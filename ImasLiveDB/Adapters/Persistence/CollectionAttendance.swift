import Foundation
import GRDB

/// 「回収」を数えるための参加マーク解決。
///
/// `user_marks` はスナップショットに無い (書き込みが頻繁でプラットフォームが正) ので、
/// **引くのはここ・選ぶ規則は imas-core** という分担にする:
///
/// - どのマークを回収に数えるか (既定は現地のみ / 設定で配信・LV も) …
///   core の `collectionAttendedShows`
/// - どの催しが回収の対象か (リアルライブだけ) … core の `attended_real_live_shows`
///
/// 以前はこの「現地のみ」の条件が `AppDatabase+UserMarks.attendedTypeCondition` (SQL) と
/// `CoreSongRepository` (Swift) の 2 か所にあり、後者には「変更時は両方を揃えること」と
/// 書いてあった。セトリの「初回収 / 未回収」で 3 つ目になるところだったので 1 本に畳む。
enum CollectionAttendance {

    /// 回収に数える参加 show id (参加形態の条件を適用済み)。
    static func showIds(database: AppDatabase) async throws -> [String] {
        let marks = try await marks(entity: .show, database: database)
        return collectionAttendedShows(
            marks: marks,
            includeStream: UserDefaults.standard.bool(forKey: AppDatabase.collectionIncludeStreamKey)
        )
    }

    /// イベント単位の参加マーク。配下の公演への展開は core がやる。
    ///
    /// 参加形態の条件は掛けない (SQL 時代の `fetchSongCollectedCountsQuery` と同じ。
    /// イベント単位のマークは「そのイベントに行った」以上の意味を持たない)。
    static func eventIds(database: AppDatabase) async throws -> [String] {
        try await database.fetchMarkedEntityIdsAsync(entity: .event, kind: .attended)
    }

    /// attended マークを (entity_id, text_value) の射影で取り出す。
    /// `fetchMarkedEntityIdsAsync` は id しか返さないので、種別が要る経路はこちらを使う。
    static func marks(
        entity: UserMarkEntity,
        database: AppDatabase
    ) async throws -> [AttendanceMarkRecord] {
        let rows = try await database.dbQueue.read { db in
            try UserMark.filter(
                UserMark.Columns.entityType == entity.rawValue &&
                UserMark.Columns.kind == UserMarkKind.attended.rawValue &&
                UserMark.Columns.boolValue == true
            ).fetchAll(db)
        }
        return rows.map { AttendanceMarkRecord(entityId: $0.entityId, attendanceType: $0.textValue) }
    }
}
