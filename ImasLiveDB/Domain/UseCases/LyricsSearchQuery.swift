import Foundation

/// 歌詞検索でサーバに送る式。
enum LyricsSearchQuery {
    /// 検索欄の入力 (空白区切り) を式にする。**空白は AND**。
    ///
    /// OR ではなく AND にしたのは、OR だと 2語打つと 1語より結果が増えるため。
    /// 絞ろうとして増えるのは直感に反する (夢=1,273曲 / 夢+翼 は AND 98曲・OR 1,308曲)。
    /// 表記ゆれは かなの正規化が ツバサ/つばさ を吸収する。
    ///
    /// 語は必ず `"…"` で囲う。歌詞は全角スペースで区切られている
    /// (「空を描いて行くよ　ここで光るよ」) ので、囲わないと空白 = AND として割れる。
    static func simple(_ raw: String) -> String {
        let terms = raw
            .split(whereSeparator: { $0.isWhitespace })
            .map { $0.replacingOccurrences(of: "\"", with: "") }
            .filter { !$0.isEmpty }
        guard !terms.isEmpty else { return "" }
        return terms.map { "\"\($0)\"" }.joined(separator: " ")
    }
}
