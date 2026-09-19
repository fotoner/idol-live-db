//! 語をほどく / 1 件の詳細を引くツール群 (resolve・search・get_*・vocabulary)。
//!
//! 規約 (`super` の注記も読むこと):
//! - 1 ツール = 1 `pub fn`。引数の取り出しは `super::args` の補助に寄せる。
//! - 返す JSON は「追加の往復なしに文章が書ける」形まで名前を解決する。id も必ず添える。
//! - 件数は既定の上限を持たせ、打ち切ったことが分かるように `truncated` を返す。

use super::{ToolError, ToolSpec};
use crate::domain::snapshot::Snapshot;
use serde_json::Value;

/// このファイルが持つツールの定義。
pub fn catalog() -> Vec<ToolSpec> {
    Vec::new() // TODO(coder-a1)
}

/// 自分の持ちツールなら `Some(結果)`、違うなら `None` (呼び手が次を試す)。
pub fn call(
    _snap: &Snapshot,
    _name: &str,
    _args: &Value,
    _today_key: &str,
) -> Option<Result<Value, ToolError>> {
    None // TODO(coder-a1)
}
