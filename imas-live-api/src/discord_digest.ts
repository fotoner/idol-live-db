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
//    タグ名・お題名は利用者が書いた文字列なので、メンションは allowed_mentions で全部止める。

import { cloudKitLookup } from "./cloudkit";
import { postChannelMessage } from "./discord";
import type { Env } from "./env";

const WEB_BASE = "https://idollivedb.fugaapp.site";
/** 1 回に読む行数の上限 (source ごと)。超えた分は次の回に回る。 */
const BATCH_LIMIT = 200;
/** 本文に名前を並べる上限。超えた分は「ほか N 件」にする。 */
const LIST_LIMIT = 8;

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
  const songTags = source<{ tag_id: string }>("song_tags", "device_song_tag", "tag_id");
  const idolTags = source<{ tag_id: string }>("idol_tags", "device_idol_tag", "tag_id");
  const unitTags = source<{ tag_id: string }>("unit_tags", "device_unit_tag", "tag_id");
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

  // コールガイド: 曲名 (CloudKit から引く。引けなければ ID) と Web の曲ページ。
  if (calls.rows?.length) {
    const songIds = [...new Set(calls.rows.map((r) => r.song_id))];
    const shown = songIds.slice(0, LIST_LIMIT);
    const titles = new Map<string, string>();
    if (env.CLOUDKIT_KEY_ID && env.CLOUDKIT_PRIVATE_KEY) {
      try {
        const res = await cloudKitLookup(shown, env.CLOUDKIT_KEY_ID, env.CLOUDKIT_PRIVATE_KEY);
        for (const id of shown) {
          const title = res.records?.get(id)?.fields?.title?.value;
          if (typeof title === "string") titles.set(id, title);
        }
      } catch {
        // 曲名が引けなくても通知は出す (ID のまま)。
      }
    }
    const names = shown.map((id) => `[${titles.get(id) ?? id}](${WEB_BASE}/songs/${encodeURIComponent(id)}/)`);
    lines.push(`🎤 **コールガイド** ${names.join("、")}${moreSuffix(songIds.length)}`);
  }

  // タグ付け: 付けた回数 (対象ごと) と、新しく作られたタグの名前。
  const tagCounts = [
    ["曲", songTags.rows?.length ?? 0],
    ["アイドル", idolTags.rows?.length ?? 0],
    ["ユニット", unitTags.rows?.length ?? 0],
  ].filter(([, n]) => (n as number) > 0);
  const newTagNames = [...(newSongTags.rows ?? []), ...(newIdolTags.rows ?? []), ...(newUnitTags.rows ?? [])].map(
    (r) => `「${r.name}」`
  );
  if (tagCounts.length > 0 || newTagNames.length > 0) {
    const counts = tagCounts.map(([label, n]) => `${label}に${n}件`).join("、");
    const created = newTagNames.length
      ? `${counts ? " / " : ""}新しいタグ ${newTagNames.slice(0, LIST_LIMIT).join("")}${moreSuffix(newTagNames.length)}`
      : "";
    lines.push(`🏷️ **タグ付け** ${counts}${created}`);
  }

  if (polls.rows?.length) {
    const titles = polls.rows.map((r) => `「${r.title}」`);
    lines.push(`🗳️ **新しいお題** ${titles.slice(0, LIST_LIMIT).join("")}${moreSuffix(titles.length)}`);
  }

  if (lines.length > 0) {
    const ok = await postChannelMessage(env as Env, env.DISCORD_UPDATES_CHANNEL_ID, {
      content: lines.join("\n").slice(0, 2000),
      allowed_mentions: { parse: [] },
      flags: 4, // SUPPRESS_EMBEDS: リンクのプレビューで埋まらないように
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
