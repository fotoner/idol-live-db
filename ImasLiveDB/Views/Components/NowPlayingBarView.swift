import SwiftUI

/// タブバーの直上に出す再生中バー (ミニプレイヤー)。
///
/// 出すのは **このアプリが鳴らしている音** だけ。純正ミュージックアプリで
/// かかっている曲は拾わない (`SystemMusicPlayer` は使っていない)。
///
/// 何を出すかの判断はコア (`imas-core` の `now_playing`) が持つ。ここは
/// コアが返した 1 枚をそのまま描くだけで、名義の組み立ても試聴の書き分けもしない。
/// iOS と Android で別々に書くと必ず片方だけずれる。
///
/// `SyncStatusBar` と同じく `.safeAreaInset(edge: .bottom)` で各タブに差し込む
/// (TabView 自体に付けるとタブバー領域に被る)。
struct NowPlayingBarView: View {
    /// コアに渡す射影。鳴っている曲が変わったときだけ引き直す。
    @State private var song: NowPlayingSong?
    @State private var destination: DetailDestination?

    private var service: MusicKitService { MusicKitService.shared }

    /// ジャケの一辺。Apple Music のミニプレイヤーとほぼ同じ大きさ。
    private static let artworkSize: CGFloat = 40

    var body: some View {
        Group {
            if let bar = nowPlayingBar(
                song: song,
                kind: service.isFullPlayback ? .full : .preview,
                isPlaying: service.isPlaying
            ) {
                barContent(bar)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: service.nowPlayingSongId)
        // 曲が変わったときだけ引き直す。再生/停止のたびに DB は叩かない。
        .task(id: service.nowPlayingSongId) { await loadSong() }
        .sheet(item: $destination) { DetailSheetView(destination: $0) }
    }

    private func barContent(_ bar: NowPlayingBar) -> some View {
        VStack(spacing: 0) {
            Rectangle().fill(DS.sep).frame(height: 0.5)

            HStack(spacing: DS.sp3) {
                ArtworkImageView(
                    url: bar.artworkUrl.flatMap(URL.init(string:)),
                    size: Self.artworkSize,
                    seed: bar.songId
                )
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                VStack(alignment: .leading, spacing: 1) {
                    Text(bar.title)
                        .font(.imasSubhead.weight(.medium))
                        .foregroundStyle(DS.ink)
                        .lineLimit(1)
                    // コアが「出すものが無い」と判断したら空文字で返る。行ごと出さない。
                    if !bar.subtitle.isEmpty {
                        Text(bar.subtitle)
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink3)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)

                Button {
                    service.stop()
                } label: {
                    Image(systemName: bar.isPlaying ? "pause.fill" : "play.fill")
                        .font(.imasTitle3)
                        .foregroundStyle(DS.ink)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(bar.isPlaying ? "停止" : "再生")
            }
            .padding(.horizontal, DS.sp4)
            .padding(.vertical, 6)
        }
        .background(.bar)
        .contentShape(Rectangle())
        .onTapGesture { openSong(bar.songId) }
        .accessibilityElement(children: .combine)
        .accessibilityHint("曲の詳細を開く")
    }

    /// 鳴っている曲をコアに渡せる形にする。
    ///
    /// 名義の材料 (`unit_name` / `singer_label` / 原唱者) をここで揃えて 1 回で渡す。
    /// どれを使うかはコアの `performer_label` が決めるので、ここでは選ばない。
    private func loadSong() async {
        guard let songId = service.nowPlayingSongId else {
            song = nil
            return
        }
        let reading = AppContainer.shared.songReading
        guard let s = try? await reading.song(id: songId) else {
            song = nil
            return
        }
        let performers = (try? await reading.songArtists(songId: songId, role: "original")) ?? []
        song = NowPlayingSong(
            songId: s.id,
            title: s.title,
            naming: PerformerNaming(
                unitName: s.unitName,
                singerLabel: s.singerLabel,
                performerNames: performers.map(\.name)
            ),
            artworkUrl: s.artworkUrl
        )
    }

    private func openSong(_ songId: String) {
        Task {
            guard let s = try? await AppContainer.shared.songReading.song(id: songId) else { return }
            destination = .song(s)
        }
    }
}

extension View {
    /// タブコンテンツの下端に再生中バーを差し込む。
    ///
    /// `syncStatusBarInset()` より **後に** 付けると、バーがタブバー寄り (下) に来る。
    /// 同期バーは数秒で畳まれるが、こちらは鳴っている間ずっと残るので下が自然。
    func nowPlayingBarInset() -> some View {
        safeAreaInset(edge: .bottom, spacing: 0) { NowPlayingBarView() }
    }
}
