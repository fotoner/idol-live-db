// 生成物: i18n/catalog/*.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation
@testable import ImasLiveDB

/// カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。
/// L10nCatalogTests が実行時の解決結果と比べる (書式・エスケープ・桁区切り・表の置き場所)。
struct L10nCatalogSample {
    /// 完全キー (<名前空間>.<相対キー>)
    let key: String
    /// String Catalog の表の名前
    let table: String
    /// 表が入るバンドル ("app" / "widget")
    let bundles: [String]
    /// 値を持つ言語 (基準言語と、訳のある言語)
    let languagesWithValue: [String]
    /// 見本の引数 (失敗メッセージ用)
    let args: String
    /// 見本の引数で作った文言
    let make: () -> LocalizedStringResource
    /// 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック)
    let expected: [String: String]

    var sample: LocalizedStringResource { make() }
}

/// Info.plist の表 (InfoPlist.xcstrings) の 1 キー。key は Info.plist のキー名。
struct L10nInfoPlistSample {
    let catalogKey: String
    /// "app" / "widget"
    let target: String
    let key: String
    /// 言語 → 値 (値のある言語だけ)
    let values: [String: String]
}

enum L10nCatalogKeys {
    /// このカタログの言語 (基準言語が先頭)
    static let languages: [String] = ["ja", "ko"]

    /// 全キー × 見本
    static var all: [L10nCatalogSample] {
        var all: [L10nCatalogSample] = []
        all += samplesI18n()
        return all
    }

    /// Info.plist の表のキー
    static var infoPlist: [L10nInfoPlistSample] { [] }

    private static func samplesI18n() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "i18n.language_tag", table: "I18n", bundles: ["app", "widget"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.I18n.languageTag }, expected: ["ja": "ja", "ko": "ko"]))
        return s
    }
}
