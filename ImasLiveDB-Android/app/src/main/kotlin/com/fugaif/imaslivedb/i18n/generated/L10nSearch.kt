// 生成物: i18n/catalog/search.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/search.json の文言。L10n.Search から引く (iOS の L10n.Search と同じ名前)。 */
object L10nSearch {
    /** {tab}に {count} — 他のタブの一致件数へ飛ぶチップ。tab はタブ名 (nav.tab.*)、count は件数。件数は今の表示どおり桁区切りしない (int) — 引数: tab (text), count (int) */
    fun crossTabChip(tab: DisplayText, count: Int): DisplayText = DisplayText.Res(R.string.search_cross_tab_chip, listOf(tab, count))
    /** 別のタブ — 一覧の検索欄の下、「他のタブに N 件」チップ列の見出し */
    val crossTabHeader: DisplayText get() = DisplayText.Res(R.string.search_cross_tab_header)
}
