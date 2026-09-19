//! データ投入ドラフトの組み立て規則。
//!
//! 新規登録は **`data/` に JSON を置くところまで**で止める。反映 (`--apply --push`) は
//! オーナーの手元にしかない鍵が要る操作で、CloudKit が source of truth なので、
//! ここから本番へ直接書く経路は作らない (`docs/DATA_PIPELINE.md`)。
//!
//! ## 出典を必須にする
//!
//! LLM は自信ありげに事実でないことを書く。`source` (一次ソースの URL) を
//! **構造として必須**にし、無ければドラフトを組まない。`data/README.md` が
//! 人間の貢献者に課しているのと同じ条件を、機械の貢献者にも課す。

use serde_json::Value;

pub use crate::domain::agent_tools::{ToolError, ToolSpec};

/// 組み上がったドラフト 1 件。ファイルには書かない (書くのはアダプタ)。
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProposalDraft {
    /// リポジトリルートからの相対パス (例: `data/songs/20260919_new_single.json`)。
    pub rel_path: String,
    /// そのまま書き出す JSON 本文 (整形済み・末尾改行あり)。
    pub contents: String,
    /// 人間とLLMに見せる要約 (「曲 3 件を追加するドラフト」など)。
    pub summary: String,
}

/// 書き込み (ドラフト作成) ツールの一覧。
pub fn proposal_catalog() -> Vec<ToolSpec> {
    Vec::new() // TODO(coder-c)
}

/// ドラフトを組む。純粋関数 — ファイルにも DB にも触らない。
pub fn build_proposal(name: &str, _args: &Value) -> Result<ProposalDraft, ToolError> {
    Err(ToolError::UnknownTool(name.to_string())) // TODO(coder-c)
}
