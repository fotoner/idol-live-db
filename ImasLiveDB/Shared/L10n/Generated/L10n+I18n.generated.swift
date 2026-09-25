// 生成物: i18n/catalog/i18n.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/i18n.json の文言 (表 I18n)
    enum I18n {
        /// ja — 実際に解決された表示言語のコード。訳文ではなく言語コードを入れる (DisplayLocale がこれを読む)
        static var languageTag: LocalizedStringResource {
            LocalizedStringResource("i18n.language_tag", defaultValue: "ja", table: "I18n", bundle: L10n.bundle)
        }
    }
}
