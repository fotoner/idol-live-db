import XCTest
@testable import ImasLiveDB

/// 文言カタログ (i18n/catalog) から生成した表とアクセサが、実行時に期待どおり解決されるかのテスト。
///
/// 期待値は生成器 (tools/i18n) がサンプル引数 (1234 / 2026 を含む) で計算し、生成物
/// `L10nCatalogKeys` (Generated/L10nCatalogKeys.generated.swift) に入れている。
/// ko は dev チャネルなので Debug ビルド (テストはこれ) にだけ表が入る — この前提で ja と ko を両方見る。
final class L10nCatalogTests: XCTestCase {

    /// アクセサが引くバンドル (`L10n.bundle`) の実体。テストでもアプリ本体を指す。
    private var appBundle: Bundle {
        switch L10n.bundle {
        case .forClass(let anyClass): Bundle(for: anyClass)
        case .atURL(let url): Bundle(url: url) ?? .main
        case .main: .main
        @unknown default: .main
        }
    }

    /// 書式・エスケープ・桁区切り: 生成器が計算した期待値と、実行時の解決結果が一致する。
    /// 言語は `LocalizedStringResource.locale` で指定する (シミュレータの言語設定に左右されない)。
    func testRenderedValuesMatchGenerator() {
        XCTAssertFalse(L10nCatalogKeys.all.isEmpty, "生成物 L10nCatalogKeys が空")
        for entry in L10nCatalogKeys.all {
            XCTAssertNotNil(entry.expected["ja"], "\(entry.key) に ja の期待値が無い")
            for (lang, expected) in entry.expected.sorted(by: { $0.key < $1.key }) {
                var resource = entry.make()
                resource.locale = Locale(identifier: lang)
                XCTAssertEqual(String(localized: resource), expected, "\(entry.key) [\(lang)] (表 \(entry.table))")
            }
        }
    }

    /// 表の配置漏れを見つける: ja の lproj に番兵値付きで直接問い合わせる。
    /// (アクセサの defaultValue は ja なので、表やキーが無くても上のテストの ja は通ってしまう)
    func testEveryKeyIsInItsJaTable() throws {
        let path = try XCTUnwrap(appBundle.path(forResource: "ja", ofType: "lproj"), "ja.lproj が無い")
        let ja = try XCTUnwrap(Bundle(path: path))
        let missing = "\u{1}MISSING"
        for entry in L10nCatalogKeys.all {
            let value = ja.localizedString(forKey: entry.key, value: missing, table: entry.table)
            XCTAssertNotEqual(value, missing, "\(entry.key) が \(entry.table) 表 (ja) に無い")
        }
    }

    /// 実際に出ている言語は i18n.language_tag で分かる (DisplayLocale の出どころ)。
    func testLanguageTagResolvesPerLanguage() {
        var resource = L10n.I18n.languageTag
        resource.locale = Locale(identifier: "ja")
        XCTAssertEqual(String(localized: resource), "ja")
        resource.locale = Locale(identifier: "ko")
        XCTAssertEqual(String(localized: resource), "ko", "ko の表が Debug ビルドに入っていない")
    }

    /// ウィジェット拡張のバンドルにも共有の表 (Shared/L10n/Generated) が入っている。
    /// シミュレータの言語に左右されないよう lproj を直接開く。
    func testWidgetBundleHasSharedTables() throws {
        let url = try XCTUnwrap(
            appBundle.builtInPlugInsURL?.appendingPathComponent("ImasLiveDBWidget.appex"), "PlugIns が無い")
        let widget = try XCTUnwrap(Bundle(url: url), "ImasLiveDBWidget.appex が無い")
        let path = try XCTUnwrap(widget.path(forResource: "ja", ofType: "lproj"), "ウィジェットに ja.lproj が無い")
        let ja = try XCTUnwrap(Bundle(path: path))
        XCTAssertEqual(ja.localizedString(forKey: "i18n.language_tag", value: "\u{1}MISSING", table: "I18n"), "ja")
    }
}
