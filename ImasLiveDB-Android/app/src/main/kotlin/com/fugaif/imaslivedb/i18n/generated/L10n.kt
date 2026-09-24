// 生成物: i18n/catalog/*.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

/**
 * カタログ (i18n/catalog) の文言への入口。名前空間ごとの object を同じ名前で並べる
 * (Kotlin の object は複数ファイルに分けて足せないため)。iOS と同じく L10n.<Ns>.<key> で引く。
 */
object L10n {
    val Common: L10nCommon get() = L10nCommon
    val I18n: L10nI18n get() = L10nI18n
    val Mypage: L10nMypage get() = L10nMypage
    val Nav: L10nNav get() = L10nNav
    val Search: L10nSearch get() = L10nSearch
    val Settings: L10nSettings get() = L10nSettings
    val Songs: L10nSongs get() = L10nSongs
    val System: L10nSystem get() = L10nSystem
    val Units: L10nUnits get() = L10nUnits
    val Widget: L10nWidget get() = L10nWidget
}
