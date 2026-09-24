// 生成物: i18n/catalog/units.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/units.json の文言。L10n.Units から引く (iOS の L10n.Units と同じ名前)。 */
object L10nUnits {
    /** タグ付け・投票にはログインが必要です。 — 未ログインでタグを付けようとしたときのダイアログの本文 (Android) */
    val detailCommunityLoginDialog: DisplayText get() = DisplayText.Res(R.string.units_detail_community_login_dialog)
    /** タグ付け・投票にはログインが必要です — コミュニティの節の先頭に出す、未ログインの人への案内 */
    val detailCommunityLoginPrompt: DisplayText get() = DisplayText.Res(R.string.units_detail_community_login_prompt)
    /** 読み込みに失敗しました。通信状況を確認してもう一度お試しください。 — 詳細の読み込みに失敗したときの説明 */
    val detailLoadErrorMessage: DisplayText get() = DisplayText.Res(R.string.units_detail_load_error_message)
    /** 読み込みに失敗しました — 詳細の読み込みに失敗したときの空状態の見出し */
    val detailLoadErrorTitle: DisplayText get() = DisplayText.Res(R.string.units_detail_load_error_title)
    /** メンバー情報がありません — Android の文言。iOS の detail.members.empty.title と ja が違う (統一はオーナーが別 PR で) */
    val detailMembersEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.units_detail_members_empty_title_android)
    /** メンバー — メンバーの節の見出し (右に人数) */
    val detailMembersHeader: DisplayText get() = DisplayText.Res(R.string.units_detail_members_header)
    /** ユニットが見つかりませんでした。 — 開こうとしたユニットがデータに無いとき (Android) */
    val detailNotFoundMessage: DisplayText get() = DisplayText.Res(R.string.units_detail_not_found_message)
    /** タグが似ているユニット — タグが似ているユニット (サーバ算出のおすすめ) の節の見出し */
    val detailSimilarHeader: DisplayText get() = DisplayText.Res(R.string.units_detail_similar_header)
    /** タグ{count}個一致 — おすすめのユニットの下に出す、共通するタグの数 — 引数: count (count) */
    fun detailSimilarSharedTags(count: Int): DisplayText = DisplayText.Plural(R.plurals.units_detail_similar_shared_tags, count, listOf(count))
    /** 楽曲がありません — 楽曲が 1 曲も無いときの空状態の見出し */
    val detailSongsEmptyTitle: DisplayText get() = DisplayText.Res(R.string.units_detail_songs_empty_title)
    /** 楽曲 — 楽曲の節の見出し (右に件数) */
    val detailSongsHeader: DisplayText get() = DisplayText.Res(R.string.units_detail_songs_header)
    /** コミュニティ — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ) */
    val detailTabCommunity: DisplayText get() = DisplayText.Res(R.string.units_detail_tab_community)
    /** メンバー — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ) */
    val detailTabMembers: DisplayText get() = DisplayText.Res(R.string.units_detail_tab_members)
    /** 楽曲 — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ) */
    val detailTabSongs: DisplayText get() = DisplayText.Res(R.string.units_detail_tab_songs)
    /** タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ */
    val detailTagsActionAdd: DisplayText get() = DisplayText.Res(R.string.units_detail_tags_action_add)
    /** タグはまだありません — タグが 1 つも無いとき */
    val detailTagsEmptyTitle: DisplayText get() = DisplayText.Res(R.string.units_detail_tags_empty_title)
    /** タグ — コミュニティタグの節の見出し */
    val detailTagsHeader: DisplayText get() = DisplayText.Res(R.string.units_detail_tags_header)
    /** 登録されているユニットがまだありません。 — ユニットが 1 件も無いときの空状態の説明 */
    val listEmptyMessage: DisplayText get() = DisplayText.Res(R.string.units_list_empty_message)
    /** ユニットがありません — ユニットが 1 件も無いときの空状態の見出し */
    val listEmptyTitle: DisplayText get() = DisplayText.Res(R.string.units_list_empty_title)
    /** 「{query}」に一致するユニットはいません。 — Android の文言。iOS の list.filter_empty.message と ja が違う (統一はオーナーが別 PR で)。query は利用者が打った語 — 引数: query (string) */
    fun listFilterEmptyMessageAndroid(query: String): DisplayText = DisplayText.Res(R.string.units_list_filter_empty_message_android, listOf(query))
    /** 見つかりませんでした — Android の文言。iOS の list.filter_empty.title と ja が違う (統一はオーナーが別 PR で) */
    val listFilterEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.units_list_filter_empty_title_android)
    /** ユニット名で絞り込み — 一覧の先頭の絞り込み欄のプレースホルダ (Android) */
    val listNameFilterPrompt: DisplayText get() = DisplayText.Res(R.string.units_list_name_filter_prompt)
}
