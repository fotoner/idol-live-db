import XCTest
import GRDB
@testable import ImasLiveDB

/// `AppDatabase.copyMasterTables` (アプデ後初回起動のマスタ再投入コア) の単体テスト。
///
/// 検証する不変条件:
/// - 一括コピーで Bundle 側データに置き換わる (旧データは消える)。
/// - 列差分に強い (Bundle にしか無い列は無視、ローカルにしか無い列は NULL)。
/// - 保護テーブル (user_marks 等) は触らない。
/// - FK 違反があれば COMMIT で throw し、トランザクション全体がロールバックする
///   (= 旧「サイレント全停止で旧データ継続」ではなく、失敗が呼び出し元に伝わる)。
final class MasterReseedTests: XCTestCase {

    private var bundlePaths: [String] = []

    override func tearDown() {
        for path in bundlePaths { try? FileManager.default.removeItem(atPath: path) }
        bundlePaths = []
        super.tearDown()
    }

    /// FK 無効の一時 Bundle DB ファイルを作り、そのパスを返す (違反データも投入できるように)。
    private func makeBundle(_ setup: (Database) throws -> Void) throws -> String {
        let path = NSTemporaryDirectory() + "reseed_bundle_\(UUID().uuidString).sqlite"
        bundlePaths.append(path)
        var config = Configuration()
        config.foreignKeysEnabled = false
        let queue = try DatabaseQueue(path: path, configuration: config)
        try queue.write { db in try setup(db) }
        return path
    }

    /// FK 有効 (GRDB 既定) の in-memory ローカル DB。
    private func makeLocal(_ setup: (Database) throws -> Void) throws -> DatabaseQueue {
        let queue = try DatabaseQueue()
        try queue.write { db in try setup(db) }
        return queue
    }

    // MARK: - happy path + 列差分 + 保護テーブル

    func testCopyReplacesDataHandlesColumnDiffAndPreservesUserTables() throws {
        let local = try makeLocal { db in
            try db.execute(sql: "CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT)")
            try db.execute(sql: "INSERT INTO meta VALUES('data_version','1')")
            // ローカルにしか無い列 extra_local を持つ。
            try db.execute(sql: "CREATE TABLE idols(id TEXT PRIMARY KEY, name TEXT, extra_local TEXT)")
            try db.execute(sql: "INSERT INTO idols VALUES('old','OldName','L')")
            try db.execute(sql: "CREATE TABLE user_marks(id TEXT PRIMARY KEY, note TEXT)")
            try db.execute(sql: "INSERT INTO user_marks VALUES('m1','keep')")
        }
        let bundle = try makeBundle { db in
            try db.execute(sql: "CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT)")
            try db.execute(sql: "INSERT INTO meta VALUES('data_version','2')")
            // Bundle にしか無い列 bundle_only を持つ (extra_local は無い)。
            try db.execute(sql: "CREATE TABLE idols(id TEXT PRIMARY KEY, name TEXT, bundle_only TEXT)")
            try db.execute(sql: "INSERT INTO idols VALUES('a','Alice','B')")
            try db.execute(sql: "INSERT INTO idols VALUES('b','Bob','B')")
            try db.execute(sql: "CREATE TABLE user_marks(id TEXT PRIMARY KEY, note TEXT)")
            try db.execute(sql: "INSERT INTO user_marks VALUES('mX','should_not_appear')")
        }

        let result = try AppDatabase.copyMasterTables(
            into: local, fromBundleAt: bundle,
            preserving: ["meta", "user_marks"], newVersion: 2, newContentHash: "hash-v2"
        )

        XCTAssertEqual(result.ok, 1)       // idols のみコピー対象
        XCTAssertEqual(result.skipped, 0)

        try local.read { db in
            // 旧データは消え、Bundle のデータに置き換わる。
            let ids = try String.fetchAll(db, sql: "SELECT id FROM idols ORDER BY id")
            XCTAssertEqual(ids, ["a", "b"])
            // 共通列 (id/name) のみコピー。ローカル固有列 extra_local は NULL。
            let extra = try String.fetchOne(db, sql: "SELECT extra_local FROM idols WHERE id='a'")
            XCTAssertNil(extra)
            let name = try String.fetchOne(db, sql: "SELECT name FROM idols WHERE id='a'")
            XCTAssertEqual(name, "Alice")
            // 保護テーブルは無傷 (Bundle の mX は入らない)。
            let marks = try String.fetchAll(db, sql: "SELECT note FROM user_marks")
            XCTAssertEqual(marks, ["keep"])
            // data_version は newVersion に更新。
            let version = try String.fetchOne(db, sql: "SELECT value FROM meta WHERE key='data_version'")
            XCTAssertEqual(version, "2")
            // 「最後に取り込んだ同梱データ」の指紋を記録する。次回の判定はこれと突き合わせる。
            // meta は保護テーブルで一括コピーの対象外なので、書き漏らすと毎起動 reseed になる。
            let hash = try String.fetchOne(db, sql: "SELECT value FROM meta WHERE key='content_hash'")
            XCTAssertEqual(hash, "hash-v2")
        }
    }

    // MARK: - 端末ローカルにしかない表は入れ直さない (D-IOS-03)

    /// 本物のスキーマの DB に端末ローカルの 3 表の行を入れ、同名の表に別の行を持つ同梱 DB で
    /// 入れ直しても、3 表の行がそのまま残ること。マスタ表は入れ直されること。
    ///
    /// 以前は触らない表を deny-list で持っていて、`personal_tags` と `expenses` が漏れていた。
    /// 同梱 DB にこの 2 表が「無い」から偶然守られていただけで、同梱 DB に入った瞬間、
    /// 次のアップデートの初回起動でマイタグと家計簿が全部消える (戻す手段が無い)。
    func testReseedNeverTouchesLocalOnlyTablesEvenIfBundleHasThem() throws {
        let localPath = try makeMigratedDatabaseFile()
        let local = try DatabaseQueue(path: localPath)
        try local.write { db in
            try Self.insertBrand(db, id: "old")
            try Self.insertLocalOnlyRows(db, marker: "local")
        }
        let bundle = try makeMigratedDatabaseFile()
        try DatabaseQueue(path: bundle).write { db in
            try Self.insertBrand(db, id: "new")
            try Self.insertLocalOnlyRows(db, marker: "bundle")
        }
        let before = try local.read(Self.localOnlyRows)

        // 起動時と同じく、スキーマを当てた結果 (台帳に無い表) から触らない表を決める。
        let schema = try ensureMasterSchema(dbPath: localPath)
        _ = try AppDatabase.copyMasterTables(
            into: local, fromBundleAt: bundle,
            preserving: AppDatabase.reseedPreservedTables(nonLedgerTables: schema.untouchedTables),
            newVersion: 2, newContentHash: "hash-v2"
        )

        try local.read { db in
            XCTAssertEqual(try Self.localOnlyRows(db), before, "端末ローカルの行が入れ直された")
            XCTAssertEqual(try String.fetchAll(db, sql: "SELECT id FROM brands"), ["new"], "マスタ表は入れ直す")
        }
    }

    private static func insertBrand(_ db: Database, id: String) throws {
        try db.execute(
            sql: "INSERT INTO brands (id, name, short_name, sort_order) VALUES (?, ?, ?, 1)",
            arguments: [id, id, id])
    }

    private static func insertLocalOnlyRows(_ db: Database, marker: String) throws {
        let now = "2026-09-23T00:00:00Z"
        try db.execute(
            sql: """
                INSERT INTO user_marks (entity_type, entity_id, kind, bool_value, text_value, updated_at)
                VALUES ('idol', ?, 'pick', 1, NULL, ?)
                """,
            arguments: [marker, now])
        try db.execute(
            sql: "INSERT INTO personal_tags (entity_type, entity_id, tag_name, created_at) VALUES ('song', ?, '聞いた', ?)",
            arguments: [marker, now])
        try db.execute(
            sql: """
                INSERT INTO expenses (id, date, category, amount, show_id, event_id, note, updated_at)
                VALUES (?, '2026-09-01', 'ticket', 13200, NULL, NULL, NULL, ?)
                """,
            arguments: [marker, now])
    }

    private static func localOnlyRows(_ db: Database) throws -> [Row] {
        try Row.fetchAll(db, sql: """
            SELECT 'user_marks', entity_id FROM user_marks
            UNION ALL SELECT 'personal_tags', entity_id FROM personal_tags
            UNION ALL SELECT 'expenses', id FROM expenses
            ORDER BY 1, 2
            """)
    }

    // MARK: - FK 違反は throw + ロールバック (旧: サイレント全停止)

    func testCopyThrowsAndRollsBackOnForeignKeyViolation() throws {
        let local = try makeLocal { db in
            try db.execute(sql: "CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT)")
            try db.execute(sql: "INSERT INTO meta VALUES('data_version','1')")
            try db.execute(sql: "CREATE TABLE parent(id TEXT PRIMARY KEY)")
            try db.execute(sql: "CREATE TABLE child(id TEXT PRIMARY KEY, parent_id TEXT REFERENCES parent(id) ON DELETE CASCADE)")
            try db.execute(sql: "INSERT INTO parent VALUES('p_old')")
            try db.execute(sql: "INSERT INTO child VALUES('c_old','p_old')")
        }
        let bundle = try makeBundle { db in
            try db.execute(sql: "CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT)")
            try db.execute(sql: "INSERT INTO meta VALUES('data_version','2')")
            try db.execute(sql: "CREATE TABLE parent(id TEXT PRIMARY KEY)")
            try db.execute(sql: "CREATE TABLE child(id TEXT PRIMARY KEY, parent_id TEXT REFERENCES parent(id) ON DELETE CASCADE)")
            try db.execute(sql: "INSERT INTO parent VALUES('p1')")
            // FK 違反: 存在しない親 pMISSING を参照 (Bundle は FK 無効なので投入できる)。
            try db.execute(sql: "INSERT INTO child VALUES('c1','pMISSING')")
        }

        XCTAssertThrowsError(
            try AppDatabase.copyMasterTables(
                into: local, fromBundleAt: bundle,
                preserving: ["meta"], newVersion: 2, newContentHash: "hash-v2"
            )
        )

        // ロールバックされ、ローカルは元のまま (data_version も 1 のまま)。
        try local.read { db in
            let parents = try String.fetchAll(db, sql: "SELECT id FROM parent")
            XCTAssertEqual(parents, ["p_old"])
            let children = try String.fetchAll(db, sql: "SELECT id FROM child")
            XCTAssertEqual(children, ["c_old"])
            let version = try String.fetchOne(db, sql: "SELECT value FROM meta WHERE key='data_version'")
            XCTAssertEqual(version, "1")
        }
    }
}
