// /app/attest・/app/assert の本文の検証。文字列でない値や base64 として読めない challenge は、
// 500 ではなく 400 で返す。

import { describe, expect, it } from "vitest";
import { callJson } from "./support/worker";

describe("アプリ証明の本文", () => {
  it.each(["/app/attest", "/app/assert"])("%s: 文字列でない・空の項目は 400 bad request", async (path) => {
    const proof = path === "/app/attest" ? "attestation" : "assertion";
    for (const body of [
      { keyId: 5, [proof]: "p", challenge: "AAAA" },
      { keyId: "k", [proof]: {}, challenge: "AAAA" },
      { keyId: "k", [proof]: "p", challenge: "" },
      [1, 2],
    ]) {
      const res = await callJson("POST", path, { body });
      expect(res.status, JSON.stringify(body)).toBe(400);
      expect(res.body).toEqual({ error: "bad request" });
    }
  });

  it.each(["/app/attest", "/app/assert"])("%s: base64 として読めない challenge は 400 bad challenge", async (path) => {
    const proof = path === "/app/attest" ? "attestation" : "assertion";
    const res = await callJson("POST", path, { body: { keyId: "k", [proof]: "p", challenge: "!!!!" } });
    expect(res.status).toBe(400);
    expect(res.body).toEqual({ error: "bad challenge" });
  });
});
