import Foundation
import Observation

/// お題一覧 (開催中 / 終了) の取得状態 (Presentation)。
/// データ取得は `CommunityVoting` プロトコル越しなのでフェイク注入で単体テストできる。
@MainActor
@Observable
final class PollListViewModel {
    private let voting: any CommunityVoting

    private(set) var activePolls: [Poll] = []
    private(set) var pastPolls: [Poll] = []
    private(set) var isLoading = false
    /// 直近の取得の失敗メッセージ。解決済みの String ではなく文言の値で持ち、画面で文字列にする。
    private(set) var loadError: DisplayText?

    nonisolated init(voting: any CommunityVoting) {
        self.voting = voting
    }

    func polls(active: Bool) -> [Poll] { active ? activePolls : pastPolls }

    func load(active: Bool) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await voting.polls(status: active ? "active" : "past")
            loadError = nil
            if active { activePolls = result } else { pastPolls = result }
        } catch {
            // APIClientError の説明は Services 側で作った文字列なのでそのまま出す (verbatim)
            loadError = (error as? APIClientError)?.errorDescription.map(DisplayText.verbatim)
                ?? .key(L10n.Polls.errorNetwork)
        }
    }

    /// 作成直後のお題を一覧へ即時反映する (開催中のみ先頭に差し込む)。
    func insertCreated(_ poll: Poll) {
        if poll.isActive { activePolls.insert(poll, at: 0) }
    }
}
