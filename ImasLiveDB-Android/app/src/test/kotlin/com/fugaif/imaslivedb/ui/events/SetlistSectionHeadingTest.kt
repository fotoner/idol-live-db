package com.fugaif.imaslivedb.ui.events

import com.fugaif.imaslivedb.data.model.Venue
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/**
 * ライブまわり (events 名前空間) の表示文言のうち、コアの語との突き合わせと会場の表示。
 * 既定の言語は ja (robolectric.properties)。ja は移行前にコードが出していた文字列と同じであること。
 */
@RunWith(RobolectricTestRunner::class)
class SetlistSectionHeadingTest {

    private val app = RuntimeEnvironment.getApplication()

    /** メタ未取得 (null) とコアの「本編」は同じ文言になる (読み込みの前後で見出しの言語が入れ替わらない)。 */
    @Test
    fun mainHeadingIsSameBeforeAndAfterMeta() {
        assertEquals(L10n.Events.setlistSectionMain, sectionHeadingText(null))
        assertEquals(L10n.Events.setlistSectionMain, sectionHeadingText("本編"))
        assertEquals("本編", sectionHeadingText(null).resolve(app))
    }

    @Test
    fun encoreMapsToCatalog() {
        assertEquals(L10n.Events.setlistSectionEncore, sectionHeadingText("アンコール"))
        assertEquals("アンコール", sectionHeadingText("アンコール").resolve(app))
    }

    /** 知らない見出し (自由文字列) はコアの文字列のまま出す。 */
    @Test
    fun unknownHeadingPassesThroughAsCore() {
        assertEquals(DisplayText.Core("MC"), sectionHeadingText("MC"))
        assertEquals("Day1 前半", sectionHeadingText("Day1 前半").resolve(app))
    }

    /** キャパは人数 (count) なので桁区切りが付く (移行前も "%,d人" で付いていた)。 */
    @Test
    fun venueCapacityIsGrouped() {
        assertEquals("14,500人", Venue(id = "v", name = "日本武道館", capacity = 14500).capacityLabel?.resolve(app))
        assertNull(Venue(id = "u", name = "会場").capacityLabel)
    }

    @Test
    fun venueNameWithArea() {
        assertEquals("東京・日本武道館", Venue(id = "v", name = "日本武道館", prefecture = "東京").displayNameWithArea.resolve(app))
        assertEquals(DisplayText.Verbatim("日本武道館"), Venue(id = "v", name = "日本武道館").displayNameWithArea)
    }
}
