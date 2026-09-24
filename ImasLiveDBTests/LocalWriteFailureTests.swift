import XCTest
@testable import ImasLiveDB

/// 端末にしか無いデータの書き込み失敗の知らせ (`LocalWriteFailure`)。
///
/// 出し方 (UIKit のアラート) は差し替えて、失敗が知らせの口まで届くことと文面を見る。
@MainActor
final class LocalWriteFailureTests: XCTestCase {

    /// アプリの起動で、知らせの出し方が差し込まれている (差し忘れるとログにしか残らない)。
    func testAppInstallsThePresenterAtLaunch() {
        XCTAssertNotNil(LocalWriteFailure.presenter)
    }

    func testReportHandsTheNoticeForTheActionToThePresenter() {
        let original = LocalWriteFailure.presenter
        defer { LocalWriteFailure.presenter = original }
        var received: [LocalWriteFailure.Notice] = []
        LocalWriteFailure.presenter = { received.append($0) }

        LocalWriteFailure.report(NSError(domain: "test", code: 1), action: "メモの保存")

        // 知らせは操作名を値で持つ (文字列の操作名はそのまま差し込むデータ)
        XCTAssertEqual(received, [LocalWriteFailure.Notice(action: .verbatim("メモの保存"))])
        // 文面はカタログの文言 (シミュレータの言語で解決される)
        XCTAssertEqual(received.map(\.title), [String(localized: L10n.EditFeed.localWriteFailedTitle)])
        XCTAssertEqual(
            received.map(\.message),
            [String(localized: L10n.EditFeed.localWriteFailedMessage(action: "メモの保存"))])
    }

    /// カタログの文言 (`.key(L10n.<Ns>.<key>)`) で渡した操作名も、同じ知らせになって出る。
    /// 操作名は本文と同じ言語で文字列になってから差し込まれる。
    func testReportWithDisplayTextAction() {
        let original = LocalWriteFailure.presenter
        defer { LocalWriteFailure.presenter = original }
        var received: [LocalWriteFailure.Notice] = []
        LocalWriteFailure.presenter = { received.append($0) }

        LocalWriteFailure.report(NSError(domain: "test", code: 1), action: .key(L10n.EditFeed.opCreate))

        XCTAssertEqual(received, [LocalWriteFailure.notice(action: .key(L10n.EditFeed.opCreate))])
        XCTAssertEqual(
            received.map(\.message),
            [String(localized: L10n.EditFeed.localWriteFailedMessage(action: String(localized: L10n.EditFeed.opCreate)))])
    }

    /// ja の文面は移行前 (文字列を直に組み立てていたとき) と 1 バイトも変わらない。
    func testJapaneseTextIsUnchanged() {
        var title = L10n.EditFeed.localWriteFailedTitle
        title.locale = Locale(identifier: "ja")
        XCTAssertEqual(String(localized: title), "保存できませんでした")

        var message = L10n.EditFeed.localWriteFailedMessage(action: "メモの保存")
        message.locale = Locale(identifier: "ja")
        XCTAssertEqual(String(localized: message), "メモの保存に失敗しました。変更は保存されていません。もう一度お試しください。")
    }
}
