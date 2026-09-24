package com.fugaif.imaslivedb.ui.polls

import android.app.Application
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * お題の状態の札 (iOS Poll.statusLabel と同じ文言)。カタログに移しても ja の表示が変わらないこと、
 * 締切が不明 (Long.MAX_VALUE) でも日数が Int に収まることを確かめる。
 */
@RunWith(RobolectricTestRunner::class)
@Config(qualifiers = "ja")
class PollStatusTextTest {

    private val app: Application = RuntimeEnvironment.getApplication()
    private val hour = 3_600_000L
    private val day = 24 * hour

    @Test
    fun endedPollSaysEnded() {
        assertEquals(L10n.Polls.statusEnded, pollStatusText(isActive = false, endsAtMs = System.currentTimeMillis() + day))
        assertEquals("終了", pollStatusText(isActive = false, endsAtMs = 0L).resolve(app))
    }

    @Test
    fun lastDaySaysClosesToday() {
        val text = pollStatusText(isActive = true, endsAtMs = System.currentTimeMillis() + hour)
        assertEquals(L10n.Polls.statusClosesToday, text)
        assertEquals("本日締切", text.resolve(app))
    }

    @Test
    fun daysLeftKeepsJapaneseText() {
        val text = pollStatusText(isActive = true, endsAtMs = System.currentTimeMillis() + 3 * day + hour)
        assertEquals(L10n.Polls.statusDaysLeft(days = 3), text)
        assertEquals("残り3日", text.resolve(app))
    }

    /**
     * 締切が不明だと Int.MAX_VALUE に頭打ちになり、ja は「残り2,147,483,647日」と桁区切り付きで出る
     * (もとは Long のままの日数で桁区切りなし)。format_change: grouping としてオーナーの判断を待つ。
     */
    @Test
    fun unknownDeadlineStaysInIntRange() {
        assertEquals(
            L10n.Polls.statusDaysLeft(days = Int.MAX_VALUE),
            pollStatusText(isActive = true, endsAtMs = Long.MAX_VALUE)
        )
    }
}
