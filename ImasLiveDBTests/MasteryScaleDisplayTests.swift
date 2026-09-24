import XCTest
@testable import ImasLiveDB

/// 習熟度の段のラベルの表示 (`MasteryScale.displayLabels` / `storing(displayLabels:)`) のテスト。
///
/// ラベルは文字列のまま保存される (`mastery_scale_labels_v1`)。保存値は言語で変えず、
/// 編集していないプリセット (ja の語彙と完全一致) だけを表示のときに訳す。
/// 言語は `LocalizedStringResource.locale` で指定し、シミュレータの言語に左右されないようにする。
final class MasteryScaleDisplayTests: XCTestCase {

    /// プリセットの文言 (下から順)。`MasteryScale.presets` と同じ並び。
    private var presetKeys: [[LocalizedStringResource]] {
        [
            [L10n.Mastery.presetSteps2Level1, L10n.Mastery.presetSteps2Level2],
            [L10n.Mastery.presetSteps3Level1, L10n.Mastery.presetSteps3Level2, L10n.Mastery.presetSteps3Level3],
            [L10n.Mastery.presetSteps4Level1, L10n.Mastery.presetSteps4Level2,
             L10n.Mastery.presetSteps4Level3, L10n.Mastery.presetSteps4Level4],
        ]
    }

    private func resolve(_ resource: LocalizedStringResource, _ lang: String) -> String {
        var r = resource
        r.locale = Locale(identifier: lang)
        return String(localized: r)
    }

    /// 保存する語彙は ja のまま (訳した値を保存すると、言語を変えたときに「編集済み」に化ける)。
    func testStoredVocabularyIsUnchanged() {
        XCTAssertEqual(MasteryScale.defaultLabels, ["聞いた", "覚えた", "完璧"])
        XCTAssertEqual(MasteryScale.presets.map(\.labels), [
            ["聞いた", "覚えた"],
            ["聞いた", "覚えた", "完璧"],
            ["聞いた", "だいたい", "覚えた", "完璧"],
        ])
    }

    /// ja の表示は保存値と 1 バイトも違わない (ja では displayLabels == labels)。
    func testPresetKeysInJaMatchStoredVocabulary() {
        XCTAssertEqual(MasteryScale.presets.count, presetKeys.count)
        for (preset, keys) in zip(MasteryScale.presets, presetKeys) {
            XCTAssertEqual(keys.map { resolve($0, "ja") }, preset.labels)
        }
    }

    /// ko の訳もスワイプのボタンに収まる長さ (4 文字以内) にしてある。
    func testPresetKeysInKoFitSwipeButton() {
        for keys in presetKeys {
            for key in keys {
                let ko = resolve(key, "ko")
                XCTAssertLessThanOrEqual(ko.count, 4, "\(key.key) の ko「\(ko)」が 4 文字を超える")
            }
        }
    }

    /// 訳したプリセットのまま反映すると、プリセットの語彙 (ja) で保存される。
    func testStoringDisplayedPresetKeepsStoredVocabulary() {
        for preset in MasteryScale.presets {
            XCTAssertEqual(MasteryScale.storing(displayLabels: preset.displayLabels), preset)
        }
    }

    /// 利用者が書き換えたラベルは訳さずにそのまま出し、そのまま保存する。
    func testCustomLabelsPassThrough() {
        let custom = MasteryScale(labels: ["聞いた", "口ずさめる"])
        XCTAssertEqual(custom.displayLabels, custom.labels)
        XCTAssertEqual(custom.label(2), "口ずさめる")
        XCTAssertEqual(MasteryScale.storing(displayLabels: custom.labels), custom)
    }

    /// 0 段 (未設定) は文言、段数を超える段は LV.n。
    func testLabelOfUnsetAndOutOfRange() {
        let scale = MasteryScale.standard
        XCTAssertEqual(scale.label(0), String(localized: L10n.Mastery.levelUnset))
        XCTAssertEqual(scale.label(9), "LV.9")
        XCTAssertEqual(scale.label(3), scale.displayLabels[2])
    }
}
