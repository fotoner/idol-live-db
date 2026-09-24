import SwiftUI

/// タグ画面の push 遷移先。値ベース push にして二重 push をスロットルで防ぐ。
enum TagRoute: Hashable {
    case detail(id: String, name: String)
}

struct TagListView: View {
    @State private var navPath = NavigationPath()
    @State private var vm = TagListViewModel()
    @State private var selectedCategory = ""
    @State private var selectedSort = "popular"
    @State private var showCreateSheet = false
    @State private var showFilterSheet = false
    /// 一覧の名前絞り込み。タグは全件 (limit 1000) を取得済みなのでクライアント側で絞る。
    @State private var nameFilter = ""

    /// 絞り込みシート (TagFilterSheet) は解決済みの String を受けるので、描くたびに今の言語で引く
    /// (let に置くと作った時点の言語で固まる)。
    private var categories: [(value: String, label: String)] {
        [
            ("", String(localized: L10n.Tags.listCategoryAll)),
            ("mood", String(localized: L10n.Tags.listCategoryMood)),
            ("scene", String(localized: L10n.Tags.listCategoryScene)),
            ("special", String(localized: L10n.Tags.listCategorySpecial)),
            ("free", String(localized: L10n.Tags.listCategoryFree)),
        ]
    }
    private var sortOptions: [(value: String, label: String)] {
        [
            ("popular", String(localized: L10n.Tags.listSortPopular)),
            ("recent", String(localized: L10n.Tags.listSortRecent)),
            ("name", String(localized: L10n.Tags.listSortName)),
        ]
    }

    private var activeFilterCount: Int {
        (selectedCategory.isEmpty ? 0 : 1) + (nameFilter.isEmpty ? 0 : 1)
    }

    /// 名前絞り込み用の索引。`vm.tags` が入れ替わった時だけ組み直す。
    /// 照合はコア (`domain/text_search_index.rs`) に一任するので、他の一覧と同じく
    /// ひらがな↔カタカナを畳む (タグ名はユーザーが打つ自由文字列なので揺れが大きい)。
    @State private var catalog: TextSearchCatalog?

    /// 名前絞り込み適用後のタグ。名前・説明の部分一致で絞る。
    private var filteredTags: [CommunityTag] {
        let trimmed = nameFilter.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return vm.tags }
        // 索引が無い間は絞り込まない (黙って 0 件にする方が悪い)。
        guard let catalog else { return vm.tags }
        return catalog.filter(vm.tags, needle: trimmed)
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                Section {
                    NameFilterField(prompt: String(localized: L10n.Tags.listNameFilterPrompt), text: $nameFilter)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 8, trailing: 16))
                }
                .listRowBackground(Color.clear)

                if vm.isLoading {
                    ImasInlineLoading()
                        .listRowBackground(Color.clear)
                } else if filteredTags.isEmpty {
                    ImasEmptyState(
                        systemImage: nameFilter.isEmpty ? "tag" : "line.3.horizontal.decrease",
                        title: String(localized: nameFilter.isEmpty ? L10n.Tags.listEmptyTitle : L10n.Tags.listFilterEmptyTitle),
                        message: nameFilter.isEmpty ? nil : String(localized: L10n.Tags.listFilterEmptyMessage(query: nameFilter))
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(Array(filteredTags.enumerated()), id: \.element.id) { idx, tag in
                        NavigationLink(value: TagRoute.detail(id: tag.id, name: tag.name)) {
                            // 人気ソート時は順位を出して「人気ランキング」として見せる。
                            TagRowView(tag: tag, rank: selectedSort == "popular" ? idx + 1 : nil)
                        }
                        .listRowBackground(DS.surface)
                        .listRowSeparatorTint(DS.sep)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(DS.bg)
            .navigationTitle(L10n.Tags.listTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: DS.sp3) {
                        FilterBarButton(activeCount: activeFilterCount) {
                            showFilterSheet = true
                        }

                        // 未サインイン時は押しても汎用エラーになりログイン導線も出ないため、
                        // PollListView と同様にボタン自体を出し分ける。
                        if AuthService.shared.isSignedIn {
                            Button {
                                AppAnalytics.tap("tag_list.create")
                                showCreateSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Picker(L10n.Tags.listSortLabel, selection: $selectedSort) {
                        ForEach(sortOptions, id: \.value) { opt in
                            Text(opt.label).tag(opt.value)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationDestination(for: TagRoute.self) { route in
                switch route {
                case let .detail(id, name):
                    TagDetailView(tagId: id, tagName: name)
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                TagCreateSheet(onCreated: { newTag in
                    vm.insertCreated(newTag)
                })
            }
            .sheet(isPresented: $showFilterSheet) {
                TagFilterSheet(
                    categories: categories,
                    sortOptions: sortOptions,
                    selectedCategory: $selectedCategory,
                    selectedSort: $selectedSort
                )
                .presentationDetents([.medium, .large])
                .onDisappear { vm.scheduleLoad(category: selectedCategory, sort: selectedSort, debounce: false) }
            }
            .task { await vm.load(category: selectedCategory, sort: selectedSort) }
            // タグは category / sort を変えるたびに読み直す。索引もそれに追随させる
            // (id 列を鍵にするので、件数が同じで中身だけ入れ替わっても組み直る)。
            .onChange(of: vm.tags.map(\.id), initial: true) { _, _ in
                catalog = TextSearchCatalog(fieldsPerItem: vm.tags.map { [$0.name, $0.description] })
            }
            .onChange(of: selectedCategory) { _, _ in vm.scheduleLoad(category: selectedCategory, sort: selectedSort, debounce: false) }
            .onChange(of: selectedSort) { _, _ in vm.scheduleLoad(category: selectedCategory, sort: selectedSort, debounce: false) }
            .trackScreen("tag_list")
        }
    }
}

struct TagRowView: View {
    let tag: CommunityTag
    /// 人気ランキングでの順位 (1始まり)。nil の時は順位を出さない。
    var rank: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: DS.sp2) {
            HStack(spacing: 6) {
                if let rank {
                    TagRankBadge(rank: rank)
                }
                if let hexColor = tag.color {
                    Circle()
                        .fill(Color(hexColor: hexColor))
                        .frame(width: 8, height: 8)
                        .accessibilityHidden(true)
                }
                Text(tag.name)
                    .font(.imasSubhead.weight(.semibold))
                    .accessibilityLabel(L10n.Tags.listRowA11y(name: tag.name))
                if let cat = tag.category {
                    Text(cat.rowLabel)
                        .font(.imasCaption2)
                        .foregroundStyle(DS.ink2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, DS.sp1)
                        .background(DS.fill)
                        .clipShape(Capsule())
                }
                Spacer()
                if let uses = tag.totalUses, uses > 0 {
                    Text(L10n.Tags.listRowSongs(count: uses))
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                }
            }
            if let desc = tag.description, !desc.isEmpty {
                Text(desc.prefix(40))
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, DS.sp1)
    }
}

private extension TagCategory {
    /// 一覧の行のバッジに出す語。保存値 (rawValue) は変えず、表示だけカタログを引く。
    /// ja は今まで出していた rawValue (英字) のまま (list.row.category.* の note を参照)。
    var rowLabel: LocalizedStringResource {
        switch self {
        case .mood: L10n.Tags.listRowCategoryMood
        case .scene: L10n.Tags.listRowCategoryScene
        case .special: L10n.Tags.listRowCategorySpecial
        case .free: L10n.Tags.listRowCategoryFree
        }
    }
}

// MARK: - Rank Badge

/// 人気ランキングの順位バッジ。上位3つはメダル色 (金/銀/銅)、それ以降はグレー。
/// タグ一覧・楽曲一覧のタグ絞り込みで共用する。
struct TagRankBadge: View {
    let rank: Int

    var body: some View {
        Text("\(rank)")
            .font(.imasCaption.bold().monospacedDigit())
            .foregroundStyle(textColor)
            .frame(minWidth: 22)
            .padding(.vertical, DS.sp1)
            .padding(.horizontal, 5)
            .background(bgColor, in: Capsule())
            .accessibilityLabel(L10n.Tags.rankBadgeA11y(rank: rank))
    }

    private var medalColor: Color? {
        switch rank {
        case 1: return Color(red: 0.91, green: 0.66, blue: 0.0)   // 金
        case 2: return Color(red: 0.66, green: 0.69, blue: 0.72)  // 銀
        case 3: return Color(red: 0.80, green: 0.50, blue: 0.20)  // 銅
        default: return nil
        }
    }

    private var textColor: Color { medalColor ?? DS.ink2 }
    private var bgColor: Color { (medalColor ?? DS.ink3).opacity(0.16) }
}
