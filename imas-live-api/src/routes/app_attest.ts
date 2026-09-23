// routes/app_attest.ts — アプリ証明 (App Attest) の口と、コミュニティ集計の読み取りのゲート。
//
// 正規アプリだけが集計を読めるようにする (クローンのただ乗り対策)。検証そのものは appattest.ts。
//   GET  /app/challenge — チャレンジの発行 (D1 を使わない)
//   POST /app/attest    — 鍵の登録 → アプリ実体トークン
//   POST /app/assert    — アサーションの検証 → アプリ実体トークン
// ゲート (gateCommunityRead) は、集計の読み取りにアプリ実体トークンかログインを求める。
// APP_ATTEST_MODE が monitor の間はログだけで通し、enforce で 401 にする。

import { getAuthUser } from "../auth";
import {
  verifyAttestation, verifyAssertion,
  mintAppToken, verifyAppToken, makeChallenge, checkChallenge,
  b64ToBytes, bytesToB64Url,
} from "../appattest";
import { checkRateLimit } from "../rate_limit";
import type { RouteContext } from "./context";
import { clientIp } from "./guards";

/** アプリ証明 (App Attest) の口。IP 単位の日次上限 (app_attest) を掛ける。 */
const APP_ATTEST_PATHS = new Set(["/app/challenge", "/app/attest", "/app/assert"]);

/** /app/challenge・/app/attest・/app/assert。どれでもなければ null。 */
export async function handleAppAttest(ctx: RouteContext): Promise<Response | null> {
  const { request, env, path, json, error } = ctx;
  if (!APP_ATTEST_PATHS.has(path)) return null;
  const secret = env.SESSION_JWT_SECRET;

  // アプリ証明の口は IP 単位レート制限 (クォータ枯渇による自爆 DoS 防止)。
  // 同じ /app/ の下にある共有リンクの着地ページ (/app/{events,shows,polls}/:id) には掛けない。
  // 閲覧や OGP のクローラーで、同じ IP の端末のアプリ証明が 429 になるため。
  const rl = await checkRateLimit(env.DB, "ip:" + clientIp(request), "app_attest");
  if (!rl.allowed) return error("rate limited", 429);

  if (path === "/app/challenge" && request.method === "GET") {
    if (!secret) return error("server not configured", 500);
    return json({ challenge: bytesToB64Url(await makeChallenge(secret)) });
  }
  if (path === "/app/attest" && request.method === "POST") {
    if (!secret) return error("server not configured", 500);
    const body: any = await request.json().catch(() => null);
    if (!body?.keyId || !body?.attestation || !body?.challenge) return error("bad request", 400);
    const challenge = b64ToBytes(body.challenge);
    if (!(await checkChallenge(challenge, secret))) return error("bad challenge", 400);
    try {
      const { spki, counter } = await verifyAttestation(challenge, b64ToBytes(body.keyId), body.attestation, env.APP_ATTEST_ALLOW_DEV === "true");
      const now = Date.now();
      // OR IGNORE: 既存 keyId への再 attest (リプレイ) で counter を 0 に戻させない
      await env.DB.prepare(
        "INSERT OR IGNORE INTO app_attest_keys (key_id, public_key, counter, created_at, updated_at) VALUES (?,?,?,?,?)"
      ).bind(body.keyId, bytesToB64Url(spki), counter, now, now).run();
      return json({ appToken: await mintAppToken(body.keyId, secret) });
    } catch (e) {
      return error("attestation failed: " + (e as Error).message, 401);
    }
  }
  if (path === "/app/assert" && request.method === "POST") {
    if (!secret) return error("server not configured", 500);
    const body: any = await request.json().catch(() => null);
    if (!body?.keyId || !body?.assertion || !body?.challenge) return error("bad request", 400);
    const challenge = b64ToBytes(body.challenge);
    if (!(await checkChallenge(challenge, secret))) return error("bad challenge", 400);
    const row: any = await env.DB.prepare("SELECT public_key, counter FROM app_attest_keys WHERE key_id=?").bind(body.keyId).first();
    if (!row) return error("unknown key", 401);
    try {
      const newCounter = await verifyAssertion(challenge, body.assertion, b64ToBytes(row.public_key), row.counter as number);
      await env.DB.prepare("UPDATE app_attest_keys SET counter=?, updated_at=? WHERE key_id=?").bind(newCounter, Date.now(), body.keyId).run();
      return json({ appToken: await mintAppToken(body.keyId, secret) });
    } catch (e) {
      return error("assertion failed: " + (e as Error).message, 401);
    }
  }
  return null;
}

/** ゲートの対象 = 認証不要で開いているコミュニティ集計の読み取り。 */
function isCommunityRead(path: string, method: string): boolean {
  if (method !== "GET") return false;
  // D1 固定無料枠に乗る集計 read を網羅する (CLAUDE.md 名指しの予想/いいね/ランキング含む)
  if (/^\/(polls|favorites|penlight|tags|master)(\/|$)/.test(path)) return true;
  if (/^\/songs\/[^/]+\/(tags|similar|detail)$/.test(path)) return true;
  if (/^\/idols\/[^/]+\/similar$/.test(path)) return true;
  if (/^\/units\/[^/]+\/similar$/.test(path)) return true;
  if (/^\/shows\/[^/]+\/(predictions|likes)$/.test(path)) return true;
  // コールガイドの整備状況。歌詞本文もコール本文も含まない件数・日時・表示名だけの
  // 集計なので、歌詞の枠 (認証必須・no-store) ではなくこちら側に置く。
  if (path === "/calls/dashboard") return true;
  return false;
}

/**
 * コミュニティ集計の読み取りを、正規アプリ (アプリ実体トークン) かログイン済みだけに開く。
 * 通すなら null、enforce で断るなら 401 を返す。
 */
export async function gateCommunityRead(ctx: RouteContext): Promise<Response | null> {
  const { request, env, path, error } = ctx;
  const attestMode = env.APP_ATTEST_MODE || "monitor";
  if (attestMode === "off" || !isCommunityRead(path, request.method)) return null;
  const secret = env.SESSION_JWT_SECRET;
  const appTok = request.headers.get("X-App-Token");
  const genuine =
    (!!appTok && !!secret && (await verifyAppToken(appTok, secret))) ||
    (await getAuthUser(request, env)) !== null;
  if (!genuine) {
    if (attestMode === "enforce") return error("app attestation required", 401);
    console.log(`[appattest:monitor] ungated community read ${path}`);
  }
  return null;
}
