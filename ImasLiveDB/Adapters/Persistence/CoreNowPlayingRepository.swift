import Foundation

/// `NowPlayingReading` のコア実装。
///
/// 他の `Core*Repository` と違って GRDB のフォールバックを持たない。バーは
/// **起動直後の一瞬出ないだけ**で済む性質の表示で、そのために同じ判断を
/// SQL 側にもう 1 つ持つ方が高くつく (規則の二重持ちは必ず片方だけ腐る)。
struct CoreNowPlayingRepository: NowPlayingReading {
    let snapshot: CoreSnapshotManager

    func bar(songId: String, kind: NowPlayingKind, isPlaying: Bool) async -> NowPlayingBar? {
        guard let store = snapshot.storeIfLoaded else { return nil }
        return try? store.nowPlayingBar(songId: songId, kind: kind, isPlaying: isPlaying)
    }
}
