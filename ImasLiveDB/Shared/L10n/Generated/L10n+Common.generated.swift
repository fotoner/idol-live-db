// 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/common.json の文言 (表 Common)
    enum Common {
        /// ログイン — 未ログインの人に出すインライン導線 (InlineLoginPrompt) のボタン。Android は同じ部品を持たずダイアログで案内する
        static var actionLogin: LocalizedStringResource {
            LocalizedStringResource("common.action.login", defaultValue: "ログイン", table: "Common", bundle: L10n.bundle)
        }
        /// 再試行 — 読み込み失敗などの空状態に出す再試行ボタン
        static var actionRetry: LocalizedStringResource {
            LocalizedStringResource("common.action.retry", defaultValue: "再試行", table: "Common", bundle: L10n.bundle)
        }
        /// すべて見る — セクション見出し右の導線
        static var actionSeeAll: LocalizedStringResource {
            LocalizedStringResource("common.action.see_all", defaultValue: "すべて見る", table: "Common", bundle: L10n.bundle)
        }
    }
}
