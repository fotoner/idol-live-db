//! 楽曲の習熟度 (段階マーク) の規則と、群ごとの集計。純粋ロジック。
//!
//! 段階は **序数だけ**を保存する (`user_marks.kind = "mastery"` の `text_value`)。
//! 0 = 未設定、1..=steps が段。ラベルはユーザーが設定で決めるので保存値に入れない
//! — 入れると「ラベルを直したら記録が迷子になる」が必ず起きる。ラベルの文言と
//! 描画は各 OS、**段数から導ける規則 (次の段 / 重み / 段数を変えたときの寄せ先)
//! と群の作り方・集計はここ**に置く。
//!
//! # なぜ群化までコアでやるか
//!
//! 「CDシリーズ別に並べる」の縦軸は `series_group` が入っていない曲があり、
//! その落とし先 (cd_series を正規化 → それも無ければ「シリーズなし」) が判断になる。
//! ここを各 OS に書くと Android 移植で必ず写経になり、片方だけ直って乖離する
//! (`color_match.rs` 冒頭の実例と同じ道)。
//!
//! # FFI の粒度
//!
//! 1 画面ぶん (数百〜数千曲) を **1 回**で渡して、群の配列を返す。曲ごとに呼ぶと
//! 3,000 曲で 3,000 回の境界越えになる。

use crate::domain::display_join::non_empty;
use crate::domain::performer_label::{performer_label, PerformerNaming};
use std::collections::HashMap;

/// 群の縦軸。
#[derive(uniffi::Enum, Clone, Copy, Debug, PartialEq, Eq)]
pub enum MasteryAxis {
    /// CDシリーズ (`series_group` → 正規化した `cd_series` → シリーズなし)。
    Series,
    /// ユニット (`unit_name` → `singer_label` → その他)。
    Unit,
    /// 発売年 (`release_date` の先頭 4 桁)。
    Year,
}

/// 集計に渡す 1 曲の射影。判定に要るフィールドだけを持つ。
#[derive(uniffi::Record, Clone, Debug)]
pub struct MasterySong {
    pub song_id: String,
    pub title: String,
    pub series_group: Option<String>,
    pub cd_series: Option<String>,
    pub unit_name: Option<String>,
    pub singer_label: Option<String>,
    pub release_date: Option<String>,
    /// 0 = 未設定、1..=steps。
    pub level: u8,
}

/// 群 1 つ。ヒートマップの 1 行。
#[derive(uniffi::Record, Clone, Debug, PartialEq)]
pub struct MasteryGroup {
    pub key: String,
    pub label: String,
    /// 群の中の枚数 (CDシリーズ軸のときの `cd_series` の異なり数)。他の軸では 0。
    pub disc_count: u32,
    pub song_ids: Vec<String>,
    pub titles: Vec<String>,
    pub levels: Vec<u8>,
    /// 加重% (0..=100)。段に 1/steps 刻みの重みを付けた平均。
    pub percent: u32,
    /// 最上段に到達した曲数。
    pub done_count: u32,
    pub total: u32,
}

/// 画面上部に出す全体のまとめ。
#[derive(uniffi::Record, Clone, Debug, PartialEq)]
pub struct MasterySummary {
    pub percent: u32,
    pub done_count: u32,
    /// 1 段でも付いている曲数。
    pub set_count: u32,
    pub total: u32,
}

/// 一括更新の対象の選び方。
#[derive(uniffi::Enum, Clone, Copy, Debug, PartialEq, Eq)]
pub enum MasteryBulkScope {
    /// 群の全曲。
    All,
    /// まだ未設定の曲だけ (非破壊)。
    UnsetOnly,
}

// ---------------------------------------------------------------------------
// 段の規則
// ---------------------------------------------------------------------------

/// 段数を 1..=8 に丸める。設定が壊れていても 0 段や桁外れにしない。
fn clamp_steps(steps: u8) -> u8 {
    steps.clamp(1, 8)
}

/// タップ/スワイプで 1 段上げたときの次の段。**最上段では据え置き**。
///
/// 一覧の操作で未設定へ一周させない。下げる・消すはピッカーからだけにする
/// (連打で記録が飛ぶのを避ける)。
pub fn next_mastery_level(current: u8, steps: u8) -> u8 {
    let max = clamp_steps(steps);
    if current >= max { max } else { current + 1 }
}

/// 段の重み。未設定 = 0、最上段 = 1.0 で等間隔。
///
/// 段数から機械的に割るので、ユーザーが段数を変えても破綻しない
/// (2 段なら 0.5 / 1.0、4 段なら 0.25 / 0.5 / 0.75 / 1.0)。
pub fn mastery_weight(level: u8, steps: u8) -> f64 {
    let max = clamp_steps(steps);
    let l = level.min(max);
    f64::from(l) / f64::from(max)
}

/// 段数を変えたときの寄せ先。**記録は消さない**。
///
/// 減らすときは上から順に 1 つ下へ寄せる (4→3 段なら LV.4 も LV.3 も新 LV.3)。
/// 増やすときは据え置き。上限を超えている値は新しい上限に丸める。
pub fn remap_mastery_level(level: u8, old_steps: u8, new_steps: u8) -> u8 {
    let old_max = clamp_steps(old_steps);
    let new_max = clamp_steps(new_steps);
    if level == 0 {
        return 0;
    }
    let l = level.min(old_max);
    if new_max >= old_max { l } else { l.min(new_max) }
}

/// 一括更新の対象 id。`UnsetOnly` は未設定の曲だけを返す (非破壊)。
///
/// `song_ids` と `levels` は同じ並び。長さが違う場合は短い方に合わせる
/// (FFI 越しに来る値を信用しない)。
pub fn mastery_bulk_targets(
    song_ids: &[String],
    levels: &[u8],
    scope: MasteryBulkScope,
) -> Vec<String> {
    song_ids
        .iter()
        .zip(levels.iter())
        .filter(|(_, &l)| match scope {
            MasteryBulkScope::All => true,
            MasteryBulkScope::UnsetOnly => l == 0,
        })
        .map(|(id, _)| id.clone())
        .collect()
}

// ---------------------------------------------------------------------------
// 群化
// ---------------------------------------------------------------------------

/// 配信メタ由来の接尾辞を落とす。
///
/// `cd_series` は Apple Music のアルバム名がそのまま入っていて
/// `… - EP` / `… - Single` が付く (実測 981 曲)。そのまま群の名前にすると
/// 画面に出たとき読めないので、ここで畳む。
fn normalize_disc_name(raw: &str) -> String {
    let t = raw.trim();
    for suffix in [" - EP", " - Single"] {
        if let Some(stripped) = t.strip_suffix(suffix) {
            return stripped.trim().to_string();
        }
    }
    t.to_string()
}

/// その曲がどの群に入るか。返すのは (キー, 表示名)。
fn group_of(song: &MasterySong, axis: MasteryAxis) -> (String, String) {
    match axis {
        MasteryAxis::Series => {
            if let Some(sg) = non_empty(&song.series_group) {
                return (sg.to_string(), sg.to_string());
            }
            if let Some(cd) = non_empty(&song.cd_series) {
                let n = normalize_disc_name(cd);
                return (n.clone(), n);
            }
            ("__none__".to_string(), "シリーズなし".to_string())
        }
        MasteryAxis::Unit => {
            // 名義の決め方は performer_label が唯一の出どころ。ここに書き写すと、
            // 一覧とヒートマップで同じ曲が違う名義で出る (実際にそうなっていた)。
            // MasterySong は原唱者を持たないので、3 段目には落ちない。
            match performer_label(&PerformerNaming {
                unit_name: song.unit_name.clone(),
                singer_label: song.singer_label.clone(),
                performer_names: Vec::new(),
            }) {
                Some(label) => (label.clone(), label),
                None => ("__none__".to_string(), "その他".to_string()),
            }
        }
        MasteryAxis::Year => {
            // バイト添字で切ると壊れた値 (全角・和暦表記) でパニックする。
            // 先頭 4 **文字**を取って、4 桁の数字のときだけ年として扱う。
            let year: Option<String> = non_empty(&song.release_date).and_then(|d| {
                let head: String = d.chars().take(4).collect();
                (head.chars().count() == 4 && head.chars().all(|c| c.is_ascii_digit()))
                    .then_some(head)
            });
            match year {
                Some(y) => (y.clone(), format!("{y}年")),
                None => ("__none__".to_string(), "発売日なし".to_string()),
            }
        }
    }
}

fn percent_of(levels: &[u8], steps: u8) -> u32 {
    if levels.is_empty() {
        return 0;
    }
    let sum: f64 = levels.iter().map(|&l| mastery_weight(l, steps)).sum();
    (sum / levels.len() as f64 * 100.0).round() as u32
}

/// 群を作って集計する。並びは **曲数の多い順 → 同数ならラベル昇順**。
///
/// 群の中の曲は入力順を保つ (呼び出し側が発売順/トラック順で渡す前提)。
/// 「シリーズなし」等の受け皿は、数が多くても**必ず末尾**に置く
/// — 一番上に来ると画面が受け皿で埋まって、軸の意味が読めなくなる。
pub fn build_mastery_groups(
    songs: &[MasterySong],
    axis: MasteryAxis,
    steps: u8,
) -> Vec<MasteryGroup> {
    let max = clamp_steps(steps);
    let mut order: Vec<String> = Vec::new();
    let mut by_key: HashMap<String, MasteryGroup> = HashMap::new();
    let mut discs: HashMap<String, Vec<String>> = HashMap::new();

    for song in songs {
        let (key, label) = group_of(song, axis);
        let entry = by_key.entry(key.clone()).or_insert_with(|| {
            order.push(key.clone());
            MasteryGroup {
                key: key.clone(),
                label,
                disc_count: 0,
                song_ids: Vec::new(),
                titles: Vec::new(),
                levels: Vec::new(),
                percent: 0,
                done_count: 0,
                total: 0,
            }
        });
        entry.song_ids.push(song.song_id.clone());
        entry.titles.push(song.title.clone());
        entry.levels.push(song.level.min(max));
        if axis == MasteryAxis::Series {
            if let Some(cd) = non_empty(&song.cd_series) {
                let n = normalize_disc_name(cd);
                let seen = discs.entry(key.clone()).or_default();
                if !seen.contains(&n) {
                    seen.push(n);
                }
            }
        }
    }

    let mut groups: Vec<MasteryGroup> = order
        .into_iter()
        .map(|k| {
            let mut g = by_key.remove(&k).expect("order と by_key は同時に作る");
            g.total = g.levels.len() as u32;
            g.done_count = g.levels.iter().filter(|&&l| l == max).count() as u32;
            g.percent = percent_of(&g.levels, max);
            g.disc_count = discs.get(&k).map_or(0, |d| d.len()) as u32;
            g
        })
        .collect();

    groups.sort_by(|a, b| {
        let a_none = a.key == "__none__";
        let b_none = b.key == "__none__";
        a_none
            .cmp(&b_none)
            .then(b.total.cmp(&a.total))
            .then(a.label.cmp(&b.label))
    });
    groups
}

/// 画面上部のまとめ。群化とは独立に全曲から出す。
pub fn mastery_summary(songs: &[MasterySong], steps: u8) -> MasterySummary {
    let max = clamp_steps(steps);
    let levels: Vec<u8> = songs.iter().map(|s| s.level.min(max)).collect();
    MasterySummary {
        percent: percent_of(&levels, max),
        done_count: levels.iter().filter(|&&l| l == max).count() as u32,
        set_count: levels.iter().filter(|&&l| l > 0).count() as u32,
        total: levels.len() as u32,
    }
}

// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    fn song(id: &str, level: u8) -> MasterySong {
        MasterySong {
            song_id: id.into(),
            title: id.into(),
            series_group: None,
            cd_series: None,
            unit_name: None,
            singer_label: None,
            release_date: None,
            level,
        }
    }

    #[test]
    fn next_level_stops_at_top() {
        assert_eq!(next_mastery_level(0, 4), 1);
        assert_eq!(next_mastery_level(3, 4), 4);
        // 最上段で押しても一周して未設定に戻らない (連打で記録が飛ばない)
        assert_eq!(next_mastery_level(4, 4), 4);
        assert_eq!(next_mastery_level(9, 4), 4);
    }

    #[test]
    fn weight_is_evenly_divided_by_steps() {
        assert_eq!(mastery_weight(0, 4), 0.0);
        assert_eq!(mastery_weight(1, 4), 0.25);
        assert_eq!(mastery_weight(4, 4), 1.0);
        // 段数を変えても壊れない
        assert_eq!(mastery_weight(1, 2), 0.5);
        assert_eq!(mastery_weight(2, 2), 1.0);
    }

    #[test]
    fn steps_are_clamped() {
        // 0 段でもゼロ除算しない
        assert_eq!(mastery_weight(1, 0), 1.0);
        assert_eq!(next_mastery_level(0, 0), 1);
    }

    #[test]
    fn remap_moves_down_one_when_steps_shrink() {
        // 4 → 3 段: LV.4 は LV.3 に寄る。記録は消えない
        assert_eq!(remap_mastery_level(4, 4, 3), 3);
        assert_eq!(remap_mastery_level(3, 4, 3), 3);
        assert_eq!(remap_mastery_level(1, 4, 3), 1);
        assert_eq!(remap_mastery_level(0, 4, 3), 0);
        // 増やすときは据え置き
        assert_eq!(remap_mastery_level(2, 3, 5), 2);
    }

    #[test]
    fn bulk_unset_only_is_non_destructive() {
        let ids = vec!["a".to_string(), "b".to_string(), "c".to_string()];
        let levels = vec![0, 3, 0];
        assert_eq!(
            mastery_bulk_targets(&ids, &levels, MasteryBulkScope::UnsetOnly),
            vec!["a".to_string(), "c".to_string()]
        );
        assert_eq!(
            mastery_bulk_targets(&ids, &levels, MasteryBulkScope::All),
            ids
        );
    }

    #[test]
    fn bulk_targets_tolerate_length_mismatch() {
        let ids = vec!["a".to_string(), "b".to_string()];
        let levels = vec![0];
        assert_eq!(
            mastery_bulk_targets(&ids, &levels, MasteryBulkScope::All),
            vec!["a".to_string()]
        );
    }

    #[test]
    fn series_axis_falls_back_to_normalized_disc_name() {
        let mut a = song("a", 0);
        a.series_group = Some("CANVAS".into());
        a.cd_series = Some("THE IDOLM@STER SHINY COLORS \"CANVAS\" 01 - EP".into());
        let mut b = song("b", 0);
        // series_group が無い曲は cd_series の正規化名で群になる
        b.cd_series = Some("Over the prism - EP".into());
        let mut c = song("c", 0);
        c.series_group = Some("   ".into()); // 空白だけは「無し」扱い

        let groups = build_mastery_groups(&[a, b, c], MasteryAxis::Series, 4);
        let labels: Vec<&str> = groups.iter().map(|g| g.label.as_str()).collect();
        assert!(labels.contains(&"CANVAS"));
        assert!(labels.contains(&"Over the prism"));
        assert!(labels.contains(&"シリーズなし"));
    }

    #[test]
    fn disc_count_counts_distinct_normalized_discs() {
        let mk = |id: &str, disc: &str| {
            let mut s = song(id, 0);
            s.series_group = Some("CANVAS".into());
            s.cd_series = Some(disc.into());
            s
        };
        let groups = build_mastery_groups(
            &[
                mk("a", "CANVAS 01 - EP"),
                mk("b", "CANVAS 01 - EP"),
                mk("c", "CANVAS 02 - EP"),
            ],
            MasteryAxis::Series,
            4,
        );
        assert_eq!(groups.len(), 1);
        assert_eq!(groups[0].disc_count, 2);
        assert_eq!(groups[0].total, 3);
    }

    #[test]
    fn catch_all_group_sinks_to_the_bottom() {
        let mut a = song("a", 0);
        a.series_group = Some("CANVAS".into());
        let b = song("b", 0); // 受け皿行き
        let c = song("c", 0);
        let d = song("d", 0);
        let groups = build_mastery_groups(&[a, b, c, d], MasteryAxis::Series, 4);
        // 受け皿は 3 曲で最多だが、末尾に置く
        assert_eq!(groups.last().unwrap().label, "シリーズなし");
        assert_eq!(groups[0].label, "CANVAS");
    }

    #[test]
    fn percent_is_weighted_not_completion_ratio() {
        let mut a = song("a", 2);
        a.series_group = Some("S".into());
        let mut b = song("b", 2);
        b.series_group = Some("S".into());
        let groups = build_mastery_groups(&[a, b], MasteryAxis::Series, 4);
        // 「覚えた」は 0 曲だが、LV.2 が 2 曲なので 50%
        assert_eq!(groups[0].percent, 50);
        assert_eq!(groups[0].done_count, 0);
    }

    #[test]
    fn unit_axis_falls_back_to_singer_label() {
        let mut a = song("a", 0);
        a.unit_name = Some("アンティーカ".into());
        let mut b = song("b", 0);
        b.singer_label = Some("櫻木真乃".into());
        let groups = build_mastery_groups(&[a, b], MasteryAxis::Unit, 4);
        let labels: Vec<&str> = groups.iter().map(|g| g.label.as_str()).collect();
        assert!(labels.contains(&"アンティーカ"));
        assert!(labels.contains(&"櫻木真乃"));
    }

    #[test]
    fn year_axis_uses_leading_four_digits() {
        let mut a = song("a", 0);
        a.release_date = Some("2023-03-20".into());
        let mut b = song("b", 0);
        b.release_date = Some("こわれた".into());
        let groups = build_mastery_groups(&[a, b], MasteryAxis::Year, 4);
        assert_eq!(groups[0].label, "2023年");
        assert_eq!(groups.last().unwrap().label, "発売日なし");
    }

    #[test]
    fn summary_counts_set_and_done_separately() {
        let s = mastery_summary(&[song("a", 0), song("b", 1), song("c", 4)], 4);
        assert_eq!(s.total, 3);
        assert_eq!(s.set_count, 2);
        assert_eq!(s.done_count, 1);
        // (0 + 0.25 + 1.0) / 3 = 41.67 → 42
        assert_eq!(s.percent, 42);
    }

    #[test]
    fn levels_above_the_scale_are_clamped() {
        // 段数を減らした直後に古い値が残っていても、集計は新しい上限で見る
        let groups = build_mastery_groups(&[song("a", 7)], MasteryAxis::Series, 2);
        assert_eq!(groups[0].levels, vec![2]);
        assert_eq!(groups[0].percent, 100);
    }

    #[test]
    fn empty_input_is_zero_not_a_panic() {
        assert_eq!(build_mastery_groups(&[], MasteryAxis::Series, 4), vec![]);
        let s = mastery_summary(&[], 4);
        assert_eq!(s, MasterySummary { percent: 0, done_count: 0, set_count: 0, total: 0 });
    }
}
