import XCTest
@testable import ImasLiveDB

/// 表示用の日付・曜日 (`DisplayFormat`) と、その既定ロケール (`DisplayLocale`) のテスト。
///
/// 言語だけ表示言語に従い、暦はグレゴリオ暦・時刻帯は JST に固定する。
final class DisplayFormatTests: XCTestCase {

    /// 2026-09-01 00:30 (JST)。UTC ではまだ 8 月 31 日。
    private let jstFirstOfSeptember = Date(timeIntervalSince1970: 1_788_190_200)

    func testWeekdaySymbolsStartOnSunday() {
        XCTAssertEqual(DisplayFormat.weekdaySymbols(Locale(identifier: "ja")), ["日", "月", "火", "水", "木", "金", "土"])
        XCTAssertEqual(DisplayFormat.weekdaySymbols(Locale(identifier: "ko")), ["일", "월", "화", "수", "목", "금", "토"])
        // 月曜始まりの地域でも、並びは日曜始まりのまま (呼び出し側の列の並びが崩れない)
        XCTAssertEqual(DisplayFormat.weekdaySymbols(Locale(identifier: "ja_JP@fw=mon")).first, "日")
    }

    func testYearMonthUsesGregorianAndJST() {
        XCTAssertEqual(DisplayFormat.yearMonth(jstFirstOfSeptember, Locale(identifier: "ja_JP")), "2026年9月")
        XCTAssertEqual(DisplayFormat.yearMonth(jstFirstOfSeptember, Locale(identifier: "ko_KR")), "2026년 9월")
        // 端末の暦が和暦でも「令和8年9月」にしない
        XCTAssertEqual(
            DisplayFormat.yearMonth(jstFirstOfSeptember, Locale(identifier: "ja_JP@calendar=japanese")), "2026年9月")
    }

    /// 既定ロケールの言語は、実際に引かれた表の言語 (i18n.language_tag) と一致する。
    func testDisplayLocaleFollowsLanguageTag() {
        let current = DisplayLocale.current
        XCTAssertTrue(["ja", "ko"].contains(current.languageTag), current.languageTag)
        XCTAssertEqual(current.formattingLocale.language.languageCode?.identifier, current.languageTag)
    }
}
