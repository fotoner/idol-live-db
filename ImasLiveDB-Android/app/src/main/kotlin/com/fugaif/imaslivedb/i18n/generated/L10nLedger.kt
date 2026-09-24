// 生成物: i18n/catalog/ledger.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/ledger.json の文言。L10n.Ledger から引く (iOS の L10n.Ledger と同じ名前)。 */
object L10nLedger {
    /** キャンセル — 入力シートを閉じるボタン */
    val editorActionCancel: DisplayText get() = DisplayText.Res(R.string.ledger_editor_action_cancel)
    /** 保存 — 入力シートの保存ボタン */
    val editorActionSave: DisplayText get() = DisplayText.Res(R.string.ledger_editor_action_save)
    /** 金額 — 入力シートの節: 金額 */
    val editorAmountHeader: DisplayText get() = DisplayText.Res(R.string.ledger_editor_amount_header)
    /** 費目 — 入力シートの節: 費目 (チケット代・交通費…) */
    val editorCategoryHeader: DisplayText get() = DisplayText.Res(R.string.ledger_editor_category_header)
    /** 決定 — 日付の選択ダイアログの決定ボタン (Android) */
    val editorDateConfirm: DisplayText get() = DisplayText.Res(R.string.ledger_editor_date_confirm)
    /** 日付 — 入力シートの節: 日付 */
    val editorDateHeader: DisplayText get() = DisplayText.Res(R.string.ledger_editor_date_header)
    /** 日付を選んでください — 入力の検査 (コア) で日付が不正なとき */
    val editorErrorBadDate: DisplayText get() = DisplayText.Res(R.string.ledger_editor_error_bad_date)
    /** 金額を入れてください — 入力の検査 (コア) で金額が 0 以下のとき */
    val editorErrorNotPositive: DisplayText get() = DisplayText.Res(R.string.ledger_editor_error_not_positive)
    /** 桁が多すぎます (1 億円未満) — 入力の検査 (コア) で金額が 1 億円以上のとき */
    val editorErrorTooLarge: DisplayText get() = DisplayText.Res(R.string.ledger_editor_error_too_large)
    /** メモ — 入力シートの節: メモ */
    val editorNoteHeader: DisplayText get() = DisplayText.Res(R.string.ledger_editor_note_header)
    /** 任意 — メモ欄のプレースホルダ (書かなくてよい) */
    val editorNotePlaceholder: DisplayText get() = DisplayText.Res(R.string.ledger_editor_note_placeholder)
    /** 紐づけると「この遠征でいくら使ったか」が出ます。課金やグッズの通販は紐づけなくて構いません。 — 公演の節の下の説明 */
    val editorShowFooter: DisplayText get() = DisplayText.Res(R.string.ledger_editor_show_footer)
    /** 公演 — 入力シートの節: 紐づける公演 */
    val editorShowHeader: DisplayText get() = DisplayText.Res(R.string.ledger_editor_show_header)
    /** 公演に紐づけない — 公演の欄: 紐づけていないとき */
    val editorShowNone: DisplayText get() = DisplayText.Res(R.string.ledger_editor_show_none)
    /** 支出を足す — 支出の入力シートの題 (新規) */
    val editorTitleAdd: DisplayText get() = DisplayText.Res(R.string.ledger_editor_title_add)
    /** 支出を直す — 支出の入力シートの題 (編集) */
    val editorTitleEdit: DisplayText get() = DisplayText.Res(R.string.ledger_editor_title_edit)
    /** 支出を足す — 右上の ＋ ボタンの読み上げ */
    val listAddA11y: DisplayText get() = DisplayText.Res(R.string.ledger_list_add_a11y)
    /** 右上の + から、チケット代や遠征費を足してください。 — 支出が 1 件も無いときの説明 */
    val listEmptyMessage: DisplayText get() = DisplayText.Res(R.string.ledger_list_empty_message)
    /** まだ記録がありません — 支出が 1 件も無いときの見出し */
    val listEmptyTitle: DisplayText get() = DisplayText.Res(R.string.ledger_list_empty_title)
    /** すべて — 公演との紐づけの絞り込み: 絞らない */
    val listLinkageAll: DisplayText get() = DisplayText.Res(R.string.ledger_list_linkage_all)
    /** 公演あり — 公演との紐づけの絞り込み: 公演に紐づいた支出だけ */
    val listLinkageLinked: DisplayText get() = DisplayText.Res(R.string.ledger_list_linkage_linked)
    /** 公演なし — 公演との紐づけの絞り込み: 公演に紐づかない支出 (課金・通販など) だけ */
    val listLinkageUnlinked: DisplayText get() = DisplayText.Res(R.string.ledger_list_linkage_unlinked)
    /** 全期間 — 集計の期間のセグメント */
    val listPeriodAll: DisplayText get() = DisplayText.Res(R.string.ledger_list_period_all)
    /** 月別 — 集計の期間のセグメント */
    val listPeriodMonth: DisplayText get() = DisplayText.Res(R.string.ledger_list_period_month)
    /** 年別 — 集計の期間のセグメント */
    val listPeriodYear: DisplayText get() = DisplayText.Res(R.string.ledger_list_period_year)
    /** 削除 — 支出の行をスワイプすると出る削除 */
    val listRowDelete: DisplayText get() = DisplayText.Res(R.string.ledger_list_row_delete)
    /** {count}件 — 合計金額の右の件数。1000 以上は桁区切りが付く (1,234件) — 引数: count (count) */
    fun listSummaryCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.ledger_list_summary_count, count, listOf(count))
    /** 使った額 — 合計の節の見出し */
    val listSummaryHeader: DisplayText get() = DisplayText.Res(R.string.ledger_list_summary_header)
    /** 1公演あたり — 合計の内訳: 公演 1 つあたりの額 */
    val listSummaryPerShow: DisplayText get() = DisplayText.Res(R.string.ledger_list_summary_per_show)
    /** 公演数 — 合計の内訳: 紐づいた公演の数 */
    val listSummaryShowCount: DisplayText get() = DisplayText.Res(R.string.ledger_list_summary_show_count)
    /** 遠征費 — 合計の内訳: 遠征費 (チケット・交通・宿) */
    val listSummaryTravel: DisplayText get() = DisplayText.Res(R.string.ledger_list_summary_travel)
    /** 収支 — 家計簿の画面の題。ko は機能名 (家計簿) に合わせる */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.ledger_list_title)
    /** 全期間 — 年の絞り込みチップの先頭 (絞らない) */
    val listYearFilterAll: DisplayText get() = DisplayText.Res(R.string.ledger_list_year_filter_all)
    /** {year}年 — 年の絞り込みチップ (記録のある年だけ)。year は支出の日付の先頭 4 桁 (2026 など) をそのまま渡す — 引数: year (string) */
    fun listYearFilterYear(year: String): DisplayText = DisplayText.Res(R.string.ledger_list_year_filter_year, listOf(year))
    /** 参加した公演がありません。ライブに「参加」を付けると、ここに並びます。 — Android の文言 (見出しと説明が 1 文)。iOS は show_picker.empty.title と .message に分かれる */
    val showPickerEmptyMessageAndroid: DisplayText get() = DisplayText.Res(R.string.ledger_show_picker_empty_message_android)
    /** 公演に紐づけない — 公演を選ぶシートの先頭の選択肢 */
    val showPickerNone: DisplayText get() = DisplayText.Res(R.string.ledger_show_picker_none)
    /** 公演を探す — 公演を選ぶシートの検索欄のプレースホルダ */
    val showPickerSearchPrompt: DisplayText get() = DisplayText.Res(R.string.ledger_show_picker_search_prompt)
    /** 公演を選ぶ — 紐づける公演を選ぶシートの題 */
    val showPickerTitle: DisplayText get() = DisplayText.Res(R.string.ledger_show_picker_title)
    /** あとで — 確認シートを記録せずに閉じるボタン */
    val ticketPromptActionLater: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_action_later)
    /** 記録する — 確認シートの記録ボタン */
    val ticketPromptActionRecord: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_action_record)
    /** 手数料や先行の差額を含めたいときは、ここで直してください。 — 金額の節の下の説明 */
    val ticketPromptAmountFooter: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_amount_footer)
    /** 記録する金額 — 確認シートの節: 記録する金額 */
    val ticketPromptAmountHeader: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_amount_header)
    /** 推定 — 券の値段が公式発表ではなく推定のときの印 */
    val ticketPromptEstimate: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_estimate)
    /** {kind}で参加 — 参加の形態。kind はコアが返す形態の名前 (現地 / 配信 / ライブビューイング) — 引数: kind (core) */
    fun ticketPromptKind(kind: String): DisplayText = DisplayText.Res(R.string.ledger_ticket_prompt_kind, listOf(kind))
    /** この公演 — 確認シートの公演名が引けなかったときの代わり */
    val ticketPromptShowFallback: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_show_fallback)
    /** 券種 — 確認シートの節: 券種 */
    val ticketPromptTicketsHeader: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_tickets_header)
    /** チケット代を記録 — 参加を付けた直後に出る、チケット代を家計簿に記録するかの確認シートの題 */
    val ticketPromptTitle: DisplayText get() = DisplayText.Res(R.string.ledger_ticket_prompt_title)
    /** 支出の削除 — Android の文言。iOS の write_action.delete と ja が違う */
    val writeActionDeleteAndroid: DisplayText get() = DisplayText.Res(R.string.ledger_write_action_delete_android)
    /** 支出の保存 — Android の文言。iOS の write_action.save と ja が違う */
    val writeActionSaveAndroid: DisplayText get() = DisplayText.Res(R.string.ledger_write_action_save_android)
    /** チケット代の記録 — 参加を付けた直後のチケット代の記録に失敗したときの知らせに入る操作の名前 */
    val writeActionTicket: DisplayText get() = DisplayText.Res(R.string.ledger_write_action_ticket)
}
