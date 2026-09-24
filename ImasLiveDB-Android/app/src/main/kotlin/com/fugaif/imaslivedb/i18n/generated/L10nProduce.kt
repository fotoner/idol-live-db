// 生成物: i18n/catalog/produce.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/produce.json の文言。L10n.Produce から引く (iOS の L10n.Produce と同じ名前)。 */
object L10nProduce {
    /** 参加ライブ — 件数タイルのラベル (参加したライブの数) */
    val activityAttended: DisplayText get() = DisplayText.Res(R.string.produce_activity_attended)
    /** 回収 — 件数タイルのラベル (ライブで生で聴いた曲の数) */
    val activityCollected: DisplayText get() = DisplayText.Res(R.string.produce_activity_collected)
    /** 投稿 — 件数タイルのラベル (自分の投稿・編集の数) */
    val activityContributions: DisplayText get() = DisplayText.Res(R.string.produce_activity_contributions)
    /** お気に入り — 件数タイルのラベル (お気に入りの数) */
    val activityFavorites: DisplayText get() = DisplayText.Res(R.string.produce_activity_favorites)
    /** あなたの活動 — 件数タイルの節の見出し */
    val activityHeader: DisplayText get() = DisplayText.Res(R.string.produce_activity_header)
    /** 投票 — 件数タイルのラベル (投票したお題の数) */
    val activityVotes: DisplayText get() = DisplayText.Res(R.string.produce_activity_votes)
    /** 参加したライブ — 参加したライブの節の見出し (右に件数) */
    val attendedHeader: DisplayText get() = DisplayText.Res(R.string.produce_attended_header)
    /** 全て見る ({count}件) — 参加したライブの節の下の導線 (6 件以上のとき)。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun attendedSeeAll(count: Int): DisplayText = DisplayText.Plural(R.plurals.produce_attended_see_all, count, listOf(count))
    /** {count}曲 — 回収した楽曲の一覧の先頭の曲数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった (count 型の規則に合わせた)。 — 引数: count (count) */
    fun collectedCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.produce_collected_count, count, listOf(count))
    /** ライブに「参加」を付けると、そのセトリの曲がここに集まります。 — 回収した楽曲が 1 曲も無いときの空状態の説明 */
    val collectedEmptyMessage: DisplayText get() = DisplayText.Res(R.string.produce_collected_empty_message)
    /** まだ回収した楽曲がありません — 回収した楽曲が 1 曲も無いときの空状態の見出し */
    val collectedEmptyTitle: DisplayText get() = DisplayText.Res(R.string.produce_collected_empty_title)
    /** 回収した楽曲 — 回収した楽曲 (参加したライブで聴いた曲) の一覧の画面タイトル */
    val collectedTitle: DisplayText get() = DisplayText.Res(R.string.produce_collected_title)
    /** 伸びてるタグ・急上昇の曲やアイドルをチェック — タグの動きの入口の説明。iOS は入口カード、Android はハブの行 */
    val entryTagActivityPreview: DisplayText get() = DisplayText.Res(R.string.produce_entry_tag_activity_preview)
    /** タグの動き — タグの動き (伸びているタグ) の入口。iOS は入口カード、Android はハブの行 */
    val entryTagActivityTitle: DisplayText get() = DisplayText.Res(R.string.produce_entry_tag_activity_title)
    /** ライブ・楽曲シリーズ・節目を1枚で俯瞰する — 年表の入口の説明。iOS は入口カード、Android はハブの行 */
    val entryTimelinePreview: DisplayText get() = DisplayText.Res(R.string.produce_entry_timeline_preview)
    /** 年表 — 年表 (ブランドの歴史) の入口。iOS は入口カード、Android はハブの行 */
    val entryTimelineTitle: DisplayText get() = DisplayText.Res(R.string.produce_entry_timeline_title)
    /** お気に入りアイドル — お気に入りのアイドルの横並びの節の見出し (Android) */
    val favoritesIdols: DisplayText get() = DisplayText.Res(R.string.produce_favorites_idols)
    /** お気に入り曲 — お気に入りの曲の節の見出し (Android) */
    val favoritesSongs: DisplayText get() = DisplayText.Res(R.string.produce_favorites_songs)
    /** 参加したライブ — ハブの行 (参加したライブの一覧へ) */
    val hubAttendedTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_attended_title)
    /** 現地で聴けた曲だけの一覧 — ハブの行「回収した楽曲」の説明 */
    val hubCollectedSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_collected_subtitle)
    /** 回収した楽曲 — ハブの行 (回収した楽曲の一覧へ) */
    val hubCollectedTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_collected_title)
    /** マイ投稿・編集履歴 — ハブの行 (自分の投稿・編集の一覧へ) */
    val hubContributionsTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_contributions_title)
    /** みんなの編集履歴 — ハブの行 (最近のコミュニティの編集へ) */
    val hubEditHistoryTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_edit_history_title)
    /** アイドルや楽曲の詳細画面で ♥ を押すと、担当・お気に入りがここに並びます — 担当もお気に入りも無いときの案内 (Android) */
    val hubEmptyHint: DisplayText get() = DisplayText.Res(R.string.produce_hub_empty_hint)
    /** 曲・アイドル・ライブ — ハブの行「お気に入り一覧」の説明 */
    val hubFavoritesSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_favorites_subtitle)
    /** お気に入り一覧 — ハブの行 (お気に入りの一覧へ) */
    val hubFavoritesTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_favorites_title)
    /** クイズ・イントロ当てクイズ — ハブの行「ゲーム」の説明 */
    val hubGamesSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_games_subtitle)
    /** ゲーム — ハブの行 (ゲームの一覧へ) */
    val hubGamesTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_games_title)
    /** 使った額 {amount} — ハブの行「収支」の説明。amount はコアが書式した金額 (¥12,000 など) — 引数: amount (core) */
    fun hubLedgerSubtitle(amount: String): DisplayText = DisplayText.Res(R.string.produce_hub_ledger_subtitle, listOf(amount))
    /** 収支 — ハブの行 (家計簿へ) */
    val hubLedgerTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_ledger_title)
    /** どこまで覚えたかをシリーズ・ユニット別に — ハブの行「習熟度」の説明 */
    val hubMasterySubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_mastery_subtitle)
    /** 習熟度 — ハブの行 (習熟度の画面へ) */
    val hubMasteryTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_mastery_title)
    /** タグ・ペンライト・ポール — ハブの行「投票・予想」の説明 */
    val hubPollsSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_polls_subtitle)
    /** 投票・予想 — ハブの行 (投票の画面へ) */
    val hubPollsTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_polls_title)
    /** 設定・マイ — ハブの行 (設定・マイページへ)。右上の歯車の読み上げは nav.settings_button.a11y */
    val hubSettingsTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_settings_title)
    /** ブランド別・年別・ランキング — ハブの行「統計」の説明 */
    val hubStatsSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_stats_subtitle)
    /** 統計 — ハブの行 (統計の画面へ) */
    val hubStatsTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_stats_title)
    /** 楽曲タグの作成・閲覧 — ハブの行「みんなのタグ」の説明 */
    val hubTagsSubtitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_tags_subtitle)
    /** みんなのタグ — ハブの行 (タグの一覧へ) */
    val hubTagsTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_tags_title)
    /** 投票履歴 — ハブの行 (自分の投票の一覧へ) */
    val hubVotesTitle: DisplayText get() = DisplayText.Res(R.string.produce_hub_votes_title)
    /** 担当 — 担当アイドルの横並びの節の見出し。Android の文言で、iOS の oshi.header と ja が違う (統一はオーナーが別 PR で) */
    val oshiHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.produce_oshi_header_android)
    /** 投票する — 「開催中のお題」カードの右下の導線 */
    val pollAction: DisplayText get() = DisplayText.Res(R.string.produce_poll_action)
    /** 投票受付中 — 先頭の「開催中のお題」カードの左上のラベル */
    val pollBadge: DisplayText get() = DisplayText.Res(R.string.produce_poll_badge)
    /** {count}候補 — 「開催中のお題」カードの候補の数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun pollEntries(count: Int): DisplayText = DisplayText.Plural(R.plurals.produce_poll_entries, count, listOf(count))
    /** {count}票 — 「開催中のお題」カードの票数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun pollVotes(count: Int): DisplayText = DisplayText.Plural(R.plurals.produce_poll_votes, count, listOf(count))
    /** 最近見た — 最近開いたライブ・曲・アイドルのチップ列の見出し */
    val recentsHeader: DisplayText get() = DisplayText.Res(R.string.produce_recents_header)
    /** プロデュース — プロデュースタブ (担当・活動のまとめ) の画面タイトル。iOS はナビゲーションタイトル、Android は TopAppBar */
    val title: DisplayText get() = DisplayText.Res(R.string.produce_title)
}
