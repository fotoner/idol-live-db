import SwiftUI

struct TagEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    let tag: CommunityTag
    var domain: TagDomain = .song

    @State private var description: String
    @State private var selectedCategory: String
    @State private var selectedColor: String
    @State private var isSaving = false
    /// 画面に出す失敗の文。サーバ・通信層の説明はデータ (.verbatim)、ほかはカタログの文言。
    @State private var errorMessage: DisplayText?

    init(tag: CommunityTag, domain: TagDomain = .song) {
        self.tag = tag
        self.domain = domain
        _description = State(initialValue: tag.description ?? "")
        _selectedCategory = State(initialValue: tag.category?.rawValue ?? "")
        _selectedColor = State(initialValue: tag.color?.rawValue ?? "")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.sp6) {
                    VStack(alignment: .leading, spacing: DS.sp3) {
                        ImasSectionHeader(title: .key(L10n.Tags.editDescriptionHeader), tight: true)
                        ImasListContainer {
                            TextField(L10n.Tags.editDescriptionPlaceholder, text: $description, axis: .vertical)
                                .font(.imasSubhead)
                                .foregroundStyle(DS.ink)
                                .lineLimit(3...6)
                                .padding(.horizontal, DS.sp4)
                                .padding(.vertical, DS.sp3)
                                .onChange(of: description) { _, new in
                                    let clamped = InputLimits.clamp(.tagDescription, new)
                                    if clamped != new { description = clamped }
                                }
                        }
                    }

                    VStack(alignment: .leading, spacing: DS.sp3) {
                        ImasSectionHeader(title: .key(L10n.Tags.editCategoryHeader), tight: true)
                        FlowLayout(spacing: DS.sp2) {
                            categoryChip(value: "", label: Vocab.table.tagCategoryNoneLabel)
                            ForEach(TagCategoryOptions.options(for: domain), id: \.value) { cat in
                                categoryChip(value: cat.value, label: cat.label)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: DS.sp3) {
                        ImasSectionHeader(title: .key(L10n.Tags.editColorHeader), tight: true)
                        ImasListContainer {
                            TagColorPicker(selectedHex: $selectedColor)
                                .padding(.horizontal, DS.sp4)
                                .padding(.vertical, DS.sp3)
                        }
                    }

                    if let errorMessage {
                        Label {
                            Text(display: errorMessage)
                        } icon: {
                            Image(systemName: "exclamationmark.triangle.fill")
                        }
                            .font(.imasFootnote)
                            .foregroundStyle(DS.danger)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, DS.sp5)
                .padding(.top, DS.sp4)
                .padding(.bottom, DS.sp7)
            }
            .background(DS.bg.ignoresSafeArea())
            .scrollContentBackground(.hidden)
            .navigationTitle(L10n.Tags.editTitle(name: tag.name))
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen("tag_edit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Tags.actionCancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Tags.editActionSave) {
                        AppAnalytics.tap("tag_edit.save")
                        Task { await save() }
                    }
                    .disabled(isSaving)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func categoryChip(value: String, label: String) -> some View {
        ImasFilterChip(text: label, isSelected: selectedCategory == value) {
            selectedCategory = value
        }
    }

    private func save() async {
        isSaving = true
        defer { isSaving = false }
        do {
            let desc = description.isEmpty ? nil : description
            let cat = selectedCategory.isEmpty ? nil : selectedCategory
            let color = selectedColor.isEmpty ? nil : selectedColor
            let writing = AppContainer.shared.communityTagWriting
            switch domain {
            case .song:
                _ = try await writing.updateTag(id: tag.id, description: desc, category: cat, color: color)
            case .idol:
                _ = try await writing.updateIdolTag(id: tag.id, description: desc, category: cat, color: color)
            case .unit:
                _ = try await writing.updateUnitTag(id: tag.id, description: desc, category: cat, color: color)
            }
            dismiss()
        } catch let error as CommunityAPIError {
            errorMessage = error.errorDescription.map(DisplayText.verbatim) ?? .key(L10n.Tags.editErrorFailed)
        } catch {
            errorMessage = .key(L10n.Tags.editErrorFailedDetail(detail: error.localizedDescription))
        }
    }
}
