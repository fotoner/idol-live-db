//! 「この曲は誰の曲か」を 1 行で出すときの名義。
//!
//! # なぜ切り出すか
//!
//! 同じ規則が **iOS の曲一覧 (`SongRowView.displayLabel`) とコアの
//! `mastery::group_key` の 2 か所に手写経されていて、しかも食い違っていた**。
//! 一覧は `singer_label` を見ずに括弧の前を抜き、群分けは括弧を見ずに
//! `singer_label` を見る。同じ曲が画面によって違う名義で出る。
//!
//! 名義の決め方は OS SDK に触らずに書ける = コアの持ち物
//! (docs/ARCHITECTURE.md)。ここへ寄せていく。
//!
//! **まだ移せていないもの**: `SongRowView.displayLabel` は `singer_label` の
//! 括弧の前を抜く段 (`"MILLIONSTARS（…）"` → `"MILLIONSTARS"`) を持っていて、
//! ここには無い。取り込むと `mastery` の Unit 群も括弧違いが 1 群に畳まれる
//! (群キーは永続化していないので移行は不要、見え方だけ変わる)。
//! どちらに揃えるか決めてから移す。それまでは規則が 2 つある。
//!
//! # 決め方
//!
//! `unit_name` → `singer_label` → 原唱者の連結、の順に落ちる。
//! 空文字は「値が無い」として扱う (DB には `''` と `NULL` が混在している)。

use crate::domain::display_join::non_empty;

/// 名義を組むのに要るぶんだけの射影。
///
/// 曲そのもの (`snapshot::Song`) を渡さないのは、原唱者名が曲の外
/// (`song_artists` → `idols`) にあるため。呼ぶ側で 1 回詰めて渡す。
#[derive(uniffi::Record, Clone, Debug)]
pub struct PerformerNaming {
    /// DB の `songs.unit_name`。ユニット名義ならここに入っている。
    pub unit_name: Option<String>,
    /// DB の `songs.singer_label`。個人名を併記する名義 (`天道輝、若里春名、…`)。
    pub singer_label: Option<String>,
    /// 原唱者 (`song_artists.role='original'`) の表示名。上 2 つが空のときだけ使う。
    pub performer_names: Vec<String>,
}

/// 原唱者を並べるときの区切り。
///
/// [`crate::domain::display_join::PARTS_SEPARATOR`] (` ・ `) と違って前後に空白を置かない。
/// あちらは種類の違う項目 (名義・年・シリーズ) を並べる区切りで、こちらは
/// **同じ種類のものの列挙**。iOS の既存表示 (`SongRowView`) も詰めた中黒なので揃える。
const PERFORMER_SEPARATOR: &str = "・";

/// 1 行で出す名義。出せるものが何も無ければ `None`。
///
/// `None` を返すのは、呼ぶ側に「行ごと出さない」を素直に書かせるため
/// ([`crate::domain::display_join::join_parts`] と同じ約束)。ここで「不明」のような
/// 文字を置くと、画面ごとに違う言い方が増える。
pub fn performer_label(naming: &PerformerNaming) -> Option<String> {
    if let Some(unit) = non_empty(&naming.unit_name) {
        return Some(unit.to_string());
    }
    if let Some(label) = non_empty(&naming.singer_label) {
        return Some(label.to_string());
    }
    let mut out = String::new();
    for name in naming.performer_names.iter().map(|n| n.trim()) {
        if name.is_empty() {
            continue;
        }
        if !out.is_empty() {
            out.push_str(PERFORMER_SEPARATOR);
        }
        out.push_str(name);
    }
    (!out.is_empty()).then_some(out)
}

/// スナップショットの曲 1 行から名義を組む。
///
/// 射影 ([`PerformerNaming`]) を呼ぶ側で詰めると、**「原唱者は `role='original'` だけ」**
/// という一段が呼ぶ側の数だけ写される。実際に LLM 向けツールの 2 ファイルが
/// それぞれ `artists_by_song` を `role == "original"` で濾していた。
/// 詰め方ごとここに置いて、呼ぶ側は曲の添字を渡すだけにする。
pub fn song_performer_label(
    snap: &crate::domain::snapshot::Snapshot,
    song: u32,
) -> Option<String> {
    let s = &snap.songs[song as usize];
    performer_label(&PerformerNaming {
        unit_name: s.unit_name.clone(),
        singer_label: s.singer_label.clone(),
        performer_names: snap
            .song_artists(&s.id, Some("original"))
            .iter()
            .map(|idol| idol.name.clone())
            .collect(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn naming(unit: Option<&str>, singer: Option<&str>, performers: &[&str]) -> PerformerNaming {
        PerformerNaming {
            unit_name: unit.map(str::to_string),
            singer_label: singer.map(str::to_string),
            performer_names: performers.iter().map(|s| s.to_string()).collect(),
        }
    }

    #[test]
    fn unit_name_wins() {
        let n = naming(Some("Team.Sol"), Some("八宮めぐる、白瀬咲耶"), &["八宮めぐる"]);
        assert_eq!(performer_label(&n).as_deref(), Some("Team.Sol"));
    }

    #[test]
    fn falls_back_to_singer_label() {
        let n = naming(None, Some("天道輝、若里春名、水嶋咲"), &["天道輝"]);
        assert_eq!(performer_label(&n).as_deref(), Some("天道輝、若里春名、水嶋咲"));
    }

    #[test]
    fn falls_back_to_performers() {
        let n = naming(None, None, &["赤城みりあ", "市原仁奈", "椎名法子"]);
        assert_eq!(
            performer_label(&n).as_deref(),
            Some("赤城みりあ・市原仁奈・椎名法子")
        );
    }

    /// DB には `NULL` と `''` が混ざっている。空文字で止まると
    /// 名義が空のまま出て、原唱者まで落ちない。
    #[test]
    fn empty_string_is_not_a_value() {
        let n = naming(Some(""), Some("   "), &["櫻木真乃"]);
        assert_eq!(performer_label(&n).as_deref(), Some("櫻木真乃"));
    }

    #[test]
    fn nothing_to_show_is_none() {
        assert_eq!(performer_label(&naming(None, None, &[])), None);
    }

    /// 原唱者の配列に空が混ざっても区切りだけが並ばない。
    #[test]
    fn blank_performers_are_dropped() {
        let n = naming(None, None, &["浅倉透", "", "  ", "市川雛菜"]);
        assert_eq!(performer_label(&n).as_deref(), Some("浅倉透・市川雛菜"));
    }

    /// ソロ曲は 1 人なので区切りが出ない。
    #[test]
    fn single_performer_has_no_separator() {
        let n = naming(None, None, &["園田智代子"]);
        assert_eq!(performer_label(&n).as_deref(), Some("園田智代子"));
    }
}
