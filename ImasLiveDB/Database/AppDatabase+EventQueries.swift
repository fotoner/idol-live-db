//  AppDatabase の Event Queries / Setlist Queries / Filtered Fetch Methods / Private Helpers を切り出したもの。
//  分割の意図と分割線の引き方は docs/ARCHITECTURE.md を参照。
//  ここにあるのは移動してきたクエリだけで、ロジックは 1 行も変えていない。

import Foundation
import GRDB

extension AppDatabase {

    // MARK: - Event Queries

    /// イベントの出演キャスト一覧（アイドル情報付き）
    func fetchEventCastMembers(eventId: String) throws -> [EventCastRow] {
        try dbQueue.read { db in
            // Cast 廃止後: show_cast 直結で idol を引く。 EventCastRow.id/name は idol を採用。
            let sql = """
                SELECT DISTINCT i.id, i.name, i.color AS idol_color, i.name AS idol_name, i.id AS idol_id
                FROM show_cast sc
                JOIN shows sh ON sc.show_id = sh.id
                JOIN idols i ON i.id = sc.idol_id
                WHERE sh.event_id = ?
                ORDER BY i.sort_order
                """
            return try EventCastRow.fetchAll(db, sql: sql, arguments: [eventId])
        }
    }

    /// イベントのメンバー出席状況（不在アイドル情報）
    /// ブランド全体のアイドル数が60名以下のイベントのみ意味を持つ。
    func fetchEventAbsenceInfo(eventId: String) throws -> EventAbsenceInfo? {
        try dbQueue.read { db in
            // 1. イベントの brand_id を取得
            guard let brandId = try Row.fetchOne(db, sql: "SELECT brand_id FROM events WHERE id = ?", arguments: [eventId])?["brand_id"] as? String
            else { return nil }

            // 2. ブランド全体のアイドル一覧（idol_brands 経由で多重所属に対応）
            //    例: ML ライブで 765AS13 が「ブランド全体」に含まれる。
            //    外部ゲスト演者 (is_external) はブランドの一部ではないので除外。
            let allIdolsSQL = """
                SELECT DISTINCT i.* FROM idols i
                JOIN idol_brands ib ON ib.idol_id = i.id
                WHERE ib.brand_id = ? AND i.is_external = 0
                ORDER BY i.sort_order
                """
            let allIdols = try Idol.fetchAll(db, sql: allIdolsSQL, arguments: [brandId])

            guard !allIdols.isEmpty else { return nil }

            // 3. このイベントに出演したアイドル (show_cast 直結、 idol_brands 経由でブランド絞り込み)
            let presentSQL = """
                SELECT DISTINCT i.* FROM idols i
                JOIN show_cast sc ON sc.idol_id = i.id
                JOIN shows sh ON sh.id = sc.show_id
                JOIN idol_brands ib ON ib.idol_id = i.id
                WHERE sh.event_id = ? AND ib.brand_id = ?
                ORDER BY i.sort_order
                """
            let presentIdols = try Idol.fetchAll(db, sql: presentSQL, arguments: [eventId, brandId])
            let presentIds = Set(presentIdols.map(\.id))

            // 4. 不在アイドル = 全体 - 出演
            let absentIdols = allIdols.filter { !presentIds.contains($0.id) }

            return EventAbsenceInfo(
                totalIdols: allIdols.count,
                presentIdols: presentIdols,
                absentIdols: absentIdols
            )
        }
    }

    /// 公演をイベント名・公演名で検索（コミュニティ投稿用）
    func searchShows(query: String, limit: Int = 30) throws -> [ShowWithEventName] {
        try dbQueue.read { db in try Self.searchShowsQuery(db, query: query, limit: limit) }
    }

    private static func searchShowsQuery(_ db: Database, query: String, limit: Int) throws -> [ShowWithEventName] {
        let pattern = "%\(query.likeEscaped)%"
        let sql = """
            SELECT s.id, s.event_id, s.name, s.date, s.venue, e.name AS event_name
            FROM shows s
            JOIN events e ON s.event_id = e.id
            WHERE s.name LIKE ? ESCAPE '\\' OR e.name LIKE ? ESCAPE '\\'
            ORDER BY s.date DESC
            LIMIT ?
            """
        return try ShowWithEventName.fetchAll(db, sql: sql, arguments: [pattern, pattern, limit])
    }

    // MARK: - Filtered Fetch Methods

    /// (async) SongFilterCriterion で楽曲一覧を取得。cooperative thread pool をブロックしない。
    func fetchSongsAsync(criterion: SongFilterCriterion) async throws -> [SongWithArtists] {
        switch criterion {
        case .brand(let id, _):
            return try await fetchSongsAsync(filter: SongSearchFilter(brandId: id))
        case .cdSeries(let series):
            let songs = try await dbQueue.read { db in try Self.songsByCdSeriesQuery(db, series: series) }
            return Self.songsWithArtists(songs)
        case .seriesGroup(let name):
            let songs = try await dbQueue.read { db in try Self.songsBySeriesGroupQuery(db, name: name) }
            return Self.songsWithArtists(songs)
        case .songType(let type):
            return try await fetchSongsAsync(filter: SongSearchFilter(songType: type))
        case .releaseYear(let year):
            let songs = try await dbQueue.read { db in try Self.songsByReleaseYearQuery(db, year: year) }
            return Self.songsWithArtists(songs)
        case .creator(let name):
            let withRoles = try await fetchSongsByCreatorAsync(name)
            return withRoles.map { SongWithArtists(song: $0.song, artistNames: $0.song.singerLabel ?? "") }
        case .songIds(let ids, _):
            guard !ids.isEmpty else { return [] }
            let songs = try await dbQueue.read { db in try Self.songsByIdsOrderedQuery(db, ids: ids) }
            return Self.songsWithArtists(songs)
        }
    }

    private static func songsWithArtists(_ songs: [Song]) -> [SongWithArtists] {
        songs.map { SongWithArtists(song: $0, artistNames: $0.singerLabel ?? "") }
    }

    private static func songsByCdSeriesQuery(_ db: Database, series: String) throws -> [Song] {
        try Song.filter(Column("cd_series") == series).order(Column("release_date"), Column("title_kana")).fetchAll(db)
    }

    private static func songsBySeriesGroupQuery(_ db: Database, name: String) throws -> [Song] {
        try Song.filter(Column("series_group") == name)
            .order(Column("release_date"), Column("title_kana"))
            .fetchAll(db)
    }

    private static func songsByReleaseYearQuery(_ db: Database, year: String) throws -> [Song] {
        try Song.filter(Column("release_date").like("\(year)%"))
            .order(Column("release_date"), Column("title_kana"))
            .fetchAll(db)
    }

    private static func songsByIdsOrderedQuery(_ db: Database, ids: [String]) throws -> [Song] {
        try Song.filter(ids.contains(Column("id")))
            .order(Column("title_kana"), Column("title"))
            .fetchAll(db)
    }

    /// (async) クリエイター名検索。cooperative thread pool をブロックしない。
    func fetchSongsByCreatorAsync(_ name: String) async throws -> [SongWithRoles] {
        guard let trimmedName = Self.normalizedCreatorName(name) else { return [] }
        let candidates = try await dbQueue.read { db in try Self.fetchSongsByCreatorQuery(db, trimmedName: trimmedName) }
        return Self.songsWithCreatorRoles(candidates, trimmedName: trimmedName)
    }

    private static func normalizedCreatorName(_ name: String) -> String? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func fetchSongsByCreatorQuery(_ db: Database, trimmedName: String) throws -> [Song] {
        let pattern = "%\(trimmedName.likeEscaped)%"
        return try Song.filter(
            Column("composer").like(pattern, escape: "\\") ||
            Column("lyricist").like(pattern, escape: "\\") ||
            Column("arranger").like(pattern, escape: "\\")
        ).order(Column("title_kana"), Column("title")).fetchAll(db)
    }

    private static func songsWithCreatorRoles(_ candidates: [Song], trimmedName: String) -> [SongWithRoles] {
        let separators = CharacterSet(charactersIn: "/／,、・")
        return candidates.compactMap { song in
            let roles = [("作曲", song.composer), ("作詞", song.lyricist), ("編曲", song.arranger)]
                .compactMap { label, field -> String? in
                    guard let value = field else { return nil }
                    let parts = value.components(separatedBy: separators)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    return parts.contains(trimmedName) ? label : nil
                }
            guard !roles.isEmpty else { return nil }
            return SongWithRoles(song: song, artists: [], roles: roles)
        }
    }

    /// 指定 event_id 集合に該当する EventWithDate を、最新公演日降順で返す。
    /// MyPage の参加ライブ一覧などで使用。 空配列を渡したら空配列を返す。
    func fetchEventsByIds(_ ids: [String]) throws -> [EventWithDate] {
        guard !ids.isEmpty else { return [] }
        return try dbQueue.read { db in try Self.fetchEventsByIdsQuery(db, ids) }
    }

    private static func fetchEventsByIdsQuery(_ db: Database, _ ids: [String]) throws -> [EventWithDate] {
        let placeholders = ids.map { _ in "?" }.joined(separator: ", ")
        let sql = """
            SELECT e.id, e.brand_id, e.name, e.event_type, e.is_streaming, e.is_solo, e.kind,
                   MIN(s.date) AS first_date,
                   MAX(s.date) AS last_date
            FROM events e
            LEFT JOIN shows s ON s.event_id = e.id
            WHERE e.id IN (\(placeholders))
            GROUP BY e.id
            ORDER BY COALESCE(MIN(s.date), '') DESC
            """
        return try Row.fetchAll(db, sql: sql, arguments: StatementArguments(ids))
            .map(Self.eventWithDate)
    }

    /// 参加したライブ(イベント)を重複なしで返す。
    /// 「イベント単位の参加マーク」と「公演(show)単位の参加マーク→所属イベント」を UNION で統合する。
    /// (参加を公演単位で付けるユーザーが多く、event マークだけ見るとリストが取りこぼすため)
    func fetchAttendedEventsWithDate() throws -> [EventWithDate] {
        try dbQueue.read { db in try Self.fetchAttendedEventsWithDateQuery(db) }
    }

    private static func fetchAttendedEventsWithDateQuery(_ db: Database) throws -> [EventWithDate] {
        let sql = """
            SELECT e.id, e.brand_id, e.name, e.event_type, e.is_streaming, e.is_solo, e.kind,
                   MIN(s.date) AS first_date,
                   MAX(s.date) AS last_date
            FROM events e
            LEFT JOIN shows s ON s.event_id = e.id
            WHERE e.id IN (
                SELECT entity_id FROM user_marks
                WHERE entity_type = 'event' AND kind = 'attended' AND bool_value = 1
                UNION
                SELECT sh.event_id FROM user_marks um
                JOIN shows sh ON sh.id = um.entity_id
                WHERE um.entity_type = 'show' AND um.kind = 'attended' AND um.bool_value = 1
            )
            GROUP BY e.id
            ORDER BY COALESCE(MIN(s.date), '') DESC
            """
        return try Row.fetchAll(db, sql: sql).map(Self.eventWithDate)
    }

    // MARK: - Private Helpers

    private static func eventWithDate(_ row: Row) -> EventWithDate {
        EventWithDate(
            event: Event(
                id: row["id"],
                brandId: row["brand_id"],
                name: row["name"],
                eventType: row["event_type"],
                isStreaming: row["is_streaming"] ?? false,
                isSolo: row["is_solo"] ?? true,
                kind: row["kind"] ?? "live"
            ),
            firstDate: row["first_date"],
            lastDate: row["last_date"]
        )
    }
}
