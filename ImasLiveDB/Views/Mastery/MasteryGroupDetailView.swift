import SwiftUI

/// 群 (シリーズ / ユニット / 年代) の中の曲一覧。**段階を変えるのはここ**。
///
/// 一覧は「どの群を見るか」までしか出さないので、曲名が要る操作は全部この画面に集める。
/// 1 曲は行末のチップをタップ (1 段上がる) / 行をスワイプ (左で段を選ぶ・右で未設定に戻す)、
/// 群ごとは右上の ⋯ から。一括更新は直前の 1 回だけ戻せる
/// (履歴は持たない — まとめて動くのは一括更新のときだけなので、それ以上は要らない)。
///
/// 行は既存の `SongTitleRow` をそのまま使う (ジャケ写・プレビュー再生・コピーメニューが
/// 付いてくる)。末尾に段階チップを差すだけにして、曲行の見た目を増やさない。
struct MasteryGroupDetailView: View {
    @Environment(AppDatabase.self) private var database
    private var marks: UserMarkService { UserMarkService.shared }

    let title: String
    /// 群に入る曲の id。**Song の実体は押されてから引く**。
    /// 一覧側で `compactMap` して渡すと、行の数だけ全曲走査が走る。
    let songIds: [String]

    @State private var songs: [Song] = []
    @State private var loaded = false

    @State private var undo: UndoState?
    @State private var sheetDestination: DetailDestination?
    /// 段階で絞る。nil = 絞らない、0 = 未設定だけ。
    @State private var levelFilter: UInt8?
    /// 「現地で聴いたのに未設定」だけに絞る。段階の絞り込みとは排他。
    @State private var heardOnly = false

    private struct UndoState {
        let label: String
        let previous: [String: UInt8]
    }

    var body: some View {
        let levels = songs.map { marks.mastery(songId: $0.id) }
        let shown = songs.enumerated().filter { pair in
            if heardOnly {
                return levels[pair.offset] == 0 && marks.isAutoCollected(songId: pair.element.id)
            }
            return levelFilter == nil || levels[pair.offset] == levelFilter
        }

        // ⚠️ ここは **List でなければならない**。`swipeActions` は List の行にしか効かず、
        // ScrollView + LazyVStack に付けても無言で消える (曲一覧 `SongListView` が List
        // なのでそちらだけ動いていた)。行のスワイプが段階を変える主な口なので、
        // 見た目より先にこの条件を満たす。
        return List {
            if loaded {
                summarySection(levels).plainRow(background: DS.bg)
                songHeader(shown, levels: levels).plainRow(background: DS.bg)
                if shown.isEmpty {
                    ImasEmptyState(systemImage: "line.3.horizontal.decrease",
                                   title: "該当する曲がありません",
                                   message: "段階の絞り込みを外してください。")
                        .plainRow(background: DS.bg)
                } else {
                    ForEach(shown, id: \.element.id) { pair in
                        row(pair.element, level: levels[pair.offset])
                            .listRowInsets(EdgeInsets(top: 0, leading: DS.sp5,
                                                      bottom: 0, trailing: DS.sp5))
                            .listRowBackground(DS.surface)
                            .listRowSeparatorTint(DS.sep)
                    }
                }
            } else {
                ImasInlineLoading().padding(.vertical, DS.sp8).plainRow(background: DS.bg)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(DS.bg.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu { bulkMenu(levels) } label: { Image(systemName: "ellipsis.circle") }
                    .accessibilityLabel("まとめて変える")
            }
        }
        .overlay(alignment: .bottom) { undoBar }
        .sheet(item: $sheetDestination) { dest in
            DetailSheetView(destination: dest).environment(database)
        }
        .task { if !loaded { await load() } }
        .trackScreen("mastery_group")
    }

    private func load() async {
        // 並びは群の中の並び (呼び出し側が発売順で渡している) を保つ。
        let fetched = (try? await database.fetchSongsAsync(ids: songIds)) ?? []
        let byId = Dictionary(fetched.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
        songs = songIds.compactMap { byId[$0] }
        loaded = true
    }

    // MARK: - 全体の進捗 (回収率サマリーと同じ組み方)

    private func summarySection(_ levels: [UInt8]) -> some View {
        let total = max(levels.count, 1)
        let steps = marks.scale.steps
        return VStack(alignment: .leading, spacing: DS.sp4) {
            ImasSectionHeader(title: "このグループの習熟度", tight: true)
            HStack(spacing: DS.sp5) {
                MasteryRing(fraction: Double(percent(levels)) / 100)
                    .frame(width: 92, height: 92)
                VStack(alignment: .leading, spacing: DS.sp3) {
                    HStack(alignment: .firstTextBaseline, spacing: DS.sp2) {
                        Text("\(levels.filter { $0 > 0 }.count)")
                            .font(.imasDisplay(30, weight: .bold)).foregroundStyle(DS.ink)
                        Text("/ \(levels.count)曲")
                            .font(.imasDisplay(15)).foregroundStyle(DS.ink2)
                    }
                    Text("段階を付けた曲").font(.imasFootnote).foregroundStyle(DS.ink2)
                    Text("\(marks.scale.label(steps)) \(levels.filter { $0 == steps }.count) 曲")
                        .font(.imasCaption.weight(.semibold)).foregroundStyle(DS.ink3)
                }
                Spacer(minLength: 0)
            }
            .padding(DS.sp5)
            .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))

            VStack(spacing: 0) {
                ForEach(Array((1...Int(steps)).reversed()), id: \.self) { level in
                    let c = levels.filter { $0 == UInt8(level) }.count
                    ImasStatBar(label: marks.scale.label(UInt8(level)), value: "\(c)",
                                percent: Double(c) / Double(total) * 100)
                }
            }
            .padding(.horizontal, DS.sp4)
            .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
        }
    }

    // MARK: - 曲一覧

    /// 曲一覧の見出し (件数 + 段階の絞り込み)。List の 1 行として差す。
    /// `levels` は body で既に出している段階配列をそのまま受け取る (ここで引き直さない)。
    private func songHeader(_ shown: [(offset: Int, element: Song)], levels: [UInt8]) -> some View {
        VStack(alignment: .leading, spacing: DS.sp4) {
            HStack(alignment: .firstTextBaseline) {
                ImasSectionHeader(title: "収録曲", tight: true)
                Spacer(minLength: 12)
                Text(levelFilter == nil && !heardOnly
                     ? "\(songs.count)曲" : "\(shown.count) / \(songs.count)曲")
                    .font(.imasCaption.weight(.semibold)).foregroundStyle(DS.ink3)
            }
            filterChips(levels)
        }
        .padding(.top, DS.sp5)
    }

    // MARK: - ヘッダ

    /// 段階の絞り込み。既存の絞り込みと同じ `ImasFilterChip` を使う。
    private func filterChips(_ levels: [UInt8]) -> some View {
        let heardUnset = songs.enumerated().filter {
            levels[$0.offset] == 0 && marks.isAutoCollected(songId: $0.element.id)
        }.count
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.sp3) {
                if heardUnset > 0 {
                    ImasFilterChip(text: "聴いたのに未設定 \(heardUnset)",
                                   systemImage: "checkmark",
                                   isSelected: heardOnly) {
                        heardOnly.toggle()
                        if heardOnly { levelFilter = nil }
                    }
                }
                ForEach(0...Int(marks.scale.steps), id: \.self) { i in
                    let level = UInt8(i)
                    let count = levels.filter { $0 == level }.count
                    ImasFilterChip(
                        text: "\(marks.scale.shortLabel(level)) \(count)",
                        isSelected: levelFilter == level,
                        isDisabled: count == 0
                    ) {
                        levelFilter = (levelFilter == level) ? nil : level
                        if levelFilter != nil { heardOnly = false }
                    }
                }
            }
        }
    }

    /// 加重%。**body から FFI を呼ばない**: ここは段数と段の本数だけで出せるので、
    /// 曲ごとに `MasterySong` を組んで境界を越えるのは丸損だった
    /// (重みの刻みは core の `masteryWeight` と同じ 1/steps)。
    private func percent(_ levels: [UInt8]) -> UInt32 {
        guard !levels.isEmpty else { return 0 }
        let steps = Double(marks.scale.steps)
        let sum = levels.reduce(0.0) { $0 + Double(min($1, marks.scale.steps)) / steps }
        return UInt32((sum / Double(levels.count) * 100).rounded())
    }

    // MARK: - 行

    /// 行は的を 2 つに分ける: 左 (曲名) は曲の詳細へ、右の段階チップは**押すたびに 1 段上がる**。
    ///
    /// スワイプでしか変えられないと、続けて付けていく作業が 1 曲ごとに止まる
    /// (引っ張って・狙って・離す)。上げるのが一番多い操作なので 1 タップに置き、
    /// 下げる/特定の段へ飛ぶのはチップの長押しと行のスワイプに残した。
    private func row(_ song: Song, level: UInt8) -> some View {
        HStack(spacing: 0) {
            SongTitleRow(song: song, showsChevron: false)
                .contentShape(Rectangle())
                .onTapGesture { sheetDestination = .song(song) }
            if marks.isAutoCollected(songId: song.id) {
                // 現地で聴いた曲。既存の一覧と同じ ✓ の意味で揃える。
                Image(systemName: "checkmark")
                    .font(.imasScaled(11, weight: .semibold))
                    .foregroundStyle(DS.success)
                    .accessibilityLabel("現地で聴いた")
            }
            stageChip(song: song, level: level)
        }
        .padding(.horizontal, DS.sp4)
        .padding(.vertical, DS.sp3)
        .masterySwipe(songId: song.id)
    }

    /// 押すと 1 段上がるチップ。最上段では動かない (連打で記録が飛ばないのは core の規則)。
    /// 行全体ではなくチップだけを的にしているので、詳細を見たいだけのときに書き換わらない。
    private func stageChip(song: Song, level: UInt8) -> some View {
        Button {
            setLevel(song.id, to: nextMasteryLevel(current: level, steps: marks.scale.steps))
        } label: {
            MasteryChip(level: level, scale: marks.scale, showsUnset: true)
                .padding(.vertical, DS.sp2)
                .padding(.leading, DS.sp4)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.increase, trigger: level)
        .accessibilityHint("押すと 1 段上がります。行を左スワイプすると段を選べます")
    }

    private func setLevel(_ songId: String, to level: UInt8) {
        do { try marks.setMastery(songId: songId, level: level) }
        catch { /* 失敗しても一覧は前の値のまま。無言で壊れた値を見せない */ }
    }

    // MARK: - 一括更新

    @ViewBuilder
    private func bulkMenu(_ levels: [UInt8]) -> some View {
        let unsetCount = levels.filter { $0 == 0 }.count
        if unsetCount > 0 {
            Section("未設定の \(unsetCount) 曲だけ") {
                ForEach(1...Int(marks.scale.steps), id: \.self) { level in
                    Button(marks.scale.label(UInt8(level))) {
                        applyBulk(levels, scope: .unsetOnly, level: UInt8(level))
                    }
                }
            }
        }
        Section("この \(songs.count) 曲すべて") {
            ForEach(1...Int(marks.scale.steps), id: \.self) { level in
                Button(marks.scale.label(UInt8(level))) {
                    applyBulk(levels, scope: .all, level: UInt8(level))
                }
            }
            Button("未設定に戻す", role: .destructive) {
                applyBulk(levels, scope: .all, level: 0)
            }
        }
    }

    private func applyBulk(_ levels: [UInt8], scope: MasteryBulkScope, level: UInt8) {
        let ids = songs.map(\.id)
        let targets = masteryBulkTargets(songIds: ids, levels: Data(levels), scope: scope)
        guard !targets.isEmpty else { return }
        var before: [String: UInt8] = [:]
        for id in targets { before[id] = marks.mastery(songId: id) }
        do {
            try marks.setMastery(songIds: targets, level: level)
            withAnimation {
                undo = UndoState(label: "\(targets.count)曲を「\(marks.scale.label(level))」に",
                                 previous: before)
            }
        } catch {
            // 書けなかったときは何も出さない (半端に反映された表示を残さない)
            undo = nil
        }
    }

    @ViewBuilder
    private var undoBar: some View {
        if let u = undo {
            HStack(spacing: DS.sp4) {
                Text(u.label).font(.imasFootnote).lineLimit(1)
                Spacer()
                Button("元に戻す") { revert(u) }.font(.imasFootnote.weight(.bold))
            }
            .padding(.horizontal, DS.sp5)
            .padding(.vertical, DS.sp4)
            .background(DS.sys, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
            .foregroundStyle(DS.onSys)
            .padding(.horizontal, DS.sp5)
            .padding(.bottom, DS.sp4)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .task(id: u.label) {
                try? await Task.sleep(for: .seconds(6))
                withAnimation { undo = nil }
            }
        }
    }

    private func revert(_ u: UndoState) {
        for (id, level) in u.previous {
            try? marks.setMastery(songId: id, level: level)
        }
        withAnimation { undo = nil }
    }
}
