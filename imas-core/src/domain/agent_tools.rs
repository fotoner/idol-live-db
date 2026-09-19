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
pub fn tool_catalog() -> Vec<ToolSpec> {
    Vec::new() // TODO(coder-a): 読み取りツール群
}

/// 読み取りツールを 1 件実行する。
///
/// `today_key` は JST の「今日」(`YYYY-MM-DD`)。今後/過去の切り分けに使う。
/// 呼び手が渡すのは、テストで日付を固定できるようにするため。
pub fn call_tool(
    _snap: &Snapshot,
    name: &str,
    _args: &Value,
    _today_key: &str,
) -> Result<Value, ToolError> {
    Err(ToolError::UnknownTool(name.to_string())) // TODO(coder-a)
}
