import SwiftUI
import MusicKit

struct IntroGameSetupView: View {
    @Environment(AppDatabase.self) private var database

    /// 曲一覧の絞り込みをそのまま出題プールにする場合のプリセット (nil ならブランド選択)。
    var presetPool: [Song]? = nil
    var presetLabel: String? = nil

    /// 設定画面内で「絞り込んで出題」から曲一覧を開いて選び直したプリセット。
    @State private var pickedPool: [Song]? = nil
    @State private var pickedLabel: String? = nil

    /// 遷移中か。子が dismiss() したときに route を倒すための橋渡し。
    private var isPushingRoute: Binding<Bool> {
        Binding(
            get: { pushedRoute != nil },
            set: { if !$0 { pushedRoute = nil } }
        )
    }

    /// 実際に使う出題範囲 (アプリ内で選び直したものを優先)。
    private var effectivePool: [Song]? { pickedPool ?? presetPool }
    private var effectiveLabel: String? { pickedLabel ?? presetLabel }

    @State private var session = IntroGameSession()
    @State private var partySession = IntroPartySession()
    /// 結果画面の「ホームに戻る」を Game 経由で受け取るシグナル。
    @State private var exitSignal = IntroDonExitSignal()
    @Environment(\.dismiss) private var dismiss
    @State private var brands: [Brand] = []
    @State private var selectedBrandIds: Set<String> = []
    @State private var mode: IntroGameMode = .normal
    @State private var answerMode: IntroAnswerMode = .choices
    @AppStorage("introPlaybackMode") private var playbackRaw: String = IntroPlaybackMode.full.rawValue
    private var playback: IntroPlaybackMode { IntroPlaybackMode(rawValue: playbackRaw) ?? .full }
    @State private var questionCount: Int = 10
    @State private var introDuration: TimeInterval = 5.0
    @State private var rushTimeLimit: TimeInterval = 60
    @State private var isLoading = false
    @State private var showAdvanced = false
    /// 設定画面から進む先 (navigationDestination は下の 1 つだけで捌く)。
    private enum PushedRoute { case game, songFilter, party }
    @State private var pushedRoute: PushedRoute? = nil
    /// 解決済みの String ではなく文言の値で持ち、画面で文字列にする。
    @State private var errorMessage: DisplayText? = nil
    @State private var authStatus: MusicAuthorization.Status = MusicKitService.shared.authorizationStatus

    private let questionCounts = [5, 10, 20]
    /// ラッシュの制限時間 (秒)。ボタンには数字と単位 (秒) を分けて出す。
    private let rushTimes: [TimeInterval] = [30, 60, 120]
    /// イントロ再生時間の選択肢。seconds は表示用の数字 (setup.seconds の引数)。
    /// 文言はロケールを抱えるので保持せず、読むたびに作る。
    private var durations: [(seconds: String, sub: LocalizedStringResource, value: TimeInterval)] {
        [
            ("0.2", L10n.Introdon.setupDurationUltra, 0.2),
            ("2", L10n.Introdon.setupDurationPlay, 2.0),
            ("5", L10n.Introdon.setupDurationPlay, 5.0),
            ("10", L10n.Introdon.setupDurationPlay, 10.0),
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // ① モード (先に決める)
                IDSectionLabel(text: String(localized: L10n.Introdon.setupModeHeader))
                    .padding(.horizontal, DS.sp6)
                Spacer().frame(height: 12)
                modeSection
                    .padding(.horizontal, DS.sp6)

                // ② 出題範囲: プリセット(曲一覧の絞り込み) があればそれを表示、無ければブランド選択。
                Spacer().frame(height: 24)
                IDSectionLabel(text: String(localized: L10n.Introdon.setupRangeHeader),
                               hint: effectivePool == nil ? String(localized: L10n.Introdon.setupRangeHint) : nil)
                    .padding(.horizontal, DS.sp6)
                Spacer().frame(height: 12)
                if let pool = effectivePool {
                    presetRangeCard(count: IntroGameSession.playable(pool).count)
                        .padding(.horizontal, DS.sp6)
                    Spacer().frame(height: 10)
                    refineButton(title: L10n.Introdon.setupRangeChange)
                        .padding(.horizontal, DS.sp6)
                } else {
                    brandSection
                        .padding(.horizontal, DS.sp6)
                    Spacer().frame(height: 10)
                    refineButton(title: L10n.Introdon.setupRangeRefine)
                        .padding(.horizontal, DS.sp6)
                }

                // ③ モード別の設定 (必要な項目だけ出す)
                modeSpecificSection

                // ④ 詳細設定 (折りたたみ): 再生方式・難易度
                Spacer().frame(height: 24)
                advancedSection
                    .padding(.horizontal, DS.sp6)

                if authStatus != .authorized {
                    Spacer().frame(height: 20)
                    authWarningCard
                        .padding(.horizontal, DS.sp6)
                }

                if let err = errorMessage {
                    Spacer().frame(height: 16)
                    errorCard(err)
                        .padding(.horizontal, DS.sp6)
                }

                Spacer().frame(height: 32)

                IDActionButton(
                    title: String(localized: isLoading ? L10n.Introdon.loadingGenerating : L10n.Introdon.setupActionStart),
                    icon: isLoading ? nil : "play.fill",
                    style: .primary,
                    isLoading: isLoading
                ) {
                    AppAnalytics.tap("intro_game_setup.start")
                    Task { await startGame() }
                }
                .padding(.horizontal, DS.sp6)

                Spacer().frame(height: 32)
            }
            .padding(.top, DS.sp5)
        }
        .background(ID.menuBg.ignoresSafeArea())
        .navigationTitle(L10n.Introdon.setupTitle)
        .navigationBarTitleDisplayMode(.inline)
        // **遷移先はここ 1 つだけ。** 同じ View に navigationDestination(isPresented:) を
        // 複数重ねるのは Apple が非サポートとしている書き方で、どれが使われるか保証がない
        // (ゲーム / 曲フィルター / パーティの 3 つを並べていた)。**ここに 2 つ目を足さず、
        // PushedRoute に case を足すこと。**
        .navigationDestination(isPresented: isPushingRoute) {
            switch pushedRoute {
            case .game:
                IntroGameView(session: session, exitSignal: exitSignal)
            case .songFilter:
                // 曲一覧でタグ/担当/検索などで絞り込み →「この範囲で出題」で設定に戻りプール反映。
                SongListView(
                    selectionMode: true,
                    onSelectPool: { pool, label in
                        pickedPool = pool
                        pickedLabel = label
                        pushedRoute = nil
                    }
                )
                .environment(database)
            case .party:
                IntroPartyGameView(session: partySession)
            case nil:
                EmptyView()
            }
        }
        // 「ホームに戻る」: Game が自分を pop してここが見えるようになった後に届く。
        // (隠れている間は SwiftUI が onChange を走らせないので、Game 側で拾わせない)
        .onChange(of: exitSignal.exitToHomeToken) { _, _ in
            dismiss()
        }
        .task {
            brands = (try? await AppContainer.shared.brandReading.brands()) ?? []
        }
        .trackScreen("intro_game_setup")
    }

    // MARK: - Brand Section

    /// ブランド選択 = 曲フィルターと同じ丸アイコングリッド (BrandIconCell)。複数選択可・空=全て。
    private var brandSection: some View {
        let columns = [GridItem(.adaptive(minimum: 56, maximum: 80), spacing: 10)]
        return LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            BrandIconCell(brandId: nil, label: String(localized: L10n.Introdon.setupBrandAll),
                          iconText: String(localized: L10n.Introdon.setupBrandAllIcon), color: nil,
                          isSelected: selectedBrandIds.isEmpty) {
                withAnimation(.easeInOut(duration: 0.15)) { selectedBrandIds = [] }
            }
            ForEach(brands) { brand in
                BrandIconCell(brandId: brand.id, label: brand.shortName, iconText: brand.iconText,
                              color: brand.color, isSelected: selectedBrandIds.contains(brand.id)) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if !selectedBrandIds.insert(brand.id).inserted {
                            selectedBrandIds.remove(brand.id)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Count / Duration Sections

    private var countSection: some View {
        HStack(spacing: DS.sp3) {
            ForEach(questionCounts, id: \.self) { n in
                IDSegmentButton(
                    primary: .verbatim("\(n)"),
                    secondary: .key(L10n.Introdon.setupUnitQuestions),
                    selected: questionCount == n
                ) {
                    withAnimation(.easeInOut(duration: 0.15)) { questionCount = n }
                }
            }
        }
    }

    private var durationSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: DS.sp3) {
                ForEach(durations, id: \.value) { d in
                    IDSegmentButton(
                        primary: .key(L10n.Introdon.setupSeconds(seconds: d.seconds)),
                        secondary: .key(d.sub),
                        selected: abs(introDuration - d.value) < 0.001
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) { introDuration = d.value }
                    }
                }
            }

            // 細かく秒数を決めるスライダー (0.2〜10秒)。超イントロ(1秒未満)も自由に。
            VStack(spacing: 6) {
                HStack {
                    Text(introDuration < 1.0 ? L10n.Introdon.setupDurationUltra : L10n.Introdon.setupDurationSliderLabel)
                        .font(ID.font(12, weight: .semibold))
                        .foregroundColor(introDuration < 1.0 ? ID.accentGold : ID.menuTextSecondary)
                    Spacer()
                    Text(L10n.Introdon.setupSeconds(seconds: String(format: "%.1f", introDuration)))
                        .font(ID.font(14, weight: .bold))
                        .foregroundColor(ID.menuText)
                        .monospacedDigit()
                }
                Slider(value: $introDuration, in: 0.2...10.0, step: 0.1)
                    .tint(ID.accentGold)
            }
        }
    }

    /// タグ・担当・検索で細かく絞って出題したい時に曲一覧へ飛ぶボタン。
    private func refineButton(title: LocalizedStringResource) -> some View {
        Button {
            AppAnalytics.tap("intro_game_setup.refine")
            pushedRoute = .songFilter
        } label: {
            HStack(spacing: DS.sp3) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.imasScaled( 14, weight: .semibold))
                Text(title)
                    .font(ID.font(13, weight: .semibold))
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.imasScaled( 12, weight: .semibold))
            }
            .foregroundColor(ID.accentPurple)
            .padding(.horizontal, 14)
            .padding(.vertical, DS.sp4)
            .background(ID.accentPurple.opacity(0.08))
            .clipShape(IDCorner(radius: 12))
        }
        .idPress()
    }

    /// 出題範囲: 曲一覧の絞り込みプリセットの表示カード。
    private func presetRangeCard(count: Int) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.imasScaled( 18, weight: .bold))
                .foregroundColor(ID.accentPurple)
            VStack(alignment: .leading, spacing: DS.sp1) {
                // 曲一覧が作った絞り込みの説明はそのまま出す (データ)。無ければ既定の見出し。
                Text(display: effectiveLabel.map(DisplayText.verbatim) ?? .key(L10n.Introdon.setupRangePresetDefault))
                    .font(ID.font(14, weight: .bold))
                    .foregroundColor(ID.menuText)
                    .lineLimit(1)
                Text(L10n.Introdon.setupRangeSongCount(count: count))
                    .font(.imasCaption)
                    .foregroundColor(ID.menuTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(ID.menuCardSubtle)
        .clipShape(IDCorner(radius: 14))
    }

    // MARK: - Section layout helpers

    /// 見出し付きセクション (上に余白 + ラベル + 中身)。
    @ViewBuilder
    private func labeledSection<C: View>(_ title: LocalizedStringResource, hint: LocalizedStringResource? = nil,
                                         @ViewBuilder _ content: () -> C) -> some View {
        Spacer().frame(height: 24)
        IDSectionLabel(text: String(localized: title), hint: hint.map { String(localized: $0) }).padding(.horizontal, DS.sp6)
        Spacer().frame(height: 12)
        content().padding(.horizontal, DS.sp6)
    }

    /// ③ モード別に必要な設定だけ出す。
    @ViewBuilder
    private var modeSpecificSection: some View {
        switch mode {
        case .normal:
            labeledSection(L10n.Introdon.setupAnswerModeHeader) { answerModeSection }
            labeledSection(L10n.Introdon.setupCountHeader) { countSection }
        case .rush:
            labeledSection(L10n.Introdon.setupRushTimeHeader) { rushTimeSection }
        case .allSongs:
            Spacer().frame(height: 20)
            allSongsNote.padding(.horizontal, DS.sp6)
        case .party:
            labeledSection(L10n.Introdon.setupRoundsHeader) { countSection }
        }
    }

    private var allSongsNote: some View {
        HStack(spacing: 10) {
            Image(systemName: "infinity")
                .font(.imasScaled( 16, weight: .bold))
                .foregroundColor(ID.accentGold)
            Text(L10n.Introdon.setupAllSongsNote)
                .font(.imasCaption)
                .foregroundColor(ID.menuTextSecondary)
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(ID.accentGold.opacity(0.08))
        .clipShape(IDCorner(radius: 14))
    }

    /// ④ 詳細設定 (折りたたみ): 再生方式・難易度。
    private var advancedSection: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showAdvanced.toggle() }
            } label: {
                HStack {
                    Text(L10n.Introdon.setupAdvancedHeader)
                        .font(ID.font(11, weight: .bold))
                        .tracking(2)
                        .foregroundColor(ID.menuTextMuted)
                    Spacer()
                    Image(systemName: showAdvanced ? "chevron.up" : "chevron.down")
                        .font(.imasScaled( 12, weight: .bold))
                        .foregroundColor(ID.menuTextMuted)
                }
                .padding(.vertical, 6)
            }
            .idPress()

            if showAdvanced {
                VStack(spacing: 18) {
                    advancedBlock(L10n.Introdon.setupPlaybackHeader) { playbackSection }
                    if mode == .normal || mode == .party {
                        advancedBlock(L10n.Introdon.setupDurationHeader) { durationSection }
                    }
                }
                .padding(.top, 14)
            }
        }
    }

    @ViewBuilder
    private func advancedBlock<C: View>(_ title: LocalizedStringResource, @ViewBuilder _ content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(ID.font(11, weight: .bold))
                .tracking(1.5)
                .foregroundColor(ID.menuTextMuted)
            content()
        }
    }

    // MARK: - Mode / Answer Mode

    private var modeSection: some View {
        VStack(spacing: DS.sp3) {
            modeRow(.normal, icon: "list.number", title: L10n.Introdon.modeNormalName, sub: L10n.Introdon.modeNormalCaption)
            modeRow(.rush, icon: "timer", title: L10n.Introdon.modeRushName, sub: L10n.Introdon.modeRushCaption)
            modeRow(.allSongs, icon: "infinity", title: L10n.Introdon.modeAllSongsName, sub: L10n.Introdon.modeAllSongsCaption)
            modeRow(.party, icon: "person.2.fill", title: L10n.Introdon.modePartyName, sub: L10n.Introdon.modePartyCaption)
        }
    }

    private func modeRow(_ m: IntroGameMode, icon: String, title: LocalizedStringResource,
                         sub: LocalizedStringResource) -> some View {
        let selected = mode == m
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { mode = m }
        } label: {
            HStack(spacing: DS.sp4) {
                Image(systemName: icon)
                    .font(.imasScaled( 16, weight: .semibold))
                    .foregroundColor(selected ? ID.menuCardDarkText : ID.accentPurple)
                    .frame(width: 36, height: 36)
                    .background((selected ? Color.white.opacity(0.18) : ID.accentPurple.opacity(0.10)))
                    .clipShape(IDCorner(radius: 10))
                VStack(alignment: .leading, spacing: DS.sp1) {
                    Text(title)
                        .font(ID.font(15, weight: .bold))
                        .foregroundColor(selected ? ID.menuCardDarkText : ID.menuText)
                    Text(sub)
                        .font(ID.font(11, weight: .semibold))
                        .foregroundColor(selected ? ID.menuCardDarkText.opacity(0.8) : ID.menuTextSecondary)
                }
                Spacer()
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ID.menuCardDarkText)
                        .font(.imasScaled( 18))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, DS.sp4)
            .background(selected ? ID.menuCardDark : ID.menuCardSubtle)
            .clipShape(IDCorner(radius: 14))
        }
        .idPress()
    }

    private var answerModeSection: some View {
        HStack(spacing: DS.sp3) {
            answerModeButton(.choices, icon: "square.grid.2x2.fill",
                             title: L10n.Introdon.answerModeChoicesName, sub: L10n.Introdon.answerModeChoicesCaption)
            answerModeButton(.voice, icon: "mic.fill",
                             title: L10n.Introdon.answerModeVoiceName, sub: L10n.Introdon.answerModeVoiceCaption)
        }
    }

    private func answerModeButton(_ a: IntroAnswerMode, icon: String, title: LocalizedStringResource,
                                  sub: LocalizedStringResource) -> some View {
        let selected = answerMode == a
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { answerMode = a }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.imasScaled( 18, weight: .semibold))
                Text(title)
                    .font(ID.font(15, weight: .bold))
                Text(sub)
                    .font(ID.font(10, weight: .semibold))
            }
            .foregroundColor(selected ? ID.menuCardDarkText : ID.menuTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DS.sp5)
            .background(selected ? ID.menuCardDark : ID.menuCardSubtle)
            .clipShape(IDCorner(radius: 16))
        }
        .idPress()
    }

    private var playbackSection: some View {
        HStack(spacing: DS.sp3) {
            playbackButton(.full, icon: "music.note",
                           title: L10n.Introdon.playbackFullName, sub: L10n.Introdon.playbackFullCaption)
            playbackButton(.preview, icon: "bolt.fill",
                           title: L10n.Introdon.playbackPreviewName, sub: L10n.Introdon.playbackPreviewCaption)
        }
    }

    private func playbackButton(_ p: IntroPlaybackMode, icon: String, title: LocalizedStringResource,
                                sub: LocalizedStringResource) -> some View {
        let selected = playback == p
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { playbackRaw = p.rawValue }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.imasScaled( 18, weight: .semibold))
                Text(title)
                    .font(ID.font(15, weight: .bold))
                Text(sub)
                    .font(ID.font(10, weight: .semibold))
            }
            .foregroundColor(selected ? ID.menuCardDarkText : ID.menuTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DS.sp5)
            .background(selected ? ID.menuCardDark : ID.menuCardSubtle)
            .clipShape(IDCorner(radius: 16))
        }
        .idPress()
    }

    private var rushTimeSection: some View {
        HStack(spacing: DS.sp3) {
            ForEach(rushTimes, id: \.self) { t in
                // 数字は整数にして出す (TimeInterval をそのまま補間すると "30.0")。単位は下の行に分ける。
                IDSegmentButton(
                    primary: .verbatim("\(Int(t))"),
                    secondary: .key(L10n.Introdon.setupUnitSeconds),
                    selected: abs(rushTimeLimit - t) < 0.001
                ) {
                    withAnimation(.easeInOut(duration: 0.15)) { rushTimeLimit = t }
                }
            }
        }
    }

    // MARK: - Warnings / Error

    private var authWarningCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: DS.sp3) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(ID.accentGold)
                Text(L10n.Introdon.authWarning)
                    .font(ID.font(13, weight: .semibold))
                    .foregroundColor(ID.menuText)
                Spacer()
            }
            IDActionButton(title: String(localized: L10n.Introdon.authActionAllow), style: .secondary) {
                AppAnalytics.tap("intro_game_setup.music_auth")
                Task {
                    await MusicKitService.shared.requestAuthorization(includingMediaLibrary: true)
                    authStatus = MusicKitService.shared.authorizationStatus
                }
            }
        }
        .padding(14)
        .background(ID.accentGold.opacity(0.08))
        .clipShape(IDCorner(radius: 14))
    }

    private func errorCard(_ msg: DisplayText) -> some View {
        HStack(spacing: DS.sp3) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(ID.incorrect)
            Text(display: msg)
                .font(.imasFootnote)
                .foregroundColor(ID.menuText)
            Spacer()
        }
        .padding(14)
        .background(ID.incorrect.opacity(0.08))
        .clipShape(IDCorner(radius: 14))
    }

    // MARK: - Start

    private func startGame() async {
        guard !isLoading else { return }
        errorMessage = nil
        isLoading = true

        if MusicKitService.shared.authorizationStatus == .notDetermined {
            await MusicKitService.shared.requestAuthorization(includingMediaLibrary: true)
            authStatus = MusicKitService.shared.authorizationStatus
        }

        let settings = IntroGameSettings(
            mode: mode,
            answerMode: answerMode,
            playback: playback,
            questionCount: questionCount,
            introDuration: introDuration,
            rushTimeLimit: rushTimeLimit,
            selectedBrandIds: selectedBrandIds.isEmpty ? nil : selectedBrandIds
        )

        do {
            if mode == .party {
                partySession.settings = settings
                partySession.presetPool = effectivePool
                try await partySession.generateQuestions(database: database)
                if partySession.questions.isEmpty {
                    errorMessage = .key(L10n.Introdon.errorNoSongs)
                } else {
                    pushedRoute = .party
                }
            } else {
                session.settings = settings
                session.presetPool = effectivePool
                try await session.generateQuestions(database: database)
                if session.questions.isEmpty {
                    errorMessage = .key(L10n.Introdon.errorNoSongs)
                } else {
                    pushedRoute = .game
                }
            }
        } catch {
            errorMessage = .key(L10n.Introdon.errorGeneric(message: error.localizedDescription))
        }
        isLoading = false
    }
}

// MARK: - IDSegmentButton

private struct IDSegmentButton: View {
    /// 大きな数字 (ただの数字は .verbatim、単位付きの秒数は .key)。
    let primary: DisplayText
    /// 数字の下の小さなラベル (単位・呼び名)。
    let secondary: DisplayText
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DS.sp1) {
                Text(display: primary)
                    .font(ID.font(22, weight: .black))
                Text(display: secondary)
                    .font(ID.font(11, weight: .bold))
            }
            .foregroundColor(selected ? ID.menuCardDarkText : ID.menuTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DS.sp5)
            .background(selected ? ID.menuCardDark : ID.menuCardSubtle)
            .clipShape(IDCorner(radius: 16))
        }
        .idPress()
    }
}
