package com.fugaif.imaslivedb.ui.settings

import android.content.Context
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Abc
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.AddAPhoto
import androidx.compose.material.icons.filled.Apartment
import androidx.compose.material.icons.filled.BarChart
import androidx.compose.material.icons.filled.Poll
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Sell
import androidx.compose.material.icons.filled.Widgets
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.vector.ImageVector
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve

/**
 * アプリ内蔵のお知らせ (新機能告知)。iOS `Models/Announcement.swift` / `Services/AnnouncementStore.swift` の移植。
 *
 * **サーバー不要**。アプデのたびにこの定数へ 1 件足すだけで増える。既読はローカルに持つ。
 *
 * 見出し・要約・本文は i18n/catalog/announcements.json の文言で、iOS と同じキーを引く
 * (両 OS でリリースノートが食い違うと、どちらが本当か分からなくなるため。Android だけ文面が違う段落は
 * `*_android` のキーにしてある)。アイコンだけは SF Symbol → Material Icons の対応を人が決め、
 * 色は iOS の `Color(red:green:blue:)` を hex に写して `ImasTheme.derive` に渡す。
 */
data class Announcement(
    /** リリースをまたいで安定させる id。既読の記録キーになるので変えないこと (訳さない)。 */
    val id: String,
    val date: String,
    val titleText: DisplayText,
    val summaryText: DisplayText,
    /** 段落。 */
    val bodyText: List<DisplayText>,
    val icon: ImageVector,
    /** 装飾テーマ seed (hex)。iOS と同じ色。 */
    val tint: String,
    val link: AnnouncementLink? = null
) {
    // 画面の言語で解決した文字列 (Compose の中でだけ読める)。受信箱 (InboxScreen) がこれを Text に渡す。
    val title: String @Composable get() = titleText.resolve()
    val summary: String @Composable get() = summaryText.resolve()
    val body: List<String> @Composable get() = bodyText.map { it.resolve() }
}

/** お知らせ詳細から開ける遷移先 (任意)。 */
enum class AnnouncementLink { WIDGET_HOW_TO }

object AnnouncementCatalog {
    /** 新しいものほど上 (表示順)。 */
    val all: List<Announcement> = listOf(
        Announcement(
            id = "20260906_call_response_retired",
            date = "2026-09-06",
            titleText = L10n.Announcements.callResponseRetiredTitle,
            summaryText = L10n.Announcements.callResponseRetiredSummary,
            bodyText = listOf(
                L10n.Announcements.callResponseRetiredBodyP1Android,
                L10n.Announcements.callResponseRetiredBodyP2Android,
            ),
            icon = Icons.Filled.Info,
            tint = "#F28C4D",
            link = null
        ),
        Announcement(
            id = "v2.1.0_cross_tab_search",
            date = "2026-09-01",
            titleText = L10n.Announcements.crossTabSearchTitle,
            summaryText = L10n.Announcements.crossTabSearchSummary,
            bodyText = listOf(
                L10n.Announcements.crossTabSearchBodyP1,
                L10n.Announcements.crossTabSearchBodyP2,
                L10n.Announcements.crossTabSearchBodyP3,
                L10n.Announcements.crossTabSearchBodyP4,
                L10n.Announcements.crossTabSearchBodyP5,
                L10n.Announcements.crossTabSearchBodyP6,
                L10n.Announcements.crossTabSearchBodyP7,
                L10n.Announcements.crossTabSearchBodyP8,
            ),
            icon = Icons.Filled.Search,
            tint = "#5C99E6",
            link = null
        ),
        Announcement(
            id = "v2.0.0_readings_android_parity",
            date = "2026-08-28",
            titleText = L10n.Announcements.readingsAndroidParityTitle,
            summaryText = L10n.Announcements.readingsAndroidParitySummary,
            bodyText = listOf(
                L10n.Announcements.readingsAndroidParityBodyP1,
                L10n.Announcements.readingsAndroidParityBodyP2,
                L10n.Announcements.readingsAndroidParityBodyP3,
                L10n.Announcements.readingsAndroidParityBodyP4,
                L10n.Announcements.readingsAndroidParityBodyP5,
                L10n.Announcements.readingsAndroidParityBodyP6,
                L10n.Announcements.readingsAndroidParityBodyP7,
                L10n.Announcements.readingsAndroidParityBodyP8,
                L10n.Announcements.readingsAndroidParityBodyP9,
            ),
            icon = Icons.Filled.Abc,
            tint = "#73C78C",
            link = null
        ),
        Announcement(
            id = "v1.11.0_search_timeline",
            date = "2026-08-24",
            titleText = L10n.Announcements.searchTimelineTitle,
            summaryText = L10n.Announcements.searchTimelineSummary,
            bodyText = listOf(
                L10n.Announcements.searchTimelineBodyP1,
                L10n.Announcements.searchTimelineBodyP2,
                L10n.Announcements.searchTimelineBodyP3,
                L10n.Announcements.searchTimelineBodyP4,
                L10n.Announcements.searchTimelineBodyP5,
                L10n.Announcements.searchTimelineBodyP6,
                L10n.Announcements.searchTimelineBodyP7,
                L10n.Announcements.searchTimelineBodyP8,
            ),
            icon = Icons.Filled.Search,
            tint = "#6B99E0",
            link = null
        ),
        Announcement(
            id = "v1.10.0_venues_setlist_copy",
            date = "2026-07-27",
            titleText = L10n.Announcements.venuesSetlistCopyTitle,
            summaryText = L10n.Announcements.venuesSetlistCopySummary,
            bodyText = listOf(
                L10n.Announcements.venuesSetlistCopyBodyP1,
                L10n.Announcements.venuesSetlistCopyBodyP2,
                L10n.Announcements.venuesSetlistCopyBodyP3,
                L10n.Announcements.venuesSetlistCopyBodyP4,
                L10n.Announcements.venuesSetlistCopyBodyP5,
                L10n.Announcements.venuesSetlistCopyBodyP6,
            ),
            icon = Icons.Filled.Apartment,
            tint = "#73BF99",
            link = null
        ),
        Announcement(
            id = "v1.9.0_idol_tags_community",
            date = "2026-07-10",
            titleText = L10n.Announcements.idolTagsCommunityTitle,
            summaryText = L10n.Announcements.idolTagsCommunitySummary,
            bodyText = listOf(
                L10n.Announcements.idolTagsCommunityBodyP1,
                L10n.Announcements.idolTagsCommunityBodyP2,
                L10n.Announcements.idolTagsCommunityBodyP3,
                L10n.Announcements.idolTagsCommunityBodyP4,
            ),
            icon = Icons.Filled.Sell,
            tint = "#66A6D9",
            link = null
        ),
        Announcement(
            id = "v1.8.1_polls_scope",
            date = "2026-06-29",
            titleText = L10n.Announcements.pollsScopeTitle,
            summaryText = L10n.Announcements.pollsScopeSummary,
            bodyText = listOf(
                L10n.Announcements.pollsScopeBodyP1,
                L10n.Announcements.pollsScopeBodyP2,
                L10n.Announcements.pollsScopeBodyP3,
                L10n.Announcements.pollsScopeBodyP4,
                L10n.Announcements.pollsScopeBodyP5,
                L10n.Announcements.pollsScopeBodyP6,
            ),
            icon = Icons.Filled.Poll,
            tint = "#D966A6",
            link = null
        ),
        Announcement(
            id = "v1.8.0_polls_polish",
            date = "2026-06-27",
            titleText = L10n.Announcements.pollsPolishTitle,
            summaryText = L10n.Announcements.pollsPolishSummary,
            bodyText = listOf(
                L10n.Announcements.pollsPolishBodyP1,
                L10n.Announcements.pollsPolishBodyP2,
                L10n.Announcements.pollsPolishBodyP3,
                L10n.Announcements.pollsPolishBodyP4,
                L10n.Announcements.pollsPolishBodyP5,
            ),
            icon = Icons.Filled.BarChart,
            tint = "#F29E1F",
            link = null
        ),
        Announcement(
            id = "v1.7.1_widget_polish",
            date = "2026-06-19",
            titleText = L10n.Announcements.widgetPolishTitle,
            summaryText = L10n.Announcements.widgetPolishSummary,
            bodyText = listOf(
                L10n.Announcements.widgetPolishBodyP1,
                L10n.Announcements.widgetPolishBodyP2,
                L10n.Announcements.widgetPolishBodyP3,
            ),
            icon = Icons.Filled.Widgets,
            tint = "#6680FF",
            link = AnnouncementLink.WIDGET_HOW_TO
        ),
        Announcement(
            id = "v1.7_oshi_widget",
            date = "2026-06-17",
            titleText = L10n.Announcements.oshiWidgetTitle,
            summaryText = L10n.Announcements.oshiWidgetSummary,
            bodyText = listOf(
                L10n.Announcements.oshiWidgetBodyP1,
                L10n.Announcements.oshiWidgetBodyP2,
                L10n.Announcements.oshiWidgetBodyP3,
            ),
            icon = Icons.Filled.AddAPhoto,
            tint = "#FF4C8C",
            link = AnnouncementLink.WIDGET_HOW_TO
        ),
    )
}

/**
 * お知らせの既読状態をローカルに持つ。サーバー不要。
 *
 * 保存キーは iOS の `AnnouncementDefaults` と同じ名前にしてある。同じ端末で
 * 両方を使うことは無いが、名前が揃っていないと「どちらの実装の話か」を
 * コードから追えなくなる。
 */
class AnnouncementStore(context: Context) {

    private val prefs = context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    private fun readIds(): Set<String> = prefs.getStringSet(KEY_READ, emptySet()) ?: emptySet()

    fun isRead(id: String): Boolean = id in readIds()

    fun markRead(id: String) {
        val next = readIds() + id
        // getStringSet が返す Set は SharedPreferences の内部インスタンスなので、
        // 直接いじらず新しい Set を渡す (in-place 変更は次回読み出しまで反映されない)。
        prefs.edit().putStringSet(KEY_READ, next).apply()
    }

    fun markAllRead() {
        prefs.edit().putStringSet(KEY_READ, AnnouncementCatalog.all.map { it.id }.toSet()).apply()
    }

    private companion object {
        const val PREFS_NAME = "announcements"
        const val KEY_READ = "announce_read_ids"
    }
}
