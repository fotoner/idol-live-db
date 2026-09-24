import SwiftUI
import UIKit

/// 歌詞クイズの結果シェア画像 (1080×1350)。本家 intro アプリのシェア画像と同じ作りで、
/// 遊んだ曲のジャケットを斜めのモザイクにして全面に敷き、下へ向かって暗くした上に結果を載せる。
///
/// ⚠️ JASRAC 許諾の条件により、**歌詞は 1 文字も載せない**。載せるのは曲名・歌唱・正誤・点・ジャケットだけ
/// (`Models/Lyrics.swift` 冒頭の「共有画像に歌詞を出さない」)。
///
/// NOTE: `ImageRenderer` で固定サイズのキャンバスへ焼くので、フォントは固定 pt
/// (`.system(size:)`) を使う。ジャケットは焼く前に `LyricsQuizShareArtwork.load` で
/// UIImage にしておく (ImageRenderer は LazyImage の非同期ロードを待たない)。
struct LyricsQuizResultShareCard: View {
    let modeLabel: String
    let result: QuizSessionResult
    let items: [LyricsQuizHistoryItem]
    let isNewBest: Bool
    /// artworkUrl → ロード済みジャケット。空ならアプリのペンライト色のタイルで代用する。
    let artworks: [String: UIImage]

    private static let maxRows = 10
    private static let correctColor = Color(red: 0.36, green: 0.86, blue: 0.55)
    private static let missColor = Color.white.opacity(0.38)
    private static let hintColor = Color(red: 1.0, green: 0.78, blue: 0.28)

    private var noHintCorrect: Int { items.filter { $0.isCorrect && $0.revealedHints == 0 }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topBar
            Spacer(minLength: 0)
            hero
            if !items.isEmpty {
                songList.padding(.top, 30)
            }
            footer.padding(.top, 30)
        }
        .padding(.horizontal, 60)
        .padding(.top, 56)
        .padding(.bottom, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LyricsQuizMosaicBackground(images: mosaicImages))
        .environment(\.colorScheme, .dark)
    }

    /// 背景に敷くジャケット (遊んだ順、重複なし)。
    private var mosaicImages: [UIImage] {
        var seen = Set<String>()
        return items.compactMap { item in
            guard let url = item.artworkUrl, seen.insert(url).inserted else { return nil }
            return artworks[url]
        }
    }

    // MARK: - 上: ラベルと自己ベスト

    private var topBar: some View {
        HStack(spacing: 14) {
            Text("LYRICS QUIZ")
                .font(.system(size: 24, weight: .heavy))
                .tracking(9)
                .foregroundColor(.white)
                .padding(.horizontal, 20).padding(.vertical, 10)
                .background(.black.opacity(0.45), in: Capsule())
                .overlay(Capsule().strokeBorder(.white.opacity(0.25), lineWidth: 1.5))
            Spacer(minLength: 0)
            if isNewBest {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill").font(.system(size: 22, weight: .bold))
                    Text("自己ベスト更新").font(.system(size: 24, weight: .heavy))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 20).padding(.vertical, 10)
                .background(Self.hintColor, in: Capsule())
            }
        }
    }

    // MARK: - 主役: モード名と正解数・グレード

    private var hero: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("歌詞クイズ")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.7), radius: 10, y: 2)
            Text(modeLabel)
                .font(.system(size: 104, weight: .black))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 16, y: 4)
            HStack(alignment: .bottom, spacing: 0) {
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("\(result.correct)")
                        .font(.system(size: 132, weight: .black, design: .rounded))
                        .monospacedDigit()
                    Text("/\(result.questions)")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .monospacedDigit()
                    Text("正解")
                        .font(.system(size: 40, weight: .heavy))
                        .padding(.leading, 8)
                }
                .foregroundColor(.white)
                // 明るいジャケットの上に乗る高さなので、影で地から剥がす (「/10」が白地に溶けていた)。
                .shadow(color: .black.opacity(0.6), radius: 14, y: 3)
                Spacer(minLength: 0)
                gradeBadge
            }
            HStack(spacing: 16) {
                statChip("\(result.points) / \(result.maxPoints) pt")
                statChip("正答率 \(result.ratePercent)%")
                if noHintCorrect > 0 { statChip("ノーヒント \(noHintCorrect)") }
            }
            .padding(.top, 4)
        }
    }

    private var gradeBadge: some View {
        ZStack {
            Circle().fill(.black.opacity(0.5))
            Circle().strokeBorder(result.grade.color, lineWidth: 9)
            Text(result.grade.label)
                .font(.system(size: 96, weight: .black, design: .rounded))
                .foregroundColor(result.grade.color)
        }
        .frame(width: 164, height: 164)
        .padding(.bottom, 14)
    }

    private func statChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 26, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundColor(.white)
            .padding(.horizontal, 20).padding(.vertical, 10)
            .background(.white.opacity(0.14), in: Capsule())
    }

    // MARK: - 出題した曲 (曲名だけ。歌詞は載せない)

    private var songList: some View {
        let shown = Array(items.prefix(Self.maxRows))
        let extra = items.count - shown.count
        return VStack(spacing: 10) {
            ForEach(shown) { item in
                HStack(spacing: 18) {
                    Image(systemName: item.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(item.isCorrect ? Self.correctColor : Self.missColor)
                    thumbnail(item)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.songTitle)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(item.isCorrect ? .white : .white.opacity(0.62))
                            .lineLimit(1)
                        if !item.singer.isEmpty {
                            Text(item.singer)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                                .lineLimit(1)
                        }
                    }
                    Spacer(minLength: 0)
                    if item.revealedHints > 0 {
                        HStack(spacing: 2) {
                            ForEach(0..<item.revealedHints, id: \.self) { _ in
                                Image(systemName: "lightbulb.fill").font(.system(size: 17))
                            }
                        }
                        .foregroundColor(Self.hintColor)
                    }
                    Text(item.earnedPoints > 0 ? "+\(item.earnedPoints)" : "0")
                        .font(.system(size: 27, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(item.earnedPoints > 0 ? Self.correctColor : Self.missColor)
                        .frame(width: 64, alignment: .trailing)
                }
                .frame(height: 50)
            }
            if extra > 0 {
                Text("ほか \(extra)曲")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 26)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous)
            .strokeBorder(.white.opacity(0.12), lineWidth: 1.5))
    }

    @ViewBuilder
    private func thumbnail(_ item: LyricsQuizHistoryItem) -> some View {
        let shape = RoundedRectangle(cornerRadius: 8, style: .continuous)
        if let url = item.artworkUrl, let image = artworks[url] {
            Image(uiImage: image).resizable().scaledToFill()
                .frame(width: 48, height: 48).clipShape(shape)
        } else {
            shape.fill(.white.opacity(0.12))
                .frame(width: 48, height: 48)
                .overlay(Image(systemName: "music.note").font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.5)))
        }
    }

    // MARK: - 下: アプリの宣伝

    private var footer: some View {
        HStack(spacing: 20) {
            Image("LaunchLogo").resizable().scaledToFit()
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
                .shadow(color: .black.opacity(0.4), radius: 8, y: 2)
            VStack(alignment: .leading, spacing: 4) {
                Text("アイドルライブDB")
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(.white)
                Text("App Storeで「アイドルライブDB」")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer(minLength: 0)
            Text("あなたは\n何曲わかる？")
                .font(.system(size: 24, weight: .heavy))
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

/// ジャケットを斜めに敷き詰めた背景 + 下へ向かって暗くするグラデーション。
private struct LyricsQuizMosaicBackground: View {
    let images: [UIImage]

    private static let tile: CGFloat = 250
    private static let gap: CGFloat = 14
    private static let columns = 8
    private static let rows = 9
    /// ジャケットが無いときの代わり (アプリアイコンのペンライト帯の色)。
    private static let fallback: [Color] = [
        Color(red: 0.93, green: 0.13, blue: 0.16), Color(red: 0.95, green: 0.60, blue: 0.10),
        Color(red: 0.98, green: 0.76, blue: 0.10), Color(red: 0.10, green: 0.74, blue: 0.56),
        Color(red: 0.42, green: 0.71, blue: 0.73), Color(red: 0.15, green: 0.50, blue: 0.80),
        Color(red: 0.38, green: 0.41, blue: 0.46),
    ]

    var body: some View {
        // overlay はキャンバスの大きさで置かれるので、はみ出したモザイクもキャンバスで切れる
        Color.black
            .overlay {
                VStack(spacing: Self.gap) {
                    ForEach(0..<Self.rows, id: \.self) { r in
                        HStack(spacing: Self.gap) {
                            ForEach(0..<Self.columns, id: \.self) { c in
                                tile(index: r * Self.columns + c + r * 3)
                            }
                        }
                        // 段ごとに半タイルずらして、同じジャケットが縦に揃わないようにする
                        .offset(x: r.isMultiple(of: 2) ? 0 : (Self.tile + Self.gap) / 2)
                    }
                }
                .fixedSize()
                .rotationEffect(.degrees(-14))
                .opacity(images.isEmpty ? 0.55 : 0.95)
            }
            .overlay {
                LinearGradient(stops: [
                    .init(color: .black.opacity(0.35), location: 0),
                    .init(color: .black.opacity(0.15), location: 0.18),
                    .init(color: .black.opacity(0.62), location: 0.42),
                    .init(color: .black.opacity(0.9), location: 0.7),
                    .init(color: .black.opacity(0.96), location: 1),
                ], startPoint: .top, endPoint: .bottom)
            }
        .clipped()
    }

    @ViewBuilder
    private func tile(index: Int) -> some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)
        if images.isEmpty {
            shape.fill(Self.fallback[index % Self.fallback.count])
                .frame(width: Self.tile, height: Self.tile)
        } else {
            Image(uiImage: images[index % images.count]).resizable().scaledToFill()
                .frame(width: Self.tile, height: Self.tile)
                .clipShape(shape)
        }
    }
}

/// シェア画像に焼くジャケットの事前ロード。結果画面が出た時点で始めておき、
/// シェアボタンが押されたら (待つとしても最大 `timeout` まで) それを使う。
enum LyricsQuizShareArtwork {
    static func load(_ urls: [String], timeout: Duration = .seconds(4)) async -> [String: UIImage] {
        await withTaskGroup(of: (String, UIImage?)?.self) { group in
            for url in urls {
                group.addTask { (url, await ShareCardArtwork.load(from: url)) }
            }
            group.addTask {
                try? await Task.sleep(for: timeout)
                return nil
            }
            var loaded: [String: UIImage] = [:]
            var remaining = urls.count
            while remaining > 0, let next = await group.next() {
                guard let pair = next else { break }  // 時間切れ。取れた分だけで焼く
                remaining -= 1
                if let image = pair.1 { loaded[pair.0] = image }
            }
            group.cancelAll()
            return loaded
        }
    }
}
