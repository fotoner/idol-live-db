//! LLM 向けツール面の規則 (カタログと実行)。
//!
//! MCP サーバも CLI も、入口の形が違うだけで **答えの中身はここで決まる**。
//! 「どの語がどのレコードに当たるか」「何を返すか」「何件で切るか」「どう並べるか」は
//! 全部この層の判断で、アダプタ (`crate::agent`) は JSON-RPC の封を開けて
//! ここへ渡し、返った `serde_json::Value` をそのまま書き出すだけにする。
//!
//! ## 返す形の方針
//!
//! 読み手は人間ではなく LLM なので、UI 用の射影 (添字列を返して呼び手が実体化する
//! FFI の作法) は使わない。**1 回の呼び出しで、追加の往復なしに文章が書ける形**まで
//! 名前を解決して返す。id も必ず添える (次の呼び出しの手がかりになる)。
//!
//! ## 歌詞は載せない
//!
//! 歌詞本文は JASRAC の許諾が「D1 に置き、ダウンロードさせない」形で下りている。
//! ここから本文を返すとその前提を外れるので、扱うのは作品コードと掲載有無まで。

pub mod browse;
pub mod lookup;

use crate::domain::snapshot::Snapshot;
use serde_json::Value;

/// ツール 1 件の定義。MCP の `tools/list` にも CLI の `--help` にもこれを使う。
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ToolSpec {
    /// ツール名 (MCP の `name`)。スネークケース。
    pub name: String,
    /// LLM がこれを読んで選ぶ説明。いつ使うか・何が返るかを 1〜3 文で。
    pub description: String,
    /// 入力の JSON Schema (draft 2020-12) を文字列で持つ。
    pub input_schema: String,
}

/// ツール実行の失敗。アダプタはこれを MCP のエラー応答 / CLI の終了コードに写す。
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ToolError {
    /// 知らないツール名。
    UnknownTool(String),
    /// 引数が足りない / 型が違う / 値が語彙に無い。
    BadArgs(String),
    /// 指定された id のレコードが無い。
    NotFound(String),
    /// 実行時の失敗 (アダプタ側の I/O 等)。
    Failed(String),
}

impl std::fmt::Display for ToolError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::UnknownTool(s) => write!(f, "知らないツール: {s}"),
            Self::BadArgs(s) => write!(f, "引数エラー: {s}"),
            Self::NotFound(s) => write!(f, "見つからない: {s}"),
            Self::Failed(s) => write!(f, "実行失敗: {s}"),
        }
    }
}

impl std::error::Error for ToolError {}

/// 読み取りツールの一覧。並びがそのまま LLM に見える順になる。
///
/// 「まず何を引けばいいか」の順に並べる: 語をほどく `resolve` / `search` を先頭に、
/// 個別の詳細、条件での一覧、集計、最後に語彙。
pub fn tool_catalog() -> Vec<ToolSpec> {
    let mut all = lookup::catalog();
    all.extend(browse::catalog());
    all
}

/// 読み取りツールを 1 件実行する。
///
/// `today_key` は JST の「今日」(`YYYY-MM-DD`)。今後/過去の切り分けに使う。
/// 呼び手が渡すのは、テストで日付を固定できるようにするため。
pub fn call_tool(
    snap: &Snapshot,
    name: &str,
    args: &Value,
    today_key: &str,
) -> Result<Value, ToolError> {
    if let Some(r) = lookup::call(snap, name, args, today_key) {
        return r;
    }
    if let Some(r) = browse::call(snap, name, args, today_key) {
        return r;
    }
    Err(ToolError::UnknownTool(name.to_string()))
}

/// 引数の取り出し。全ツールがここを通ることで、型違いのときの文言が揃う。
///
/// LLM は数値を文字列で寄こしたり、配列を 1 個の文字列で寄こしたりする。厳格に
/// 弾くと会話が 1 往復増えるだけなので、**意味が一意に決まる寄こし方は受ける**
/// (`"12"` → 12、`"cg"` → `["cg"]`)。曖昧なものだけ `BadArgs` で返す。
pub mod args {
    use super::{ToolError, Value};

    /// 文字列。数値・真偽値が来ても綴りに直して受ける。空文字は無いものとして扱う。
    pub fn str_opt(args: &Value, key: &str) -> Option<String> {
        match args.get(key) {
            Some(Value::String(s)) if !s.trim().is_empty() => Some(s.trim().to_string()),
            Some(Value::Number(n)) => Some(n.to_string()),
            Some(Value::Bool(b)) => Some(b.to_string()),
            _ => None,
        }
    }

    /// 必須の文字列。
    pub fn str_req(args: &Value, key: &str) -> Result<String, ToolError> {
        str_opt(args, key).ok_or_else(|| ToolError::BadArgs(format!("{key} は必須です")))
    }

    /// 文字列の配列。1 個だけ文字列で来ても 1 要素の配列として受ける。
    pub fn str_list(args: &Value, key: &str) -> Vec<String> {
        match args.get(key) {
            Some(Value::Array(items)) => items
                .iter()
                .filter_map(|v| v.as_str().map(|s| s.trim().to_string()))
                .filter(|s| !s.is_empty())
                .collect(),
            Some(Value::String(s)) if !s.trim().is_empty() => vec![s.trim().to_string()],
            _ => Vec::new(),
        }
    }

    /// 上限件数。`max` を超える指定は `max` に丸める (LLM が 10000 と書いても壊れない)。
    pub fn limit(args: &Value, default: u32, max: u32) -> Result<u32, ToolError> {
        let Some(v) = args.get("limit") else { return Ok(default) };
        let n = match v {
            Value::Number(n) => n.as_u64(),
            Value::String(s) => s.trim().parse::<u64>().ok(),
            Value::Null => return Ok(default),
            _ => None,
        }
        .ok_or_else(|| ToolError::BadArgs("limit は 0 以上の整数です".into()))?;
        Ok(if n == 0 { default } else { (n as u32).min(max) })
    }

    /// 整数。文字列で来ても受ける。
    pub fn u32_opt(args: &Value, key: &str) -> Result<Option<u32>, ToolError> {
        match args.get(key) {
            None | Some(Value::Null) => Ok(None),
            Some(Value::Number(n)) => n
                .as_u64()
                .map(|n| Some(n as u32))
                .ok_or_else(|| ToolError::BadArgs(format!("{key} は整数です"))),
            Some(Value::String(s)) => s
                .trim()
                .parse::<u32>()
                .map(Some)
                .map_err(|_| ToolError::BadArgs(format!("{key} は整数です"))),
            _ => Err(ToolError::BadArgs(format!("{key} は整数です"))),
        }
    }

    /// 真偽値。`"true"` / `"1"` のような寄こし方も受ける。
    pub fn bool_or(args: &Value, key: &str, default: bool) -> bool {
        match args.get(key) {
            Some(Value::Bool(b)) => *b,
            Some(Value::String(s)) => matches!(s.trim(), "true" | "1" | "yes"),
            Some(Value::Number(n)) => n.as_u64().is_some_and(|n| n != 0),
            _ => default,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn 数値を文字列で寄こしても受ける() {
        let a = json!({"limit": "25", "month": "7"});
        assert_eq!(args::limit(&a, 20, 100).unwrap(), 25);
        assert_eq!(args::u32_opt(&a, "month").unwrap(), Some(7));
    }

    #[test]
    fn limit_は上限で丸める_0_は既定に戻す() {
        assert_eq!(args::limit(&json!({"limit": 10000}), 20, 100).unwrap(), 100);
        assert_eq!(args::limit(&json!({"limit": 0}), 20, 100).unwrap(), 20);
        assert_eq!(args::limit(&json!({}), 20, 100).unwrap(), 20);
    }

    #[test]
    fn 配列を1個の文字列で寄こしても受ける() {
        assert_eq!(args::str_list(&json!({"brands": "cg"}), "brands"), vec!["cg"]);
        assert_eq!(args::str_list(&json!({"brands": ["cg", " ml "]}), "brands"), vec!["cg", "ml"]);
        assert!(args::str_list(&json!({}), "brands").is_empty());
    }

    #[test]
    fn 知らないツール名は_unknown_tool() {
        let snap = crate::domain::snapshot::Snapshot::default();
        let err = call_tool(&snap, "存在しない", &json!({}), "2026-09-19").unwrap_err();
        assert_eq!(err, ToolError::UnknownTool("存在しない".into()));
    }
}
