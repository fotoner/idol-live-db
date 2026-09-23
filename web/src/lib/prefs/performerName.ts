/**
 * セトリの歌唱者をどの名前で出すか — 閲覧者ごとの表示の好み。
 *
 * **モードもラベルも既定もここに無い。** どの名前を主/副にするかも、選択肢の順も文言も、
 * どれが既定かも `imas-core` の `performer_name_options` が持ち、`meta.json` 越しに配られる
 * (既定は HTML の `<option selected>` として描かれていて、呼び出し側がそこから読む)。
 * ここがやるのは localStorage への出し入れだけ (保存値の文字列も向こうの `raw`)。
 *
 * サーバ側で描いた HTML は既定モード (アイドル名) で出ているので、
 * 既定のままの閲覧者には JS が 1 バイトも要らない。
 */
const KEY = "performerName";

export function readMode(known: readonly string[], fallback: string): string {
  try {
    const v = localStorage.getItem(KEY);
    return v && known.includes(v) ? v : fallback;
  } catch {
    // プライベートウィンドウ等で localStorage が投げることがある。既定で続ける。
    return fallback;
  }
}

/** 既定のモードは保存しない (既定が変わったときに、選んでいない人まで古い既定に縛らない)。 */
export function writeMode(mode: string, fallback: string): void {
  try {
    if (mode === fallback) localStorage.removeItem(KEY);
    else localStorage.setItem(KEY, mode);
  } catch {
    // 保存できなくても表示は切り替わる (次の訪問で既定に戻るだけ)。
  }
}
