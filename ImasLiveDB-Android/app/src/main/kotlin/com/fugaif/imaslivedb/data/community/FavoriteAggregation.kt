package com.fugaif.imaslivedb.data.community

import android.content.Context
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import org.json.JSONArray
import org.json.JSONObject

/**
 * 曲のお気に入りを、みんなの集計 (`POST /favorites/toggle`、端末単位で重複を除く) に送る。
 * iOS `UserMarkService.setBool` + `PendingCommunityActions` と同じ振る舞い:
 * 付け外しのたびに背景で送り、失敗したら端末に積んでおき、あとで送り直す (最大 3 回まで)。
 * 同じ曲の未送信が残っているときは、最後の値だけを送る。
 *
 * @param send 1 件送る。失敗したら例外を投げる。
 */
class FavoriteAggregation(
    context: Context,
    private val scope: CoroutineScope,
    private val send: suspend (songId: String, value: Boolean) -> Unit
) {
    private val prefs = context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    private val lock = Mutex()

    private data class Pending(val songId: String, val value: Boolean, val retryCount: Int)

    /** お気に入りを付け外しした直後に呼ぶ。送るのは背景で、画面は待たない。 */
    fun report(songId: String, value: Boolean) {
        scope.launch {
            try {
                send(songId, value)
            } catch (e: Exception) {
                Log.w(TAG, "favorite toggle failed, enqueue: $songId", e)
                lock.withLock { save(load().filter { it.songId != songId } + Pending(songId, value, 0)) }
            }
        }
    }

    /** 積んである未送信を送り直す (アプリが前面に出たとき)。 */
    suspend fun flushPending() = lock.withLock {
        val remaining = load().mapNotNull { action ->
            try {
                send(action.songId, action.value)
                null
            } catch (e: Exception) {
                val retried = action.copy(retryCount = action.retryCount + 1)
                if (retried.retryCount < MAX_RETRIES) retried else {
                    Log.w(TAG, "giving up favorite toggle: ${action.songId}", e)
                    null
                }
            }
        }
        save(remaining)
    }

    private fun load(): List<Pending> = runCatching {
        val arr = JSONArray(prefs.getString(KEY_ACTIONS, "[]"))
        (0 until arr.length()).map { i ->
            val o = arr.getJSONObject(i)
            Pending(o.getString("songId"), o.getBoolean("value"), o.optInt("retryCount"))
        }
    }.getOrDefault(emptyList())

    private fun save(actions: List<Pending>) {
        val arr = JSONArray(actions.map {
            JSONObject().put("songId", it.songId).put("value", it.value).put("retryCount", it.retryCount)
        })
        prefs.edit().putString(KEY_ACTIONS, arr.toString()).apply()
    }

    private companion object {
        const val TAG = "FavoriteAggregation"
        const val PREFS_NAME = "pending_favorite_actions"
        const val KEY_ACTIONS = "actions"
        /** iOS `PendingCommunityActions.maxRetries` と同じ。 */
        const val MAX_RETRIES = 3
    }
}
