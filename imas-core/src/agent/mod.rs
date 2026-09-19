//! Driving adapter: LLM (MCP クライアント / 人の手) からの入口。
//!
//! ## この層の責務 (これ以外を書かない)
//!
//! `web_export` と同じ立ち位置で、やってよいのは 3 つだけ:
//!
//! 1. 入力 (JSON-RPC の封 / argv) をほどく
//! 2. `domain::agent_tools` / `domain::proposal` を呼ぶ
//! 3. 返った値を書き出す (stdout / ファイル)
//!
//! 「どのレコードを返すか」「何件で切るか」「どの語が当たるか」をここで決めてはいけない。
//! 判断が要るものは domain に `pub fn` を足してから呼ぶ。
//!
//! ## `#[uniffi::export]` は足さない
//!
//! FFI 面 (`tests/ffi_surface.rs` の一覧) は不変。このモジュールは既定 off の
//! feature = "agent" でしかコンパイルされず、iOS/Android のバインディングには現れない。

pub mod cli;
pub mod mcp;
pub mod proposal_io;
pub mod stdio;

use crate::domain::agent_tools::{self, ToolError, ToolSpec};
use crate::domain::proposal;
use crate::domain::snapshot::Snapshot;
use serde_json::Value;
use std::path::PathBuf;

/// 1 プロセスぶんの実行文脈。
pub struct Ctx {
    /// 読む master.sqlite。
    pub db_path: PathBuf,
    /// リポジトリルート。ドラフトの書き出し先と `tools/apply_data.py` の基準。
    pub repo_root: PathBuf,
    /// JST の「今日」(`YYYY-MM-DD`)。今後/過去の切り分けに使う。
    pub today_key: String,
    /// 書き込み (ドラフト作成) ツールを出すか。リモート公開時は false。
    pub allow_write: bool,
}

/// 出せるツールの一覧 (読み取り + 書き込み)。
pub fn catalog(ctx: &Ctx) -> Vec<ToolSpec> {
    let mut all = agent_tools::tool_catalog();
    if ctx.allow_write {
        all.extend(proposal::proposal_catalog());
    }
    all
}

/// ツール名で読み取り / 書き込みを振り分けて実行する。
pub fn dispatch(ctx: &Ctx, snap: &Snapshot, name: &str, args: &Value) -> Result<Value, ToolError> {
    let is_write = proposal::proposal_catalog().iter().any(|t| t.name == name);
    if is_write {
        if !ctx.allow_write {
            return Err(ToolError::UnknownTool(name.to_string()));
        }
        return proposal_io::run(ctx, name, args);
    }
    agent_tools::call_tool(snap, name, args, &ctx.today_key)
}
