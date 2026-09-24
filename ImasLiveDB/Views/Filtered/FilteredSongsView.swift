import os
import SwiftUI

struct FilteredSongsView: View {
    @Environment(AppDatabase.self) private var database
    let criterion: SongFilterCriterion
    let navigate: (DetailDestination) -> Void

    @State private var songs: [SongWithArtists] = []
    @State private var songsWithRoles: [SongWithRoles] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ImasLoadingState()
            } else {
                switch criterion {
                case .creator:
                    if songsWithRoles.isEmpty {
                        ImasEmptyState(systemImage: "music.note.list", title: String(localized: L10n.Filtered.songsEmpty))
                    } else {
                        creatorList
                    }
                default:
                    if songs.isEmpty {
                        ImasEmptyState(systemImage: "music.note.list", title: String(localized: L10n.Filtered.songsEmpty))
                    } else {
                        standardList
                    }
                }
            }
        }
        .navigationTitle(Text(display: title))
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadSongs() }
        .trackScreen("filtered_songs")
    }

    private var standardList: some View {
        List {
            Section {
                ForEach(songs) { item in
                    Button {
                        navigate(.song(item.song))
                    } label: {
                        SongRowView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(L10n.Filtered.songsCount(count: songs.count))
                    .font(.imasCaption)
            }
        }
        .listStyle(.plain)
    }

    private var creatorList: some View {
        List {
            Section {
                ForEach(songsWithRoles) { item in
                    Button {
                        navigate(.song(item.song))
                    } label: {
                        VStack(alignment: .leading, spacing: DS.sp1) {
                            SongRowView(item: SongWithArtists(song: item.song, artistNames: item.song.singerLabel ?? ""))
                            Text(item.rolesLabel)
                                .font(.imasCaption2)
                                .foregroundStyle(.tint)
                                .padding(.leading, 62)
                        }
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text(L10n.Filtered.songsCount(count: songsWithRoles.count))
                    .font(.imasCaption)
            }
        }
        .listStyle(.plain)
    }

    /// 画面タイトル。`criterion.navigationTitle` は遷移先の識別子 (DetailSheet の id) にも使うので、
    /// 表示だけここで写す。CD シリーズ名などのデータと、呼び出し側が引いて渡したタイトルはそのまま。
    private var title: DisplayText {
        switch criterion {
        case .brand(_, let label): return .key(L10n.Filtered.songsTitleBrand(brand: label))
        case .cdSeries(let name): return .verbatim(name)
        case .seriesGroup(let name): return .verbatim(name)
        case .songType(let type): return .key(L10n.Filtered.songsTitleSongType(songType: type))
        case .releaseYear(let year): return .key(L10n.Filtered.songsTitleReleaseYear(year: year))
        case .creator(let name): return .key(L10n.Filtered.songsTitleCreator(name: name))
        case .songIds(_, let title): return .verbatim(title)
        }
    }

    private func loadSongs() async {
        isLoading = true
        defer { isLoading = false }
        do {
            if case .creator(let name) = criterion {
                songsWithRoles = try await AppContainer.shared.songReading.songsByCreator(name)
            } else {
                songs = try await AppContainer.shared.songReading.songs(criterion: criterion)
            }
        } catch {
            Logger.database.error("load_failed filtered_songs: \(error.localizedDescription)")
            songs = []
            songsWithRoles = []
        }
    }
}
