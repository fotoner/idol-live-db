package com.fugaif.imaslivedb.i18n

import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * [L10nCatalogJaTest] と同じ検査を ko で行う。
 *
 * ko は channel=dev なので values-ko は debug の overlay (app/i18n/debug) にだけある。JVM の単体テストは
 * debug でだけ回り、Robolectric は debug の統合済みリソースを見るので、ここから ko の表が引ける。
 * ko の訳が無いキーは values/ (ja) に落ちる (期待値も同じ)。
 */
@RunWith(RobolectricTestRunner::class)
@Config(qualifiers = "ko")
class L10nCatalogKoTest {

    private val app = RuntimeEnvironment.getApplication()

    /** ko の表が実際に引けている (debug の overlay が効いている) こと。 */
    @Test
    fun displayLocaleIsKo() {
        val locale = DisplayLocale.of(app)
        assertEquals("ko", locale.languageTag)
        assertEquals("ko", locale.formattingLocale.language)
    }

    @Test
    fun everyKeyRendersTheExpectedKo() {
        assertCatalogRenders(app, "ko")
    }
}
