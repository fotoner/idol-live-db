import XCTest
@testable import ImasLiveDB

/// 表示文言の値 (`DisplayText`) のテスト。
///
/// データ (`.verbatim`) とコア由来 (`.core`) は翻訳引きも書式も通らず、そのままの文字列になる。
/// DS コンポーネントの移行用入口 (String → `.verbatim`) が今と 1 バイトも違わずに描ける根拠。
final class DisplayTextTests: XCTestCase {

    func testVerbatimAndCorePassThroughUnchanged() {
        // 桁区切り・% 書式・カタログのキーに見える文字列も、そのまま出る
        for s in ["1234曲", "50%オフ", "%@", "common.action.see_all", "欠席", ""] {
            XCTAssertEqual(DisplayText.verbatim(s).resolved, s)
            XCTAssertEqual(DisplayText.core(s).resolved, s)
        }
    }

    func testKeyResolvesThroughCatalog() {
        var resource = L10n.I18n.languageTag
        resource.locale = Locale(identifier: "ja")
        XCTAssertEqual(DisplayText.key(resource).resolved, "ja")
    }

    /// ViewModel の状態を値の等価で断言できる (シミュレータの言語に左右されない)。
    func testEquatable() {
        XCTAssertEqual(DisplayText.verbatim("楽曲"), .verbatim("楽曲"))
        XCTAssertNotEqual(DisplayText.verbatim("楽曲"), .verbatim("ユニット"))
        // 同じ文字列でも、データとコア由来は別物
        XCTAssertNotEqual(DisplayText.verbatim("欠席"), .core("欠席"))
        XCTAssertEqual(DisplayText.key(L10n.Common.actionSeeAll), .key(L10n.Common.actionSeeAll))
        XCTAssertNotEqual(DisplayText.key(L10n.Common.actionSeeAll), .key(L10n.I18n.languageTag))
        XCTAssertNotEqual(DisplayText.key(L10n.Common.actionSeeAll), .verbatim("すべて見る"))
    }
}
