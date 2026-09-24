import SwiftUI

/// 習熟度の段階を編集する。段数とラベルを決める面。
///
/// **保存されているのは序数だけ**なので、ラベルを書き換えても記録には触らない。
/// 段を減らしたときだけ、その段にいた曲が 1 つ下へ寄る (規則は core の
/// `remapMasteryLevel`)。消さずに寄せるので、増やし直せば戻る訳ではないが記録は残る。
///
/// 削除は**最上段だけ**にしている。真ん中を抜くと序数の意味がずれて、寄せ先の規則
/// (上限で丸める) と噛み合わなくなる。規則を増やすより操作を狭める方を選んだ。
///
/// 編集欄は**表示するラベル** (`displayLabels`) を持つ。編集していないプリセットは表示言語の訳で
/// 並び、そのまま反映すればプリセットの語彙 (ja) で保存する (`MasteryScale.storing`)。
struct MasteryScaleSettingsView: View {
    private var marks: UserMarkService { UserMarkService.shared }

    @State private var labels: [String] = []
    @State private var loaded = false
    @FocusState private var focused: Int?

    private static let maxSteps = 8

    var body: some View {
        List {
            presetSection
            stageSection
            if let warning = shrinkWarning {
                Section {
                    Label(warning, systemImage: "exclamationmark.triangle")
                        .font(.imasFootnote)
                        .foregroundStyle(DS.warning)
                }
                .listRowBackground(DS.surface)
            }
            applySection
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(DS.bg.ignoresSafeArea())
        .navigationTitle(L10n.Mastery.settingsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !loaded else { return }
            labels = marks.scale.displayLabels
            loaded = true
        }
        .trackScreen("mastery_scale_settings")
    }

    // MARK: - プリセット

    private var presetSection: some View {
        Section {
            HStack(spacing: DS.sp3) {
                ForEach(MasteryScale.presets, id: \.labels) { preset in
                    ImasFilterChip(text: String(localized: L10n.Mastery.presetName(steps: preset.labels.count)),
                                   isSelected: labels == preset.displayLabels) {
                        labels = preset.displayLabels
                    }
                }
                Spacer()
            }
        } header: {
            Text(L10n.Mastery.settingsPresetHeader).font(.imasCaption).foregroundStyle(DS.ink2)
        } footer: {
            Text(L10n.Mastery.settingsPresetFooter)
                .font(.imasCaption2).foregroundStyle(DS.ink3)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - 段

    private var stageSection: some View {
        Section {
            ForEach(labels.indices, id: \.self) { i in
                HStack(spacing: DS.sp4) {
                    MasteryCell(level: UInt8(i + 1),
                                scale: MasteryScale(labels: labels), size: 16)
                    // LocalizedStringResource を受ける TextField(_:text:) は iOS 26 からなので、prompt: 付きの版 (iOS 16) を使う
                    TextField(L10n.Mastery.settingsStagePlaceholder, text: Binding(
                        get: { i < labels.count ? labels[i] : "" },
                        set: { if i < labels.count { labels[i] = $0 } }
                    ), prompt: nil)
                    .font(.imasBody)
                    .focused($focused, equals: i)
                    .submitLabel(.done)
                    Text("\(count(at: i))")
                        .font(.imasDisplay(11)).foregroundStyle(DS.ink2)
                    if i == labels.count - 1 && labels.count > 1 {
                        Button {
                            labels.removeLast()
                        } label: {
                            Image(systemName: "minus.circle.fill").foregroundStyle(DS.danger)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(L10n.Mastery.settingsStageRemoveA11y)
                    }
                }
            }
            if labels.count < Self.maxSteps {
                Button {
                    labels.append("")
                    focused = labels.count - 1
                } label: {
                    Label(L10n.Mastery.settingsStageAdd, systemImage: "plus.circle").font(.imasSubhead)
                }
            }
        } header: {
            Text(L10n.Mastery.settingsStageHeader).font(.imasCaption).foregroundStyle(DS.ink2)
        } footer: {
            Text(L10n.Mastery.settingsStageFooter)
                .font(.imasCaption2).foregroundStyle(DS.ink3)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    /// いまその段にある曲数 (保存済みの段数で数えた値)。
    private func count(at index: Int) -> Int {
        let counts = marks.masteryCounts()
        return index < counts.count ? counts[index] : 0
    }

    // MARK: - 反映

    private var trimmed: [String] {
        labels.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    private var isValid: Bool {
        let t = trimmed
        return !t.isEmpty && t.allSatisfy { !$0.isEmpty } && Set(t).count == t.count
    }

    /// 保存済みと比べるのも表示するラベルどうし (訳したプリセットを開いただけで「変更あり」にしない)。
    private var isDirty: Bool { trimmed != marks.scale.displayLabels }

    /// 段を減らすときに何曲動くか。動かないなら nil。
    private var shrinkWarning: LocalizedStringResource? {
        let newSteps = UInt8(clamping: max(1, min(trimmed.count, Self.maxSteps)))
        let oldSteps = marks.scale.steps
        guard newSteps < oldSteps else { return nil }
        let counts = marks.masteryCounts()
        let moving = counts.enumerated()
            .filter { $0.offset + 1 > Int(newSteps) }
            .reduce(0) { $0 + $1.element }
        guard moving > 0 else { return nil }
        let dest = trimmed.indices.contains(Int(newSteps) - 1)
            ? trimmed[Int(newSteps) - 1] : String(localized: L10n.Mastery.settingsShrinkTopStage)
        return L10n.Mastery.settingsShrinkWarning(count: moving, stage: dest)
    }

    private var applySection: some View {
        Section {
            Button {
                apply()
            } label: {
                Text(L10n.Mastery.settingsActionApply).font(.imasSubhead.weight(.semibold))
            }
            .disabled(!isValid || !isDirty)
            if isDirty {
                Button(L10n.Mastery.settingsActionRevert, role: .cancel) { labels = marks.scale.displayLabels }
            }
        } footer: {
            if !isValid {
                Text(L10n.Mastery.settingsInvalid)
                    .font(.imasCaption2).foregroundStyle(DS.danger)
            }
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    private func apply() {
        guard isValid else { return }
        do {
            try marks.setScale(MasteryScale.storing(displayLabels: trimmed))
        } catch {
            LocalWriteFailure.report(error, action: String(localized: L10n.Mastery.writeActionScaleSave))
        }
        labels = marks.scale.displayLabels
    }
}
