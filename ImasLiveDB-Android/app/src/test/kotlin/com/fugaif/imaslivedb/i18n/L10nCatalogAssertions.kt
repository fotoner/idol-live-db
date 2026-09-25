package com.fugaif.imaslivedb.i18n

import android.content.Context
import com.fugaif.imaslivedb.i18n.generated.L10nCatalogKeys
import org.junit.Assert.assertTrue

/**
 * 生成物 [L10nCatalogKeys.all] の全項目を [context] の言語で解決し、`expected[lang]` と比べる。
 * 食い違いは 1 件目で止めずに全部並べる (生成器と実行時のどちらがずれたかを一度に見るため)。
 *
 * [lang] の期待値が無い項目は、実行時も既定の values/ (ja) に落ちるので ja の期待値と比べる。
 * それで素通りにならないよう、言語ごとのテストは i18n.language_tag が [lang] になることも確かめる
 * (debug の overlay が効いていないと ko の表そのものが無い)。
 */
internal fun assertCatalogRenders(context: Context, lang: String) {
    val entries = L10nCatalogKeys.all
    assertTrue("L10nCatalogKeys.all が空 (生成物が古い? python3 tools/i18n/i18n.py generate)", entries.isNotEmpty())
    val mismatches = entries.mapNotNull { entry ->
        val expected = entry.expected[lang] ?: entry.expected["ja"]
            ?: return@mapNotNull "${entry.key}: 期待値が無い (expected=${entry.expected.keys})"
        val actual = runCatching { entry.text.resolve(context) }
            .getOrElse { return@mapNotNull "${entry.key}: 解決できない ${it::class.simpleName}: ${it.message}" }
        if (actual == expected) null else "${entry.key}: 期待 «$expected» / 実際 «$actual»"
    }
    assertTrue("$lang で期待と違う文言が ${mismatches.size} 件:\n" + mismatches.joinToString("\n"), mismatches.isEmpty())
}
