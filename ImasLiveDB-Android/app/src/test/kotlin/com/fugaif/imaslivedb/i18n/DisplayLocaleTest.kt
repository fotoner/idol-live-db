package com.fugaif.imaslivedb.i18n

import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * 書式のロケールは、言語と文字体系を表示言語から、地域を端末から取る。
 * 端末の文字体系 (sr-Latn の Latn) を残すと ja-Latn になり、日付がセルビア語の並びに崩れる。
 */
@RunWith(RobolectricTestRunner::class)
@Config(qualifiers = "b+sr+Latn+RS")
class DisplayLocaleTest {

    @Test
    fun deviceScriptIsDropped() {
        val locale = DisplayLocale.of(RuntimeEnvironment.getApplication())
        assertEquals("ja", locale.languageTag)
        assertEquals("ja", locale.formattingLocale.language)
        assertEquals("", locale.formattingLocale.script)
        assertEquals("RS", locale.formattingLocale.country)
    }
}
