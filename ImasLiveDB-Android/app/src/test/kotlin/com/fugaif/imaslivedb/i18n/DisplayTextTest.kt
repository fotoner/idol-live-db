package com.fugaif.imaslivedb.i18n

import com.fugaif.imaslivedb.i18n.generated.L10n
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/**
 * データ (Verbatim) とコア由来 (Core) は、訳さず・書式に通さず・エスケープもせずにそのまま出る。
 * 移行中の String 入口 (deprecated) はこれで未移行の呼び出しを今と同じに描く。
 */
@RunWith(RobolectricTestRunner::class)
class DisplayTextTest {

    private val app = RuntimeEnvironment.getApplication()

    /** 書式指定子・自リソース参照・引用符・前後の空白を含んでも、そのまま出る。 */
    private val raw = listOf(
        "すべて見る",
        "50%オフ",
        "%1\$s ・ %2\$d名",
        "%d",
        "{count}曲",
        "@string/foo",
        "?attr/colorPrimary",
        "It's \"quoted\" <b>&amp;</b>",
        "  前後に空白  ",
        "",
    )

    @Test
    fun verbatimPassesThrough() {
        raw.forEach { s ->
            assertEquals(s, DisplayText.Verbatim(s).resolve(app))
            assertEquals(s, DisplayText.Verbatim(s).resolve(app.resources))
        }
    }

    @Test
    fun corePassesThrough() {
        raw.forEach { s ->
            assertEquals(s, DisplayText.Core(s).resolve(app))
            assertEquals(s, DisplayText.Core(s).resolve(app.resources))
            assertEquals(s, coreText(s))
        }
    }

    /** データとコア由来は同じ文字列でも別の値 (コア段階の置換リストで数えられるように)。 */
    @Test
    fun verbatimAndCoreAreDistinctMarkers() {
        assertEquals(DisplayText.Verbatim("欠席"), DisplayText.Verbatim("欠席"))
        assertEquals(DisplayText.Core("欠席"), DisplayText.Core("欠席"))
        assertNotEquals(DisplayText.Verbatim("欠席"), DisplayText.Core("欠席"))
    }

    /** 文言は値で比べられる (ViewModel のテストは解決せずに DisplayText の等価で確かめる)。 */
    @Test
    fun catalogTextIsComparedByValue() {
        assertEquals(L10n.I18n.languageTag, L10n.I18n.languageTag)
        assertEquals(L10n.I18n.languageTag.resolve(app), L10n.I18n.languageTag.resolve(app.resources))
    }
}
