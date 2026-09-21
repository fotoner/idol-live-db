//! セトリ 1 行に添える「名義」と「いつぶりか」を、公演ぶんまとめて組む。
//!
//! 規則そのものは別のところにある — ここはそれを公演の行に当てはめるだけ:
//!
//! - 名義の落ちる順 … [`crate::domain::performer_label::setlist_performer_label`]
//! - 顔ぶれからのユニット逆引き … [`crate::domain::unit_queries::exact_matching_units`]
//! - 出演者全員か … [`crate::domain::setlist_lineup::is_full_cast`]
//! - 何回目・いつぶり … [`crate::domain::performance_gap`]
//! - 自分の回収 (初回収・回収 N 回目・未回収) … [`crate::domain::collection_gap`]
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
use crate::domain::collection_gap::{
    attended_real_live_shows, collection_badge_label, collection_gap, is_real_live,
    show_collection_summary, CollectionGap, ShowCollectionRecord,
};
use crate::domain::performance_gap::performance_gap;
use crate::domain::performer_label::{setlist_performer_label, SetlistNaming};
use crate::domain::screen_composition::{
    setlist_collection_badges, setlist_history_badges, CollectionBadgeRecord, SetlistDisplayMode,
};
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
    /// **行に出す「自分の回収」の札** (`初回収` / `回収 3 回目 (2 年ぶり)` / `未回収`)。
    /// 多くても 1 つ。色は `role` で決める。
    ///
    /// 回数や前回の日といった**生の事実はここでは出さない**。出せば各 OS が
    /// 「N 回目」を自前で組み立てる口になり、文言が 3 面に散る
    /// (披露履歴の `ordinal` / `since_label` は既に出してしまっているが、
    /// あれも画面は `history_badges` しか読んでいない)。
    pub collection_badges: Vec<CollectionBadgeRecord>,
}

/// 公演 1 つぶんの添え物ひとまとめ。
///
/// **行と要約を 1 回で返す。** 要約は行の回収から数えたものなので、別の呼び出しに
/// 分けると「行は初回収と言っているのに要約は 0 曲」というズレを作れてしまう。
#[derive(uniffi::Record, Clone, Debug, PartialEq, Eq)]
pub struct SetlistRowMetaBundle {
    /// セトリと同じ並び (呼び出し側は zip するだけ)。
    pub rows: Vec<SetlistRowMetaRecord>,
    /// 公演の頭に出す自分の回収の要約。出すものが無ければ `None`。
    pub collection: Option<ShowCollectionRecord>,
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

/// 公演のセトリ行ぜんぶぶんの添え物 (`setlist_items_by_show` = position 昇順) と、
/// 自分の回収の要約。未知の show_id は空。
///
/// `attended_show_ids` / `attended_event_ids` は参加マーク (`user_marks`) を
/// プラットフォーム側で解決した id 列。**参加形態の条件は解決済みで渡す**
/// ([`crate::domain::collection_gap::collection_attended_show_ids`])。
/// 空で渡せば回収の札も要約も出ない (参加記録を付けていない人の見え方)。
pub fn setlist_row_meta(
    snap: &Snapshot,
    show_id: &str,
    mode: PerformerNameMode,
    display_mode: SetlistDisplayMode,
    attended_show_ids: &[String],
    attended_event_ids: &[String],
) -> SetlistRowMetaBundle {
    let Some(&show) = snap.show_index_by_id.get(show_id) else {
        return SetlistRowMetaBundle { rows: Vec::new(), collection: None };
    };
    let is_character_live =
        detail::is_character_live(snap.shows[show as usize].performer_type.as_deref());
    let cast_ids = detail::show_cast_idol_ids(snap, show_id);
    let cast: BTreeSet<&str> = cast_ids.iter().map(String::as_str).collect();
    let active = active_units(snap, show);
    let performers_by_item = detail::setlist_performers_by_item(snap, show_id);
    let attended =
        attended_real_live_shows(snap, attended_show_ids, attended_event_ids, true);
    // 回収の表示を出す門は**解決後の集合**で決める。生の id 列で見ると、
    // 「配信参加しか記録していない人 (既定は現地のみ)」と「リリイベだけ記録した人」で
    // 答えが割れる (前者は無言、後者は全行に未回収)。どちらも回収は 0 件なのに。
    let has_marks = !attended.is_empty();
    let real_live = is_real_live(snap, show);
    // 要約を数えるための材料 (曲 id と回収) を行を組みながら集める。
    let mut collection_rows: Vec<(String, CollectionGap)> = Vec::new();

    let rows: Vec<SetlistRowMetaRecord> = snap.setlist_items_by_show[show as usize]
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
            let mine = collection_gap(snap, item, &attended);
            let collection_badges = if has_marks {
                setlist_collection_badges(
                    display_mode,
                    real_live,
                    mine.attended,
                    collection_badge_label(&mine).as_deref(),
                    mine.collected_count,
                )
            } else {
                // 参加記録を 1 件も付けていない人に「未回収」を並べても情報にならない。
                Vec::new()
            };
            collection_rows.push((song.id.clone(), mine));

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
                collection_badges,
            }
        })
        .collect();

    let collection = display_mode
        .shows_collection_summary()
        .then(|| show_collection_summary(&collection_rows, has_marks, real_live))
        .flatten();
    SetlistRowMetaBundle { rows, collection }
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

    use crate::domain::screen_composition::CollectionBadgeRole;

    /// 参加記録なしで行だけ取る (既存テストの読み方)。
    fn rows_of(
        snap: &Snapshot,
        show_id: &str,
        mode: PerformerNameMode,
        display_mode: SetlistDisplayMode,
    ) -> Vec<SetlistRowMetaRecord> {
        setlist_row_meta(snap, show_id, mode, display_mode, &[], &[]).rows
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
        rows_of(snap, &show.id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed)
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
            let metas = rows_of(snap, show_id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
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
                .zip(rows_of(snap, show_id, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed))
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
            let metas = rows_of(snap, show, PerformerNameMode::IdolOnly, quiet);
            assert!(!metas.is_empty());
            assert!(
                metas.iter().all(|m| m.history_badges.is_empty()),
                "{quiet:?} で札が出ている"
            );
        }
        let detailed =
            rows_of(snap, show, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
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
        let metas = rows_of(snap, &show, PerformerNameMode::IdolOnly, SetlistDisplayMode::Detailed);
        assert_eq!(entries.len(), metas.len());
        for (e, m) in entries.iter().zip(&metas) {
            assert_eq!(e.id, m.item_id);
        }
        assert!(rows_of(snap, "存在しない公演", PerformerNameMode::IdolOnly, SetlistDisplayMode::Normal).is_empty());
    }

    // ---- 自分の回収 ----

    /// 参加した公演では、行に自分の回収が乗り、頭の要約もその公演のものになる。
    #[test]
    fn 参加した公演では行に回収が乗り要約が出る() {
        let snap = snap();
        // 曲数が多く、リアルライブの公演を 1 つ選ぶ。
        let show = snap
            .shows
            .iter()
            .enumerate()
            .find(|(i, _)| {
                snap.setlist_items_by_show[*i].len() >= 10
                    && is_real_live(snap, *i as u32)
            })
            .map(|(_, s)| s.id.clone())
            .expect("10 曲以上のリアルライブがある");

        let bundle = setlist_row_meta(
            snap,
            &show,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Detailed,
            std::slice::from_ref(&show),
            &[],
        );
        assert!(
            bundle.rows.iter().all(|r| r.collection_badges.len() == 1),
            "詳細表示では全行に回収の札が 1 つ付く"
        );
        assert!(
            bundle
                .rows
                .iter()
                .flat_map(|r| &r.collection_badges)
                .all(|b| b.role == CollectionBadgeRole::Collected),
            "その場で回収している行に未回収は出さない"
        );
        let summary = bundle.collection.expect("要約が出る");
        assert!(summary.attended);
        assert!(summary.label.starts_with("この公演で"));
        assert_eq!(summary.collected_songs, summary.total_songs);
    }

    /// 参加記録があっても、その公演に行っていなければ未回収の札と要約になる。
    #[test]
    fn 参加していない公演では未回収だけが出る() {
        let snap = snap();
        // 開く公演と、参加した扱いにする公演を選ぶ。**曲が 1 曲以上重なる 2 公演**にする
        // (重なりが無いと「別公演で回収済みなら札が付かない」を確かめられない)。
        let real_live = |i: usize| is_real_live(snap, i as u32);
        let songs_of = |i: usize| -> HashSet<u32> {
            snap.setlist_items_by_show[i]
                .iter()
                .map(|&item| snap.setlist_items[item as usize].song)
                .collect()
        };
        let (open, attended_elsewhere) = (0..snap.shows.len())
            .filter(|&i| snap.setlist_items_by_show[i].len() >= 10 && real_live(i))
            .find_map(|i| {
                let mine = songs_of(i);
                (0..snap.shows.len())
                    .filter(|&j| j != i && snap.setlist_items_by_show[j].len() >= 10 && real_live(j))
                    .find(|&j| !songs_of(j).is_disjoint(&mine))
                    .map(|j| (snap.shows[i].id.clone(), snap.shows[j].id.clone()))
            })
            .expect("曲が重なるリアルライブが 2 公演ある");

        let bundle = setlist_row_meta(
            snap,
            &open,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Detailed,
            std::slice::from_ref(&attended_elsewhere),
            &[],
        );
        assert!(
            bundle.rows.iter().flat_map(|r| &r.collection_badges).all(|b| {
                b.role == CollectionBadgeRole::Uncollected && b.text == "未回収"
            }),
            "参加していない公演で出る札は未回収だけ"
        );
        assert!(
            bundle.rows.iter().any(|r| r.collection_badges.is_empty()),
            "別公演で回収済みの曲には札が付かない (この 2 公演には共通の曲がある)"
        );
        let summary = bundle.collection.expect("要約が出る");
        assert!(!summary.attended);
        assert!(summary.label.contains("未回収") || summary.label.contains("全曲回収済み"));
    }

    /// 参加記録が 1 件も無い人には、回収の札も要約も出ない。
    #[test]
    fn 参加記録が無ければ回収の表示は何も出ない() {
        let snap = snap();
        let show = snap
            .shows
            .iter()
            .enumerate()
            .find(|(i, _)| !snap.setlist_items_by_show[*i].is_empty())
            .map(|(_, s)| s.id.clone())
            .expect("セトリのある公演がある");
        let bundle = setlist_row_meta(
            snap,
            &show,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Detailed,
            &[],
            &[],
        );
        assert!(bundle.rows.iter().all(|r| r.collection_badges.is_empty()));
        assert_eq!(bundle.collection, None);
    }

    /// **回収の対象でない催し (リリイベ等) に参加していても「未回収」と言わない。**
    ///
    /// 回帰: 参加した公演の集合はリアルライブだけに絞られるので、リリイベの行は
    /// 「未参加 かつ 回収 0 回」に化け、自分で付けた参加記録を全行が否定していた。
    #[test]
    fn 回収の対象でない催しでは参加していても札を出さない() {
        let snap = snap();
        let target = snap.shows.iter().enumerate().find(|(i, _)| {
            !snap.setlist_items_by_show[*i].is_empty()
                && !is_real_live(snap, *i as u32)
        });
        let Some((_, show)) = target else { return };
        let bundle = setlist_row_meta(
            snap,
            &show.id,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Detailed,
            std::slice::from_ref(&show.id),
            &[],
        );
        assert!(!bundle.rows.is_empty());
        assert!(
            bundle.rows.iter().all(|r| r.collection_badges.is_empty()),
            "回収の対象でない催しで札が出ている"
        );
        assert_eq!(bundle.collection, None);
    }

    /// 要約はシンプル表示では出さない (スクショに自分の記録を焼き込まない)。
    #[test]
    fn シンプル表示では要約を出さない() {
        let snap = snap();
        let show = snap
            .shows
            .iter()
            .enumerate()
            .find(|(i, _)| {
                !snap.setlist_items_by_show[*i].is_empty()
                    && is_real_live(snap, *i as u32)
            })
            .map(|(_, s)| s.id.clone())
            .expect("セトリのあるリアルライブがある");
        let simple = setlist_row_meta(
            snap,
            &show,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Simple,
            std::slice::from_ref(&show),
            &[],
        );
        assert_eq!(simple.collection, None);
        assert!(simple.rows.iter().all(|r| r.collection_badges.is_empty()));
        // 普通表示では札は出ないが要約は出る。
        let normal = setlist_row_meta(
            snap,
            &show,
            PerformerNameMode::IdolOnly,
            SetlistDisplayMode::Normal,
            std::slice::from_ref(&show),
            &[],
        );
        assert!(normal.collection.is_some());
        assert!(normal.rows.iter().all(|r| r.collection_badges.is_empty()));
    }
}
