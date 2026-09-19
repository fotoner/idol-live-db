//! MCP (Model Context Protocol) の JSON-RPC 2.0 面。
//!
//! 扱うのは `initialize` / `tools/list` / `tools/call` / `ping` と、通知
//! (`notifications/initialized`) だけ。トランスポート (stdio / HTTP) は呼び手が持つ。

use super::Ctx;
use crate::domain::snapshot::Snapshot;
use serde_json::Value;

/// リクエスト 1 件を処理して応答を返す。通知 (id 無し) には `None`。
pub fn handle(_ctx: &Ctx, _snap: &Snapshot, _request: &Value) -> Option<Value> {
    None // TODO(coder-b)
}
