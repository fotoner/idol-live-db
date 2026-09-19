//! 「こんな公演があったらどんなセトリになるか」を**呼び手が考えるための材料**
//! (list_shows・setlist_shape・song_position_profile・co_performed_songs)。
//!
//! # ここに予想は書かない
//!
//! 返すのは過去の事実だけ。「この曲が来そう」のスコアも、枠ごとの重みづけも持たない。
//! 予想を Rust に埋めると、外れたときに直す先が無く、DB が予想を持っているように
//! 見える。予想は、この 4 本が返した事実を読んだ LLM が組み立てる。
//!
//! # なぜ browse から分けたか
//!
//! `list_shows` だけなら `browse` に置いてもよかったが、`setlist_shape` は
//! **`list_shows` とまったく同じ軸で公演を絞る**必要がある (「翼が lead の公演の型」は
//! 「翼が lead の公演の一覧」と同じ集合でなければ意味が無い)。2 ファイルに割ると
//! 絞り込みが export 越しになるか、写経になる。同じ絞り込みを共有する 4 本を
//! 1 ファイルに置き、[`narrow_shows`] をこの中の唯一の入口にする。
//!
//! # 規則は借りる
//!
//! - 公演の絞り込み (brand / year / venue) は `browse::scoped_show_indexes`
//!   (中身は `event_list_filtering` / `event_list_queries` が正本。会場は読み・旧名でも当たる)
//! - 今後/過去は `event_grouping::is_upcoming_on`
//! - 「誰がいたか」は `event_detail_queries::show_presence` (出演者表 ∪ 歌唱メンバー)
//! - 型の計算そのものは `domain::setlist_shape`、共起は `domain::performance_stats`
//!
//! このファイルが持つのは引数のほどき方と JSON の組み方だけ。

use super::json::{brand_ref, listing, listing_with, Obj};
use super::{args, ToolError, ToolSpec};
use crate::domain::event_detail_queries::show_presence;
use crate::domain::event_grouping::is_upcoming_on;
use crate::domain::setlist_shape as shape;
use crate::domain::snapshot::Snapshot;
use serde_json::{json, Value};
use std::collections::BTreeSet;

/// 枠ごとのランキングを何件まで並べるか。主演公演が 6 件しかない以上、
/// 上位 8 件も並べれば「1 回だけ来た曲」まで見えるので十分。
const SLOT_TOP: usize = 8;

// =============================================================================
// カタログ
// =============================================================================

pub fn catalog() -> Vec<ToolSpec> {
    vec![
        spec(
            "list_shows",
            "条件で公演 (1 日ぶん) を並べる。list_events はライブ単位なので\
             「出演者が 13 人の公演」「あの人が主演だった公演」は引けない — そのときはこちら。\
             idol_id と cast_role を組み合わせると「その人が lead (主演) だった公演」が出る。",
            show_scope_schema(json!({
                "has_setlist": { "type": "boolean", "description": "セトリが入っている公演だけ / 入っていない公演だけ。" },
                "limit": { "type": "integer", "description": "既定 30・最大 200。" }
            })),
        ),
        spec(
            "setlist_shape",
            "公演群のセトリの「型」。曲数・区切りごとの曲数・1 曲目 / アンコール / 締めに\
             来やすい曲・ソロ枠の本数を、指定した公演の集合について返す。\
             絞り込みの軸は list_shows と同じ。\
             **これは予想ではなく過去の実績**で、標本にした公演数 (shows) が必ず添うので、\
             少ない標本から出た数字かどうかは呼び手が見て判断すること。",
            show_scope_schema(json!({
                "top": { "type": "integer", "description": "枠ごとのランキング件数。既定 8・最大 30。" }
            })),
        ),
        spec(
            "song_position_profile",
            "ある曲が公演の「どこで」歌われるか。披露回数のうち 1 曲目・締め・アンコールが\
             何回か、区切り別の回数、公演内の相対位置 (序盤 / 中盤 / 終盤) の分布を返す。\
             song_performances が 1 回ずつの履歴を返すのに対し、こちらは位置の傾向をまとめる。",
            json!({
                "song_id": { "type": "string", "description": "曲の id。" }
            }),
        ),
        spec(
            "co_performed_songs",
            "同じ公演で一緒に歌われやすい曲。together が一緒に来た公演数、\
             performances が相手の曲の総披露公演数 (分母)。1 公演で 2 回歌われても 1 と数える。",
            json!({
                "song_id": { "type": "string", "description": "曲の id。" },
                "limit": { "type": "integer", "description": "既定 20・最大 100。" }
            }),
        ),
    ]
}

/// 自分の持ちツールなら `Some(結果)`、違うなら `None` (呼び手が次を試す)。
pub fn call(
    snap: &Snapshot,
    name: &str,
    arguments: &Value,
    today_key: &str,
) -> Option<Result<Value, ToolError>> {
    Some(match name {
        "list_shows" => list_shows(snap, arguments, today_key),
        "setlist_shape" => setlist_shape(snap, arguments, today_key),
        "song_position_profile" => song_position_profile(snap, arguments),
        "co_performed_songs" => co_performed_songs(snap, arguments),
        _ => return None,
    })
}

fn spec(name: &str, description: &str, properties: Value) -> ToolSpec {
    let required: &[&str] = match name {
        "song_position_profile" | "co_performed_songs" => &["song_id"],
        _ => &[],
    };
    ToolSpec {
        name: name.to_string(),
        description: description.to_string(),
        input_schema: super::tool_schema(properties, required),
    }
}

/// `list_shows` と `setlist_shape` が共有する軸。**スキーマも 1 箇所で書く** —
/// 説明文が 2 つに割れると、同じ `cast_role` の意味が 2 通りに書かれる。
fn show_scope_schema(extra: Value) -> Value {
    let mut props = json!({
        "brand": { "type": "string", "description": "ブランド id (例 ml / cg)。合同ライブは参加ブランドどれでも当たる。" },
        "year": { "type": "integer", "description": "公演日の年。" },
        "venue": { "type": "string", "description": "会場名。読み・旧名でも当たる。" },
        "kind": { "type": "string", "description": "親イベントの種別 (live / festival / release_event)。発売記念イベントを外したいときに使う。" },
        "event_id": { "type": "string", "description": "親イベント (ライブ) の id。" },
        "idol_id": { "type": "string", "description": "その人が出ていた公演だけ。cast_role と併せると役割まで絞れる。" },
        "cast_role": { "type": "string", "description": "出演の役割 (lead = 主演 / member)。idol_id が無ければ「その役割の人がいた公演」。" },
        "min_cast": { "type": "integer", "description": "出演者数の下限。" },
        "max_cast": { "type": "integer", "description": "出演者数の上限。少人数公演を探すときに使う。" },
        "when": { "type": "string", "enum": ["upcoming", "past", "all"], "description": "既定 all。upcoming は近い順、それ以外は新しい順。" }
    });
    if let (Some(base), Some(add)) = (props.as_object_mut(), extra.as_object()) {
        for (k, v) in add {
            base.insert(k.clone(), v.clone());
        }
    }
    props
}

// =============================================================================
// 公演の絞り込み (この 2 本の唯一の入口)
// =============================================================================

/// 軸で公演を絞る。並びは日付順 (`when=upcoming` なら近い順、それ以外は新しい順)。
///
/// brand / year / venue は `browse` の既存の絞り込みをそのまま通す
/// (`stats --kind show_song_count_ranking` と同じ集合になる)。ここが足すのは
/// 公演そのものの軸 — 親イベント・出演者・役割・人数・今後/過去。
fn narrow_shows(snap: &Snapshot, arguments: &Value, today_key: &str) -> Result<Vec<u32>, ToolError> {
    use super::browse::{checked, event_kind_vocab, scoped_show_indexes};

    let mut shows = scoped_show_indexes(snap, arguments)?;

    // 種別は親イベントが持つ。発売記念イベント (2 曲のミニステージ) が混ざったまま
    // 型を取ると曲数の中央値が本公演の 1/4 になるので、外せる軸を用意する。
    if let Some(kind) = args::str_opt(arguments, "kind") {
        let kind = checked("kind", kind, &event_kind_vocab(snap))?;
        shows.retain(|&s| snap.events[snap.shows[s as usize].event as usize].kind == kind);
    }

    if let Some(event_id) = args::str_opt(arguments, "event_id") {
        let Some(&event) = snap.event_index_by_id.get(&event_id) else {
            return Err(ToolError::NotFound(format!("ライブ {event_id} が無い")));
        };
        shows.retain(|&s| snap.shows[s as usize].event == event);
    }

    // 役割は show_cast の実在値が語彙 (定数で持つと 'guest' が増えた日に古くなる)。
    let role = args::str_opt(arguments, "cast_role")
        .map(|r| checked("cast_role", r, &cast_role_vocab(snap)))
        .transpose()?;
    let idol = args::str_opt(arguments, "idol_id")
        .map(|id| {
            snap.idol_index_by_id
                .get(&id)
                .copied()
                .ok_or_else(|| ToolError::NotFound(format!("アイドル {id} が無い")))
        })
        .transpose()?;

    match (idol, role.as_deref()) {
        // その人がその役割だった公演。
        (Some(i), Some(r)) => shows.retain(|&s| snap.show_cast_role(s, i) == Some(r)),
        // その人がいた公演。「いた」の定義は show_presence が正本
        // (出演者表が未入力で歌唱だけ入っている公演があるので、show_cast だけでは足りない)。
        (Some(i), None) => shows.retain(|&s| show_presence(snap, s).contains(&i)),
        // その役割の人がいた公演 (= 主演公演そのものを探すとき)。
        (None, Some(r)) => {
            shows.retain(|&s| snap.cast_by_show[s as usize].iter().any(|l| l.cast_role == r))
        }
        (None, None) => {}
    }

    let min_cast = args::u32_opt(arguments, "min_cast")?;
    let max_cast = args::u32_opt(arguments, "max_cast")?;
    if min_cast.is_some() || max_cast.is_some() {
        shows.retain(|&s| {
            let n = show_presence(snap, s).len() as u32;
            min_cast.is_none_or(|m| n >= m) && max_cast.is_none_or(|m| n <= m)
        });
    }

    if arguments.get("has_setlist").is_some_and(|v| !v.is_null()) {
        let want = args::bool_or(arguments, "has_setlist", true)?;
        shows.retain(|&s| !snap.setlist_items_by_show[s as usize].is_empty() == want);
    }

    let when = args::str_opt(arguments, "when").unwrap_or_else(|| "all".to_string());
    if !matches!(when.as_str(), "upcoming" | "past" | "all") {
        return Err(ToolError::BadArgs("when は upcoming / past / all です".into()));
    }
    if when != "all" {
        let want_upcoming = when == "upcoming";
        shows.retain(|&s| is_upcoming_on(&snap.shows[s as usize].date, today_key) == want_upcoming);
    }

    // 日付で並べる。同日は公演の添字で決定的に (ロード時に date/sort_order 順)。
    shows.sort_by(|&a, &b| {
        let (x, y) = (&snap.shows[a as usize], &snap.shows[b as usize]);
        x.date.cmp(&y.date).then(a.cmp(&b))
    });
    // これから来る予定は近い順、過去は新しい順 (list_events と同じ読み方)。
    if when != "upcoming" {
        shows.reverse();
    }
    Ok(shows)
}

/// `cast_role` の取りうる値。語彙はデータそのものから作る。
fn cast_role_vocab(snap: &Snapshot) -> Vec<String> {
    let set: BTreeSet<&str> = snap
        .cast_by_show
        .iter()
        .flat_map(|links| links.iter().map(|l| l.cast_role.as_str()))
        .filter(|r| !r.is_empty())
        .collect();
    set.into_iter().map(str::to_string).collect()
}

// =============================================================================
// list_shows
// =============================================================================

fn list_shows(snap: &Snapshot, arguments: &Value, today_key: &str) -> Result<Value, ToolError> {
    use super::browse::{show_header, take};

    let limit = args::limit(arguments, 30, 200)?;
    let shows = narrow_shows(snap, arguments, today_key)?;
    let total = shows.len();

    let rows = take(shows, limit)
        .into_iter()
        .map(|s| {
            let show = &snap.shows[s as usize];
            let event = &snap.events[show.event as usize];
            let mut o = Obj::new();
            // 「どの公演か」の書き方は browse と共通 (同じ鍵で同じ意味になる)。
            if let Value::Object(header) = show_header(snap, s) {
                for (k, v) in header {
                    o.put(&k, v);
                }
            }
            o.put("id", json!(show.id));
            o.opt("brand", brand_ref(snap, event.brand_id.as_deref()));
            o.put("cast_count", json!(show_presence(snap, s).len()));
            // 主演は数が少ないので名前まで出す (これが出れば「主演公演だったか」が
            // 一覧を見るだけで分かり、公演ごとに get_show を呼ばずに済む)。
            o.list("lead", role_names(snap, s, "lead"));
            o.put("upcoming", json!(is_upcoming_on(&show.date, today_key)));
            o.value()
        })
        .collect();
    Ok(listing("shows", total, rows))
}

/// その公演でその役割だった人の名前。並びは `cast_by_show` の前計算順。
fn role_names(snap: &Snapshot, show: u32, role: &str) -> Vec<Value> {
    snap.cast_by_show[show as usize]
        .iter()
        .filter(|l| l.cast_role == role)
        .map(|l| {
            let idol = &snap.idols[l.idol as usize];
            let mut o = Obj::new();
            o.put("id", idol.id.as_str());
            o.put("name", idol.name.as_str());
            o.value()
        })
        .collect()
}

// =============================================================================
// setlist_shape
// =============================================================================

fn setlist_shape(snap: &Snapshot, arguments: &Value, today_key: &str) -> Result<Value, ToolError> {
    // `limit` ではなく `top` で受ける (一覧の件数ではなく「枠ごとの上位いくつ」なので、
    // 同じ鍵にすると list_shows の limit と意味が混ざる)。
    let top = args::u32_opt(arguments, "top")?
        .filter(|&n| n > 0)
        .map_or(SLOT_TOP, |n| (n as usize).min(30));
    let shows = narrow_shows(snap, arguments, today_key)?;
    let s = shape::setlist_shape(snap, &shows, top);

    let mut o = Obj::new();
    o.put("shows", json!(s.shows));
    // 0 でも載せる。落とすと「条件に当たった公演は全部セトリがあった」と読める。
    o.put("shows_without_setlist", json!(s.shows_without_setlist));
    // どの公演を標本にしたかを言えないと、数字の当否を呼び手が確かめられない。
    o.list(
        "sampled_shows",
        shows
            .iter()
            .filter(|&&x| !snap.setlist_items_by_show[x as usize].is_empty())
            .map(|&x| {
                let show = &snap.shows[x as usize];
                let mut r = Obj::new();
                r.put("id", show.id.as_str());
                r.put("date", show.date.as_str());
                r.put("name", show.name.as_str());
                r.value()
            })
            .collect(),
    );
    o.opt("song_count", s.song_count.as_ref().map(spread_json));
    o.list(
        "sections",
        s.sections
            .iter()
            .map(|sec| {
                let mut r = Obj::new();
                // 区切り無し (= 本編) は label ごと落とす。`null` を載せない規約どおり。
                o_label(&mut r, sec.label.as_deref());
                r.put("shows", json!(sec.shows));
                r.put("songs", spread_json(&sec.songs));
                r.value()
            })
            .collect(),
    );
    o.list("openers", slot_rows(snap, &s.openers));
    o.list("encore", slot_rows(snap, &s.encore));
    o.list("closers", slot_rows(snap, &s.closers));
    o.opt("solo_slots", s.solo_slots.as_ref().map(spread_json));
    Ok(o.value())
}

fn o_label(o: &mut Obj, label: Option<&str>) {
    o.opt("label", label.map(str::to_string));
}

fn spread_json(s: &shape::Spread) -> Value {
    let mut o = Obj::new();
    o.put("samples", json!(s.samples));
    o.put("min", json!(s.min));
    o.put("median", json!(s.median));
    o.put("max", json!(s.max));
    o.value()
}

fn slot_rows(snap: &Snapshot, rows: &[shape::SlotTally]) -> Vec<Value> {
    rows.iter()
        .map(|t| {
            let mut o = Obj::new();
            o.put("id", t.song_id.as_str());
            o.opt("title", snap.song(&t.song_id).map(|s| s.title.clone()));
            o.put("times", json!(t.times));
            o.value()
        })
        .collect()
}

// =============================================================================
// song_position_profile
// =============================================================================

fn song_position_profile(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    let song_id = args::str_req(arguments, "song_id")?;
    let Some(&index) = snap.song_index_by_id.get(&song_id) else {
        return Err(ToolError::NotFound(format!("曲 {song_id} が無い")));
    };
    let p = shape::song_position_profile(snap, &song_id);

    let mut o = Obj::new();
    o.put("song", super::browse::song_row(snap, index));
    o.put("performances", json!(p.performances));
    o.put("opener", json!(p.opener));
    o.put("closer", json!(p.closer));
    o.put("encore", json!(p.encore));
    o.list(
        "sections",
        p.sections
            .iter()
            .map(|(label, times)| {
                let mut r = Obj::new();
                o_label(&mut r, label.as_deref());
                r.put("times", json!(times));
                r.value()
            })
            .collect(),
    );
    // 序盤 / 中盤 / 終盤。公演ごとに曲数が違う (1〜34 曲) ので、生の曲順ではなく
    // 曲数で正規化した 3 等分。割り方は domain::setlist_shape::Phase が正本。
    let mut phase = Obj::new();
    phase.put("early", json!(p.early));
    phase.put("middle", json!(p.middle));
    phase.put("late", json!(p.late));
    o.put("position", phase.value());
    Ok(o.value())
}

// =============================================================================
// co_performed_songs
// =============================================================================

fn co_performed_songs(snap: &Snapshot, arguments: &Value) -> Result<Value, ToolError> {
    use crate::domain::performance_stats::CoOccurIndex;

    let song_id = args::str_req(arguments, "song_id")?;
    let Some(&index) = snap.song_index_by_id.get(&song_id) else {
        return Err(ToolError::NotFound(format!("曲 {song_id} が無い")));
    };
    let limit = args::limit(arguments, 20, 100)?;

    // 計算は performance_stats が正本。ここは呼ぶだけ (新しい数え方を書かない)。
    let index_built = CoOccurIndex::build(snap);
    // 総数を返すために打ち切らずに受け、件数はこちらで切る (「何曲と一緒に来たか」に
    // 答えられなくなるので、打ち切った件数だけを返さない — §4 の規約)。
    let all = index_built.co_occurring(snap, &song_id, u32::MAX);
    let total = all.len();
    let rows: Vec<Value> = all
        .into_iter()
        .take(limit as usize)
        .map(|c| {
            let mut o = Obj::new();
            o.put("id", c.song_id.as_str());
            o.opt("title", snap.song(&c.song_id).map(|s| s.title.clone()));
            o.put("together", json!(c.together));
            o.put("performances", json!(c.performances));
            o.value()
        })
        .collect();

    let mut head = Obj::new();
    head.put("song", super::browse::song_row(snap, index));
    // 「一緒に来る率」の分母になる、対象曲そのものの公演数。
    head.put("song_shows", json!(index_built.performances(index)));
    Ok(listing_with(head, "co_performed", total, rows))
}

// =============================================================================
// テスト
// =============================================================================

#[cfg(test)]
mod tests {
    use super::*;
    use crate::domain::agent_tools::call_tool;
    use std::sync::OnceLock;

    const TODAY: &str = "2026-09-19";

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

    fn call(name: &str, args: Value) -> Value {
        call_tool(snap(), name, &args, TODAY).unwrap_or_else(|e| panic!("{name}: {e}"))
    }

    #[test]
    fn 主演公演は_cast_role_で引ける() {
        let out = call("list_shows", json!({ "cast_role": "lead" }));
        assert!(out["total"].as_u64().unwrap() >= 6, "{out}");
        for row in out["shows"].as_array().unwrap() {
            assert!(row["lead"].as_array().is_some_and(|a| !a.is_empty()), "{row}");
        }
        // 人と役割を組み合わせると、その人が主演だった公演だけになる。
        let lead_id = out["shows"][0]["lead"][0]["id"].as_str().unwrap().to_string();
        let mine = call("list_shows", json!({ "idol_id": lead_id, "cast_role": "lead" }));
        assert!(mine["total"].as_u64().unwrap() >= 1, "{mine}");
        assert!(mine["total"].as_u64().unwrap() <= out["total"].as_u64().unwrap());
    }

    #[test]
    fn 主演公演が無い人でも_0_件で落ちない() {
        // 伊吹翼には主演公演が無い。0 件が返ること (エラーにしないこと) を固定する。
        let out = call("list_shows", json!({ "idol_id": "ml_伊吹翼", "cast_role": "lead" }));
        assert_eq!(out["total"], json!(0), "{out}");
        // 出演した公演そのものは沢山ある。
        let all = call("list_shows", json!({ "idol_id": "ml_伊吹翼" }));
        assert!(all["total"].as_u64().unwrap() > 50, "{all}");
    }

    #[test]
    fn 人数と今後過去で絞れる() {
        let few = call("list_shows", json!({ "brand": "ml", "max_cast": 8, "has_setlist": true }));
        for row in few["shows"].as_array().unwrap() {
            assert!(row["cast_count"].as_u64().unwrap() <= 8, "{row}");
            assert!(row["song_count"].as_u64().unwrap() > 0, "{row}");
        }
        let upcoming = call("list_shows", json!({ "when": "upcoming" }));
        for row in upcoming["shows"].as_array().unwrap() {
            assert_eq!(row["upcoming"], json!(true), "{row}");
        }
        // upcoming は近い順 (日付昇順)。
        let dates: Vec<&str> =
            upcoming["shows"].as_array().unwrap().iter().map(|r| r["date"].as_str().unwrap()).collect();
        assert!(dates.windows(2).all(|w| w[0] <= w[1]), "{dates:?}");
    }

    #[test]
    fn 種別で発売記念イベントを外せる() {
        // 発売記念イベント (2 曲のミニステージ) が混ざったままだと曲数の中央値が
        // 本公演の型を表さない。kind=live で外れることを固定する。
        let all = call("setlist_shape", json!({ "idol_id": "ml_伊吹翼", "max_cast": 16 }));
        let live = call("setlist_shape", json!({ "idol_id": "ml_伊吹翼", "max_cast": 16, "kind": "live" }));
        assert!(live["shows"].as_u64().unwrap() < all["shows"].as_u64().unwrap(), "{live}");
        assert!(
            live["song_count"]["median"].as_u64().unwrap()
                > all["song_count"]["median"].as_u64().unwrap(),
            "発売記念イベントが混ざったままの方が曲数が多い: {all} / {live}"
        );
    }

    #[test]
    fn 語彙外の役割は候補つきで突き返す() {
        let err = call_tool(snap(), "list_shows", &json!({ "cast_role": "主演" }), TODAY).unwrap_err();
        match err {
            ToolError::BadArgs(m) => assert!(m.contains("lead"), "{m}"),
            other => panic!("{other}"),
        }
    }

    #[test]
    fn 型は同じ軸で絞った公演から出る() {
        let listed = call("list_shows", json!({ "cast_role": "lead" }));
        let shaped = call("setlist_shape", json!({ "cast_role": "lead" }));
        // 一覧の件数 = 型の標本 + セトリ未入力。ここがズレたら軸が二重管理になっている。
        assert_eq!(
            listed["total"].as_u64().unwrap(),
            shaped["shows"].as_u64().unwrap() + shaped["shows_without_setlist"].as_u64().unwrap(),
            "一覧と型で公演の集合が違う: {listed} / {shaped}"
        );
        assert!(shaped["song_count"]["median"].as_u64().unwrap() >= 10, "{shaped}");
        assert!(!shaped["openers"].as_array().unwrap().is_empty(), "{shaped}");
        assert!(!shaped["closers"].as_array().unwrap().is_empty(), "{shaped}");
        assert!(shaped["solo_slots"]["max"].as_u64().unwrap() >= 1, "{shaped}");
    }

    #[test]
    fn 曲の位置は合計が披露回数に一致する() {
        // よく歌われる曲を 1 つ選ぶ。
        let top = call("stats", json!({ "kind": "song_play_ranking", "limit": 1 }));
        let song_id = top["items"][0]["id"].as_str().unwrap().to_string();
        let out = call("song_position_profile", json!({ "song_id": song_id }));
        let n = out["performances"].as_u64().unwrap();
        assert!(n > 0, "{out}");
        let p = &out["position"];
        assert_eq!(
            p["early"].as_u64().unwrap() + p["middle"].as_u64().unwrap() + p["late"].as_u64().unwrap(),
            n,
            "{out}"
        );
        assert!(out["closer"].as_u64().unwrap() <= n);
    }

    #[test]
    fn 共起は分母つきで返る() {
        let top = call("stats", json!({ "kind": "song_play_ranking", "limit": 1 }));
        let song_id = top["items"][0]["id"].as_str().unwrap().to_string();
        let out = call("co_performed_songs", json!({ "song_id": song_id, "limit": 5 }));
        let rows = out["co_performed"].as_array().unwrap();
        assert!(!rows.is_empty(), "{out}");
        for row in rows {
            assert!(row["performances"].as_u64() >= row["together"].as_u64(), "{row}");
            assert_ne!(row["id"].as_str().unwrap(), song_id, "自分自身が入っている");
        }
        assert!(out["song_shows"].as_u64().unwrap() > 0, "{out}");
    }

    #[test]
    fn 知らない_id_は_not_found() {
        for (tool, key) in
            [("song_position_profile", "song_id"), ("co_performed_songs", "song_id")]
        {
            let err = call_tool(snap(), tool, &json!({ key: "無い曲" }), TODAY).unwrap_err();
            assert!(matches!(err, ToolError::NotFound(_)), "{tool}: {err}");
        }
        let err =
            call_tool(snap(), "list_shows", &json!({ "idol_id": "無い人" }), TODAY).unwrap_err();
        assert!(matches!(err, ToolError::NotFound(_)), "{err}");
    }
}
