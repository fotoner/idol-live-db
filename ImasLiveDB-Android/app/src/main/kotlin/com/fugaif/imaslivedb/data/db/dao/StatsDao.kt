package com.fugaif.imaslivedb.data.db.dao

import androidx.room.Dao
import androidx.room.Query

@Dao
interface StatsDao {

    @Query("SELECT COUNT(*) FROM songs")
    suspend fun fetchSongCount(): Int

    @Query("SELECT COUNT(*) FROM idols")
    suspend fun fetchIdolCount(): Int

    @Query("SELECT COUNT(*) FROM events")
    suspend fun fetchEventCount(): Int

    @Query("SELECT COUNT(*) FROM shows")
    suspend fun fetchShowCount(): Int

    // MARK: - Collection Dashboard (iOS AppDatabase の回収ダッシュボード関連クエリの移植)

    /**
     * ユーザが参加した「リアルライブ」のセトリに含まれる全 song_id (回収済み)。
     * 回収はリアルライブ(live/festival)のみ・参加種別は現地のみ (iOS の配信含む設定は未移植、既定値で固定)。
     */
    @Query("""
        SELECT DISTINCT si.song_id
        FROM setlist_items si
        JOIN shows sh ON si.show_id = sh.id
        JOIN events e ON e.id = sh.event_id
        WHERE e.kind IN ('live','festival')
        AND (
            sh.id IN (
                SELECT entity_id FROM user_marks
                WHERE entity_type='show' AND kind='attended' AND bool_value=1
                  AND (text_value IS NULL OR text_value='live')
            )
            OR sh.event_id IN (
                SELECT entity_id FROM user_marks
                WHERE entity_type='event' AND kind='attended' AND bool_value=1
            )
        )
    """)
    suspend fun fetchAutoCollectedSongIds(): List<String>

    /** 最新公演のセトリ曲数。 */
    @Query("SELECT COUNT(*) FROM setlist_items WHERE show_id = :showId")
    suspend fun fetchSetlistCount(showId: String): Int
}
