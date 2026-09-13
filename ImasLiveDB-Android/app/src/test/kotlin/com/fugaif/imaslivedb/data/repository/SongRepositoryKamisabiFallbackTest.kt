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
 * コア `song_list_queries.rs::is_hidden_variant` と同じ規則を Android の SQL フォールバックでも
 * 守れていることを固定する:
 *
 * > 派生曲は隠す。ただし**それ自体が商品として立っている曲は隠さない**。
 *
 * `kamisabiOnly` の値には関係しない — 以前は「kamisabiOnly 中だけリミックス除外を外す」と
 * いう 2 軸を絡ませた条件だったが (Code Simplifier 指摘で撤去)、規則そのものが
 * `(parent_song_id IS NULL OR has_kamisabi_card = 1)` の無条件 1 行に一般化された。
 * KAMISABI のカードは `Welcome!! (レジェンドデイズ Ver.)` のような派生曲にも付くため、
 * これを漏らすとスナップショット未ロード時の既定の曲一覧が 1 件少なくなる
 * (実データでは 2,034 → 2,033)。
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
    fun fallbackShowsVariantsThatCarryTheKamisabiCardRegardlessOfKamisabiOnly() = runBlocking {
        db.syncDao().upsertSongs(
            listOf(
                baseSong(id = "ml_welcome", parentSongId = null, hasKamisabiCard = true),
                // 派生曲だが KAMISABI 収録 = 商品として単独で立っている曲。既定 (includeRemixes=false)
                // でも隠してはいけない。
                baseSong(id = "ml_welcome_legend_days_ver", parentSongId = "ml_welcome", hasKamisabiCard = true),
                // 普通の派生曲 (KAMISABI 収録なし) — includeRemixes=false のときは従来通り隠れる。
                baseSong(id = "ml_other_remix", parentSongId = "ml_welcome", hasKamisabiCard = false)
            )
        )

        // 既定 (kamisabiOnly=false, includeRemixes=false) — 以前はここでカード付き派生曲も
        // 一緒に隠れて 149 相当になっていた退行。
        val default = repository.fetchSongs(SongSearchFilter(excludeLiveOnly = false))
        val defaultIds = default.map { it.song.id }.toSet()
        assertTrue(
            "KAMISABI 収録の派生曲は kamisabiOnly を付けていなくても隠してはいけない (商品として立っているため)",
            defaultIds.contains("ml_welcome_legend_days_ver")
        )
        assertTrue(defaultIds.contains("ml_welcome"))
        assertTrue(
            "KAMISABI 収録が無い派生曲は既定通り隠れる",
            !defaultIds.contains("ml_other_remix")
        )

        // kamisabiOnly=true でも同じ規則 (軸を絡ませていないので分岐で結果が変わらない)。
        val kamisabiOnly = repository.fetchSongs(SongSearchFilter(kamisabiOnly = true, excludeLiveOnly = false))
        val kamisabiOnlyIds = kamisabiOnly.map { it.song.id }.toSet()
        assertTrue(kamisabiOnlyIds.contains("ml_welcome_legend_days_ver"))
        assertTrue(kamisabiOnlyIds.contains("ml_welcome"))
        assertTrue(!kamisabiOnlyIds.contains("ml_other_remix"))

        // includeRemixes=true では全部出る (対照)。
        val allRemixes = repository.fetchSongs(SongSearchFilter(includeRemixes = true, excludeLiveOnly = false))
        val allIds = allRemixes.map { it.song.id }.toSet()
        assertTrue(allIds.containsAll(setOf("ml_welcome", "ml_welcome_legend_days_ver", "ml_other_remix")))
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
