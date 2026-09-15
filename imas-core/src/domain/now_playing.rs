//! 再生中バー (ミニプレイヤー) に何を出すか。
//!
//! # 何がここの持ち物か
//!
//! 音を鳴らすのは OS SDK (iOS は `AVPlayer` / `ApplicationMusicPlayer`) なので各 OS。
//! **鳴っているものをどう見せるかの判断はここ** — バーを出すのか、題と名義に何を置くのか、
//! 試聴とフル尺をどう書き分けるのか。iOS と Android で別々に書くと、
//! `color_match.rs` 冒頭に残っている二重管理の事故を繰り返す。
//!
//! # 曲名では引き当てない
//!
//! 入口を `song_id` にしてあるのは、**同名で別録音の曲が実在する**ため。
//! 「私はアイドル♡ (M@STER VERSION)」は歌唱者の違う 2 録音があり、
//! 曲名で突き合わせると別バージョンのジャケと名義が出る。
//! iOS の `MusicKitService` は長らく `nowPlayingTitle: String?` で同一性を見ていた。

use crate::domain::performer_label::{performer_label, PerformerNaming};

/// 鳴らし方。
#[derive(uniffi::Enum, Clone, Copy, Debug, PartialEq, Eq)]
pub enum NowPlayingKind {
    /// 30 秒試聴 (`songs.preview_url`)。**勝手に終わる**ので、その旨を出す。
    /// 黙って止まると「なぜか止まった」に見える。
    Preview,
    /// フル尺 (Apple Music のカタログ再生)。最後まで鳴る。
    Full,
}

/// 鳴っている 1 曲の射影。
///
/// 曲ごとに FFI を往復させないため、OS 側で 1 回詰めて渡す
/// (docs/ARCHITECTURE.md の「1 操作 = 1 FFI 呼び出し」)。
#[derive(uniffi::Record, Clone, Debug)]
pub struct NowPlayingSong {
    pub song_id: String,
    pub title: String,
    /// 名義の材料。組み立ては [`performer_label`] が唯一の出どころ。
    pub naming: PerformerNaming,
    pub artwork_url: Option<String>,
}

/// バーに出す 1 枚ぶん。これをそのまま描く。
///
/// OS 側に `if` を持たせないため、**出す文字はすべてここで確定させる**。
#[derive(uniffi::Record, Clone, Debug, PartialEq)]
pub struct NowPlayingBar {
    /// タップしたときに開く曲。
    pub song_id: String,
    /// 1 行目。
    pub title: String,
    /// 2 行目。名義。出せるものが無ければ空文字 (その場合 OS 側は行を描かない)。
    pub subtitle: String,
    pub artwork_url: Option<String>,
    /// 再生ボタンの向き。false なら「再生」、true なら「一時停止」を出す。
    pub is_playing: bool,
    /// 試聴中か。バーの見た目は変えず、印を 1 つ足すだけに使う。
    pub is_preview: bool,
}

/// 試聴中であることを名義に添える語。
///
/// 2 行目に混ぜるのは、Apple Music と同じ「ジャケ + 2 行 + ボタン」の形を崩さずに
/// 「これは 30 秒で終わる」を伝えられる唯一の場所だから。バッジを足すと形が変わる。
const PREVIEW_SUFFIX: &str = "試聴";

/// 名義と試聴の印をつないで 2 行目にする。
const SUBTITLE_SEPARATOR: &str = " · ";

/// バーに出す内容。鳴っていなければ `None` = バーごと出さない。
///
/// 「止めたら消す」ではなく **「鳴らすものが無ければ消す」**。一時停止では
/// `song` が残るのでバーも残り、再生ボタンだけが向きを変える (Apple Music と同じ)。
pub fn now_playing_bar(
    song: Option<NowPlayingSong>,
    kind: NowPlayingKind,
    is_playing: bool,
) -> Option<NowPlayingBar> {
    let song = song?;
    let is_preview = kind == NowPlayingKind::Preview;
    let label = performer_label(&song.naming);

    let subtitle = match (label.is_empty(), is_preview) {
        (true, true) => PREVIEW_SUFFIX.to_string(),
        (true, false) => String::new(),
        (false, true) => format!("{label}{SUBTITLE_SEPARATOR}{PREVIEW_SUFFIX}"),
        (false, false) => label,
    };

    Some(NowPlayingBar {
        song_id: song.song_id,
        title: song.title,
        subtitle,
        artwork_url: song.artwork_url.filter(|u| !u.trim().is_empty()),
        is_playing,
        is_preview,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn song(title: &str, unit: Option<&str>, performers: &[&str]) -> NowPlayingSong {
        NowPlayingSong {
            song_id: "sc_take_ur_time".to_string(),
            title: title.to_string(),
            naming: PerformerNaming {
                unit_name: unit.map(str::to_string),
                singer_label: None,
                performer_names: performers.iter().map(|s| s.to_string()).collect(),
            },
            artwork_url: Some("https://example.invalid/600x600bb.jpg".to_string()),
        }
    }

    #[test]
    fn nothing_playing_means_no_bar() {
        assert!(now_playing_bar(None, NowPlayingKind::Full, true).is_none());
    }

    #[test]
    fn full_playback_shows_naming_only() {
        let bar = now_playing_bar(
            Some(song("Take Ur Time", None, &["八宮めぐる"])),
            NowPlayingKind::Full,
            true,
        )
        .unwrap();
        assert_eq!(bar.title, "Take Ur Time");
        assert_eq!(bar.subtitle, "八宮めぐる");
        assert!(!bar.is_preview);
        assert!(bar.is_playing);
    }

    /// 試聴は黙って終わるので、必ず 2 行目に印が出る。
    #[test]
    fn preview_is_marked_in_subtitle() {
        let bar = now_playing_bar(
            Some(song("Take Ur Time", None, &["八宮めぐる"])),
            NowPlayingKind::Preview,
            true,
        )
        .unwrap();
        assert_eq!(bar.subtitle, "八宮めぐる · 試聴");
        assert!(bar.is_preview);
    }

    /// 名義が無い曲でも、試聴の印だけは出す (区切りが先頭に出ない)。
    #[test]
    fn preview_without_naming_shows_only_the_mark() {
        let bar = now_playing_bar(
            Some(song("名義なしの曲", None, &[])),
            NowPlayingKind::Preview,
            true,
        )
        .unwrap();
        assert_eq!(bar.subtitle, "試聴");
    }

    #[test]
    fn nothing_to_show_leaves_subtitle_empty() {
        let bar = now_playing_bar(
            Some(song("名義なしの曲", None, &[])),
            NowPlayingKind::Full,
            true,
        )
        .unwrap();
        assert_eq!(bar.subtitle, "");
    }

    /// 一時停止でもバーは残る。消えるのは鳴らすものが無くなったときだけ。
    #[test]
    fn paused_keeps_the_bar() {
        let bar = now_playing_bar(
            Some(song("Take Ur Time", None, &["八宮めぐる"])),
            NowPlayingKind::Full,
            false,
        )
        .unwrap();
        assert!(!bar.is_playing);
    }

    #[test]
    fn unit_name_is_used_for_unit_songs() {
        let bar = now_playing_bar(
            Some(song("SOLAR WAY -10 colors-", Some("Team.Sol"), &["八宮めぐる"])),
            NowPlayingKind::Full,
            true,
        )
        .unwrap();
        assert_eq!(bar.subtitle, "Team.Sol");
    }

    /// 空のジャケ URL はキーごと無かったことにする。OS 側で
    /// 「空文字の URL」を掴ませると、壊れた画像枠が出る。
    #[test]
    fn blank_artwork_url_becomes_none() {
        let mut s = song("Take Ur Time", None, &["八宮めぐる"]);
        s.artwork_url = Some("   ".to_string());
        let bar = now_playing_bar(Some(s), NowPlayingKind::Full, true).unwrap();
        assert!(bar.artwork_url.is_none());
    }

    /// タップで開く先は必ず id で返す。曲名で引き当てさせない。
    #[test]
    fn bar_carries_the_song_id() {
        let bar = now_playing_bar(
            Some(song("私はアイドル♡ (M@STER VERSION)", None, &["水瀬伊織"])),
            NowPlayingKind::Full,
            true,
        )
        .unwrap();
        assert_eq!(bar.song_id, "sc_take_ur_time");
    }
}
