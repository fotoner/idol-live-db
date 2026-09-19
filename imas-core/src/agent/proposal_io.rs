//! 投入ドラフトの書き出しと検証の実行。
//!
//! 組み立て規則は `domain::proposal`。ここは「ファイルに書く」「`tools/apply_data.py
//! --check` を動かして結果を読む」だけを持つ。検証規則を Rust に写経しない —
//! 写経すると apply 側と二重管理になり、必ず片方だけ書き換わる。

use super::Ctx;
use crate::domain::agent_tools::ToolError;
use serde_json::Value;

/// 書き込みツールを実行する (ドラフト作成 → 書き出し → --check)。
pub fn run(_ctx: &Ctx, name: &str, _args: &Value) -> Result<Value, ToolError> {
    Err(ToolError::UnknownTool(name.to_string())) // TODO(coder-c)
}
