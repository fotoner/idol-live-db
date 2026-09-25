// discord_digest.ts — アプリでの動き (編集・コールガイド・タグ・お題) を Discord の #更新通知 にまとめて投稿する。
//
// 5 分 cron (scheduled.ts の EVERY_RUN) から呼ぶ。1 件ごとに流すとタグ付けなどでチャンネルが
// 埋まるので、前回から増えた分を 1 通にまとめる。何も増えていなければ投稿しない。
//
// 読み進め位置は source ごとの rowid (discord_digest_cursors)。rowid の範囲で引くので、
// 1 回に読むのは新しく増えた行だけ (D1 の rows_read を食わない。0036 の事象参照)。
// 投稿に成功したときだけ位置を進めるので、Discord が落ちていても次の回にまとめて出る。
//
// ⚠️ 編集者は出さない (編集者匿名性: feed.ts の契約 §1)。編集の要約もクライアントが書いた
//    文字列 (edit_batch.summary の " — " 以降) は使わず、機械生成の部分だけを数える。
//    タグ名・お題名は利用者が書いた文字列なので、メンションは allowed_mentions で全部止め、
//    Markdown の記号は md() で無効にする。
//
// 曲へのタグ付けは、曲ごとに埋め込み (ジャケ写つき) で出す。本文のリンクは <URL> で包んで
// プレビューを出さない (埋め込みを使うので SUPPRESS_EMBEDS は付けられない)。

import { cloudKitLookup } from "./cloudkit";
import { postChannelMessage } from "./discord";
import type { Env } from "./env";

const WEB_BASE = "https://idollivedb.fugaapp.site";
/** 1 回に読む行数の上限 (source ごと)。超えた分は次の回に回る。 */
const BATCH_LIMIT = 200;
/** 本文に名前を並べる上限。超えた分は「ほか N 件」にする。 */
const LIST_LIMIT = 8;
/** 曲のタグ付けを埋め込みで出す上限 (Discord は 1 通 10 個まで)。 */
const EMBED_LIMIT = 9;
const TAG_EMBED_COLOR = 0xe85a9b;

type DigestEnv = Pick<Env, "DB"> & Partial<Env>;

interface Source<Row> {
  name: string;
  /** rowid > ? を BATCH_LIMIT 件まで。rid 列 (rowid) を必ず含める。 */
  sql: string;
  table: string;
  rows?: Array<Row & { rid: number }>;
}

const RECORD_LABELS: Record<string, string> = {
  SetlistItem: "セトリ",
  Song: "曲",
  Show: "公演",
  Event: "イベント",
  Idol: "アイドル",
  Unit: "ユニット",
  Venue: "会場",
};

function source<Row>(name: string, table: string, columns: string, where = ""): Source<Row> {
  return {
    name,
    table,
    sql: `SELECT rowid AS rid, ${columns} FROM ${table} WHERE rowid > ?${where ? ` AND ${where}` : ""} ORDER BY rowid LIMIT ${BATCH_LIMIT}`,
  };
}

/** 利用者が書いた文字列を Markdown として解釈させない。 */
function md(text: string): string {
  return text.replace(/[\\*_~`|[\]()<>#@:]/g, (c) => `\\${c}`);
}

function link(label: string, url: string): string {
  return `[${md(label)}](<${url}>)`;
}

interface CkInfo {
  name?: string;
  artworkUrl?: string;
}

/** CloudKit から名前 (曲は title、アイドル・ユニットは name) とジャケ写を引く。引けなければ空。 */
async function lookupNames(env: DigestEnv, ids: string[]): Promise<Map<string, CkInfo>> {
  const out = new Map<string, CkInfo>();
  if (ids.length === 0 || !env.CLOUDKIT_KEY_ID || !env.CLOUDKIT_PRIVATE_KEY) return out;
  try {
    const res = await cloudKitLookup(ids, env.CLOUDKIT_KEY_ID, env.CLOUDKIT_PRIVATE_KEY);
    for (const id of ids) {
      const f = res.records?.get(id)?.fields;
      if (!f) continue;
      const name = f.title?.value ?? f.name?.value;
      const art = f.artworkUrl?.value;
      out.set(id, {
        name: typeof name === "string" ? name : undefined,
        artworkUrl: typeof art === "string" && art.startsWith("https://") ? art : undefined,
      });
    }
  } catch {
    // 名前が引けなくても通知は出す (ID のまま)。
  }
  return out;
}

/** タグ ID → 表示名 (公開中のものだけ)。 */
async function tagNames(env: DigestEnv, table: string, ids: string[]): Promise<Map<string, string>> {
  if (ids.length === 0) return new Map();
  const res = await env.DB.prepare(
    `SELECT id, name FROM ${table} WHERE status = 'active' AND id IN (${ids.map(() => "?").join(",")})`
  )
    .bind(...ids)
    .all<{ id: string; name: string }>();
  return new Map((res.results ?? []).map((r) => [r.id, r.name]));
}

/** 対象ごとに付いたタグ名をまとめる (同じタグは 1 回、見つからないタグは出さない)。 */
function groupTags(rows: Array<{ target: string; tag_id: string }>, names: Map<string, string>): Map<string, string[]> {
  const out = new Map<string, string[]>();
  for (const r of rows) {
    const name = names.get(r.tag_id);
    if (!name) continue;
    const list = out.get(r.target) ?? [];
    if (!list.includes(name)) list.push(name);
    out.set(r.target, list);
  }
  return out;
}

function tagList(names: string[]): string {
  return names.map((n) => `#${md(n)}`).join(" ");
}

function moreSuffix(total: number): string {
  return total > LIST_LIMIT ? ` ほか${total - LIST_LIMIT}件` : "";
}

/** 1 回ぶん。設定が無ければ何もしない。 */
export async function postDiscordDigest(env: DigestEnv): Promise<void> {
  if (!env.DISCORD_BOT_TOKEN || !env.DISCORD_UPDATES_CHANNEL_ID) return;

  const edits = source<{ summary: string | null }>(
    "edits", "edit_batch", "summary", "source = 'app' AND cloudkit_ok = 1"
  );
  const calls = source<{ song_id: string }>("calls", "call_edit_history", "song_id");
  const songTags = source<{ target: string; tag_id: string }>("song_tags", "device_song_tag", "song_id AS target, tag_id");
  const idolTags = source<{ target: string; tag_id: string }>("idol_tags", "device_idol_tag", "idol_id AS target, tag_id");
  const unitTags = source<{ target: string; tag_id: string }>("unit_tags", "device_unit_tag", "unit_id AS target, tag_id");
  const newSongTags = source<{ name: string }>("tag_master", "tags", "name", "status = 'active'");
  const newIdolTags = source<{ name: string }>("idol_tag_master", "idol_tag_master", "name", "status = 'active'");
  const newUnitTags = source<{ name: string }>("unit_tag_master", "unit_tag_master", "name", "status = 'active'");
  const polls = source<{ title: string }>("polls", "polls", "title", "status = 'active'");
  const sources: Source<any>[] = [edits, calls, songTags, idolTags, unitTags, newSongTags, newIdolTags, newUnitTags, polls];

  const cursorRows = await env.DB.prepare("SELECT source, last_rowid FROM discord_digest_cursors").all<{
    source: string;
    last_rowid: number;
  }>();
  const cursors = new Map((cursorRows.results ?? []).map((r) => [r.source, Number(r.last_rowid)]));

  // 位置がまだ無い source は、今の末尾を入れるだけ (過去の全件を流さない)。
  const fresh = sources.filter((s) => !cursors.has(s.name));
  if (fresh.length > 0) {
    await env.DB.batch(
      fresh.map((s) =>
        env.DB.prepare(
          `INSERT OR IGNORE INTO discord_digest_cursors (source, last_rowid)
           SELECT ?, COALESCE(MAX(rowid), 0) FROM ${s.table}`
        ).bind(s.name)
      )
    );
  }
  const active = sources.filter((s) => cursors.has(s.name));
  if (active.length === 0) return;

  const results = await env.DB.batch(active.map((s) => env.DB.prepare(s.sql).bind(cursors.get(s.name)!)));
  active.forEach((s, i) => {
    s.rows = (results[i].results ?? []) as any[];
  });

  const lines: string[] = [];

  // 編集: 件数と、種類ごとの op 数 (機械生成の要約 "Song.update x1, SetlistItem.create x3" を数える)。
  if (edits.rows?.length) {
    const byType: Record<string, number> = {};
    for (const row of edits.rows) {
      const machine = (row.summary ?? "").split(" — ")[0];
      for (const part of machine.split(",")) {
        const m = part.trim().match(/^([A-Za-z]+)\.[a-z]+ x(\d+)$/);
        if (!m) continue;
        const label = RECORD_LABELS[m[1]] ?? m[1];
        byType[label] = (byType[label] ?? 0) + Number(m[2]);
      }
    }
    const detail = Object.entries(byType)
      .sort((a, b) => b[1] - a[1])
      .map(([label, n]) => `${label} ×${n}`)
      .join("、");
    lines.push(`📝 **データの編集** ${edits.rows.length}件${detail ? `（${detail}）` : ""}`);
  }

  // タグ付け: 対象ごとに付いたタグ名 (曲は tags、アイドル・ユニットはそれぞれのマスタ)。
  const [songTagNames, idolTagNames, unitTagNames] = await Promise.all([
    tagNames(env, "tags", [...new Set((songTags.rows ?? []).map((r) => r.tag_id))]),
    tagNames(env, "idol_tag_master", [...new Set((idolTags.rows ?? []).map((r) => r.tag_id))]),
    tagNames(env, "unit_tag_master", [...new Set((unitTags.rows ?? []).map((r) => r.tag_id))]),
  ]);
  const songTagged = groupTags(songTags.rows ?? [], songTagNames);
  const idolTagged = groupTags(idolTags.rows ?? [], idolTagNames);
  const unitTagged = groupTags(unitTags.rows ?? [], unitTagNames);

  // 名前とジャケ写は CloudKit から 1 回でまとめて引く。
  const callSongIds = [...new Set((calls.rows ?? []).map((r) => r.song_id))];
  const taggedSongIds = [...songTagged.keys()];
  const idolIds = [...idolTagged.keys()];
  const unitIds = [...unitTagged.keys()];
  const info = await lookupNames(env, [
    ...new Set([
      ...callSongIds.slice(0, LIST_LIMIT),
      ...taggedSongIds.slice(0, EMBED_LIMIT + LIST_LIMIT),
      ...idolIds.slice(0, LIST_LIMIT),
      ...unitIds.slice(0, LIST_LIMIT),
    ]),
  ]);
  const nameOf = (id: string) => info.get(id)?.name ?? id;

  // コールガイド: 曲名と Web の曲ページ。
  if (callSongIds.length) {
    const names = callSongIds
      .slice(0, LIST_LIMIT)
      .map((id) => link(nameOf(id), `${WEB_BASE}/songs/${encodeURIComponent(id)}/`));
    lines.push(`🎤 **コールガイド** ${names.join("、")}${moreSuffix(callSongIds.length)}`);
  }

  // 曲のタグ付け: 曲ごとに埋め込み (曲名・付いたタグ・ジャケ写)。入りきらない分は本文に名前だけ。
  const embeds: unknown[] = [];
  if (taggedSongIds.length) {
    for (const id of taggedSongIds.slice(0, EMBED_LIMIT)) {
      const art = info.get(id)?.artworkUrl;
      embeds.push({
        title: nameOf(id).slice(0, 256),
        url: `${WEB_BASE}/songs/${encodeURIComponent(id)}/`,
        description: tagList(songTagged.get(id)!).slice(0, 1000),
        color: TAG_EMBED_COLOR,
        ...(art ? { thumbnail: { url: art } } : {}),
      });
    }
    const rest = taggedSongIds.slice(EMBED_LIMIT);
    const restText = rest.length
      ? `（ほかに ${rest
          .slice(0, LIST_LIMIT)
          .map((id) => link(nameOf(id), `${WEB_BASE}/songs/${encodeURIComponent(id)}/`))
          .join("、")}${moreSuffix(rest.length)}）`
      : "";
    lines.push(`🏷️ **曲にタグ** ${taggedSongIds.length}曲${restText}`);
  }

  // アイドル・ユニットのタグ付け: 「名前 #タグ #タグ」を並べる。
  const targetLine = (label: string, path: string, tagged: Map<string, string[]>) => {
    const ids = [...tagged.keys()];
    if (!ids.length) return;
    const items = ids
      .slice(0, LIST_LIMIT)
      .map((id) => `${link(nameOf(id), `${WEB_BASE}/${path}/${encodeURIComponent(id)}/`)} ${tagList(tagged.get(id)!)}`);
    lines.push(`🏷️ **${label}にタグ** ${items.join("、")}${moreSuffix(ids.length)}`);
  };
  targetLine("アイドル", "idols", idolTagged);
  targetLine("ユニット", "units", unitTagged);

  const newTagNames = [...(newSongTags.rows ?? []), ...(newIdolTags.rows ?? []), ...(newUnitTags.rows ?? [])].map(
    (r) => `「${md(r.name)}」`
  );
  if (newTagNames.length) {
    lines.push(`✨ **新しいタグ** ${newTagNames.slice(0, LIST_LIMIT).join("")}${moreSuffix(newTagNames.length)}`);
  }

  if (polls.rows?.length) {
    const titles = polls.rows.map((r) => `「${md(r.title)}」`);
    lines.push(`🗳️ **新しいお題** ${titles.slice(0, LIST_LIMIT).join("")}${moreSuffix(titles.length)}`);
  }

  if (lines.length > 0) {
    const ok = await postChannelMessage(env as Env, env.DISCORD_UPDATES_CHANNEL_ID, {
      content: lines.join("\n").slice(0, 2000),
      allowed_mentions: { parse: [] },
      ...(embeds.length ? { embeds } : {}),
    });
    if (!ok) throw new Error("discord digest post failed");
  }

  // 読んだところまで進める (何も無かった source は据え置き)。
  const advance = active.filter((s) => s.rows && s.rows.length > 0);
  if (advance.length > 0) {
    await env.DB.batch(
      advance.map((s) =>
        env.DB.prepare("UPDATE discord_digest_cursors SET last_rowid = ? WHERE source = ?").bind(
          s.rows![s.rows!.length - 1].rid,
          s.name
        )
      )
    );
  }
}
