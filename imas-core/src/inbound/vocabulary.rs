//! 画面に出す語彙の FFI 面。ロジック (表) は [`crate::domain::vocabulary`]。
//!
//! アプリは起動時に 1 回引いて、生値 → 語の表として持っておく (行ごとに呼ばない)。

use crate::domain::vocabulary::{self as domain, Vocabulary};

/// 語彙の一式 (曲種別・催しの種別と性格・参加形態・チケットの日程・タグのカテゴリ)。
/// 各語は短い形 (`short_label`) と正式な形 (`label`) を持つ。
#[uniffi::export]
pub fn vocabulary() -> Vocabulary {
    domain::vocabulary()
}
