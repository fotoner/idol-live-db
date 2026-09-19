//! stdio トランスポート (行区切り JSON-RPC)。MCP クライアントはこれで繋ぐ。

use super::Ctx;
use crate::domain::snapshot::Snapshot;

/// 標準入力が閉じるまで応答し続ける。
pub fn serve(_ctx: &Ctx, _snap: &Snapshot) -> std::io::Result<()> {
    Ok(()) // TODO(coder-b)
}
