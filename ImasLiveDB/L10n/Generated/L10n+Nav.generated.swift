// 生成物: i18n/catalog/nav.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/nav.json の文言 (表 Nav)
    enum Nav {
        /// 設定・マイ — 各タブ右上の歯車ボタン (設定・マイページを開く) の読み上げ
        static var settingsButtonA11y: LocalizedStringResource {
            LocalizedStringResource("nav.settings_button.a11y", defaultValue: "設定・マイ", table: "Nav", bundle: L10n.bundle)
        }
        /// ライブ — 下のタブバーのラベル (ライブ・公演の一覧)
        static var tabEvents: LocalizedStringResource {
            LocalizedStringResource("nav.tab.events", defaultValue: "ライブ", table: "Nav", bundle: L10n.bundle)
        }
        /// アイドル — 下のタブバーのラベル (アイドルの一覧)
        static var tabIdols: LocalizedStringResource {
            LocalizedStringResource("nav.tab.idols", defaultValue: "アイドル", table: "Nav", bundle: L10n.bundle)
        }
        /// プロデュース — 下のタブバーのラベル (プロデュース = マイページ的なハブ)
        static var tabProduce: LocalizedStringResource {
            LocalizedStringResource("nav.tab.produce", defaultValue: "プロデュース", table: "Nav", bundle: L10n.bundle)
        }
        /// スケジュール — 下のタブバーのラベル (スケジュール = カレンダー)
        static var tabSchedule: LocalizedStringResource {
            LocalizedStringResource("nav.tab.schedule", defaultValue: "スケジュール", table: "Nav", bundle: L10n.bundle)
        }
        /// 楽曲 — 下のタブバーのラベル (楽曲の一覧)
        static var tabSongs: LocalizedStringResource {
            LocalizedStringResource("nav.tab.songs", defaultValue: "楽曲", table: "Nav", bundle: L10n.bundle)
        }
    }
}
