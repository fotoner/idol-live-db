//! CLI 面。MCP と同じツールを人の手から叩けるようにする (デバッグと単体確認用)。

use super::Ctx;
use crate::domain::agent_tools::ToolError;
use crate::domain::snapshot::Snapshot;

/// `imas-mcp <tool> [--json '{...}'] [--key value ...]` を 1 回実行して stdout に書く。
pub fn run(_ctx: &Ctx, _snap: &Snapshot, _argv: &[String]) -> Result<(), ToolError> {
    Ok(()) // TODO(coder-b)
}
