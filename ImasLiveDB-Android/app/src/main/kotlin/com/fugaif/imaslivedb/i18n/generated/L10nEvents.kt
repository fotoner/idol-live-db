// 生成物: i18n/catalog/events.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/events.json の文言。L10n.Events から引く (iOS の L10n.Events と同じ名前)。 */
object L10nEvents {
    /** キャンセル — メモ・座席の入力と、公演への参加を選ぶダイアログの取り消しボタン */
    val actionCancel: DisplayText get() = DisplayText.Res(R.string.events_action_cancel)
    /** 保存 — メモ・座席の入力の保存ボタン */
    val actionSave: DisplayText get() = DisplayText.Res(R.string.events_action_save)
    /** 全公演に現地参加 — 全公演をまとめて現地参加にする行 */
    val attendanceSheetAllLive: DisplayText get() = DisplayText.Res(R.string.events_attendance_sheet_all_live)
    /** 公演ごとに参加形態を選べます。回収率には現地参加だけが数えられます。 — 参加シートの説明。iOS の attendance_sheet.footer_ios と ja が違う */
    val attendanceSheetFooterAndroid: DisplayText get() = DisplayText.Res(R.string.events_attendance_sheet_footer_android)
    /** {count}公演 — 「全公演に現地参加」の行の右に出す公演数。1000 以上は桁区切りが付く (ありえない) — 引数: count (count) */
    fun attendanceSheetShowCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_attendance_sheet_show_count, count, listOf(count))
    /** 参加した公演 — イベントの公演ごとに参加を選ぶシートの見出し */
    val attendanceSheetTitle: DisplayText get() = DisplayText.Res(R.string.events_attendance_sheet_title)
    /** {month}/{day}({weekday}) — 出演パネルの DAY 見出しの日付。weekday は表示言語の 1 文字の曜日 (土 / 토) — 引数: month (int), day (int), weekday (string) */
    fun castDayDate(month: Int, day: Int, weekday: String): DisplayText = DisplayText.Res(R.string.events_cast_day_date, listOf(month, day, weekday))
    /** セトリ・出演者が登録されると表示されます — 出演パネルの空状態の説明 */
    val castEmptyMessage: DisplayText get() = DisplayText.Res(R.string.events_cast_empty_message)
    /** 出演情報がありません — 出演パネルの空状態の見出し */
    val castEmptyTitle: DisplayText get() = DisplayText.Res(R.string.events_cast_empty_title)
    /** {present}/{total} 名 — 全員集合の帯の右の人数 (出演 / ブランド全体)。1000 以上は桁区切りが付く (ありえない) — 引数: present (int), total (count) */
    fun castFullAttendanceCount(present: Int, total: Int): DisplayText = DisplayText.Plural(R.plurals.events_cast_full_attendance_count, total, listOf(present, total))
    /** 全員集合！ — ブランドのアイドルが全員出演したライブの帯 */
    val castFullAttendanceTitle: DisplayText get() = DisplayText.Res(R.string.events_cast_full_attendance_title)
    /** {label} ・ {count}名 — 出演パネル: DAY ごと・欠席などのまとまりの見出し。label はコアが付けた名前 (DAY1・欠席など)。1000 以上は桁区切りが付く (ありえない) — 引数: label (core), count (count) */
    fun castGroupHeader(label: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.events_cast_group_header, count, listOf(label, count))
    /** ゲスト — 出演パネル: ゲストの節の見出し (1 人のとき) と、アバターの下の札 */
    val castRoleGuest: DisplayText get() = DisplayText.Res(R.string.events_cast_role_guest)
    /** ゲスト ・ {count}名 — 出演パネル: ゲストの節の見出し (2 人以上のとき)。1000 以上は桁区切りが付く (ありえない) — 引数: count (count) */
    fun castRoleGuestCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_cast_role_guest_count, count, listOf(count))
    /** 主演 — 出演パネル: 主演の節の見出し (1 人のとき) と、アバターの下の札 */
    val castRoleLead: DisplayText get() = DisplayText.Res(R.string.events_cast_role_lead)
    /** 主演 ・ {count}名 — 出演パネル: 主演の節の見出し (2 人以上のとき)。1000 以上は桁区切りが付く (ありえない) — 引数: count (count) */
    fun castRoleLeadCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_cast_role_lead_count, count, listOf(count))
    /** ・ 合同 — ライブ詳細の日付の行の後ろに付ける、合同ライブ (複数ブランド) の印 */
    val detailHeroJoint: DisplayText get() = DisplayText.Res(R.string.events_detail_hero_joint)
    /** ライブ・公演の編集にはログインが必要です。 — 未ログインで編集しようとしたときのダイアログの本文 */
    val detailLoginDialog: DisplayText get() = DisplayText.Res(R.string.events_detail_login_dialog)
    /** このライブを編集 — ライブ詳細の右上メニュー: ライブを編集。iOS の detail.menu.edit と ja が違う */
    val detailMenuEditAndroid: DisplayText get() = DisplayText.Res(R.string.events_detail_menu_edit_android)
    /** 編集履歴 — ライブ詳細の右上メニュー (Android は公演の行の ⋮ メニューにも): 編集履歴を開く */
    val detailMenuHistory: DisplayText get() = DisplayText.Res(R.string.events_detail_menu_history)
    /** このイベントをシェア — ライブ詳細の右上の共有ボタンの読み上げ */
    val detailShareA11y: DisplayText get() = DisplayText.Res(R.string.events_detail_share_a11y)
    /** 公演を追加 — 公演を追加する操作。iOS は公演が無いときの空状態のボタン、Android は右上メニュー */
    val detailShowsActionAddShow: DisplayText get() = DisplayText.Res(R.string.events_detail_shows_action_add_show)
    /** 公演を編集 — 公演の行のメニュー (iOS は長押し、Android は ⋮) */
    val detailShowsActionEditShow: DisplayText get() = DisplayText.Res(R.string.events_detail_shows_action_edit_show)
    /** 公演がまだありません — 公演が 1 つも無いときの空状態の見出し */
    val detailShowsEmptyTitle: DisplayText get() = DisplayText.Res(R.string.events_detail_shows_empty_title)
    /** 公演 ・ {count} 公演 → セトリへ — 公演一覧の節の見出し。行を押すとセトリへ進む。1000 以上は桁区切りが付く (ありえない) — 引数: count (count) */
    fun detailShowsHeader(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_detail_shows_header, count, listOf(count))
    /** 公演の操作 — 公演の行の ⋮ ボタンの読み上げ */
    val detailShowsMenuA11y: DisplayText get() = DisplayText.Res(R.string.events_detail_shows_menu_a11y)
    /** 出演 — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報) */
    val detailTabCast: DisplayText get() = DisplayText.Res(R.string.events_detail_tab_cast)
    /** 情報 — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報) */
    val detailTabInfo: DisplayText get() = DisplayText.Res(R.string.events_detail_tab_info)
    /** 公演・セトリ — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報) */
    val detailTabShows: DisplayText get() = DisplayText.Res(R.string.events_detail_tab_shows)
    /** 適用 — フィルタシートの、選択を一覧に反映するボタン */
    val filterActionApply: DisplayText get() = DisplayText.Res(R.string.events_filter_action_apply)
    /** リセット — フィルタシートの、選択を初期状態に戻すボタン */
    val filterActionReset: DisplayText get() = DisplayText.Res(R.string.events_filter_action_reset)
    /** すべて — 参加状態の選択肢: 絞らない */
    val filterAttendanceAll: DisplayText get() = DisplayText.Res(R.string.events_filter_attendance_all)
    /** 参加済み — 参加状態の選択肢 (と適用中のチップ): 参加したライブだけ */
    val filterAttendanceAttended: DisplayText get() = DisplayText.Res(R.string.events_filter_attendance_attended)
    /** 参加状態 — フィルタシートの節: 参加したかどうか */
    val filterAttendanceHeader: DisplayText get() = DisplayText.Res(R.string.events_filter_attendance_header)
    /** 未参加 — 参加状態の選択肢 (と適用中のチップ): 参加していないライブだけ */
    val filterAttendanceNotAttended: DisplayText get() = DisplayText.Res(R.string.events_filter_attendance_not_attended)
    /** 全て — フィルタシート: ブランドで絞らないチップ */
    val filterBrandAll: DisplayText get() = DisplayText.Res(R.string.events_filter_brand_all)
    /** ブランド — フィルタシートの節: ブランド */
    val filterBrandHeader: DisplayText get() = DisplayText.Res(R.string.events_filter_brand_header)
    /** 表示設定 — フィルタシートの節: 一覧に出す範囲 */
    val filterDisplayHeader: DisplayText get() = DisplayText.Res(R.string.events_filter_display_header)
    /** 配信・番組だけのイベント (公演として開かれていないもの) を一覧から隠す — フィルタシートのスイッチの説明 */
    val filterDisplayHideStreamingSubtitle: DisplayText get() = DisplayText.Res(R.string.events_filter_display_hide_streaming_subtitle)
    /** 配信を除く — フィルタシートのスイッチ (と適用中のチップ): 配信・番組だけのイベントを隠す */
    val filterDisplayHideStreamingTitle: DisplayText get() = DisplayText.Res(R.string.events_filter_display_hide_streaming_title)
    /** 公演がまだ登録されていないライブを一覧に出す — フィルタシートのスイッチの説明 */
    val filterDisplayShowEmptySubtitle: DisplayText get() = DisplayText.Res(R.string.events_filter_display_show_empty_subtitle)
    /** セトリ情報がないライブも表示 — フィルタシートのスイッチ */
    val filterDisplayShowEmptyTitle: DisplayText get() = DisplayText.Res(R.string.events_filter_display_show_empty_title)
    /** 全て表示中 — フィルタシート: どの種別も除外していないとき */
    val filterKindAllShown: DisplayText get() = DisplayText.Res(R.string.events_filter_kind_all_shown)
    /** 除外: {kinds} — 除外している種別。一覧のチップでは 1 つ、フィルタシートでは「 / 」区切りの並び。語はコア — 引数: kinds (core) */
    fun filterKindExcluded(kinds: String): DisplayText = DisplayText.Res(R.string.events_filter_kind_excluded, listOf(kinds))
    /** 種別 — フィルタシートの節: イベントの種別 (ライブ・フェスなど) */
    val filterKindHeader: DisplayText get() = DisplayText.Res(R.string.events_filter_kind_header)
    /** お気に入りのみ — フィルタシートのスイッチ */
    val filterMarksFavoriteOnly: DisplayText get() = DisplayText.Res(R.string.events_filter_marks_favorite_only)
    /** マイマーク — フィルタシートの節: 自分で付けた印 (お気に入り・メモ) */
    val filterMarksHeader: DisplayText get() = DisplayText.Res(R.string.events_filter_marks_header)
    /** メモがあるライブのみ — フィルタシートのスイッチ */
    val filterMarksNoteOnly: DisplayText get() = DisplayText.Res(R.string.events_filter_marks_note_only)
    /** フィルター — ライブ一覧のフィルタシートの見出しと、フィルタボタンの読み上げ */
    val filterTitle: DisplayText get() = DisplayText.Res(R.string.events_filter_title)
    /** ブランド — 情報パネルの行の名前: ブランド */
    val infoMetaBrand: DisplayText get() = DisplayText.Res(R.string.events_info_meta_brand)
    /** 年度 — 情報パネルの行の名前: 開催年 */
    val infoMetaYear: DisplayText get() = DisplayText.Res(R.string.events_info_meta_year)
    /** {year}年 — 情報パネルの開催年の値 — 引数: year (int) */
    fun infoMetaYearValue(year: Int): DisplayText = DisplayText.Res(R.string.events_info_meta_year_value, listOf(year))
    /** キャスト — 情報パネルの数字のタイル: 出演者数 */
    val infoStatsCast: DisplayText get() = DisplayText.Res(R.string.events_info_stats_cast)
    /** 公演 — 情報パネルの数字のタイル: 公演数 */
    val infoStatsShows: DisplayText get() = DisplayText.Res(R.string.events_info_stats_shows)
    /** 曲（延べ） — 情報パネルの数字のタイル: 全公演で歌われた曲数 (同じ曲も数える) */
    val infoStatsTotalSongs: DisplayText get() = DisplayText.Res(R.string.events_info_stats_total_songs)
    /** ユニーク曲 — 情報パネルの数字のタイル: 歌われた曲の種類数 (同じ曲は 1 回) */
    val infoStatsUniqueSongs: DisplayText get() = DisplayText.Res(R.string.events_info_stats_unique_songs)
    /** チケット情報は未登録です — チケット情報が無いとき */
    val infoTicketEmpty: DisplayText get() = DisplayText.Res(R.string.events_info_ticket_empty)
    /** チケット情報 — 情報パネル: チケット情報の節の見出し */
    val infoTicketHeader: DisplayText get() = DisplayText.Res(R.string.events_info_ticket_header)
    /** 公式チケットページを開く — チケット情報: 公式のチケットページへのリンク */
    val infoTicketOpenOfficial: DisplayText get() = DisplayText.Res(R.string.events_info_ticket_open_official)
    /** {count}件 — 絞り込み後のライブの件数。1000 以上は桁区切りが付く (移行前の Android は区切り無し: 1234件 → 1,234件) — 引数: count (count) */
    fun listCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_list_count, count, listOf(count))
    /** 開催済みのライブはまだ登録されていません。 — 「開催済み」に 1 件も無いときの説明 */
    val listEmptyPastMessage: DisplayText get() = DisplayText.Res(R.string.events_list_empty_past_message)
    /** 開催済みのライブがありません — 「開催済み」に 1 件も無いときの空状態の見出し */
    val listEmptyPastTitle: DisplayText get() = DisplayText.Res(R.string.events_list_empty_past_title)
    /** 現在、登録されている今後のライブはありません。「開催済み」タブもご確認ください。 — 「今後の予定」に 1 件も無いときの説明。「開催済み」は list.tab.past のタブの名前 */
    val listEmptyUpcomingMessage: DisplayText get() = DisplayText.Res(R.string.events_list_empty_upcoming_message)
    /** 今後の予定はありません — 「今後の予定」に 1 件も無いときの空状態の見出し */
    val listEmptyUpcomingTitle: DisplayText get() = DisplayText.Res(R.string.events_list_empty_upcoming_title)
    /** お気に入り — 適用中の絞り込みのチップ: お気に入りだけ */
    val listFilterChipFavorite: DisplayText get() = DisplayText.Res(R.string.events_list_filter_chip_favorite)
    /** メモあり — 適用中の絞り込みのチップ: メモがあるライブだけ */
    val listFilterChipHasNote: DisplayText get() = DisplayText.Res(R.string.events_list_filter_chip_has_note)
    /** 「{query}」 — 適用中の絞り込みのチップ: 名前の絞り込み語 — 引数: query (string) */
    fun listFilterChipQuery(query: String): DisplayText = DisplayText.Res(R.string.events_list_filter_chip_query, listOf(query))
    /** 空イベントも表示 — 適用中の絞り込みのチップ: 公演が無いライブも出す */
    val listFilterChipShowEmpty: DisplayText get() = DisplayText.Res(R.string.events_list_filter_chip_show_empty)
    /** ライブ名で絞り込み — 一覧の上の絞り込み欄のプレースホルダ */
    val listNameFilterPrompt: DisplayText get() = DisplayText.Res(R.string.events_list_name_filter_prompt)
    /** 開催済み — ライブ一覧のセグメント: 終わったライブ。list.empty.upcoming.message が「開催済み」タブと呼ぶ */
    val listTabPast: DisplayText get() = DisplayText.Res(R.string.events_list_tab_past)
    /** 今後の予定 — ライブ一覧のセグメント: これからのライブ */
    val listTabUpcoming: DisplayText get() = DisplayText.Res(R.string.events_list_tab_upcoming)
    /** ライブ — ライブ一覧の画面の見出し */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.events_list_title)
    /** 会場 — 会場で絞るチップ (会場を選んでいないとき) */
    val listVenueChip: DisplayText get() = DisplayText.Res(R.string.events_list_venue_chip)
    /** 会場絞り込みを解除 — 会場チップの × の読み上げ */
    val listVenueClearA11y: DisplayText get() = DisplayText.Res(R.string.events_list_venue_clear_a11y)
    /** 参加の記録 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 */
    val localWriteRecordAttendance: DisplayText get() = DisplayText.Res(R.string.events_local_write_record_attendance)
    /** メモの保存 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 */
    val localWriteSaveNote: DisplayText get() = DisplayText.Res(R.string.events_local_write_save_note)
    /** 座席の保存 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 */
    val localWriteSaveSeat: DisplayText get() = DisplayText.Res(R.string.events_local_write_save_seat)
    /** {mark}の切り替え — 端末への書き込みに失敗したときの知らせに入る操作名。mark はマークの種類名 (お気に入りなど) — 引数: mark (text) */
    fun localWriteToggle(mark: DisplayText): DisplayText = DisplayText.Res(R.string.events_local_write_toggle, listOf(mark))
    /**  ・  — 項目を 1 行に並べるときの区切り (前後に空白)。公演の「会場 ・ 日付」、会場の「キャパ ・ 旧名」など */
    val metaSeparator: DisplayText get() = DisplayText.Res(R.string.events_meta_separator)
    /** この公演の思い出・持ち物・同行者など — 公演のメモの入力欄のプレースホルダ */
    val noteEditorPlaceholder: DisplayText get() = DisplayText.Res(R.string.events_note_editor_placeholder)
    /** メモ — メモの入力シート・ダイアログの見出し */
    val noteEditorTitle: DisplayText get() = DisplayText.Res(R.string.events_note_editor_title)
    /** 例: アリーナ A6 ブロック 12番 — 座席の入力欄のプレースホルダ。iOS の seat_editor.placeholder_ios と ja が違う (統一はオーナーが別 PR で) */
    val seatEditorPlaceholderAndroid: DisplayText get() = DisplayText.Res(R.string.events_seat_editor_placeholder_android)
    /** 座席 — 座席の入力シート・ダイアログの見出し */
    val seatEditorTitle: DisplayText get() = DisplayText.Res(R.string.events_seat_editor_title)
    /** {type}で参加 — 参加の形態を選ぶダイアログの選択肢。type は形態 (現地・配信など。コアの語) — 引数: type (core) */
    fun setlistAttendanceJoin(type: String): DisplayText = DisplayText.Res(R.string.events_setlist_attendance_join, listOf(type))
    /** {type}で参加 (取り消す) — 参加の形態を選ぶダイアログの、選択中の選択肢 (押すと取り消す) — 引数: type (core) */
    fun setlistAttendanceJoinSelected(type: String): DisplayText = DisplayText.Res(R.string.events_setlist_attendance_join_selected, listOf(type))
    /** この公演への参加 — 参加の形態を選ぶダイアログの見出し */
    val setlistAttendanceTitle: DisplayText get() = DisplayText.Res(R.string.events_setlist_attendance_title)
    /** 衣装 ・ {count} 着 — セトリ画面の衣装の節の見出し。1000 以上は桁区切りが付く (ありえない) — 引数: count (count) */
    fun setlistCostumeHeader(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_setlist_costume_header, count, listOf(count))
    /** セトリを追加 — セトリが無い過去の公演の空状態のボタン (編集できる人だけ) */
    val setlistEmptyAction: DisplayText get() = DisplayText.Res(R.string.events_setlist_empty_action)
    /** セトリは公演後に登録されます — セトリが無い未来の公演の空状態の説明 */
    val setlistEmptyFutureMessage: DisplayText get() = DisplayText.Res(R.string.events_setlist_empty_future_message)
    /** 公演前です — セトリが無い未来の公演の空状態の見出し */
    val setlistEmptyFutureTitle: DisplayText get() = DisplayText.Res(R.string.events_setlist_empty_future_title)
    /** このライブのセトリはまだ登録されていません。ログインして編集に参加できます — セトリが無い過去の公演の空状態の説明 */
    val setlistEmptyPastMessage: DisplayText get() = DisplayText.Res(R.string.events_setlist_empty_past_message)
    /** セトリ未登録 — セトリが無い過去の公演の空状態の見出し */
    val setlistEmptyPastTitle: DisplayText get() = DisplayText.Res(R.string.events_setlist_empty_past_title)
    /** 日付 — セトリ画面の会場カードの行の名前: 公演日 */
    val setlistInfoDate: DisplayText get() = DisplayText.Res(R.string.events_setlist_info_date)
    /** 会場 — セトリ画面の会場カードの行の名前: 会場 */
    val setlistInfoVenue: DisplayText get() = DisplayText.Res(R.string.events_setlist_info_venue)
    /** この曲が良かった — セトリの行の 👍 ボタンの読み上げ (まだ押していないとき) */
    val setlistLikeAddA11y: DisplayText get() = DisplayText.Res(R.string.events_setlist_like_add_a11y)
    /** Like するにはログインが必要です — 未ログインで 👍 したときのエラー。iOS の setlist.like.error.unauthorized_ios と ja が違う */
    val setlistLikeErrorUnauthorizedAndroid: DisplayText get() = DisplayText.Res(R.string.events_setlist_like_error_unauthorized_android)
    /** Good を取り消す — セトリの行の 👍 ボタンの読み上げ (押してあるとき) */
    val setlistLikeRemoveA11y: DisplayText get() = DisplayText.Res(R.string.events_setlist_like_remove_a11y)
    /** セトリの編集や 👍 での投票にはログインが必要です。 — 未ログインで編集・投票しようとしたときのダイアログの本文 */
    val setlistLoginDialog: DisplayText get() = DisplayText.Res(R.string.events_setlist_login_dialog)
    /** セトリを編集 — セトリ画面の右上メニュー */
    val setlistMenuEdit: DisplayText get() = DisplayText.Res(R.string.events_setlist_menu_edit)
    /** セトリの編集履歴 — セトリ画面の右上メニュー */
    val setlistMenuHistory: DisplayText get() = DisplayText.Res(R.string.events_setlist_menu_history)
    /** 全員 — セトリの行の札: 出演者全員で歌った曲 */
    val setlistRowFullCast: DisplayText get() = DisplayText.Res(R.string.events_setlist_row_full_cast)
    /** アンコール — セトリの区切りの見出し: アンコール (コアがアンコール類をこの語に畳む) */
    val setlistSectionEncore: DisplayText get() = DisplayText.Res(R.string.events_setlist_section_encore)
    /** 本編 — セトリの区切りの見出し: 本編 (コアの見出し「本編」とメタ未取得のときに出す) */
    val setlistSectionMain: DisplayText get() = DisplayText.Res(R.string.events_setlist_section_main)
    /** チケット — セトリ画面のチケット価格の節の見出し */
    val setlistTicketHeader: DisplayText get() = DisplayText.Res(R.string.events_setlist_ticket_header)
    /** {kind}・{name} — 券の形態が 1 種類だけのときの行の名前。kind は形態 (コアの語)、name は券種名 — 引数: kind (core), name (string) */
    fun setlistTicketKindName(kind: String, name: String): DisplayText = DisplayText.Res(R.string.events_setlist_ticket_kind_name, listOf(kind, name))
    /** {name} (推定) — 推定の価格の券種名。name は券種名 (データ) — 引数: name (string) */
    fun setlistTicketNameEstimate(name: String): DisplayText = DisplayText.Res(R.string.events_setlist_ticket_name_estimate, listOf(name))
    /** {range} (推定含む) — 券の形態ごとの価格帯に推定の価格が混じるとき。range はコアが作った価格帯 — 引数: range (core) */
    fun setlistTicketRangeEstimate(range: String): DisplayText = DisplayText.Res(R.string.events_setlist_ticket_range_estimate, listOf(range))
    /** 👍 で投票するにはログインが必要です — セトリの上の案内 (未ログイン) */
    val setlistVoteHintLogin: DisplayText get() = DisplayText.Res(R.string.events_setlist_vote_hint_login)
    /** 良かったと思った曲に 👍 で投票しよう！ — セトリの上の案内 (ログイン済み) */
    val setlistVoteHintSignedIn: DisplayText get() = DisplayText.Res(R.string.events_setlist_vote_hint_signed_in)
    /** その他 — ライブ詳細・セトリ画面の右上の ⋮ メニューボタンの読み上げ */
    val toolbarMoreA11y: DisplayText get() = DisplayText.Res(R.string.events_toolbar_more_a11y)
    /** 参加 ({type}) — マイマークの帯の参加ボタン。参加の形態 (現地・配信など。語はコア) が付いているとき — 引数: type (core) */
    fun userMarkAttendedWithType(type: String): DisplayText = DisplayText.Res(R.string.events_user_mark_attended_with_type, listOf(type))
    /** 参加 — マークの種類名: 公演に参加した。マイマークの帯のボタンの名前にもなる */
    val userMarkKindAttended: DisplayText get() = DisplayText.Res(R.string.events_user_mark_kind_attended)
    /** お気に入り — マークの種類名: お気に入り。マイマークの帯のボタンの名前にもなる */
    val userMarkKindFavorite: DisplayText get() = DisplayText.Res(R.string.events_user_mark_kind_favorite)
    /** メモ — マークの種類名: 自分用のメモ。マイマークの帯のボタンの名前にもなる */
    val userMarkKindNote: DisplayText get() = DisplayText.Res(R.string.events_user_mark_kind_note)
    /** 座席 — マークの種類名: 参加した公演の座席。マイマークの帯のボタンの名前にもなる */
    val userMarkKindSeat: DisplayText get() = DisplayText.Res(R.string.events_user_mark_kind_seat)
    /** {count}人 — 会場のキャパ (収容人数)。1000 以上は桁区切りが付く (14,500人) — 引数: count (count) */
    fun venueCapacity(count: Int): DisplayText = DisplayText.Plural(R.plurals.events_venue_capacity, count, listOf(count))
    /** {prefecture}・{name} — 都道府県つきの会場名 (東京・日本武道館)。どちらもデータ — 引数: prefecture (string), name (string) */
    fun venueNameWithArea(prefecture: String, name: String): DisplayText = DisplayText.Res(R.string.events_venue_name_with_area, listOf(prefecture, name))
    /** 「{query}」に一致する会場がありません — 会場の絞り込みで 1 件も残らなかったときの説明。query は入力した語 — 引数: query (string) */
    fun venuePickerEmptyMessage(query: String): DisplayText = DisplayText.Res(R.string.events_venue_picker_empty_message, listOf(query))
    /** 見つかりません — 会場の絞り込みで 1 件も残らなかったときの見出し */
    val venuePickerEmptyTitle: DisplayText get() = DisplayText.Res(R.string.events_venue_picker_empty_title)
    /** 会場を絞り込み — 会場を選ぶ画面の絞り込み欄のプレースホルダ */
    val venuePickerFilterPrompt: DisplayText get() = DisplayText.Res(R.string.events_venue_picker_filter_prompt)
    /** 旧: {name} — 会場の行の副題: 以前の名前 (データ) — 引数: name (string) */
    fun venuePickerFormerName(name: String): DisplayText = DisplayText.Res(R.string.events_venue_picker_former_name, listOf(name))
    /** 選択なし — 会場を選ぶ画面の先頭の行: 会場で絞らない */
    val venuePickerNone: DisplayText get() = DisplayText.Res(R.string.events_venue_picker_none)
    /** 会場 — 会場を選ぶ画面の見出し */
    val venuePickerTitle: DisplayText get() = DisplayText.Res(R.string.events_venue_picker_title)
}
