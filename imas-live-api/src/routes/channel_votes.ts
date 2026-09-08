// routes/channel_votes.ts — チャンネル (アイマス / ボカロ) のアイドル別投票 API
//
// イントロクイズ側で遊んで貯まる「投票ポイント」の使い道。device_aggregates と
// 同じ性質を持つので同じ形にしてある:
//   - 認証不要 (X-Device-Id のみ)。サインインを挟むと、パーティゲームの
//     気軽さの側が壊れる
//   - 他のルートと状態を共有しない
//   - CloudKit ではなく D1 で完結する
//
// **月ごとに区切る。** 累計だと最初の数か月で順位が決まって二度と動かない。
// period は必ずサーバーが決める — クライアントに選ばせると過去の月へ詰め込める。

import { dryCheckIpRateLimit, commitIpRateLimit } from "../rate_limit";
import { parsePositiveInt, validateOpaqueKey } from "../validation";
import type { RouteContext } from "./context";

/** 1 リクエストで入れられる票数の上限。 */
const MAX_VOTES_PER_REQUEST = 100;

/** ランキングで返す最大件数。 */
const MAX_RANKING_LIMIT = 100;

/**
 * いまの投票期間 ('YYYY-MM')。
 *
 * **JST の暦月。** UTC で切ると、日本の月初 9 時間ぶんが前の月に入る。
 */
export function currentPeriod(now: Date = new Date()): string {
  const jst = new Date(now.getTime() + 9 * 60 * 60 * 1000);
  return jst.toISOString().slice(0, 7);
}

/** 'YYYY-MM' の形だけ通す (読み出しはクライアントが期間を指定できる)。 */
function validPeriod(raw: string | null): string | null {
  if (!raw) return null;
  return /^\d{4}-(0[1-9]|1[0-2])$/.test(raw) ? raw : null;
}

/**
 * /channel-votes/* を処理する。
 * どのルートにも一致しなければ `null` を返し、呼び出し元の if チェーンへ処理を戻す。
 */
export async function handleChannelVotes(ctx: RouteContext): Promise<Response | null> {
  const { request, env, url, path, json, error, rateLimitSimple } = ctx;

  // ------------------------------------------------------------------
  // GET /channel-votes?channel_id=&period=&limit= — ランキング (auth 不要)
  // ------------------------------------------------------------------
  if (path === "/channel-votes" && request.method === "GET") {
    const channelId = url.searchParams.get("channel_id");
    const channelErr = validateOpaqueKey(channelId, "channel_id");
    if (channelErr) return error(channelErr);

    const period = validPeriod(url.searchParams.get("period")) ?? currentPeriod();
    const limit = parsePositiveInt(url.searchParams.get("limit"), 50, MAX_RANKING_LIMIT);

    const { results } = await env.DB.prepare(
      `SELECT entity_id, votes FROM channel_vote_totals
        WHERE period = ? AND channel_id = ? AND votes > 0
        ORDER BY votes DESC, entity_id ASC
        LIMIT ?`
    )
      .bind(period, channelId, limit)
      .all<{ entity_id: string; votes: number }>();

    const totalRow = await env.DB.prepare(
      `SELECT COUNT(*) AS entries, COALESCE(SUM(votes), 0) AS total
         FROM channel_vote_totals WHERE period = ? AND channel_id = ? AND votes > 0`
    )
      .bind(period, channelId)
      .first<{ entries: number; total: number }>();

    // 自分の内訳は X-Device-Id があるときだけ。無くてもランキングは返す。
    const deviceId = request.headers.get("X-Device-Id");
    let mine: Array<{ entity_id: string; votes: number }> = [];
    if (deviceId) {
      const { results: mineRows } = await env.DB.prepare(
        `SELECT entity_id, votes FROM device_channel_votes
          WHERE device_id = ? AND period = ? AND channel_id = ? AND votes > 0
          ORDER BY votes DESC, entity_id ASC`
      )
        .bind(deviceId, period, channelId)
        .all<{ entity_id: string; votes: number }>();
      mine = mineRows;
    }

    return json({
      period,
      channel_id: channelId,
      // 順位はここで振る。同票は entity_id 順で並びを固定してあるので、
      // 引き直しても順位が入れ替わらない。
      ranking: results.map((row, index) => ({
        rank: index + 1,
        entity_id: row.entity_id,
        votes: row.votes,
      })),
      entry_count: totalRow?.entries ?? 0,
      total_votes: totalRow?.total ?? 0,
      my_votes: mine,
    });
  }

  // ------------------------------------------------------------------
  // POST /channel-votes — 投票 (X-Device-Id 必須)
  // ------------------------------------------------------------------
  if (path === "/channel-votes" && request.method === "POST") {
    const deviceId = request.headers.get("X-Device-Id");
    if (!deviceId) return error("X-Device-Id header is required");

    const ip = request.headers.get("CF-Connecting-IP") ?? "unknown";
    const ipDry = await dryCheckIpRateLimit(env.DB, ip);
    if (!ipDry.allowed) return rateLimitSimple();

    // 不正な JSON は catch-all に落として 500 にせず 400 で返す
    // (クライアントのバグがサーバ障害として観測されるのを防ぐ)。
    const body = (await request.json().catch(() => null)) as any;
    if (body === null) return error("invalid JSON body");

    const { channel_id: channelId, entity_id: entityId, votes } = body;
    const channelErr = validateOpaqueKey(channelId, "channel_id");
    if (channelErr) return error(channelErr);
    const entityErr = validateOpaqueKey(entityId, "entity_id");
    if (entityErr) return error(entityErr);
    if (!Number.isInteger(votes) || votes < 1 || votes > MAX_VOTES_PER_REQUEST) {
      return error(`votes must be an integer between 1 and ${MAX_VOTES_PER_REQUEST}`);
    }

    // **期間はサーバーが決める。** 受け取ると過去の月へ詰め込める。
    const period = currentPeriod();

    await env.DB.batch([
      env.DB.prepare(
        `INSERT INTO channel_vote_totals (period, channel_id, entity_id, votes)
         VALUES (?, ?, ?, ?)
         ON CONFLICT(period, channel_id, entity_id) DO UPDATE SET
           votes = votes + excluded.votes,
           updated_at = datetime('now')`
      ).bind(period, channelId, entityId, votes),
      env.DB.prepare(
        `INSERT INTO device_channel_votes (period, channel_id, entity_id, device_id, votes)
         VALUES (?, ?, ?, ?, ?)
         ON CONFLICT(period, channel_id, entity_id, device_id) DO UPDATE SET
           votes = votes + excluded.votes,
           updated_at = datetime('now')`
      ).bind(period, channelId, entityId, deviceId, votes),
    ]);

    await commitIpRateLimit(env.DB, ip, ipDry.bucket, ipDry.dayBucket);

    // 入れた直後の得票と順位を返す。**もう 1 往復させない** —
    // 投票の手応えはその場で出したい。
    const total = await env.DB.prepare(
      `SELECT votes FROM channel_vote_totals
        WHERE period = ? AND channel_id = ? AND entity_id = ?`
    )
      .bind(period, channelId, entityId)
      .first<{ votes: number }>();

    const above = await env.DB.prepare(
      `SELECT COUNT(*) AS n FROM channel_vote_totals
        WHERE period = ? AND channel_id = ? AND votes > ?`
    )
      .bind(period, channelId, total?.votes ?? 0)
      .first<{ n: number }>();

    const mine = await env.DB.prepare(
      `SELECT votes FROM device_channel_votes
        WHERE period = ? AND channel_id = ? AND entity_id = ? AND device_id = ?`
    )
      .bind(period, channelId, entityId, deviceId)
      .first<{ votes: number }>();

    return json({
      period,
      channel_id: channelId,
      entity_id: entityId,
      votes: total?.votes ?? 0,
      rank: (above?.n ?? 0) + 1,
      my_votes: mine?.votes ?? 0,
    });
  }

  return null;
}
