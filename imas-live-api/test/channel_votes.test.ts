import { describe, expect, it } from "vitest";
import { currentPeriod } from "../src/routes/channel_votes";

// 投票の期間は月ごと。**書き込み側は必ずサーバーがこれを使う** (クライアントに
// 選ばせると過去の月へ詰め込める) ので、境界の切り方をここで固定する。

describe("currentPeriod", () => {
  it("YYYY-MM を返す", () => {
    expect(currentPeriod(new Date("2026-09-15T03:00:00Z"))).toBe("2026-09");
  });

  // **JST の暦月で切る。** UTC で切ると、日本の月初 9 時間ぶんが前の月に入る
  // (10/1 の朝 8 時に投票した票が 9 月のランキングへ乗る)。
  it("日本時間の月初は新しい月に入る", () => {
    // JST 2026-10-01 00:00 = UTC 2026-09-30 15:00
    expect(currentPeriod(new Date("2026-09-30T15:00:00Z"))).toBe("2026-10");
    // その 1 分前 (JST 9/30 23:59) はまだ 9 月。
    expect(currentPeriod(new Date("2026-09-30T14:59:00Z"))).toBe("2026-09");
  });

  it("年をまたぐ", () => {
    // JST 2027-01-01 00:00 = UTC 2026-12-31 15:00
    expect(currentPeriod(new Date("2026-12-31T15:00:00Z"))).toBe("2027-01");
    expect(currentPeriod(new Date("2026-12-31T14:00:00Z"))).toBe("2026-12");
  });
});
