// 生成物: i18n/catalog/search.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/search.json の文言 (表 Search)
    enum Search {
        /// {tab}に {count} — 他のタブの一致件数へ飛ぶチップ。tab はタブ名 (nav.tab.*)、count は件数。件数は今の表示どおり桁区切りしない (int) — 引数: tab (text), count (int)
        static func crossTabChip(tab: LocalizedStringResource, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("search.cross_tab.chip", defaultValue: "\(tab)に \(String(count))", table: "Search", bundle: L10n.bundle)
        }
        /// 別のタブ — 一覧の検索欄の下、「他のタブに N 件」チップ列の見出し
        static var crossTabHeader: LocalizedStringResource {
            LocalizedStringResource("search.cross_tab.header", defaultValue: "別のタブ", table: "Search", bundle: L10n.bundle)
        }
    }
}
