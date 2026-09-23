import XCTest
@testable import ImasLiveDB

/// `sortIdols` (純粋ロジック) の単体テスト。DB にも UI にも依存しない。
///
/// 固定する不変条件:
/// - 数値キー (年齢・身長・体重) は既定で降順 (年上から / 背が高い順)。
/// - **値が無いアイドルは並び方向に関わらず必ず末尾**。昇順で先頭に空欄が並ぶと
///   「若い順」を見に来た人の視界を潰すため。
/// - 同値は公式順 (sortOrder) で安定させる (再描画で順序が入れ替わらない)。
///
/// 規則そのものはコア (imas-core) の Rust テストが持つ。ここに残すのは、Swift の包みが
/// コアに正しく渡し・受け取れていることを見る配線のスモークテストと、Swift にしか無い処理のテスト (Q-13)。
final class IdolListSortingTests: XCTestCase {

    private func makeIdol(
        _ id: String,
        sortOrder: Int = 0,
        nameKana: String? = nil,
        age: Int? = nil,
        height: Double? = nil,
        weight: Double? = nil,
        birthday: String? = nil,
        debutDate: String? = nil
    ) -> Idol {
        Idol(
            id: id, brandId: "cg", name: id, nameKana: nameKana,
            nameRomaji: nil, familyName: nil, givenName: nil, nickname: nil, color: nil,
            sortOrder: sortOrder, birthday: birthday, bloodType: nil, height: height, weight: weight,
            birthPlace: nil, age: age, bust: nil, waist: nil, hip: nil, constellation: nil,
            hobbies: nil, talents: nil, description: nil, gender: nil, handedness: nil,
            debutDate: debutDate, attribute: nil, aliases: nil)
    }

    // MARK: - 年齢

    func testAgeMissingValuesGoLastRegardlessOfDirection() {
        let idols = [makeIdol("none1"), makeIdol("young", age: 12), makeIdol("none2"), makeIdol("old", age: 30)]

        let desc = sortIdols(idols, by: .age, ascending: false).map(\.id)
        XCTAssertEqual(Array(desc.prefix(2)), ["old", "young"])
        XCTAssertEqual(Set(desc.suffix(2)), ["none1", "none2"])

        let asc = sortIdols(idols, by: .age, ascending: true).map(\.id)
        XCTAssertEqual(Array(asc.prefix(2)), ["young", "old"], "昇順でも値なしが先頭に来てはいけない")
        XCTAssertEqual(Set(asc.suffix(2)), ["none1", "none2"])
    }

    // MARK: - 身長 / 体重

    // MARK: - 文字列キー

    // MARK: - 安定性 / 公式順

    // MARK: - グルーピング方針

    func testOnlyOfficialKeepsBrandGrouping() {
        XCTAssertTrue(IdolSortOrder.official.keepsBrandGrouping)
        for order in IdolSortOrder.allCases where order != .official {
            XCTAssertFalse(order.keepsBrandGrouping, "\(order.rawValue) は通し並びであるべき")
        }
    }

    // MARK: - 行に出す指標

    func testMetricLabelIsShownOnlyForSortableFields() {
        let idol = makeIdol("x", age: 17, height: 158, weight: 45)
        XCTAssertEqual(IdolSortOrder.age.metricLabel(for: idol), "17歳")
        XCTAssertEqual(IdolSortOrder.height.metricLabel(for: idol), "158cm")
        XCTAssertEqual(IdolSortOrder.weight.metricLabel(for: idol), "45kg")
        XCTAssertNil(IdolSortOrder.official.metricLabel(for: idol))
        XCTAssertNil(IdolSortOrder.nameKana.metricLabel(for: idol))
    }

    func testMetricLabelIsNilWhenValueMissing() {
        let idol = makeIdol("x")
        XCTAssertNil(IdolSortOrder.age.metricLabel(for: idol))
        XCTAssertNil(IdolSortOrder.height.metricLabel(for: idol))
    }
}
