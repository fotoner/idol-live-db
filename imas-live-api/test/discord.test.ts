// Discord のロール受け取り (routes/discord.ts) と、#更新通知 のまとめ投稿 (discord_digest.ts)。
// Discord / GitHub への通信は fetchMock で返す。

import { fetchMock } from "cloudflare:test";
import { afterEach, describe, expect, it } from "vitest";
import { bearer, BASE, call, callJson, fetchWorker, makeEnv, runScheduled } from "./support/worker";
import { exec, insertUser, row, rows } from "./support/d1";

const UID = "001094.discorder";
const DISCORD = "https://discord.com";
const GITHUB = "https://github.com";
const GITHUB_API = "https://api.github.com";
const GUILD = "1530435001231868076";
const DATA_ROLE = "1552703794733645986";
const CONTRIBUTOR_ROLE = "1552703793081090259";
const CHANNEL = "1552704747939565681";
const DISCORD_USER = "900000000000000001";

const configured = () =>
  makeEnv({
    DISCORD_BOT_TOKEN: "bot-token",
    DISCORD_CLIENT_SECRET: "client-secret",
    GITHUB_OAUTH_CLIENT_ID: "gh-client",
    GITHUB_OAUTH_CLIENT_SECRET: "gh-secret",
  });

afterEach(() => {
  fetchMock.assertNoPendingInterceptors();
});

async function seedEdits(uid: string, n: number) {
  for (let i = 0; i < n; i++) {
    await exec(
      "INSERT INTO edit_batch (editor_id, source, op, summary, cloudkit_ok, created_at) VALUES (?, 'app', 'update', ?, 1, ?)",
      uid, "SetlistItem.create x3, Song.update x1 — クライアントの文字列", Date.now()
    );
  }
}

async function startLink(): Promise<string> {
  const res = await callJson("POST", "/discord/link", { headers: await bearer(UID), body: {}, env: configured() });
  expect(res.status).toBe(200);
  const url = new URL(res.body.url);
  expect(url.origin + url.pathname).toBe("https://discord.com/oauth2/authorize");
  expect(url.searchParams.get("redirect_uri")).toBe(`${BASE}/discord/callback`);
  expect(url.searchParams.get("scope")).toBe("identify guilds.join");
  return url.searchParams.get("state")!;
}

function serveDiscordLogin(memberStatus = 201) {
  fetchMock.get(DISCORD).intercept({ path: "/api/v10/oauth2/token", method: "POST" })
    .reply(200, { access_token: "user-access" });
  fetchMock.get(DISCORD).intercept({ path: "/api/v10/users/@me", method: "GET" })
    .reply(200, { id: DISCORD_USER });
  fetchMock.get(DISCORD).intercept({ path: `/api/v10/guilds/${GUILD}/members/${DISCORD_USER}`, method: "PUT" })
    .reply(memberStatus, "");
}

describe("POST /discord/link", () => {
  it("未ログインは 401、設定が無ければ 503", async () => {
    expect((await callJson("POST", "/discord/link", { body: {}, env: configured() })).status).toBe(401);
    await insertUser(UID);
    const res = await callJson("POST", "/discord/link", { headers: await bearer(UID), body: {} });
    expect(res.status).toBe(503);
    expect(res.body).toEqual({ error: "discord_not_configured" });
  });

  it("認可 URL を返し、state を 1 行だけ積む", async () => {
    await insertUser(UID);
    const state = await startLink();
    expect(await rows("SELECT kind, user_id FROM discord_oauth_states WHERE state = ?", state)).toEqual([
      { kind: "discord", user_id: UID },
    ]);
  });
});

describe("GET /discord/callback", () => {
  it("知らない state は期限切れのページ", async () => {
    const res = await call("GET", "/discord/callback?code=c&state=nope", { env: configured() });
    expect(res.status).toBe(400);
    expect(await res.text()).toContain("リンクの期限が切れました");
  });

  it("編集 10 件以上ならサーバーに参加させて「データ協力」を付ける。state は 1 回で消える", async () => {
    await insertUser(UID);
    await seedEdits(UID, 10);
    const state = await startLink();
    serveDiscordLogin(201);
    fetchMock.get(DISCORD)
      .intercept({ path: `/api/v10/guilds/${GUILD}/members/${DISCORD_USER}/roles/${DATA_ROLE}`, method: "PUT" })
      .reply(204, "");

    const res = await call("GET", `/discord/callback?code=c&state=${state}`, { env: configured() });
    expect(res.status).toBe(200);
    expect(res.headers.get("Content-Type")).toContain("text/html");
    expect(await res.text()).toContain("「データ協力」ロールを付けました");
    expect(await row("SELECT discord_user_id FROM discord_links WHERE user_id = ?", UID)).toEqual({
      discord_user_id: DISCORD_USER,
    });

    const again = await call("GET", `/discord/callback?code=c&state=${state}`, { env: configured() });
    expect(again.status).toBe(400);
  });

  it("10 件未満なら参加だけさせて、残りの件数を出す (ロールは付けない)", async () => {
    await insertUser(UID);
    await seedEdits(UID, 3);
    const state = await startLink();
    serveDiscordLogin(204);
    const res = await call("GET", `/discord/callback?code=c&state=${state}`, { env: configured() });
    expect(res.status).toBe(200);
    expect(await res.text()).toContain("あと 7 件編集すると");
  });

  it("差し戻された編集は数えない", async () => {
    await insertUser(UID);
    await seedEdits(UID, 10);
    await exec("UPDATE edit_batch SET reverted_at = ? WHERE id = (SELECT MIN(id) FROM edit_batch)", Date.now());
    const state = await startLink();
    serveDiscordLogin(204);
    const res = await call("GET", `/discord/callback?code=c&state=${state}`, { env: configured() });
    expect(await res.text()).toContain("あと 1 件編集すると");
  });

  it("認可画面でキャンセルしたら code が無い", async () => {
    await insertUser(UID);
    const state = await startLink();
    const res = await call("GET", `/discord/callback?error=access_denied&state=${state}`, { env: configured() });
    expect(await res.text()).toContain("キャンセルしました");
  });
});

// ---------------------------------------------------------------------------
// Interactions
// ---------------------------------------------------------------------------

function toHex(buf: ArrayBuffer): string {
  return [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function signer() {
  const keys = (await crypto.subtle.generateKey({ name: "Ed25519" }, true, ["sign", "verify"])) as CryptoKeyPair;
  const publicKey = toHex((await crypto.subtle.exportKey("raw", keys.publicKey)) as ArrayBuffer);
  async function send(payload: unknown, opts: { tamper?: boolean } = {}) {
    const body = JSON.stringify(payload);
    const timestamp = String(Math.floor(Date.now() / 1000));
    const sig = await crypto.subtle.sign("Ed25519", keys.privateKey, new TextEncoder().encode(timestamp + body));
    const req = new Request(`${BASE}/discord/interactions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Signature-Ed25519": toHex(sig),
        "X-Signature-Timestamp": timestamp,
      },
      body: opts.tamper ? body.replace("}", ',"x":1}') : body,
    });
    const res = await fetchWorker(req, makeEnv({ ...configured(), DISCORD_PUBLIC_KEY: publicKey }));
    const text = await res.text();
    return { status: res.status, body: text ? JSON.parse(text) : null };
  }
  return { send };
}

const command = (role: string) => ({
  type: 2,
  data: { name: "申請", options: [{ name: "ロール", value: role }] },
  member: { user: { id: DISCORD_USER } },
});

describe("POST /discord/interactions", () => {
  it("署名が合わなければ 401、PING には PONG", async () => {
    const { send } = await signer();
    expect((await send({ type: 1 }, { tamper: true })).status).toBe(401);
    expect(await send({ type: 1 })).toEqual({ status: 200, body: { type: 1 } });
  });

  it("/申請 データ協力 はアプリへの案内を本人にだけ返す", async () => {
    const { send } = await signer();
    const res = await send(command("data"));
    expect(res.body.type).toBe(4);
    expect(res.body.data.flags).toBe(64);
    expect(res.body.data.content).toContain("マイページ");
  });

  it("/申請 コントリビューター は GitHub の認可リンクを返し、Discord のユーザーを state に積む", async () => {
    const { send } = await signer();
    const res = await send(command("contributor"));
    const link = new URL(res.body.data.components[0].components[0].url);
    expect(link.origin + link.pathname).toBe("https://github.com/login/oauth/authorize");
    expect(link.searchParams.get("redirect_uri")).toBe(`${BASE}/github/callback`);
    expect(await row("SELECT kind, discord_user_id FROM discord_oauth_states WHERE state = ?", link.searchParams.get("state"))).toEqual({
      kind: "github",
      discord_user_id: DISCORD_USER,
    });
  });
});

describe("GET /github/callback", () => {
  async function githubState(): Promise<string> {
    const { send } = await signer();
    const res = await send(command("contributor"));
    return new URL(res.body.data.components[0].components[0].url).searchParams.get("state")!;
  }

  function serveGithub(merged: number) {
    fetchMock.get(GITHUB).intercept({ path: "/login/oauth/access_token", method: "POST" })
      .reply(200, { access_token: "gh-access" });
    fetchMock.get(GITHUB_API).intercept({ path: "/user", method: "GET" }).reply(200, { login: "someone" });
    fetchMock.get(GITHUB_API).intercept({ path: (p) => p.startsWith("/search/issues"), method: "GET" })
      .reply(200, { total_count: merged });
  }

  it("マージ済みの PR があれば「コントリビューター」を付ける", async () => {
    const state = await githubState();
    serveGithub(2);
    fetchMock.get(DISCORD)
      .intercept({ path: `/api/v10/guilds/${GUILD}/members/${DISCORD_USER}/roles/${CONTRIBUTOR_ROLE}`, method: "PUT" })
      .reply(204, "");
    const res = await call("GET", `/github/callback?code=c&state=${state}`, { env: configured() });
    expect(await res.text()).toContain("「コントリビューター」ロールを付けました");
  });

  it("マージ済みの PR が無ければ付けない", async () => {
    const state = await githubState();
    serveGithub(0);
    const res = await call("GET", `/github/callback?code=c&state=${state}`, { env: configured() });
    expect(await res.text()).toContain("マージされた PR が見つかりませんでした");
  });

  it("Discord の state では通らない (種類違い)", async () => {
    await insertUser(UID);
    const state = await startLink();
    const res = await call("GET", `/github/callback?code=c&state=${state}`, { env: configured() });
    expect(res.status).toBe(400);
  });
});

// ---------------------------------------------------------------------------
// #更新通知
// ---------------------------------------------------------------------------

describe("#更新通知 のまとめ投稿 (5 分 cron)", () => {
  const cron = "*/5 * * * *";
  const digestEnv = () =>
    makeEnv({ DISCORD_BOT_TOKEN: "bot-token", CLOUDKIT_KEY_ID: "", CLOUDKIT_PRIVATE_KEY: "" });

  it("初回は位置を覚えるだけで、過去の分は流さない。増えた分だけ 1 通にまとめ、編集者と利用者の文字列を出さない", async () => {
    await insertUser(UID);
    await seedEdits(UID, 1);
    await runScheduled(cron, digestEnv()); // 投稿なし (interceptor を置いていないので、投げれば落ちる)

    await seedEdits(UID, 2);
    await exec("INSERT INTO call_edit_history (song_id, user_id, call_lines_before, call_lines_after, call_count_before, call_count_after) VALUES ('s1', ?, 0, 3, 0, 5)", UID);
    await exec("INSERT INTO device_song_tag (device_id, song_id, tag_id, created_at) VALUES ('d1', 's1', 't1', 0)");
    await exec("INSERT INTO polls (id, title, target_type, created_by, ends_at) VALUES ('p1', '@everyone 推し曲は？', 'song', ?, datetime('now', '+1 day'))", UID);

    let posted: any = null;
    fetchMock.get(DISCORD).intercept({ path: `/api/v10/channels/${CHANNEL}/messages`, method: "POST" })
      .reply(200, (opts) => {
        posted = JSON.parse(String(opts.body));
        return {};
      });
    await runScheduled(cron, digestEnv());

    expect(posted.allowed_mentions).toEqual({ parse: [] });
    const text: string = posted.content;
    expect(text).toContain("データの編集** 2件（セトリ ×6、曲 ×2）");
    expect(text).toContain("コールガイド** [s1](https://idollivedb.fugaapp.site/songs/s1/)");
    expect(text).toContain("タグ付け** 曲に1件");
    expect(text).toContain("新しいお題** 「@everyone 推し曲は？」");
    expect(text).not.toContain("クライアントの文字列");
    expect(text).not.toContain(UID);

    // 何も増えていなければ投稿しない。
    await runScheduled(cron, digestEnv());
  });

  it("Bot トークンが無ければ何もしない", async () => {
    await runScheduled(cron, makeEnv());
    expect(await rows("SELECT * FROM discord_digest_cursors")).toEqual([]);
  });
});
