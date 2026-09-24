import SwiftUI
import EventKit
import UIKit

/// 選択日の予定 1 行。スケジュール画面のインラインリストと、
/// 日詳細 sheet (`CalendarDayDetailView`) の双方で共有する。
/// 公演 / CDリリース / 誕生日 を ImasLeadBar + アイコン/アバター + タイトル/サブ で描画する。
struct DayEntryRow: View {
    @Environment(AppDatabase.self) private var database
    @Environment(\.colorScheme) private var scheme
    let entry: CalendarEntry
    /// タップ時に親へ詳細遷移先を通知する。親が sheet / nav で受ける。
    let onSelect: (DetailDestination) -> Void
    /// マイ予定タップ時に親へ通知する (DetailDestination を持たないため別経路)。
    /// 親は簡易詳細シート (PersonalEventDetailView) を出す。
    var onSelectPersonal: ((PersonalCalendarEvent) -> Void)? = nil
    /// この行が表示される暦日。記念日のN周年計算に使う (省略時は当日)。
    var displayDate: Date = Date()

    var body: some View {
        switch entry {
        case .show(let row):
            // 主タップ: 親イベント詳細。スワイプ (セトリ) で公演 (Show) に直接飛べる。
            Button {
                Task {
                    if let event = try? await AppContainer.shared.eventReading.event(id: row.show.eventId) {
                        onSelect(.event(event))
                    }
                }
            } label: {
                showRow(row)
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    Task {
                        if let show = try? await AppContainer.shared.showReading.show(id: row.show.id) {
                            onSelect(.show(show))
                        }
                    }
                } label: {
                    Label(L10n.Schedule.rowSetlist, systemImage: "music.note.list")
                }
                .tint(DS.sys)
            }
        case .release(_, let songs):
            Button {
                guard let first = songs.first else { return }
                onSelect(.song(first))
            } label: {
                releaseRow(songs: songs)
            }
            .buttonStyle(.plain)
        case .birthday(let idol, _):
            Button {
                onSelect(.idol(idol))
            } label: {
                birthdayRow(idol: idol)
            }
            .buttonStyle(.plain)
        case .staffBirthday(let staff, _):
            // 事務員は専用詳細画面が無いのでタップ無効 (View だけ)。
            staffBirthdayRow(staff: staff)
        case .anniversary(let ann, _):
            // 記念日も詳細導線無し。タップ無効。
            anniversaryRow(ann)
        case .personal(let event):
            Button {
                onSelectPersonal?(event)
            } label: {
                personalRow(event: event)
            }
            .buttonStyle(.plain)
        case .ticket(let row):
            Button {
                Task {
                    if let event = try? await AppContainer.shared.eventReading.event(id: row.eventId) {
                        onSelect(.event(event))
                    }
                }
            } label: {
                ticketRow(row)
            }
            .buttonStyle(.plain)
        case .ticketPeriod(let row):
            Button {
                Task {
                    if let event = try? await AppContainer.shared.eventReading.event(id: row.eventId) {
                        onSelect(.event(event))
                    }
                }
            } label: {
                ticketPeriodRow(row)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Row variants

    /// 行の共通シェル: リードバー + リーディング (アイコン/アバター) + タイトル/サブ + 末尾。
    private func rowShell<Leading: View, Trailing: View>(
        seed: String?,
        title: String,
        subtitle: String?,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(spacing: DS.sp3) {
            ImasLeadBar(seed: seed)
                .frame(height: 36)
            leading()
            VStack(alignment: .leading, spacing: DS.sp1) {
                Text(title)
                    .font(.imasSubhead.weight(.semibold))
                    .foregroundStyle(DS.ink)
                    .lineLimit(2)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.imasFootnote)
                        .foregroundStyle(DS.ink2)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: DS.sp2)
            trailing()
        }
        .padding(.horizontal, DS.sp4)
        .padding(.vertical, DS.sp3)
        .contentShape(Rectangle())
    }

    private func showRow(_ row: CalendarShowRow) -> some View {
        let sub = [row.show.name, row.show.startTime, row.show.venue]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: String(localized: L10n.Schedule.rowSeparator))
        return rowShell(
            seed: row.brandColor,
            title: row.eventName,
            subtitle: sub.isEmpty ? nil : sub,
            leading: { ShowIconAvatar(seed: row.brandColor) },
            trailing: { chevron }
        )
    }

    private func releaseRow(songs: [Song]) -> some View {
        let title = songs.count == 1
            ? songs[0].title
            : String(localized: L10n.Schedule.rowReleaseMulti(count: songs.count, title: songs[0].title))
        return rowShell(
            seed: nil,
            title: title,
            subtitle: String(localized: L10n.Schedule.rowReleaseSubtitle),
            leading: { ReleaseIconAvatar() },
            trailing: { chevron }
        )
    }

    private func birthdayRow(idol: Idol) -> some View {
        rowShell(
            seed: idol.color,
            title: String(localized: L10n.Schedule.rowBirthdayTitle(name: idol.name)),
            subtitle: idol.birthdayDisplay,
            leading: { IdolAvatarView(idol: idol, size: 36) },
            trailing: { BirthdayGiftChip(seed: idol.color) }
        )
    }

    /// 事務員 (音無小鳥・千川ちひろ 等) の誕生日行。アイドル詳細を持たないので非タップ。
    private func staffBirthdayRow(staff: Staff) -> some View {
        rowShell(
            seed: nil,
            title: String(localized: L10n.Schedule.rowBirthdayTitle(name: staff.name)),
            subtitle: staff.role,
            leading: {
                let t = ImasTheme.derive(seed: CalendarEntry.ThemeSeed.staffBirthday, scheme: scheme)
                Image(systemName: "person.text.rectangle.fill")
                    .font(.imasScaled(16, weight: .semibold))
                    .foregroundStyle(t.chipText)
                    .frame(width: 36, height: 36)
                    .background(t.chipBg, in: Circle())
            },
            trailing: { BirthdayGiftChip(seed: nil) }
        )
    }

    /// ブランド記念日 (N周年表示)。
    private func anniversaryRow(_ ann: Anniversary) -> some View {
        let kind = AnniversaryKind(rawValue: ann.kind)
        let icon = kind?.systemImage ?? "sparkles"
        var jst = Calendar(identifier: .gregorian)
        jst.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let thisYear = jst.component(.year, from: displayDate)
        let years = ann.anniversaryYears(in: thisYear)
        // 表示: 「21周年・アーケード版稼働」 (起点年=0周年は「初日」と表示)
        let title: String
        if let years {
            title = years == 0
                ? String(localized: L10n.Schedule.rowAnniversaryFirstDay(label: ann.label))
                : String(localized: L10n.Schedule.rowAnniversaryYears(years: years, label: ann.label))
        } else {
            title = ann.label
        }
        let subtitle = String(localized: L10n.Schedule.rowAnniversarySince(year: String(ann.date.prefix(4))))
        return rowShell(
            seed: nil,
            title: title,
            subtitle: subtitle,
            leading: {
                let t = ImasTheme.derive(seed: CalendarEntry.ThemeSeed.anniversary, scheme: scheme)
                Image(systemName: icon)
                    .font(.imasScaled(16, weight: .semibold))
                    .foregroundStyle(t.chipText)
                    .frame(width: 36, height: 36)
                    .background(t.chipBg, in: Circle())
            },
            trailing: { EmptyView() }
        )
    }

    /// チケット受付期間行 (受付開始〜申込締切)。タップで親イベント詳細へ。
    private func ticketPeriodRow(_ row: TicketPeriodRow) -> some View {
        // 両端が読めれば「6/13 〜 6/20」、片方だけならその日付だけ、どちらも読めなければ語だけ。
        let days = [Self.md(row.start), Self.md(row.end)].compactMap { $0 }
        let range: String? = days.count == 2
            ? String(localized: L10n.Schedule.rowTicketPeriodRange(start: days[0], end: days[1]))
            : days.first
        return rowShell(
            seed: nil,
            title: String(localized: L10n.Schedule.rowTicketPeriodTitle(label: Vocab.table.ticketPeriodLabel, event: row.eventName)),
            subtitle: range.map { String(localized: L10n.Schedule.rowTicketPeriodSubtitleRange(range: $0)) }
                ?? String(localized: L10n.Schedule.rowTicketPeriodSubtitle),
            leading: { TicketIconAvatar(systemImage: "calendar.badge.clock", color: ImasTheme.derive(seed: CalendarEntry.ThemeSeed.ticket, scheme: scheme).accent) },
            trailing: { chevron }
        )
    }

    /// "2026-06-13" → "6/13"。
    private static func md(_ ymd: String) -> String? {
        let parts = ymd.split(separator: "-")
        guard parts.count == 3, let m = Int(parts[1]), let d = Int(parts[2]) else { return nil }
        return "\(m)/\(d)"
    }

    /// チケット日程行 (申込締切 / 当落発表)。タップで親イベント詳細へ。
    private func ticketRow(_ row: TicketCalendarRow) -> some View {
        let color: Color = row.kind == .deadline ? DS.danger : ImasTheme.derive(seed: CalendarEntry.ThemeSeed.ticket, scheme: scheme).accent
        return rowShell(
            seed: nil,
            title: String(localized: L10n.Schedule.rowTicketTitle(kind: row.kind.label, event: row.eventName)),
            subtitle: String(localized: row.kind == .deadline
                ? L10n.Schedule.rowTicketDeadlineSubtitle : L10n.Schedule.rowTicketLotterySubtitle),
            leading: { TicketIconAvatar(systemImage: row.kind.icon, color: color) },
            trailing: { chevron }
        )
    }

    /// 端末カレンダー由来のマイ予定行。リードバーはカレンダー色をそのまま使う。
    private func personalRow(event: PersonalCalendarEvent) -> some View {
        let timeText = event.isAllDay
            ? String(localized: L10n.Schedule.rowPersonalAllDay)
            : String(localized: L10n.Schedule.rowPersonalTimeRange(
                start: event.start.formatted(date: .omitted, time: .shortened),
                end: event.end.formatted(date: .omitted, time: .shortened)))
        return HStack(spacing: DS.sp3) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(event.color)
                .frame(width: 3, height: 36)
            Image(systemName: "calendar")
                .font(.imasScaled( 16, weight: .semibold))
                .foregroundStyle(event.color)
                .frame(width: 36, height: 36)
                .background(event.color.opacity(0.16), in: Circle())
            VStack(alignment: .leading, spacing: DS.sp1) {
                Text(event.title)
                    .font(.imasSubhead.weight(.semibold))
                    .foregroundStyle(DS.ink)
                    .lineLimit(2)
                Text(L10n.Schedule.rowPersonalSubtitle(time: timeText, calendar: event.calendarTitle))
                    .font(.imasFootnote)
                    .foregroundStyle(DS.ink2)
                    .lineLimit(1)
            }
            Spacer(minLength: DS.sp2)
            chevron
        }
        .padding(.horizontal, DS.sp4)
        .padding(.vertical, DS.sp3)
        .contentShape(Rectangle())
    }

    private var chevron: some View {
        ImasRowChevron()
    }

}

// MARK: - 日詳細 sheet (detent プレゼン用に保持。共有行 DayEntryRow を再利用)

struct CalendarDayDetailView: View {
    @Environment(AppDatabase.self) private var database
    @Environment(\.colorScheme) private var scheme
    let entries: [CalendarEntry]
    let selectedDate: Date
    /// 親に「この sheet を閉じてから詳細 sheet を開いてほしい」と通知するコールバック。
    /// 二重 sheet 表示できない SwiftUI 制約への対応。
    let onSelect: (DetailDestination) -> Void
    /// マイ予定行タップ → 親が簡易詳細シートを開く (こちらも閉じてから開く流儀は親に任せる)。
    var onSelectPersonal: ((PersonalCalendarEvent) -> Void)? = nil

    // MARK: - カレンダー連携 state
    @State private var exportTarget: CalendarShowEntry? = nil
    @State private var exportResult: ExportResultAlert? = nil
    @State private var showPermissionAlert = false

    var body: some View {
        VStack(spacing: 0) {
            dayHeader

            if entries.isEmpty {
                ImasEmptyState(
                    systemImage: "calendar",
                    title: String(localized: L10n.Schedule.daySheetEmptyTitle),
                    message: String(localized: L10n.Schedule.dayEmptyMessage)
                )
                Spacer(minLength: 0)
            } else {
                List {
                    ForEach(entries) { entry in
                        entryRow(for: entry)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(DS.bg)
                .environment(\.defaultMinListRowHeight, 0)
            }
        }
        .background(DS.bg)
        .trackScreen("calendar_day")
        // カレンダーに追加 確認シート（presenting オーバーロードでレース回避）
        .confirmationDialog(
            Text(L10n.Schedule.exportAction),
            isPresented: Binding(
                get: { exportTarget != nil },
                set: { if !$0 { exportTarget = nil } }
            ),
            titleVisibility: .visible,
            presenting: exportTarget
        ) { target in
            Button {
                exportTarget = nil
                Task { await performExport(target) }
            } label: {
                Text(L10n.Schedule.exportConfirmAdd(event: target.showRow.eventName))
            }
            Button(role: .cancel) {
                exportTarget = nil
            } label: {
                Text(L10n.Schedule.actionCancel)
            }
        } message: { target in
            Text(L10n.Schedule.exportConfirmMessage(event: target.showRow.eventName))
        }
        // 追加結果アラート
        .alert(item: $exportResult) { result in
            if result.kind == .alreadyAdded, let target = result.target {
                return Alert(
                    title: Text(result.title),
                    message: Text(display: result.message),
                    primaryButton: .default(Text(L10n.Schedule.exportReadd)) {
                        CalendarExportService.shared.removeAddedRecord(for: target.showRow.show.id)
                        Task { await performExport(target) }
                    },
                    secondaryButton: .cancel(Text(L10n.Schedule.actionClose))
                )
            }
            return Alert(
                title: Text(result.title),
                message: Text(display: result.message),
                dismissButton: .default(Text("OK"))
            )
        }
        // 権限拒否 → 設定アプリへ誘導
        .alert(Text(L10n.Schedule.exportDeniedTitle), isPresented: $showPermissionAlert) {
            Button {
                if let url = CalendarExportService.shared.settingsURL {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(L10n.Schedule.actionOpenSettings)
            }
            Button(role: .cancel) {} label: {
                Text(L10n.Schedule.actionCancel)
            }
        } message: {
            Text(L10n.Schedule.exportDeniedMessage)
        }
    }

    // MARK: - 行の描画

    @ViewBuilder
    private func entryRow(for entry: CalendarEntry) -> some View {
        Group {
            if case .show(let row) = entry {
                // 公演行だけ参加登録のスワイプを付ける (右)。カレンダー追加 (左) と規則を共有。
                DayEntryRow(entry: entry, onSelect: onSelect, onSelectPersonal: onSelectPersonal, displayDate: selectedDate)
                    .environment(database)
                    .attendanceSwipe(show: row.show)
            } else {
                DayEntryRow(entry: entry, onSelect: onSelect, onSelectPersonal: onSelectPersonal, displayDate: selectedDate)
                    .environment(database)
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
        // 公演行だけ「カレンダーに追加」スワイプアクションを付ける
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            if case .show(let row) = entry {
                Button {
                    AppAnalytics.tap("calendar_day.calendar_add")
                    exportTarget = CalendarShowEntry(showRow: row)
                } label: {
                    Label(L10n.Schedule.exportSwipe, systemImage: "calendar.badge.plus")
                }
                .tint(DS.success)
            }
        }
    }

    // MARK: - カレンダーエクスポート実行

    private func performExport(_ target: CalendarShowEntry) async {
        do {
            guard let event = try await AppContainer.shared.eventReading.event(id: target.showRow.show.eventId) else {
                exportResult = ExportResultAlert(
                    kind: .error,
                    title: L10n.Schedule.exportErrorTitle,
                    message: .key(L10n.Schedule.exportErrorEventNotFound),
                    target: target
                )
                return
            }

            let result = try await CalendarExportService.shared.exportShow(target.showRow.show, event: event)
            switch result {
            case .added:
                exportResult = ExportResultAlert(
                    kind: .added,
                    title: L10n.Schedule.exportAddedTitle,
                    message: .key(L10n.Schedule.exportAddedMessage(event: target.showRow.eventName)),
                    target: target
                )
            case .alreadyAdded:
                exportResult = ExportResultAlert(
                    kind: .alreadyAdded,
                    title: L10n.Schedule.exportAlreadyTitle,
                    message: .key(L10n.Schedule.exportAlreadyMessage(event: target.showRow.eventName)),
                    target: target
                )
            case .permissionDenied:
                showPermissionAlert = true
            }
        } catch {
            exportResult = ExportResultAlert(
                kind: .error,
                title: L10n.Schedule.exportErrorTitle,
                // CalendarExportError はカタログの文言、EventKit のエラーは OS が訳した文 (どちらも解決済み)
                message: .verbatim(error.localizedDescription),
                target: target
            )
        }
    }

    // MARK: - ヘッダー

    private var dayHeader: some View {
        HStack(alignment: .center, spacing: DS.sp4) {
            VStack(alignment: .leading, spacing: DS.sp1) {
                Text(selectedDate.formatted(.dateTime.year().month(.wide).day()))
                    .font(.imasTitle3.weight(.bold))
                    .foregroundStyle(DS.ink)
                if !entries.isEmpty {
                    Text(L10n.Schedule.daySheetEventCount(count: entries.count))
                        .font(.imasFootnote)
                        .foregroundStyle(DS.ink2)
                }
            }
            Spacer()
            entryTypeSummary
        }
        .padding(.horizontal, DS.sp6)
        .padding(.vertical, DS.sp4)
        .background(DS.surface)
    }

    private var entryTypeSummary: some View {
        let showCount = entries.filter { if case .show = $0 { true } else { false } }.count
        let releaseCount = entries.filter { if case .release = $0 { true } else { false } }.count
        // アイドル誕生日と事務員誕生日は同じ「gift」アイコンでまとめて集計。
        let birthdayCount = entries.filter {
            if case .birthday = $0 { return true }
            if case .staffBirthday = $0 { return true }
            return false
        }.count
        let anniversaryCount = entries.filter { if case .anniversary = $0 { true } else { false } }.count
        let ticketCount = entries.filter {
            if case .ticket = $0 { return true }
            if case .ticketPeriod = $0 { return true }
            return false
        }.count
        let personalCount = entries.filter { if case .personal = $0 { true } else { false } }.count
        return HStack(spacing: DS.sp3) {
            if showCount > 0 {
                summaryBadge(count: showCount, systemImage: "music.mic", color: DS.sys)
            }
            if releaseCount > 0 {
                summaryBadge(count: releaseCount, systemImage: "opticaldisc", color: DS.warning)
            }
            if birthdayCount > 0 {
                summaryBadge(count: birthdayCount, systemImage: "gift", color: ImasTheme.derive(seed: CalendarEntry.ThemeSeed.staffBirthday, scheme: scheme).accent)
            }
            if anniversaryCount > 0 {
                summaryBadge(count: anniversaryCount, systemImage: "sparkles", color: ImasTheme.derive(seed: CalendarEntry.ThemeSeed.anniversary, scheme: scheme).accent)
            }
            if ticketCount > 0 {
                summaryBadge(count: ticketCount, systemImage: "ticket", color: DS.danger)
            }
            if personalCount > 0 {
                summaryBadge(count: personalCount, systemImage: "calendar", color: DS.sys2)
            }
        }
    }

    private func summaryBadge(count: Int, systemImage: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Image(systemName: systemImage).font(.imasScaled( 12, weight: .semibold))
            Text("\(count)").font(.imasDisplay(13, weight: .semibold))
        }
        .foregroundStyle(color)
    }
}

// MARK: - Supporting types

private struct CalendarShowEntry: Identifiable {
    let id = UUID()
    let showRow: CalendarShowRow
}

private enum ExportResultKind: Equatable {
    case added, alreadyAdded, error
}

private struct ExportResultAlert: Identifiable {
    let id = UUID()
    let kind: ExportResultKind
    /// 解決済みの String ではなく文言の値で持ち、アラートを出すときに引く。
    let title: LocalizedStringResource
    let message: DisplayText
    let target: CalendarShowEntry?
}

// MARK: - Row leading / trailing accents

/// 公演アイコン (テーマ chip 面 + mic)。
private struct ShowIconAvatar: View {
    var seed: String?
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        let t = ImasTheme.derive(seed: seed, scheme: scheme)
        Image(systemName: "music.mic")
            .font(.imasScaled( 16, weight: .semibold))
            .foregroundStyle(t.chipText)
            .frame(width: 36, height: 36)
            .background(t.chipBg, in: Circle())
    }
}

/// リリースアイコン (橙基調)。
private struct ReleaseIconAvatar: View {
    var body: some View {
        Image(systemName: "opticaldisc.fill")
            .font(.imasScaled( 16, weight: .semibold))
            .foregroundStyle(DS.warning)
            .frame(width: 36, height: 36)
            .background(DS.warning.opacity(0.16), in: Circle())
    }
}

/// チケットアイコン (締切=赤 / 当落=藍)。
private struct TicketIconAvatar: View {
    let systemImage: String
    let color: Color
    var body: some View {
        Image(systemName: systemImage)
            .font(.imasScaled( 15, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: 36, height: 36)
            .background(color.opacity(0.16), in: Circle())
    }
}

/// 誕生日末尾のギフトチップ (アイドル色テーマ)。
private struct BirthdayGiftChip: View {
    var seed: String?
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        let t = ImasTheme.derive(seed: seed, scheme: scheme)
        Image(systemName: "gift.fill")
            .font(.imasScaled( 12, weight: .semibold))
            .foregroundStyle(t.chipText)
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .background(t.chipBg, in: Capsule())
    }
}
