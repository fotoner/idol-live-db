import os
import SwiftUI

/// 楽曲フィルタ設定画面（シートで表示）
struct SongFilterView: View {
    @Environment(AppDatabase.self) private var database
    @Environment(\.dismiss) private var dismiss

    /// 一覧を名前で絞り込むテキスト。入力欄は一覧側 (`.searchable`) にあり、
    /// ここでは「絞り込み中」の表示とクリアのためだけに持つ。
    @Binding var nameFilter: String
    @Binding var filter: SongSearchFilter
    @Binding var sortOrder: SongSortOrder
    /// nil = sortOrder のデフォルト方向、 true=昇順、 false=降順
    @Binding var sortAscending: Bool?
    @Binding var listMode: SongListMode
    @Binding var collectFilter: SongCollectFilter
    @Binding var myMarkFilter: SongMyMarkFilter
    /// 「その他」(歌枠カバー等 brand_id='other') をブラウズ一覧に出すか。
    @Binding var showOtherBrand: Bool
    /// ライブ履歴のみのファントム曲を一覧から隠すか。
    @Binding var excludeLiveOnly: Bool
    /// コールガイド (歌詞行のコール・手拍子) が書き込まれている曲だけに絞るか。
    @Binding var callGuideOnly: Bool
    /// 音楽カードゲーム「KAMISABI」の収録曲だけに絞るか。
    @Binding var kamisabiOnly: Bool

    @State private var brands: [Brand] = []
    @State private var idols: [Idol] = []
    @State private var cdSeriesList: [String] = []
    @State private var seriesGroupList: [String] = []
    @State private var eventNames: [String] = []

    // 選択中の状態
    @State private var selectedIdolIds: Set<String> = []
    @State private var songwriterText = ""
    @State private var selectedCdSeries: String? = nil
    @State private var selectedSeriesGroup: String? = nil
    @State private var selectedEventName: String? = nil
    @State private var selectedBrandIds: Set<String> = []
    @State private var selectedSongType: String? = nil

    /// `.task` での初期値復元が済んだか。シリーズ/CD/ライブのピッカーを push → pop すると
    /// `.task` が再実行され、選んだばかりの値を「適用前の filter」で上書きして選択が消える。
    /// 復元は 1 度きりにする。
    @State private var didRestore = false

    @State private var showIdolPicker = false

    var body: some View {
        NavigationStack {
            List {
                // 表示形式
                Section {
                    Picker(selection: $listMode) {
                        Label(L10n.Songs.filterListModeSongs, systemImage: "music.note.list").tag(SongListMode.songs)
                        Label(L10n.Songs.filterListModeAlbums, systemImage: "square.grid.2x2").tag(SongListMode.albums)
                        Label(L10n.Songs.filterListModeSeries, systemImage: "rectangle.stack").tag(SongListMode.series)
                    } label: {
                        Text(L10n.Songs.filterListModePicker)
                    }
                    .pickerStyle(.segmented)

                    if listMode == .songs {
                        Picker(selection: $collectFilter) {
                            // 表示は label。rawValue は @AppStorage に保存される値なので画面に出さない。
                            ForEach(SongCollectFilter.allCases, id: \.rawValue) { c in
                                Text(c.label).tag(c)
                            }
                        } label: {
                            Text(L10n.Songs.filterCollectHeader)
                        }
                        .pickerStyle(.segmented)
                    }
                } header: {
                    Text(L10n.Songs.filterListModeHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                if listMode == .songs {
                    Section {
                        Toggle(isOn: $myMarkFilter.requireMyPick) {
                            Label(L10n.Songs.filterMyMarkMyPick, systemImage: "heart.fill")
                                .foregroundStyle(DS.pick)
                        }
                        Toggle(isOn: $myMarkFilter.requireFavorite) {
                            Label(L10n.Songs.filterMyMarkFavorite, systemImage: "star.fill")
                                .foregroundStyle(DS.favorite)
                        }
                        Toggle(isOn: $myMarkFilter.requireNote) {
                            Label(L10n.Songs.filterMyMarkNote, systemImage: "note.text")
                                .foregroundStyle(DS.warning)
                        }
                    } header: {
                        Text(L10n.Songs.filterMyMarkHeader)
                    } footer: {
                        Text(L10n.Songs.filterMyMarkFooter)
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink3)
                    }
                    .listRowBackground(DS.surface)
                    .listRowSeparatorTint(DS.sep)
                }

                if listMode == .songs, LyricsFeature.isAvailable {
                    Section {
                        Toggle(isOn: $callGuideOnly) {
                            Label(L10n.Songs.filterCallGuideToggle, systemImage: "hands.clap.fill")
                        }
                    } header: {
                        Text(L10n.Songs.filterCallGuideHeader)
                    } footer: {
                        Text(L10n.Songs.filterCallGuideFooter)
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink3)
                    }
                    .listRowBackground(DS.surface)
                    .listRowSeparatorTint(DS.sep)
                }

                // ソート
                Section {
                    Picker(selection: $sortOrder) {
                        ForEach(SongSortOrder.allCases, id: \.rawValue) { order in
                            Text(order.label).tag(order)
                        }
                    } label: {
                        Text(L10n.Songs.filterSortPicker)
                    }
                    .pickerStyle(.menu)

                    // 方向 toggle (Binding<Bool> に橋渡し: nil なら sortOrder の default を表示値とする)
                    Picker(selection: Binding(
                        get: { sortAscending ?? sortOrder.defaultAscending },
                        set: { sortAscending = $0 }
                    )) {
                        Label(L10n.Songs.sortAscending, systemImage: "arrow.up").tag(true)
                        Label(L10n.Songs.sortDescending, systemImage: "arrow.down").tag(false)
                    } label: {
                        Text(L10n.Songs.filterSortDirection)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(L10n.Songs.filterSortHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // ブランド
                BrandFilterSection(brands: brands, selectedBrandIds: $selectedBrandIds)

                Section {
                    Toggle(isOn: $excludeLiveOnly) {
                        VStack(alignment: .leading, spacing: DS.sp1) {
                            Text(L10n.Songs.filterLiveOnlyTitle)
                            Text(L10n.Songs.filterLiveOnlyCaption)
                                .font(.imasCaption).foregroundStyle(DS.ink3)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

                    Toggle(isOn: $showOtherBrand) {
                        VStack(alignment: .leading, spacing: DS.sp1) {
                            Text(L10n.Songs.filterOtherBrandTitle)
                            Text(L10n.Songs.filterOtherBrandCaption)
                                .font(.imasCaption).foregroundStyle(DS.ink3)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                if listMode == .songs {
                    Section {
                        Toggle(isOn: $kamisabiOnly) {
                            // 収録はカタログの事実、所持 (UserMarkKind.owned) はユーザーのマーク。
                            // 別物なので同じ記号 (shippingbox) を流用しない。
                            Label(L10n.Songs.filterKamisabiToggleIos, systemImage: "suit.club.fill")
                        }
                    } header: {
                        Text("KAMISABI")
                    } footer: {
                        Text(L10n.Songs.filterKamisabiCaptionIos)
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink3)
                    }
                    .listRowBackground(DS.surface)
                    .listRowSeparatorTint(DS.sep)
                }

                // 曲タイプ
                Section {
                    songTypePicker
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                } header: {
                    Text(L10n.Songs.filterSongTypeHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // アイドル選択
                Section {
                    Button {
                        showIdolPicker = true
                    } label: {
                        HStack {
                            if selectedIdolIds.isEmpty {
                                Text(L10n.Songs.filterNone)
                                    .foregroundStyle(DS.ink2)
                            } else {
                                let names = selectedIdolNames
                                FlowLayout(spacing: DS.sp2) {
                                    ForEach(names, id: \.self) { name in
                                        Text(name)
                                            .font(.imasCaption)
                                            .padding(.horizontal, DS.sp3)
                                            .padding(.vertical, DS.sp2)
                                            .background(DS.fill)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            Spacer()
                            ImasRowChevron()
                        }
                    }
                } header: {
                    Text(L10n.Songs.filterIdolHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // 作詞・作曲・編曲
                Section {
                    // LocalizedStringResource を受ける TextField(_:text:) は iOS 26 からなので、prompt: 付きの版 (iOS 16) を使う
                    TextField(L10n.Songs.filterCreatorPlaceholder, text: $songwriterText, prompt: nil)
                        .textFieldStyle(.plain)
                } header: {
                    Text(L10n.Songs.filterCreatorHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // シリーズ (series_group: LTF / BRILLI@NT WING 等)
                Section {
                    NavigationLink {
                        ListPickerView(title: String(localized: L10n.Songs.filterSeriesHeader),
                                       items: seriesGroupList, selected: $selectedSeriesGroup)
                    } label: {
                        pickedValue(selectedSeriesGroup)
                    }
                } header: {
                    Text(L10n.Songs.filterSeriesHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // CDシリーズ
                Section {
                    NavigationLink {
                        ListPickerView(title: String(localized: L10n.Songs.filterCdSeriesHeader),
                                       items: cdSeriesList, selected: $selectedCdSeries)
                    } label: {
                        pickedValue(selectedCdSeries)
                    }
                } header: {
                    Text(L10n.Songs.filterCdSeriesHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // ライブ名
                Section {
                    NavigationLink {
                        ListPickerView(title: String(localized: L10n.Songs.filterLivePickerTitle),
                                       items: eventNames, selected: $selectedEventName)
                    } label: {
                        pickedValue(selectedEventName)
                    }
                } header: {
                    Text(L10n.Songs.filterLiveHeader)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                // リセット
                if hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            resetAll()
                        } label: {
                            Label(L10n.Songs.filterResetIos, systemImage: "arrow.counterclockwise")
                        }
                    }
                    .listRowBackground(DS.surface)
                    .listRowSeparatorTint(DS.sep)
                }
            }
            .imasFilterSheetChrome()
            .toolbar {
                filterSheetToolbar(
                    analyticsPrefix: "song_filter",
                    canReset: hasActiveFilters,
                    onReset: resetAll,
                    onApply: {
                        applyFilter()
                        dismiss()
                    }
                )
            }
            .sheet(isPresented: $showIdolPicker) {
                IdolPickerView(
                    title: String(localized: L10n.Songs.filterIdolHeader),
                    idols: idols,
                    selected: selectedIdolIds
                ) { selectedIdolIds = $0 }
                    .environment(database)
                    .presentationDetents([.large])
            }
            .task { await loadData() }
            .trackScreen("song_filter")
        }
    }

    // MARK: - Song Type Picker

    private var songTypePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                songTypeChip(value: nil, label: String(localized: L10n.Songs.filterAll))
                // 絞り込みは今までどおり先頭の 3 種 (ソロ / ユニット / 全体曲)。語はコアの vocabulary。
                ForEach(Vocab.table.songTypes.prefix(3), id: \.value) { term in
                    songTypeChip(value: term.value, label: term.shortLabel)
                }
            }
        }
    }

    private func songTypeChip(value: String?, label: String) -> some View {
        let isSelected = selectedSongType == value
        return Button {
            selectedSongType = value
        } label: {
            ImasChip(text: label, style: isSelected ? .selected : .neutral)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    /// 選択ページへ降りる行の値。選んだ値はデータなのでそのまま、未選択は「選択なし」。
    @ViewBuilder
    private func pickedValue(_ value: String?) -> some View {
        if let value {
            Text(value).foregroundStyle(DS.ink)
        } else {
            Text(L10n.Songs.filterNone).foregroundStyle(DS.ink2)
        }
    }

    private var selectedIdolNames: [String] {
        idols.filter { selectedIdolIds.contains($0.id) }.map(\.name)
    }

    private var hasActiveFilters: Bool {
        !nameFilter.isEmpty ||
        !selectedBrandIds.isEmpty || !selectedIdolIds.isEmpty ||
        !songwriterText.isEmpty || selectedCdSeries != nil || selectedSeriesGroup != nil ||
        selectedEventName != nil || selectedSongType != nil
    }

    private func resetAll() {
        nameFilter = ""
        selectedBrandIds = []
        selectedIdolIds = []
        songwriterText = ""
        selectedCdSeries = nil
        selectedSeriesGroup = nil
        selectedEventName = nil
        selectedSongType = nil
    }

    private func applyFilter() {
        var f = SongSearchFilter(
            brandIds: selectedBrandIds,
            title: nil,
            idolIds: selectedIdolIds.isEmpty ? nil : Array(selectedIdolIds),
            songwriter: songwriterText.isEmpty ? nil : songwriterText,
            cdSeries: selectedCdSeries,
            liveName: selectedEventName,
            songType: selectedSongType
        )
        f.seriesGroup = selectedSeriesGroup
        filter = f
    }

    private func loadData() async {
        do {
            brands = try await AppContainer.shared.brandReading.brands()
            idols = try await AppContainer.shared.idolReading.idols(brandId: nil)
            cdSeriesList = try await AppContainer.shared.songReading.cdSeriesList()
            seriesGroupList = try await AppContainer.shared.songReading.seriesGroups(brandIds: [])
            eventNames = try await AppContainer.shared.eventReading.eventNames()
        } catch {
            Logger.database.error("load_failed SongFilterView: \(error.localizedDescription)")
        }

        // 既存フィルタから状態を復元 (初回のみ)
        guard !didRestore else { return }
        selectedBrandIds = filter.brandIds
        songwriterText = filter.songwriter ?? ""
        selectedCdSeries = filter.cdSeries
        selectedSeriesGroup = filter.seriesGroup
        selectedEventName = filter.liveName
        selectedSongType = filter.songType
        didRestore = true
    }
}
