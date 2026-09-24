// 生成物: i18n/catalog/mastery.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/mastery.json の文言。L10n.Mastery から引く (iOS の L10n.Mastery と同じ名前)。 */
object L10nMastery {
    /** 全部に段階が付いています — 群の長押しで出るシートで、未設定の曲が無いとき (Android) */
    val bulkAllSet: DisplayText get() = DisplayText.Res(R.string.mastery_bulk_all_set)
    /** この {count} 曲すべて — 一括更新のメニューの節: 群の曲すべての段階を変える — 引数: count (count) */
    fun bulkAllSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_bulk_all_songs, count, listOf(count))
    /** 未設定に戻す — 一括更新のメニュー: 群の曲すべてを未設定に戻す */
    val bulkReset: DisplayText get() = DisplayText.Res(R.string.mastery_bulk_reset)
    /** 未設定の {count} 曲だけ — 一括更新のメニューの節: 未設定の曲だけに段階を付ける — 引数: count (count) */
    fun bulkUnsetOnly(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_bulk_unset_only, count, listOf(count))
    /** リセット — 絞り込みシートの条件を戻すボタン (Android) */
    val filterActionReset: DisplayText get() = DisplayText.Res(R.string.mastery_filter_action_reset)
    /** すべて — 進み具合の絞り込み: 絞らない */
    val filterProgressAll: DisplayText get() = DisplayText.Res(R.string.mastery_filter_progress_all)
    /** 完了 — 進み具合の絞り込み: 全曲が最上段の群 */
    val filterProgressComplete: DisplayText get() = DisplayText.Res(R.string.mastery_filter_progress_complete)
    /** 未設定あり — 進み具合の絞り込み: 未設定の曲がある群 */
    val filterProgressHasUnset: DisplayText get() = DisplayText.Res(R.string.mastery_filter_progress_has_unset)
    /** 聴いたのに未設定 — 進み具合の絞り込み: 現地で聴いたのに段階を付けていない曲がある群 */
    val filterProgressHeardButUnset: DisplayText get() = DisplayText.Res(R.string.mastery_filter_progress_heard_but_unset)
    /** 手つかず — 進み具合の絞り込み: まだ 1 曲も段階を付けていない群 */
    val filterProgressUntouched: DisplayText get() = DisplayText.Res(R.string.mastery_filter_progress_untouched)
    /** 進み具合 — 絞り込みシートの節: 進み具合 */
    val filterSectionProgress: DisplayText get() = DisplayText.Res(R.string.mastery_filter_section_progress)
    /** 並び — 絞り込みシートの節: 並び順 */
    val filterSectionSort: DisplayText get() = DisplayText.Res(R.string.mastery_filter_section_sort)
    /** 名前順 — 群の並び */
    val filterSortName: DisplayText get() = DisplayText.Res(R.string.mastery_filter_sort_name)
    /** 進み具合が低い順 — 群の並び */
    val filterSortProgressAsc: DisplayText get() = DisplayText.Res(R.string.mastery_filter_sort_progress_asc)
    /** 進み具合が高い順 — 群の並び */
    val filterSortProgressDesc: DisplayText get() = DisplayText.Res(R.string.mastery_filter_sort_progress_desc)
    /** 曲数順 — 群の並び: 曲の多い順 */
    val filterSortSongCount: DisplayText get() = DisplayText.Res(R.string.mastery_filter_sort_song_count)
    /** フィルタ — 絞り込みシートの題 (Android) */
    val filterTitle: DisplayText get() = DisplayText.Res(R.string.mastery_filter_title)
    /** まとめて変える — 群の詳細の右上の ⋯ ボタン (一括更新のメニュー) の読み上げ */
    val groupBulkA11y: DisplayText get() = DisplayText.Res(R.string.mastery_group_bulk_a11y)
    /** 聴いたのに未設定 {songs} — 段階の絞り込みチップ: 現地で聴いたのに段階を付けていない曲だけ — 引数: songs (int) */
    fun groupFilterHeardButUnset(songs: Int): DisplayText = DisplayText.Res(R.string.mastery_group_filter_heard_but_unset, listOf(songs))
    /** 現地で聴いた — 曲の行の ✓ (現地で聴いた曲) の読み上げ */
    val groupRowHeardA11y: DisplayText get() = DisplayText.Res(R.string.mastery_group_row_heard_a11y)
    /** {count}曲 — 曲一覧の見出しの右の曲数 (絞っていないとき) — 引数: count (count) */
    fun groupSongsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_group_songs_count, count, listOf(count))
    /** {shown} / {count}曲 — 曲一覧の見出しの右: 絞り込んで見えている曲数 / 群の曲数。群は最大でも数百曲 — 引数: shown (int), count (count) */
    fun groupSongsCountFiltered(shown: Int, count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_group_songs_count_filtered, count, listOf(shown, count))
    /** 収録曲 — 群の詳細の曲一覧の見出し */
    val groupSongsHeader: DisplayText get() = DisplayText.Res(R.string.mastery_group_songs_header)
    /** このグループの習熟度 — 群の詳細の先頭の進み具合の節の見出し */
    val groupSummaryHeader: DisplayText get() = DisplayText.Res(R.string.mastery_group_summary_header)
    /** CDシリーズ — 群の分け方のセグメント: CD シリーズごと */
    val listAxisSeries: DisplayText get() = DisplayText.Res(R.string.mastery_list_axis_series)
    /** ユニット — 群の分け方のセグメント: ユニット (歌唱名義) ごと */
    val listAxisUnit: DisplayText get() = DisplayText.Res(R.string.mastery_list_axis_unit)
    /** 年代 — 群の分け方のセグメント: 発売年ごと */
    val listAxisYear: DisplayText get() = DisplayText.Res(R.string.mastery_list_axis_year)
    /** 全て — ブランドの絞り込みチップの先頭 (絞らない) */
    val listBrandAll: DisplayText get() = DisplayText.Res(R.string.mastery_list_brand_all)
    /** 絞り込みを緩めてください。 — 絞り込みの結果、群が 1 つも無いときの説明 */
    val listEmptyMessage: DisplayText get() = DisplayText.Res(R.string.mastery_list_empty_message)
    /** 該当するグループがありません — 絞り込みの結果、群が 1 つも無いときの見出し */
    val listEmptyTitle: DisplayText get() = DisplayText.Res(R.string.mastery_list_empty_title)
    /** フィルタ — 右上の絞り込みボタンの読み上げ */
    val listFilterA11y: DisplayText get() = DisplayText.Res(R.string.mastery_list_filter_a11y)
    /** まとめて付ける — 群の行を右へスワイプしたときに出る文字 (未設定の曲にまとめて段階を付ける) */
    val listGroupBulkSwipe: DisplayText get() = DisplayText.Res(R.string.mastery_list_group_bulk_swipe)
    /** {count}枚 — 群の行の副題: その群の CD の枚数。副題は「 ・ 」で並ぶ — 引数: count (count) */
    fun listGroupDiscs(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_list_group_discs, count, listOf(count))
    /** 聴いた {songs} — 群の行の副題: 現地で聴いた (回収した) 曲の数 — 引数: songs (int) */
    fun listGroupHeard(songs: Int): DisplayText = DisplayText.Res(R.string.mastery_list_group_heard, listOf(songs))
    /** 聴いたのに未設定 {songs} — 群の行の副題: 現地で聴いた (回収した) のに段階を付けていない曲の数 — 引数: songs (int) */
    fun listGroupHeardButUnset(songs: Int): DisplayText = DisplayText.Res(R.string.mastery_list_group_heard_but_unset, listOf(songs))
    /**  ・  — 群の行の副題の区切り (前後に空白) */
    val listGroupSeparator: DisplayText get() = DisplayText.Res(R.string.mastery_list_group_separator)
    /** {count}曲 — 群の行の副題: その群の曲数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun listGroupSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_list_group_songs, count, listOf(count))
    /** 未設定 {songs} — 群の行の副題: 段階が未設定の曲の数 (Android だけ) — 引数: songs (int) */
    fun listGroupUnset(songs: Int): DisplayText = DisplayText.Res(R.string.mastery_list_group_unset, listOf(songs))
    /** {count} 件 — 群の一覧の件数。1000 以上は桁区切りが付く (1,047 件) — 引数: count (count) */
    fun listGroupsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_list_groups_count, count, listOf(count))
    /** グループ別 — 群 (CD シリーズ / ユニット / 年代) の一覧の見出し */
    val listGroupsHeader: DisplayText get() = DisplayText.Res(R.string.mastery_list_groups_header)
    /** CDシリーズ名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (CD シリーズで分けているとき) */
    val listNameFilterSeries: DisplayText get() = DisplayText.Res(R.string.mastery_list_name_filter_series)
    /** ユニット名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (ユニットで分けているとき) */
    val listNameFilterUnit: DisplayText get() = DisplayText.Res(R.string.mastery_list_name_filter_unit)
    /** 年代名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (年代で分けているとき。群の名前は 2023年 など) */
    val listNameFilterYear: DisplayText get() = DisplayText.Res(R.string.mastery_list_name_filter_year)
    /** あなたの習熟度 — 一覧の先頭の全体の進み具合の節の見出し */
    val listSummaryHeader: DisplayText get() = DisplayText.Res(R.string.mastery_list_summary_header)
    /** 習熟度 — 習熟度ダッシュボードの画面の題 */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.mastery_list_title)
    /** {level} {count} 曲 — 最上段 (例: 完璧) にある曲数。level は最上段の名前 (利用者が付けたラベルのこともある)。1000 以上は桁区切りが付く (完璧 1,234 曲) — 引数: level (string), count (count) */
    fun summaryDoneSongs(level: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_summary_done_songs, count, listOf(level, count))
    /** 段階を付けた曲 — 進み具合の大きな数字の説明 */
    val summarySetSongs: DisplayText get() = DisplayText.Res(R.string.mastery_summary_set_songs)
    /** / {count}曲 — 進み具合の大きな数字 (段階を付けた曲数) の右に出る分母。1000 以上は桁区切りが付く (/ 3,012曲) — 引数: count (count) */
    fun summaryTotalSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.mastery_summary_total_songs, count, listOf(count))
    /** 習熟度の記録 — 書き込みに失敗したときの知らせに入る操作の名前 (「〜に失敗しました」の〜の部分) */
    val writeActionRecord: DisplayText get() = DisplayText.Res(R.string.mastery_write_action_record)
}
