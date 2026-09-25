import Foundation

/// 画面に実際に出ている言語。`Locale.current` ではなく、カタログの `i18n.language_tag` を解決して得る。
///
/// 未対応言語の端末でフォールバック中でも、実際に引かれた表の言語になる。
/// 出荷ゲート (XCSTRINGS_LANGUAGES_TO_COMPILE) で外した言語も自動で反映される。
/// Android の `DisplayLocale` と同じ規則。
struct DisplayLocale: Sendable, Equatable {
    /// "ja" / "ko"。カタログの i18n.language_tag の値そのもの。
    let languageTag: String
    /// 日付・数値の書式に使うロケール。言語と文字体系は languageTag、地域などは端末設定。
    let formattingLocale: Locale

    /// 呼ぶたびに表を引く (キャッシュしない。LocalizedStringResource と同じく作った時点の言語で固まるため)。
    static var current: DisplayLocale {
        let tag = String(localized: L10n.I18n.languageTag)
        let language = Locale.Language.Components(identifier: tag)
        var components = Locale.Components(locale: .current)
        // languageComponents ごと差し替えると地域 (region) まで消える。言語と文字体系だけ差し替える
        // (端末の文字体系は残さない。"sr-Latn" の端末で ja にしたとき "ja-Latn" にならないように)
        components.languageComponents.languageCode = language.languageCode
        components.languageComponents.script = language.script
        return DisplayLocale(languageTag: tag, formattingLocale: Locale(components: components))
    }
}
