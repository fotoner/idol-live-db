import os
import SwiftUI

// MARK: - Brand Filter Section (shared across filter sheets)

/// ブランドを丸アイコンの格子で選ぶ素のグリッド。 List/Form/ScrollView いずれでも置ける。
/// 「全て」セルの有無は `includeAllOption` で切り替える (絞り込み画面では出し、
/// 投票候補のブランド限定では出さない＝必ず1つは選ばせる)。
struct BrandGridPicker: View {
    let brands: [Brand]
    /// 空集合 = `includeAllOption` 時は全ブランド対象、それ以外は未選択。 複数選択は OR (= IN) で結合。
    @Binding var selectedBrandIds: Set<String>
    var includeAllOption: Bool = false

    private let columns = [GridItem(.adaptive(minimum: 56, maximum: 80), spacing: 10)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            if includeAllOption {
                BrandIconCell(
                    brandId: nil,
                    label: String(localized: L10n.Common.brandFilterAll),
                    iconText: String(localized: L10n.Common.brandFilterAllIcon),
                    color: nil,
                    isSelected: selectedBrandIds.isEmpty
                ) { selectedBrandIds = [] }
            }

            ForEach(brands) { brand in
                BrandIconCell(
                    brandId: brand.id,
                    label: brand.shortName,
                    iconText: brand.iconText,
                    color: brand.color,
                    isSelected: selectedBrandIds.contains(brand.id)
                ) {
                    if !selectedBrandIds.insert(brand.id).inserted {
                        selectedBrandIds.remove(brand.id)
                    }
                }
            }
        }
    }
}

struct BrandFilterSection: View {
    let brands: [Brand]
    /// 空集合 = 全ブランド対象。 複数選択は OR (= IN) で結合される。
    @Binding var selectedBrandIds: Set<String>

    var body: some View {
        Section {
            BrandGridPicker(brands: brands, selectedBrandIds: $selectedBrandIds, includeAllOption: true)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        } header: {
            Text(L10n.Common.filterSheetBrandHeader)
        } footer: {
            Text(L10n.Common.filterSheetBrandFooter).font(.imasCaption2).foregroundStyle(DS.ink3)
        }
    }
}

/// ブランド 1 件分。CustomImageService に画像があれば優先表示し、無ければ
/// ブランドカラー円 + 短いテキスト (765 / ミリ 等) を fallback として描画する。
/// 版権上、公式ロゴは使わずユーザー側で gist 経由 import した画像を使う。
struct BrandIconCell: View {
    let brandId: String?
    let label: String
    let iconText: String
    let color: String?
    let isSelected: Bool
    let action: () -> Void

    @State private var imageService = CustomImageService.shared

    private var background: Color {
        color.map { Color(hexString: $0) } ?? DS.sys
    }

    private var fontSize: CGFloat {
        switch iconText.count {
        case 0...2: return 18
        case 3:     return 14
        case 4:     return 12
        default:    return 10
        }
    }

    private var customImageURL: URL? {
        brandId.flatMap { imageService.brandImageURL(for: $0) }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: DS.sp2) {
                iconView
                Text(label)
                    .font(.imasCaption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    @ViewBuilder
    private var iconView: some View {
        if let url = customImageURL, let uiImage = UIImage(contentsOfFile: url.path) {
            // ブランドロゴは横長のロックアップも来る。 .fill だと両端が切れて
            // 判別できなくなるので .fit で円の中に収める (下地はブランド色)。
            // 配布しているブランド画像は「円 + 四隅透過」なので余白なしでちょうど収まる。
            // 下地の円は、ユーザーが独自に横長画像を入れたときに絵が浮かないための保険。
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .background(background.opacity(isSelected ? 0.18 : 0.10), in: Circle())
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? background : Color.clear, lineWidth: 2)
                )
                .opacity(isSelected ? 1.0 : 0.55)
        } else {
            ZStack {
                Circle()
                    .fill(isSelected ? background : background.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .strokeBorder(isSelected ? .clear : background.opacity(0.4), lineWidth: 1.5)
                    )
                Text(iconText)
                    .font(.imasScaled( fontSize, weight: .heavy, design: .rounded))
                    .foregroundStyle(isSelected ? .white : background)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: 42)
            }
        }
    }
}

// MARK: - Event Filter Sheet

struct EventFilterSheet: View {
    @Environment(AppDatabase.self) private var database
    @Environment(\.dismiss) private var dismiss

    /// 会場絞り込み (venue_id。空 = 絞り込みなし)。
    /// 名前ではなく ID で持つので、会場が改名しても絞り込みが外れない。
    @Binding var venue: String
    @Binding var selectedBrandIds: Set<String>
    /// 除外する EventKind の rawValue を CSV で保持
    @Binding var excludedKindsRaw: String
    @Binding var showEmptyEvents: Bool
    /// 参加状態フィルタ ("all" / "attended" / "not_attended")
    @Binding var attendanceFilter: String
    @Binding var requireFavorite: Bool
    @Binding var requireNote: Bool

    @State private var brands: [Brand] = []
    @State private var venueDirectory: VenueDirectory = .empty
    /// 選択中の会場 (venue_id)。nil = 未選択。
    @State private var localVenue: String?
    @State private var localBrandIds: Set<String> = []
    @State private var localExcluded: Set<EventKind> = []
    @State private var localShowEmpty: Bool = false
    @State private var localAttendance: String = "all"
    @State private var localFavorite: Bool = false
    @State private var localNote: Bool = false
    /// `.task` での初期値復元が済んだか。会場ピッカーを push → pop すると `.task` が
    /// 再実行され、選んだばかりの localVenue を「適用前の venue (空)」で上書きして
    /// 選択が消える。復元は 1 度きりにする (IdolFilterSheet の didRestore と同じ対策)。
    @State private var didRestore = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        VenuePickerView(directory: venueDirectory, selected: $localVenue)
                    } label: {
                        Text(selectedVenueLabel)
                            .foregroundStyle(localVenue == nil ? DS.ink2 : DS.ink)
                    }
                } header: {
                    Text(L10n.Common.filterSheetVenueHeader)
                } footer: {
                    Text(L10n.Common.filterSheetVenueFooter)
                }

                BrandFilterSection(brands: brands, selectedBrandIds: $localBrandIds)

                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: DS.sp3)], spacing: DS.sp3) {
                        ForEach(EventKind.allCases, id: \.rawValue) { kind in
                            EventKindChip(
                                kind: kind,
                                isOn: !localExcluded.contains(kind)
                            ) {
                                if localExcluded.contains(kind) {
                                    localExcluded.remove(kind)
                                } else {
                                    localExcluded.insert(kind)
                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                } header: {
                    Text(L10n.Common.filterSheetKindHeader)
                } footer: {
                    if localExcluded.isEmpty {
                        Text(L10n.Common.filterSheetKindAllShown)
                    } else {
                        // 種別名はコアの語彙。並びの区切り「 / 」はそのまま
                        Text(L10n.Common.filterSheetKindExcluded(
                            kinds: localExcluded.map(\.displayLabel).sorted().joined(separator: " / ")))
                    }
                }

                Section(L10n.Common.filterSheetAttendanceHeader) {
                    ImasSegmented(options: ["all", "attended", "not_attended"], selection: $localAttendance) {
                        switch $0 {
                        case "attended": String(localized: L10n.Common.filterSheetAttendanceAttended)
                        case "not_attended": String(localized: L10n.Common.filterSheetAttendanceNotAttended)
                        default: String(localized: L10n.Common.filterSheetAttendanceAll)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section(L10n.Common.filterSheetMyMarkHeader) {
                    Toggle(isOn: $localFavorite) {
                        Label(L10n.Common.filterSheetMyMarkFavoriteOnly, systemImage: "star.fill")
                            .foregroundStyle(DS.favorite)
                    }
                    Toggle(isOn: $localNote) {
                        Label(L10n.Common.filterSheetMyMarkEventNoteOnly, systemImage: "note.text")
                            .foregroundStyle(DS.warning)
                    }
                }

                Section(L10n.Common.filterSheetDisplayHeader) {
                    Toggle(L10n.Common.filterSheetDisplayShowEmptyEvents, isOn: $localShowEmpty)
                        .tint(DS.success)
                }

            }
            .imasFilterSheetChrome()
            .toolbar {
                filterSheetToolbar(
                    analyticsPrefix: "event_filter",
                    canReset: hasActiveFilters,
                    onReset: reset,
                    onApply: apply
                )
            }
            .task {
                do {
                    brands = try await AppContainer.shared.brandReading.brands()
                } catch {
                    Logger.database.error("load_failed brands (FilterSheet/event): \(error.localizedDescription)")
                }
                venueDirectory = (try? await AppContainer.shared.showReading.venueDirectory()) ?? .empty
                guard !didRestore else { return }
                localVenue = venue.isEmpty ? nil : venue
                localBrandIds = selectedBrandIds
                localExcluded = Set(excludedKindsRaw.split(separator: ",")
                    .compactMap { EventKind(rawValue: String($0)) })
                localShowEmpty = showEmptyEvents
                localAttendance = attendanceFilter
                localFavorite = requireFavorite
                localNote = requireNote
                didRestore = true
            }
            .trackScreen("event_filter_sheet")
        }
    }

    /// 選択中の会場ラベル。ID から現行名 + 都道府県を引く。
    private var selectedVenueLabel: String {
        guard let localVenue, let v = venueDirectory.venue(id: localVenue) else {
            return String(localized: L10n.Common.filterSheetVenueNone)
        }
        return v.displayNameWithArea
    }

    private var hasActiveFilters: Bool {
        localVenue != nil
            || !localBrandIds.isEmpty || !localExcluded.isEmpty || localShowEmpty
            || localAttendance != "all" || localFavorite || localNote
    }

    private func reset() {
        localVenue = nil
        localBrandIds = []
        localExcluded = []
        localShowEmpty = false
        localAttendance = "all"
        localFavorite = false
        localNote = false
    }

    private func apply() {
        venue = localVenue ?? ""
        selectedBrandIds = localBrandIds
        excludedKindsRaw = localExcluded.map(\.rawValue).sorted().joined(separator: ",")
        showEmptyEvents = localShowEmpty
        attendanceFilter = localAttendance
        requireFavorite = localFavorite
        requireNote = localNote
        dismiss()
    }
}

/// 種別 (EventKind) の on/off chip。
struct EventKindChip: View {
    let kind: EventKind
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        ImasFilterChip(
            text: kind.displayLabel,
            systemImage: kind.iconName,
            isSelected: isOn,
            fillsWidth: true,
            action: action
        )
        .accessibilityLabel(isOn
                            ? L10n.Common.filterSheetKindChipShownA11y(kind: kind.displayLabel)
                            : L10n.Common.filterSheetKindChipExcludedA11y(kind: kind.displayLabel))
    }
}

// MARK: - Idol Filter Sheet

/// ブランドごとのサブカテゴリ属性 (idols.attribute) 定義。
/// (内部値, 表示ラベル) のペア。順序が UI 表示順。
/// ラベルは描くたびに引く (定数に置くと作った時点の言語で固まる)。英字の属性名 (シャイニーカラーズ) は訳さない。
private var brandAttributes: [String: [(value: String, label: DisplayText)]] {
    let princess: [(value: String, label: DisplayText)] = [
        ("princess", .key(L10n.Common.filterSheetAttributePrincess)),
        ("fairy", .key(L10n.Common.filterSheetAttributeFairy)),
        ("angel", .key(L10n.Common.filterSheetAttributeAngel)),
    ]
    let cinderella: [(value: String, label: DisplayText)] = [
        ("cute", .key(L10n.Common.filterSheetAttributeCute)),
        ("cool", .key(L10n.Common.filterSheetAttributeCool)),
        ("passion", .key(L10n.Common.filterSheetAttributePassion)),
    ]
    let sidem: [(value: String, label: DisplayText)] = [
        ("intelli", .key(L10n.Common.filterSheetAttributeIntelli)),
        ("physical", .key(L10n.Common.filterSheetAttributePhysical)),
        ("mental", .key(L10n.Common.filterSheetAttributeMental)),
    ]
    let shiny: [(value: String, label: DisplayText)] = [
        ("sol", .verbatim("Sol")), ("luna", .verbatim("Luna")), ("stella", .verbatim("Stella")),
    ]
    return ["cg": cinderella, "ml": princess, "765as": princess, "sidem": sidem, "sc": shiny]
}

/// 表示形式の選択肢の文言。rawValue (「アイドル名」「CV名」) は @AppStorage に入る保存値なので変えず、
/// 表示だけカタログを引く。
private extension IdolDisplayMode {
    var filterSheetLabel: LocalizedStringResource {
        switch self {
        case .idolName: L10n.Common.filterSheetDisplayModeIdolName
        case .cvName: L10n.Common.filterSheetDisplayModeCvName
        }
    }
}

/// 並び順の選択肢の文言。rawValue (「公式順」など) は @AppStorage に入る保存値なので変えず、
/// 表示だけカタログを引く。
private extension IdolSortOrder {
    var filterSheetLabel: LocalizedStringResource {
        switch self {
        case .official: L10n.Common.filterSheetIdolSortOfficial
        case .nameKana: L10n.Common.filterSheetIdolSortNameKana
        case .age: L10n.Common.filterSheetIdolSortAge
        case .height: L10n.Common.filterSheetIdolSortHeight
        case .weight: L10n.Common.filterSheetIdolSortWeight
        case .birthday: L10n.Common.filterSheetIdolSortBirthday
        case .debut: L10n.Common.filterSheetIdolSortDebut
        }
    }
}

struct IdolFilterSheet: View {
    @Environment(AppDatabase.self) private var database
    @Environment(\.dismiss) private var dismiss

    @Binding var sortOrder: IdolSortOrder
    /// nil = sortOrder の既定方向、true=昇順、false=降順。
    @Binding var sortAscending: Bool?
    @Binding var selectedBrandIds: Set<String>
    @Binding var selectedAttribute: String?
    @Binding var displayMode: IdolDisplayMode
    @Binding var showCV: Bool
    @Binding var requireMyPick: Bool
    @Binding var requireFavorite: Bool
    @Binding var requireNote: Bool

    @State private var brands: [Brand] = []
    @State private var localSortOrder: IdolSortOrder = .official
    @State private var localSortAscending: Bool?
    @State private var localBrandIds: Set<String> = []
    @State private var localAttribute: String?
    @State private var localDisplayMode: IdolDisplayMode = .idolName
    @State private var localShowCV: Bool = false
    @State private var localMyPick: Bool = false
    @State private var localFavorite: Bool = false
    @State private var localNote: Bool = false
    /// `.task` での初期値復元が完了するまでは true。復元中の localBrandIds 代入で
    /// onChange(of: localBrandIds) が誤発火し、復元直後の localAttribute を
    /// リセットしてしまうのを防ぐためのガード。
    @State private var didRestore = false

    /// 属性チップは「単一ブランドが選択されている」場合のみ表示。
    /// 0 件 or 複数ブランドではブランド共通のサブ属性が無いので空。
    private var attributesForBrand: [(value: String, label: DisplayText)] {
        guard localBrandIds.count == 1, let bid = localBrandIds.first else { return [] }
        return brandAttributes[bid] ?? []
    }

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.Common.filterSheetDisplayModeHeader) {
                    ImasSegmented(options: IdolDisplayMode.allCases, selection: $localDisplayMode) {
                        String(localized: $0.filterSheetLabel)
                    }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

                    // アイドル名表示のとき、CV 名を別行で併記するか。CV 名表示中は CV がタイトルなので無効。
                    Toggle(L10n.Common.filterSheetShowCv, isOn: $localShowCV)
                        .disabled(localDisplayMode == .cvName)
                }

                Section {
                    Picker(L10n.Common.filterSheetSortHeader, selection: $localSortOrder) {
                        ForEach(IdolSortOrder.allCases, id: \.rawValue) { order in
                            Text(order.filterSheetLabel).tag(order)
                        }
                    }
                    .pickerStyle(.menu)

                    // 方向 toggle (nil なら並び順ごとの既定を表示値にする)
                    Picker(L10n.Common.filterSheetSortDirection, selection: Binding(
                        get: { localSortAscending ?? localSortOrder.defaultAscending },
                        set: { localSortAscending = $0 }
                    )) {
                        Label(localSortOrder.ascendingLabel, systemImage: "arrow.up").tag(true)
                        Label(localSortOrder.descendingLabel, systemImage: "arrow.down").tag(false)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(L10n.Common.filterSheetSortHeader)
                } footer: {
                    if !localSortOrder.keepsBrandGrouping {
                        Text(L10n.Common.filterSheetSortUngroupedFooter)
                    }
                }

                BrandFilterSection(brands: brands, selectedBrandIds: $localBrandIds)
                    .onChange(of: localBrandIds) { _, _ in
                        // ブランド変更時は属性絞り込みリセット。
                        // ただし .task による初期値復元中はスキップ (復元した
                        // localAttribute を巻き添えで消してしまうため)。
                        guard didRestore else { return }
                        localAttribute = nil
                    }

                if !attributesForBrand.isEmpty {
                    Section(L10n.Common.filterSheetAttributeHeader) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                attributeChip(value: nil, label: String(localized: L10n.Common.filterSheetAttributeAll))
                                ForEach(attributesForBrand, id: \.value) { item in
                                    attributeChip(value: item.value, label: item.label.resolved)
                                }
                            }
                        }
                    }
                }

                Section(L10n.Common.filterSheetMyMarkHeader) {
                    Toggle(isOn: $localMyPick) {
                        Label(L10n.Common.filterSheetMyMarkMyPickOnly, systemImage: "heart.fill")
                            .foregroundStyle(DS.pick)
                    }
                    Toggle(isOn: $localFavorite) {
                        Label(L10n.Common.filterSheetMyMarkFavoriteOnly, systemImage: "star.fill")
                            .foregroundStyle(DS.favorite)
                    }
                    Toggle(isOn: $localNote) {
                        Label(L10n.Common.filterSheetMyMarkIdolNoteOnly, systemImage: "note.text")
                            .foregroundStyle(DS.warning)
                    }
                }

            }
            .imasFilterSheetChrome()
            .toolbar {
                filterSheetToolbar(
                    analyticsPrefix: "idol_filter",
                    canReset: hasActiveFilters,
                    onReset: reset,
                    onApply: apply
                )
            }
            .task {
                do {
                    brands = try await AppContainer.shared.brandReading.brands()
                } catch {
                    Logger.database.error("load_failed brands (FilterSheet/idol): \(error.localizedDescription)")
                }
                localSortOrder = sortOrder
                localSortAscending = sortAscending
                localBrandIds = selectedBrandIds
                localAttribute = selectedAttribute
                localDisplayMode = displayMode
                localShowCV = showCV
                localMyPick = requireMyPick
                localFavorite = requireFavorite
                localNote = requireNote
                didRestore = true
            }
            .trackScreen("idol_filter_sheet")
        }
    }

    private var hasActiveFilters: Bool {
        localSortOrder != .official || localSortAscending != nil
            || !localBrandIds.isEmpty || localAttribute != nil || localDisplayMode != .idolName
            || localShowCV || localMyPick || localFavorite || localNote
    }

    private func reset() {
        localSortOrder = .official
        localSortAscending = nil
        localBrandIds = []
        localAttribute = nil
        localDisplayMode = .idolName
        localShowCV = false
        localMyPick = false
        localFavorite = false
        localNote = false
    }

    private func apply() {
        sortOrder = localSortOrder
        sortAscending = localSortAscending
        selectedBrandIds = localBrandIds
        selectedAttribute = localAttribute
        displayMode = localDisplayMode
        showCV = localShowCV
        requireMyPick = localMyPick
        requireFavorite = localFavorite
        requireNote = localNote
        dismiss()
    }

    private func attributeChip(value: String?, label: String) -> some View {
        ImasFilterChip(text: label, isSelected: localAttribute == value) {
            localAttribute = value
        }
    }
}

// MARK: - Tag Filter Sheet

struct TagFilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    let categories: [(value: String, label: String)]
    let sortOptions: [(value: String, label: String)]

    @Binding var selectedCategory: String
    @Binding var selectedSort: String

    @State private var localCategory: String = ""
    @State private var localSort: String = "popular"

    var activeFilterCount: Int {
        (selectedCategory.isEmpty ? 0 : 1)
    }

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.Common.filterSheetCategoryHeader) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DS.sp3) {
                            ForEach(categories, id: \.value) { cat in
                                categoryChip(value: cat.value, label: cat.label)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section(L10n.Common.filterSheetSortHeader) {
                    ImasSegmented(options: sortOptions.map(\.value), selection: $localSort) { value in
                        sortOptions.first { $0.value == value }?.label ?? value
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

            }
            .imasFilterSheetChrome()
            .toolbar {
                filterSheetToolbar(
                    analyticsPrefix: "tag_filter",
                    canReset: hasActiveFilters,
                    onReset: reset,
                    onApply: apply
                )
            }
            .onAppear {
                localCategory = selectedCategory
                localSort = selectedSort
            }
            .trackScreen("tag_filter_sheet")
        }
    }

    private var hasActiveFilters: Bool {
        !localCategory.isEmpty || localSort != "popular"
    }

    private func reset() {
        localCategory = ""
        localSort = "popular"
    }

    private func apply() {
        selectedCategory = localCategory
        selectedSort = localSort
        dismiss()
    }

    private func categoryChip(value: String, label: String) -> some View {
        ImasFilterChip(text: label, isSelected: localCategory == value) {
            localCategory = value
        }
    }
}

// MARK: - Filter Badge Button

/// ナビバーのフィルタアイコン。activeCount > 0 なら赤バッジを表示。
struct FilterBarButton: View {
    let activeCount: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: activeCount > 0
                      ? "line.3.horizontal.decrease.circle.fill"
                      : "line.3.horizontal.decrease.circle")
                if activeCount > 0 {
                    Text("\(activeCount)")
                        .font(.imasCaption2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 16, height: 16)
                        .background(DS.danger)
                        .clipShape(Circle())
                        .offset(x: 6, y: -6)
                }
            }
        }
    }
}
