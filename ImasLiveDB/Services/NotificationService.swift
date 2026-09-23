import Foundation
import UserNotifications
import os

// MARK: - NotificationService

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            // ⚠️ このクラスは @MainActor。ここのコールバックを素の (MainActor 推論の)
            //    クロージャで書くと、UNUserNotificationCenter が**バックグラウンドキュー**で
            //    呼び返した瞬間に Swift ランタイムの実行者チェック
            //    (swift_task_isCurrentExecutor → dispatch_assert_queue) が
            //    「MainActor のはずが違う」で SIGTRAP を投げる。iOS 26.2 ランタイム
            //    (CI の runner) で顕在化した。
            //    → コールバックを **@Sendable (非隔離)** にして実行者の期待を外す。
            //    中で触るのは Sendable な Bool / Error と Sendable な continuation だけ。
            let center = self.center
            let granted = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
                center.requestAuthorization(options: [.alert, .sound, .badge]) { @Sendable granted, error in
                    if let error { continuation.resume(throwing: error) }
                    else { continuation.resume(returning: granted) }
                }
            }
            return granted
        } catch {
            Logger.notification.error("notif_auth_failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        // ⚠️ 完了ハンドラは @Sendable にする (requestAuthorization と同じ理由)。
        //    getNotificationSettings はバックグラウンドキューで呼び返すので、
        //    MainActor 推論のクロージャだと dispatch_assert_queue で SIGTRAP になる
        //    (起動時に rescheduleAll から呼ばれ、iOS 26.2 の CI で毎回落ちていた)。
        //    非 Sendable な UNNotificationSettings はここで Sendable な列挙値に落として返す。
        let center = self.center
        return await withCheckedContinuation { continuation in
            center.getNotificationSettings { @Sendable settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }

    // MARK: - Reschedule All

    /// いま走っている再予約。次の呼び出しは、これが終わってから走る。
    private var rescheduleInFlight: Task<Void, Never>?

    /// 既存の pending 通知を全消去し、設定がONの通知を再スケジュールする。
    /// 未認可の場合は何もしない。上限と配分はコアの予定表が決める。
    ///
    /// 呼び出しは 1 本ずつ順に走らせる。起動時とマイページの 5 つのトグルから同時に呼ばれうるが、
    /// 並行に走ると「全部消す → await → 登録」が互い違いになり、OFF にした直後の呼び出しが
    /// 消した通知を、前の呼び出しが登録し直すことがある。後に呼ばれた方が必ず最後に走るので、
    /// 最後の設定が残る。
    func rescheduleAll(database: AppDatabase) async {
        let previous = rescheduleInFlight
        let task = Task {
            await previous?.value
            await performRescheduleAll(database: database)
        }
        rescheduleInFlight = task
        await task.value
    }

    /// 予定表 (何を・いつ・どの文言で・上限 60 件・カテゴリ間の round-robin) はコアの
    /// `notification_plan`。ここは認可・全消し・設定と印の読み出し・トリガーへの詰め替え・画像の添付だけ。
    private func performRescheduleAll(database: AppDatabase) async {
        let status = await authorizationStatus()
        guard status == .authorized || status == .provisional else { return }

        let plan: [PlannedNotificationRecord]
        do {
            plan = try await buildPlan(database: database)
        } catch {
            Logger.notification.error("notif_plan_failed: \(error.localizedDescription, privacy: .public)")
            return
        }

        center.removeAllPendingNotificationRequests()

        for item in plan {
            let request = notificationRequest(for: item)
            do {
                // 同上。center も request も非 Sendable なのでコールバック版を使う。
                let center = self.center
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                    center.add(request) { @Sendable error in
                        if let error { continuation.resume(throwing: error) }
                        else { continuation.resume() }
                    }
                }
            } catch {
                Logger.notification.error("notif_add_failed \(request.identifier, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }

        Logger.notification.info("notif_rescheduled total=\(plan.count, privacy: .public)")
    }

    /// 設定と印を詰めて、コアに予定表を訊く。日付と時刻は**端末のその地**の暦で渡す。
    private func buildPlan(database: AppDatabase) async throws -> [PlannedNotificationRecord] {
        let pickIdolIds = try database.fetchMarkedEntityIds(entity: .idol, kind: .myPick)
        // お気に入り ∪ 参加マークのイベント。
        let favoriteIds = Set(try database.fetchMarkedEntityIds(entity: .event, kind: .favorite))
        let attendedIds = Set(try database.fetchAttendedEventsWithDate().map(\.id))
        let now = Date()
        let calendar = Calendar.current
        let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        let today = String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
        let input = NotificationPlanInput(
            today: today,
            nowMinutes: UInt32((parts.hour ?? 0) * 60 + (parts.minute ?? 0)),
            birthdayEnabled: notifEnabled("notif_oshi_birthday"),
            mondayEnabled: notifEnabled("notif_monday"),
            liveWeekEnabled: notifEnabled("notif_live_week"),
            ticketEnabled: notifEnabled("notif_ticket"),
            pickIdolIds: pickIdolIds,
            eventIds: Array(favoriteIds.union(attendedIds)).sorted(),
            // 月曜のミームのレア抽選 (1/500) の種。
            seed: UInt64.random(in: .min ... .max))
        let store = try await AppContainer.shared.coreSnapshot.loadedStore()
        return try store.notificationPlan(input: input)
    }

    /// 予定 1 件を通知にする。日付 + 時・分で、くり返さない (積み直しのたびに次の 1 回を積む)。
    private func notificationRequest(for item: PlannedNotificationRecord) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = item.title
        if let body = item.body { content.body = body }
        content.sound = .default
        if let idolId = item.imageIdolId,
           let attachment = customImageAttachment(idolId: idolId, identifier: "\(item.id)_img") {
            content.attachments = [attachment]
        }
        var components = DateComponents()
        let dateParts = item.date.split(separator: "-").compactMap { Int($0) }
        if dateParts.count == 3 {
            components.year = dateParts[0]
            components.month = dateParts[1]
            components.day = dateParts[2]
        }
        components.hour = Int(item.hour)
        components.minute = Int(item.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        return UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
    }

    // MARK: - Helpers

    /// ユーザーがアプリ内で取り込んだアイドル画像を通知添付にする。
    /// 版権セーフ: 運営が同梱するのではなく、ユーザー自身のローカル画像のみ使う。
    /// UNNotificationAttachment はファイルを所有(移動)しうるため temp にコピーして渡す。
    private func customImageAttachment(idolId: String, identifier: String) -> UNNotificationAttachment? {
        guard let src = CustomImageService.shared.imageURL(for: idolId),
              FileManager.default.fileExists(atPath: src.path) else { return nil }
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent("notif_\(identifier).jpg")
        try? FileManager.default.removeItem(at: tmp)
        do {
            try FileManager.default.copyItem(at: src, to: tmp)
            return try UNNotificationAttachment(identifier: identifier, url: tmp, options: nil)
        } catch {
            return nil
        }
    }

    /// UserDefaults から設定を読む。未設定（nil）なら既定 true。
    private func notifEnabled(_ key: String) -> Bool {
        guard UserDefaults.standard.object(forKey: key) != nil else { return true }
        return UserDefaults.standard.bool(forKey: key)
    }
}
