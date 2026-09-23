package com.fugaif.imaslivedb.data.db.dao

import androidx.room.Dao
import androidx.room.Query
import com.fugaif.imaslivedb.data.model.Event
import com.fugaif.imaslivedb.data.model.EventWithDateRangeRow

@Dao
interface EventDao {

    @Query("SELECT * FROM events")
    suspend fun fetchEvents(): List<Event>

    @Query("""
        SELECT e.id, e.brand_id, e.name, e.event_type, e.is_streaming, e.joint_brand_ids,
               MIN(s.date) AS first_date, MAX(s.date) AS last_date
        FROM events e
        LEFT JOIN shows s ON s.event_id = e.id
        GROUP BY e.id
        ORDER BY COALESCE(MIN(s.date), '') DESC
    """)
    suspend fun fetchEventsWithFirstDate(): List<EventWithDateRangeRow>
}
