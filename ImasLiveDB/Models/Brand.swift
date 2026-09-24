import Foundation
import GRDB

struct Brand: Codable, FetchableRecord, PersistableRecord, Identifiable, Sendable {
    static let databaseTableName = "brands"

    var id: String
    var name: String
    var shortName: String
    var color: String?
    var sortOrder: Int
    var iconUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case color
        case sortOrder = "sort_order"
        case iconUrl = "icon_url"
    }
}

// MARK: - Icon Text

extension Brand {
    /// アイコン円内に表示する短いテキスト (3-4 字)。
    /// 公式ロゴは版権 NG なので、ブランドカラー背景に「765」「ミリ」等を載せる。
    /// 仮名の略称 (デレ・ミリ…) はファンの呼び方で正式名ではないので、今の言語で引く。
    /// 数字と英字の略称 (765・SideM) はどの言語でもそのまま。
    var iconText: String {
        switch id {
        case "765as":  return "765"
        case "961":    return "961"
        case "876":    return "876"
        case "cg":     return String(localized: L10n.Model.brandIconCg)
        case "ml":     return String(localized: L10n.Model.brandIconMl)
        case "sidem":  return "SideM"
        case "sc":     return String(localized: L10n.Model.brandIconSc)
        case "gakuen": return String(localized: L10n.Model.brandIconGakuen)
        case "valv":   return String(localized: L10n.Model.brandIconValv)
        case "other":  return String(localized: L10n.Model.brandIconOther)
        default:       return String(shortName.prefix(2))
        }
    }
}
