//  AppDatabase の Calendar Queries を切り出したもの。
//  分割の意図と分割線の引き方は docs/ARCHITECTURE.md を参照。
//  ここにあるのは移動してきたクエリだけで、ロジックは 1 行も変えていない。

import Foundation
import GRDB

extension AppDatabase {

    // MARK: - Calendar Queries

    private static let calendarDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        // JST 固定: 海外渡航中でも日付がズレないようにする
        fmt.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return fmt
    }()

    static func parseDate(_ string: String) -> Date? {
        calendarDateFormatter.date(from: string)
    }

}
