package com.fugaif.imaslivedb.data.db.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.RawQuery
import androidx.sqlite.db.SupportSQLiteQuery
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.Song

@Dao
interface SongDao {

    @Query("SELECT * FROM songs WHERE id = :id LIMIT 1")
    suspend fun fetchSong(id: String): Song?

    @Query("SELECT * FROM songs WHERE id IN (:ids)")
    suspend fun fetchSongsByIds(ids: List<String>): List<Song>

    /**
     * スナップショット (共有コア) が返した idol id 列を Idol 実体へ引き直すための一括取得。
     * 並びはコアが返した id 列が正なので、呼び出し側 (SongRepository) で並べ直す。
     */
    @Query("SELECT * FROM idols WHERE id IN (:ids)")
    suspend fun fetchIdolsByIds(ids: List<String>): List<Idol>

    @RawQuery
    suspend fun fetchSongsRaw(query: SupportSQLiteQuery): List<Song>

    /**
     * クリエイター名 (作曲・作詞・編曲 横断) の候補曲。**コアに対応 API が無い絞り込み**なので
     * Room で引く。
     *
     * 3 欄は「/」「、」等で複数名が入った自由文字列なので、SQL では部分一致まで広く拾い、
     * 「その名前が本当に 1 人ぶんとして入っているか」の判定は呼び出し側 (SongRepository) が行う
     * (iOS fetchSongsByCreatorQuery + songsWithCreatorRoles と同じ 2 段構え)。
     * `%` `_` を含む名前でパターンが壊れないよう、パターンはエスケープ済みを受け取り
     * `ESCAPE '\'` を明示する (iOS の likeEscaped と対)。
     */
    @Query("""
        SELECT * FROM songs
        WHERE composer LIKE :pattern ESCAPE '\'
           OR lyricist LIKE :pattern ESCAPE '\'
           OR arranger LIKE :pattern ESCAPE '\'
        ORDER BY title_kana, title
    """)
    suspend fun fetchSongsByCreator(pattern: String): List<Song>
}
