import Foundation
import OSLog

private let logger = Logger(subsystem: "com.fugaif.ImasLiveDB", category: "pending_actions")

/// お気に入りのコミュニティAPI送信に失敗した場合の軽量永続キュー。
/// UserDefaults ベース・JSON 配列で保持し、再起動後もリトライできる。
struct PendingFavoriteAction: Codable, Sendable {
    let songId: String
    let value: Bool
    let enqueuedAt: Date
    var retryCount: Int
}

@MainActor
final class PendingCommunityActions {
    static let shared = PendingCommunityActions()

    /// お気に入りをサーバへ送る口。テストでは差し替える。
    typealias SendFavorite = @Sendable (_ songId: String, _ value: Bool) async throws -> Void

    private let key: String
    private let defaults: UserDefaults
    private let sendFavorite: SendFavorite
    private(set) var actions: [PendingFavoriteAction] = []
    private var isFlushing = false
    private static let maxRetries = 3

    private convenience init() {
        self.init(defaults: .standard) { songId, value in
            try await CommunityAPI.shared.toggleFavorite(songId: songId, value: value)
        }
    }

    init(defaults: UserDefaults, key: String = "pending_favorite_actions", send: @escaping SendFavorite) {
        self.defaults = defaults
        self.key = key
        self.sendFavorite = send
        load()
    }

    // MARK: - Queue Management

    /// お気に入りの状態をコミュニティ集計へ送る。送れなければ積んで、後で送り直す。
    func send(songId: String, value: Bool) async {
        do {
            try await sendFavorite(songId, value)
            // 送れた値がこの曲の最新の意思。前に積んだ別の値を送り直すと集計が巻き戻る。
            discard(songId: songId)
        } catch {
            logger.warning("toggleFavorite failed, enqueuing: songId=\(songId) error=\(error.localizedDescription)")
            enqueue(songId: songId, value: value)
        }
    }

    func enqueue(songId: String, value: Bool) {
        // 同じ songId が既にあれば上書き
        actions.removeAll { $0.songId == songId }
        let action = PendingFavoriteAction(songId: songId, value: value, enqueuedAt: Date(), retryCount: 0)
        actions.append(action)
        persist()
        logger.info("Enqueued pending favorite: songId=\(songId) value=\(value)")
    }

    func flushPendingFavorites() {
        guard !isFlushing, !actions.isEmpty else { return }
        isFlushing = true
        Task { await flush() }
    }

    /// 積み残しを送り直す (テストからは完了を待てる形で呼ぶ)。
    func flush() async {
        isFlushing = true
        defer { isFlushing = false }
        await performFlush()
    }

    // MARK: - Private

    /// この曲の積み残しを捨てる。
    private func discard(songId: String) {
        let before = actions.count
        actions.removeAll { $0.songId == songId }
        if actions.count != before { persist() }
    }

    /// 列の中でまだ最新の意思として残っているか (送り直しの途中で上書き・破棄されていないか)。
    private func isStillQueued(_ action: PendingFavoriteAction) -> Bool {
        actions.contains { $0.songId == action.songId && $0.enqueuedAt == action.enqueuedAt }
    }

    /// 送り直しは、始めた時点の列を順に回す。送信を待つ間に積まれた・捨てられたものを
    /// 失わないよう、列はまとめて置き換えず 1 件ずつ直す。
    private func performFlush() async {
        for action in actions {
            guard isStillQueued(action) else { continue }

            if action.retryCount > 0 {
                // 指数バックオフ: 最大3回
                let delay = pow(2.0, Double(action.retryCount))
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                guard isStillQueued(action) else { continue }
            }

            do {
                try await sendFavorite(action.songId, action.value)
                logger.info("Flushed pending favorite: songId=\(action.songId) retryCount=\(action.retryCount)")
                remove(action)
            } catch {
                let retryCount = action.retryCount + 1
                if retryCount < Self.maxRetries {
                    logger.warning("Pending favorite retry \(retryCount)/\(Self.maxRetries): songId=\(action.songId) error=\(error.localizedDescription)")
                    if let i = actions.firstIndex(where: { $0.songId == action.songId && $0.enqueuedAt == action.enqueuedAt }) {
                        actions[i].retryCount = retryCount
                    }
                } else {
                    logger.error("Giving up on pending favorite: songId=\(action.songId) error=\(error.localizedDescription)")
                    remove(action)
                }
            }
        }
        persist()
    }

    private func remove(_ action: PendingFavoriteAction) {
        actions.removeAll { $0.songId == action.songId && $0.enqueuedAt == action.enqueuedAt }
    }

    private func load() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([PendingFavoriteAction].self, from: data) else {
            actions = []
            return
        }
        actions = decoded
        if !actions.isEmpty {
            let count = actions.count
            logger.info("Loaded \(count) pending favorite actions from UserDefaults")
        }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(actions) else { return }
        defaults.set(data, forKey: key)
    }
}
