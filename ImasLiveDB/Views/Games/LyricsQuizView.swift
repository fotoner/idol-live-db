import SwiftUI

/// 歌詞クイズ (曲名当て / 続きはどれ)。ヒント式段階採点はソロ曲クイズと同じ (3/2/1pt)。
///
/// 出題順・曲名当ての 4 択・歌詞のどこを出すか・続きはどれの 4 択・採点は imas-core の
/// `domain/lyrics_quiz.rs` にあり、Android と同じ実装を共有する。
/// この画面が担うのは描画・歌詞の取得・シード調達だけ。
///
/// ⚠️ JASRAC 許諾の条件 (一括ダウンロードできない形式) を守るため:
/// - 歌詞は**出題のたびに 1 曲ずつ**取る。先読みは「次の 1 問」まで。
/// - 歌詞の断片は表示中の問題 (と先読みした 1 問) にだけ持つ。振り返り・リザルト・シェアは
///   曲名だけで組み、歌詞を載せない。
struct LyricsQuizView: View {
    let mode: LyricsQuizMode
    /// 同梱 SQLite の曲 (出題の index 参照元)。コアが返す index はこの配列の位置を指す。
    let songs: [SongWithArtists]
    let publishedSongIds: [String]
    let selectedBrandIds: Set<String>

    /// 歌詞が届いて出題できる状態になった 1 問。
    private struct Prepared {
        /// `questions` 内の位置 (次の曲を探す起点)。
        let cursor: Int
        let question: LyricsQuizQuestion
        let excerpt: LyricsQuizExcerpt
    }

    private enum Phase: Equatable {
        case loading
        case playing
        case failed
        case exhausted
    }

    private var sessionLength: Int { Int(quizSessionLength()) }

    @State private var questions: [LyricsQuizQuestion] = []
    @State private var current: Prepared?
    /// 次の 1 問の先読み (解答中に取っておき、「次の問題」で待たせない)。
    @State private var prefetch: Task<Prepared?, Error>?
    @State private var phase: Phase = .loading
    @State private var selectedKey: String?
    @State private var revealed: UInt32 = 0
    @State private var hint = LyricsQuizHintState(currentValue: 0, shown: [], nextHint: nil)
    @State private var tally = QuizTally(asked: 0, correct: 0, points: 0)
    @State private var isLastQuestion = false
    @State private var history: [LyricsQuizHistoryItem] = []
    @State private var result: QuizSessionResult?
    @State private var isNewBest = false
    /// 正誤の手触り (sensoryFeedback のトリガ)。次の問題で nil に戻す。
    @State private var lastCorrect: Bool?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sp5) {
                if let result {
                    QuizResultView(result: result, kind: .lyricsQuiz, isNewBest: isNewBest,
                                   customHistory: history.isEmpty ? nil
                                       : AnyView(LyricsQuizHistoryList(items: history)),
                                   onReplay: { startSession() })
                } else {
                    switch phase {
                    case .loading where current == nil:
                        ImasInlineLoading(tint: DS.sys)
                    case .failed:
                        ImasEmptyState(systemImage: "wifi.exclamationmark",
                                       title: "歌詞を読み込めませんでした",
                                       message: "通信状態を確認して、もう一度お試しください。",
                                       actionTitle: "再試行", action: { retry() })
                    case .exhausted where current == nil:
                        ImasEmptyState(systemImage: "text.quote", title: "出題できる歌詞が不足しています")
                    default:
                        if let p = current { questionBody(p) }
                    }
                }
                JASRACLicenseNotice(placement: .lyrics)
                    .frame(maxWidth: .infinity)
                    .padding(.top, DS.sp3)
            }
            .padding(DS.sp5)
        }
        .background(DS.bg.ignoresSafeArea())
        .scrollContentBackground(.hidden)
        .navigationTitle(mode == .title ? "歌詞クイズ · 曲名当て" : "歌詞クイズ · 続きはどれ")
        .navigationBarTitleDisplayMode(.inline)
        // 解答後の「次の問題」がタブバーに隠れないよう、遊んでいる間は隠す (イントロドンと同じ)。
        .toolbar(.hidden, for: .tabBar)
        .sensoryFeedback(trigger: lastCorrect) { _, new in
            guard let new else { return nil }
            return new ? .success : .error
        }
        .task { startSession() }
        .onDisappear { prefetch?.cancel() }
        .trackScreen("lyrics_quiz")
    }

    // MARK: - 出題

    @ViewBuilder
    private func questionBody(_ p: Prepared) -> some View {
        let answered = selectedKey != nil
        QuizProgressHeader(current: min(Int(tally.asked) + (answered ? 0 : 1), sessionLength),
                           total: sessionLength, points: Int(tally.points))
        Group {
            lyricCard(p)
            if !answered { hintArea() }
            choiceList(p)
        }
        .id(p.cursor)
        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .opacity))
        if answered {
            if phase == .loading {
                // 次の曲の歌詞がまだ届いていない (先読みが間に合わなかった)。
                HStack(spacing: DS.sp3) {
                    ProgressView().tint(DS.sys)
                    Text("次の歌詞を読み込み中…").font(.imasSubhead).foregroundStyle(DS.ink3)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
            } else {
                QuizNextButton(isLastQuestion: isLastQuestion || phase == .exhausted,
                               onNext: nextQuestion, onFinish: finish)
            }
        }
    }

    private func song(_ index: UInt32) -> SongWithArtists? {
        songs.indices.contains(Int(index)) ? songs[Int(index)] : nil
    }

    private func singerText(_ s: SongWithArtists) -> String {
        let label = s.song.singerLabel ?? ""
        return label.isEmpty ? s.artistNames : label
    }

    private func lyricCard(_ p: Prepared) -> some View {
        let answered = selectedKey != nil
        let shown = Set(hint.shown)
        let answerSong = song(p.question.song)
        return VStack(alignment: .leading, spacing: DS.sp4) {
            HStack {
                Text(mode == .title ? "この歌詞の曲は？" : "この歌詞の続きは？")
                    .font(.imasHeadline.weight(.bold)).foregroundStyle(DS.ink)
                Spacer(minLength: 0)
                if !answered { QuizValueBadge(value: Int(hint.currentValue)) }
            }

            // 続きはどれは曲を明かして出題する (知っている曲の続きを当てる遊び)。
            if mode == .nextLine, let s = answerSong {
                songRow(s, caption: nil)
            }

            VStack(alignment: .leading, spacing: DS.sp3) {
                if mode == .nextLine, shown.contains(.previousLine), let prev = p.excerpt.contextLine {
                    lyricLine(prev, style: .context)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                lyricLine(p.excerpt.prompt, style: .prompt)
                if mode == .title, shown.contains(.nextLine), let next = p.excerpt.contextLine {
                    lyricLine(next, style: .context)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                if mode == .nextLine {
                    if answered, p.excerpt.choices.indices.contains(Int(p.excerpt.answer)) {
                        // 解答後は正解の行を歌詞の並びに戻す (曲名当てが続きの行を出すのと揃える)。
                        lyricLine(p.excerpt.choices[Int(p.excerpt.answer)], style: .answer)
                            .transition(.opacity)
                    } else {
                        lyricLine("？？？", style: .blank)
                    }
                }
            }

            if mode == .title, shown.contains(.singer), !answered, let s = answerSong {
                Label(singerText(s), systemImage: "music.microphone")
                    .font(.imasFootnote.weight(.semibold)).foregroundStyle(DS.ink2)
                    .lineLimit(2)
                    .padding(.horizontal, DS.sp4).padding(.vertical, DS.sp2)
                    .background(DS.fill, in: Capsule())
                    .transition(.scale.combined(with: .opacity))
            }

            if mode == .title, answered, let s = answerSong {
                Divider()
                songRow(s, caption: "正解")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.sp5)
        .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rLG, style: .continuous))
    }

    private enum LineStyle { case prompt, context, blank, answer }

    /// 歌詞 1 行。出題行は大きく・左に縦線、ヒントで開いた行は控えめに出す。
    private func lyricLine(_ text: String, style: LineStyle) -> some View {
        HStack(alignment: .top, spacing: DS.sp4) {
            Capsule()
                .fill(barColor(style))
                .frame(width: 3)
            Text(text)
                .font(style == .prompt || style == .answer ? .imasTitle3.weight(.bold) : .imasCallout)
                .foregroundStyle(textColor(style))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func barColor(_ style: LineStyle) -> Color {
        switch style {
        case .prompt:          return DS.sys
        case .answer:          return DS.success
        case .context, .blank: return DS.ink3.opacity(0.5)
        }
    }

    private func textColor(_ style: LineStyle) -> Color {
        switch style {
        case .prompt:  return DS.ink
        case .answer:  return DS.success
        case .context: return DS.ink2
        case .blank:   return DS.ink3
        }
    }

    private func songRow(_ s: SongWithArtists, caption: String?) -> some View {
        HStack(spacing: DS.sp4) {
            ArtworkImageView(url: URL(string: s.song.artworkUrl ?? ""), size: 48,
                             songTitle: s.song.title, songId: s.song.id)
                .clipShape(RoundedRectangle(cornerRadius: DS.rSM, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                if let caption {
                    Text(caption).font(.imasCaption.weight(.bold)).foregroundStyle(DS.success)
                }
                Text(s.song.title).font(.imasSubhead.weight(.bold)).foregroundStyle(DS.ink)
                    .lineLimit(2)
                Text(singerText(s)).font(.imasCaption).foregroundStyle(DS.ink3).lineLimit(1)
            }
            Spacer(minLength: 0)
        }
    }

    // MARK: - ヒント

    @ViewBuilder
    private func hintArea() -> some View {
        if let next = hint.nextHint {
            QuizHintButton(systemImage: hintIcon(next.kind), title: hintTitle(next.kind),
                           nextValue: Int(next.nextValue)) {
                AppAnalytics.tap("lyrics_quiz.hint_\(hintKey(next.kind))")
                withAnimation(.easeInOut(duration: 0.25)) {
                    revealed += 1
                    refreshHint()
                }
            }
        }
    }

    private func hintTitle(_ kind: LyricsQuizHintKind) -> String {
        switch kind {
        case .nextLine:     return "ヒント: 続きの1行を見る"
        case .singer:       return "ヒント: 歌っているのは？"
        case .previousLine: return "ヒント: 前の1行を見る"
        case .fiftyFifty:   return "ヒント: 選択肢を2つに絞る"
        }
    }

    private func hintIcon(_ kind: LyricsQuizHintKind) -> String {
        switch kind {
        case .nextLine:     return "text.append"
        case .singer:       return "music.microphone"
        case .previousLine: return "text.insert"
        case .fiftyFifty:   return "divide.circle"
        }
    }

    private func hintKey(_ kind: LyricsQuizHintKind) -> String {
        switch kind {
        case .nextLine:     return "next_line"
        case .singer:       return "singer"
        case .previousLine: return "previous_line"
        case .fiftyFifty:   return "fifty_fifty"
        }
    }

    // MARK: - 選択肢

    private struct Choice: Identifiable {
        let id: String      // 採点に渡すキー (曲名当て=曲 id / 続きはどれ=位置)
        let text: String
        let song: SongWithArtists?
    }

    private func choices(_ p: Prepared) -> [Choice] {
        switch mode {
        case .title:
            return p.question.choices.compactMap { i in
                song(i).map { Choice(id: $0.song.id, text: $0.song.title, song: $0) }
            }
        case .nextLine:
            return p.excerpt.choices.enumerated().map { Choice(id: String($0.offset), text: $0.element, song: nil) }
        }
    }

    private func answerKey(_ p: Prepared) -> String {
        switch mode {
        case .title:    return song(p.question.song)?.song.id ?? ""
        case .nextLine: return String(p.excerpt.answer)
        }
    }

    private func choiceList(_ p: Prepared) -> some View {
        let answered = selectedKey != nil
        let answer = answerKey(p)
        let hidden: Set<String> = Set(hint.shown).contains(.fiftyFifty) && !answered
            ? Set(p.excerpt.fiftyFiftyHidden.map { String($0) }) : []
        return VStack(spacing: DS.sp3) {
            ForEach(choices(p)) { choice in
                LyricsQuizChoiceButton(
                    text: choice.text,
                    isLyric: mode == .nextLine,
                    song: answered ? choice.song : nil,
                    answered: answered,
                    isAnswer: choice.id == answer,
                    isPicked: choice.id == selectedKey,
                    isEliminated: hidden.contains(choice.id)
                ) {
                    pick(choice, prepared: p)
                }
            }
        }
    }

    // MARK: - 進行

    private func pick(_ choice: Choice, prepared p: Prepared) {
        guard selectedKey == nil else { return }
        AppAnalytics.tap("lyrics_quiz.answer")
        let answer = answerKey(p)
        let outcome = lyricsQuizAnswer(revealed: revealed, picked: choice.id, answer: answer, before: tally)
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedKey = choice.id
            tally = outcome.tally
            isLastQuestion = outcome.isLastQuestion
            refreshHint()
        }
        lastCorrect = outcome.isCorrect
        let answerSong = song(p.question.song)
        history.append(LyricsQuizHistoryItem(
            id: "\(tally.asked)-\(answerSong?.song.id ?? "")",
            index: Int(tally.asked),
            songTitle: answerSong?.song.title ?? "",
            singer: answerSong.map(singerText) ?? "",
            pickedTitle: mode == .title && !outcome.isCorrect ? choice.text : nil,
            isCorrect: outcome.isCorrect,
            earnedPoints: Int(outcome.earnedPoints),
            revealedHints: Int(outcome.revealedHints)
        ))
        if !outcome.isLastQuestion { startPrefetch(after: p.cursor) }
    }

    private func nextQuestion() {
        guard let task = prefetch else { return }
        phase = .loading
        Task {
            do {
                let next = try await task.value
                prefetch = nil
                if let next {
                    withAnimation(.easeInOut(duration: 0.25)) { show(next) }
                } else {
                    // 予備の曲も尽きた。ここまでの成績で結果へ。
                    phase = .exhausted
                    finish()
                }
            } catch {
                prefetch = nil
                phase = .failed
            }
        }
    }

    private func finish() {
        prefetch?.cancel()
        prefetch = nil
        let sessionResult = lyricsQuizSessionResult(tally: tally)
        if tally.asked > 0 {
            let update = GameProgressStore.shared.recordResult(
                .lyricsQuiz, score: Int(sessionResult.points), outOf: Int(sessionResult.outOf))
            isNewBest = update.isNewBest
        }
        withAnimation(.easeInOut(duration: 0.25)) { result = sessionResult }
    }

    private func show(_ p: Prepared) {
        current = p
        selectedKey = nil
        revealed = 0
        lastCorrect = nil
        phase = .playing
        refreshHint()
    }

    private func startSession() {
        prefetch?.cancel()
        prefetch = nil
        var generator = SystemRandomNumberGenerator()
        questions = lyricsQuizSession(songs: lyricsQuizSongRefs(songs),
                                      publishedSongIds: publishedSongIds,
                                      selectedBrandIds: Array(selectedBrandIds),
                                      seed: generator.next())
        current = nil
        selectedKey = nil
        revealed = 0
        tally = QuizTally(asked: 0, correct: 0, points: 0)
        isLastQuestion = false
        history = []
        result = nil
        isNewBest = false
        lastCorrect = nil
        loadFirst()
    }

    private func loadFirst() {
        phase = .loading
        let task = makePrepareTask(from: 0)
        Task {
            do {
                if let p = try await task.value {
                    show(p)
                } else {
                    phase = .exhausted
                }
            } catch {
                phase = .failed
            }
        }
    }

    private func retry() {
        if let p = current {
            // 次の問題の取得で失敗した。解答済みの画面に戻して先読みをやり直す。
            phase = .playing
            startPrefetch(after: p.cursor)
        } else {
            loadFirst()
        }
    }

    private func startPrefetch(after cursor: Int) {
        prefetch?.cancel()
        prefetch = makePrepareTask(from: cursor + 1)
    }

    /// `from` 以降の曲を順に試し、出題できる最初の 1 問を返す (尽きたら nil)。
    /// 歌詞が無い・出題に向かない曲は飛ばす。取得は 1 リクエスト 1 曲。
    private func makePrepareTask(from start: Int) -> Task<Prepared?, Error> {
        let questions = questions
        let songs = songs
        let mode = mode
        let reader = AppContainer.shared.lyricsQuizReading
        return Task {
            var cursor = start
            while cursor < questions.count {
                try Task.checkCancellation()
                let q = questions[cursor]
                guard songs.indices.contains(Int(q.song)) else { cursor += 1; continue }
                let s = songs[Int(q.song)]
                if let lyrics = try await reader.lyrics(songId: s.song.id) {
                    let lines = lyrics.lines.map {
                        LyricsQuizLine(text: $0.text, isLyric: $0.kind == .lyric)
                    }
                    let singer = (s.song.singerLabel ?? "").isEmpty ? s.artistNames : (s.song.singerLabel ?? "")
                    var generator = SystemRandomNumberGenerator()
                    if let excerpt = lyricsQuizExcerpt(lines: lines, songTitle: s.song.title,
                                                       hasSinger: !singer.isEmpty, mode: mode,
                                                       seed: generator.next()) {
                        return Prepared(cursor: cursor, question: q, excerpt: excerpt)
                    }
                }
                cursor += 1
            }
            return nil
        }
    }

    private func refreshHint() {
        hint = lyricsQuizHintState(hints: current?.excerpt.hints ?? [], revealed: revealed,
                                   answered: selectedKey != nil)
    }
}

// MARK: - 選択肢ボタン

/// 歌詞クイズの 4 択。曲名も歌詞の 1 行も長くなりがちなので 1 列で並べ、折り返して全文を出す。
private struct LyricsQuizChoiceButton: View {
    let text: String
    let isLyric: Bool
    let song: SongWithArtists?
    let answered: Bool
    let isAnswer: Bool
    let isPicked: Bool
    /// 50:50 で消した誤答。押せなくし、薄く取り消し線で見せる。
    let isEliminated: Bool
    let action: () -> Void

    var body: some View {
        let bg: Color = {
            guard answered else { return DS.surface }
            if isAnswer { return DS.success.opacity(0.18) }
            if isPicked { return DS.danger.opacity(0.18) }
            return DS.surface
        }()
        let border: Color = answered && (isAnswer || isPicked) ? (isAnswer ? DS.success : DS.danger) : .clear
        Button(action: action) {
            HStack(spacing: DS.sp3) {
                if let song, isAnswer || isPicked {
                    ArtworkImageView(url: URL(string: song.song.artworkUrl ?? ""), size: 34,
                                     songTitle: song.song.title, songId: song.song.id)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                Text(text)
                    .font(isLyric ? .imasCallout.weight(.medium) : .imasSubhead.weight(.semibold))
                    .foregroundStyle(DS.ink)
                    .strikethrough(isEliminated, color: DS.ink3)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                if answered && isAnswer {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(DS.success)
                } else if answered && isPicked {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(DS.danger)
                }
            }
            .padding(.horizontal, DS.sp4).padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .background(bg, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: DS.rMD, style: .continuous).strokeBorder(border, lineWidth: 1.5))
            .contentShape(Rectangle())
            .opacity(isEliminated ? 0.35 : 1)
        }
        .buttonStyle(.plain)
        .disabled(answered || isEliminated)
        .animation(.easeInOut(duration: 0.2), value: isEliminated)
    }
}

// MARK: - 振り返り

/// 1 問分の振り返り。⚠️ 歌詞は載せない (曲名と正誤だけ)。
struct LyricsQuizHistoryItem: Identifiable, Hashable {
    let id: String
    let index: Int
    let songTitle: String
    let singer: String
    /// 曲名当てで誤答したときに選んだ曲名 (それ以外は nil)。
    let pickedTitle: String?
    let isCorrect: Bool
    let earnedPoints: Int
    let revealedHints: Int
}

struct LyricsQuizHistoryList: View {
    let items: [LyricsQuizHistoryItem]

    var body: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet.rectangle.portrait")
                    .font(.imasScaled(13, weight: .semibold)).foregroundStyle(DS.ink2)
                Text("出題の振り返り").font(.imasSubhead.weight(.bold)).foregroundStyle(DS.ink)
                Spacer(minLength: 0)
            }
            VStack(spacing: DS.sp2) {
                ForEach(items) { item in row(item) }
            }
        }
    }

    private func row(_ item: LyricsQuizHistoryItem) -> some View {
        HStack(alignment: .top, spacing: DS.sp3) {
            VStack(spacing: DS.sp1) {
                Text("Q\(item.index)").font(.imasCaption.weight(.bold).monospacedDigit()).foregroundStyle(DS.ink3)
                Image(systemName: item.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.imasCallout)
                    .foregroundStyle(item.isCorrect ? DS.success : DS.danger)
            }
            .frame(width: 36)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.songTitle).font(.imasSubhead.weight(.semibold)).foregroundStyle(DS.ink).lineLimit(2)
                if !item.singer.isEmpty {
                    Text(item.singer).font(.imasCaption).foregroundStyle(DS.ink3).lineLimit(1)
                }
                if let picked = item.pickedTitle {
                    Text("選択: \(picked)").font(.imasCaption.weight(.semibold)).foregroundStyle(DS.danger)
                        .lineLimit(1)
                }
                HStack(spacing: 10) {
                    Label("\(item.earnedPoints)pt", systemImage: "plus.circle.fill")
                        .font(.imasCaption.weight(.semibold).monospacedDigit())
                        .foregroundStyle(item.earnedPoints > 0 ? DS.success : DS.ink3)
                    if item.revealedHints > 0 {
                        Label("ヒント\(item.revealedHints)", systemImage: "lightbulb.fill")
                            .font(.imasCaption.weight(.semibold))
                            .foregroundStyle(DS.warning)
                    }
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .padding(DS.sp3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
    }
}
