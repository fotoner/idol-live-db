package com.fugaif.imaslivedb.data.notification

import android.Manifest
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.Shadows.shadowOf

/** 通知の予定表を作れなかったとき、今の予約を消さずに残す (RedTeam A-M2)。 */
@RunWith(RobolectricTestRunner::class)
class NotificationSchedulerTest {

    private val app = RuntimeEnvironment.getApplication()

    @Test
    fun failedPlanKeepsTheCurrentReservations() = runBlocking {
        shadowOf(app).grantPermissions(Manifest.permission.POST_NOTIFICATIONS)
        val prefs = NotificationPrefs(app)
        prefs.setScheduledIds(listOf("bday_a", "monday_meme_0"))

        NotificationScheduler.rescheduleAll(app) { _, _, _ -> throw IllegalStateException("snapshot unavailable") }

        assertEquals(setOf("bday_a", "monday_meme_0"), prefs.scheduledIds().toSet())
    }

    @Test
    fun successfulPlanReplacesTheReservations() = runBlocking {
        shadowOf(app).grantPermissions(Manifest.permission.POST_NOTIFICATIONS)
        val prefs = NotificationPrefs(app)
        prefs.setScheduledIds(listOf("bday_a"))

        NotificationScheduler.rescheduleAll(app) { _, _, _ -> emptyList() }

        assertEquals(emptyList<String>(), prefs.scheduledIds())
    }
}
