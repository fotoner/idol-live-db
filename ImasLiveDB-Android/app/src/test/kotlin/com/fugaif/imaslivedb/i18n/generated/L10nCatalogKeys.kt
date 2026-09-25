// 生成物: i18n/catalog/*.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.i18n.DisplayText

/**
 * カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。
 * L10nCatalogJaTest / L10nCatalogKoTest が実行時の解決結果と比べる (書式・エスケープ・桁区切り・複数形)。
 */
class L10nCatalogSample(
    /** 完全キー (<名前空間>.<相対キー>) */
    val key: String,
    /** リソース名 (R.string / R.plurals) */
    val resourceName: String,
    /** 値を持つ言語 (基準言語と、訳のある言語) */
    val languagesWithValue: List<String>,
    /** 見本の引数 (失敗メッセージ用) */
    val args: String,
    /** 見本の引数で作った文言 */
    val make: () -> DisplayText,
    /** 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック) */
    val expected: Map<String, String>,
) {
    /** 見本の引数で作った文言 (呼ぶたびに作る) */
    val text: DisplayText get() = make()

    override fun toString(): String = if (args.isEmpty()) key else "$key ($args)"
}

object L10nCatalogKeys {
    /** このカタログの言語 (基準言語が先頭) */
    val languages: List<String> = listOf("ja", "ko")

    /** 全キー × 見本 */
    val all: List<L10nCatalogSample>
        get() = i18n0()

    private fun i18n0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("i18n.language_tag", "i18n_language_tag", listOf("ja", "ko"), "", { L10n.I18n.languageTag }, mapOf("ja" to "ja", "ko" to "ko")),
    )
}
