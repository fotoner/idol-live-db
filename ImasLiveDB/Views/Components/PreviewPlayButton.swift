import SwiftUI

/// 30秒プレビュー再生ボタン（アプリ内再生）
struct PreviewPlayButton: View {
    let url: URL
    /// 再生中判定に使う `songs.id`。曲名では同名別録音を取り違える。
    let songId: String

    var body: some View {
        Button {
            MusicKitService.shared.togglePreview(url: url, songId: songId)
        } label: {
            HStack {
                Label {
                    if isCurrentlyPlaying {
                        Text("再生中…")
                    } else {
                        Text("30秒プレビュー")
                    }
                } icon: {
                    Image(systemName: isCurrentlyPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.imasTitle3)
                        .foregroundStyle(isCurrentlyPlaying ? .red : DS.sys)
                }
                Spacer()
            }
        }
    }

    private var isCurrentlyPlaying: Bool {
        MusicKitService.shared.isPlaying(songId: songId)
    }
}
