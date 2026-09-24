import SwiftUI

/// ユニットにタグを付ける picker。IdolTagPicker と同じ見た目・操作感だが、タグは曲/アイドルとは
/// 別プール (unit_tag_master) から検索・作成する。付与したらそのまま閉じる。
struct UnitTagPicker: View {
    @Environment(\.dismiss) private var dismiss
    /// タグ色なしチップの背景 .accentColor (= 推しカラー tint) を実色解決するために保持。
    let unit: Unit
    var onApplied: (() -> Void)?

    @State private var vm: UnitTagPickerViewModel
    @State private var searchText = ""
    @State private var selectedTagIds: Set<String> = []
    /// 選択された CommunityTag の実体辞書。検索で tags が差し替わっても選択済みを保持する。
    @State private var selectedTagsById: [String: CommunityTag] = [:]
    @State private var showCreateSheet = false

    init(unit: Unit, onApplied: (() -> Void)? = nil) {
        self.unit = unit
        self.onApplied = onApplied
        _vm = State(initialValue: UnitTagPickerViewModel(unitId: unit.id))
    }

    private var trimmedSearch: String { searchText.trimmingCharacters(in: .whitespaces) }
    private var exactMatchExists: Bool { vm.tags.contains { $0.name == trimmedSearch } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.sp6) {
                    // 対象ユニットを明示する見出し行。
                    ImasListContainer {
                        HStack(spacing: DS.sp3) {
                            UnitAvatarView(unit: unit, size: 40)
                            Text(unit.displayName).font(.imasSubhead.weight(.semibold)).foregroundStyle(DS.ink)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, DS.sp4).padding(.vertical, 10)
                    }

                    // 検索語をそのまま新規タグ名にできる導線。
                    if !trimmedSearch.isEmpty && !exactMatchExists {
                        Button {
                            AppAnalytics.tap("unit_tag_picker.create_from_search")
                            showCreateSheet = true
                        } label: {
                            HStack(spacing: DS.sp2) {
                                Image(systemName: "plus.circle.fill").font(.imasScaled( 18, weight: .semibold))
                                Text(L10n.Tags.pickerCreateFromSearch(query: trimmedSearch)).font(.imasSubhead.weight(.semibold))
                                Spacer()
                            }
                            .foregroundStyle(DS.sys)
                            .padding(.horizontal, DS.sp4).padding(.vertical, 13)
                            .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: DS.sp3) {
                        Text(trimmedSearch.isEmpty ? L10n.Tags.pickerSectionPopular : L10n.Tags.pickerSectionCandidates)
                            .font(.imasFootnote.weight(.semibold))
                            .foregroundStyle(DS.ink3)
                        if vm.isLoading {
                            ImasInlineLoading()
                        } else if vm.tags.isEmpty {
                            Text(L10n.Tags.pickerEmpty).font(.imasFootnote).foregroundStyle(DS.ink3)
                        } else {
                            FlowLayout(spacing: DS.sp2) {
                                ForEach(vm.tags) { tag in tagChip(tag) }
                            }
                        }
                    }

                    Button {
                        AppAnalytics.tap("unit_tag_picker.create_full")
                        showCreateSheet = true
                    } label: {
                        HStack(spacing: DS.sp2) {
                            Image(systemName: "plus").font(.imasScaled( 14, weight: .semibold))
                            Text(L10n.Tags.pickerCreateFull).font(.imasFootnote.weight(.semibold))
                        }
                        .foregroundStyle(DS.ink2)
                    }
                    .buttonStyle(.plain)
                }
                .padding(DS.sp5)
            }
            .background(DS.bg)
            .navigationTitle(L10n.Tags.pickerTitle)
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen("unit_tag_picker")
            .searchable(text: $searchText, prompt: Text(L10n.Tags.pickerSearchPrompt))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Tags.actionCancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Tags.pickerActionAdd) {
                        guard !vm.isApplying else { return }
                        AppAnalytics.tap("unit_tag_picker.apply")
                        Task {
                            if await vm.applyTags(selectedTagIds) {
                                onApplied?()
                                dismiss()
                            }
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(selectedTagIds.isEmpty || vm.isApplying)
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                TagCreateSheet(domain: .unit, onCreated: { newTag in
                    vm.insertCreated(newTag)
                    selectedTagIds.insert(newTag.id)
                    selectedTagsById[newTag.id] = newTag
                }, initialName: trimmedSearch)
            }
            .alert(L10n.Tags.pickerErrorApplyFailed, isPresented: Binding(get: { vm.applyError != nil }, set: { if !$0 { vm.applyError = nil } })) {
                Button(L10n.Tags.actionOk) { vm.applyError = nil }
            } message: {
                Text(vm.applyError ?? "")
            }
            .task { await vm.loadData() }
            .onChange(of: searchText) { _, new in vm.scheduleSearch(new) }
        }
    }

    @ViewBuilder
    private func tagChip(_ tag: CommunityTag) -> some View {
        TagSelectChip(
            tag: tag,
            isApplied: vm.myTagIds.contains(tag.id),
            isSelected: selectedTagIds.contains(tag.id)
        ) {
            if selectedTagIds.contains(tag.id) {
                selectedTagIds.remove(tag.id)
                selectedTagsById.removeValue(forKey: tag.id)
            } else {
                selectedTagIds.insert(tag.id)
                selectedTagsById[tag.id] = tag
            }
        }
    }

}
