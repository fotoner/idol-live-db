// 生成物: i18n/catalog/tags.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/tags.json の文言。L10n.Tags から引く (iOS の L10n.Tags と同じ名前)。 */
object L10nTags {
    /** キャンセル — タグ画面群の取り消しボタン (作成・編集・絞り込み・追加のシート、通報の確認) */
    val actionCancel: DisplayText get() = DisplayText.Res(R.string.tags_action_cancel)
    /** OK — 通報の結果・エラー、タグ追加の失敗のアラートを閉じるボタン */
    val actionOk: DisplayText get() = DisplayText.Res(R.string.tags_action_ok)
    /** アイドルにタグを付けると、ここに反映されます。 — 「アイドル」のセグメントにタグの動きが無いときの説明 */
    val activityEmptyMessageIdols: DisplayText get() = DisplayText.Res(R.string.tags_activity_empty_message_idols)
    /** 曲にタグを付けると、ここに反映されます。 — 「曲」のセグメントにタグの動きが無いときの説明 */
    val activityEmptyMessageSongs: DisplayText get() = DisplayText.Res(R.string.tags_activity_empty_message_songs)
    /** まだ動きがありません — タグの動きが 1 件も無いときの空状態の見出し */
    val activityEmptyTitle: DisplayText get() = DisplayText.Res(R.string.tags_activity_empty_title)
    /** アイドルを読み込み中 — タグの動きの行で、アイドルの情報をまだ手元のデータから読めていないとき (名前の代わり) */
    val activityLoadingIdol: DisplayText get() = DisplayText.Res(R.string.tags_activity_loading_idol)
    /** 曲を読み込み中 — タグの動きの行で、曲の情報をまだ手元のデータから読めていないとき (曲名の代わり) */
    val activityLoadingSong: DisplayText get() = DisplayText.Res(R.string.tags_activity_loading_song)
    /** 最近つけられたタグ — タグの動きの節の見出し (新しく付けられたタグの一覧) */
    val activityRecentHeader: DisplayText get() = DisplayText.Res(R.string.tags_activity_recent_header)
    /** 「{name}」タグが付きました — 最近つけられたタグの行の説明。name はタグ名 — 引数: name (string) */
    fun activityRecentTagged(name: String): DisplayText = DisplayText.Res(R.string.tags_activity_recent_tagged, listOf(name))
    /** {count}件 — タグが急増中の行の右、直近に付けられた回数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun activityRisingCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_activity_rising_count, count, listOf(count))
    /** タグが急増中 — タグの動きの節の見出し (直近でタグが急に増えている曲・アイドル) */
    val activityRisingHeader: DisplayText get() = DisplayText.Res(R.string.tags_activity_rising_header)
    /** 「{name}」 — タグが急増中の行の、増えているタグの名前をかぎ括弧で囲んだもの。name はタグ名 — 引数: name (string) */
    fun activityRisingTag(name: String): DisplayText = DisplayText.Res(R.string.tags_activity_rising_tag, listOf(name))
    /** アイドル — タグの動きの画面のセグメント (アイドルのタグ) */
    val activityTabIdols: DisplayText get() = DisplayText.Res(R.string.tags_activity_tab_idols)
    /** 曲 — タグの動きの画面のセグメント (曲のタグ) */
    val activityTabSongs: DisplayText get() = DisplayText.Res(R.string.tags_activity_tab_songs)
    /** タグの動き — タグ付けの盛り上がり (最近付いたタグ・伸びているタグ) の画面の見出し */
    val activityTitle: DisplayText get() = DisplayText.Res(R.string.tags_activity_title)
    /** 伸びてるタグ — タグの動きの節の見出し (直近でよく付けられているタグ) */
    val activityTrendingHeader: DisplayText get() = DisplayText.Res(R.string.tags_activity_trending_header)
    /** 直近{count}件 — 伸びてるタグの行の右、直近 (7 日) に付けられた回数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun activityTrendingRecent(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_activity_trending_recent, count, listOf(count))
    /** 累計{count} — 伸びてるタグの行の右、これまでに付けられた回数の合計。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun activityTrendingTotal(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_activity_trending_total, count, listOf(count))
    /** 色なし — タグの色の選択で「色を付けない」スウォッチの読み上げ */
    val colorPickerNoneA11y: DisplayText get() = DisplayText.Res(R.string.tags_color_picker_none_a11y)
    /** 作成 — 新規タグ作成シートの確定ボタン */
    val createActionCreate: DisplayText get() = DisplayText.Res(R.string.tags_create_action_create)
    /** カテゴリ(任意) — Android の文言。iOS の create.category.header と括弧が違う (統一はオーナーが別 PR で) */
    val createCategoryHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.tags_create_category_header_android)
    /** 色(任意) — Android の文言。iOS の create.color.header と括弧が違う (統一はオーナーが別 PR で) */
    val createColorHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.tags_create_color_header_android)
    /** 説明文(任意) — Android の文言。iOS の create.description.header と括弧が違う (統一はオーナーが別 PR で) */
    val createDescriptionLabelAndroid: DisplayText get() = DisplayText.Res(R.string.tags_create_description_label_android)
    /** 作成に失敗しました — タグを作れず、サーバから説明が来なかったとき */
    val createErrorFailed: DisplayText get() = DisplayText.Res(R.string.tags_create_error_failed)
    /** タグの作成にはサインインが必要です(設定画面からサインインしてください) — 未ログインでタグを作ろうとしたとき (シートの中の文) */
    val createErrorLoginRequired: DisplayText get() = DisplayText.Res(R.string.tags_create_error_login_required)
    /** 1日10件まで作成できます。明日試してください — タグの作成が 1 日の上限 (10 件) に達したとき */
    val createErrorRateLimited: DisplayText get() = DisplayText.Res(R.string.tags_create_error_rate_limited)
    /** {length} / {max}文字 — 新規タグ作成シートの名前の欄の下の文字数 (Android)。length は今の文字数、max は上限 (30 前後。桁区切りは出ない) — 引数: length (int), max (count) */
    fun createNameCounterAndroid(length: Int, max: Int): DisplayText = DisplayText.Plural(R.plurals.tags_create_name_counter_android, max, listOf(length, max))
    /** タグ名(1〜{max}文字) — 新規タグ作成シートの名前の欄のラベル (Android)。max は文字数の上限 (30 前後。桁区切りは出ない) — 引数: max (count) */
    fun createNameLabelAndroid(max: Int): DisplayText = DisplayText.Plural(R.plurals.tags_create_name_label_android, max, listOf(max))
    /** 新規タグ作成 — 新規タグ作成シートの見出し */
    val createTitle: DisplayText get() = DisplayText.Res(R.string.tags_create_title)
    /** 説明を編集 — タグ詳細の説明の下のボタン (説明文・カテゴリ・色の編集シートを開く) */
    val detailActionEditDescription: DisplayText get() = DisplayText.Res(R.string.tags_detail_action_edit_description)
    /** 編集履歴 — タグ詳細の説明の下のボタン (説明文の編集履歴を開く) */
    val detailActionHistory: DisplayText get() = DisplayText.Res(R.string.tags_detail_action_history)
    /** 不適切なタグを通報 — タグ詳細の右上のメニューの項目 */
    val detailActionReport: DisplayText get() = DisplayText.Res(R.string.tags_detail_action_report)
    /** まだこのタグが付いたアイドルはいません — アイドルのタグ詳細で、付いたアイドルが 1 人もいないとき */
    val detailIdolsEmpty: DisplayText get() = DisplayText.Res(R.string.tags_detail_idols_empty)
    /** 「{name}」なアイドルランキング ({count}人) — Android の文言。iOS の detail.idols.header と括弧が違う (統一はオーナーが別 PR で)。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count) */
    fun detailIdolsHeaderAndroid(name: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_detail_idols_header_android, count, listOf(name, count))
    /** メニュー — タグ詳細の右上の ︙ アイコンの読み上げ */
    val detailMenuA11y: DisplayText get() = DisplayText.Res(R.string.tags_detail_menu_a11y)
    /** 説明なし — タグ詳細で、タグに説明文が無いとき */
    val detailNoDescription: DisplayText get() = DisplayText.Res(R.string.tags_detail_no_description)
    /** 通報する — タグの通報の確認ダイアログの実行ボタン */
    val detailReportConfirmAction: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_confirm_action)
    /** 不適切なコンテンツとして通報します — タグの通報の確認ダイアログの本文 */
    val detailReportConfirmMessage: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_confirm_message)
    /** タグを通報 — タグの通報の確認ダイアログの見出し */
    val detailReportConfirmTitle: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_confirm_title)
    /** ご報告ありがとうございます。内容を確認します。 — タグの通報を受け付けたときのダイアログの本文 */
    val detailReportDoneMessage: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_done_message)
    /** 通報しました — タグの通報を受け付けたときのダイアログの見出し */
    val detailReportDoneTitle: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_done_title)
    /** 通報に失敗しました。しばらくしてからお試しください。 — タグの通報に失敗したとき (Android。理由は区別しない) */
    val detailReportErrorFailed: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_error_failed)
    /** 通報エラー — タグの通報に失敗したときのダイアログの見出し */
    val detailReportErrorTitle: DisplayText get() = DisplayText.Res(R.string.tags_detail_report_error_title)
    /** まだこのタグが付いた曲はありません — 曲のタグ詳細で、付いた曲が 1 曲も無いとき */
    val detailSongsEmpty: DisplayText get() = DisplayText.Res(R.string.tags_detail_songs_empty)
    /** 「{name}」な曲ランキング ({count}曲) — Android の文言。iOS の detail.songs.header と括弧が違う (統一はオーナーが別 PR で)。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count) */
    fun detailSongsHeaderAndroid(name: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_detail_songs_header_android, count, listOf(name, count))
    /** まだこのタグが付いたユニットはいません — ユニットのタグ詳細で、付いたユニットが 1 つも無いとき */
    val detailUnitsEmpty: DisplayText get() = DisplayText.Res(R.string.tags_detail_units_empty)
    /** 「{name}」なユニットランキング ({count}組) — Android の文言。iOS の detail.units.header と括弧が違う (統一はオーナーが別 PR で)。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count) */
    fun detailUnitsHeaderAndroid(name: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_detail_units_header_android, count, listOf(name, count))
    /** {count}票 — タグ詳細のランキングの行の右端、このタグへの票の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun detailVotes(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_detail_votes, count, listOf(count))
    /** 保存 — タグの編集シートの確定ボタン */
    val editActionSave: DisplayText get() = DisplayText.Res(R.string.tags_edit_action_save)
    /** カテゴリ — タグの編集シートのカテゴリの見出し */
    val editCategoryHeader: DisplayText get() = DisplayText.Res(R.string.tags_edit_category_header)
    /** 色 — タグの編集シートの色の見出し */
    val editColorHeader: DisplayText get() = DisplayText.Res(R.string.tags_edit_color_header)
    /** 説明文 — タグの編集シートの説明文の欄の見出し (Android は欄のラベル) */
    val editDescriptionHeader: DisplayText get() = DisplayText.Res(R.string.tags_edit_description_header)
    /** 保存に失敗しました — タグの編集を保存できず、サーバから説明が来なかったとき */
    val editErrorFailed: DisplayText get() = DisplayText.Res(R.string.tags_edit_error_failed)
    /** タグの編集にはサインインが必要です(設定画面からサインインしてください) — 未ログインでタグを編集しようとしたとき (シートの中の文) */
    val editErrorLoginRequired: DisplayText get() = DisplayText.Res(R.string.tags_edit_error_login_required)
    /** 「{name}」を編集 — タグの編集シートの見出し。name はタグ名 — 引数: name (string) */
    fun editTitle(name: String): DisplayText = DisplayText.Res(R.string.tags_edit_title, listOf(name))
    /** 完了 — タグで絞り込むシートの確定ボタン */
    val filterActionDone: DisplayText get() = DisplayText.Res(R.string.tags_filter_action_done)
    /** タグがありません — タグで絞り込むシートで候補が 1 つも無いとき */
    val filterEmpty: DisplayText get() = DisplayText.Res(R.string.tags_filter_empty)
    /** {count}曲 — タグで絞り込むシートの行の右端、このタグが付いた曲の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun filterRowSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_filter_row_songs, count, listOf(count))
    /** タグ名で検索 — タグで絞り込むシートの検索欄のプレースホルダ */
    val filterSearchPrompt: DisplayText get() = DisplayText.Res(R.string.tags_filter_search_prompt)
    /** 選択中 ({count}) — すべてを含む曲に絞り込み — タグで絞り込むシートの選んだタグの見出し。count は選んだタグの数。選んだタグを全部持つ曲だけに絞る (AND)。ko の「곡만 보기」は文中の動詞としての「絞り込み」なので、用語集の 필터 / 찾기 (機能名・ボタン名) は使わない。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun filterSelectedHeader(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_filter_selected_header, count, listOf(count))
    /** タグで絞り込み — 曲一覧をタグで絞り込むシートの見出し */
    val filterTitle: DisplayText get() = DisplayText.Res(R.string.tags_filter_title)
    /** なし — 新規タグ作成・編集シートのカテゴリの選択肢の先頭 (カテゴリを付けない)。iOS はコアの語彙の語を出している */
    val formCategoryNone: DisplayText get() = DisplayText.Res(R.string.tags_form_category_none)
    /** この操作は制限されています。 — 利用が制限されたアカウントでタグを作成・編集しようとしたとき (シートの中の文) */
    val formErrorRestricted: DisplayText get() = DisplayText.Res(R.string.tags_form_error_restricted)
    /** 編集履歴はありません — タグの説明文の編集履歴が 1 件も無いとき */
    val historyEmpty: DisplayText get() = DisplayText.Res(R.string.tags_history_empty)
    /** (説明なし) — Android の文言。iOS の history.no_description と括弧が違う (統一はオーナーが別 PR で) */
    val historyNoDescriptionAndroid: DisplayText get() = DisplayText.Res(R.string.tags_history_no_description_android)
    /** 編集履歴 — タグの説明文の編集履歴の画面の見出し */
    val historyTitle: DisplayText get() = DisplayText.Res(R.string.tags_history_title)
    /** 新規タグ作成 — タグ一覧の右上の ＋ アイコンの読み上げ */
    val listCreateA11y: DisplayText get() = DisplayText.Res(R.string.tags_list_create_a11y)
    /** タグはまだありません — タグ一覧にタグが 1 つも無いとき */
    val listEmptyTitle: DisplayText get() = DisplayText.Res(R.string.tags_list_empty_title)
    /** カテゴリで絞り込み — タグ一覧の右上の絞り込みアイコンの読み上げ (押すとカテゴリのメニュー) */
    val listFilterA11y: DisplayText get() = DisplayText.Res(R.string.tags_list_filter_a11y)
    /** 「{query}」に一致するタグがありません — 名前で絞り込んで 0 件のときの説明。query は入力した語 (Android はこれ 1 行だけを出す) — 引数: query (string) */
    fun listFilterEmptyMessage(query: String): DisplayText = DisplayText.Res(R.string.tags_list_filter_empty_message, listOf(query))
    /** タグ名で絞り込み — タグ一覧の上の名前の絞り込み欄のプレースホルダ */
    val listNameFilterPrompt: DisplayText get() = DisplayText.Res(R.string.tags_list_name_filter_prompt)
    /** {count}曲 — タグ一覧の行の右端、このタグが付いた曲の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count) */
    fun listRowSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.tags_list_row_songs, count, listOf(count))
    /** 並び順 — タグ一覧の並び順メニュー (iOS は Picker のラベル、Android は並び替えアイコンの読み上げ) */
    val listSortLabel: DisplayText get() = DisplayText.Res(R.string.tags_list_sort_label)
    /** 名前 — タグ一覧の並び順の選択肢 (名前順) */
    val listSortName: DisplayText get() = DisplayText.Res(R.string.tags_list_sort_name)
    /** 人気 — タグ一覧の並び順の選択肢 (人気順) */
    val listSortPopular: DisplayText get() = DisplayText.Res(R.string.tags_list_sort_popular)
    /** 新着 — タグ一覧の並び順の選択肢 (新しく作られた順) */
    val listSortRecent: DisplayText get() = DisplayText.Res(R.string.tags_list_sort_recent)
    /** タグ — タグ一覧の画面タイトル */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.tags_list_title)
    /** 追加 — タグを付けるシートの確定ボタン (選んだタグをまとめて付ける) */
    val pickerActionAdd: DisplayText get() = DisplayText.Res(R.string.tags_picker_action_add)
    /** 「{query}」を作成 — 検索語と同じ名前のタグが無いときの、その名前で新しく作るボタン。query は入力した語 — 引数: query (string) */
    fun pickerCreateFromSearch(query: String): DisplayText = DisplayText.Res(R.string.tags_picker_create_from_search, listOf(query))
    /** 色やカテゴリを付けて新規作成 — タグを付けるシートの下のボタン (新規タグ作成シートを開く) */
    val pickerCreateFull: DisplayText get() = DisplayText.Res(R.string.tags_picker_create_full)
    /** タグが見つかりません — タグを付けるシートで候補が 1 つも無いとき */
    val pickerEmpty: DisplayText get() = DisplayText.Res(R.string.tags_picker_empty)
    /** タグの追加に失敗しました — 選んだタグを付けられなかったとき (iOS はアラートの見出し、Android はシートの中の文) */
    val pickerErrorApplyFailed: DisplayText get() = DisplayText.Res(R.string.tags_picker_error_apply_failed)
    /** タグの追加にはサインインが必要です(設定画面からサインインしてください) — 未ログインでタグを付けようとしたとき (シートの中の文) */
    val pickerErrorLoginRequired: DisplayText get() = DisplayText.Res(R.string.tags_picker_error_login_required)
    /** タグを検索 / 新規作成 — タグを付けるシートの検索欄のプレースホルダ (無ければその語で新しく作れる) */
    val pickerSearchPrompt: DisplayText get() = DisplayText.Res(R.string.tags_picker_search_prompt)
    /** 候補 — タグを付けるシートの候補の見出し (検索中) */
    val pickerSectionCandidates: DisplayText get() = DisplayText.Res(R.string.tags_picker_section_candidates)
    /** よく使われるタグ — タグを付けるシートの候補の見出し (検索していないとき) */
    val pickerSectionPopular: DisplayText get() = DisplayText.Res(R.string.tags_picker_section_popular)
    /** タグを追加 — 曲・アイドル・ユニットにタグを付けるシートの見出し */
    val pickerTitle: DisplayText get() = DisplayText.Res(R.string.tags_picker_title)
}
