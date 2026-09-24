package com.fugaif.imaslivedb.data.local

import android.content.res.Resources
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.asSharedFlow

/**
 * 端末にしか無いデータ (担当・参加・メモ・座席・習熟度・家計簿・マイタグ) の書き込み失敗を 1 か所で受ける。
 * iOS `LocalWriteFailure` と同じ。
 *
 * これらはクラウドにもサーバにも無いので、書けなかったことを黙っていると、保存したつもりの
 * 記録が次に開いたときに消えている。画面は握りつぶさず、[localWrite] を通して失敗をここへ渡す。
 * ログに残し、利用者にはアラートで知らせる (出すのはアプリのルート。[notices] を見ている)。
 */
object LocalWriteFailure {
    private const val TAG = "LocalWrite"

    /**
     * 利用者に見せる知らせ (iOS と同じ文面)。何をしようとして失敗したか ([action]) だけを値で持ち、
     * 文面は出す口 (アプリのルートのアラート) が画面の言語で作る。
     * 書き込みは 1 トランザクションなので、失敗したら何も変わっていない。それをそのまま伝える。
     */
    data class Notice(val action: DisplayText) {
        /** アラートの見出し (画面の言語)。 */
        val title: String
            @Composable @ReadOnlyComposable get() = L10n.EditFeed.localWriteFailedTitle.resolve()

        /** アラートの本文 (画面の言語)。操作名も同じ言語で文字列にしてから差し込む。 */
        val message: String
            @Composable @ReadOnlyComposable get() =
                L10n.EditFeed.localWriteFailedMessage(action = action.resolve()).resolve()

        /** [res] の言語の見出し (Compose の外・テスト)。 */
        fun resolveTitle(res: Resources): String = L10n.EditFeed.localWriteFailedTitle.resolve(res)

        /** [res] の言語の本文 (Compose の外・テスト)。 */
        fun resolveMessage(res: Resources): String =
            L10n.EditFeed.localWriteFailedMessage(action = action.resolve(res)).resolve(res)
    }

    private val _notices = MutableSharedFlow<Notice>(
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    /** 知らせの流れ。アプリのルートが 1 つずつアラートにする。 */
    val notices: SharedFlow<Notice> = _notices.asSharedFlow()

    /** @param action 何をしようとして失敗したか。文言は `L10n.<Ns>.<key>` で渡す。 */
    fun report(error: Throwable, action: DisplayText) {
        Log.e(TAG, "local_write_failed action=${logName(action)}", error)
        _notices.tryEmit(notice(action))
    }

    /**
     * ログに出す操作名。文字列の操作名はそのまま (移行前と同じ `action=メモの保存`)、
     * カタログの文言は Context が無いので文字列にせず、リソース id で残す
     * (DisplayText の toString だと `Res(id=…, args=[])` になり読めない)。
     */
    private fun logName(action: DisplayText): String = when (action) {
        is DisplayText.Verbatim -> action.value
        is DisplayText.Core -> action.value
        is DisplayText.Res -> "res:0x" + Integer.toHexString(action.id)
        is DisplayText.Plural -> "plural:0x" + Integer.toHexString(action.id)
    }

    /**
     * 操作名を文字列で受ける入口 (例: "メモの保存")。まだ日本語の文字列のまま渡す画面があるので残す。
     * 文字列はそのまま ([DisplayText.Verbatim]) 文に差し込む。
     */
    fun report(error: Throwable, action: String) = report(error, DisplayText.Verbatim(action))

    /** 失敗した操作の名前から、知らせを作る。 */
    fun notice(action: DisplayText): Notice = Notice(action)

    /** 操作名が文字列のときの [notice] (そのまま差し込む)。 */
    fun notice(action: String): Notice = notice(DisplayText.Verbatim(action))
}

/**
 * 端末ローカルの書き込みを 1 回行う。失敗したら [LocalWriteFailure] で知らせて null を返す
 * (呼び出し側は null なら「保存できなかった」として、入力を捨てない・画面を閉じない)。
 *
 * @param action 何をしようとして失敗したか。文言は `L10n.<Ns>.<key>` で渡す。
 */
suspend fun <T> localWrite(action: DisplayText, block: suspend () -> T): T? =
    try {
        block()
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        LocalWriteFailure.report(e, action)
        null
    }

/** 操作名を文字列で受ける [localWrite] (まだ日本語の文字列のまま渡す画面向け。そのまま差し込む)。 */
suspend fun <T> localWrite(action: String, block: suspend () -> T): T? =
    localWrite(DisplayText.Verbatim(action), block)
