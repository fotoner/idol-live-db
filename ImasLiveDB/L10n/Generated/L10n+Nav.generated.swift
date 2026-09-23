// 生成物: i18n/catalog/nav.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/nav.json の文言 (表 Nav)
    enum Nav {
        /// 設定・マイ — 各タブ右上の歯車ボタン (設定・マイページを開く) の読み上げ
        static var settingsButtonA11y: LocalizedStringResource {
            LocalizedStringResource("nav.settings_button.a11y", defaultValue: "設定・マイ", table: "Nav", bundle: L10n.bundle)
        }
    }
}
