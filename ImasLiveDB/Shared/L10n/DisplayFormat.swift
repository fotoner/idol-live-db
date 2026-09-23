import Foundation

/// 表示用の日付・曜日。公演日は JST 基準、暦はグレゴリオ暦に固定し、言語だけ DisplayLocale に従う。
///
/// 端末の暦を和暦・仏暦にしている人に「令和8年9月」を出さない (TimelineDateParser.calendar と同じ方針)。
/// `Date.FormatStyle` の calendar は既定で端末の暦 (.autoupdatingCurrent) なので、ここで明示的に固定する。
/// 並びの区切り (list) は common.list.* のキーができたら足す。
enum DisplayFormat {
    private static let jst = TimeZone(identifier: "Asia/Tokyo")!

    private static func calendar(_ locale: Locale) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = locale
        calendar.timeZone = jst
        return calendar
    }

    /// 1 文字の曜日。先頭は日曜 (firstWeekday に関わらず)。ja: 日 月 火 … / ko: 일 월 화 …
    static func weekdaySymbols(_ locale: Locale = DisplayLocale.current.formattingLocale) -> [String] {
        calendar(locale).veryShortWeekdaySymbols
    }

    /// 年と月。ja: 2026年9月 / ko: 2026년 9월
    static func yearMonth(_ date: Date, _ locale: Locale = DisplayLocale.current.formattingLocale) -> String {
        date.formatted(Date.FormatStyle(locale: locale, calendar: calendar(locale), timeZone: jst).year().month())
    }
}
