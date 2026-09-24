import XCTest
@testable import ImasLiveDB

/// 楽曲一覧・曲詳細で enum から引く表示名 (songs 名前空間) のテスト。
///
/// `SongSortOrder` / `SongCollectFilter` は日本語の rawValue をそのまま画面に出していた。
/// rawValue は変えずに (`SongCollectFilter` は `@AppStorage("songs_collect_filter")` の保存値)、
/// 表示だけ `songsListLabel` 経由でカタログを引くようにしたので、
/// - ja の表示が以前の rawValue と 1 バイトも違わないこと
/// - 保存値の rawValue が変わっていないこと
/// を固定する。言語は `LocalizedStringResource.locale` で指定する (シミュレータの言語に左右されない)。
final class SongsDisplayLabelTests: XCTestCase {

    private func resolve(_ resource: LocalizedStringResource, _ language: String) -> String {
        var resource = resource
        resource.locale = Locale(identifier: language)
        return String(localized: resource)
    }

    func testSortOrderLabelInJapaneseIsTheFormerRawValue() {
        for order in SongSortOrder.allCases {
            XCTAssertEqual(resolve(order.songsListLabel, "ja"), order.rawValue, "\(order)")
        }
    }

    func testCollectFilterStoredValuesAreUnchanged() {
        // @AppStorage に入っている値。変えると利用者の設定が黙って既定に戻る。
        XCTAssertEqual(SongCollectFilter.allCases.map(\.rawValue), ["すべて", "回収済のみ", "未回収のみ"])
    }

    func testCollectFilterLabelInJapaneseIsTheFormerRawValue() {
        for filter in SongCollectFilter.allCases {
            XCTAssertEqual(resolve(filter.songsListLabel, "ja"), filter.rawValue, "\(filter)")
        }
    }

    func testLabelsAreTranslatedInKorean() {
        XCTAssertEqual(resolve(SongCollectFilter.all.songsListLabel, "ko"), "전체")
        XCTAssertEqual(resolve(SongSortOrder.releaseDate.songsListLabel, "ko"), "발매일순")
    }

    /// 曲詳細のタブ名。以前の固定文字列と ja が同じ。
    func testDetailTabLabelsInJapanese() {
        let expected: [SongDetailTab: String] = [
            .info: "情報・歌唱", .lyrics: "歌詞", .history: "披露履歴", .community: "コミュニティ",
        ]
        for tab in SongDetailTab.allCases {
            XCTAssertEqual(resolve(tab.label, "ja"), expected[tab], "\(tab)")
        }
    }

    /// 検索対象のチップ。曲名スコープは表示形式で絞る対象が変わる。
    func testSearchModeLabelsInJapanese() {
        XCTAssertEqual(resolve(SongSearchMode.title.label(in: .songs), "ja"), "曲名")
        XCTAssertEqual(resolve(SongSearchMode.title.label(in: .albums), "ja"), "アルバム名")
        XCTAssertEqual(resolve(SongSearchMode.title.label(in: .series), "ja"), "シリーズ名")
        XCTAssertEqual(resolve(SongSearchMode.performer.label(in: .songs), "ja"), "歌唱")
        XCTAssertEqual(resolve(SongSearchMode.creator.label(in: .songs), "ja"), "作詞作曲")
        XCTAssertEqual(resolve(SongSearchMode.lyrics.label(in: .songs), "ja"), "歌詞")
    }
}
