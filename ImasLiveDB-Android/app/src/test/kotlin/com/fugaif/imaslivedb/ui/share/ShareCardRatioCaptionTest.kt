package com.fugaif.imaslivedb.ui.share

import com.fugaif.imaslivedb.i18n.resolve
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * シェアカードの縦横比の補助ラベル ([ShareCardRatio.caption]) は文言の値 (DisplayText) で持ち、
 * 描く側の言語で引く。ja は移行前の文字列 (正方形 / 縦長 / ストーリーズ) と同じ。
 */
@RunWith(RobolectricTestRunner::class)
class ShareCardRatioCaptionTest {

    @Test
    @Config(qualifiers = "ja")
    fun captionsInJaAreUnchanged() {
        val app = RuntimeEnvironment.getApplication()
        assertEquals(listOf("正方形", "縦長", "ストーリーズ"), ShareCardRatio.ALL.map { it.caption.resolve(app) })
    }

    @Test
    @Config(qualifiers = "ko")
    fun captionsFollowTheDisplayLanguage() {
        val app = RuntimeEnvironment.getApplication()
        assertEquals(listOf("정사각형", "세로형", "스토리"), ShareCardRatio.ALL.map { it.caption.resolve(app) })
    }
}
