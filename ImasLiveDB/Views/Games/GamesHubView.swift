import SwiftUI

/// クイズ・ゲームのハブ。プロデュース → 「クイズ・ゲーム」から push。
/// イントロドン／アイドル当て／ソロ曲／メンバーカラー合わせ／歌詞クイズを束ねる。
///
/// 一覧そのものはアプリ本体と同じ明るい画面のまま、上にだけ「QUIZ STAGE」の
/// チケット (ゲーム画面と同じ暗いステージ色) を置いて、ここから先が会場だと分かるようにする。
struct GamesHubView: View {
    @State private var progress = GameProgressStore.shared

    /// ハブに並べるゲーム定義 (表示順)。
    private struct GameEntry {
        let kind: GameKind
        let systemImage: String
        let title: String
        let blurb: String
    }

    private let entries: [GameEntry] = [
        .init(kind: .idolQuiz, systemImage: "person.fill.questionmark", title: "アイドル当て",
              blurb: "プロフィールから当てる"),
        .init(kind: .songSingerQuiz, systemImage: "music.microphone", title: "ソロ曲クイズ",
              blurb: "曲名から歌っているアイドルを"),
        .init(kind: .lyricsQuiz, systemImage: "text.quote", title: "歌詞クイズ",
              blurb: "曲名当て／続きの行当て"),
        .init(kind: .introDon, systemImage: "music.note.list", title: "イントロドン",
              blurb: "イントロを聴いて曲を当てる"),
        .init(kind: .colorMatch, systemImage: "paintpalette.fill", title: "メンバーカラー合わせ",
              blurb: "名前とイメージカラーを結ぶ"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sp5) {
                stageTicket
                gameList
            }
            .padding(DS.sp5)
        }
        .background(DS.bg.ignoresSafeArea())
        .scrollContentBackground(.hidden)
        .navigationTitle("クイズ・ゲーム")
        .navigationBarTitleDisplayMode(.large)
        .trackScreen("games_hub")
    }

    // MARK: - QUIZ STAGE チケット

    private var totalPlays: Int {
        entries.reduce(0) { $0 + Int(progress.record(for: $1.kind).playCount) }
    }

    /// 自己ベストの正答率をグレードにしたもの (未プレイは nil)。
    private func bestGrade(_ kind: GameKind) -> QuizGrade? {
        progress.bestRatePercent(for: kind).map { quizGradeForRate(ratePercent: UInt32(clamping: $0)) }
    }

    /// いちばん自己ベストの正答率が高いゲーム。
    private var strongest: (entry: GameEntry, grade: QuizGrade)? {
        entries
            .compactMap { e in progress.bestRatePercent(for: e.kind).map { (e, $0) } }
            .max { $0.1 < $1.1 }
            .map { ($0.0, quizGradeForRate(ratePercent: UInt32(clamping: $0.1))) }
    }

    private var stageTicket: some View {
        VStack(spacing: 0) {
            // アプリアイコンの帯 (ペンライトの色)。
            HStack(spacing: 0) {
                ForEach(0..<QS.penlights.count, id: \.self) { i in QS.penlights[i] }
            }
            .frame(height: 6)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Text("@").font(QS.text(14, weight: .black)).foregroundStyle(QS.bg)
                        .frame(width: 22, height: 22)
                        .background(QS.ink, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    Text("QUIZ STAGE").font(QS.mono(11)).tracking(1.3).foregroundStyle(QS.dim)
                }
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("連続プレイ").font(QS.text(12, weight: .bold)).foregroundStyle(QS.dim)
                        HStack(alignment: .lastTextBaseline, spacing: 6) {
                            Text("\(progress.displayStreak)").font(QS.num(56))
                            Text("日").font(QS.text(14, weight: .bold)).foregroundStyle(QS.dim)
                        }
                    }
                    Spacer(minLength: 8)
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("プレイ")
                            Text("\(totalPlays)").fontWeight(.bold).foregroundStyle(QS.ink)
                            Text("回")
                        }
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text("通算")
                            Text("\(progress.totalDays)").fontWeight(.bold).foregroundStyle(QS.ink)
                            Text("日")
                        }
                    }
                    .font(QS.text(12))
                    .foregroundStyle(QS.dim)
                }
            }
            .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 16)

            // 切り取り線 (両端は一覧の背景色で欠ける)。
            HStack(spacing: 0) {
                UnevenRoundedRectangle(bottomTrailingRadius: 9, topTrailingRadius: 9)
                    .fill(DS.bg).frame(width: 9, height: 18)
                Rectangle().fill(.clear).frame(height: 1.5)
                    .overlay(Line().stroke(QS.line, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])))
                    .padding(.horizontal, 6)
                UnevenRoundedRectangle(topLeadingRadius: 9, bottomLeadingRadius: 9)
                    .fill(DS.bg).frame(width: 9, height: 18)
            }
            .accessibilityHidden(true)

            HStack(spacing: 12) {
                if let strongest {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("いちばん得意").font(QS.text(11)).foregroundStyle(QS.dim)
                        Text(strongest.entry.title).font(QS.text(15, weight: .bold)).lineLimit(1)
                    }
                    Spacer(minLength: 8)
                    Text(strongest.grade.label).font(QS.num(34))
                } else {
                    Text("まずは 1 ゲーム遊んでみよう").font(QS.text(15, weight: .bold))
                    Spacer(minLength: 0)
                }
            }
            .foregroundStyle(QS.ink)
            .padding(.leading, 20).padding(.trailing, 20)
            .frame(minHeight: 64)
        }
        .foregroundStyle(QS.ink)
        .background(QS.bg, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: 0, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            return p
        }
    }

    // MARK: - ゲーム一覧

    private var gameList: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            ImasSectionHeader(title: "ゲーム", count: "\(entries.count)")
            ImasListContainer {
                ForEach(Array(entries.enumerated()), id: \.element.kind) { i, entry in
                    if i > 0 { ImasRowDivider(inset: 68) }
                    NavigationLink {
                        destination(for: entry.kind)
                    } label: {
                        gameRow(entry)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func gameRow(_ entry: GameEntry) -> some View {
        let rec = progress.record(for: entry.kind)
        return HStack(spacing: 12) {
            icon(entry)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title).font(.imasBody.weight(.semibold)).foregroundStyle(DS.ink)
                    .lineLimit(1).minimumScaleFactor(0.8)
                Text(entry.blurb).font(.imasFootnote).foregroundStyle(DS.ink3).lineLimit(1)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 1) {
                if rec.hasPlayed, let grade = bestGrade(entry.kind) {
                    Text(grade.label).font(QS.num(22)).foregroundStyle(DS.ink)
                    Text(bestLabel(entry.kind, rec)).font(.imasCaption2).foregroundStyle(DS.ink3)
                } else {
                    Text("未プレイ").font(.imasCaption.weight(.semibold)).foregroundStyle(DS.ink3)
                }
            }
            Image(systemName: "chevron.right")
                .font(.imasScaled(13, weight: .semibold))
                .foregroundStyle(DS.ink3)
        }
        .padding(.horizontal, DS.sp4)
        .frame(minHeight: 64)
        .background(DS.surface)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }

    /// 暗いステージ色のアイコン。メンバーカラーだけ色の 2×2 にする。
    @ViewBuilder
    private func icon(_ entry: GameEntry) -> some View {
        if entry.kind == .colorMatch {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 3), GridItem(.flexible(), spacing: 3)], spacing: 3) {
                ForEach([0, 4, 2, 3], id: \.self) { i in
                    RoundedRectangle(cornerRadius: 4, style: .continuous).fill(QS.penlight(i)).frame(height: 9)
                }
            }
            .padding(9)
            .frame(width: 40, height: 40)
            .background(QS.bg, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            Image(systemName: entry.systemImage)
                .font(.imasScaled(18, weight: .semibold))
                .foregroundStyle(QS.ink)
                .frame(width: 40, height: 40)
                .background(QS.bg, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    /// 最高記録の表示文字列。色合わせは正答率%、クイズ系は獲得ポイント。
    /// 正答率は保存値から引く計算なのでコア (game_progress) に委譲する
    /// (記録が無ければ nil が返るので「—」を出す)。
    private func bestLabel(_ kind: GameKind, _ rec: GameRecord) -> String {
        if kind.scoreIsPercent {
            guard let pct = progress.bestRatePercent(for: kind) else { return "—" }
            return "最高 \(pct)%"
        }
        guard rec.bestOutOf > 0 else { return "—" }
        return "最高 \(rec.bestScore) pt"
    }

    // MARK: - 遷移先

    @ViewBuilder
    private func destination(for kind: GameKind) -> some View {
        switch kind {
        case .introDon: IntroDonHomeView()
        // アイドル当て・ソロ曲はブランド絞り込み設定画面を先に挟む。
        case .idolQuiz: IdolQuizSetupView()
        case .songSingerQuiz: SongSingerQuizSetupView()
        case .colorMatch: ColorMatchGameView()
        case .lyricsQuiz: LyricsQuizSetupView()
        }
    }
}
