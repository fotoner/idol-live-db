//  AppDatabase の Stats Queries / Search を切り出したもの。
//  分割の意図と分割線の引き方は docs/ARCHITECTURE.md を参照。
//  ここにあるのは移動してきたクエリだけで、ロジックは 1 行も変えていない。

import Foundation
import GRDB

extension AppDatabase {

    // MARK: - Stats Queries

    /// brand_id が設定されている曲 ID セット。
    /// 回収率集計で分子と分母の母集合を揃えるために使う。
    func fetchBrandedSongIds() throws -> Set<String> {
        try dbQueue.read { db in try Self.fetchBrandedSongIdsQuery(db) }
    }

    private static func fetchBrandedSongIdsQuery(_ db: Database) throws -> Set<String> {
        let ids = try String.fetchAll(db, sql: "SELECT id FROM songs WHERE brand_id IS NOT NULL")
        return Set(ids)
    }

    /// 全ブランド取得
    func fetchBrands() throws -> [Brand] {
        try dbQueue.read { db in try Self.fetchBrandsQuery(db) }
    }

    func fetchBrandsAsync() async throws -> [Brand] {
        try await dbQueue.read { db in try Self.fetchBrandsQuery(db) }
    }

    private static func fetchBrandsQuery(_ db: Database) throws -> [Brand] {
        try Brand.order(Column("sort_order")).fetchAll(db)
    }

    /// イントロドンの出題候補 (選んだブランドの曲)。出題できるかどうかはここでは決めない
    /// (端末の契約状態を込みでコアが決める。`IntroGameSession.questionPool`)。
    func fetchIntroDonSongs(brandIds: Set<String>? = nil) throws -> [Song] {
        try dbQueue.read { db in
            var sql = "SELECT * FROM songs"
            var args: [DatabaseValueConvertible] = []
            if let brandIds, !brandIds.isEmpty {
                sql += "\nWHERE brand_id IN (\(brandIds.map { _ in "?" }.joined(separator: ",")))"
                args = Array(brandIds)
            }
            sql += "\nORDER BY RANDOM()"
            return try Song.fetchAll(db, sql: sql, arguments: StatementArguments(args))
        }
    }

    /// 全ユニット (picker 用)。
    func fetchAllUnits() throws -> [Unit] {
        try dbQueue.read { db in try Self.fetchAllUnitsQuery(db) }
    }

    private static func fetchAllUnitsQuery(_ db: Database) throws -> [Unit] {
        try Unit.order(Column("brand_id"), Column("name")).fetchAll(db)
    }

    /// DB全体の統計 (外部ゲスト演者は除外)
    func fetchDatabaseStatsAsync() async throws -> DatabaseStats {
        try await dbQueue.read { db in try Self.fetchDatabaseStatsQuery(db) }
    }

    private static func fetchDatabaseStatsQuery(_ db: Database) throws -> DatabaseStats {
        DatabaseStats(
            songCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM songs") ?? 0,
            idolCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM idols WHERE is_external = 0") ?? 0,
            eventCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM events") ?? 0,
            showCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM shows") ?? 0
        )
    }

    /// 同期診断用 — recordName に '@' が入ったレコード数を集計し、ML 13thLIVE が
    /// 存在するかチェックする。@-roundtrip バグの切り分けに使う。
    func fetchSyncDiagnosticsAsync() async throws -> SyncDiagnostics {
        try await dbQueue.read { db in try Self.fetchSyncDiagnosticsQuery(db) }
    }

    private static func fetchSyncDiagnosticsQuery(_ db: Database) throws -> SyncDiagnostics {
        SyncDiagnostics(
            eventsAt: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM events WHERE id LIKE '%@%'") ?? 0,
            showsAt: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM shows WHERE id LIKE '%@%'") ?? 0,
            setlistItemsAt: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM setlist_items WHERE id LIKE '%@%'") ?? 0,
            ml13thLiveExists: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM events WHERE id = ?", arguments: ["ev_the_idolm@ster_million_live_13thlive"]) ?? 0 > 0,
            ml13thShowsCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM shows WHERE event_id = ?", arguments: ["ev_the_idolm@ster_million_live_13thlive"]) ?? 0,
            ml13thSetlistItemsCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM setlist_items WHERE show_id LIKE 'sh_the_idolm@ster_million_live_13thlive%'") ?? 0,
            sc8thName: try String.fetchOne(db, sql: "SELECT name FROM events WHERE id = ?", arguments: ["ev_the_idolm@ster_shiny_colors_8th_live_ito_yume"]),
            sc8thKind: try String.fetchOne(db, sql: "SELECT kind FROM events WHERE id = ?", arguments: ["ev_the_idolm@ster_shiny_colors_8th_live_ito_yume"]),
            sc8thShowsCount: try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM shows WHERE event_id = ?", arguments: ["ev_the_idolm@ster_shiny_colors_8th_live_ito_yume"]) ?? 0
        )
    }

    /// イベント名 OR 公演会場 (shows.venue) のいずれかが query に部分一致するイベントを返す。
    /// venue は同 event 内の複数 shows をまたぐので EXISTS で結合。
    func searchEventsByNameOrVenue(query: String, limit: Int = 100) throws -> [Event] {
        try dbQueue.read { db in try Self.searchEventsByNameOrVenueQuery(db, query: query, limit: limit) }
    }

    private static func searchEventsByNameOrVenueQuery(_ db: Database, query: String, limit: Int) throws -> [Event] {
        let pattern = "%\(query.lowercased().likeEscaped)%"
        return try Event.fetchAll(
            db,
            sql: """
                SELECT DISTINCT e.* FROM events e
                LEFT JOIN shows sh ON sh.event_id = e.id
                WHERE LOWER(e.name) LIKE ? ESCAPE '\\'
                   OR LOWER(IFNULL(sh.venue, '')) LIKE ? ESCAPE '\\'
                LIMIT ?
                """,
            arguments: [pattern, pattern, limit]
        )
    }

    /// アイドルを名前 / かな / ローマ字の部分一致で検索 (ピッカー用)。
    func searchIdols(query: String, limit: Int = 50) throws -> [Idol] {
        try dbQueue.read { db in try Self.searchIdolsQuery(db, query: query, limit: limit) }
    }

    private static func searchIdolsQuery(_ db: Database, query: String, limit: Int) throws -> [Idol] {
        let pattern = "%\(query.likeEscaped)%"
        // CV 名と別名 (aliases) も対象にする。声優名でアイドルを引くのは
        // このアプリでは主要な探し方なので、名前系カラムだけだと取りこぼす。
        //
        // CV は idol_voice_actors (期間つき履歴) にあり、**歴代すべて**を対象にする。
        // 前任者の名前で引いても担当アイドルに辿り着けた方が、「この人が昔やっていた役」
        // を探す用途に合う。
        // 相関サブクエリは GRDB の式ビルダーでは組めないので素の SQL で書く。
        return try Idol.fetchAll(db, sql: """
            SELECT * FROM idols
             WHERE name        LIKE :p ESCAPE '\\'
                OR name_kana   LIKE :p ESCAPE '\\'
                OR name_romaji LIKE :p ESCAPE '\\'
                OR aliases     LIKE :p ESCAPE '\\'
                OR EXISTS (SELECT 1 FROM idol_voice_actors v
                            WHERE v.idol_id = idols.id AND v.name LIKE :p ESCAPE '\\')
             ORDER BY sort_order
             LIMIT :limit
            """, arguments: ["p": pattern, "limit": limit])
    }

    /// metaテーブルから値取得
    func fetchMetaValue(forKey key: String) throws -> String? {
        try dbQueue.read { db in try Self.fetchMetaValueQuery(db, forKey: key) }
    }

    func fetchMetaValueAsync(forKey key: String) async throws -> String? {
        try await dbQueue.read { db in try Self.fetchMetaValueQuery(db, forKey: key) }
    }

    private static func fetchMetaValueQuery(_ db: Database, forKey key: String) throws -> String? {
        try Meta.getValue(db, forKey: key)
    }
}
