import os
import SwiftUI

/// 自分の編集 batch 一覧 (`GET /me/edits`) と、本人による各 batch の revert (`POST /edits/:batchId/revert`)。
///
/// 確定モデル: 即時オープン編集 + 事後モデレーション。本人 revert を v1 で開放しているため、
/// ユーザーは自分が行った編集を後から打ち消せる (誤編集の自己修正)。
/// - revert は CloudKit ハード削除を伝播しないため、サーバ側で soft delete / before
///   スナップショットへの forceUpdate として安全に逆適用される (契約 v2 #1)。
/// - 既に revert 済み / revert 操作自体の batch は再 revert させない (`EditFeedEntry.isRevertable`)。
/// - revert 成功後はその行を「差戻し済み」状態に楽観更新し、リストからは消さずに残す
///   (履歴の連続性を保つ。サーバも revert を新規 edit_history として記録する)。
struct MyEditsView: View {
    @State private var entries: [EditFeedEntry] = []
    @State private var page = 1
    @State private var hasMore = true
    @State private var isLoading = false
    @State private var isLoadingMore = false
    /// アラートに出す失敗の文言 (アプリの文言。OS・サーバのエラー文は引数で埋める)。
    @State private var errorMessage: DisplayText?

    /// revert 確認中の対象 batch。
    @State private var revertTarget: EditFeedEntry?
    /// revert 実行中の batchId (二度押し防止 + スピナー表示)。
    @State private var revertingId: Int?
    /// 楽観的に revert 済みへ倒した batchId 群 (サーバ反映成功で確定)。
    @State private var locallyReverted: Set<Int> = []

    private let limit = 20

    var body: some View {
        let times = EditFeedFormat.relativeTimes(entries.map { ($0.id, $0.createdDate) })
        return ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(entries) { entry in
                    MyEditRow(
                        entry: entry,
                        timeLabel: times[entry.id] ?? "",
                        isReverted: isReverted(entry),
                        isReverting: revertingId == entry.id,
                        onRevert: { revertTarget = entry }
                    )
                    .onAppear { maybeLoadMore(currentItem: entry) }
                }

                if isLoadingMore {
                    ImasInlineLoading()
                }
            }
            .padding(.horizontal, DS.sp5)
            .padding(.vertical, DS.sp4)
        }
        .background(DS.bg)
        .navigationTitle(L10n.Mypage.editsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .trackScreen("my_edits")
        .overlay {
            if isLoading && entries.isEmpty {
                ProgressView { Text(L10n.Mypage.editsLoading) }
                    .padding(DS.sp7)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            } else if entries.isEmpty && !isLoading {
                ImasEmptyState(
                    systemImage: "square.and.pencil",
                    title: String(localized: L10n.Mypage.editsEmptyTitle),
                    message: String(localized: L10n.Mypage.editsEmptyMessage)
                )
            }
        }
        .refreshable { await reload() }
        .task {
            if entries.isEmpty { await reload() }
        }
        .confirmationDialog(
            Text(L10n.Mypage.editsRevertConfirmTitle),
            isPresented: Binding(
                get: { revertTarget != nil },
                set: { if !$0 { revertTarget = nil } }
            ),
            titleVisibility: .visible,
            presenting: revertTarget
        ) { target in
            Button(role: .destructive) {
                Task { await revert(target) }
            } label: {
                Text(L10n.Mypage.editsActionRevert)
            }
            Button(role: .cancel) { revertTarget = nil } label: { Text(L10n.Mypage.editsRevertCancel) }
        } message: { target in
            Text(revertMessage(for: target))
        }
        .alert(Text(L10n.Mypage.editsErrorTitle), isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(display: errorMessage ?? .verbatim(""))
        }
    }

    // MARK: - State resolution

    private func isReverted(_ entry: EditFeedEntry) -> Bool {
        entry.reverted || locallyReverted.contains(entry.id)
    }

    private func revertMessage(for entry: EditFeedEntry) -> LocalizedStringResource {
        let label = editFeedText(EditFeedFormat.recordTypeLabel(entry.recordType)).resolved
        return L10n.Mypage.editsRevertConfirmMessage(summary: entry.summary ?? label)
    }

    // MARK: - Loading

    private func reload() async {
        isLoading = true
        defer { isLoading = false }
        page = 1
        do {
            let result = try await EditFeedService.shared.fetchEdits(
                page: 1, limit: limit, mine: true
            )
            entries = result.items
            locallyReverted.removeAll()
            hasMore = result.items.count >= limit
        } catch {
            errorMessage = errorText(error)
        }
    }

    private func maybeLoadMore(currentItem: EditFeedEntry) {
        guard hasMore, !isLoadingMore, !isLoading else { return }
        guard let idx = entries.firstIndex(where: { $0.id == currentItem.id }),
              idx >= entries.count - 3 else { return }
        Task { await loadMore() }
    }

    private func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        let next = page + 1
        do {
            let result = try await EditFeedService.shared.fetchEdits(
                page: next, limit: limit, mine: true
            )
            let existing = Set(entries.map(\.id))
            let fresh = result.items.filter { !existing.contains($0.id) }
            entries.append(contentsOf: fresh)
            page = next
            hasMore = result.items.count >= limit
        } catch {
            Logger.community.error("my_edits_load_more_failed: \(error.localizedDescription)")
            hasMore = false
        }
    }

    // MARK: - Revert

    private func revert(_ entry: EditFeedEntry) async {
        revertTarget = nil
        guard revertingId == nil else { return }
        revertingId = entry.id
        defer { revertingId = nil }
        do {
            let outcome = try await AdminModerationService.shared.revertBatch(batchId: entry.id)
            switch outcome {
            case .reverted, .alreadyReverted:
                // 楽観反映: 行は消さず「差戻し済み」へ。実データは次回同期で戻る。
                locallyReverted.insert(entry.id)
            case .skippedConflict:
                // 後続編集があり巻き戻せなかった (本人 revert は競合スキップ固定)。状態は変えない。
                errorMessage = .key(L10n.Mypage.editsErrorConflict)
            default:
                // outcome の表示名は管理者画面 (AdminModerationService) と共用の語で、まだ訳さない
                errorMessage = .key(L10n.Mypage.editsErrorRevertOutcome(outcome: outcome.label))
            }
        } catch {
            if case APIClientError.notAuthorized = error {
                errorMessage = .key(L10n.Mypage.editsErrorAuthExpired)
            } else {
                errorMessage = .key(L10n.Mypage.editsErrorRevertFailed(detail: error.localizedDescription))
            }
        }
    }

    private func errorText(_ error: Error) -> DisplayText {
        if case APIClientError.rateLimited = error {
            return .key(L10n.Mypage.editsErrorRateLimited)
        }
        return .key(L10n.Mypage.editsErrorLoadFailed(detail: error.localizedDescription))
    }
}

// MARK: - Row

private struct MyEditRow: View {
    let entry: EditFeedEntry
    /// 相対時刻 (一覧がまとめて作る)。
    let timeLabel: String
    let isReverted: Bool
    let isReverting: Bool
    let onRevert: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: DS.sp4) {
            EditTypeIcon(recordType: entry.recordType)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    OpBadge(op: entry.op)
                    if isReverted {
                        Text(L10n.Mypage.editsRowReverted)
                            .font(.imasCaption2.weight(.semibold))
                            .foregroundStyle(DS.ink2)
                            .padding(.horizontal, 7)
                            .padding(.vertical, DS.sp1)
                            .background(DS.fill, in: Capsule())
                    }
                    Spacer(minLength: 4)
                    Text(timeLabel)
                        .font(.imasCaption2)
                        .foregroundStyle(DS.ink2)
                }

                Text(display: entry.summary.map(DisplayText.verbatim)
                     ?? editFeedText(EditFeedFormat.recordTypeLabel(entry.recordType)))
                    .font(.imasSubhead)
                    .foregroundStyle(isReverted ? AnyShapeStyle(DS.ink2) : AnyShapeStyle(DS.ink))
                    .strikethrough(isReverted, color: DS.ink2)
                    .fixedSize(horizontal: false, vertical: true)

                footer
            }
        }
        .padding(14)
        .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD))
    }

    @ViewBuilder
    private var footer: some View {
        HStack {
            if entry.goodCount > 0 {
                Label("\(entry.goodCount)", systemImage: "hands.clap.fill")
                    .font(.imasCaption)
                    .foregroundStyle(DS.pick)
            }
            Spacer()
            if isReverting {
                ProgressView()
            } else if entry.isRevertable && !isReverted {
                Button(role: .destructive) {
                    AppAnalytics.tap("my_edits.revert")
                    onRevert()
                } label: {
                    Label(L10n.Mypage.editsActionRevert, systemImage: "arrow.uturn.backward")
                        .font(.imasCaption.weight(.semibold))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(DS.danger)
            }
        }
        .padding(.top, DS.sp1)
    }
}

// MARK: - Shared small components

/// record_type のアイコンチップ (RecentEditsView の EditRecordIcon と同一の見た目)。
struct EditTypeIcon: View {
    let recordType: String
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let design = EditFeedFormat.recordTypeDesign(recordType, scheme: scheme)
        Circle()
            .fill(design.color.opacity(0.15))
            .frame(width: 40, height: 40)
            .overlay {
                Image(systemName: design.icon)
                    .font(.imasScaled( 16, weight: .medium))
                    .foregroundStyle(design.color)
            }
            .accessibilityHidden(true)
    }
}

/// op バッジ (RecentEditsView の EditOpBadge と同一の見た目)。
struct OpBadge: View {
    let op: String

    var body: some View {
        let (label, color) = EditFeedFormat.opDesign(op)
        Text(display: editFeedText(label))
            .font(.imasCaption2.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, DS.sp1)
            .background(color.opacity(0.15), in: Capsule())
    }
}

// MARK: - 編集フィードの語の受け口

// EditFeedFormat (edit_feed の持ち物) が返す語 (記録の種類名・操作名) を表示文言にする。
// 語の型は edit_feed 側の移行で String → LocalizedStringResource / DisplayText に変わりうるので、
// どれになってもこの画面がそのまま組めるように、受け口を型ごとに用意しておく。
private func editFeedText(_ text: String) -> DisplayText { .verbatim(text) }
private func editFeedText(_ text: LocalizedStringResource) -> DisplayText { .key(text) }
private func editFeedText(_ text: DisplayText) -> DisplayText { text }
