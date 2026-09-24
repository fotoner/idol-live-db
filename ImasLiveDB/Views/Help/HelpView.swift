import SwiftUI

// MARK: - Model

/// ヘルプの 1 機能カテゴリ。
struct HelpSection: Identifiable {
    let icon: String
    /// カテゴリ識別用の装飾テーマ seed (hex)。`ImasTheme.derive(seed:scheme:)` に渡して
    /// ライト/ダーク双方で一貫したトークンを導出する (生の SwiftUI システムカラーは使わない)。
    let tint: String
    let title: LocalizedStringResource
    let summary: LocalizedStringResource
    let body: [HelpItem]

    /// 文言のキー (help.category.<カテゴリ>.title)。表示言語に左右されず、`HelpCatalog.sections` を
    /// 作り直しても変わらない (UUID だと body を評価するたびに別の行になる)。
    var id: String { title.key }
}

struct HelpItem: Identifiable {
    let label: LocalizedStringResource
    let detail: LocalizedStringResource

    /// 文言のキー (help.category.<カテゴリ>.<項目>.label)。
    var id: String { label.key }
}

// MARK: - Data

/// 文面は i18n/catalog/help.json (kind: content)。Android の HelpScreen.kt と同じ項目は同じキーを引き、
/// 出来ることが OS で違う項目だけ iOS 用のキー (Android 側は *_android や別の項目) を使う。
enum HelpCatalog {
    /// 文言はロケールを抱えるので static let にしない (L10n.swift の注意と同じ)。
    static var sections: [HelpSection] {
        [
            HelpSection(
                icon: "music.mic",
                tint: "#FF2D55",
                title: L10n.Help.categoryEventsTitle,
                summary: L10n.Help.categoryEventsSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryEventsYearListLabel,
                             detail: L10n.Help.categoryEventsYearListDetail),
                    HelpItem(label: L10n.Help.categoryEventsBrandFilterLabel,
                             detail: L10n.Help.categoryEventsBrandFilterDetail),
                    HelpItem(label: L10n.Help.categoryEventsKindFilterLabel,
                             detail: L10n.Help.categoryEventsKindFilterDetail),
                    HelpItem(label: L10n.Help.categoryEventsEventDetailLabel,
                             detail: L10n.Help.categoryEventsEventDetailDetail),
                    HelpItem(label: L10n.Help.categoryEventsAttendedLabel,
                             detail: L10n.Help.categoryEventsAttendedDetail),
                ]
            ),
            HelpSection(
                icon: "music.note.list",
                tint: "#5856D6",
                title: L10n.Help.categorySongsTitle,
                summary: L10n.Help.categorySongsSummary,
                body: [
                    HelpItem(label: L10n.Help.categorySongsViewModesLabel,
                             detail: L10n.Help.categorySongsViewModesDetail),
                    HelpItem(label: L10n.Help.categorySongsAppleMusicLabel,
                             detail: L10n.Help.categorySongsAppleMusicDetail),
                    HelpItem(label: L10n.Help.categorySongsHistoryLabel,
                             detail: L10n.Help.categorySongsHistoryDetail),
                    HelpItem(label: L10n.Help.categorySongsOriginalMembersLabel,
                             detail: L10n.Help.categorySongsOriginalMembersDetail),
                    HelpItem(label: L10n.Help.categorySongsCollectFilterLabel,
                             detail: L10n.Help.categorySongsCollectFilterDetail),
                ]
            ),
            HelpSection(
                icon: "person.3.fill",
                tint: "#FF9500",
                title: L10n.Help.categoryIdolsTitle,
                summary: L10n.Help.categoryIdolsSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryIdolsLayoutLabel,
                             detail: L10n.Help.categoryIdolsLayoutDetail),
                    HelpItem(label: L10n.Help.categoryIdolsCvNamesLabel,
                             detail: L10n.Help.categoryIdolsCvNamesDetail),
                    HelpItem(label: L10n.Help.categoryIdolsAttributesLabel,
                             detail: L10n.Help.categoryIdolsAttributesDetail),
                    HelpItem(label: L10n.Help.categoryIdolsIdolDetailLabel,
                             detail: L10n.Help.categoryIdolsIdolDetailDetail),
                    HelpItem(label: L10n.Help.categoryIdolsAliasesLabel,
                             detail: L10n.Help.categoryIdolsAliasesDetail),
                ]
            ),
            HelpSection(
                icon: "bookmark.fill",
                tint: "#FF3B30",
                title: L10n.Help.categoryMarksTitle,
                summary: L10n.Help.categoryMarksSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryMarksOshiLabel,
                             detail: L10n.Help.categoryMarksOshiDetail),
                    HelpItem(label: L10n.Help.categoryMarksCollectedLabel,
                             detail: L10n.Help.categoryMarksCollectedDetail),
                    HelpItem(label: L10n.Help.categoryMarksAttendedLabel,
                             detail: L10n.Help.categoryMarksAttendedDetail),
                    HelpItem(label: L10n.Help.categoryMarksLocalLabel,
                             detail: L10n.Help.categoryMarksLocalDetail),
                ]
            ),
            HelpSection(
                icon: "square.and.pencil",
                tint: "#007AFF",
                title: L10n.Help.categoryEditTitle,
                summary: L10n.Help.categoryEditSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryEditDirectLabel,
                             detail: L10n.Help.categoryEditDirectDetail),
                    HelpItem(label: L10n.Help.categoryEditLoginLabel,
                             detail: L10n.Help.categoryEditLoginDetail),
                    HelpItem(label: L10n.Help.categoryEditHistoryLabel,
                             detail: L10n.Help.categoryEditHistoryDetail),
                    HelpItem(label: L10n.Help.categoryEditLikesLabel,
                             detail: L10n.Help.categoryEditLikesDetail),
                    HelpItem(label: L10n.Help.categoryEditRevertLabel,
                             detail: L10n.Help.categoryEditRevertDetail),
                    HelpItem(label: L10n.Help.categoryEditContributionLabel,
                             detail: L10n.Help.categoryEditContributionDetail),
                ]
            ),
            HelpSection(
                icon: "tag.fill",
                tint: "#30B0C7",
                title: L10n.Help.categoryTagsTitle,
                summary: L10n.Help.categoryTagsSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryTagsAttachLabel,
                             detail: L10n.Help.categoryTagsAttachDetail),
                    HelpItem(label: L10n.Help.categoryTagsBrowseLabel,
                             detail: L10n.Help.categoryTagsBrowseDetail),
                    HelpItem(label: L10n.Help.categoryTagsDescriptionLabel,
                             detail: L10n.Help.categoryTagsDescriptionDetail),
                ]
            ),
            HelpSection(
                icon: "circle.hexagongrid.fill",
                tint: "#AF52DE",
                title: L10n.Help.categoryPenlightTitle,
                summary: L10n.Help.categoryPenlightSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryPenlightVoteLabel,
                             detail: L10n.Help.categoryPenlightVoteDetail),
                    HelpItem(label: L10n.Help.categoryPenlightResultsLabel,
                             detail: L10n.Help.categoryPenlightResultsDetail),
                    HelpItem(label: L10n.Help.categoryPenlightOneVoteLabel,
                             detail: L10n.Help.categoryPenlightOneVoteDetail),
                ]
            ),
            HelpSection(
                icon: "music.note.house.fill",
                tint: "#FF2D55",
                title: L10n.Help.categoryIntroTitle,
                summary: L10n.Help.categoryIntroSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryIntroPreviewLabel,
                             detail: L10n.Help.categoryIntroPreviewDetail),
                    HelpItem(label: L10n.Help.categoryIntroDifficultyLabel,
                             detail: L10n.Help.categoryIntroDifficultyDetail),
                    HelpItem(label: L10n.Help.categoryIntroVoiceLabel,
                             detail: L10n.Help.categoryIntroVoiceDetail),
                    HelpItem(label: L10n.Help.categoryIntroBestLabel,
                             detail: L10n.Help.categoryIntroBestDetail),
                ]
            ),
            HelpSection(
                icon: "magnifyingglass",
                tint: "#8E8E93",
                title: L10n.Help.categorySearchTitle,
                summary: L10n.Help.categorySearchSummary,
                body: [
                    HelpItem(label: L10n.Help.categorySearchInTabLabel,
                             detail: L10n.Help.categorySearchInTabDetail),
                    HelpItem(label: L10n.Help.categorySearchGlobalLabel,
                             detail: L10n.Help.categorySearchGlobalDetail),
                    HelpItem(label: L10n.Help.categorySearchFallbackLabel,
                             detail: L10n.Help.categorySearchFallbackDetail),
                    HelpItem(label: L10n.Help.categorySearchAliasesLabel,
                             detail: L10n.Help.categorySearchAliasesDetail),
                ]
            ),
            HelpSection(
                icon: "calendar",
                tint: "#34C759",
                title: L10n.Help.categoryCalendarTitle,
                summary: L10n.Help.categoryCalendarSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryCalendarOpenLabel,
                             detail: L10n.Help.categoryCalendarOpenDetail),
                    HelpItem(label: L10n.Help.categoryCalendarColorsLabel,
                             detail: L10n.Help.categoryCalendarColorsDetail),
                ]
            ),
            HelpSection(
                icon: "photo.on.rectangle.angled",
                tint: "#00C7BE",
                title: L10n.Help.categoryImageImportTitle,
                summary: L10n.Help.categoryImageImportSummary,
                body: [
                    HelpItem(label: L10n.Help.categoryImageImportOpenLabel,
                             detail: L10n.Help.categoryImageImportOpenDetail),
                    HelpItem(label: L10n.Help.categoryImageImportTemplateLabel,
                             detail: L10n.Help.categoryImageImportTemplateDetail),
                    HelpItem(label: L10n.Help.categoryImageImportAliasesLabel,
                             detail: L10n.Help.categoryImageImportAliasesDetail),
                    HelpItem(label: L10n.Help.categoryImageImportResetLabel,
                             detail: L10n.Help.categoryImageImportResetDetail),
                ]
            ),
            HelpSection(
                icon: "icloud.fill",
                tint: "#32ADE6",
                title: L10n.Help.categorySyncTitle,
                summary: L10n.Help.categorySyncSummary,
                body: [
                    HelpItem(label: L10n.Help.categorySyncCloudkitLabel,
                             detail: L10n.Help.categorySyncCloudkitDetail),
                    HelpItem(label: L10n.Help.categorySyncLoginLabel,
                             detail: L10n.Help.categorySyncLoginDetail),
                    HelpItem(label: L10n.Help.categorySyncDeleteAccountLabel,
                             detail: L10n.Help.categorySyncDeleteAccountDetail),
                ]
            ),
        ]
    }
}

// MARK: - Top View

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: DS.sp3) {
                        Text(L10n.Help.topHeading)
                            .font(.imasTitle3)
                        Text(L10n.Help.topIntro)
                            .font(.imasSubhead)
                            .foregroundStyle(DS.ink2)
                    }
                    .padding(.vertical, DS.sp2)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                Section(L10n.Help.topFeaturedHeader) {
                    NavigationLink {
                        WidgetHowToView()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "person.crop.square.badge.camera")
                                .font(.imasTitle3)
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(
                                    LinearGradient(colors: [Color(red: 1, green: 0.3, blue: 0.55),
                                                            Color(red: 0.55, green: 0.35, blue: 0.95)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                                    in: RoundedRectangle(cornerRadius: 9))
                            VStack(alignment: .leading, spacing: DS.sp1) {
                                Text(L10n.Help.widgetHowtoTitle).font(.imasHeadline)
                                Text(L10n.Help.topWidgetHowtoSummary)
                                    .font(.imasCaption)
                                    .foregroundStyle(DS.ink2)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, DS.sp1)
                    }
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                Section(L10n.Help.topCategoriesHeader) {
                    ForEach(HelpCatalog.sections) { section in
                        let t = ImasTheme.derive(seed: section.tint, scheme: scheme)
                        NavigationLink {
                            HelpDetailView(section: section)
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: section.icon)
                                    .font(.imasTitle3)
                                    .foregroundStyle(t.onAccent)
                                    .frame(width: 36, height: 36)
                                    .background(t.accent.gradient, in: RoundedRectangle(cornerRadius: 9))
                                VStack(alignment: .leading, spacing: DS.sp1) {
                                    Text(section.title).font(.imasHeadline)
                                    Text(section.summary)
                                        .font(.imasCaption)
                                        .foregroundStyle(DS.ink2)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, DS.sp1)
                        }
                    }
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                Section {
                    Text(L10n.Help.topFooter)
                        .font(.imasFootnote)
                        .foregroundStyle(DS.ink2)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(DS.bg)
            .navigationTitle(L10n.Help.topTitle)
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen("help")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: { Text(L10n.Help.topActionClose) }
                }
            }
        }
    }
}

// MARK: - Detail View

private struct HelpDetailView: View {
    let section: HelpSection
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let t = ImasTheme.derive(seed: section.tint, scheme: scheme)
        List {
            Section {
                VStack(spacing: 14) {
                    Image(systemName: section.icon)
                        .font(.imasScaled( 36, weight: .semibold))
                        .foregroundStyle(t.onAccent)
                        .frame(width: 72, height: 72)
                        .background(t.accent.gradient, in: RoundedRectangle(cornerRadius: DS.rLG))
                    Text(section.title)
                        .font(.imasTitle2)
                    Text(section.summary)
                        .font(.imasSubhead)
                        .foregroundStyle(DS.ink2)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .listRowBackground(Color.clear)
            }

            Section(L10n.Help.detailFeaturesHeader) {
                ForEach(section.body) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: DS.sp3) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(t.accent)
                                .padding(.top, DS.sp1)
                            Text(item.label)
                                .font(.imasSubhead.bold())
                        }
                        Text(item.detail)
                            .font(.imasSubhead)
                            .foregroundStyle(DS.ink2)
                            .padding(.leading, 26)
                    }
                    .padding(.vertical, DS.sp2)
                }
            }
            .listRowBackground(DS.surface)
            .listRowSeparatorTint(DS.sep)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(DS.bg)
        .navigationTitle(section.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HelpView()
}
