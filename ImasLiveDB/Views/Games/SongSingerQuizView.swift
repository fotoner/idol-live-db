import SwiftUI

/// ソロ曲クイズ (ヒント式段階採点)。最初は「曲名だけ」で出題し、ヒントを開くほど手がかりが増える
/// 代わりに獲得点が下がる: 曲名だけで正解=3pt / ジャケットを見る=2pt / プレビュー再生=1pt。
/// ジャケットを初手で出すと答え (歌手) がバレるため、開示はヒントで段階制御する。
/// データは songs(song_type=solo) と song_artists(role=original) の事実情報のみ。
///
/// 出題の生成・選択肢の作り方・採点・母集団の条件 (原唱が単独の曲だけ / 歌手が 4 人以上) は
/// imas-core の `domain/quiz_generation.rs` にあり、Android と同じ実装を共有する。
/// この画面が担うのは描画・プレビュー再生・シード調達だけ。
struct SongSingerQuizView: View {

    /// 出題ブランド絞り込み（空集合 = 全ブランド対象）。SongSingerQuizSetupView から渡す。
    let selectedBrandIds: Set<String>

    init(selectedBrandIds: Set<String> = []) {
        self.selectedBrandIds = selectedBrandIds
    }

    /// 1 セッションの出題数 (規則本体はコア。UI は総問数の表示にだけ使う)。
    private var sessionLength: Int { Int(quizSessionLength()) }

    /// 出題の index 参照元。コアが返す `answer` / `choices` はこの配列の位置を指す。
    @State private var singers: [Idol] = []
    /// 出題曲の引き当て表 (コアは曲 id だけを返す)。
    @State private var songById: [String: Song] = [:]
    /// `song_artists(role='original')` の行 (曲名かな順)。母集団の条件 (原唱が単独か・
    /// 外部演者か・ブランド一致) はコアが持つので、ここは行を並べて渡すだけ。
    @State private var rows: [SongQuizOriginalArtistRow] = []
    /// 1 ゲーム分の出題 (コアが 1 回でまとめて生成)。
    @State private var questions: [SongSingerQuizQuestion] = []
    @State private var index = 0
    @State private var selectedId: String?
    @State private var revealed: UInt32 = 0    // 0=曲名のみ / 1=ジャケ / 2=プレビュー
    /// ジャケ/プレビューの開示段階と次のヒント (コアが算出)。
    @State private var hint = SongSingerQuizHintState(currentValue: 0, showArtwork: false,
                                                     canPreview: false, nextHint: nil)
    /// 開示段階ごとの獲得点 ([曲名だけ, ジャケ, 試聴])。
    @State private var stageValues: [Int] = []
    /// 解答済み問題数・正解数・累計ポイント (コアが積み上げる)。
    @State private var tally = QuizTally(asked: 0, correct: 0, points: 0)
    @State private var isLastQuestion = false
    /// 各問の記録 (ペンライト・連続正解・見直す)。
    @State private var plays: [QuizStagePlay] = []
    /// 直前の問題の判定 (解答後に出す大きなカード)。
    @State private var verdict: QuizVerdict?
    @State private var scoreBefore = 0
    @State private var result: QuizSessionResult?
    @State private var isNewBest = false
    @State private var previousBest: Int?
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss

    private var question: SongSingerQuizQuestion? {
        questions.indices.contains(index) ? questions[index] : nil
    }

    private var header: QuizStageHeader {
        if let result { return .result(total: Int(result.questions)) }
        guard let q = question, songById[q.songId] != nil, !isLoading else { return .none }
        return .question(current: min(plays.count + (verdict == nil ? 1 : 0), sessionLength),
                         total: sessionLength, points: Int(tally.points))
    }

    var body: some View {
        QuizStageScaffold(title: "ソロ曲クイズ", header: header, onClose: { dismiss() }) {
            content
        }
        .onDisappear { MusicKitService.shared.stop() }
        .task { await load() }
        .trackScreen("song_singer_quiz")
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ImasInlineLoading(tint: QS.ink)
        } else if let result {
            QuizStageResultView(result: result, kind: .songSingerQuiz, isNewBest: isNewBest,
                                previousBest: previousBest,
                                slots: plays.penlights(total: Int(result.questions), answering: false),
                                longestStreak: plays.longestStreak, misses: plays.misses,
                                onReplay: { restart() }, onClose: { dismiss() })
        } else if let q = question, let song = songById[q.songId] {
            QuizStageProgress(slots: plays.penlights(total: sessionLength, answering: verdict == nil),
                              caption: plays.setlistCaption(total: sessionLength),
                              streak: plays.streak, streakBrokeAt: plays.streakBrokeAt)
                .padding(.bottom, 2)
            if let verdict {
                QuizVerdictCard(verdict: verdict).id(verdict.number)
                QuizVerdictStats(before: scoreBefore, after: Int(tally.points), streak: plays.streak)
                if !verdict.isCorrect { QuizVerdictFootnote() }
                QuizStageNextButton(isLastQuestion: isLastQuestion, onNext: nextQuestion, onFinish: finish)
                    .padding(.top, 4)
            } else {
                ticket(song)
                QuizStageChoiceGrid(choices: choices(q).map { QuizStageChoice(id: $0.id, title: $0.name) }) { choice in
                    if let idol = singers.first(where: { $0.id == choice.id }) { pick(idol, song: song) }
                }
                .padding(.top, 4)
            }
        } else {
            ImasEmptyState(systemImage: "music.note", title: "出題できるソロ曲が不足しています")
        }
    }

    // MARK: - チケット

    /// 曲名を大きく載せ、ジャケット (ヒント1) を開いたら横に出す。プレビューは「ヒント2」。
    /// ジャケットを初手で出すと答え (歌手) がバレるため、開示はコアの段階に従う。
    private func ticket(_ song: Song) -> some View {
        let hasPreview = !(song.previewUrl ?? "").isEmpty
        return QuizTicket {
            QuizTicketTitleBlock(label: "SOLO SONG", question: "この曲を歌っているのは？",
                                 value: Int(hint.currentValue), base: stageValues.first ?? 0) {
                HStack(alignment: .center, spacing: 14) {
                    if hint.showArtwork {
                        ArtworkImageView(url: URL(string: song.artworkUrl ?? ""), size: 84,
                                         previewURL: hint.canPreview ? song.previewUrl.flatMap { URL(string: $0) } : nil,
                                         songTitle: song.title, songId: song.id, seed: nil)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(song.title)
                            .font(QS.text(hint.showArtwork ? 30 : 40, weight: .black))
                            .lineLimit(3).minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                        if let cd = song.cdTitle, !cd.isEmpty {
                            Text(cd).font(QS.text(12)).foregroundStyle(QS.paperSub).lineLimit(1)
                        }
                    }
                }
                .padding(.top, 6)
            }
            QuizTicketNotch()
            QuizTicketHintTiles {
                QuizTicketHintTile(title: "ジャケット", phase: revealed >= 1 ? .open(value: "表示中")
                                   : .available(cost: cost(1), action: { openHint(1, song: song) }))
                if hasPreview {
                    QuizTicketHintTile(title: "試聴", phase: revealed >= 2 ? .open(value: "再生中")
                                       : revealed == 1 ? .available(cost: cost(2), action: { openHint(2, song: song) })
                                       : .locked(cost: cost(2)))
                }
            }
        }
    }

    /// 段階 n のヒントで下がる点 (コアの段階別の獲得点の差)。
    private func cost(_ stage: Int) -> Int {
        guard stageValues.indices.contains(stage) else { return 0 }
        return stageValues[stage - 1] - stageValues[stage]
    }

    private func openHint(_ stage: UInt32, song: Song) {
        AppAnalytics.tap(stage == 1 ? "song_singer_quiz.hint_artwork" : "song_singer_quiz.hint_preview")
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            revealed = stage
            refreshHint(song)
        }
        if stage == 2, let url = song.previewUrl.flatMap({ URL(string: $0) }) {
            MusicKitService.shared.togglePreview(url: url, songId: song.id)
        }
    }

    // MARK: - 進行

    /// 選択肢に並べるアイドル (コアが返す index を引き当てる)。
    private func choices(_ q: SongSingerQuizQuestion) -> [Idol] {
        q.choices.compactMap { singers.indices.contains(Int($0)) ? singers[Int($0)] : nil }
    }

    private func pick(_ idol: Idol, song: Song) {
        guard selectedId == nil, let q = question else { return }
        AppAnalytics.tap("song_singer_quiz.answer")
        MusicKitService.shared.stop()
        selectedId = idol.id
        let answer = singers[Int(q.answer)]
        scoreBefore = Int(tally.points)
        // 正誤判定・獲得点 (開示段階で決まる)・積み上げはコアがまとめて返す。
        let outcome = songSingerQuizAnswer(revealed: revealed, pickedIdolId: idol.id,
                                           answerIdolId: answer.id, before: tally)
        isLastQuestion = outcome.isLastQuestion
        refreshHint(song)
        let number = plays.count + 1
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            tally = outcome.tally
            plays.append(QuizStagePlay(number: number, isCorrect: outcome.isCorrect,
                                       answerName: answer.name, answerHex: answer.color,
                                       pickedName: outcome.isCorrect ? nil : idol.name))
            verdict = QuizVerdict(isCorrect: outcome.isCorrect, number: number,
                                  answerName: answer.name, answerHex: answer.color,
                                  earned: Int(outcome.earnedPoints), base: stageValues.first ?? 0,
                                  hints: Int(outcome.revealedHints),
                                  pickedName: outcome.isCorrect ? nil : idol.name,
                                  detail: "「\(song.title)」" + (song.cdTitle.map { " · \($0)" } ?? ""))
        }
        UINotificationFeedbackGenerator().notificationOccurred(outcome.isCorrect ? .success : .error)
    }

    private func nextQuestion() {
        MusicKitService.shared.stop()
        selectedId = nil
        revealed = 0
        verdict = nil
        index += 1
        if let song = question.flatMap({ songById[$0.songId] }) { refreshHint(song) }
    }

    private func restart() {
        startSession()
    }

    private func finish() {
        let sessionResult = songSingerQuizSessionResult(tally: tally)
        previousBest = GameProgressStore.shared.previousBestScore(for: .songSingerQuiz)
        // 保存と「自己ベスト更新！」の判定は進捗ストア (コアの game_progress) が 1 回で返す。
        let update = GameProgressStore.shared.recordResult(
            .songSingerQuiz, score: Int(sessionResult.points), outOf: Int(sessionResult.outOf))
        isNewBest = update.isNewBest
        verdict = nil
        result = sessionResult
    }

    // MARK: - Data

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        let solos = (try? await AppContainer.shared.songReading.songs(filter: SongSearchFilter(songType: "solo"), sortOrder: .titleKana, ascending: nil)) ?? []
        let origMap = (try? await AppContainer.shared.showReading.originalArtistIds(songIds: solos.map(\.song.id))) ?? [:]
        let allIdolIds = Set(origMap.values.flatMap { $0 })
        let idols = (try? await AppContainer.shared.idolReading.idols(ids: Array(allIdolIds))) ?? []
        songById = Dictionary(solos.map { ($0.song.id, $0.song) }, uniquingKeysWith: { first, _ in first })
        singers = idols
        rows = songQuizOriginalArtistRows(solos: solos, originalArtistIds: origMap)
        startSession()
    }

    /// 1 ゲーム分の出題をコアに一括生成させる (問題ごとに FFI を呼ばない)。
    private func startSession() {
        var generator = SystemRandomNumberGenerator()
        questions = songSingerQuizSession(rows: rows,
                                          singers: songQuizSingerRefs(singers),
                                          selectedBrandIds: Array(selectedBrandIds),
                                          seed: generator.next())
        index = 0
        selectedId = nil
        revealed = 0
        tally = QuizTally(asked: 0, correct: 0, points: 0)
        isLastQuestion = false
        plays = []
        verdict = nil
        result = nil
        isNewBest = false
        previousBest = nil
        if let song = question.flatMap({ songById[$0.songId] }) { refreshHint(song) }
    }

    /// 開示段階と次のヒントを引き直す (出題が変わった / ヒントを開いた / 解答した とき)。
    private func refreshHint(_ song: Song) {
        let hasPreview = !(song.previewUrl ?? "").isEmpty
        hint = songSingerQuizHintState(revealed: revealed, hasPreview: hasPreview,
                                       answered: selectedId != nil)
        // 段階ごとの獲得点 (曲名だけ / ジャケ / 試聴)。メーターの元値とタイルの「−n」に使う。
        stageValues = (0...2).map {
            Int(songSingerQuizHintState(revealed: UInt32($0), hasPreview: hasPreview, answered: false).currentValue)
        }
    }
}
