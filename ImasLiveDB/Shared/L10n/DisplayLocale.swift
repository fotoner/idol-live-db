import Foundation

/// 画面に実際に出ている言語。`Locale.current` ではなく、カタログの `i18n.language_tag` を解決して得る。
///
/// 未対応言語の端末でフォールバック中でも、実際に引かれた表の言語になる。
/// 出荷ゲート (XCSTRINGS_LANGUAGES_TO_COMPILE) で外した言語も自動で反映される。
/// Android の `DisplayLocale` と同じ規則。将来コアの FFI に渡す locale もこれを出どころにする。
struct DisplayLocale: Sendable, Equatable {
    /// "ja" / "ko"。カタログの i18n.language_tag の値そのもの。
    let languageTag: String
    /// 日付・曜日の書式に使うロケール。言語は languageTag、地域は端末設定
    /// (暦は DisplayFormat がグレゴリオ暦に固定する)。
    let formattingLocale: Locale

    /// 呼ぶたびに表を引く (キャッシュしない。LocalizedStringResource と同じく作った時点の言語で固まるため)。
    static var current: DisplayLocale {
        let tag = String(localized: L10n.I18n.languageTag)
        var components = Locale.Components(locale: .current)
        // languageComponents ごと差し替えると地域 (region) まで消える。言語コードだけ差し替え、
        // 文字体系は言語に合わせて付け直させる (Android の Locale.Builder().setLanguage と同じ結果)
        components.languageComponents.languageCode = Locale.LanguageCode(tag)
        components.languageComponents.script = nil
        return DisplayLocale(languageTag: tag, formattingLocale: Locale(components: components))
    }
}
