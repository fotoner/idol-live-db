import Foundation
import SwiftUI
import UIKit

/// 習熟度の段階の定義 (ラベルと数)。
///
/// **保存されるのは序数だけ** (`user_marks.kind = "mastery"` の `text_value`)。
/// ラベルはここが持ち、設定で差し替えても既存の記録には触らない。段数から導ける規則
/// (次の段 / 重み / 段数を変えたときの寄せ先) と群化・集計は `imas-core` の
/// `domain/mastery.rs` にある。ここは**文言と色だけ**。
struct MasteryScale: Codable, Equatable, Sendable {
    /// 下から順の段ラベル。`labels[0]` が LV.1。
    var labels: [String]

    /// 既定は 3 段。
    ///
    /// 依頼元のツイートは 4 段 (1回聞いた / 耳に馴染んだ / だいたい覚えた / 覚えた) だったが、
    /// 「耳に馴染んだ」が実機で読んだときに言い方として微妙で、さらに**スワイプの
    /// ボタン幅に収まらず途中で切れる** (「耳に馴染」になる)。短く言い切れる 3 段にした。
    /// 語彙の好みは人によるので、設定 (`MasteryScaleSettingsView`) で変えられる。
    ///
    /// **保存される語彙** (`mastery_scale_labels_v1`)。訳さない・変えない。表示は `displayLabels` /
    /// `label(_:)` を通すと、編集していないプリセットは表示言語の訳 (カタログの mastery.preset.*) になる。
    static let defaultLabels = ["聞いた", "覚えた", "完璧"]  // i18n-ignore(storage): 保存する語彙。表示は mastery.preset.steps3.*

    static let standard = MasteryScale(labels: defaultLabels)

    /// 2 段・4 段のプリセットの保存する語彙 (defaultLabels と同じく ja のまま保存する)。
    private static let twoStepLabels = ["聞いた", "覚えた"]  // i18n-ignore(storage): 保存する語彙。表示は mastery.preset.steps2.*
    private static let fourStepLabels = ["聞いた", "だいたい", "覚えた", "完璧"]  // i18n-ignore(storage): 保存する語彙。表示は mastery.preset.steps4.*

    /// 段数を変えるときの出発点。どのラベルも 4 文字以内にして、
    /// スワイプのボタンが切れないようにしてある (訳もカタログの max_len で 4 文字以内)。
    /// チップの名前は `L10n.Mastery.presetName(steps:)`。
    static let presets: [MasteryScale] = [
        MasteryScale(labels: twoStepLabels),
        MasteryScale(labels: defaultLabels),
        MasteryScale(labels: fourStepLabels),
    ]

    /// 段数。core に渡す `steps`。
    var steps: UInt8 { UInt8(clamping: max(1, min(labels.count, 8))) }

    /// 保存値がプリセットの語彙と完全に同じなら、そのプリセットの表示用の文言 (下から順)。
    /// 利用者が 1 つでも書き換えたラベルは nil (そのまま出す)。
    ///
    /// LocalizedStringResource は作った時点の言語で固まるので、static let に置かず毎回作る。
    private static func presetDisplayKeys(for labels: [String]) -> [LocalizedStringResource]? {
        if labels == twoStepLabels {
            return [L10n.Mastery.presetSteps2Level1, L10n.Mastery.presetSteps2Level2]
        }
        if labels == defaultLabels {
            return [L10n.Mastery.presetSteps3Level1, L10n.Mastery.presetSteps3Level2,
                    L10n.Mastery.presetSteps3Level3]
        }
        if labels == fourStepLabels {
            return [L10n.Mastery.presetSteps4Level1, L10n.Mastery.presetSteps4Level2,
                    L10n.Mastery.presetSteps4Level3, L10n.Mastery.presetSteps4Level4]
        }
        return nil
    }

    /// 表示するラベル (下から順)。編集していないプリセットは表示言語の訳、それ以外は保存値のまま。
    /// ja では常に `labels` と同じ。
    var displayLabels: [String] {
        guard let keys = Self.presetDisplayKeys(for: labels) else { return labels }
        return keys.map { String(localized: $0) }
    }

    /// 表示中のラベル (設定画面の入力) から保存する段階を作る。
    /// 訳したプリセットのままなら、そのプリセットの語彙 (ja) で保存する (保存値を言語で変えない)。
    static func storing(displayLabels: [String]) -> MasteryScale {
        presets.first { $0.displayLabels == displayLabels } ?? MasteryScale(labels: displayLabels)
    }

    /// 表示名。`0` は未設定。
    func label(_ level: UInt8) -> String {
        guard level > 0 else { return String(localized: L10n.Mastery.levelUnset) }
        let i = Int(level) - 1
        guard i < labels.count else { return "LV.\(level)" }
        if let keys = Self.presetDisplayKeys(for: labels) { return String(localized: keys[i]) }
        return labels[i]
    }

    /// 一覧のチップに出す短い名前。長いラベルは頭から詰める。
    func shortLabel(_ level: UInt8) -> String {
        let full = label(level)
        return full.count <= 6 ? full : String(full.prefix(5)) + "…"
    }

    /// スワイプで出るボタンのラベル。
    ///
    /// swipe actions のボタンは**中身の幅の合計が画面に収まらないと端が見切れる**。
    /// 「…」を足すとその 1 文字ぶん更に広がるので、ここでは足さずに素で切る。
    /// 4 文字あれば既定の 4 段 (1回聞いた / 耳に馴染んだ / だいたい覚えた / 覚えた) が
    /// iPhone の幅に収まる。
    func swipeLabel(_ level: UInt8) -> String {
        let full = label(level)
        return full.count <= 4 ? full : String(full.prefix(4))
    }
}

// MARK: - 段の色 (単一色相の濃度ランプ)

/// ヒートマップに並べる以上、段ごとに色相を変えない。
/// 色相を変えると「濃い＝進んでいる」がマスの列で読めなくなる。
/// システム accent は塗らない (DS 原則: 色はエンティティ側から来る) ので、
/// 習熟度専用の 1 色を濃度で割る。
enum MasteryPalette {
    /// 未設定は面を持たず、点線の枠だけ。
    static let empty = Color.clear

    private static let rampLight = [0xD7E5F4, 0x9DC4E6, 0x5392CE, 0x1C5FA3]
    private static let rampDark  = [0x17304A, 0x27547F, 0x4287C6, 0x7FBAF0]

    /// `level` (1..=steps) の面の色。段数が 4 未満なら上寄りを使う
    /// (2 段のときに薄い 2 色だけになって「進んだ感」が出ないのを避ける)。
    static func fill(level: UInt8, steps: UInt8) -> Color {
        guard level > 0 else { return empty }
        let idx = rampIndex(level: level, steps: steps)
        return Color(UIColor { tc in
            let hex = tc.userInterfaceStyle == .dark ? rampDark[idx] : rampLight[idx]
            return UIColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                           green: CGFloat((hex >> 8) & 0xFF) / 255,
                           blue: CGFloat(hex & 0xFF) / 255, alpha: 1)
        })
    }

    /// その面の上に乗せる文字色。薄い段は濃い文字、濃い段は抜き文字。
    static func ink(level: UInt8, steps: UInt8) -> Color {
        guard level > 0 else { return DS.ink3 }
        let idx = rampIndex(level: level, steps: steps)
        return Color(UIColor { tc in
            let dark = tc.userInterfaceStyle == .dark
            // ライトは上位 2 段が濃いので白抜き、ダークは上位が明るいので黒文字。
            if dark { return idx >= 2 ? UIColor(red: 0.02, green: 0.07, blue: 0.12, alpha: 1) : .white }
            return idx >= 2 ? .white : UIColor(red: 0.07, green: 0.16, blue: 0.24, alpha: 1)
        })
    }

    private static func rampIndex(level: UInt8, steps: UInt8) -> Int {
        let s = max(1, Int(steps))
        let l = max(1, min(Int(level), s))
        // 段数が 4 でないときは 4 段のランプ上へ等間隔に写す (最上段は必ず一番濃い)。
        let idx = Int((Double(l - 1) / Double(max(s - 1, 1))) * 3.0 + 0.5)
        return min(max(idx, 0), 3)
    }
}
