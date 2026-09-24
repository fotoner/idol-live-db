import SwiftUI

/// コールガイドの整備状況を 1 枚にまとめた画面 (プロデュース → コールガイド)。
///
/// 3 セクション:
/// 1. コールガイドがある曲 (読みに行く導線)
/// 2. 最近の編集 (誰が書いているかを見せる)
/// 3. 「コール曲」タグが付いているのに未整備 (書き手を募る導線)
///
/// どの行も歌詞タブ (`DetailDestination.songLyrics`) を開くところまでで、編集モードへは
/// 自動で入らない。編集意図を `DetailDestination` に持たせると、DEBUG 限定の
/// `debugStartsEditing` (スクショ検証用) と境界が曖昧になる。
struct CallGuideDashboardView: View {
    @Environment(AppDatabase.self) private var database

    @State private var vm = CallGuideDashboardViewModel()
    @State private var sheetDestination: DetailDestination?
    @State private var showLoginPrompt = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sp6) {
                summarySection
                if vm.isLoading && vm.withCalls.isEmpty && vm.wanted.isEmpty {
                    ImasInlineLoading()
                } else {
                    if let message = vm.loadError { errorBanner(message) }
                    withCallsSection
                    recentEditsSection
                    wantedSection
                }
            }
            .padding(.horizontal, DS.sp5)
            .padding(.top, DS.sp4)
            .padding(.bottom, DS.sp7)
        }
        .background(DS.bg.ignoresSafeArea())
        .navigationTitle(L10n.Callguide.dashboardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $sheetDestination) { dest in
            DetailSheetView(destination: dest)
                .environment(database)
        }
        .sheet(isPresented: $showLoginPrompt) {
            LoginToEditSheet()
        }
        .task { await vm.load() }
        .refreshable { await vm.load() }
        .trackScreen("call_guide_dashboard")
    }

    // MARK: - サマリ

    @ViewBuilder
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            HStack(spacing: DS.sp3) {
                ImasStatTile(systemImage: "hands.clap.fill", value: "\(vm.withCalls.count)",
                             unit: String(localized: L10n.Callguide.dashboardStatUnitSongs),
                             label: String(localized: L10n.Callguide.dashboardStatWithCalls))
                ImasStatTile(systemImage: "tag.fill", value: "\(vm.tag?.tagged ?? 0)",
                             unit: String(localized: L10n.Callguide.dashboardStatUnitSongs),
                             label: String(localized: L10n.Callguide.dashboardStatTagged))
                ImasStatTile(systemImage: "square.and.pencil", value: "\(vm.tag?.writable ?? 0)",
                             unit: String(localized: L10n.Callguide.dashboardStatUnitSongs),
                             label: String(localized: L10n.Callguide.dashboardStatWanted))
            }
            VStack(alignment: .leading, spacing: DS.sp1) {
                Text(L10n.Callguide.dashboardIntro)
                if let generatedAt = vm.generatedAt {
                    // 全端末で共有するキャッシュ (最大 30 分) 越しなので「今」ではない。
                    // 自分が書いた直後に出てこない理由が、ここを見れば分かるようにする。
                    Text(L10n.Callguide.dashboardGeneratedAt(time: EditFeedFormat.relativeTime(generatedAt)))
                }
                if vm.droppedCount > 0 {
                    // 派生曲・「その他」ブランド・手元に未同期の曲。曲一覧と同じ母集合に
                    // 揃えている以上ここには出せないので、数だけ正直に出す。
                    Text(L10n.Callguide.dashboardDropped(count: vm.droppedCount))
                }
            }
            .font(.imasCaption)
            .foregroundStyle(DS.ink3)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func errorBanner(_ message: DisplayText) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.imasCaption)
                .foregroundStyle(DS.warning)
            Text(L10n.Callguide.dashboardLoadError(message: message.resolved))
                .font(.imasCaption)
                .foregroundStyle(DS.ink2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - ① コールガイドがある曲

    @ViewBuilder
    private var withCallsSection: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            // 件数は見出しの文字列に入れる (`ImasSectionHeader` の `count` は tight では出ない)。
            ImasSectionHeader(title: .key(L10n.Callguide.dashboardWithCallsHeader(count: vm.withCalls.count)), tight: true)
            if vm.withCalls.isEmpty {
                ImasEmptyState(
                    systemImage: "music.mic",
                    title: String(localized: L10n.Callguide.dashboardWithCallsEmptyTitle),
                    message: String(localized: L10n.Callguide.dashboardWithCallsEmptyMessage)
                )
            } else {
                let times = EditFeedFormat.relativeTimes(
                    vm.withCalls.compactMap { row in row.updatedAt.map { (row.id, $0) } })
                ImasListContainer {
                    ForEach(Array(vm.withCalls.enumerated()), id: \.element.id) { idx, row in
                        if idx > 0 { ImasRowDivider(inset: DS.sp4) }
                        songRow(row.song, subtitle: subtitle(for: row, time: times[row.id])) {
                            open(row.song, from: "with_calls")
                        }
                    }
                }
                if vm.withCallsTruncated {
                    Text(L10n.Callguide.dashboardWithCallsTruncated)
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink3)
                }
            }
        }
    }

    private func subtitle(for row: CallGuideSongRow, time: String?) -> LocalizedStringResource {
        if let time {
            return L10n.Callguide.dashboardRowSubtitle(detail: row.detailLabel, time: time, by: row.updatedBy)
        }
        return L10n.Callguide.dashboardRowSubtitleNoTime(detail: row.detailLabel, by: row.updatedBy)
    }

    // MARK: - ② 最近の編集

    @ViewBuilder
    private var recentEditsSection: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            ImasSectionHeader(title: .key(L10n.Callguide.dashboardRecentHeader), tight: true)
            if vm.recentEdits.isEmpty {
                ImasEmptyState(
                    systemImage: "square.and.pencil",
                    title: String(localized: L10n.Callguide.dashboardRecentEmptyTitle),
                    message: String(localized: L10n.Callguide.dashboardRecentEmptyMessage)
                )
            } else {
                let times = EditFeedFormat.relativeTimes(vm.recentEdits.map { ($0.id, $0.at) })
                ImasListContainer {
                    ForEach(Array(vm.recentEdits.enumerated()), id: \.element.id) { idx, row in
                        if idx > 0 { ImasRowDivider(inset: DS.sp4) }
                        songRow(row.song,
                                subtitle: L10n.Callguide.dashboardRowSubtitle(
                                    detail: row.label, time: times[row.id] ?? "", by: row.by)) {
                            open(row.song, from: "recent_edit")
                        }
                    }
                }
            }
        }
    }

    // MARK: - ③ タグはあるのに未整備

    @ViewBuilder
    private var wantedSection: some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            // 件数はサーバの内訳から出す (一覧は上限 100 件で打ち切られるため、行数とは一致しない)。
            ImasSectionHeader(title: .key(wantedSectionTitle), tight: true)
            if vm.wanted.isEmpty {
                ImasEmptyState(
                    systemImage: "checkmark.seal",
                    title: String(localized: L10n.Callguide.dashboardWantedEmptyTitle),
                    message: String(localized: L10n.Callguide.dashboardWantedEmptyMessage)
                )
            } else {
                ImasListContainer {
                    ForEach(Array(vm.wanted.enumerated()), id: \.element.id) { idx, row in
                        if idx > 0 { ImasRowDivider(inset: DS.sp4) }
                        wantedRow(row)
                    }
                }
            }
            wantedFooter
        }
    }

    private var wantedSectionTitle: LocalizedStringResource {
        guard let tag = vm.tag else { return L10n.Callguide.dashboardWantedHeader }
        return L10n.Callguide.dashboardWantedHeaderCount(count: tag.writable)
    }

    private func wantedRow(_ row: CallGuideWantedRow) -> some View {
        // 未ログインでも押せる。押すとログイン導線へ行き、ログイン後に自分で曲を開き直せる
        // (行き止まりにせず「なぜ書けないか」をその場で解消する)。
        let signedIn = AuthService.shared.isSignedIn
        return Button {
            if signedIn {
                open(row.song, from: "wanted")
            } else {
                AppAnalytics.tap("call_guide_dashboard.login")
                showLoginPrompt = true
            }
        } label: {
            HStack(spacing: DS.sp3) {
                ImasArtwork(title: row.song.title, seed: nil, size: 40,
                            imageURL: row.song.artworkUrl.flatMap(URL.init))
                Text(row.song.title)
                    .font(.imasSubhead.weight(.semibold))
                    .foregroundStyle(DS.ink)
                    .lineLimit(1)
                Spacer(minLength: DS.sp2)
                // ボタンは縮ませない。曲名の方を省略する
                // (「ログイン…」まで潰れると、何のボタンか読めなくなる)。
                ImasChip(text: String(localized: signedIn ? L10n.Callguide.dashboardWantedWrite
                                                        : L10n.Callguide.dashboardWantedLoginToWrite),
                         systemImage: "square.and.pencil", style: .selected)
                    .fixedSize(horizontal: true, vertical: false)
                    .layoutPriority(1)
            }
            .padding(.horizontal, DS.sp4)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var wantedFooter: some View {
        VStack(alignment: .leading, spacing: DS.sp2) {
            if let tag = vm.tag, tag.withoutLyrics > 0 {
                Text(L10n.Callguide.dashboardWantedWithoutLyrics(count: tag.withoutLyrics))
            }
            if vm.wantedTruncated {
                Text(L10n.Callguide.dashboardWantedTruncated)
            }
            if let tag = vm.tag {
                NavigationLink {
                    TagDetailView(tagId: tag.tagId, tagName: tag.tagName)
                } label: {
                    Text(L10n.Callguide.dashboardWantedSeeTag(tag: tag.tagName))
                        .font(.imasCaption.weight(.semibold))
                }
                .buttonStyle(.plain)
            }
        }
        .font(.imasCaption)
        .foregroundStyle(DS.ink3)
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - 共通行

    private func songRow(_ song: Song, subtitle: LocalizedStringResource, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DS.sp3) {
                ImasArtwork(title: song.title, seed: nil, size: 40,
                            imageURL: song.artworkUrl.flatMap(URL.init))
                VStack(alignment: .leading, spacing: DS.sp1) {
                    Text(song.title)
                        .font(.imasSubhead.weight(.semibold))
                        .foregroundStyle(DS.ink)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                ImasRowChevron()
            }
            .padding(.horizontal, DS.sp4)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func open(_ song: Song, from source: String) {
        AppAnalytics.tap("call_guide_dashboard.\(source)")
        sheetDestination = .songLyrics(song)
    }
}
