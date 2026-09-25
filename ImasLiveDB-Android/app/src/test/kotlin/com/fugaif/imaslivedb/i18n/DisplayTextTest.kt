package com.fugaif.imaslivedb.i18n

import com.fugaif.imaslivedb.i18n.generated.L10n
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/** データ (Verbatim) とコア由来 (Core) は、訳さず・書式に通さず・エスケープもせずにそのまま出る。 */
@RunWith(RobolectricTestRunner::class)
class DisplayTextTest {

    private val app = RuntimeEnvironment.getApplication()

    @Test
    fun verbatimAndCorePassThrough() {
        // 書式指定子・自リソース参照・引用符も、そのまま出る
        val s = "%1\$s 50%オフ @string/foo It's \"quoted\""
        assertEquals(s, DisplayText.Verbatim(s).resolve(app))
        assertEquals(s, DisplayText.Core(s).resolve(app))
    }

    @Test
    fun catalogTextResolvesThroughResources() {
        assertEquals("ja", L10n.I18n.languageTag.resolve(app))
    }
}
