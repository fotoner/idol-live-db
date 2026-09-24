import SwiftUI

// =============================================================================
// コール文言のパレット
//
// ここにあるのは**初期値にすぎない**。実際のコールは曲ごと・現場ごとに変わるので、
// 編集シートでは常に自由入力を許すこと (パレットから選ぶのは近道でしかない)。
//
// 表記は実物のコール表 (くわね氏のコール表 等) に合わせてある。半角/全角の混在や
// 空白の入り方も含めて「現場でそう書かれている形」を優先していて、正規化していない。
//
// MIX (「タイガー・ファイヤー…」) は **意図的に入れていない**。アイマスのコール文化では
// 使われないため、パレットに置くと誤用を促す。
// =============================================================================

struct CallPaletteGroup: Identifiable {
    let id: String
    /// 組の名前 (画面の言語で引く)。
    let title: LocalizedStringResource
    /// コールの文言そのもの。押すと入力欄に入り、サーバに保存されるデータなので訳さない。
    let items: [String]
}

enum CallPalette {
    /// 組の名前は文言の値なので、static let に置かず呼ぶたびに作る (作った時点の言語で固まらないように)。
    static var groups: [CallPaletteGroup] {
        [
            CallPaletteGroup(id: "voice", title: L10n.Callguide.paletteGroupVoice, items: [
                "(Hi!)", "(Oi!)", "(Hey!!)", "(Fuu!)", "(FuFuu!)", "(Fuu--!)",
                // i18n-ignore(data): コールの文言そのもの (入力欄に入りサーバに保存される)。訳さない
                "(u--)", "（ふぅっ）", "(Fuwa × 4)", "(Yeah!)", "(Wow)", "(Woooo,Yeah!!)",
            ]),
            CallPaletteGroup(id: "clap", title: L10n.Callguide.paletteGroupClap, items: [
                "x　Pan! x Pan!", "Pan Pan Pan Pan!", "(Pan Pan Pan PaPan)",
                "Pan Pa Pan Hyu-!", "Oooo Hyu!",
            ]),
            CallPaletteGroup(id: "oh", title: L10n.Callguide.paletteGroupOh, items: [
                // i18n-ignore(data): コールの文言そのもの。訳さない
                "(o-- Hi!)", "(-- Hi!)", "（ハーイハーイハイハイハイハイ）", "（せーの！）",
            ]),
            CallPaletteGroup(id: "count", title: L10n.Callguide.paletteGroupCount, items: [
                // i18n-ignore(data): コールの文言そのもの。訳さない
                "3・2・1・GO!!",
                // i18n-ignore(data): コールの文言そのもの。訳さない
                "（いち・にの・さん・レッツ・ゴー！）",
                // i18n-ignore(data): コールの文言そのもの。訳さない
                "（いち・に・ついて・よ〜い・ドン！）",
            ]),
            CallPaletteGroup(id: "section", title: L10n.Callguide.paletteGroupSection, items: [
                // i18n-ignore(data): コールの文言そのもの (曲の区切りの札として歌詞に入る)。訳さない
                "（前奏）", "（間奏）",
            ]),
        ]
    }

    /// 「歌詞コール」= 選択した歌詞語をそのまま繰り返すコール。
    /// 固定文言では表現できないので、選択範囲から動的に組み立てる。
    /// 実物の表記に合わせて**全角括弧**で包む。
    static func lyricCall(anchorText: String) -> String? {
        let trimmed = anchorText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return "（\(trimmed)）"
    }
}

// MARK: - 強調度の配色

extension CallEmphasis {
    /// 強調度の色。凡例・コール文言・アンカーのハイライトで同じ色を使う。
    ///
    /// `normal` に本文と同じ `DS.ink` を使うと、太字なだけで歌詞と同化して
    /// 「どれがコールか」が一目で分からない (実機で確認)。曲の配色 (担当色 /
    /// ブランド色) を渡して、本文とは別の色にする。
    /// accent が無い文脈 (凡例のプレビュー等) だけ ink にフォールバックする。
    func color(accent: Color? = nil) -> Color {
        switch self {
        case .normal:           return accent ?? DS.ink
        case .optional:         return DS.success
        case .performerRequest: return DS.danger
        }
    }
}
