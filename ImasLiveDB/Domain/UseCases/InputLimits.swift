import Foundation

/// 入力欄の上限と数え方 (タグ名 30・タグの説明 300・表示名 40・お題 80・お題の説明 280)。
///
/// 上限の値も数え方 (表示名はコードポイント、ほかはサーバの `.length` と同じ UTF-16)、
/// 前後の空白を除くか、空を許すかも、コア (`input_limit_max` / `input_length` /
/// `input_clamp` / `input_is_acceptable`) が決める。ここは画面の言い回しに包むだけ。
enum InputLimits {
    /// 「N / 上限文字」の数え。`separator` と `unit` は画面ごとの今の見た目に合わせる。
    ///
    /// 単位の既定 (文字) は訳されない (移行中。TagCreateSheet がまだ既定の単位で呼ぶ)。
    /// 単位付きの数えを画面に出すときは `counterText` を使う
    /// (Domain は文言を文字列に解決しないので、ここで今の言語の単位を引けない)。
    static func counter(_ field: InputField, _ text: String,
                        separator: String = " / ", unit: String = "文字") -> String {
        "\(inputLength(field: field, text: text))\(separator)\(inputLimitMax(field: field))\(unit)"
    }

    /// 「N / 上限文字」の数えの文言 (ja: 12 / 30文字 / ko: 12 / 30자)。画面で Text か String(localized:) にする。
    /// ja は `counter(field, text)` (既定の区切りと単位) と同じ文字列になる。
    static func counterText(_ field: InputField, _ text: String) -> LocalizedStringResource {
        L10n.Model.inputLimitsCounter(length: Int(inputLength(field: field, text: text)),
                                      max: Int(inputLimitMax(field: field)))
    }

    /// 入力が変わるたびに通す (上限で切る。文字の途中では切らない)。
    static func clamp(_ field: InputField, _ text: String) -> String {
        inputClamp(field: field, text: text)
    }

    /// 送信してよいか。
    static func isAcceptable(_ field: InputField, _ text: String) -> Bool {
        inputIsAcceptable(field: field, text: text)
    }

    static func max(_ field: InputField) -> Int { Int(inputLimitMax(field: field)) }
}
