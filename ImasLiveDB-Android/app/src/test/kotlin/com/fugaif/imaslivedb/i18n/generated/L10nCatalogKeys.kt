// 生成物: i18n/catalog/*.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.i18n.DisplayText

/**
 * カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。
 * L10nCatalogJaTest / L10nCatalogKoTest が実行時の解決結果と比べる (書式・エスケープ・桁区切り・複数形)。
 */
class L10nCatalogSample(
    /** 完全キー (<名前空間>.<相対キー>) */
    val key: String,
    /** リソース名 (R.string / R.plurals) */
    val resourceName: String,
    /** 値を持つ言語 (基準言語と、訳のある言語) */
    val languagesWithValue: List<String>,
    /** 見本の引数 (失敗メッセージ用) */
    val args: String,
    /** 見本の引数で作った文言 */
    val make: () -> DisplayText,
    /** 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック) */
    val expected: Map<String, String>,
) {
    /** 見本の引数で作った文言 (呼ぶたびに作る) */
    val text: DisplayText get() = make()

    override fun toString(): String = if (args.isEmpty()) key else "$key ($args)"
}

object L10nCatalogKeys {
    /** このカタログの言語 (基準言語が先頭) */
    val languages: List<String> = listOf("ja", "ko")

    /** 全キー × 見本 */
    val all: List<L10nCatalogSample>
        get() = common0() + i18n0() + nav0() + search0() + system0() + units0() + widget0()

    private fun common0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("common.action.back", "common_action_back", listOf("ja", "ko"), "", { L10n.Common.actionBack }, mapOf("ja" to "戻る", "ko" to "뒤로")),
        L10nCatalogSample("common.action.collapse", "common_action_collapse", listOf("ja", "ko"), "", { L10n.Common.actionCollapse }, mapOf("ja" to "折りたたむ", "ko" to "접기")),
        L10nCatalogSample("common.action.expand", "common_action_expand", listOf("ja", "ko"), "", { L10n.Common.actionExpand }, mapOf("ja" to "展開", "ko" to "펼치기")),
        L10nCatalogSample("common.action.retry", "common_action_retry", listOf("ja", "ko"), "", { L10n.Common.actionRetry }, mapOf("ja" to "再試行", "ko" to "다시 시도")),
        L10nCatalogSample("common.action.see_all", "common_action_see_all", listOf("ja", "ko"), "", { L10n.Common.actionSeeAll }, mapOf("ja" to "すべて見る", "ko" to "모두 보기")),
        L10nCatalogSample("common.personal_tags.add.a11y", "common_personal_tags_add_a11y", listOf("ja", "ko"), "", { L10n.Common.personalTagsAddA11y }, mapOf("ja" to "マイタグを追加", "ko" to "마이 태그 추가")),
        L10nCatalogSample("common.personal_tags.empty", "common_personal_tags_empty", listOf("ja", "ko"), "", { L10n.Common.personalTagsEmpty }, mapOf("ja" to "マイタグはまだありません", "ko" to "아직 마이 태그가 없어요")),
        L10nCatalogSample("common.personal_tags.header", "common_personal_tags_header", listOf("ja", "ko"), "", { L10n.Common.personalTagsHeader }, mapOf("ja" to "マイタグ(自分だけに表示)", "ko" to "마이 태그 (나에게만 보여요)")),
        L10nCatalogSample("common.personal_tags.placeholder", "common_personal_tags_placeholder", listOf("ja", "ko"), "", { L10n.Common.personalTagsPlaceholder }, mapOf("ja" to "例: 聞いた", "ko" to "예: 들었음")),
        L10nCatalogSample("common.personal_tags.remove.a11y", "common_personal_tags_remove_a11y", listOf("ja", "ko"), "", { L10n.Common.personalTagsRemoveA11y }, mapOf("ja" to "削除", "ko" to "삭제")),
        L10nCatalogSample("common.personal_tags.remove.hint", "common_personal_tags_remove_hint", listOf("ja", "ko"), "", { L10n.Common.personalTagsRemoveHint }, mapOf("ja" to "長押しで削除", "ko" to "길게 눌러 삭제")),
    )

    private fun i18n0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("i18n.language_tag", "i18n_language_tag", listOf("ja", "ko"), "", { L10n.I18n.languageTag }, mapOf("ja" to "ja", "ko" to "ko")),
    )

    private fun nav0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("nav.settings_button.a11y", "nav_settings_button_a11y", listOf("ja", "ko"), "", { L10n.Nav.settingsButtonA11y }, mapOf("ja" to "設定・マイ", "ko" to "설정·마이페이지")),
        L10nCatalogSample("nav.tab.events", "nav_tab_events", listOf("ja", "ko"), "", { L10n.Nav.tabEvents }, mapOf("ja" to "ライブ", "ko" to "라이브")),
        L10nCatalogSample("nav.tab.idols", "nav_tab_idols", listOf("ja", "ko"), "", { L10n.Nav.tabIdols }, mapOf("ja" to "アイドル", "ko" to "아이돌")),
        L10nCatalogSample("nav.tab.produce", "nav_tab_produce", listOf("ja", "ko"), "", { L10n.Nav.tabProduce }, mapOf("ja" to "プロデュース", "ko" to "프로듀스")),
        L10nCatalogSample("nav.tab.schedule", "nav_tab_schedule", listOf("ja", "ko"), "", { L10n.Nav.tabSchedule }, mapOf("ja" to "スケジュール", "ko" to "스케줄")),
        L10nCatalogSample("nav.tab.songs", "nav_tab_songs", listOf("ja", "ko"), "", { L10n.Nav.tabSongs }, mapOf("ja" to "楽曲", "ko" to "곡")),
    )

    private fun search0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("search.cross_tab.chip", "search_cross_tab_chip", listOf("ja", "ko"), "tab=<i18n.language_tag>, count=2026", { L10n.Search.crossTabChip(tab = L10n.I18n.languageTag, count = 2026) }, mapOf("ja" to "jaに 2026", "ko" to "ko에 2026")),
        L10nCatalogSample("search.cross_tab.header", "search_cross_tab_header", listOf("ja", "ko"), "", { L10n.Search.crossTabHeader }, mapOf("ja" to "別のタブ", "ko" to "다른 탭")),
    )

    private fun system0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("system.app.display_name", "system_app_display_name", listOf("ja"), "", { L10n.System.appDisplayName }, mapOf("ja" to "アイドルライブDB", "ko" to "アイドルライブDB")),
    )

    private fun units0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("units.detail.community.login_dialog", "units_detail_community_login_dialog", listOf("ja", "ko"), "", { L10n.Units.detailCommunityLoginDialog }, mapOf("ja" to "タグ付け・投票にはログインが必要です。", "ko" to "태그를 달거나 투표하려면 로그인해야 해요.")),
        L10nCatalogSample("units.detail.community.login_prompt", "units_detail_community_login_prompt", listOf("ja", "ko"), "", { L10n.Units.detailCommunityLoginPrompt }, mapOf("ja" to "タグ付け・投票にはログインが必要です", "ko" to "태그를 달거나 투표하려면 로그인해야 해요")),
        L10nCatalogSample("units.detail.load_error.message", "units_detail_load_error_message", listOf("ja", "ko"), "", { L10n.Units.detailLoadErrorMessage }, mapOf("ja" to "読み込みに失敗しました。通信状況を確認してもう一度お試しください。", "ko" to "불러오지 못했어요. 통신 상태를 확인하고 다시 시도해 주세요.")),
        L10nCatalogSample("units.detail.load_error.title", "units_detail_load_error_title", listOf("ja", "ko"), "", { L10n.Units.detailLoadErrorTitle }, mapOf("ja" to "読み込みに失敗しました", "ko" to "불러오지 못했어요")),
        L10nCatalogSample("units.detail.members.empty.title_android", "units_detail_members_empty_title_android", listOf("ja", "ko"), "", { L10n.Units.detailMembersEmptyTitleAndroid }, mapOf("ja" to "メンバー情報がありません", "ko" to "멤버 정보가 없어요")),
        L10nCatalogSample("units.detail.members.header", "units_detail_members_header", listOf("ja", "ko"), "", { L10n.Units.detailMembersHeader }, mapOf("ja" to "メンバー", "ko" to "멤버")),
        L10nCatalogSample("units.detail.not_found.message", "units_detail_not_found_message", listOf("ja", "ko"), "", { L10n.Units.detailNotFoundMessage }, mapOf("ja" to "ユニットが見つかりませんでした。", "ko" to "유닛을 찾지 못했어요.")),
        L10nCatalogSample("units.detail.similar.header", "units_detail_similar_header", listOf("ja", "ko"), "", { L10n.Units.detailSimilarHeader }, mapOf("ja" to "タグが似ているユニット", "ko" to "태그가 비슷한 유닛")),
        L10nCatalogSample("units.detail.similar.shared_tags", "units_detail_similar_shared_tags", listOf("ja", "ko"), "count=1", { L10n.Units.detailSimilarSharedTags(count = 1) }, mapOf("ja" to "タグ1個一致", "ko" to "태그 1개 일치")),
        L10nCatalogSample("units.detail.similar.shared_tags", "units_detail_similar_shared_tags", listOf("ja", "ko"), "count=3", { L10n.Units.detailSimilarSharedTags(count = 3) }, mapOf("ja" to "タグ3個一致", "ko" to "태그 3개 일치")),
        L10nCatalogSample("units.detail.similar.shared_tags", "units_detail_similar_shared_tags", listOf("ja", "ko"), "count=1234", { L10n.Units.detailSimilarSharedTags(count = 1234) }, mapOf("ja" to "タグ1,234個一致", "ko" to "태그 1,234개 일치")),
        L10nCatalogSample("units.detail.songs.empty.title", "units_detail_songs_empty_title", listOf("ja", "ko"), "", { L10n.Units.detailSongsEmptyTitle }, mapOf("ja" to "楽曲がありません", "ko" to "곡이 없어요")),
        L10nCatalogSample("units.detail.songs.header", "units_detail_songs_header", listOf("ja", "ko"), "", { L10n.Units.detailSongsHeader }, mapOf("ja" to "楽曲", "ko" to "곡")),
        L10nCatalogSample("units.detail.tab.community", "units_detail_tab_community", listOf("ja", "ko"), "", { L10n.Units.detailTabCommunity }, mapOf("ja" to "コミュニティ", "ko" to "커뮤니티")),
        L10nCatalogSample("units.detail.tab.members", "units_detail_tab_members", listOf("ja", "ko"), "", { L10n.Units.detailTabMembers }, mapOf("ja" to "メンバー", "ko" to "멤버")),
        L10nCatalogSample("units.detail.tab.songs", "units_detail_tab_songs", listOf("ja", "ko"), "", { L10n.Units.detailTabSongs }, mapOf("ja" to "楽曲", "ko" to "곡")),
        L10nCatalogSample("units.detail.tags.action.add", "units_detail_tags_action_add", listOf("ja", "ko"), "", { L10n.Units.detailTagsActionAdd }, mapOf("ja" to "タグを追加", "ko" to "태그 추가")),
        L10nCatalogSample("units.detail.tags.empty.title", "units_detail_tags_empty_title", listOf("ja", "ko"), "", { L10n.Units.detailTagsEmptyTitle }, mapOf("ja" to "タグはまだありません", "ko" to "아직 태그가 없어요")),
        L10nCatalogSample("units.detail.tags.header", "units_detail_tags_header", listOf("ja", "ko"), "", { L10n.Units.detailTagsHeader }, mapOf("ja" to "タグ", "ko" to "태그")),
        L10nCatalogSample("units.list.empty.message", "units_list_empty_message", listOf("ja", "ko"), "", { L10n.Units.listEmptyMessage }, mapOf("ja" to "登録されているユニットがまだありません。", "ko" to "등록된 유닛이 아직 없어요.")),
        L10nCatalogSample("units.list.empty.title", "units_list_empty_title", listOf("ja", "ko"), "", { L10n.Units.listEmptyTitle }, mapOf("ja" to "ユニットがありません", "ko" to "유닛이 없어요")),
        L10nCatalogSample("units.list.filter_empty.message_android", "units_list_filter_empty_message_android", listOf("ja", "ko"), "query=かな カナ1", { L10n.Units.listFilterEmptyMessageAndroid(query = "かな カナ1") }, mapOf("ja" to "「かな カナ1」に一致するユニットはいません。", "ko" to "“かな カナ1”에 해당하는 유닛이 없어요.")),
        L10nCatalogSample("units.list.filter_empty.title_android", "units_list_filter_empty_title_android", listOf("ja", "ko"), "", { L10n.Units.listFilterEmptyTitleAndroid }, mapOf("ja" to "見つかりませんでした", "ko" to "찾지 못했어요")),
        L10nCatalogSample("units.list.name_filter.prompt", "units_list_name_filter_prompt", listOf("ja", "ko"), "", { L10n.Units.listNameFilterPrompt }, mapOf("ja" to "ユニット名で絞り込み", "ko" to "유닛 이름으로 찾기")),
    )

    private fun widget0(): List<L10nCatalogSample> = listOf(
        L10nCatalogSample("widget.next_live.description", "widget_next_live_description", listOf("ja", "ko"), "", { L10n.Widget.nextLiveDescription }, mapOf("ja" to "次のライブまでの日数を表示します。", "ko" to "다음 라이브까지 남은 날을 보여 줘요.")),
        L10nCatalogSample("widget.next_live.name", "widget_next_live_name", listOf("ja", "ko"), "", { L10n.Widget.nextLiveName }, mapOf("ja" to "次のライブ", "ko" to "다음 라이브")),
        L10nCatalogSample("widget.oshi_image.description", "widget_oshi_image_description", listOf("ja", "ko"), "", { L10n.Widget.oshiImageDescription }, mapOf("ja" to "担当アイドルの取り込んだ画像をホーム画面に出します。タップで次の画像に切り替わります。", "ko" to "가져온 담당 아이돌 이미지를 홈 화면에 보여 줘요. 탭하면 다음 이미지로 바뀌어요.")),
        L10nCatalogSample("widget.oshi_image.name", "widget_oshi_image_name", listOf("ja", "ko"), "", { L10n.Widget.oshiImageName }, mapOf("ja" to "担当の画像（タップで切替）", "ko" to "담당 이미지 (탭으로 전환)")),
        L10nCatalogSample("widget.oshi_launcher.description", "widget_oshi_launcher_description", listOf("ja", "ko"), "", { L10n.Widget.oshiLauncherDescription }, mapOf("ja" to "担当アイドルの取り込んだ画像をホーム画面に出します。タップするとアプリが開きます。", "ko" to "가져온 담당 아이돌 이미지를 홈 화면에 보여 줘요. 탭하면 앱이 열려요.")),
        L10nCatalogSample("widget.oshi_launcher.name", "widget_oshi_launcher_name", listOf("ja", "ko"), "", { L10n.Widget.oshiLauncherName }, mapOf("ja" to "担当の画像（タップでアプリ）", "ko" to "담당 이미지 (탭으로 앱 열기)")),
        L10nCatalogSample("widget.select_oshi.title", "widget_select_oshi_title", listOf("ja", "ko"), "", { L10n.Widget.selectOshiTitle }, mapOf("ja" to "担当を選ぶ", "ko" to "담당 고르기")),
        L10nCatalogSample("widget.ticket_deadline.description", "widget_ticket_deadline_description", listOf("ja", "ko"), "", { L10n.Widget.ticketDeadlineDescription }, mapOf("ja" to "締切が近いチケットの先行受付を表示します。", "ko" to "마감이 가까운 티켓 선행 접수를 보여 줘요.")),
        L10nCatalogSample("widget.ticket_deadline.name", "widget_ticket_deadline_name", listOf("ja", "ko"), "", { L10n.Widget.ticketDeadlineName }, mapOf("ja" to "チケット締切", "ko" to "티켓 마감")),
        L10nCatalogSample("widget.today_song.description", "widget_today_song_description", listOf("ja", "ko"), "", { L10n.Widget.todaySongDescription }, mapOf("ja" to "日替わりで1曲をジャケット付きで表示します。", "ko" to "날마다 한 곡을 재킷과 함께 보여 줘요.")),
        L10nCatalogSample("widget.today_song.name", "widget_today_song_name", listOf("ja", "ko"), "", { L10n.Widget.todaySongName }, mapOf("ja" to "今日の1曲", "ko" to "오늘의 한 곡")),
    )
}
