package com.fugaif.imaslivedb.data.db.dao

import androidx.room.Dao
import androidx.room.Query
import com.fugaif.imaslivedb.data.model.Idol

@Dao
interface IdolDao {

    @Query("""
        SELECT DISTINCT i.* FROM idols i
        JOIN idol_brands ib ON i.id = ib.idol_id
        WHERE ib.brand_id = :brandId
        ORDER BY i.sort_order
    """)
    suspend fun fetchIdolsByBrand(brandId: String): List<Idol>

    @Query("SELECT * FROM idols WHERE id = :id LIMIT 1")
    suspend fun fetchIdol(id: String): Idol?

    /** タグが似ているアイドルの解決用。N+1を避けてIN句で一括取得する (SongDao.fetchSongsByIds と同型)。 */
    @Query("SELECT * FROM idols WHERE id IN (:ids)")
    suspend fun fetchIdolsByIds(ids: List<String>): List<Idol>

    @Query("SELECT COUNT(*) FROM idols")
    suspend fun fetchIdolCount(): Int
}
