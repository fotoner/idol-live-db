//! 歌詞に語を含む曲を探す。**本文は返さない。一致箇所まわりの短い断片だけ。**
//!
//! # 何をここに置くか
//!
//! 探すのは**サーバ** (`GET /lyrics/search`)。歌詞本文は D1 にしか無く、
//! JASRAC の許諾が「一括ダウンロードさせない配信形式」に対して下りている以上
//! (`JASRAC.md`)、本文をこちら側に持ってこない。サーバは song_id と断片しか返さず、
//! 曲名も歌手も返さない (端末が同梱 SQLite から引く前提のため)。
//!
//! ここに置くのは**その断片に曲の情報を添える規則**と、
//! **断片を出す上限**。HTTP を話すのはアダプタ (`agent::lyrics_api`) の仕事で、
//! アダプタに「何を返すか」を書かない。
//!
//! # 引用の範囲に収めるための上限
//!
//! サーバは 1 曲につき打った語の数だけ断片を返しうる。そのまま通すと、語を変えて
//! 何度も引けば曲が復元できてしまう。ここで **1 曲 [`MAX_SNIPPETS_PER_SONG`] 本**に
//! 切る。行番号も前後の行も持たないので、断片どうしのつながりは分からない。

use crate::domain::agent_tools::{json::Obj, tool_schema, ToolSpec};
use crate::domain::snapshot::Snapshot;
use serde_json::{json, Value};

/// 1 曲につき返す断片の本数。AND で 2 語打ったとき「なぜ当たったか」が読める最小限。
pub const MAX_SNIPPETS_PER_SONG: usize = 2;

/// サーバの `/lyrics/search` が返す 1 曲ぶん (HTTP をほどくのはアダプタ)。
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ApiHit {
    pub song_id: String,
    pub snippets: Vec<String>,
}

/// ツールが返す 1 曲。
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LyricHit {
    pub song_id: String,
    pub title: String,
    pub brand_id: Option<String>,
    /// 一致箇所まわりの断片。[`MAX_SNIPPETS_PER_SONG`] 本まで。
    pub snippets: Vec<String>,
    /// この曲の披露回数。「レア曲か」「定番か」をもう 1 回引かずに読めるようにする。
    pub show_count: u32,
}

/// サーバの結果に曲の情報を添える。
///
/// **この DB に無い song_id は落とす。** サーバの歌詞は master より新しいことがあり
/// (歌詞だけ先に入る)、曲名を引けないものを id だけで返すと呼び手が扱えない。
/// 落とした数は [`decorate`] の戻り値では分からないので、件数は呼び手が
/// サーバの生の件数と比べること。
pub fn decorate(snap: &Snapshot, hits: &[ApiHit], brand: Option<&str>, limit: usize) -> Vec<LyricHit> {
    let mut rows: Vec<LyricHit> = hits
        .iter()
        .filter_map(|hit| {
            let &idx = snap.song_index_by_id.get(&hit.song_id)?;
            let song = &snap.songs[idx as usize];
            if brand.is_some_and(|b| song.brand_id.as_deref() != Some(b)) {
                return None;
            }
            let mut snippets: Vec<String> = hit.snippets.clone();
            snippets.truncate(MAX_SNIPPETS_PER_SONG);
            Some(LyricHit {
                song_id: song.id.clone(),
                title: song.title.clone(),
                brand_id: song.brand_id.clone(),
                snippets,
                show_count: snap.performance_counts[idx as usize],
            })
        })
        .collect();
    // サーバは song_id 順で返す。そのまま切ると id の若いブランドだけが並ぶので、
    // **披露回数の多い順**に直してから切る。定番曲かレア曲かが上から読める並びにする。
    rows.sort_by(|a, b| b.show_count.cmp(&a.show_count).then(a.song_id.cmp(&b.song_id)));
    rows.truncate(limit);
    rows
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

    fn hit(id: &str, n: usize) -> ApiHit {
        ApiHit {
            song_id: id.into(),
            snippets: (0..n).map(|i| format!("だみー断片{i}")).collect(),
        }
    }

    #[test]
    fn 曲名と披露回数が添う() {
        let out = decorate(snap(), &[hit("ml_ロケットスター", 1)], None, 10);
        assert_eq!(out.len(), 1, "{out:?}");
        assert_eq!(out[0].title, "ロケットスター☆");
        assert_eq!(out[0].brand_id.as_deref(), Some("ml"));
        assert!(out[0].show_count >= 1, "{out:?}");
    }

    #[test]
    fn 断片は_1_曲_2_本までに切る() {
        // サーバが 5 本返しても 2 本しか通さない。語を変えて集めても曲は復元できない。
        let out = decorate(snap(), &[hit("ml_ロケットスター", 5)], None, 10);
        assert_eq!(out[0].snippets.len(), MAX_SNIPPETS_PER_SONG);
    }

    #[test]
    fn この_db_に無い曲は落とす() {
        let out = decorate(snap(), &[hit("ml_ロケットスター", 1), hit("無い曲", 1)], None, 10);
        assert_eq!(out.len(), 1);
    }

    #[test]
    fn 披露回数の多い順に並ぶ() {
        // サーバは song_id 順で返すので、並べ替えていないとここが落ちる。
        let hits: Vec<ApiHit> =
            ["765as_continue", "ml_アイル", "765as_masterpiece"].iter().map(|id| hit(id, 1)).collect();
        let out = decorate(snap(), &hits, None, 10);
        let counts: Vec<u32> = out.iter().map(|h| h.show_count).collect();
        let mut sorted = counts.clone();
        sorted.sort_by(|a, b| b.cmp(a));
        assert_eq!(counts, sorted, "{out:?}");
    }

    #[test]
    fn ブランドで絞れる() {
        let hits: Vec<ApiHit> =
            ["765as_continue", "ml_アイル"].iter().map(|id| hit(id, 1)).collect();
        let out = decorate(snap(), &hits, Some("ml"), 10);
        assert_eq!(out.len(), 1);
        assert_eq!(out[0].brand_id.as_deref(), Some("ml"));
    }

    #[test]
    fn limit_で曲数を切る() {
        let hits: Vec<ApiHit> = ["ml_ロケットスター", "ml_アイル"].iter().map(|id| hit(id, 1)).collect();
        assert_eq!(decorate(snap(), &hits, None, 1).len(), 1);
    }
}

/// 1 回の検索で返す曲数の上限。
pub const MAX_SONGS: usize = 40;

/// 歌詞検索ツールの札。実行は HTTP を話すアダプタ (`agent::lyrics_api`) の仕事で、
/// `proposal_*` と同じ振り分け方 (`agent::dispatch`) になる。
pub fn lyrics_catalog() -> Vec<ToolSpec> {
    vec![ToolSpec {
        name: "search_lyrics".to_string(),
        description: "歌詞に語を含む曲を探す。空白で AND、| で OR、() でまとめる             (例: 空 翼 / つばさ|ツバサ / (空|海) 夏)。ひらがな/カタカナと大文字小文字は畳む。            **歌詞本文は返らない。**返るのは曲と、一致箇所まわりの短い断片 (1 曲 2 本まで) と             披露回数だけ。断片に行番号も前後の行も付かないので、集めても歌詞は組み直せない。            「名前が歌詞に出てくる曲」「季節や情景で曲を選ぶ」といった、            曲名や原唱者からは引けない探し方に使う。"
            .to_string(),
        input_schema: tool_schema(
            json!({
                "query": { "type": "string", "description": "探す語。空白=AND / |=OR / ()=grouping。2 文字以上。" },
                "brand": { "type": "string", "description": "ブランド id で絞る (例 ml / cg)。歌詞は全ブランド横断なので、1 ブランドの中で探すときに付ける。" },
                "limit": { "type": "integer", "description": "曲数の上限。既定 20・最大 40。並びは披露回数の多い順。" }
            }),
            &["query"],
        ),
    }]
}

/// この名前は歌詞検索ツールか。
pub fn is_lyrics_tool(name: &str) -> bool {
    name == "search_lyrics"
}

/// ツールの応答を組む。**「何を返すか」はここが正本**で、アダプタは HTTP をほどいて
/// [`ApiHit`] にするところまでしかやらない。
///
/// `server_total` はサーバが返した生の件数。この DB に無い曲を落とすので
/// (歌詞だけ先に入ることがある)、落とした事実が分かるように両方の数を返す。
pub fn response(
    snap: &Snapshot,
    query: &str,
    hits: &[ApiHit],
    brand: Option<&str>,
    server_total: usize,
    limit: usize,
) -> Value {
    let rows = decorate(snap, hits, brand, limit);
    let mut o = Obj::new();
    o.put("query", query);
    o.put("total", server_total);
    if rows.len() < server_total {
        o.put("shown", rows.len());
    }
    o.list(
        "songs",
        rows.iter()
            .map(|h| {
                let mut r = Obj::new();
                r.put("song_id", h.song_id.as_str());
                r.put("title", h.title.as_str());
                r.opt("brand_id", h.brand_id.clone());
                r.put("show_count", h.show_count);
                r.list("snippets", h.snippets.iter().map(|s| json!(s)).collect());
                r.value()
            })
            .collect(),
    );
    o.value()
}
