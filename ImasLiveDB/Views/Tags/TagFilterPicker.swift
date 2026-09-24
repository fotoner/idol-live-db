import SwiftUI

/// 曲一覧をコミュニティタグで絞り込むためのタグ**複数選択**シート。
/// 「完了」で onDone(選択タグ配列) を呼ぶ。複数選択時は AND (全タグを含む曲) で絞る想定。
struct TagFilterPicker: View {
    @Environment(\.dismiss) private var dismiss
    let onDone: ([CommunityTag]) -> Void

    @State private var tags: [CommunityTag] = []
    /// 選択中タグ。検索で一覧から消えても保持するため id ではなくオブジェクトで持つ。
    @State private var selected: [CommunityTag]
    @State private var query = ""
    @State private var isLoading = true

    init(initialSelection: [CommunityTag], onDone: @escaping ([CommunityTag]) -> Void) {
        self.onDone = onDone
        _selected = State(initialValue: initialSelection)
    }

    private func isSelected(_ tag: CommunityTag) -> Bool {
        selected.contains { $0.id == tag.id }
    }
    private func toggle(_ tag: CommunityTag) {
        if let idx = selected.firstIndex(where: { $0.id == tag.id }) {
            selected.remove(at: idx)
        } else {
            selected.append(tag)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if !selected.isEmpty {
                    Section {
                        Text(selected.map(\.name).joined(separator: " ＋ "))
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink2)
                    } header: {
                        Text(L10n.Tags.filterSelectedHeader(count: selected.count))
                    }
                    .listRowBackground(DS.surface)
                    .listRowSeparatorTint(DS.sep)
                }
                Section {
                    if isLoading {
                        ImasInlineLoading()
                            .listRowBackground(Color.clear)
                    } else if tags.isEmpty {
                        Text(L10n.Tags.filterEmpty).foregroundStyle(DS.ink2)
                            .listRowBackground(DS.surface)
                    } else {
                        ForEach(Array(tags.enumerated()), id: \.element.id) { idx, tag in
                            Button {
                                AppAnalytics.tap("tag_filter.toggle_tag")
                                toggle(tag)
                            } label: {
                                HStack(spacing: DS.sp3) {
                                    // 検索していない時は人気順そのものなので順位バッジを出す。
                                    if query.isEmpty {
                                        TagRankBadge(rank: idx + 1)
                                    }
                                    if let color = tag.color {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color(hexColor: color))
                                            .frame(width: 14, height: 14)
                                    }
                                    Text(tag.name).foregroundStyle(DS.ink)
                                    Spacer()
                                    if let uses = tag.totalUses, uses > 0 {
                                        Text(L10n.Tags.filterRowSongs(count: uses)).font(.imasCaption).foregroundStyle(DS.ink2)
                                    }
                                    if isSelected(tag) {
                                        ImasSelectionMark(isSelected: true, color: tag.color.map { Color(hexColor: $0) })
                                    }
                                }
                            }
                            .listRowBackground(DS.surface)
                            .listRowSeparatorTint(DS.sep)
                        }
                    }
                } header: {
                    Text(query.isEmpty ? L10n.Tags.filterSectionPopular : L10n.Tags.filterSectionResults)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(DS.bg)
            .searchable(text: $query, prompt: Text(L10n.Tags.filterSearchPrompt))
            .navigationTitle(L10n.Tags.filterTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Tags.actionCancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.Tags.filterActionDone) {
                        AppAnalytics.tap("tag_filter.done")
                        onDone(selected)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .task(id: query) { await load() }
            .trackScreen("tag_filter")
        }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        tags = (try? await AppContainer.shared.communityTagReading.tags(search: query, category: "", sort: "popular", limit: 100, offset: 0)) ?? []
    }
}
