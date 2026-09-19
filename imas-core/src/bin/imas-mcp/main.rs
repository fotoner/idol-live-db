//! アイドルライブ DB を LLM から引くための MCP サーバ / CLI。
//!
//! 本体は `imas_core::agent`。ここは引数を読んで呼ぶだけにしてある
//! (ロジックを bin に置くとテストから触れないため)。
//!
//! ```text
//! cargo run --release --features agent --bin imas-mcp -- --stdio
//! cargo run --release --features agent --bin imas-mcp -- search --json '{"query":"春日未来"}'
//! ```
//!
//! 終了コード: 0=成功 / 1=引数エラー / 2=DB エラー / 3=ツール実行エラー。

fn main() {
    std::process::exit(1); // TODO(coder-b)
}
