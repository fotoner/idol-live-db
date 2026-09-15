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
//! (docs/ARCHITECTURE.md)。ここを唯一の出どころにする。
//!
//! # 決め方
//!
//! `unit_name` → `singer_label` → 原唱者の連結、の順に落ちる。
//! 空文字は「値が無い」として扱う (DB には `''` と `NULL` が混在している)。

/// 名義を組むのに要るぶんだけの射影。
///
/// 曲そのもの (`snapshot::Song`) を渡さないのは、原唱者名が曲の外
/// (`song_artists` → `idols`) にあるため。OS 側で 1 回詰めて渡す。
#[derive(uniffi::Record, Clone, Debug, Default, PartialEq)]
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
/// `singer_label` 側の区切りが `、` なのと揃っていないが、こちらは
/// **DB の文字列をそのまま出す** のに対して、原唱者は名前の配列から
/// こちらが組む。既存の一覧表示が `・` なので合わせる。
const PERFORMER_SEPARATOR: &str = "・";

/// 値として扱える文字列だけを返す。空文字と空白だけの値は無かったことにする。
fn non_empty(v: &Option<String>) -> Option<&str> {
    v.as_deref().map(str::trim).filter(|s| !s.is_empty())
}

/// 1 行で出す名義。出せるものが何も無ければ空文字。
///
/// 空文字を返すのは、呼ぶ側に「行ごと出さない」判断をさせるため。
/// ここで「不明」のような文字を置くと、画面ごとに違う言い方が増える。
pub fn performer_label(naming: &PerformerNaming) -> String {
    if let Some(unit) = non_empty(&naming.unit_name) {
        return unit.to_string();
    }
    if let Some(label) = non_empty(&naming.singer_label) {
        return label.to_string();
    }
    naming
        .performer_names
        .iter()
        .map(|n| n.trim())
        .filter(|n| !n.is_empty())
        .collect::<Vec<_>>()
        .join(PERFORMER_SEPARATOR)
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
        assert_eq!(performer_label(&n), "Team.Sol");
    }

    #[test]
    fn falls_back_to_singer_label() {
        let n = naming(None, Some("天道輝、若里春名、水嶋咲"), &["天道輝"]);
        assert_eq!(performer_label(&n), "天道輝、若里春名、水嶋咲");
    }

    #[test]
    fn falls_back_to_performers() {
        let n = naming(None, None, &["赤城みりあ", "市原仁奈", "椎名法子"]);
        assert_eq!(performer_label(&n), "赤城みりあ・市原仁奈・椎名法子");
    }

    /// DB には `NULL` と `''` が混ざっている。空文字で止まると
    /// 名義が空のまま出て、原唱者まで落ちない。
    #[test]
    fn empty_string_is_not_a_value() {
        let n = naming(Some(""), Some("   "), &["櫻木真乃"]);
        assert_eq!(performer_label(&n), "櫻木真乃");
    }

    #[test]
    fn nothing_to_show_is_empty() {
        assert_eq!(performer_label(&naming(None, None, &[])), "");
    }

    /// 原唱者の配列に空が混ざっても区切りだけが並ばない。
    #[test]
    fn blank_performers_are_dropped() {
        let n = naming(None, None, &["浅倉透", "", "  ", "市川雛菜"]);
        assert_eq!(performer_label(&n), "浅倉透・市川雛菜");
    }

    /// ソロ曲は 1 人なので区切りが出ない。
    #[test]
    fn single_performer_has_no_separator() {
        let n = naming(None, None, &["園田智代子"]);
        assert_eq!(performer_label(&n), "園田智代子");
    }
}
