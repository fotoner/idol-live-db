import XCTest
@testable import ImasLiveDB

/// 表示文言の値 (`DisplayText`) のテスト。
///
/// データ (`.verbatim`) とコア由来 (`.core`) は翻訳引きも書式も通らず、そのままの文字列になる。
final class DisplayTextTests: XCTestCase {

    func testVerbatimAndCorePassThroughUnchanged() {
        // % 書式・カタログのキーに見える文字列も、そのまま出る
        let s = "%@ 50%オフ i18n.language_tag"
        XCTAssertEqual(DisplayText.verbatim(s).resolved, s)
        XCTAssertEqual(DisplayText.core(s).resolved, s)
    }

    func testKeyResolvesThroughCatalog() {
        var resource = L10n.I18n.languageTag
        resource.locale = Locale(identifier: "ja")
        XCTAssertEqual(DisplayText.key(resource).resolved, "ja")
    }
}
