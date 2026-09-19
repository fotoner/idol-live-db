//! 条件で並べる / 数えるツール群 (list_*・idol_songs・song_performances・setlist_diff・stats)。
//!
//! 規約 (`super` の注記も読むこと):
//! - 1 ツール = 1 `pub fn`。引数の取り出しは `super::args` の補助に寄せる。
//! - 返す JSON は「追加の往復なしに文章が書ける」形まで名前を解決する。id も必ず添える。
//! - 件数は既定の上限を持たせ、打ち切ったことが分かるように `truncated` を返す。
//!
//! ## 絞り込みと並び順はここに書かない
//!
//! どの曲が条件に当たるか・どう並ぶかは `song_list_queries` / `idol_list_filtering` /
//! `event_list_filtering` が正本で、アプリも Web もそこを通っている。このファイルは
//! **引数を正本の条件型へ詰め替えて呼ぶだけ**にする。軸が足りないときは正本側に足す
//! (ここに自前の述語を書くと、iOS・Web・LLM で「当たる曲」が三者三様になる)。
//!
//! 正本に無くて足したもの:
//! - `song_list_queries::songs_in_release_range` (リリース日の範囲)
//! - `event_list_queries::event_ids_at_venue` (会場 → イベントの逆引き)
//! - `setlist_diff::compare_setlists` (2 公演のセットリスト比較)
//!
//! ## 語彙外の値は黙って 0 件にしない
//!
//! LLM は `brand` に "cinderella" のような**それらしい綴り**を入れてくる。0 件を返すと
//! 「そんなライブは無かった」と書いてしまい、空振りに気づけない。取りうる値を並べた
//! [`ToolError::BadArgs`] で返して、次の 1 手で直せるようにする。
//! id 系 (`idol_id` / `unit_id` 等) は値域が広すぎて並べられないので
//! [`ToolError::NotFound`] にして、名前をほどくツールへ送り返す。

use super::{args, ToolError, ToolSpec};
use crate::domain::snapshot::{Idol, Snapshot};
use serde_json::{json, Map, Value};
use std::collections::{BTreeSet, HashSet};

// =============================================================================
// カタログ
// =============================================================================

/// このファイルが持つツールの定義。
pub fn catalog() -> Vec<ToolSpec> {
    vec![
        spec(
            "list_idols",
            "条件でアイドルを並べる。誕生月・星座・出身地・血液型・属性・CV・所属ユニットで絞れる。\
             ブランドや属性の取りうる値は語彙ツールで引ける (知らない値を渡すと候補つきのエラーが返る)。",
            json!({
                "brand": { "type": "string", "description": "ブランド id (例 cg / ml / sc / gakuen)。" },
                "birth_month": { "type": "integer", "minimum": 1, "maximum": 12, "description": "誕生月。" },
                "constellation": { "type": "string", "description": "星座 (例 獅子座)。" },
                "birth_place": { "type": "string", "description": "出身地 (例 東京)。" },
                "blood_type": { "type": "string", "description": "血液型 (A / B / O / AB)。" },
                "attribute": { "type": "string", "description": "ブランド内の属性 (例 cute / cool / passion)。" },
                "voice_actor": { "type": "string", "description": "CV (声優) 名の完全一致。歴代すべてが対象。" },
                "unit_id": { "type": "string", "description": "所属ユニットの id。" },
                "query": { "type": "string", "description": "名前 / 読み / 別名 / 愛称 / CV 名の部分一致。" },
                "sort": { "type": "string", "description": "official (既定) / kana / age / height / weight / birthday / debut。" },
                "limit": { "type": "integer", "description": "既定 30・最大 200。" }
            }),
            &[],
        ),
        spec(
            "list_songs",
            "条件で曲を並べる。ブランド・曲種別・原唱者・ユニット・CD シリーズ・リリース時期で絞れる。\
             一覧の母集団はアプリの曲一覧と同じで、ライブ履歴にしか出てこない曲 (カタログ情報が皆無の曲) と\
             リミックス等の派生曲は含めない。",
            json!({
                "brand": { "type": "string", "description": "ブランド id。合同曲は参加ブランドどれでも当たる。" },
                "song_type": { "type": "string", "description": "曲種別 (solo / unit / all / cover / tie_in)。all は全体曲。" },
                "idol_id": { "type": "string", "description": "原唱者 (song_artists.role='original') の idol_id。ライブで歌っただけの曲は含まない。" },
                "unit_id": { "type": "string", "description": "ユニット名義の曲 (songs.unit_id) の unit_id。" },
                "cd_series": { "type": "string", "description": "CD シリーズ名の部分一致。" },
                "series_group": { "type": "string", "description": "上位シリーズ名の完全一致。" },
                "released_from": { "type": "string", "description": "リリース日の下限。YYYY / YYYY-MM / YYYY-MM-DD。" },
                "released_to": { "type": "string", "description": "リリース日の上限。粗い指定はその年/月をすべて含む。" },
                "query": { "type": "string", "description": "曲名 / 読みの部分一致。" },
                "sort": { "type": "string", "description": "kana (既定) / release / performance。" },
                "limit": { "type": "integer", "description": "既定 30・最大 200。" }
            }),
            &[],
        ),
        spec(
            "list_events",
            "条件でライブ (イベント) を並べる。ブランド・開催年・会場・種別・今後/過去で絞れる。\
             1 イベントは複数公演 (日程) を持つので、日付は初日と最終日で返る。",
            json!({
                "brand": { "type": "string", "description": "ブランド id。合同ライブは参加ブランドどれでも当たる。" },
                "year": { "type": "integer", "description": "初日の開催年。" },
                "venue": { "type": "string", "description": "会場名。読み・旧名でも当たる。" },
                "kind": { "type": "string", "description": "live / festival / release_event。" },
                "when": { "type": "string", "enum": ["upcoming", "past", "all"], "description": "既定 all。upcoming は近い順、それ以外は新しい順。" },
                "query": { "type": "string", "description": "ライブ名の部分一致。" },
                "limit": { "type": "integer", "description": "既定 30・最大 200。" }
            }),
            &[],
        ),
        spec(
            "idol_songs",
            "あるアイドルの曲。原唱 (持ち歌) と、ライブで歌った曲は別物なので分けて返す。\
             ユニット名義の持ち歌も別立てで返す (個人の song_artists には出てこないため)。",
            json!({
                "idol_id": { "type": "string", "description": "アイドルの id。" },
                "role": { "type": "string", "enum": ["original", "performed", "all"], "description": "既定 all。" },
                "limit": { "type": "integer", "description": "区分ごとの上限。既定 50・最大 300。" }
            }),
            &["idol_id"],
        ),
        spec(
            "song_performances",
            "ある曲の披露履歴 (新しい順)。日付・公演・会場・そのときの歌唱者・通算何回目かを返す。\
             出演者全員で歌った回は歌唱者の名前を並べず full_cast で示す。",
            json!({
                "song_id": { "type": "string", "description": "曲の id。" },
                "limit": { "type": "integer", "description": "既定 50・最大 500。" }
            }),
            &["song_id"],
        ),
        spec(
            "setlist_diff",
            "2 つの公演のセットリストを比べる。両方でやった曲・片方だけの曲・曲順が同じかを返す。",
            json!({
                "show_id_a": { "type": "string", "description": "公演 A の id。" },
                "show_id_b": { "type": "string", "description": "公演 B の id。" }
            }),
            &["show_id_a", "show_id_b"],
        ),
        spec(
            "stats",
            "集計。披露回数ランキング・出演公演数ランキング・ブランド別曲数・年別/月別公演数・CD シリーズ一覧。",
            json!({
                "kind": {
                    "type": "string",
                    "enum": STATS_KINDS,
                    "description": "集計の種類。"
                },
                "limit": { "type": "integer", "description": "ランキングは既定 20、一覧系は既定で全件。最大 1000。" }
            }),
            &["kind"],
        ),
    ]
}

/// 自分の持ちツールなら `Some(結果)`、違うなら `None` (呼び手が次を試す)。
pub fn call(
    snap: &Snapshot,
    name: &str,
    args: &Value,
    today_key: &str,
) -> Option<Result<Value, ToolError>> {
    Some(match name {
        "list_idols" => list_idols(snap, args),
        "list_songs" => list_songs(snap, args),
        "list_events" => list_events(snap, args, today_key),
        "idol_songs" => idol_songs(snap, args),
        "song_performances" => song_performances(snap, args),
        "setlist_diff" => setlist_diff(snap, args),
        "stats" => stats(snap, args),
        _ => return None,
    })
}

fn spec(name: &str, description: &str, properties: Value, required: &[&str]) -> ToolSpec {
    let schema = json!({
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "properties": properties,
        "required": required,
        "additionalProperties": false,
    });
    ToolSpec {
        name: name.to_string(),
        description: description.to_string(),
        input_schema: schema.to_string(),
    }
}

// =============================================================================
// 返す形の共通部品
// =============================================================================

/// `null` は入れない。読み手はトークンを払って読むので、「値が無い」ことを
/// わざわざ書いて伝える価値は無い (キーが無い = 未設定、で通じる)。
fn put(o: &mut Map<String, Value>, key: &str, value: Option<impl Into<Value>>) {
    if let Some(v) = value {
        o.insert(key.to_string(), v.into());
    }
}

/// 一覧の包み。**総数は必ず返す** —「何件ありますか」に答えられなくなるため、
/// 打ち切った件数だけを返すことはしない。
fn listing(key: &str, total: usize, rows: Vec<Value>) -> Value {
    let mut o = Map::new();
    o.insert("total".into(), json!(total));
    o.insert("count".into(), json!(rows.len()));
    if rows.len() < total {
        o.insert("truncated".into(), json!(true));
    }
    o.insert(key.to_string(), Value::Array(rows));
    Value::Object(o)
}

/// 先頭 `limit` 件だけ残す (総数は呼び出し側が先に控えておく)。
fn take<T>(mut items: Vec<T>, limit: u32) -> Vec<T> {
    items.truncate(limit as usize);
    items
}

/// 条件を 1 本足すたびに「いままでの候補との積」を取る。
///
/// 正本の絞り込み (`filter_song_indexes` 等) が持っていない軸は、その軸の**正本の関数**
/// (`unit_song_ids` / `idols_by_constellation` 等) が返す集合と交差させて実現する。
/// ここで述語を書き直さないのは、軸ごとの当たり方を 2 箇所に持たないため。
fn narrow<T: std::hash::Hash + Eq + Clone>(
    allow: &mut Option<HashSet<T>>,
    candidates: impl IntoIterator<Item = T>,
) {
    let next: HashSet<T> = candidates.into_iter().collect();
    *allow = Some(match allow.take() {
        Some(current) => current.intersection(&next).cloned().collect(),
        None => next,
    });
}

// =============================================================================
// 語彙 (取りうる値) と検査
// =============================================================================

/// `stats` の `kind`。スキーマにも `BadArgs` の文面にも同じ配列を使う。
const STATS_KINDS: [&str; 6] = [
    "song_play_ranking",
    "cast_show_ranking",
    "brand_song_counts",
    "yearly_show_counts",
    "monthly_show_counts",
    "cd_series_list",
];

/// 空でない値を重複なく昇順で。語彙はデータそのものから作る
/// (定数で持つと、ブランドや属性が増えたときに黙って古いままになる)。
fn distinct<'a>(values: impl Iterator<Item = Option<&'a str>>) -> Vec<String> {
    let set: BTreeSet<&str> = values.flatten().filter(|v| !v.is_empty()).collect();
    set.into_iter().map(str::to_string).collect()
}

fn brand_vocab(snap: &Snapshot) -> Vec<String> {
    snap.brand_order.iter().map(|&i| snap.brands[i as usize].id.clone()).collect()
}

fn song_type_vocab(snap: &Snapshot) -> Vec<String> {
    distinct(snap.songs.iter().map(|s| s.song_type.as_deref()))
}

fn event_kind_vocab(snap: &Snapshot) -> Vec<String> {
    distinct(snap.events.iter().map(|e| Some(e.kind.as_str())))
}

/// アイドルの列そのものが語彙。`idols_by_constellation` 等が完全一致で引くので、
/// **その列の実在値**が取りうる値のすべて。
fn idol_vocab(snap: &Snapshot, column: fn(&Idol) -> Option<&str>) -> Vec<String> {
    distinct(snap.idols.iter().map(column))
}

/// 語彙に無い値を、候補つきで突き返す。
fn checked(arg: &str, value: String, allowed: &[String]) -> Result<String, ToolError> {
    if allowed.contains(&value) {
        return Ok(value);
    }
    Err(ToolError::BadArgs(format!(
        "{arg} に「{value}」は無い。取りうる値: {}",
        sample(allowed)
    )))
}

/// 候補の並べ方。全部並べると CD シリーズのように 100 件を超えるものがあるので頭だけ。
fn sample(allowed: &[String]) -> String {
    const SHOWN: usize = 40;
    let head = allowed.iter().take(SHOWN).cloned().collect::<Vec<_>>().join(" / ");
    if allowed.len() > SHOWN {
        format!("{head} … 他 {} 件", allowed.len() - SHOWN)
    } else if head.is_empty() {
        "(該当なし)".to_string()
    } else {
        head
    }
}

/// `YYYY` / `YYYY-MM` / `YYYY-MM-DD` のいずれか。
/// 粗い指定を許すのは「2020 年以降」を 1 語で書けるようにするため。
fn checked_date_bound(arg: &str, value: String) -> Result<String, ToolError> {
    let ok = matches!(value.len(), 4 | 7 | 10)
        && value
            .char_indices()
            .all(|(i, c)| if i == 4 || i == 7 { c == '-' } else { c.is_ascii_digit() });
    if ok {
        Ok(value)
    } else {
        Err(ToolError::BadArgs(format!(
            "{arg} は YYYY / YYYY-MM / YYYY-MM-DD で書く (与えられた値: {value})"
        )))
    }
}

// =============================================================================
// 行の射影 (名前まで解決する)
// =============================================================================

fn brand_short_name(snap: &Snapshot, brand_id: Option<&str>) -> Option<String> {
    snap.brand(brand_id?).map(|b| b.short_name.clone())
}

fn idol_row(snap: &Snapshot, idol: &Idol) -> Value {
    use crate::domain::idol_queries::{birthday_display, height_display};
    let mut o = Map::new();
    o.insert("id".into(), json!(idol.id));
    o.insert("name".into(), json!(idol.name));
    put(&mut o, "name_kana", idol.name_kana.clone());
    put(&mut o, "brand", idol.brand_id.clone());
    put(&mut o, "brand_name", brand_short_name(snap, idol.brand_id.as_deref()));
    put(&mut o, "attribute", idol.attribute.clone());
    put(&mut o, "birthday", birthday_display(idol.birthday.as_deref()));
    put(&mut o, "constellation", idol.constellation.clone());
    put(&mut o, "blood_type", idol.blood_type.clone());
    put(&mut o, "birth_place", idol.birth_place.clone());
    put(&mut o, "age", idol.age);
    put(&mut o, "height", height_display(idol.height));
    let index = snap.idol_index_by_id[&idol.id];
    put(&mut o, "voice_actor", snap.current_voice_actor(index).map(|v| v.name.clone()));
    Value::Object(o)
}

/// 曲 1 行。原唱者は人数が多い曲 (全体曲) で名前を並べると読む量が跳ね上がるので、
/// 数だけを必ず返し、名前は並べても読める人数のときだけ添える。
fn song_row(snap: &Snapshot, index: u32) -> Value {
    const NAMED_ARTISTS_MAX: usize = 10;
    let song = &snap.songs[index as usize];
    let mut o = Map::new();
    o.insert("id".into(), json!(song.id));
    o.insert("title".into(), json!(song.title));
    put(&mut o, "title_kana", song.title_kana.clone());
    put(&mut o, "brand", song.brand_id.clone());
    put(&mut o, "brand_name", brand_short_name(snap, song.brand_id.as_deref()));
    put(&mut o, "song_type", song.song_type.clone());
    put(&mut o, "release_date", song.release_date.clone());
    put(&mut o, "cd_series", song.cd_series.clone());
    put(&mut o, "series_group", song.series_group.clone());
    put(&mut o, "unit_name", song.unit_name.clone());
    put(&mut o, "singer_label", song.singer_label.clone());
    o.insert("performance_count".into(), json!(snap.performance_counts[index as usize]));

    let artists = original_artist_names(snap, index);
    o.insert("artist_count".into(), json!(artists.len()));
    if !artists.is_empty() && artists.len() <= NAMED_ARTISTS_MAX {
        o.insert("artists".into(), json!(artists));
    }
    Value::Object(o)
}

/// 原唱者 (song_artists.role='original') の名前。並びは idol の公式順 (前計算済み)。
fn original_artist_names(snap: &Snapshot, song: u32) -> Vec<String> {
    snap.artists_by_song[song as usize]
        .iter()
        .filter(|l| l.role == "original")
        .map(|l| snap.idols[l.idol as usize].name.clone())
        .collect()
}

/// 原唱者の idol_id (オリメン判定用。名前ではなく id で比べる)。
fn original_artist_ids(snap: &Snapshot, song: u32) -> Vec<&str> {
    snap.artists_by_song[song as usize]
        .iter()
        .filter(|l| l.role == "original")
        .map(|l| snap.idols[l.idol as usize].id.as_str())
        .collect()
}

/// 公演 1 件の見出し (どの公演かを 1 行で書けるだけの情報)。
fn show_header(snap: &Snapshot, show_index: u32) -> Value {
    let show = &snap.shows[show_index as usize];
    let event = &snap.events[show.event as usize];
    let mut o = Map::new();
    o.insert("show_id".into(), json!(show.id));
    o.insert("show_name".into(), json!(show.name));
    o.insert("event_id".into(), json!(event.id));
    o.insert("event_name".into(), json!(event.name));
    o.insert("date".into(), json!(show.date));
    put(&mut o, "venue", show.venue.clone());
    o.insert(
        "song_count".into(),
        json!(snap.setlist_items_by_show[show_index as usize].len()),
    );
    Value::Object(o)
}

// =============================================================================
// list_idols
// =============================================================================

fn list_idols(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::idol_list_filtering::{
        filter_idol_list, idol_list_entries, sort_idol_list, IdolQuery, IdolSortKind,
        ALL_SORT_KINDS,
    };
    use crate::domain::idol_queries::{
        idol_cast_names, idols_by_blood_type, idols_by_birth_place, idols_by_constellation,
        idols_by_voice_actor,
    };

    let limit = args::limit(arguments, 30, 200)?;
    let mut query = IdolQuery::default();

    if let Some(brand) = args::str_opt(arguments, "brand") {
        query.brand_ids = vec![checked("brand", brand, &brand_vocab(snap))?];
    }
    if let Some(attribute) = args::str_opt(arguments, "attribute") {
        let vocab = idol_vocab(snap, |i| i.attribute.as_deref());
        query.attribute = Some(checked("attribute", attribute, &vocab)?);
    }
    if let Some(month) = args::u32_opt(arguments, "birth_month")? {
        if !(1..=12).contains(&month) {
            return Err(ToolError::BadArgs("birth_month は 1〜12 です".into()));
        }
        query.birth_month = Some(month);
    }
    if let Some(text) = args::str_opt(arguments, "query") {
        query.search_text = text;
    }
    let sort_keys: Vec<String> = ALL_SORT_KINDS.iter().map(|k| k.key().to_string()).collect();
    if let Some(sort) = args::str_opt(arguments, "sort") {
        query.sort = checked("sort", sort, &sort_keys)?;
    }

    // 正本が持たない軸は、その軸の正本の関数が返す id 集合と交差させる。
    let mut allow: Option<HashSet<String>> = None;
    if let Some(value) = args::str_opt(arguments, "constellation") {
        let vocab = idol_vocab(snap, |i| i.constellation.as_deref());
        let value = checked("constellation", value, &vocab)?;
        narrow(&mut allow, idols_by_constellation(snap, &value).into_iter().map(|r| r.id));
    }
    if let Some(value) = args::str_opt(arguments, "birth_place") {
        let vocab = idol_vocab(snap, |i| i.birth_place.as_deref());
        let value = checked("birth_place", value, &vocab)?;
        narrow(&mut allow, idols_by_birth_place(snap, &value).into_iter().map(|r| r.id));
    }
    if let Some(value) = args::str_opt(arguments, "blood_type") {
        let vocab = idol_vocab(snap, |i| i.blood_type.as_deref());
        let value = checked("blood_type", value, &vocab)?;
        narrow(&mut allow, idols_by_blood_type(snap, &value).into_iter().map(|r| r.id));
    }
    if let Some(name) = args::str_opt(arguments, "voice_actor") {
        // CV 名は完全一致でしか引けない (歴代分の索引がそうなっている)。
        // 語彙は数百件あって並べられないので、ほどき直しを促す NotFound に倒す。
        let hits = idols_by_voice_actor(snap, &name);
        if hits.is_empty() {
            return Err(ToolError::NotFound(format!(
                "CV「{name}」の担当アイドルがいない (表記ゆれの可能性がある。名前をほどいてから渡すこと)"
            )));
        }
        narrow(&mut allow, hits.into_iter().map(|r| r.id));
    }
    if let Some(unit_id) = args::str_opt(arguments, "unit_id") {
        let members = crate::domain::unit_queries::unit_member_idol_ids(snap, &unit_id);
        if members.is_empty() {
            return Err(ToolError::NotFound(format!("ユニット {unit_id} が無いか、メンバーがいない")));
        }
        narrow(&mut allow, members);
    }

    let entries = idol_list_entries(snap);
    let kept: HashSet<u32> =
        filter_idol_list(&entries, &query.to_criteria(idol_cast_names(snap))).into_iter().collect();
    let sort_kind = IdolSortKind::from_key(&query.sort);
    let ordered: Vec<u32> = sort_idol_list(&entries, sort_kind, query.ascending)
        .into_iter()
        .filter(|i| kept.contains(i))
        .filter(|i| {
            allow.as_ref().is_none_or(|ids| ids.contains(&entries[*i as usize].idol_id))
        })
        .collect();

    let total = ordered.len();
    let rows = take(ordered, limit)
        .into_iter()
        .filter_map(|i| snap.idol(&entries[i as usize].idol_id))
        .map(|idol| idol_row(snap, idol))
        .collect();
    Ok(listing("idols", total, rows))
}

// =============================================================================
// list_songs
// =============================================================================

fn list_songs(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::song_detail_queries::series_group_names;
    use crate::domain::song_list_queries::{
        song_list_indexes, song_list_sort_options_without_user_marks, songs_in_release_range,
        SongQuery,
    };
    use crate::domain::stats_queries::cd_series_list;

    let limit = args::limit(arguments, 30, 200)?;
    // 既定はアプリの曲一覧と同じ (ライブ履歴だけの曲と派生曲を隠す)。
    // ここを素の `SongListFilter::default()` にすると、一覧に無い曲まで数に入る。
    let mut query = SongQuery::default();

    if let Some(brand) = args::str_opt(arguments, "brand") {
        query.brand_ids = vec![checked("brand", brand, &brand_vocab(snap))?];
    }
    if let Some(song_type) = args::str_opt(arguments, "song_type") {
        query.song_type = Some(checked("song_type", song_type, &song_type_vocab(snap))?);
    }
    if let Some(idol_id) = args::str_opt(arguments, "idol_id") {
        if snap.idol(&idol_id).is_none() {
            return Err(ToolError::NotFound(format!("アイドル {idol_id} が無い")));
        }
        query.idol_ids = vec![idol_id];
    }
    if let Some(series) = args::str_opt(arguments, "cd_series") {
        let all = cd_series_list(snap);
        // cd_series は部分一致で当てるので、語彙との一致も部分一致で見る。
        if !all.iter().any(|s| s.contains(&series)) {
            return Err(ToolError::BadArgs(format!(
                "cd_series に「{series}」を含むシリーズは無い。取りうる値: {}",
                sample(&all)
            )));
        }
        query.cd_series = Some(series);
    }
    if let Some(group) = args::str_opt(arguments, "series_group") {
        query.series_group = Some(checked("series_group", group, &series_group_names(snap, &[]))?);
    }
    if let Some(text) = args::str_opt(arguments, "query") {
        query.title = Some(text);
    }
    let sort_keys: Vec<String> =
        song_list_sort_options_without_user_marks().into_iter().map(|o| o.key).collect();
    if let Some(sort) = args::str_opt(arguments, "sort") {
        query.sort = checked("sort", sort, &sort_keys)?;
    }

    let mut allow: Option<HashSet<u32>> = None;
    if let Some(unit_id) = args::str_opt(arguments, "unit_id") {
        if snap.unit(&unit_id).is_none() {
            return Err(ToolError::NotFound(format!("ユニット {unit_id} が無い")));
        }
        let ids = crate::domain::unit_queries::unit_song_ids(snap, &unit_id);
        narrow(&mut allow, ids.iter().filter_map(|id| snap.song_index_by_id.get(id).copied()));
    }
    let from = args::str_opt(arguments, "released_from")
        .map(|v| checked_date_bound("released_from", v))
        .transpose()?;
    let to = args::str_opt(arguments, "released_to")
        .map(|v| checked_date_bound("released_to", v))
        .transpose()?;
    if from.is_some() || to.is_some() {
        narrow(&mut allow, songs_in_release_range(snap, from.as_deref(), to.as_deref()));
    }

    let indexes: Vec<u32> = song_list_indexes(
        snap,
        &query.to_filter(),
        query.sort_order(),
        query.ascending,
        &[],
        &[],
    )
    .into_iter()
    .filter(|i| allow.as_ref().is_none_or(|ids| ids.contains(i)))
    .collect();

    let total = indexes.len();
    let rows = take(indexes, limit).into_iter().map(|i| song_row(snap, i)).collect();
    Ok(listing("songs", total, rows))
}

// =============================================================================
// list_events
// =============================================================================

fn list_events(snap: &Snapshot, arguments: &Value, today_key: &str) -> Result<Value, ToolError> {
    use crate::domain::event_grouping::year_key;
    use crate::domain::event_list_filtering::{
        filter_event_indices, EventFilterCriteria, EventFilterItem,
    };
    use crate::domain::event_list_queries::{event_ids_at_venue, events_with_first_date};

    let limit = args::limit(arguments, 30, 200)?;
    let brand = args::str_opt(arguments, "brand")
        .map(|b| checked("brand", b, &brand_vocab(snap)))
        .transpose()?;
    let kind = args::str_opt(arguments, "kind")
        .map(|k| checked("kind", k, &event_kind_vocab(snap)))
        .transpose()?;
    let when = args::str_opt(arguments, "when").unwrap_or_else(|| "all".to_string());
    if !matches!(when.as_str(), "upcoming" | "past" | "all") {
        return Err(ToolError::BadArgs("when は upcoming / past / all です".into()));
    }
    let venue = args::str_opt(arguments, "venue");
    let year = args::u32_opt(arguments, "year")?;

    // kind を明示しなければ全種別。`events_with_first_date` の既定 (live+festival) だと
    // 発売記念イベントが黙って消えるので、語彙から作った全種別を渡す。
    let kinds: Vec<String> = kind.into_iter().collect::<Vec<_>>();
    let kinds = if kinds.is_empty() { event_kind_vocab(snap) } else { kinds };
    let records = events_with_first_date(snap, None, true, false, Some(&kinds));

    let items: Vec<EventFilterItem> = records
        .iter()
        .map(|r| EventFilterItem {
            id: r.event.id.clone(),
            brand_id: r.event.brand_id.clone(),
            joint_brand_ids: r.event.joint_brand_ids.clone(),
            name: r.event.name.clone(),
            kind: r.event.kind.clone(),
        })
        .collect();
    let criteria = EventFilterCriteria {
        selected_brand_ids: brand.into_iter().collect(),
        excluded_kinds: Vec::new(),
        search_text: args::str_opt(arguments, "query").unwrap_or_default(),
        attendance_filter: "all".to_string(),
        attended_event_ids: Vec::new(),
        require_favorite: false,
        favorite_ids: Vec::new(),
        require_note: false,
        note_ids: Vec::new(),
        venue: venue.clone().unwrap_or_default(),
        venue_event_ids: venue.map(|v| event_ids_at_venue(snap, &v)).unwrap_or_default(),
    };

    let mut kept: Vec<u32> = filter_event_indices(&items, &criteria)
        .into_iter()
        .filter(|&i| {
            let record = &records[i as usize];
            year.is_none_or(|y| year_key(record.first_date.as_deref()) == Some(y.to_string()))
        })
        .filter(|&i| {
            let record = &records[i as usize];
            match when.as_str() {
                "upcoming" => is_upcoming(record.first_date.as_deref(), record.last_date.as_deref(), today_key),
                "past" => !is_upcoming(record.first_date.as_deref(), record.last_date.as_deref(), today_key),
                _ => true,
            }
        })
        .collect();
    // 元の並びは初日の降順 (新しい順)。今後の予定だけは「近い順」で読みたい。
    if when == "upcoming" {
        kept.reverse();
    }

    let total = kept.len();
    let rows = take(kept, limit)
        .into_iter()
        .map(|i| {
            let record = &records[i as usize];
            let index = snap.event_index_by_id[&record.event.id];
            let mut o = Map::new();
            o.insert("id".into(), json!(record.event.id));
            o.insert("name".into(), json!(record.event.name));
            put(&mut o, "brand", record.event.brand_id.clone());
            put(&mut o, "brand_name", brand_short_name(snap, record.event.brand_id.as_deref()));
            put(&mut o, "joint_brands", record.event.joint_brand_ids.clone());
            o.insert("kind".into(), json!(record.event.kind));
            put(&mut o, "first_date", record.first_date.clone());
            put(&mut o, "last_date", record.last_date.clone());
            let shows = &snap.shows_by_event[index as usize];
            o.insert("show_count".into(), json!(shows.len()));
            let venues: Vec<String> = distinct(
                shows.iter().map(|&s| snap.shows[s as usize].venue.as_deref()),
            );
            if !venues.is_empty() {
                o.insert("venues".into(), json!(venues));
            }
            o.insert(
                "upcoming".into(),
                json!(is_upcoming(
                    record.first_date.as_deref(),
                    record.last_date.as_deref(),
                    today_key
                )),
            );
            Value::Object(o)
        })
        .collect();
    Ok(listing("events", total, rows))
}

/// まだ終わっていないライブか。最終日で見る (初日が過ぎていても会期中なら「今後」)。
///
/// 日付が決まっていないイベントは「今後」に入れる — `event_grouping` の年グルーピングと
/// 同じ扱いで、日程未定は登録途中の予定であって開催済みではない。
fn is_upcoming(first_date: Option<&str>, last_date: Option<&str>, today_key: &str) -> bool {
    match last_date.or(first_date) {
        Some(date) => date >= today_key,
        None => true,
    }
}

// =============================================================================
// idol_songs
// =============================================================================

fn idol_songs(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::idol_song_queries::{idol_performed_songs, idol_unit_song_ids};

    let idol_id = args::str_req(arguments, "idol_id")?;
    let Some(idol) = snap.idol(&idol_id) else {
        return Err(ToolError::NotFound(format!("アイドル {idol_id} が無い")));
    };
    let limit = args::limit(arguments, 50, 300)?;
    let role = args::str_opt(arguments, "role").unwrap_or_else(|| "all".to_string());
    if !matches!(role.as_str(), "original" | "performed" | "all") {
        return Err(ToolError::BadArgs("role は original / performed / all です".into()));
    }

    let mut out = Map::new();
    out.insert("idol".into(), idol_row(snap, idol));

    if role != "performed" {
        // 原唱 (持ち歌)。song_artists.role='original' の行だけ。
        let originals = crate::domain::idol_song_queries::idol_songs(snap, &idol_id, Some("original"));
        let total = originals.len();
        let rows = take(originals, limit)
            .into_iter()
            .map(|r| {
                let mut o = Map::new();
                o.insert("id".into(), json!(r.song_id));
                o.insert("title".into(), json!(r.title));
                put(&mut o, "release_date", r.release_date);
                put(&mut o, "unit_name", r.unit_name);
                Value::Object(o)
            })
            .collect();
        out.insert("original".into(), listing("songs", total, rows));

        // ユニット名義の持ち歌 (songs.unit_id 由来)。個人の song_artists には
        // 出てこないことがあるので、原唱とは別立てで返す。
        let unit_ids = idol_unit_song_ids(snap, &idol_id);
        let total = unit_ids.len();
        let rows = take(unit_ids, limit)
            .into_iter()
            .filter_map(|id| snap.song_index_by_id.get(&id).copied())
            .map(|i| {
                let song = &snap.songs[i as usize];
                let mut o = Map::new();
                o.insert("id".into(), json!(song.id));
                o.insert("title".into(), json!(song.title));
                put(&mut o, "release_date", song.release_date.clone());
                put(&mut o, "unit_name", song.unit_name.clone());
                Value::Object(o)
            })
            .collect();
        out.insert("unit_songs".into(), listing("songs", total, rows));
    }

    if role != "original" {
        // ライブで歌った曲。持ち歌とは別物 (他人の曲を歌うことも、持ち歌を
        // 一度も歌っていないこともある)。
        let performed = idol_performed_songs(snap, &idol_id);
        let total = performed.len();
        let rows = take(performed, limit)
            .into_iter()
            .map(|r| {
                let mut o = Map::new();
                o.insert("id".into(), json!(r.song_id));
                o.insert("title".into(), json!(r.title));
                o.insert("perform_count".into(), json!(r.perform_count));
                put(&mut o, "unit_name", r.unit_name);
                Value::Object(o)
            })
            .collect();
        out.insert("performed".into(), listing("songs", total, rows));
    }

    Ok(Value::Object(out))
}

// =============================================================================
// song_performances
// =============================================================================

fn song_performances(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::setlist_lineup::{is_full_cast, summarize};
    use crate::domain::song_detail_queries::{
        performance_history, performance_item_indices, performance_ordinal_label,
    };

    let song_id = args::str_req(arguments, "song_id")?;
    let Some(&song_index) = snap.song_index_by_id.get(&song_id) else {
        return Err(ToolError::NotFound(format!("曲 {song_id} が無い")));
    };
    let limit = args::limit(arguments, 50, 500)?;

    let history = performance_history(snap, &song_id);
    let items = performance_item_indices(snap, &song_id).to_vec();
    let total = history.len();
    let originals = original_artist_ids(snap, song_index);

    let rows: Vec<Value> = history
        .into_iter()
        .zip(items)
        .take(limit as usize)
        .map(|(entry, item)| {
            let mut o = Map::new();
            o.insert("show_id".into(), json!(entry.show_id));
            o.insert("event_id".into(), json!(entry.event_id));
            o.insert("event_name".into(), json!(entry.event_name));
            o.insert("show_name".into(), json!(entry.show_name));
            o.insert("date".into(), json!(entry.date));
            put(&mut o, "venue", entry.venue);
            o.insert("position".into(), json!(entry.position));
            put(&mut o, "section", entry.section);
            o.insert("ordinal".into(), json!(entry.ordinal));
            o.insert("ordinal_label".into(), json!(performance_ordinal_label(entry.ordinal)));

            let performers: Vec<&str> = snap.performers_by_item[item as usize]
                .iter()
                .map(|&i| snap.idols[i as usize].id.as_str())
                .collect();
            let performer_set: BTreeSet<&str> = performers.iter().copied().collect();
            o.insert("singer_count".into(), json!(performers.len()));

            let show = snap.setlist_items[item as usize].show;
            let cast: BTreeSet<&str> = snap.cast_by_show[show as usize]
                .iter()
                .map(|l| snap.idols[l.idol as usize].id.as_str())
                .collect();
            let full_cast = is_full_cast(&cast, &performer_set);
            if full_cast {
                // 「出演者全員」で言い切れるなら名前は並べない。人数の多い全体曲で
                // 30 人ぶんの名前を毎回積むと、読む側の予算をそれだけで食い潰す。
                o.insert("full_cast".into(), json!(true));
            } else if !performers.is_empty() {
                let names: Vec<String> = snap.performers_by_item[item as usize]
                    .iter()
                    .map(|&i| snap.idols[i as usize].name.clone())
                    .collect();
                o.insert("singers".into(), json!(names));
            }
            if let Some(summary) = summarize(&originals, &performer_set, &cast, full_cast) {
                o.insert("lineup".into(), json!(summary.label()));
            }
            Value::Object(o)
        })
        .collect();

    let mut out = Map::new();
    out.insert("song".into(), song_row(snap, song_index));
    let listed = listing("performances", total, rows);
    if let Value::Object(map) = listed {
        for (k, v) in map {
            out.insert(k, v);
        }
    }
    Ok(Value::Object(out))
}

// =============================================================================
// setlist_diff
// =============================================================================

fn setlist_diff(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::setlist_diff::{compare_setlists, SetlistItemDiffRow};

    let a = show_index(snap, &args::str_req(arguments, "show_id_a")?)?;
    let b = show_index(snap, &args::str_req(arguments, "show_id_b")?)?;

    let rows_of = |show: u32| -> Vec<SetlistItemDiffRow> {
        snap.setlist_items_by_show[show as usize]
            .iter()
            .map(|&i| {
                let item = &snap.setlist_items[i as usize];
                SetlistItemDiffRow {
                    id: item.id.clone(),
                    song_id: snap.songs[item.song as usize].id.clone(),
                    position: item.position,
                    section: item.section.clone(),
                }
            })
            .collect()
    };
    let comparison = compare_setlists(&rows_of(a), &rows_of(b));

    let title = |song_id: &str| snap.song(song_id).map(|s| s.title.clone());
    let slot_rows = |slots: &[crate::domain::setlist_diff::SetlistSlot]| -> Vec<Value> {
        slots
            .iter()
            .map(|s| {
                let mut o = Map::new();
                o.insert("song_id".into(), json!(s.song_id));
                put(&mut o, "title", title(&s.song_id));
                o.insert("position".into(), json!(s.position));
                put(&mut o, "section", s.section.clone());
                Value::Object(o)
            })
            .collect()
    };

    let mut out = Map::new();
    out.insert("a".into(), show_header(snap, a));
    out.insert("b".into(), show_header(snap, b));
    out.insert("shared_count".into(), json!(comparison.shared.len()));
    out.insert("same_order".into(), json!(comparison.same_order));
    out.insert(
        "shared".into(),
        json!(comparison
            .shared
            .iter()
            .map(|s| {
                let mut o = Map::new();
                o.insert("song_id".into(), json!(s.song_id));
                put(&mut o, "title", title(&s.song_id));
                o.insert("position_a".into(), json!(s.position_a));
                o.insert("position_b".into(), json!(s.position_b));
                Value::Object(o)
            })
            .collect::<Vec<_>>()),
    );
    out.insert("only_a".into(), json!(slot_rows(&comparison.only_a)));
    out.insert("only_b".into(), json!(slot_rows(&comparison.only_b)));
    Ok(Value::Object(out))
}

fn show_index(snap: &Snapshot, show_id: &str) -> Result<u32, ToolError> {
    snap.show_index_by_id
        .get(show_id)
        .copied()
        .ok_or_else(|| ToolError::NotFound(format!("公演 {show_id} が無い")))
}

// =============================================================================
// stats
// =============================================================================

fn stats(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::stats_queries::{
        brand_song_counts, cast_show_count_ranking, cd_series_list, monthly_show_counts,
        song_play_count_ranking, yearly_show_counts,
    };

    let kind = args::str_req(arguments, "kind")?;
    if !STATS_KINDS.contains(&kind.as_str()) {
        return Err(ToolError::BadArgs(format!(
            "kind に「{kind}」は無い。取りうる値: {}",
            STATS_KINDS.join(" / ")
        )));
    }
    // ランキングは「上位いくつか」を見るもの、一覧系は全部見るもの。既定が違う。
    let ranking = matches!(kind.as_str(), "song_play_ranking" | "cast_show_ranking");
    let limit = args::limit(arguments, if ranking { 20 } else { 1000 }, 1000)?;

    let (total, rows): (usize, Vec<Value>) = match kind.as_str() {
        "song_play_ranking" => {
            let total = snap.performance_counts.iter().filter(|&&c| c > 0).count();
            let rows = song_play_count_ranking(snap, limit)
                .into_iter()
                .map(|r| {
                    let mut o = Map::new();
                    o.insert("id".into(), json!(r.id));
                    o.insert("title".into(), json!(r.title));
                    o.insert("play_count".into(), json!(r.play_count));
                    put(&mut o, "brand", r.brand_id.clone());
                    put(&mut o, "brand_name", brand_short_name(snap, r.brand_id.as_deref()));
                    Value::Object(o)
                })
                .collect();
            (total, rows)
        }
        "cast_show_ranking" => {
            let total = snap.cast_shows_by_idol.iter().filter(|s| !s.is_empty()).count();
            let rows = cast_show_count_ranking(snap, limit)
                .into_iter()
                .map(|r| json!({ "id": r.id, "name": r.name, "show_count": r.show_count }))
                .collect();
            (total, rows)
        }
        "brand_song_counts" => {
            let all = brand_song_counts(snap);
            let total = all.len();
            let rows = take(all, limit)
                .into_iter()
                .map(|r| json!({ "id": r.id, "name": r.short_name, "song_count": r.song_count }))
                .collect();
            (total, rows)
        }
        "yearly_show_counts" => {
            let all = yearly_show_counts(snap);
            let total = all.len();
            let rows = take(all, limit)
                .into_iter()
                .map(|r| json!({ "id": r.year, "year": r.year, "show_count": r.show_count }))
                .collect();
            (total, rows)
        }
        "monthly_show_counts" => {
            let all: Vec<(String, u32)> = monthly_show_counts(snap).into_iter().collect();
            let total = all.len();
            let rows = take(all, limit)
                .into_iter()
                .map(|(month, count)| json!({ "id": month, "month": month, "show_count": count }))
                .collect();
            (total, rows)
        }
        _ => {
            let all = cd_series_list(snap);
            let total = all.len();
            let rows =
                take(all, limit).into_iter().map(|name| json!({ "id": name, "name": name })).collect();
            (total, rows)
        }
    };

    let mut out = Map::new();
    out.insert("kind".into(), json!(kind));
    if let Value::Object(map) = listing("items", total, rows) {
        for (k, v) in map {
            out.insert(k, v);
        }
    }
    Ok(Value::Object(out))
}

// =============================================================================
// テスト
// =============================================================================

#[cfg(test)]
mod tests {
    use super::*;
    use crate::domain::agent_tools::call_tool;
    use crate::outbound::sqlite_loader::load_snapshot;
    use std::sync::OnceLock;

    fn db_path() -> String {
        format!("{}/../ImasLiveDB/Resources/master.sqlite", env!("CARGO_MANIFEST_DIR"))
    }

    /// スナップショットは全テストで共有 (不変なので安全・ロードを 1 回にする)。
    fn snap() -> &'static Snapshot {
        static SNAP: OnceLock<Snapshot> = OnceLock::new();
        SNAP.get_or_init(|| load_snapshot(&db_path()).expect("bundle DB はロードできる"))
    }

    const TODAY: &str = "2026-09-19";

    fn run(name: &str, arguments: Value) -> Value {
        call_tool(snap(), name, &arguments, TODAY)
            .unwrap_or_else(|e| panic!("{name} が失敗した: {e}"))
    }

    fn err(name: &str, arguments: Value) -> ToolError {
        call_tool(snap(), name, &arguments, TODAY).expect_err("エラーになるはず")
    }

    fn rows<'a>(value: &'a Value, key: &str) -> &'a Vec<Value> {
        value[key].as_array().unwrap_or_else(|| panic!("{key} が配列でない: {value}"))
    }

    fn text(value: &Value, key: &str) -> String {
        value[key].as_str().unwrap_or_else(|| panic!("{key} が文字列でない: {value}")).to_string()
    }

    // ---- カタログ ----

    #[test]
    fn カタログは_7_件で_スキーマは_json() {
        let all = catalog();
        assert_eq!(all.len(), 7);
        for tool in &all {
            let schema: Value = serde_json::from_str(&tool.input_schema)
                .unwrap_or_else(|e| panic!("{} のスキーマが JSON でない: {e}", tool.name));
            assert_eq!(schema["type"], "object", "{} のスキーマ", tool.name);
            assert!(!tool.description.is_empty(), "{} に説明が無い", tool.name);
        }
    }

    #[test]
    fn 全ツールが_call_で拾われる() {
        for tool in catalog() {
            assert!(
                call(snap(), &tool.name, &json!({}), TODAY).is_some(),
                "{} が dispatch から漏れている",
                tool.name
            );
        }
    }

    // ---- list_idols ----

    #[test]
    fn 七月生まれのアイドルを引いて文章が書ける() {
        let out = run("list_idols", json!({ "birth_month": 7, "limit": 200 }));
        let idols = rows(&out, "idols");
        assert!(idols.len() > 20, "7 月生まれが 20 人以下はおかしい: {}", idols.len());
        assert_eq!(out["total"].as_u64().unwrap() as usize, idols.len());

        // 返った 1 件だけで「誰が・どのブランドで・いつ生まれ」が書ける。
        let first = &idols[0];
        assert!(!text(first, "id").is_empty());
        assert!(!text(first, "name").is_empty());
        assert!(text(first, "birthday").starts_with("7月"), "誕生日が 7 月でない: {first}");
        assert!(first.get("brand_name").is_some(), "ブランド名が無い: {first}");

        // null のキーは出さない (年齢未設定のアイドルで確かめる)。
        for idol in idols {
            assert!(!idol.as_object().unwrap().values().any(Value::is_null), "null が混じった: {idol}");
        }
    }

    #[test]
    fn ブランドと誕生月は_and_で効く() {
        let all = run("list_idols", json!({ "birth_month": 7, "limit": 200 }));
        let cg = run("list_idols", json!({ "brand": "cg", "birth_month": 7, "limit": 200 }));
        assert!(cg["total"].as_u64().unwrap() > 0);
        assert!(cg["total"].as_u64().unwrap() < all["total"].as_u64().unwrap());
        for idol in rows(&cg, "idols") {
            assert_eq!(text(idol, "brand"), "cg");
            assert!(text(idol, "birthday").starts_with("7月"));
        }
    }

    #[test]
    fn 星座と血液型は正本の関数と同じ集合になる() {
        use crate::domain::idol_queries::idols_by_constellation;
        let out = run("list_idols", json!({ "constellation": "獅子座", "limit": 200 }));
        // 一覧は外部ゲストを含まないので「正本の結果に含まれる」ことを見る。
        let canonical: HashSet<String> =
            idols_by_constellation(snap(), "獅子座").into_iter().map(|r| r.id).collect();
        for idol in rows(&out, "idols") {
            assert!(canonical.contains(&text(idol, "id")), "正本に無い: {idol}");
        }
        assert!(out["total"].as_u64().unwrap() > 20);

        let blood = run("list_idols", json!({ "blood_type": "AB", "limit": 200 }));
        for idol in rows(&blood, "idols") {
            assert_eq!(text(idol, "blood_type"), "AB");
        }
    }

    #[test]
    fn 声優名でアイドルを引ける() {
        let out = run("list_idols", json!({ "voice_actor": "大橋彩香" }));
        let names: Vec<String> = rows(&out, "idols").iter().map(|i| text(i, "name")).collect();
        assert!(names.contains(&"島村卯月".to_string()), "大橋彩香 の担当に島村卯月がいない: {names:?}");
    }

    #[test]
    fn 並べ替えは正本の軸を使う() {
        let out = run("list_idols", json!({ "sort": "height", "limit": 5 }));
        let heights: Vec<String> = rows(&out, "idols").iter().map(|i| text(i, "height")).collect();
        assert_eq!(heights.len(), 5);
        // 既定方向は降順 (高い順)。
        let cm = |s: &String| s.trim_end_matches("cm").parse::<f64>().unwrap();
        assert!(heights.windows(2).all(|w| cm(&w[0]) >= cm(&w[1])), "高い順でない: {heights:?}");
    }

    #[test]
    fn 語彙外のブランドは候補つきで弾く() {
        let e = err("list_idols", json!({ "brand": "cinderella" }));
        let ToolError::BadArgs(message) = e else { panic!("BadArgs でない") };
        assert!(message.contains("cinderella"), "{message}");
        assert!(message.contains("cg"), "取りうる値が並んでいない: {message}");
    }

    #[test]
    fn 誕生月の範囲外は弾く() {
        assert!(matches!(err("list_idols", json!({ "birth_month": 13 })), ToolError::BadArgs(_)));
    }

    // ---- list_songs ----

    #[test]
    fn シンデレラガールズのユニット曲をリリース順で引ける() {
        let out = run(
            "list_songs",
            json!({ "brand": "cg", "song_type": "unit", "sort": "release", "limit": 5 }),
        );
        let songs = rows(&out, "songs");
        assert_eq!(songs.len(), 5);
        assert!(out["truncated"].as_bool().unwrap());
        assert!(out["total"].as_u64().unwrap() > 100);

        let dates: Vec<String> = songs.iter().map(|s| text(s, "release_date")).collect();
        assert!(dates.windows(2).all(|w| w[0] >= w[1]), "新しい順でない: {dates:?}");
        for song in songs {
            assert_eq!(text(song, "song_type"), "unit");
            assert!(song["performance_count"].is_number());
            assert!(song["artist_count"].is_number());
        }
    }

    #[test]
    fn リリース日の範囲は粗い指定でもその年を丸ごと含む() {
        let out = run(
            "list_songs",
            json!({ "released_from": "2024", "released_to": "2024", "limit": 200 }),
        );
        let songs = rows(&out, "songs");
        assert!(!songs.is_empty());
        for song in songs {
            assert!(text(song, "release_date").starts_with("2024"), "{song}");
        }
    }

    #[test]
    fn 原唱者で絞ると全体曲まで含めて引ける() {
        // 島村卯月の持ち歌 (song_artists.role='original')。
        let out = run("list_songs", json!({ "idol_id": "cg_島村卯月", "limit": 200 }));
        assert!(out["total"].as_u64().unwrap() > 10, "{out}");
        let titles: Vec<String> = rows(&out, "songs").iter().map(|s| text(s, "title")).collect();
        assert!(titles.iter().any(|t| t.starts_with("S(mile)ING")), "持ち歌が引けていない: {titles:?}");
    }

    #[test]
    fn 原唱者が多い曲は名前を並べず人数だけ返す() {
        let out = run("list_songs", json!({ "song_type": "all", "limit": 200 }));
        let many = rows(&out, "songs")
            .iter()
            .find(|s| s["artist_count"].as_u64().unwrap() > 10)
            .expect("原唱者 11 人以上の全体曲がある");
        assert!(many.get("artists").is_none(), "人数が多いのに名前を並べている: {many}");

        let few = rows(&out, "songs")
            .iter()
            .find(|s| (1..=10).contains(&s["artist_count"].as_u64().unwrap()));
        if let Some(few) = few {
            assert!(few.get("artists").is_some(), "人数が少ないのに名前が無い: {few}");
        }
    }

    #[test]
    fn 知らない_cd_シリーズは候補つきで弾く() {
        let e = err("list_songs", json!({ "cd_series": "存在しないシリーズ名" }));
        let ToolError::BadArgs(message) = e else { panic!("BadArgs でない") };
        assert!(message.contains("取りうる値"), "{message}");
    }

    #[test]
    fn リリース日の書式違いは弾く() {
        assert!(matches!(
            err("list_songs", json!({ "released_from": "2024/01/01" })),
            ToolError::BadArgs(_)
        ));
    }

    // ---- list_events ----

    #[test]
    fn シンデレラガールズの_2024_年のライブを引いて文章が書ける() {
        let out = run("list_events", json!({ "brand": "cg", "year": 2024, "limit": 50 }));
        let events = rows(&out, "events");
        assert!(events.len() >= 8, "2024 年の cg のライブが少なすぎる: {}", events.len());

        let names: Vec<String> = events.iter().map(|e| text(e, "name")).collect();
        assert!(
            names.iter().any(|n| n.contains("ConnecTrip")),
            "ConnecTrip! が入っていない: {names:?}"
        );
        for event in events {
            assert!(text(event, "first_date").starts_with("2024"), "{event}");
            assert!(event["show_count"].as_u64().unwrap() >= 1);
            // 会場まで返るので「どこで何公演やったか」がこの 1 回で書ける。
            assert!(event.get("venues").is_some(), "会場が無い: {event}");
        }
    }

    #[test]
    fn 会場で引くと読みでも旧名でも当たる() {
        let ids = |out: &Value| -> HashSet<String> {
            out["events"].as_array().unwrap().iter().map(|e| text(e, "id")).collect()
        };
        let kanji = ids(&run("list_events", json!({ "venue": "横浜アリーナ", "limit": 200 })));
        let kana = ids(&run("list_events", json!({ "venue": "よこはまありーな", "limit": 200 })));
        assert!(kanji.len() > 3, "横浜アリーナのライブが少なすぎる: {}", kanji.len());
        // 読みは会場マスタ経由なので、`venue_id` を持たない古い公演のぶんだけ少なくなる。
        // そこは生文字列でしか引きようがない (会場マスタに無いものの読みは持てない)。
        assert!(!kana.is_empty(), "読みで 0 件 = 会場マスタの綴りを見ていない");
        assert!(kana.is_subset(&kanji), "読みでしか当たらないライブがある: {kana:?}");
    }

    #[test]
    fn 今後と過去は今日を境に分かれる() {
        let past = run("list_events", json!({ "when": "past", "limit": 200 }));
        let upcoming = run("list_events", json!({ "when": "upcoming", "limit": 200 }));
        let all = run("list_events", json!({ "when": "all", "limit": 1 }));
        assert_eq!(
            past["total"].as_u64().unwrap() + upcoming["total"].as_u64().unwrap(),
            all["total"].as_u64().unwrap(),
            "今後と過去が全体の分割になっていない"
        );
        for event in rows(&past, "events") {
            assert!(!event["upcoming"].as_bool().unwrap());
        }
        // 過去は新しい順。
        let dates: Vec<String> = rows(&past, "events").iter().map(|e| text(e, "first_date")).collect();
        assert!(dates.windows(2).all(|w| w[0] >= w[1]), "新しい順でない: {:?}", &dates[..5]);
    }

    #[test]
    fn 種別を指定しなければ発売記念イベントも入る() {
        let all = run("list_events", json!({ "limit": 1 }));
        let live = run("list_events", json!({ "kind": "live", "limit": 1 }));
        let release = run("list_events", json!({ "kind": "release_event", "limit": 1 }));
        assert!(release["total"].as_u64().unwrap() > 0);
        assert!(all["total"].as_u64().unwrap() > live["total"].as_u64().unwrap());
    }

    // ---- idol_songs ----

    #[test]
    fn 持ち歌とライブで歌った曲は別に返る() {
        let out = run("idol_songs", json!({ "idol_id": "cg_島村卯月", "limit": 300 }));
        assert_eq!(text(&out["idol"], "name"), "島村卯月");
        let original = out["original"]["total"].as_u64().unwrap();
        let performed = out["performed"]["total"].as_u64().unwrap();
        assert!(original > 0 && performed > 0);
        assert_ne!(original, performed, "原唱と披露が同数 = どちらかを取り違えている疑い");

        // ライブで歌った側には回数が付く (「何回歌ったか」を追加の往復なしで書ける)。
        assert!(rows(&out["performed"], "songs")[0]["perform_count"].as_u64().unwrap() >= 1);
        // ユニット名義の持ち歌も別立てで返る。
        assert!(out["unit_songs"].is_object());
    }

    #[test]
    fn role_で区分を絞れる() {
        let original = run("idol_songs", json!({ "idol_id": "cg_島村卯月", "role": "original" }));
        assert!(original.get("performed").is_none());
        let performed = run("idol_songs", json!({ "idol_id": "cg_島村卯月", "role": "performed" }));
        assert!(performed.get("original").is_none());
    }

    #[test]
    fn 知らないアイドルは_not_found() {
        assert!(matches!(
            err("idol_songs", json!({ "idol_id": "存在しないアイドル" })),
            ToolError::NotFound(_)
        ));
        assert!(matches!(err("idol_songs", json!({})), ToolError::BadArgs(_)));
    }

    // ---- song_performances ----

    #[test]
    fn 披露履歴から公演と歌唱者が書ける() {
        // 披露回数の多い曲を実データから選ぶ (id をテストに焼き付けない)。
        let ranking = run("stats", json!({ "kind": "song_play_ranking", "limit": 1 }));
        let song_id = text(&rows(&ranking, "items")[0], "id");

        let out = run("song_performances", json!({ "song_id": song_id, "limit": 10 }));
        let performances = rows(&out, "performances");
        assert_eq!(performances.len(), 10);
        assert!(out["truncated"].as_bool().unwrap());
        assert_eq!(out["total"].as_u64().unwrap(), out["song"]["performance_count"].as_u64().unwrap());

        // 新しい順。
        let dates: Vec<String> = performances.iter().map(|p| text(p, "date")).collect();
        assert!(dates.windows(2).all(|w| w[0] >= w[1]), "新しい順でない: {dates:?}");

        for p in performances {
            assert!(!text(p, "event_name").is_empty());
            assert!(text(p, "ordinal_label").ends_with("回目") || text(p, "ordinal_label") == "初披露");
            assert!(p["singer_count"].is_number());
            // 全員で歌った回は名前を並べず full_cast で示す。
            assert!(
                p.get("full_cast").is_some() || p.get("singers").is_some() || p["singer_count"] == json!(0),
                "歌唱者の情報が無い: {p}"
            );
        }
    }

    #[test]
    fn 初披露は_1_回目でなく初披露と呼ぶ() {
        let ranking = run("stats", json!({ "kind": "song_play_ranking", "limit": 1 }));
        let song_id = text(&rows(&ranking, "items")[0], "id");
        let out = run("song_performances", json!({ "song_id": song_id, "limit": 500 }));
        let oldest = rows(&out, "performances").last().unwrap().clone();
        assert_eq!(oldest["ordinal"], json!(1));
        assert_eq!(text(&oldest, "ordinal_label"), "初披露");
    }

    // ---- setlist_diff ----

    #[test]
    fn 同じ公演どうしの比較は完全一致になる() {
        let show_id = snap().shows_in_date_order.last().map(|&i| snap().shows[i as usize].id.clone()).unwrap();
        let out = run("setlist_diff", json!({ "show_id_a": show_id, "show_id_b": show_id }));
        assert!(rows(&out, "only_a").is_empty());
        assert!(rows(&out, "only_b").is_empty());
        assert!(out["same_order"].as_bool().unwrap());
    }

    #[test]
    fn 別の公演を比べると共通曲と片方だけの曲が出る() {
        // 同じツアーの 2 公演 (ConnecTrip! の大阪と東京) を比べる。
        let a = tour_show("ev_the_idolmster_cinderella_girls_unit_live_tour_connectrip_大阪公演");
        let b = tour_show("ev_the_idolmster_cinderella_girls_unit_live_tour_connectrip_東京公演");
        let out = run("setlist_diff", json!({ "show_id_a": a, "show_id_b": b }));

        assert!(out["shared_count"].as_u64().unwrap() > 0, "同じツアーで共通曲が 0: {out}");
        let shared = rows(&out, "shared");
        for song in shared {
            assert!(!text(song, "title").is_empty(), "曲名が解決できていない: {song}");
            assert!(song["position_a"].is_number() && song["position_b"].is_number());
        }
        // 片方だけの曲にも曲名が付く (id だけ返して呼び直させない)。
        for song in rows(&out, "only_a").iter().chain(rows(&out, "only_b")) {
            assert!(song.get("title").is_some(), "{song}");
        }
        assert!(out["a"]["date"].is_string() && out["b"]["date"].is_string());
    }

    /// イベント id からその配下の最初の公演 id を取る (テストの下ごしらえ)。
    fn tour_show(event_id: &str) -> String {
        let index = snap().event_index_by_id[event_id];
        let show = snap().shows_by_event[index as usize][0];
        snap().shows[show as usize].id.clone()
    }

    #[test]
    fn 知らない公演は_not_found() {
        assert!(matches!(
            err("setlist_diff", json!({ "show_id_a": "show_無い", "show_id_b": "show_無い" })),
            ToolError::NotFound(_)
        ));
    }

    // ---- stats ----

    #[test]
    fn 全種別の集計が引ける() {
        for kind in STATS_KINDS {
            let out = run("stats", json!({ "kind": kind }));
            assert_eq!(text(&out, "kind"), kind);
            let items = rows(&out, "items");
            assert!(!items.is_empty(), "{kind} が空");
            for item in items {
                assert!(item.get("id").is_some(), "{kind} の行に id が無い: {item}");
            }
        }
    }

    #[test]
    fn 披露回数ランキングは多い順で総数も返る() {
        let out = run("stats", json!({ "kind": "song_play_ranking", "limit": 5 }));
        let items = rows(&out, "items");
        assert_eq!(items.len(), 5);
        let counts: Vec<u64> = items.iter().map(|i| i["play_count"].as_u64().unwrap()).collect();
        assert!(counts.windows(2).all(|w| w[0] >= w[1]), "多い順でない: {counts:?}");
        // 「何曲が披露されたことがあるか」に答えられる。
        assert!(out["total"].as_u64().unwrap() > 1000);
        assert!(out["truncated"].as_bool().unwrap());
    }

    #[test]
    fn 語彙外の集計種別は取りうる値を並べて返す() {
        let ToolError::BadArgs(message) = err("stats", json!({ "kind": "何か" })) else {
            panic!("BadArgs でない")
        };
        for kind in STATS_KINDS {
            assert!(message.contains(kind), "{kind} が候補に無い: {message}");
        }
    }

    // ---- 歌詞は載せない ----

    #[test]
    fn 歌詞本文を返す経路が無い() {
        let out = run("list_songs", json!({ "limit": 50 }));
        for song in rows(&out, "songs") {
            for key in song.as_object().unwrap().keys() {
                assert!(!key.contains("lyric"), "歌詞の欄が混じった: {key}");
            }
        }
    }

    /// 共有 CARGO_TARGET_DIR の成果物混入の回帰ガード (他の domain テストと同型)。
    #[test]
    fn test_binary_was_built_from_this_tree() {
        let baked = include_str!("browse.rs");
        let path = concat!(env!("CARGO_MANIFEST_DIR"), "/src/domain/agent_tools/browse.rs");
        let on_disk = std::fs::read_to_string(path).unwrap_or_else(|e| {
            panic!("ビルド元ツリーの {path} を読めない = 陳腐化した成果物で検証している: {e}")
        });
        assert!(baked == on_disk, "ビルド元とディスク上の {path} が不一致 = 陳腐化した成果物で検証している");
    }
}
