// 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/common.json の文言。L10n.Common から引く (iOS の L10n.Common と同じ名前)。 */
object L10nCommon {
    /** 戻る — 画面左上の戻るボタンの読み上げ (contentDescription)。iOS は OS が出すので Android だけ */
    val actionBack: DisplayText get() = DisplayText.Res(R.string.common_action_back)
    /** 閉じる — シートや完了画面を閉じるボタン (シェアカードのシート・タグ付与の完了画面) */
    val actionClose: DisplayText get() = DisplayText.Res(R.string.common_action_close)
    /** 折りたたむ — 開いている節を閉じるボタンの読み上げ */
    val actionCollapse: DisplayText get() = DisplayText.Res(R.string.common_action_collapse)
    /** 展開 — 閉じている節を開くボタンの読み上げ */
    val actionExpand: DisplayText get() = DisplayText.Res(R.string.common_action_expand)
    /** 再試行 — 読み込み失敗などの空状態に出す再試行ボタン */
    val actionRetry: DisplayText get() = DisplayText.Res(R.string.common_action_retry)
    /** すべて見る — セクション見出し右の導線 */
    val actionSeeAll: DisplayText get() = DisplayText.Res(R.string.common_action_see_all)
    /** プレビュー再生 — ジャケ写に重ねた再生ボタンの読み上げ (曲の試聴を始める) */
    val artworkPreviewPlayA11y: DisplayText get() = DisplayText.Res(R.string.common_artwork_preview_play_a11y)
    /** 停止 — ジャケ写に重ねた停止ボタンの読み上げ (試聴中) */
    val artworkPreviewStopA11y: DisplayText get() = DisplayText.Res(R.string.common_artwork_preview_stop_a11y)
    /** 参加を取り消す — 参加形態を選ぶシートの一番下の、参加の記録を取り消す行 */
    val attendancePickerCancel: DisplayText get() = DisplayText.Res(R.string.common_attendance_picker_cancel)
    /** {type}で参加 — 参加形態を選ぶシートの選択肢。type は形態 (現地・配信・LV。コアの語彙) — 引数: type (core) */
    fun attendancePickerOption(type: String): DisplayText = DisplayText.Res(R.string.common_attendance_picker_option, listOf(type))
    /** 参加形態を選ぶ — 参加形態を選ぶシートの見出しの下の説明 */
    val attendancePickerSubtitle: DisplayText get() = DisplayText.Res(R.string.common_attendance_picker_subtitle)
    /** この公演への参加 — 参加形態を選ぶシートの見出し (公演名が無いときの代わり) */
    val attendancePickerTitleFallback: DisplayText get() = DisplayText.Res(R.string.common_attendance_picker_title_fallback)
    /** {type}で参加中 — 公演の行のスワイプに出る、今の参加形態。type は形態 (現地・配信・LV。コアの語彙) — 引数: type (core) */
    fun attendanceSwipeAttending(type: String): DisplayText = DisplayText.Res(R.string.common_attendance_swipe_attending, listOf(type))
    /** 参加を登録 — 公演・ライブの行をスワイプすると出る参加登録のボタン */
    val attendanceSwipeRegister: DisplayText get() = DisplayText.Res(R.string.common_attendance_swipe_register)
    /** 第{rank}位 — みんなの投票の終了お題での順位バッジ (2〜3 位)。お題名の後ろに付く。rank は順位 — 引数: rank (int) */
    fun awardChipRank(rank: Int): DisplayText = DisplayText.Res(R.string.common_award_chip_rank, listOf(rank))
    /** 優勝 — みんなの投票の終了お題で 1 位になったことを示すバッジ (お題名の後ろに付く) */
    val awardChipWinner: DisplayText get() = DisplayText.Res(R.string.common_award_chip_winner)
    /** 全て — ブランドの絞り込みの「全ブランド」の選択肢 (選ぶとブランドの絞り込みを外す) */
    val brandFilterAll: DisplayText get() = DisplayText.Res(R.string.common_brand_filter_all)
    /** コピー — 長押しメニューのコピー項目の既定の文言 (何をコピーするかを渡さないとき) */
    val copyDefault: DisplayText get() = DisplayText.Res(R.string.common_copy_default)
    /** {label}をコピー — 「よみ」「CV」などの行の長押しメニュー。label は行の見出し (よみ・CV・会場…) — 引数: label (string) */
    fun copyLabeled(label: String): DisplayText = DisplayText.Res(R.string.common_copy_labeled, listOf(label))
    /** タグ{count}個一致 — アイドルの格子 (タグが似ているアイドル) の名前の下に出す、共通するタグの数。1000 以上は桁区切りが付く (実際には出ない値) — 引数: count (count) */
    fun idolGridSharedTags(count: Int): DisplayText = DisplayText.Plural(R.plurals.common_idol_grid_shared_tags, count, listOf(count))
    /** ・ — 名前を並べるときの区切り (シェアカードの原唱者名「A・B・C」)。前後に空白は入れない */
    val listMiddot: DisplayText get() = DisplayText.Res(R.string.common_list_middot)
    /** 参加の記録 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 (公演の行のスワイプで参加を登録・取り消す) */
    val localWriteRecordAttendance: DisplayText get() = DisplayText.Res(R.string.common_local_write_record_attendance)
    /** マークの切り替え — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 (画面上部のボタンで担当・お気に入りなどを付け外しする) */
    val localWriteToggleMark: DisplayText get() = DisplayText.Res(R.string.common_local_write_toggle_mark)
    /** 絞り込みを解除 — 名前の絞り込み欄の右の × ボタンの読み上げ (入力を消す)。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ) */
    val nameFilterClearA11y: DisplayText get() = DisplayText.Res(R.string.common_name_filter_clear_a11y)
    /** マイタグを追加 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。入力欄の右の ＋ ボタンの読み上げ */
    val personalTagsAddA11y: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_add_a11y)
    /** マイタグはまだありません — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。1 つも無いときの案内 */
    val personalTagsEmpty: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_empty)
    /** マイタグ(自分だけに表示) — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。節の見出し。自分だけのタグで、コミュニティには送らない */
    val personalTagsHeader: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_header)
    /** 例: 聞いた — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。入力欄のプレースホルダ。例の語も訳す */
    val personalTagsPlaceholder: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_placeholder)
    /** 削除 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。チップの × の読み上げ (削除は長押し) */
    val personalTagsRemoveA11y: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_remove_a11y)
    /** 長押しで削除 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。チップの下の操作の案内 */
    val personalTagsRemoveHint: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_remove_hint)
    /** 回 — ランキング行 (ImasRankingRow) の数値の後ろに付く単位の既定 (回数)。呼び出し側が単位を渡さないときに出る */
    val rankingRowUnitDefault: DisplayText get() = DisplayText.Res(R.string.common_ranking_row_unit_default)
    /** {label}を解除 — Android の文言。iOS の removable_chip.remove.a11y と ja が違う (空白の有無。統一はオーナーが別 PR で)。× ボタンの読み上げ。label はチップの文言 — 引数: label (string) */
    fun removableChipRemoveA11yAndroid(label: String): DisplayText = DisplayText.Res(R.string.common_removable_chip_remove_a11y_android, listOf(label))
}
