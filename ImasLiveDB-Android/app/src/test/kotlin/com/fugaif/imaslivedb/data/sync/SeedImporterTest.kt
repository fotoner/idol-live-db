package com.fugaif.imaslivedb.data.sync

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import androidx.room.Room
import androidx.sqlite.db.SupportSQLiteDatabase
import com.fugaif.imaslivedb.data.db.AppDatabase
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import java.io.File

/**
 * [SeedImporter] を、ビルド時に db/master.sql から生成した本物の seed (assets/master_seed.sqlite)
 * で動かす。
 *
 * DB は本番と同じ設定 ([AppDatabase.configure]: 移行とコールバック) でメモリ上に作る。
 * 初回起動の「空の DB に seed を入れる」を再現し、seed の中身がそのまま入ることを確かめる。
 */
@RunWith(RobolectricTestRunner::class)
class SeedImporterTest {

    private lateinit var context: Context
    private lateinit var db: AppDatabase
    private lateinit var seedFile: File
    private lateinit var seed: SQLiteDatabase

    @Before
    fun setUp() {
        context = RuntimeEnvironment.getApplication()
        db = AppDatabase.configure(Room.inMemoryDatabaseBuilder(context, AppDatabase::class.java))
            .allowMainThreadQueries()
            .build()
        seedFile = File.createTempFile("seed", ".sqlite")
        context.assets.open(SEED_ASSET).use { input -> seedFile.outputStream().use { input.copyTo(it) } }
        seed = SQLiteDatabase.openDatabase(seedFile.path, null, SQLiteDatabase.OPEN_READONLY)
    }

    @After
    fun tearDown() {
        seed.close()
        db.close()
        seedFile.delete()
    }

    /** 空の DB に入れると、seed と共通の表はどれも seed と同じ行数になる。 */
    @Test
    fun importsEveryCommonTableFromTheSeed() = runBlocking {
        assertTrue(SeedImporter.importIfNeeded(context, db))
        assertNull(SeedImporter.lastImportError)

        val room = db.openHelper.writableDatabase
        val common = tables(room).intersect(tables(seed).toSet()) - INTERNAL_TABLES
        assertTrue("seed と共通の表が見つからない: $common", "songs" in common && "setlist_performers" in common)
        for (table in common) {
            assertEquals("$table の行数", count(seed, table), count(room, table))
        }
    }

    /**
     * brands が入っていれば投入済みとみなし、2 回目は seed を読まない。
     * (行数が変わらないだけなら INSERT OR IGNORE でも同じになるので、消した行が戻らないことで見る)
     */
    @Test
    fun skipsWhenBrandsAlreadyExist() = runBlocking {
        assertTrue(SeedImporter.importIfNeeded(context, db))
        val room = db.openHelper.writableDatabase
        room.execSQL("DELETE FROM songs")

        assertTrue(SeedImporter.importIfNeeded(context, db))
        assertEquals("投入済みの DB に seed を入れ直した", 0, count(room, "songs"))
    }

    /** 端末ローカルにしかない表には何も入れない (seed は利用者のデータを持たない)。 */
    @Test
    fun leavesLocalOnlyTablesEmpty() = runBlocking {
        assertTrue(SeedImporter.importIfNeeded(context, db))
        val room = db.openHelper.writableDatabase
        for (table in listOf("user_marks", "personal_tags", "expenses")) {
            assertEquals("$table に行が入った", 0, count(room, table))
        }
    }

    private fun tables(db: SQLiteDatabase): List<String> =
        db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null).use { c ->
            buildList { while (c.moveToNext()) add(c.getString(0)) }
        }

    private fun tables(db: SupportSQLiteDatabase): List<String> =
        db.query("SELECT name FROM sqlite_master WHERE type='table'").use { c ->
            buildList { while (c.moveToNext()) add(c.getString(0)) }
        }

    private fun count(db: SQLiteDatabase, table: String): Int =
        db.rawQuery("SELECT COUNT(*) FROM \"$table\"", null).use { it.moveToFirst(); it.getInt(0) }

    private fun count(db: SupportSQLiteDatabase, table: String): Int =
        db.query("SELECT COUNT(*) FROM \"$table\"").use { it.moveToFirst(); it.getInt(0) }

    private companion object {
        const val SEED_ASSET = "master_seed.sqlite"

        /** 行を移さない SQLite / Room の内部表。 */
        val INTERNAL_TABLES = setOf("room_master_table", "android_metadata", "sqlite_sequence")
    }
}
