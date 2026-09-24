import SwiftUI

/// 歌詞クイズの結果シェア画像 (1080×1350)。イントロドンの `IntroResultShareCard` と同じ作り
/// (ImageRenderer で焼いて UIActivityViewController で共有) を踏襲する。
///
/// ⚠️ JASRAC 許諾の条件により、**歌詞は 1 文字も載せない**。載せるのは曲名・歌唱・正誤・点だけ
/// (`Models/Lyrics.swift` 冒頭の「共有画像に歌詞を出さない」)。
///
/// NOTE: `ImageRenderer` で固定サイズのキャンバスへ焼くので、フォントは固定 pt
/// (`.system(size:)`) を使う。Dynamic Type に追随させると出力画像のレイアウトが崩れる。
struct LyricsQuizResultShareCard: View {
    let modeLabel: String
    let result: QuizSessionResult
    let items: [LyricsQuizHistoryItem]
    let isNewBest: Bool

    private static let maxRows = 10

    private var noHintCorrect: Int { items.filter { $0.isCorrect && $0.revealedHints == 0 }.count }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, 60)

            Spacer(minLength: 0)

            scoreHero

            Spacer(minLength: 0)

            metrics
                .padding(.horizontal, 56)

            if !items.isEmpty {
                breakdown
                    .padding(.horizontal, 56)
                    .padding(.top, 24)
            }

            Spacer(minLength: 0)

            footer
                .padding(.top, 24)
                .padding(.bottom, 52)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background)
    }

    // MARK: - 背景 (大きな引用符を透かしで敷く = 歌詞のゲームだと一目で分かる)

    private var background: some View {
        ZStack {
            DS.bg
            RadialGradient(colors: [result.grade.color.opacity(0.22), .clear],
                           center: .top, startRadius: 0, endRadius: 760)
            Text("“")
                .font(.system(size: 620, weight: .black, design: .serif))
                .foregroundColor(DS.ink.opacity(0.05))
                .offset(x: -300, y: -330)
            Text("”")
                .font(.system(size: 620, weight: .black, design: .serif))
                .foregroundColor(DS.ink.opacity(0.05))
                .offset(x: 320, y: 420)
        }
    }

    // MARK: - ヘッダ

    private var header: some View {
        VStack(spacing: 14) {
            Text("歌詞クイズ")
                .font(.system(size: 60, weight: .black, design: .rounded))
                .foregroundColor(DS.ink)
            HStack(spacing: 12) {
                Text(modeLabel)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(DS.pick)
                    .padding(.horizontal, 22).padding(.vertical, 8)
                    .background(DS.pick.opacity(0.14), in: Capsule())
                if isNewBest {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill").font(.system(size: 22, weight: .bold))
                        Text("自己ベスト更新").font(.system(size: 26, weight: .bold))
                    }
                    .foregroundColor(DS.favorite)
                    .padding(.horizontal, 22).padding(.vertical, 8)
                    .background(DS.favorite.opacity(0.16), in: Capsule())
                }
            }
        }
    }

    // MARK: - グレード + 大スコア

    private var scoreHero: some View {
        HStack(spacing: 44) {
            ZStack {
                Circle().fill(result.grade.color.opacity(0.14))
                Circle().strokeBorder(result.grade.color, lineWidth: 10)
                Text(result.grade.label)
                    .font(.system(size: 124, weight: .black, design: .rounded))
                    .foregroundColor(result.grade.color)
            }
            .frame(width: 210, height: 210)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text("\(result.points)")
                        .font(.system(size: 112, weight: .black, design: .rounded))
                        .foregroundColor(DS.ink)
                        .monospacedDigit()
                    Text("/ \(result.maxPoints) pt")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(DS.ink2)
                }
                Text(result.comment)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(DS.ink2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 56)
    }

    // MARK: - メトリクス

    private var metrics: some View {
        HStack(spacing: 0) {
            statItem("正解", "\(result.correct)/\(result.questions)")
            divider
            statItem("正答率", "\(result.ratePercent)%")
            divider
            statItem("ノーヒント正解", "\(noHintCorrect)")
        }
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity)
        .background(DS.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var divider: some View {
        Rectangle().fill(DS.ink3.opacity(0.3)).frame(width: 1, height: 56)
    }

    private func statItem(_ label: String, _ value: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 50, weight: .black, design: .rounded))
                .foregroundColor(DS.ink)
                .monospacedDigit()
            Text(label)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(DS.ink2)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 出題の内訳 (曲名だけ。歌詞は載せない)

    private var breakdown: some View {
        let shown = Array(items.prefix(Self.maxRows))
        return VStack(spacing: 8) {
            ForEach(shown) { item in
                HStack(spacing: 18) {
                    Image(systemName: item.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(item.isCorrect ? DS.success : DS.ink3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.songTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(DS.ink)
                            .lineLimit(1)
                        if !item.singer.isEmpty {
                            Text(item.singer)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(DS.ink3)
                                .lineLimit(1)
                        }
                    }
                    Spacer(minLength: 0)
                    if item.revealedHints > 0 {
                        HStack(spacing: 2) {
                            ForEach(0..<item.revealedHints, id: \.self) { _ in
                                Image(systemName: "lightbulb.fill").font(.system(size: 18))
                            }
                        }
                        .foregroundColor(DS.warning)
                    }
                    Text(item.earnedPoints > 0 ? "+\(item.earnedPoints)" : "0")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(item.earnedPoints > 0 ? DS.success : DS.ink3)
                        .monospacedDigit()
                        .frame(width: 56, alignment: .trailing)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
        .background(DS.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // MARK: - フッタ (アプリの宣伝)

    private var footer: some View {
        VStack(spacing: 8) {
            Text("あなたは何曲わかる？")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(DS.ink2)
            Text("App Storeで「アイドルライブDB」")
                .font(.system(size: 34, weight: .black))
                .foregroundColor(DS.ink)
        }
    }
}
