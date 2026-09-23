package com.fugaif.imaslivedb.i18n

import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * カタログの全キーを ja で解決し、生成器が計算した期待値と突き合わせる (iOS L10nCatalogTests と対)。
 * 引数の順序・エスケープ・`%` の扱い・桁区切り (count は 1,234 / int は 2026)・複数形の経路をまとめて確かめる。
 *
 * 既定の qualifiers は robolectric.properties で ja だが、この検査は言語が前提なので明示する。
 */
@RunWith(RobolectricTestRunner::class)
@Config(qualifiers = "ja")
class L10nCatalogJaTest {

    private val app = RuntimeEnvironment.getApplication()

    /** 表示言語は端末の言語ではなく、引けた表の i18n.language_tag で決まる。 */
    @Test
    fun displayLocaleIsJa() {
        val locale = DisplayLocale.of(app)
        assertEquals("ja", locale.languageTag)
        assertEquals("ja", locale.formattingLocale.language)
    }

    @Test
    fun everyKeyRendersTheExpectedJa() {
        assertCatalogRenders(app, "ja")
    }
}
