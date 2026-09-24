// 生成物: i18n/catalog/mypage.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/mypage.json の文言。L10n.Mypage から引く (iOS の L10n.Mypage と同じ名前)。 */
object L10nMypage {
    /** 現地参加のライブがありません — 参加したライブ一覧で「現地」(または「すべて」) に 1 件も無いときの空状態 */
    val attendedEmptyLive: DisplayText get() = DisplayText.Res(R.string.mypage_attended_empty_live)
    /** ライブビューイング参加のライブがありません — 参加したライブ一覧で「ライブビューイング」(映画館での中継) に 1 件も無いときの空状態 */
    val attendedEmptyLiveViewing: DisplayText get() = DisplayText.Res(R.string.mypage_attended_empty_live_viewing)
    /** 配信参加のライブがありません — 参加したライブ一覧で「配信」に 1 件も無いときの空状態 */
    val attendedEmptyStream: DisplayText get() = DisplayText.Res(R.string.mypage_attended_empty_stream)
    /** すべて — 参加したライブ一覧の絞り込みセグメントの先頭 (形態で絞らない)。ほかの選択肢 (現地・配信・LV) はコアの語彙をそのまま出す */
    val attendedFilterAll: DisplayText get() = DisplayText.Res(R.string.mypage_attended_filter_all)
    /** 参加したライブ — 参加したライブ一覧の画面タイトル (プロデュースの「参加したライブ すべて見る」から開く) */
    val attendedTitle: DisplayText get() = DisplayText.Res(R.string.mypage_attended_title)
    /** 内訳 — 投稿の種類ごとの件数を並べる節の見出し */
    val contributionsBreakdownHeader: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_breakdown_header)
    /** セトリ編集・動画追加・タグ追加が累計に含まれます。再インストールするとカウントはリセットされます (端末ローカル記録)。 — マイ投稿の画面の下の注意書き。数は端末にだけ記録している */
    val contributionsHelp: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_help)
    /** セトリ編集 — 投稿の種類: セットリストの編集 */
    val contributionsKindSetlistEdit: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_kind_setlist_edit)
    /** タグ — 投稿の種類: タグの追加 */
    val contributionsKindTag: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_kind_tag)
    /** 動画 — 投稿の種類: 参考動画の追加 */
    val contributionsKindVideo: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_kind_video)
    /** マイ投稿 — 自分の投稿累計の画面タイトル (プロデュースの「投稿」タイルから開く)。投稿 = セトリ編集・動画追加・タグ追加 */
    val contributionsTitle: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_title)
    /** コミュニティへの投稿累計 — 累計の大きな数字の下の説明 */
    val contributionsTotalCaption: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_total_caption)
    /** 件 — 投稿の件数の右に添える単位。数字は大きく別に出すので単位だけの文言 (累計のカードと内訳の各行) */
    val contributionsUnit: DisplayText get() = DisplayText.Res(R.string.mypage_contributions_unit)
    /** お気に入りのライブがありません — お気に入りのライブが 1 つも無いときの空状態 */
    val favoritesEventsEmpty: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_events_empty)
    /** お気に入りのアイドルがいません — お気に入りのアイドルが 1 人もいないときの空状態 */
    val favoritesIdolsEmpty: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_idols_empty)
    /** お気に入りの曲がありません — お気に入りの曲が 1 つも無いときの空状態 */
    val favoritesSongsEmpty: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_songs_empty)
    /** ライブ — お気に入り一覧のセグメント: ライブ (イベント) */
    val favoritesTabEvents: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_tab_events)
    /** アイドル — お気に入り一覧のセグメント: アイドル */
    val favoritesTabIdols: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_tab_idols)
    /** 曲 — お気に入り一覧のセグメント: 曲 */
    val favoritesTabSongs: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_tab_songs)
    /** お気に入り — お気に入り一覧の画面タイトル (プロデュースの「お気に入り」タイルから開く) */
    val favoritesTitle: DisplayText get() = DisplayText.Res(R.string.mypage_favorites_title)
}
