// 歌詞検索のバインド変数の上限。ローカル D1 で通す。
// 歌詞の本文には実在の歌詞を使わない (意味の無い文字列だけ)。

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { callJson } from "./support/worker";
import { exec } from "./support/d1";

beforeEach(() => void vi.spyOn(console, "log").mockImplementation(() => {}));
afterEach(() => vi.restoreAllMocks());

describe("GET /lyrics/search のバインド変数", () => {
  it("同じ語を上限まで繰り返しても、索引の候補が多くても 500 にならない", async () => {
    // 索引で絞れる (候補 300 件以下) かつ、1 回の IN に入りきらない件数の曲を用意する。
    const ids = Array.from({ length: 100 }, (_, i) => `s${String(i).padStart(3, "0")}`);
    for (const id of ids) {
      await exec(
        "INSERT INTO song_lyrics (song_id, status, lines_json, body, body_norm) VALUES (?, 'published', '[]', 'アイ', 'アイ')",
        id
      );
    }
    for (const gram of ["ア", "イ", "アイ"]) {
      await exec("INSERT INTO lyrics_gram_index (gram, part, song_ids) VALUES (?, 0, ?)", gram, ids.join("\n"));
    }
    // 1 文字の語を空白で 25 個 (検索文字列の上限 50 文字)。
    const q = Array.from({ length: 25 }, (_, i) => (i % 2 === 0 ? "あ" : "い")).join(" ");
    expect(q.length).toBeLessThanOrEqual(50);

    const res = await callJson("GET", `/lyrics/search?q=${encodeURIComponent(q)}`);
    expect(res.status).toBe(200);
    expect(res.body.hits).toHaveLength(100);
    expect(res.body.hits[0].songId).toBe("s000");
  });
});
