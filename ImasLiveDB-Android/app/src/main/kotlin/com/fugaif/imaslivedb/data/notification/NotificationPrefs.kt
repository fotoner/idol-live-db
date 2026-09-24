package com.fugaif.imaslivedb.data.notification

import android.content.Context
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n

/**
 * 通知の 4 カテゴリ。iOS `NotificationService` / `MyPageView.notificationSection` と 1:1。
 *
 * `prefKey` は iOS の UserDefaults キーをそのまま使う。バックアップの引き継ぎや
 * ドキュメント上で「同じ設定」だと分かるようにするため、Android 側で独自に
 * 命名し直さない。
 *
 * `channelId` はカテゴリごとに分けている。iOS は通知種別を 1 つのバケツで扱うが、
 * Android は「システム設定側でカテゴリ単位に音・重要度を切れる」のが標準の作法で、
 * アプリ内トグル 4 つとちょうど対応する。
 *
 * チャンネルの名前と説明はカタログの文言 ([channelNameText] / [channelDescriptionText]) を正とし、
 * チャンネルを作る出口 (NotificationScheduler.ensureChannels) で `resolve(context)` する。
 */
enum class NotificationCategory(
    val prefKey: String,
    val channelId: String,
    /** システムの通知設定に出るチャンネル名 (カタログの文言)。 */
    val channelNameText: DisplayText,
    /** システムの通知設定に出るチャンネルの説明 (カタログの文言)。 */
    val channelDescriptionText: DisplayText
) {
    OSHI_BIRTHDAY(
        prefKey = "notif_oshi_birthday",
        channelId = "imas_oshi_birthday",
        channelNameText = L10n.Settings.notificationsChannelOshiBirthdayName,
        channelDescriptionText = L10n.Settings.notificationsChannelOshiBirthdayDescription
    ),
    LIVE_WEEK(
        prefKey = "notif_live_week",
        channelId = "imas_live_week",
        channelNameText = L10n.Settings.notificationsChannelLiveWeekName,
        channelDescriptionText = L10n.Settings.notificationsChannelLiveWeekDescription
    ),
    TICKET(
        prefKey = "notif_ticket",
        channelId = "imas_ticket",
        channelNameText = L10n.Settings.notificationsChannelTicketName,
        channelDescriptionText = L10n.Settings.notificationsChannelTicketDescription
    ),
    MONDAY(
        prefKey = "notif_monday",
        channelId = "imas_monday",
        channelNameText = L10n.Settings.notificationsChannelMondayName,
        channelDescriptionText = L10n.Settings.notificationsChannelMondayDescription
    )
}

/**
 * 通知設定の保存先。iOS が UserDefaults を直読みしているのと同じ位置づけで、
 * ViewModel を挟まず Scheduler と設定 UI の両方から触れるようにしてある
 * (BroadcastReceiver からも読むため、ViewModel 依存にはできない)。
 *
 * 「未設定なら既定 ON」も iOS の `notifEnabled` と同じ。初回インストール直後から
 * 通知許可さえ取れれば 4 種すべてが動く。
 */
class NotificationPrefs(context: Context) {

    private val prefs = context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun isEnabled(category: NotificationCategory): Boolean =
        prefs.getBoolean(category.prefKey, true)

    fun setEnabled(category: NotificationCategory, enabled: Boolean) {
        prefs.edit().putBoolean(category.prefKey, enabled).apply()
    }

    /**
     * 現在 AlarmManager に積んである通知 id の一覧。
     *
     * iOS の `removeAllPendingNotificationRequests()` に相当するものが AlarmManager には
     * 無く、「予約を消す」には登録時と同一の PendingIntent を作り直して cancel するしかない。
     * プロセスをまたいでも消せるように、積んだ id をここに残しておく。
     */
    fun scheduledIds(): List<String> =
        prefs.getStringSet(KEY_SCHEDULED_IDS, emptySet())?.toList() ?: emptyList()

    fun setScheduledIds(ids: List<String>) {
        // getStringSet が返す Set は SharedPreferences 内部の実体を共有しうるので、
        // 必ず新しい Set を渡す (同じインスタンスを put すると保存されないことがある)。
        prefs.edit().putStringSet(KEY_SCHEDULED_IDS, LinkedHashSet(ids)).apply()
    }

    private companion object {
        const val PREFS_NAME = "imas_notifications"
        const val KEY_SCHEDULED_IDS = "scheduled_ids"
    }
}
