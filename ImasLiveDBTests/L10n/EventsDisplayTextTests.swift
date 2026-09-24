import XCTest
@testable import ImasLiveDB

/// ライブまわり (events 名前空間) の表示文言のテスト。
///
/// 言語は `LocalizedStringResource.locale` で ja に固定して引く (シミュレータの言語に左右されない)。
/// ja は移行前にコードが出していた文字列と 1 バイトも違わないこと。
final class EventsDisplayTextTests: XCTestCase {

    private func ja(_ resource: LocalizedStringResource) -> String {
        var r = resource
        r.locale = Locale(identifier: "ja")
        return String(localized: r)
    }

    /// マークの種類の表示名。保存値 (rawValue) は英字のまま変えず、表示だけカタログを引く。
    func testUserMarkKindLabelsKeepJapaneseAndStoredValues() {
        let expected: [UserMarkKind: String] = [
            .collected: "回収済", .favorite: "お気に入り", .myPick: "担当", .attended: "参加",
            .note: "メモ", .seat: "座席", .owned: "所有", .mastery: "習熟度",
        ]
        for kind in UserMarkKind.allCases {
            XCTAssertEqual(ja(kind.label), expected[kind], "\(kind)")
        }
        XCTAssertEqual(UserMarkKind.myPick.rawValue, "myPick")
        XCTAssertEqual(UserMarkKind.collected.rawValue, "collected")
    }

    /// サーバの文言は訳さずにそのまま差し込む。
    func testPredictionServerErrorKeepsServerText() {
        guard case .key(let resource) = PredictionError.serverError("rate: 429").userMessage else {
            return XCTFail("serverError はカタログの文言で包む")
        }
        XCTAssertEqual(ja(resource), "サーバーエラー: rate: 429")
    }

    func testPredictionErrorsKeepJapanese() {
        guard case .key(let unauthorized) = PredictionError.unauthorized.userMessage,
              case .key(let tooMany) = PredictionError.tooManyPerformers.userMessage else {
            return XCTFail("カタログの文言で返す")
        }
        XCTAssertEqual(ja(unauthorized), "投票にはApple Sign Inが必要です")
        XCTAssertEqual(ja(tooMany), "1曲につき予想できるのは8人までです")
    }

    /// キャパは人数 (count) なので桁区切りが付く (移行前も grouping(.automatic) で付いていた)。
    func testVenueCapacityLabel() {
        let venue = Venue(id: "v", name: "日本武道館", nameKana: nil, prefecture: nil, city: nil,
                          aliases: nil, capacity: 14500, sortOrder: 0)
        XCTAssertEqual(venue.capacityLabel.map { ja($0) }, "14,500人")
        XCTAssertEqual(venue.displayNameWithArea, "日本武道館")

        let unknown = Venue(id: "u", name: "会場", nameKana: nil, prefecture: nil, city: nil,
                            aliases: nil, capacity: nil, sortOrder: 0)
        XCTAssertNil(unknown.capacityLabel)
    }

    /// 出演パネルの DAY 見出しの日付。曜日は表示言語の 1 文字を差し込む。
    func testCastDayDate() {
        XCTAssertEqual(ja(L10n.Events.castDayDate(month: 9, day: 19, weekday: "土")), "9/19(土)")
    }

    /// セトリの区切りの見出し。メタ未取得 (nil) とコアの「本編」は同じ文言になり、
    /// 読み込みの前後で見出しの言語が入れ替わらない。知らない見出しはコアの文字列のまま。
    @MainActor
    func testSetlistSectionHeading() {
        XCTAssertEqual(SetlistView.sectionHeading(nil), .key(L10n.Events.setlistSectionMain))
        XCTAssertEqual(SetlistView.sectionHeading("本編"), .key(L10n.Events.setlistSectionMain))
        XCTAssertEqual(SetlistView.sectionHeading("アンコール"), .key(L10n.Events.setlistSectionEncore))
        XCTAssertEqual(SetlistView.sectionHeading("MC"), .core("MC"))
        XCTAssertEqual(ja(L10n.Events.setlistSectionMain), "本編")
        XCTAssertEqual(ja(L10n.Events.setlistSectionEncore), "アンコール")
    }
}
