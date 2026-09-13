package com.fugaif.imaslivedb.data.repository

import androidx.room.Room
import com.fugaif.imaslivedb.data.db.AppDatabase
import com.fugaif.imaslivedb.data.model.Song
import com.fugaif.imaslivedb.data.model.SongSearchFilter
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/**
 * [SongRepository.fetchSongs] の SQL フォールバック経路 (スナップショット未ロード時) の回帰テスト。
 *
 * RedTeam 指摘 (H-1): コア (`song_list_queries.rs`) と iOS (`AppDatabase+SongQueries.swift`)
 * には「`kamisabiOnly` 中は既定のリミックス除外を効かせない」上書きが入っているのに、
 * Android の SQL フォールバックだけこれが無かった。KAMISABI のカードは
 * `Welcome!! (レジェンドデイズ Ver.)` のような派生曲にも付くため、これを漏らすと
 * スナップショット未ロード時の一覧が 149 件になり、コア経路 (150 件) と食い違う。
 *
 * Room は JVM 単体テストではそのまま動かないため Robolectric 上で実 DB (in-memory) を組む。
 */
@RunWith(RobolectricTestRunner::class)
class SongRepositoryKamisabiFallbackTest {

    private lateinit var db: AppDatabase
    private lateinit var repository: SongRepository

    @Before
    fun setUp() {
        db = Room.inMemoryDatabaseBuilder(RuntimeEnvironment.getApplication(), AppDatabase::class.java)
            .allowMainThreadQueries()
            .build()
        // snapshots = null で常に SQL フォールバック経路を通す (スナップショット未ロードの再現)。
        repository = SongRepository(db, snapshots = null)
    }

    @After
    fun tearDown() {
        db.close()
    }

    @Test
    fun kamisabiOnlyFallbackIncludesRemixesWithTheCard() = runBlocking {
        // 通常の派生曲 (KAMISABI 収録なし) — includeRemixes=false のときは既定通り隠れる。
        db.syncDao().upsertSongs(
            listOf(
                baseSong(id = "ml_welcome", parentSongId = null, hasKamisabiCard = true),
                baseSong(id = "ml_welcome_legend_days_ver", parentSongId = "ml_welcome", hasKamisabiCard = true),
                baseSong(id = "ml_other_remix", parentSongId = "ml_welcome", hasKamisabiCard = false)
            )
        )

        val kamisabiOnly = repository.fetchSongs(SongSearchFilter(kamisabiOnly = true, excludeLiveOnly = false))
        val ids = kamisabiOnly.map { it.song.id }.toSet()

        assertTrue(
            "KAMISABI 収録の派生曲 (Welcome!! レジェンドデイズ Ver. 相当) を落としてはいけない",
            ids.contains("ml_welcome_legend_days_ver")
        )
        assertTrue(ids.contains("ml_welcome"))
        assertTrue(
            "KAMISABI 収録が無い派生曲は絞り込み対象外のまま",
            !ids.contains("ml_other_remix")
        )

        // 対照: kamisabiOnly=false かつ includeRemixes=false (既定) では派生曲は従来通り隠れる。
        val withoutKamisabiFilter = repository.fetchSongs(SongSearchFilter(excludeLiveOnly = false))
        val idsWithout = withoutKamisabiFilter.map { it.song.id }.toSet()
        assertTrue(
            "kamisabiOnly を付けていないときは既定のリミックス除外が従来通り効く",
            !idsWithout.contains("ml_welcome_legend_days_ver")
        )
    }

    private fun baseSong(id: String, parentSongId: String?, hasKamisabiCard: Boolean) = Song(
        id = id,
        title = id,
        titleKana = null,
        brandId = "ml",
        songType = "solo",
        releaseDate = null,
        durationSec = null,
        composer = null,
        lyricist = null,
        arranger = null,
        cdSeries = null,
        cdTitle = null,
        artworkUrl = null,
        previewUrl = null,
        appleMusicId = null,
        appleMusicAlbumId = null,
        isrc = null,
        lyricsUrl = null,
        parentSongId = parentSongId,
        singerLabel = null,
        unitName = null,
        unitId = null,
        hasKamisabiCard = hasKamisabiCard
    )
}
