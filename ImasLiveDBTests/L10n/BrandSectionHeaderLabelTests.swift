import XCTest
@testable import ImasLiveDB

/// ブランドの区切り見出し (`BrandSectionHeader`) の件数の文言のテスト。
///
/// 単位を渡さない呼び出し (アイドル一覧・ピッカー) は人数の文言をカタログから引き、
/// ユニット一覧は件数の文言を `countLabel:` で渡す。String の単位を渡す移行用の入口は、
/// 以前の `Text("\(count)\(unit)")` と同じ文字列をそのまま出す。
///
/// `BrandSectionHeader` は View なので MainActor に隔離される。テストも @MainActor にする。
@MainActor
final class BrandSectionHeaderLabelTests: XCTestCase {

    private let brand = Brand(id: "ml", name: "ミリオンライブ", shortName: "ミリ", color: nil, sortOrder: 0, iconUrl: nil)

    func testDefaultCountIsPeopleKey() {
        XCTAssertEqual(BrandSectionHeader(brand: brand, count: 12).countLabel,
                       .key(L10n.Common.brandSectionCountPeople(count: 12)))
    }

    func testCountLabelIsPassedThrough() {
        let label = DisplayText.key(L10n.Units.listBrandCount(count: 5))
        XCTAssertEqual(BrandSectionHeader(brand: brand, countLabel: label).countLabel, label)
    }

    func testLegacyUnitIsVerbatim() {
        XCTAssertEqual(BrandSectionHeader(brand: brand, count: 5, unit: "組").countLabel, .verbatim("5組"))
    }

    /// ja は移行前の表示 (「12人」「5組」) と同じ。
    func testJaMatchesPreviousRendering() {
        var people = L10n.Common.brandSectionCountPeople(count: 12)
        people.locale = Locale(identifier: "ja")
        XCTAssertEqual(String(localized: people), "12人")

        var units = L10n.Units.listBrandCount(count: 5)
        units.locale = Locale(identifier: "ja")
        XCTAssertEqual(String(localized: units), "5組")
    }
}
