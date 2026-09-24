import XCTest
@testable import ImasLiveDB

@MainActor
final class PollListViewModelTests: XCTestCase {

    private func makePoll(id: String, active: Bool) -> Poll {
        Poll(id: id, title: "お題\(id)", description: nil, targetType: .song,
             createdBy: "u1", createdAt: Date(),
             endsAt: Date().addingTimeInterval(active ? 86400 : -86400),
             status: "active", totalVotes: 0, entryCount: 0,
             candidateScope: .all, scopeBrandIds: nil, scopeEntityIds: nil, topEntityId: nil)
    }

    func testLoadActivePopulatesActiveList() async {
        let fake = FakeCommunityVoting()
        fake.pollsByStatus["active"] = [makePoll(id: "p1", active: true)]
        let vm = PollListViewModel(voting: fake)

        await vm.load(active: true)

        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.loadError)
        XCTAssertEqual(vm.polls(active: true).map(\.id), ["p1"])
        XCTAssertTrue(vm.polls(active: false).isEmpty)
    }

    func testLoadPastPopulatesPastList() async {
        let fake = FakeCommunityVoting()
        fake.pollsByStatus["past"] = [makePoll(id: "old", active: false)]
        let vm = PollListViewModel(voting: fake)

        await vm.load(active: false)

        XCTAssertEqual(vm.polls(active: false).map(\.id), ["old"])
        XCTAssertTrue(vm.polls(active: true).isEmpty)
    }

    func testLoadErrorSetsMessage() async {
        let fake = FakeCommunityVoting()
        fake.shouldThrow = true
        let vm = PollListViewModel(voting: fake)

        await vm.load(active: true)

        XCTAssertNotNil(vm.loadError)
        // APIClientError でない失敗は、カタログの「通信エラー」になる
        XCTAssertEqual(vm.loadError, .key(L10n.Polls.errorNetwork))
    }

    func testInsertCreatedPrependsActivePoll() async {
        let fake = FakeCommunityVoting()
        fake.pollsByStatus["active"] = [makePoll(id: "p1", active: true)]
        let vm = PollListViewModel(voting: fake)
        await vm.load(active: true)

        vm.insertCreated(makePoll(id: "new", active: true))

        XCTAssertEqual(vm.polls(active: true).map(\.id), ["new", "p1"])
    }
}

@MainActor
final class PollHallOfFameViewModelTests: XCTestCase {

    func testLoadPopulatesResults() async {
        let fake = FakeCommunityVoting()
        fake.resultsToReturn = [
            PollResult(pollId: "p1", title: "最強の曲", targetType: .song,
                       endsAt: Date(), entityId: "s1", voteCount: 42)
        ]
        let vm = PollHallOfFameViewModel(voting: fake)

        await vm.load()

        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.loadError)
        XCTAssertEqual(vm.results.map(\.entityId), ["s1"])
    }

    func testLoadErrorSetsMessage() async {
        let fake = FakeCommunityVoting()
        fake.shouldThrow = true
        let vm = PollHallOfFameViewModel(voting: fake)

        await vm.load()

        XCTAssertNotNil(vm.loadError)
        XCTAssertEqual(vm.loadError, .key(L10n.Polls.errorNetwork))
        XCTAssertTrue(vm.results.isEmpty)
    }
}

/// お題の状態の札・候補の範囲のバッジ・対象の種類の表示名。カタログに移しても ja の表示が
/// 1 バイトも変わらないことを、言語を ja に固定して確かめる (シミュレータの言語に左右されない)。
@MainActor
final class PollDisplayLabelTests: XCTestCase {

    private func makePoll(endsIn seconds: TimeInterval, status: String = "active",
                          scope: PollCandidateScope = .all,
                          brandIds: [String]? = nil, entityIds: [String]? = nil) -> Poll {
        Poll(id: "p1", title: "お題", description: nil, targetType: .song,
             createdBy: "u1", createdAt: Date(), endsAt: Date().addingTimeInterval(seconds),
             status: status, totalVotes: 0, entryCount: 0,
             candidateScope: scope, scopeBrandIds: brandIds, scopeEntityIds: entityIds, topEntityId: nil)
    }

    private func ja(_ resource: LocalizedStringResource?) -> String? {
        guard var resource else { return nil }
        resource.locale = Locale(identifier: "ja")
        return String(localized: resource)
    }

    func testStatusLabelKeepsJapaneseText() {
        XCTAssertEqual(ja(makePoll(endsIn: -86_400).statusLabel), "終了")
        XCTAssertEqual(ja(makePoll(endsIn: 86_400, status: "removed").statusLabel), "終了")
        XCTAssertEqual(ja(makePoll(endsIn: 3_600).statusLabel), "本日締切")
        XCTAssertEqual(ja(makePoll(endsIn: 86_400 * 3 + 3_600).statusLabel), "残り3日")
    }

    func testScopeShortLabelKeepsJapaneseText() {
        XCTAssertNil(makePoll(endsIn: 86_400).scopeShortLabel)
        XCTAssertEqual(ja(makePoll(endsIn: 86_400, scope: .brand, brandIds: ["765as"]).scopeShortLabel), "ブランド限定")
        XCTAssertEqual(ja(makePoll(endsIn: 86_400, scope: .brand, brandIds: ["765as", "cg"]).scopeShortLabel),
                       "ブランド限定×2")
        XCTAssertEqual(ja(makePoll(endsIn: 86_400, scope: .manual, entityIds: ["s1", "s2", "s3"]).scopeShortLabel),
                       "指定候補3件")
    }

    func testCandidateNounKeepsJapaneseText() {
        XCTAssertEqual(ja(PollTargetType.song.candidateNoun), "曲")
        XCTAssertEqual(ja(PollTargetType.idol.candidateNoun), "アイドル")
        XCTAssertEqual(ja(PollTargetType.unit.candidateNoun), "ユニット")
    }
}
