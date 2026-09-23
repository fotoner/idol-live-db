//  AppDatabase の Idol Queries / Idol Song Queries を切り出したもの。
//  分割の意図と分割線の引き方は docs/ARCHITECTURE.md を参照。
//  ここにあるのは移動してきたクエリだけで、ロジックは 1 行も変えていない。

import Foundation
import GRDB

extension AppDatabase {

    // MARK: - Idol Queries

    /// アイドル一覧 (外部ゲスト演者は除外)
    func fetchIdols(brandId: String? = nil) throws -> [Idol] {
        try dbQueue.read { db in try Self.fetchIdolsByBrandQuery(db, brandId: brandId) }
    }

    private static func fetchIdolsByBrandQuery(_ db: Database, brandId: String?) throws -> [Idol] {
        if let brandId {
            let sql = """
                SELECT DISTINCT i.* FROM idols i
                JOIN idol_brands ib ON i.id = ib.idol_id
                WHERE ib.brand_id = ? AND i.is_external = 0
                ORDER BY i.sort_order
                """
            return try Idol.fetchAll(db, sql: sql, arguments: [brandId])
        }
        return try Idol
            .filter(Column("is_external") == 0)
            .order(Column("sort_order"))
            .fetchAll(db)
    }

    /// 編集フィード用: recordType + recordName から人間可読のタイトル(曲名/公演名/アイドル名 等)を引く。
    /// 解決できない recordType (コミュニティ投稿等) は nil。
    func fetchEditRecordTitleAsync(recordType: String, recordName: String) async throws -> String? {
        try await dbQueue.read { db in try Self.fetchEditRecordTitleQuery(db, recordType: recordType, recordName: recordName) }
    }

    private static func fetchEditRecordTitleQuery(_ db: Database, recordType: String, recordName: String) throws -> String? {
        func one(_ sql: String) -> String? {
            (try? String.fetchOne(db, sql: sql, arguments: [recordName])) ?? nil
        }
        switch recordType {
        case "Song":
            return one("SELECT title FROM songs WHERE id = ?")
        case "Event":
            return one("SELECT name FROM events WHERE id = ?")
        case "Show", "ShowSetlist":
            return one("SELECT name FROM shows WHERE id = ?")
        case "Idol":
            return one("SELECT name FROM idols WHERE id = ?")
        case "SetlistItem":
            // 「どのセトリ(公演)を編集したか」を示すため公演名を返す。
            return one("""
                SELECT sh.name FROM setlist_items si
                JOIN shows sh ON sh.id = si.show_id WHERE si.id = ?
                """)
        case "SetlistPerformer":
            return one("""
                SELECT sh.name FROM setlist_performers sp
                JOIN setlist_items si ON si.id = sp.setlist_item_id
                JOIN shows sh ON sh.id = si.show_id WHERE sp.setlist_item_id = ?
                """)
        case "SongVideo":
            // ytref_xxx → song_videos.song_id を辿って曲名を返す。
            return one("""
                SELECT s.title FROM song_videos sv
                JOIN songs s ON s.id = sv.song_id WHERE sv.id = ?
                """)
        default:
            return nil
        }
    }

    /// 編集レコードが属する公演 ID を解決する (セトリ系編集 → 該当公演のセトリへ遷移するため)。
    /// Show/ShowSetlist は recordName 自体が公演 ID。SetlistItem/SetlistPerformer は親を辿る。
    func fetchEditRecordShowIdAsync(recordType: String, recordName: String) async throws -> String? {
        try await dbQueue.read { db in try Self.fetchEditRecordShowIdQuery(db, recordType: recordType, recordName: recordName) }
    }

    private static func fetchEditRecordShowIdQuery(_ db: Database, recordType: String, recordName: String) throws -> String? {
        func one(_ sql: String) -> String? {
            (try? String.fetchOne(db, sql: sql, arguments: [recordName])) ?? nil
        }
        switch recordType {
        case "Show", "ShowSetlist":
            return one("SELECT id FROM shows WHERE id = ?")
        case "SetlistItem":
            return one("SELECT show_id FROM setlist_items WHERE id = ?")
        case "SetlistPerformer":
            return one("""
                SELECT si.show_id FROM setlist_performers sp
                JOIN setlist_items si ON si.id = sp.setlist_item_id
                WHERE sp.setlist_item_id = ?
                """)
        default:
            return nil
        }
    }

    /// 編集レコードが属する曲 ID を解決する (SongVideo 編集 → 該当曲詳細へ遷移するため)。
    func fetchEditRecordSongIdAsync(recordType: String, recordName: String) async throws -> String? {
        try await dbQueue.read { db in try Self.fetchEditRecordSongIdQuery(db, recordType: recordType, recordName: recordName) }
    }

    private static func fetchEditRecordSongIdQuery(_ db: Database, recordType: String, recordName: String) throws -> String? {
        func one(_ sql: String) -> String? {
            (try? String.fetchOne(db, sql: sql, arguments: [recordName])) ?? nil
        }
        switch recordType {
        case "SongVideo":
            return one("SELECT song_id FROM song_videos WHERE id = ?")
        default:
            return nil
        }
    }
}
