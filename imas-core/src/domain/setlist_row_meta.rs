//! セトリ 1 行に添える「名義」と「いつぶりか」を、公演ぶんまとめて組む。
//!
//! 規則そのものは別のところにある — ここはそれを公演の行に当てはめるだけ:
//!
//! - 名義の落ちる順 … [`crate::domain::performer_label::setlist_performer_label`]
//! - 顔ぶれからのユニット逆引き … [`crate::domain::unit_queries::exact_matching_units`]
//! - 出演者全員か … [`crate::domain::setlist_lineup::is_full_cast`]
//! - 何回目・いつぶり … [`crate::domain::performance_gap`]
//!
//! # なぜ 1 公演ぶんまとめて返すか
//!
//! 行ごとに FFI を呼ぶと、35 曲のセトリで 35 往復になる。しかも「その公演で
//! ユニット単独曲として披露されたユニット」(下の [`active_units`]) は公演全体を
//! 見ないと決まらないので、行ごとの API では毎回作り直すことになる。
//! 1 操作 = 1 呼び出し (docs/ARCHITECTURE.md)。

use crate::domain::event_detail_queries::{
    self as detail, PerformerNameMode, SetlistPerformerRecord,
};
use crate::domain::performance_gap::performance_gap;
use crate::domain::performer_label::{setlist_performer_label, SetlistNaming};
use crate::domain::screen_composition::{setlist_history_badges, SetlistDisplayMode};
use crate::domain::setlist_lineup::is_full_cast;
use crate::domain::snapshot::Snapshot;
use crate::domain::unit_queries::exact_matching_unit_names;
use std::collections::{BTreeSet, HashSet};

/// セトリ 1 行ぶんの添え物。行そのもの (`SetlistEntryRecord`) と同じ並びで返る。
#[derive(uniffi::Record, Clone, Debug, PartialEq, Eq)]
pub struct SetlistRowMetaRecord {
    /// `setlist_items.id`。行と突き合わせるための鍵。
    pub item_id: String,
    /// 1 行で出す名義。出せるものが何も無ければ `None` (行ごと出さない)。
    pub performer_label: Option<String>,
    /// ユニット名のチップに出す名前。空ならチップを出さない。
    pub unit_names: Vec<String>,
    /// 出演者全員で歌う行 (`全員` のチップ)。
    pub is_full_cast: bool,
    /// 通算何回目か (1 = 初披露)。
    pub ordinal: u32,
    /// `初披露` / `4 回目`。
    pub ordinal_label: String,
    pub is_first_performance: bool,
    /// その公演時点での前回の披露日 (`YYYY-MM-DD`)。初披露なら `None`。
    pub previous_date: Option<String>,
    /// `3 年 10 か月ぶり`。1 年に満たない間隔と初披露では `None`。
    pub since_label: Option<String>,
    /// **行に出す披露履歴の札**(詳細表示のときだけ中身が入る)。
    ///
    /// 上の 4 つ (`ordinal` / `ordinal_label` / `previous_date` / `since_label`) は
    /// 生の事実で、そこから「どのモードでどれを出すか」を決めた結果がこれ。
    /// **画面はこれを並べるだけにする** — モードを見て出し分ける条件を
    /// Swift / Kotlin に書くと、同じ条件が 2 か所に増える
    /// (`crate::domain::screen_composition::setlist_history_badges`)。
    pub history_badges: Vec<String>,
}

/// その公演で「ユニット単独曲」として披露されたユニット (スナップショット添字)。
///
/// 顔ぶれ逆引きの門。これが無いと、偶然メンバーが揃った全体曲にユニット名が付く
/// (`TintMe!` が出てしまう類の誤検出)。**単独一致だけ**を数える — 合同曲で
/// 立った和集合を門に入れると、門の意味がなくなる。
fn active_units(snap: &Snapshot, show: u32) -> HashSet<u32> {
    let members: Vec<HashSet<u32>> = snap
        .members_by_unit
        .iter()
        .map(|m| m.iter().copied().collect())
        .collect();
    let mut active = HashSet::new();
    for &item in &snap.setlist_items_by_show[show as usize] {
        let performers: HashSet<u32> =
            snap.performers_by_item[item as usize].iter().copied().collect();
        if performers.len() < 2 {
            continue;
        }
        for (ui, unit) in members.iter().enumerate() {
            if unit.len() >= 2 && *unit == performers {
                active.insert(ui as u32);
            }
        }
    }
    active
}

/// 公演のセトリ行ぜんぶぶんの添え物 (`setlist_items_by_show` = position 昇順)。
/// 未知の show_id は空。
pub fn setlist_row_meta(
    snap: &Snapshot,
    show_id: &str,
    mode: PerformerNameMode,
    display_mode: SetlistDisplayMode,
) -> Vec<SetlistRowMetaRecord> {
    let Some(&show) = snap.show_index_by_id.get(show_id) else { return vec![] };
    let is_character_live =
        detail::is_character_live(snap.shows[show as usize].performer_type.as_deref());
    let cast_ids = detail::show_cast_idol_ids(snap, show_id);
    let cast: BTreeSet<&str> = cast_ids.iter().map(String::as_str).collect();
    let active = active_units(snap, show);
    let performers_by_item = detail::setlist_performers_by_item(snap, show_id);

    snap.setlist_items_by_show[show as usize]
        .iter()
        .map(|&item| {
            let row = &snap.setlist_items[item as usize];
            let song = &snap.songs[row.song as usize];
            let empty: Vec<SetlistPerformerRecord> = Vec::new();
            let performers = performers_by_item.get(&row.id).unwrap_or(&empty);
            let performer_ids: BTreeSet<&str> =
                performers.iter().map(|p| p.idol_id.as_str()).collect();
            let performer_indices: HashSet<u32> =
                snap.performers_by_item[item as usize].iter().copied().collect();
            let full_cast = is_full_cast(&cast, &performer_ids);

            let label = setlist_performer_label(&SetlistNaming {
                item_unit_name: row.unit_name.clone(),
                song_unit_name: song.unit_name.clone(),
                singer_label: song.singer_label.clone(),
                lineup_unit_names: exact_matching_unit_names(snap, &performer_indices, &active),
                has_original_artists: !snap.song_artists(&song.id, Some("original")).is_empty(),
                is_full_cast: full_cast,
                performer_names: performers
                    .iter()
                    .map(|p| detail::performer_display_name(p, mode, is_character_live).joined())
                    .collect(),
            });
            let gap = performance_gap(snap, item);
            let history_badges = setlist_history_badges(
                display_mode,
                gap.is_first,
                &gap.ordinal_label,
                gap.since_label.as_deref(),
            );

            SetlistRowMetaRecord {
                item_id: row.id.clone(),
                performer_label: label.as_ref().map(|l| l.text.clone()),
                unit_names: label.map(|l| l.unit_names).unwrap_or_default(),
                is_full_cast: full_cast,
                ordinal: gap.ordinal,
                ordinal_label: gap.ordinal_label,
                is_first_performance: gap.is_first,
                previous_date: gap.previous_date,
                history_badges,
                since_label: gap.since_label,
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::OnceLock;

    fn snap() -> &'static Snapshot {
        static SNAP: OnceLock<Snapshot> = OnceLock::new();
        SNAP.get_or_init(|| {
            crate::outbound::sqlite_loader::load_snapshot(&format!(
                "{}/../ImasLiveDB/Resources/master.sqlite",
                env!("CARGO_MANIFEST_DIR")
            ))
            .expect("bundle DB はロードできる")
        })
    }

    fn meta_of(song_id: &str, date: &str) -> SetlistRowMetaRecord {
        let snap = snap();
        let si = snap.song_index_by_id[song_id];
        let item = snap.setlist_items_by_song[si as usize]
            .iter()
            .copied()
            .find(|&i| snap.shows[snap.setlist_items[i as usize].show as usize].date == date)
            .unwrap_or_else(|| panic!("{song_id} の {date} の披露"));
        let show = &snap.shows[snap.setlist_items[item as usize].show as usize];
        let item_id = snap.setlist_items[item as usize].id.clone();
        setlist_row_meta(snap, &show.id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed)
            .into_iter()
            .find(|m| m.item_id == item_id)
            .expect("行は返る")
    }

    /// 依頼の実例。エミリー スチュアートと徳川まつりの 2 人が歌うが、
    /// **Charlotte・Charlotte の曲ではない**ので、顔ぶれが一致してもユニット名を出さない。
    ///
    /// 2026-09-20 の配信開始で `singer_label` に公式クレジット
    /// (「徳川まつり、エミリー スチュアート」) が入ったため、名義はそちらが勝つ。
    /// **このテストが見張っているのは綴りではなく「ユニット名に化けないこと」**なので、
    /// 期待値の更新で趣旨は変わらない。配信前は歌唱者名の連結が出ていた。
    #[test]
    fn パルティシオンは_ユニット名義にならない() {
        let meta = meta_of("ml_パルティシオン", "2026-09-19");
        assert_eq!(
            meta.performer_label.as_deref(),
            Some("徳川まつり、エミリー スチュアート")
        );
        assert!(meta.unit_names.is_empty(), "ユニットのチップを出さない");
        assert!(meta.is_first_performance, "14thLIVE DAY1 が初披露");
    }

    /// 同じ 2 人でも、`unit_id` を持つ本物のユニット曲はユニット名で出る。
    #[test]
    fn 同じ_2_人の本物のユニット曲はユニット名で出る() {
        let snap = snap();
        let si = snap.song_index_by_id["ml_だってあなたはプリンセス"];
        assert_eq!(
            snap.songs[si as usize].unit_name.as_deref(),
            Some("Charlotte・Charlotte"),
            "この曲は名義を持っている前提のテスト"
        );
    }

    /// 回帰: 顔ぶれ推論が曲の名義を上書きしていた行が、曲の綴りで出る。
    #[test]
    fn 曲の名義の綴りが顔ぶれ側の綴りに負けない() {
        let snap = snap();
        let mut checked = 0usize;
        for show in 0..snap.shows.len() as u32 {
            if snap.setlist_items_by_show[show as usize].is_empty() {
                continue;
            }
            let show_id = &snap.shows[show as usize].id;
            let metas = setlist_row_meta(snap, show_id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
            for (&item, meta) in snap.setlist_items_by_show[show as usize].iter().zip(&metas) {
                let row = &snap.setlist_items[item as usize];
                let song = &snap.songs[row.song as usize];
                let credit = row
                    .unit_name
                    .as_deref()
                    .filter(|s| !s.trim().is_empty())
                    .or(song.unit_name.as_deref().filter(|s| !s.trim().is_empty()));
                let Some(credit) = credit else { continue };
                assert_eq!(meta.performer_label.as_deref(), Some(credit), "{}", row.id);
                checked += 1;
            }
        }
        assert!(checked > 2000, "名義を持つ行が少なすぎる: {checked}");
    }

    /// 名義を持たない行でも、名義の材料が何も無いときだけ推論が出る。
    /// 実データで推論が残るのは一握り (原唱者すら記録の無い曲)。
    #[test]
    fn 推論で名義が出る行はごく少数に絞られる() {
        let snap = snap();
        let mut inferred = 0usize;
        for show in 0..snap.shows.len() as u32 {
            let show_id = &snap.shows[show as usize].id;
            for (&item, meta) in snap.setlist_items_by_show[show as usize]
                .iter()
                .zip(setlist_row_meta(snap, show_id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed))
            {
                let row = &snap.setlist_items[item as usize];
                let song = &snap.songs[row.song as usize];
                let has_credit = [
                    row.unit_name.as_deref(),
                    song.unit_name.as_deref(),
                    song.singer_label.as_deref(),
                ]
                .into_iter()
                .flatten()
                .any(|s| !s.trim().is_empty());
                if !has_credit && !meta.unit_names.is_empty() {
                    inferred += 1;
                    assert!(
                        snap.song_artists(&song.id, Some("original")).is_empty(),
                        "原唱者が分かっている {} で推論している",
                        song.id
                    );
                }
            }
        }
        assert!(inferred < 50, "推論で出る行が多すぎる: {inferred}");
    }

    /// 札が出るのは詳細表示だけ。普通表示・シンプル表示では 1 行も札を持たない。
    #[test]
    fn 札は詳細表示でだけ出る() {
        let snap = snap();
        let show = &snap.shows[snap.setlist_items[snap.song_index_by_id
            .get("765as_初恋_一章_片想いの桜")
            .map(|&si| snap.setlist_items_by_song[si as usize][0])
            .expect("初恋には披露がある") as usize]
            .show as usize]
            .id;
        for quiet in [SetlistDisplayMode::Simple, SetlistDisplayMode::Normal] {
            let metas = setlist_row_meta(snap, show, PerformerNameMode::IdolOnly, quiet);
            assert!(!metas.is_empty());
            assert!(
                metas.iter().all(|m| m.history_badges.is_empty()),
                "{quiet:?} で札が出ている"
            );
        }
        let detailed =
            setlist_row_meta(snap, show, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
        assert!(
            detailed.iter().all(|m| !m.history_badges.is_empty()),
            "詳細表示では全行が何かしらの札を持つ (初披露 か N 回目)"
        );
        // 初披露の行は「初披露」1 つだけ (「1 回目」を並べない)。
        for m in &detailed {
            if m.is_first_performance {
                assert_eq!(m.history_badges, vec!["初披露".to_string()]);
            }
        }
    }

    /// 行の並びはセトリと同じ (呼び出し側が zip できる)。
    #[test]
    fn 行の並びはセトリと同じ() {
        let snap = snap();
        let show = snap
            .shows
            .iter()
            .enumerate()
            .find(|(i, _)| snap.setlist_items_by_show[*i].len() >= 20)
            .map(|(_, s)| s.id.clone())
            .expect("20 曲以上のセトリがある");
        let entries = detail::setlist(snap, &show);
        let metas = setlist_row_meta(snap, &show, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
        assert_eq!(entries.len(), metas.len());
        for (e, m) in entries.iter().zip(&metas) {
            assert_eq!(e.id, m.item_id);
        }
        assert!(setlist_row_meta(snap, "存在しない公演", PerformerNameMode::IdolOnly, SetlistDisplayMode::Normal).is_empty());
    }
}
