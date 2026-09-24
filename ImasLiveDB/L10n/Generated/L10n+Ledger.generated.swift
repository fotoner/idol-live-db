// 生成物: i18n/catalog/ledger.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/ledger.json の文言 (表 Ledger)
    enum Ledger {
        /// キャンセル — 入力シートを閉じるボタン
        static var editorActionCancel: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.action.cancel", defaultValue: "キャンセル", table: "Ledger", bundle: L10n.bundle)
        }
        /// 保存 — 入力シートの保存ボタン
        static var editorActionSave: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.action.save", defaultValue: "保存", table: "Ledger", bundle: L10n.bundle)
        }
        /// 金額 — 入力シートの節: 金額
        static var editorAmountHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.amount.header", defaultValue: "金額", table: "Ledger", bundle: L10n.bundle)
        }
        /// 費目 — 入力シートの節: 費目 (チケット代・交通費…)
        static var editorCategoryHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.category.header", defaultValue: "費目", table: "Ledger", bundle: L10n.bundle)
        }
        /// 日付 — 入力シートの節: 日付
        static var editorDateHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.date.header", defaultValue: "日付", table: "Ledger", bundle: L10n.bundle)
        }
        /// 日付 — 日付の選択欄のラベル
        static var editorDatePicker: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.date.picker", defaultValue: "日付", table: "Ledger", bundle: L10n.bundle)
        }
        /// 日付を選んでください — 入力の検査 (コア) で日付が不正なとき
        static var editorErrorBadDate: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.error.bad_date", defaultValue: "日付を選んでください", table: "Ledger", bundle: L10n.bundle)
        }
        /// 金額を入れてください — 入力の検査 (コア) で金額が 0 以下のとき
        static var editorErrorNotPositive: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.error.not_positive", defaultValue: "金額を入れてください", table: "Ledger", bundle: L10n.bundle)
        }
        /// 桁が多すぎます (1 億円未満) — 入力の検査 (コア) で金額が 1 億円以上のとき
        static var editorErrorTooLarge: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.error.too_large", defaultValue: "桁が多すぎます (1 億円未満)", table: "Ledger", bundle: L10n.bundle)
        }
        /// メモ — 入力シートの節: メモ
        static var editorNoteHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.note.header", defaultValue: "メモ", table: "Ledger", bundle: L10n.bundle)
        }
        /// 任意 — メモ欄のプレースホルダ (書かなくてよい)
        static var editorNotePlaceholder: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.note.placeholder", defaultValue: "任意", table: "Ledger", bundle: L10n.bundle)
        }
        /// 紐づけると「この遠征でいくら使ったか」が出ます。課金やグッズの通販は紐づけなくて構いません。 — 公演の節の下の説明
        static var editorShowFooter: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.show.footer", defaultValue: "紐づけると「この遠征でいくら使ったか」が出ます。課金やグッズの通販は紐づけなくて構いません。", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演 — 入力シートの節: 紐づける公演
        static var editorShowHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.show.header", defaultValue: "公演", table: "Ledger", bundle: L10n.bundle)
        }
        /// 紐づけた公演 — 公演の欄: 紐づけた公演の名前が引けなかったときの代わり
        static var editorShowLinkedFallback: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.show.linked_fallback", defaultValue: "紐づけた公演", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演に紐づけない — 公演の欄: 紐づけていないとき
        static var editorShowNone: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.show.none", defaultValue: "公演に紐づけない", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演との紐づけを外す — 公演の紐づけを外すボタン
        static var editorShowUnlink: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.show.unlink", defaultValue: "公演との紐づけを外す", table: "Ledger", bundle: L10n.bundle)
        }
        /// 支出を足す — 支出の入力シートの題 (新規)
        static var editorTitleAdd: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.title.add", defaultValue: "支出を足す", table: "Ledger", bundle: L10n.bundle)
        }
        /// 支出を直す — 支出の入力シートの題 (編集)
        static var editorTitleEdit: LocalizedStringResource {
            LocalizedStringResource("ledger.editor.title.edit", defaultValue: "支出を直す", table: "Ledger", bundle: L10n.bundle)
        }
        /// 支出を足す — 右上の ＋ ボタンの読み上げ
        static var listAddA11y: LocalizedStringResource {
            LocalizedStringResource("ledger.list.add.a11y", defaultValue: "支出を足す", table: "Ledger", bundle: L10n.bundle)
        }
        /// 右上の + から、チケット代や遠征費を足してください。 — 支出が 1 件も無いときの説明
        static var listEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("ledger.list.empty.message", defaultValue: "右上の + から、チケット代や遠征費を足してください。", table: "Ledger", bundle: L10n.bundle)
        }
        /// まだ記録がありません — 支出が 1 件も無いときの見出し
        static var listEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("ledger.list.empty.title", defaultValue: "まだ記録がありません", table: "Ledger", bundle: L10n.bundle)
        }
        /// すべて — 公演との紐づけの絞り込み: 絞らない
        static var listLinkageAll: LocalizedStringResource {
            LocalizedStringResource("ledger.list.linkage.all", defaultValue: "すべて", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演あり — 公演との紐づけの絞り込み: 公演に紐づいた支出だけ
        static var listLinkageLinked: LocalizedStringResource {
            LocalizedStringResource("ledger.list.linkage.linked", defaultValue: "公演あり", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演なし — 公演との紐づけの絞り込み: 公演に紐づかない支出 (課金・通販など) だけ
        static var listLinkageUnlinked: LocalizedStringResource {
            LocalizedStringResource("ledger.list.linkage.unlinked", defaultValue: "公演なし", table: "Ledger", bundle: L10n.bundle)
        }
        /// 全期間 — 集計の期間のセグメント
        static var listPeriodAll: LocalizedStringResource {
            LocalizedStringResource("ledger.list.period.all", defaultValue: "全期間", table: "Ledger", bundle: L10n.bundle)
        }
        /// 月別 — 集計の期間のセグメント
        static var listPeriodMonth: LocalizedStringResource {
            LocalizedStringResource("ledger.list.period.month", defaultValue: "月別", table: "Ledger", bundle: L10n.bundle)
        }
        /// 年別 — 集計の期間のセグメント
        static var listPeriodYear: LocalizedStringResource {
            LocalizedStringResource("ledger.list.period.year", defaultValue: "年別", table: "Ledger", bundle: L10n.bundle)
        }
        /// 削除 — 支出の行をスワイプすると出る削除
        static var listRowDelete: LocalizedStringResource {
            LocalizedStringResource("ledger.list.row.delete", defaultValue: "削除", table: "Ledger", bundle: L10n.bundle)
        }
        /// {count}件 — 合計金額の右の件数。1000 以上は桁区切りが付く (1,234件) — 引数: count (count)
        static func listSummaryCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("ledger.list.summary.count", defaultValue: "\(count)件", table: "Ledger", bundle: L10n.bundle)
        }
        /// 使った額 — 合計の節の見出し
        static var listSummaryHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.list.summary.header", defaultValue: "使った額", table: "Ledger", bundle: L10n.bundle)
        }
        /// 1公演あたり — 合計の内訳: 公演 1 つあたりの額
        static var listSummaryPerShow: LocalizedStringResource {
            LocalizedStringResource("ledger.list.summary.per_show", defaultValue: "1公演あたり", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演数 — 合計の内訳: 紐づいた公演の数
        static var listSummaryShowCount: LocalizedStringResource {
            LocalizedStringResource("ledger.list.summary.show_count", defaultValue: "公演数", table: "Ledger", bundle: L10n.bundle)
        }
        /// 遠征費 — 合計の内訳: 遠征費 (チケット・交通・宿)
        static var listSummaryTravel: LocalizedStringResource {
            LocalizedStringResource("ledger.list.summary.travel", defaultValue: "遠征費", table: "Ledger", bundle: L10n.bundle)
        }
        /// 収支 — 家計簿の画面の題。ko は機能名 (家計簿) に合わせる
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("ledger.list.title", defaultValue: "収支", table: "Ledger", bundle: L10n.bundle)
        }
        /// 全期間 — 年の絞り込みチップの先頭 (絞らない)
        static var listYearFilterAll: LocalizedStringResource {
            LocalizedStringResource("ledger.list.year_filter.all", defaultValue: "全期間", table: "Ledger", bundle: L10n.bundle)
        }
        /// {year}年 — 年の絞り込みチップ (記録のある年だけ)。year は支出の日付の先頭 4 桁 (2026 など) をそのまま渡す — 引数: year (string)
        static func listYearFilterYear(year: String) -> LocalizedStringResource {
            LocalizedStringResource("ledger.list.year_filter.year", defaultValue: "\(year)年", table: "Ledger", bundle: L10n.bundle)
        }
        /// 閉じる — 公演を選ぶシートを閉じるボタン
        static var showPickerActionClose: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.action.close", defaultValue: "閉じる", table: "Ledger", bundle: L10n.bundle)
        }
        /// ライブに「参加」を付けると、ここに並びます。 — 参加を付けた公演が 1 つも無いときの説明
        static var showPickerEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.empty.message", defaultValue: "ライブに「参加」を付けると、ここに並びます。", table: "Ledger", bundle: L10n.bundle)
        }
        /// 参加した公演がありません — 参加を付けた公演が 1 つも無いときの見出し
        static var showPickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.empty.title", defaultValue: "参加した公演がありません", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演に紐づけない — 公演を選ぶシートの先頭の選択肢
        static var showPickerNone: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.none", defaultValue: "公演に紐づけない", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演を探す — 公演を選ぶシートの検索欄のプレースホルダ
        static var showPickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.search_prompt", defaultValue: "公演を探す", table: "Ledger", bundle: L10n.bundle)
        }
        /// 公演を選ぶ — 紐づける公演を選ぶシートの題
        static var showPickerTitle: LocalizedStringResource {
            LocalizedStringResource("ledger.show_picker.title", defaultValue: "公演を選ぶ", table: "Ledger", bundle: L10n.bundle)
        }
        /// あとで — 確認シートを記録せずに閉じるボタン
        static var ticketPromptActionLater: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.action.later", defaultValue: "あとで", table: "Ledger", bundle: L10n.bundle)
        }
        /// 記録する — 確認シートの記録ボタン
        static var ticketPromptActionRecord: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.action.record", defaultValue: "記録する", table: "Ledger", bundle: L10n.bundle)
        }
        /// 手数料や先行の差額を含めたいときは、ここで直してください。 — 金額の節の下の説明
        static var ticketPromptAmountFooter: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.amount.footer", defaultValue: "手数料や先行の差額を含めたいときは、ここで直してください。", table: "Ledger", bundle: L10n.bundle)
        }
        /// 記録する金額 — 確認シートの節: 記録する金額
        static var ticketPromptAmountHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.amount.header", defaultValue: "記録する金額", table: "Ledger", bundle: L10n.bundle)
        }
        /// 推定 — 券の値段が公式発表ではなく推定のときの印
        static var ticketPromptEstimate: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.estimate", defaultValue: "推定", table: "Ledger", bundle: L10n.bundle)
        }
        /// {kind}で参加 — 参加の形態。kind はコアが返す形態の名前 (現地 / 配信 / ライブビューイング) — 引数: kind (core)
        static func ticketPromptKind(kind: String) -> LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.kind", defaultValue: "\(kind)で参加", table: "Ledger", bundle: L10n.bundle)
        }
        /// この公演 — 確認シートの公演名が引けなかったときの代わり
        static var ticketPromptShowFallback: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.show_fallback", defaultValue: "この公演", table: "Ledger", bundle: L10n.bundle)
        }
        /// 券種 — 確認シートの節: 券種
        static var ticketPromptTicketsHeader: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.tickets.header", defaultValue: "券種", table: "Ledger", bundle: L10n.bundle)
        }
        /// チケット代を記録 — 参加を付けた直後に出る、チケット代を家計簿に記録するかの確認シートの題
        static var ticketPromptTitle: LocalizedStringResource {
            LocalizedStringResource("ledger.ticket_prompt.title", defaultValue: "チケット代を記録", table: "Ledger", bundle: L10n.bundle)
        }
        /// 家計簿の削除 — 書き込みに失敗したときの知らせに入る操作の名前
        static var writeActionDelete: LocalizedStringResource {
            LocalizedStringResource("ledger.write_action.delete", defaultValue: "家計簿の削除", table: "Ledger", bundle: L10n.bundle)
        }
        /// 家計簿の保存 — 書き込みに失敗したときの知らせに入る操作の名前 (「〜に失敗しました」の〜)
        static var writeActionSave: LocalizedStringResource {
            LocalizedStringResource("ledger.write_action.save", defaultValue: "家計簿の保存", table: "Ledger", bundle: L10n.bundle)
        }
        /// チケット代の記録 — 参加を付けた直後のチケット代の記録に失敗したときの知らせに入る操作の名前
        static var writeActionTicket: LocalizedStringResource {
            LocalizedStringResource("ledger.write_action.ticket", defaultValue: "チケット代の記録", table: "Ledger", bundle: L10n.bundle)
        }
    }
}
