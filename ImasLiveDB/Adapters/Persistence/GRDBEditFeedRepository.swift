import Foundation

/// `EditFeedReading` ポートのアダプタ。
///
/// 編集の対象の呼び名と公演は、スナップショットにあるものはコア (`edit_record_target`:
/// 公演・セトリは「ライブ名 見分け」の正式な呼び名) が答える。参考動画 (SongVideo) は
/// スナップショットに無いので端末の DB に訊く。
struct GRDBEditFeedRepository: EditFeedReading {
    let database: AppDatabase
    let snapshot: CoreSnapshotManager

    func editRecordShowId(recordType: String, recordName: String) async throws -> String? {
        try await target(recordType: recordType, recordName: recordName)?.showId
    }

    func editRecordSongId(recordType: String, recordName: String) async throws -> String? {
        try await database.fetchEditRecordSongIdAsync(recordType: recordType, recordName: recordName)
    }

    func editRecordTitle(recordType: String, recordName: String) async throws -> String? {
        if recordType == "SongVideo" {
            return try await database.fetchSongVideoSongTitleAsync(videoId: recordName)
        }
        return try await target(recordType: recordType, recordName: recordName)?.title
    }

    private func target(recordType: String, recordName: String) async throws -> EditRecordTarget? {
        try await snapshot.withStore { store in
            try store.editRecordTarget(recordType: recordType, recordName: recordName)
        }
    }
}
