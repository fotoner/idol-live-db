import Foundation
import Observation

/// 殿堂 (終了お題の優勝者一覧) の取得状態 (Presentation)。
/// 取得は `CommunityVoting` プロトコル越し。曲/アイドルへの遷移解決 (master 参照) は View 側に残す。
@MainActor
@Observable
final class PollHallOfFameViewModel {
    private let voting: any CommunityVoting

    private(set) var results: [PollResult] = []
    private(set) var isLoading = false
    /// 直近の取得の失敗メッセージ。解決済みの String ではなく文言の値で持ち、画面で文字列にする。
    private(set) var loadError: DisplayText?

    nonisolated init(voting: any CommunityVoting) {
        self.voting = voting
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            results = try await voting.pollResults()
            loadError = nil
        } catch {
            // APIClientError の説明は Services 側で作った文字列なのでそのまま出す (verbatim)
            loadError = (error as? APIClientError)?.errorDescription.map(DisplayText.verbatim)
                ?? .key(L10n.Polls.errorNetwork)
        }
    }
}
