package com.fugaif.imaslivedb.data.local

import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.yield
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/** 端末ローカルの書き込み失敗は握りつぶさず、知らせに流す (iOS LocalWriteFailureTests と同じ)。 */
@RunWith(RobolectricTestRunner::class)
class LocalWriteFailureTest {

    @Test
    fun failureIsReportedAndReturnsNull() = runBlocking {
        val notice = async { LocalWriteFailure.notices.first() }
        yield()
        val result = localWrite<Int>("メモの保存") { throw IllegalStateException("disk full") }
        assertNull(result)
        val got = notice.await()
        assertEquals(LocalWriteFailure.notice("メモの保存"), got)
        // 知らせは操作名を値で持つ (文字列の操作名はそのまま差し込むデータ)
        assertEquals(LocalWriteFailure.Notice(DisplayText.Verbatim("メモの保存")), got)
    }

    /**
     * カタログの文言 (`L10n.<Ns>.<key>`) で渡した操作名も、同じ知らせになって流れる。
     * 操作名は本文と同じ言語で文字列になってから差し込まれる (既定のリソースは ja)。
     */
    @Test
    fun failureWithDisplayTextActionIsReported() = runBlocking {
        val notice = async { LocalWriteFailure.notices.first() }
        yield()
        val action = L10n.EditFeed.opCreate
        assertNull(localWrite<Int>(action) { throw IllegalStateException("disk full") })
        assertEquals(LocalWriteFailure.notice(action), notice.await())
        val res = RuntimeEnvironment.getApplication().resources
        assertEquals(
            "追加に失敗しました。変更は保存されていません。もう一度お試しください。",
            LocalWriteFailure.notice(action).resolveMessage(res)
        )
    }

    /** 文面はカタログの文言。ja は移行前 (文字列を直に組み立てていたとき) と 1 バイトも変わらない。 */
    @Test
    fun noticeTextInJapaneseIsUnchanged() {
        val res = RuntimeEnvironment.getApplication().resources
        val notice = LocalWriteFailure.notice("メモの保存")
        assertEquals(L10n.EditFeed.localWriteFailedTitle.resolve(res), notice.resolveTitle(res))
        assertEquals("保存できませんでした", notice.resolveTitle(res))
        assertEquals(
            "メモの保存に失敗しました。変更は保存されていません。もう一度お試しください。",
            notice.resolveMessage(res)
        )
    }

    @Test
    fun successPassesTheValueThrough() = runBlocking {
        assertEquals(3, localWrite("メモの保存") { 3 })
    }
}
