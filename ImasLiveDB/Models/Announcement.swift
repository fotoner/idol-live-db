import SwiftUI

/// アプリ内蔵のお知らせ (新機能告知など)。サーバー不要・アプデで増える (ゼロコスト)。
///
/// 見出し・要約・本文は i18n/catalog/announcements.json の文言 (Android と同じキーを引く)。
/// お知らせを足すときは、先にカタログへ `<slug>.title` / `.summary` / `.body.p<n>` を足してから参照する。
struct Announcement: Identifiable {
    let id: String        // リリースをまたいで安定させる (既読の記録キー。訳さない)
    let date: String      // "2026-06-17"
    let title: LocalizedStringResource
    let summary: LocalizedStringResource
    let body: [LocalizedStringResource]    // 段落
    let icon: String      // SF Symbol
    let tint: Color
    let link: AnnouncementLink?
}

/// お知らせ詳細から開ける遷移先 (任意)。
enum AnnouncementLink {
    case widgetHowTo
}

enum AnnouncementCatalog {
    /// 新しいものほど上 (表示順)。
    ///
    /// 文言 (LocalizedStringResource) は作った時点の言語で固まるので static let に置かず、読むたびに作る。
    static var all: [Announcement] { [
        Announcement(
            id: "v2.3.0_setlist_gap",
            date: "2026-09-20",
            title: L10n.Announcements.setlistGapTitle,
            summary: L10n.Announcements.setlistGapSummary,
            body: [
                L10n.Announcements.setlistGapBodyP1,
                L10n.Announcements.setlistGapBodyP2,
                L10n.Announcements.setlistGapBodyP3,
                L10n.Announcements.setlistGapBodyP4,
            ],
            icon: "clock.arrow.circlepath",
            tint: Color(red: 0.38, green: 0.60, blue: 0.92),
            link: nil
        ),
        Announcement(
            id: "20260906_call_response_retired",
            date: "2026-09-06",
            title: L10n.Announcements.callResponseRetiredTitle,
            summary: L10n.Announcements.callResponseRetiredSummary,
            body: [
                L10n.Announcements.callResponseRetiredBodyP1,
                L10n.Announcements.callResponseRetiredBodyP2,
                L10n.Announcements.callResponseRetiredBodyP3,
            ],
            icon: "hands.clap.fill",
            tint: Color(red: 0.95, green: 0.55, blue: 0.30),
            link: nil
        ),
        Announcement(
            id: "v2.3.0_call_guide_dashboard",
            date: "2026-09-04",
            title: L10n.Announcements.callGuideDashboardTitle,
            summary: L10n.Announcements.callGuideDashboardSummary,
            body: [
                L10n.Announcements.callGuideDashboardBodyP1,
                L10n.Announcements.callGuideDashboardBodyP2,
                L10n.Announcements.callGuideDashboardBodyP3,
                L10n.Announcements.callGuideDashboardBodyP4,
            ],
            icon: "hands.clap.fill",
            tint: Color(red: 0.95, green: 0.55, blue: 0.30),
            link: nil
        ),
        Announcement(
            id: "v2.2.0_lyrics",
            date: "2026-09-03",
            title: L10n.Announcements.lyricsTitle,
            summary: L10n.Announcements.lyricsSummary,
            body: [
                L10n.Announcements.lyricsBodyP1,
                L10n.Announcements.lyricsBodyP2,
                L10n.Announcements.lyricsBodyP3,
                L10n.Announcements.lyricsBodyP4,
                L10n.Announcements.lyricsBodyP5,
            ],
            icon: "text.quote",
            tint: Color(red: 0.82, green: 0.55, blue: 0.35),
            link: nil
        ),
        Announcement(
            id: "v2.1.0_cross_tab_search",
            date: "2026-09-01",
            title: L10n.Announcements.crossTabSearchTitle,
            summary: L10n.Announcements.crossTabSearchSummary,
            body: [
                L10n.Announcements.crossTabSearchBodyP1,
                L10n.Announcements.crossTabSearchBodyP2,
                L10n.Announcements.crossTabSearchBodyP3,
                L10n.Announcements.crossTabSearchBodyP4,
                L10n.Announcements.crossTabSearchBodyP5,
                L10n.Announcements.crossTabSearchBodyP6,
                L10n.Announcements.crossTabSearchBodyP7,
                L10n.Announcements.crossTabSearchBodyP8,
            ],
            icon: "magnifyingglass",
            tint: Color(red: 0.36, green: 0.60, blue: 0.90),
            link: nil
        ),
        Announcement(
            id: "v2.0.0_readings_android_parity",
            date: "2026-08-28",
            title: L10n.Announcements.readingsAndroidParityTitle,
            summary: L10n.Announcements.readingsAndroidParitySummary,
            body: [
                L10n.Announcements.readingsAndroidParityBodyP1,
                L10n.Announcements.readingsAndroidParityBodyP2,
                L10n.Announcements.readingsAndroidParityBodyP3,
                L10n.Announcements.readingsAndroidParityBodyP4,
                L10n.Announcements.readingsAndroidParityBodyP5,
                L10n.Announcements.readingsAndroidParityBodyP6,
                L10n.Announcements.readingsAndroidParityBodyP7,
                L10n.Announcements.readingsAndroidParityBodyP8,
                L10n.Announcements.readingsAndroidParityBodyP9,
            ],
            icon: "textformat.abc.dottedunderline",
            tint: Color(red: 0.45, green: 0.78, blue: 0.55),
            link: nil
        ),
        Announcement(
            id: "v1.11.0_search_timeline",
            date: "2026-08-24",
            title: L10n.Announcements.searchTimelineTitle,
            summary: L10n.Announcements.searchTimelineSummary,
            body: [
                L10n.Announcements.searchTimelineBodyP1,
                L10n.Announcements.searchTimelineBodyP2,
                L10n.Announcements.searchTimelineBodyP3,
                L10n.Announcements.searchTimelineBodyP4,
                L10n.Announcements.searchTimelineBodyP5,
                L10n.Announcements.searchTimelineBodyP6,
                L10n.Announcements.searchTimelineBodyP7,
                L10n.Announcements.searchTimelineBodyP8,
            ],
            icon: "magnifyingglass",
            tint: Color(red: 0.42, green: 0.6, blue: 0.88),
            link: nil
        ),
        Announcement(
            id: "v1.10.0_venues_setlist_copy",
            date: "2026-07-27",
            title: L10n.Announcements.venuesSetlistCopyTitle,
            summary: L10n.Announcements.venuesSetlistCopySummary,
            body: [
                L10n.Announcements.venuesSetlistCopyBodyP1,
                L10n.Announcements.venuesSetlistCopyBodyP2,
                L10n.Announcements.venuesSetlistCopyBodyP3,
                L10n.Announcements.venuesSetlistCopyBodyP4,
                L10n.Announcements.venuesSetlistCopyBodyP5,
                L10n.Announcements.venuesSetlistCopyBodyP6,
            ],
            icon: "building.2",
            tint: Color(red: 0.45, green: 0.75, blue: 0.6),
            link: nil
        ),
        Announcement(
            id: "v1.9.0_idol_tags_community",
            date: "2026-07-10",
            title: L10n.Announcements.idolTagsCommunityTitle,
            summary: L10n.Announcements.idolTagsCommunitySummary,
            body: [
                L10n.Announcements.idolTagsCommunityBodyP1,
                L10n.Announcements.idolTagsCommunityBodyP2,
                L10n.Announcements.idolTagsCommunityBodyP3,
                L10n.Announcements.idolTagsCommunityBodyP4,
            ],
            icon: "tag.circle",
            tint: Color(red: 0.4, green: 0.65, blue: 0.85),
            link: nil
        ),
        Announcement(
            id: "v1.8.1_polls_scope",
            date: "2026-06-29",
            title: L10n.Announcements.pollsScopeTitle,
            summary: L10n.Announcements.pollsScopeSummary,
            body: [
                L10n.Announcements.pollsScopeBodyP1,
                L10n.Announcements.pollsScopeBodyP2,
                L10n.Announcements.pollsScopeBodyP3,
                L10n.Announcements.pollsScopeBodyP4,
                L10n.Announcements.pollsScopeBodyP5,
                L10n.Announcements.pollsScopeBodyP6,
            ],
            icon: "list.bullet.rectangle.portrait",
            tint: Color(red: 0.85, green: 0.4, blue: 0.65),
            link: nil
        ),
        Announcement(
            id: "v1.8.0_polls_polish",
            date: "2026-06-27",
            title: L10n.Announcements.pollsPolishTitle,
            summary: L10n.Announcements.pollsPolishSummary,
            body: [
                L10n.Announcements.pollsPolishBodyP1,
                L10n.Announcements.pollsPolishBodyP2,
                L10n.Announcements.pollsPolishBodyP3,
                L10n.Announcements.pollsPolishBodyP4,
                L10n.Announcements.pollsPolishBodyP5,
            ],
            icon: "chart.bar.doc.horizontal",
            tint: Color(red: 0.95, green: 0.62, blue: 0.12),
            link: nil
        ),
        Announcement(
            id: "v1.7.1_widget_polish",
            date: "2026-06-19",
            title: L10n.Announcements.widgetPolishTitle,
            summary: L10n.Announcements.widgetPolishSummary,
            body: [
                L10n.Announcements.widgetPolishBodyP1,
                L10n.Announcements.widgetPolishBodyP2,
                L10n.Announcements.widgetPolishBodyP3,
            ],
            icon: "rectangle.stack.badge.play",
            tint: Color(red: 0.4, green: 0.5, blue: 1),
            link: .widgetHowTo
        ),
        Announcement(
            id: "v1.7_oshi_widget",
            date: "2026-06-17",
            title: L10n.Announcements.oshiWidgetTitle,
            summary: L10n.Announcements.oshiWidgetSummary,
            body: [
                L10n.Announcements.oshiWidgetBodyP1,
                L10n.Announcements.oshiWidgetBodyP2,
                L10n.Announcements.oshiWidgetBodyP3,
            ],
            icon: "person.crop.square.badge.camera",
            tint: Color(red: 1, green: 0.3, blue: 0.55),
            link: .widgetHowTo
        ),
    ] }
}

/// App.init など MainActor 隔離外からも読める軽量ヘルパ (UserDefaults 直読み)。
enum AnnouncementDefaults {
    static let readKey = "read_announcement_ids"
    static let seenVersionKey = "announce_seen_version"

    /// 未読が 1 件でもあるか。
    static func hasUnread() -> Bool {
        let read = Set(UserDefaults.standard.stringArray(forKey: readKey) ?? [])
        return AnnouncementCatalog.all.contains { !read.contains($0.id) }
    }
}
