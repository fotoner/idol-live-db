// 生成物: i18n/catalog/stats.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/stats.json の文言。L10n.Stats から引く (iOS の L10n.Stats と同じ名前)。 */
object L10nStats {
    /** ブランド別の回収率 — ブランド別の回収率の節の見出し */
    val brandProgressHeader: DisplayText get() = DisplayText.Res(R.string.stats_brand_progress_header)
    /** マスタ規模 ・ ブランド別楽曲数 — ブランドごとの登録曲数の見出し。マスタはアプリのマスタデータ (データベース) のこと (ko の「마스터」は作品名 (아이돌마스터) や称号に読めるので DB と訳す) */
    val brandSongsHeader: DisplayText get() = DisplayText.Res(R.string.stats_brand_songs_header)
    /** 活動量 ・ 出演回数 — 出演回数の多い人のランキングの見出し */
    val castShowHeader: DisplayText get() = DisplayText.Res(R.string.stats_cast_show_header)
    /** 人 — 出演回数のランキングの数字の単位。数字は各アイドルの出演公演数なので ko は「회」(37회)。ja の「人」は移行前の表示をそのまま残したもので、回 (または 公演) に直すのはオーナーの承認を得て別の PR で行う */
    val castShowUnit: DisplayText get() = DisplayText.Res(R.string.stats_cast_show_unit)
    /** 過去に披露 — 公演カードの右の数字の説明 (その曲が過去の公演で歌われた) */
    val catchChanceCaption: DisplayText get() = DisplayText.Res(R.string.stats_catch_chance_caption)
    /** {date} ・ {event} — 公演カードの上の行。date は 6/4 のような月日、event はイベント名 — 引数: date (string), event (string) */
    fun catchChanceDateEvent(date: String, event: String): DisplayText = DisplayText.Res(R.string.stats_catch_chance_date_event, listOf(date, event))
    /** この公演で聴けるかも — これからの公演で未回収の曲が聴けそうなものの節の見出し */
    val catchChanceHeader: DisplayText get() = DisplayText.Res(R.string.stats_catch_chance_header)
    /** 曲 — 公演カードの右の数字の単位 (聴けそうな未回収の曲数) */
    val catchChanceUnit: DisplayText get() = DisplayText.Res(R.string.stats_catch_chance_unit)
    /** 回収ダッシュボード — 統計タブ (回収ダッシュボード) の画面の題。回収 = ライブで曲を生で聴くこと */
    val dashboardTitle: DisplayText get() = DisplayText.Res(R.string.stats_dashboard_title)
    /** イベント — データベースの規模のタイル: イベント数 (Android) */
    val dbEvents: DisplayText get() = DisplayText.Res(R.string.stats_db_events)
    /** アイドル — データベースの規模のタイル: アイドル数 (Android) */
    val dbIdols: DisplayText get() = DisplayText.Res(R.string.stats_db_idols)
    /** 公演 — データベースの規模のタイル: 公演数 (Android) */
    val dbShows: DisplayText get() = DisplayText.Res(R.string.stats_db_shows)
    /** 楽曲 — データベースの規模のタイル: 曲数 (Android) */
    val dbSongs: DisplayText get() = DisplayText.Res(R.string.stats_db_songs)
    /** お気に入り登録が増えるとここにランキングが表示されます。 — ランキングが空のときの説明 */
    val heatEmptyMessage: DisplayText get() = DisplayText.Res(R.string.stats_heat_empty_message)
    /** まだデータがありません — ランキングが空のときの見出し */
    val heatEmptyTitle: DisplayText get() = DisplayText.Res(R.string.stats_heat_empty_title)
    /** コミュニティの熱量 — みんなのお気に入り登録の多い曲のランキングの節の見出し */
    val heatHeader: DisplayText get() = DisplayText.Res(R.string.stats_heat_header)
    /** 最新公演 ・ {date} — 最新の公演カードの上の行。date は 6/4 のような月日 — 引数: date (string) */
    fun latestDate(date: String): DisplayText = DisplayText.Res(R.string.stats_latest_date, listOf(date))
    /** 最新の動き — いちばん新しい公演の節の見出し */
    val latestHeader: DisplayText get() = DisplayText.Res(R.string.stats_latest_header)
    /** セトリを見る — 最新の公演カードのセトリを開く導線 */
    val latestOpenSetlist: DisplayText get() = DisplayText.Res(R.string.stats_latest_open_setlist)
    /**  ・  — 最新の公演カードの会場とセトリの曲数の区切り (前後に空白) */
    val latestSeparator: DisplayText get() = DisplayText.Res(R.string.stats_latest_separator)
    /** セトリ {count}曲 — 最新の公演カードの会場の行に続く、セトリの曲数 — 引数: count (count) */
    fun latestSetlistSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.stats_latest_setlist_songs, count, listOf(count))
    /** 活動量 ・ 披露回数 — ライブで歌われた回数の多い曲のランキングの見出し */
    val songPlayHeader: DisplayText get() = DisplayText.Res(R.string.stats_song_play_header)
    /** 回 — 披露回数のランキングの数字の単位 */
    val songPlayUnit: DisplayText get() = DisplayText.Res(R.string.stats_song_play_unit)
    /** 現地ライブで聴けた曲 — 回収した曲数の説明 */
    val summaryCaption: DisplayText get() = DisplayText.Res(R.string.stats_summary_caption)
    /** あなたの回収率 — 全体の回収率の節の見出し */
    val summaryHeader: DisplayText get() = DisplayText.Res(R.string.stats_summary_header)
    /** カードでシェア — 回収率のシェアカードを開くボタン */
    val summaryShare: DisplayText get() = DisplayText.Res(R.string.stats_summary_share)
    /** / {count}曲 — 回収した曲数の右の分母 (全曲数)。1000 以上は桁区切りが付く (/ 3,012曲) — 引数: count (count) */
    fun summaryTotalSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.stats_summary_total_songs, count, listOf(count))
    /** 参加ライブを記録すると、未回収曲がここに並びます。 — 未回収の曲が無いときの説明 (全体) */
    val uncollectedEmptyAllMessage: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_empty_all_message)
    /** 未回収曲はありません — 未回収の曲が無いときの見出し (全体) */
    val uncollectedEmptyAllTitle: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_empty_all_title)
    /** 参加ライブを記録すると、担当のオリ曲の回収状況がここに出ます。 — 担当のオリ曲に未回収が無いときの説明 */
    val uncollectedEmptyPickMessage: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_empty_pick_message)
    /** 担当曲はコンプリート！ — 担当のオリ曲に未回収が無いときの見出し */
    val uncollectedEmptyPickTitle: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_empty_pick_title)
    /** まだ生で聴けていない曲 — 未回収の曲の一覧の見出し */
    val uncollectedHeader: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_header)
    /** 担当 {collected}/{total} — 担当のオリ曲の回収数 / 曲数 (見出しの右) — 引数: collected (int), total (int) */
    fun uncollectedMyPickProgress(collected: Int, total: Int): DisplayText = DisplayText.Res(R.string.stats_uncollected_my_pick_progress, listOf(collected, total))
    /** {count}回披露 — 未回収の曲の行の右: これまでにライブで歌われた回数 — 引数: count (count) */
    fun uncollectedPlayCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.stats_uncollected_play_count, count, listOf(count))
    /** 全体 — 未回収の曲の範囲のセグメント: すべての曲 */
    val uncollectedScopeAll: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_scope_all)
    /** 担当のオリ曲 — 未回収の曲の範囲のセグメント: 担当アイドルのオリジナル曲 */
    val uncollectedScopeMyPick: DisplayText get() = DisplayText.Res(R.string.stats_uncollected_scope_my_pick)
    /** 年別 公演数 — 年ごとの公演数の見出し (Android) */
    val yearlyHeader: DisplayText get() = DisplayText.Res(R.string.stats_yearly_header)
}
