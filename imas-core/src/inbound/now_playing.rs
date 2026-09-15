//! 再生中バーの FFI 面。判断は domain::now_playing。
//!
//! 鳴っている 1 曲を射影で 1 回渡して、描く内容を 1 枚受け取る。

use crate::domain::now_playing::{NowPlayingBar, NowPlayingKind, NowPlayingSong};
use crate::domain::performer_label::PerformerNaming;

#[uniffi::export]
pub fn now_playing_bar(
    song: Option<NowPlayingSong>,
    kind: NowPlayingKind,
    is_playing: bool,
) -> Option<NowPlayingBar> {
    crate::domain::now_playing::now_playing_bar(song, kind, is_playing)
}

/// 曲一覧など、バー以外で名義だけ要るときの口。
///
/// 規則を画面ごとに書き直させないために出している
/// (iOS の `SongRowView` とコアで食い違っていた)。
#[uniffi::export]
pub fn performer_label(naming: PerformerNaming) -> String {
    crate::domain::performer_label::performer_label(&naming)
}
