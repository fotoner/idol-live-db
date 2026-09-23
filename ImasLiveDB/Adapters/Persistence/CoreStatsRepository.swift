import Foundation

/// `StatsReading` ポートの共有コア (imas-core インメモリスナップショット) アダプタ。
/// スナップショットがまだなら、ロードを待ってから答える (`CoreSnapshotManager.withStore`)。
struct CoreStatsRepository: StatsReading {
    let snapshot: CoreSnapshotManager

    func brandSongCounts() async throws -> [BrandSongCount] {
        try await snapshot.withStore { store in
            try store.brandSongCounts().map(CoreRecordMapping.brandSongCount(from:))
        }
    }

    func songPlayCountRanking(limit: Int) async throws -> [SongPlayCount] {
        try await snapshot.withStore { store in
            try store.songPlayCountRanking(limit: UInt32(max(0, limit))).map(CoreRecordMapping.songPlayCount(from:))
        }
    }

    func castShowCountRanking(limit: Int) async throws -> [CastShowCount] {
        try await snapshot.withStore { store in
            try store.castShowCountRanking(limit: UInt32(max(0, limit))).map(CoreRecordMapping.castShowCount(from:))
        }
    }

    func yearlyShowCounts() async throws -> [YearlyShowCount] {
        try await snapshot.withStore { store in
            try store.yearlyShowCounts().map(CoreRecordMapping.yearlyShowCount(from:))
        }
    }
}
