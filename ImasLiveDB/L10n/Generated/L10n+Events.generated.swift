// 生成物: i18n/catalog/events.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/events.json の文言 (表 Events)
    enum Events {
        /// キャンセル — メモ・座席の入力と、公演への参加を選ぶダイアログの取り消しボタン
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("events.action.cancel", defaultValue: "キャンセル", table: "Events", bundle: L10n.bundle)
        }
        /// 完了 — 参加した公演を選ぶシートを閉じるボタン
        static var actionDone: LocalizedStringResource {
            LocalizedStringResource("events.action.done", defaultValue: "完了", table: "Events", bundle: L10n.bundle)
        }
        /// 保存 — メモ・座席の入力の保存ボタン
        static var actionSave: LocalizedStringResource {
            LocalizedStringResource("events.action.save", defaultValue: "保存", table: "Events", bundle: L10n.bundle)
        }
        /// 全公演に現地参加 — 全公演をまとめて現地参加にする行
        static var attendanceSheetAllLive: LocalizedStringResource {
            LocalizedStringResource("events.attendance_sheet.all_live", defaultValue: "全公演に現地参加", table: "Events", bundle: L10n.bundle)
        }
        /// 公演ごとに参加形態を選べます（配信・ライブビューイングは開催があった公演のみ）。回収率には現地参加だけが数えられます。 — 参加シートの説明。Android は attendance_sheet.footer_android (括弧の補足が無い)
        static var attendanceSheetFooterIos: LocalizedStringResource {
            LocalizedStringResource("events.attendance_sheet.footer_ios", defaultValue: "公演ごとに参加形態を選べます（配信・ライブビューイングは開催があった公演のみ）。回収率には現地参加だけが数えられます。", table: "Events", bundle: L10n.bundle)
        }
        /// 公演ごとに選ぶ — 参加シートの公演一覧の節の見出し
        static var attendanceSheetPerShowHeader: LocalizedStringResource {
            LocalizedStringResource("events.attendance_sheet.per_show_header", defaultValue: "公演ごとに選ぶ", table: "Events", bundle: L10n.bundle)
        }
        /// {count}公演 — 「全公演に現地参加」の行の右に出す公演数。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func attendanceSheetShowCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.attendance_sheet.show_count", defaultValue: "\(count)公演", table: "Events", bundle: L10n.bundle)
        }
        /// 参加した公演 — イベントの公演ごとに参加を選ぶシートの見出し
        static var attendanceSheetTitle: LocalizedStringResource {
            LocalizedStringResource("events.attendance_sheet.title", defaultValue: "参加した公演", table: "Events", bundle: L10n.bundle)
        }
        /// {month}/{day}({weekday}) — 出演パネルの DAY 見出しの日付。weekday は表示言語の 1 文字の曜日 (土 / 토) — 引数: month (int), day (int), weekday (string)
        static func castDayDate(month: Int, day: Int, weekday: String) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.day.date", defaultValue: "\(String(month))/\(String(day))(\(weekday))", table: "Events", bundle: L10n.bundle)
        }
        /// セトリ・出演者が登録されると表示されます — 出演パネルの空状態の説明
        static var castEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("events.cast.empty.message", defaultValue: "セトリ・出演者が登録されると表示されます", table: "Events", bundle: L10n.bundle)
        }
        /// 出演情報がありません — 出演パネルの空状態の見出し
        static var castEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.cast.empty.title", defaultValue: "出演情報がありません", table: "Events", bundle: L10n.bundle)
        }
        /// {present}/{total} 名 — 全員集合の帯の右の人数 (出演 / ブランド全体)。1000 以上は桁区切りが付く (ありえない) — 引数: present (int), total (count)
        static func castFullAttendanceCount(present: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.full_attendance.count", defaultValue: "\(String(present))/\(total) 名", table: "Events", bundle: L10n.bundle)
        }
        /// 全員集合！ — ブランドのアイドルが全員出演したライブの帯
        static var castFullAttendanceTitle: LocalizedStringResource {
            LocalizedStringResource("events.cast.full_attendance.title", defaultValue: "全員集合！", table: "Events", bundle: L10n.bundle)
        }
        /// {label} ・ {count}名 — 出演パネル: DAY ごと・欠席などのまとまりの見出し。label はコアが付けた名前 (DAY1・欠席など)。1000 以上は桁区切りが付く (ありえない) — 引数: label (core), count (count)
        static func castGroupHeader(label: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.group.header", defaultValue: "\(label) ・ \(count)名", table: "Events", bundle: L10n.bundle)
        }
        /// ゲスト — 出演パネル: ゲストの節の見出し (1 人のとき) と、アバターの下の札
        static var castRoleGuest: LocalizedStringResource {
            LocalizedStringResource("events.cast.role.guest", defaultValue: "ゲスト", table: "Events", bundle: L10n.bundle)
        }
        /// ゲスト ・ {count}名 — 出演パネル: ゲストの節の見出し (2 人以上のとき)。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func castRoleGuestCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.role.guest_count", defaultValue: "ゲスト ・ \(count)名", table: "Events", bundle: L10n.bundle)
        }
        /// 主演 — 出演パネル: 主演の節の見出し (1 人のとき) と、アバターの下の札
        static var castRoleLead: LocalizedStringResource {
            LocalizedStringResource("events.cast.role.lead", defaultValue: "主演", table: "Events", bundle: L10n.bundle)
        }
        /// 主演 ・ {count}名 — 出演パネル: 主演の節の見出し (2 人以上のとき)。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func castRoleLeadCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.role.lead_count", defaultValue: "主演 ・ \(count)名", table: "Events", bundle: L10n.bundle)
        }
        /// 披露ユニット ・ 全 {present}/{total} 名 — 出演パネル: 歌唱したユニットの節の見出し (出演者 / ブランド全体の人数)。1000 以上は桁区切りが付く (ありえない) — 引数: present (int), total (count)
        static func castUnitsHeader(present: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.cast.units.header", defaultValue: "披露ユニット ・ 全 \(String(present))/\(total) 名", table: "Events", bundle: L10n.bundle)
        }
        /// ライブ名をコピー — ライブ名の長押しメニュー
        static var detailCopyName: LocalizedStringResource {
            LocalizedStringResource("events.detail.copy.name", defaultValue: "ライブ名をコピー", table: "Events", bundle: L10n.bundle)
        }
        /// ・ 合同 — ライブ詳細の日付の行の後ろに付ける、合同ライブ (複数ブランド) の印
        static var detailHeroJoint: LocalizedStringResource {
            LocalizedStringResource("events.detail.hero.joint", defaultValue: "・ 合同", table: "Events", bundle: L10n.bundle)
        }
        /// 編集 — ライブ詳細の右上メニュー: ライブを編集。Android は detail.menu.edit_android
        static var detailMenuEdit: LocalizedStringResource {
            LocalizedStringResource("events.detail.menu.edit", defaultValue: "編集", table: "Events", bundle: L10n.bundle)
        }
        /// 編集履歴 — ライブ詳細の右上メニュー (Android は公演の行の ⋮ メニューにも): 編集履歴を開く
        static var detailMenuHistory: LocalizedStringResource {
            LocalizedStringResource("events.detail.menu.history", defaultValue: "編集履歴", table: "Events", bundle: L10n.bundle)
        }
        /// このイベントをシェア — ライブ詳細の右上の共有ボタンの読み上げ
        static var detailShareA11y: LocalizedStringResource {
            LocalizedStringResource("events.detail.share.a11y", defaultValue: "このイベントをシェア", table: "Events", bundle: L10n.bundle)
        }
        /// 追加 — 公演一覧の見出しの右の、公演を追加するボタン
        static var detailShowsActionAdd: LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.action.add", defaultValue: "追加", table: "Events", bundle: L10n.bundle)
        }
        /// 公演を追加 — 公演を追加する操作。iOS は公演が無いときの空状態のボタン、Android は右上メニュー
        static var detailShowsActionAddShow: LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.action.add_show", defaultValue: "公演を追加", table: "Events", bundle: L10n.bundle)
        }
        /// 公演を編集 — 公演の行のメニュー (iOS は長押し、Android は ⋮)
        static var detailShowsActionEditShow: LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.action.edit_show", defaultValue: "公演を編集", table: "Events", bundle: L10n.bundle)
        }
        /// 「追加」から公演を登録できます — 公演が無いときの空状態の説明 (編集できる人だけ)。「追加」は見出しの右のボタン (detail.shows.action.add)
        static var detailShowsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.empty.message", defaultValue: "「追加」から公演を登録できます", table: "Events", bundle: L10n.bundle)
        }
        /// 公演がまだありません — 公演が 1 つも無いときの空状態の見出し
        static var detailShowsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.empty.title", defaultValue: "公演がまだありません", table: "Events", bundle: L10n.bundle)
        }
        /// 公演 ・ {count} 公演 → セトリへ — 公演一覧の節の見出し。行を押すとセトリへ進む。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func detailShowsHeader(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.detail.shows.header", defaultValue: "公演 ・ \(count) 公演 → セトリへ", table: "Events", bundle: L10n.bundle)
        }
        /// 出演 — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報)
        static var detailTabCast: LocalizedStringResource {
            LocalizedStringResource("events.detail.tab.cast", defaultValue: "出演", table: "Events", bundle: L10n.bundle)
        }
        /// 情報 — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報)
        static var detailTabInfo: LocalizedStringResource {
            LocalizedStringResource("events.detail.tab.info", defaultValue: "情報", table: "Events", bundle: L10n.bundle)
        }
        /// 公演・セトリ — ライブ詳細の中のセグメント (公演・セトリ / 出演 / 情報)
        static var detailTabShows: LocalizedStringResource {
            LocalizedStringResource("events.detail.tab.shows", defaultValue: "公演・セトリ", table: "Events", bundle: L10n.bundle)
        }
        /// 参加済み — 参加状態の選択肢 (と適用中のチップ): 参加したライブだけ
        static var filterAttendanceAttended: LocalizedStringResource {
            LocalizedStringResource("events.filter.attendance.attended", defaultValue: "参加済み", table: "Events", bundle: L10n.bundle)
        }
        /// 未参加 — 参加状態の選択肢 (と適用中のチップ): 参加していないライブだけ
        static var filterAttendanceNotAttended: LocalizedStringResource {
            LocalizedStringResource("events.filter.attendance.not_attended", defaultValue: "未参加", table: "Events", bundle: L10n.bundle)
        }
        /// 除外: {kinds} — 除外している種別。一覧のチップでは 1 つ、フィルタシートでは「 / 」区切りの並び。語はコア — 引数: kinds (core)
        static func filterKindExcluded(kinds: String) -> LocalizedStringResource {
            LocalizedStringResource("events.filter.kind.excluded", defaultValue: "除外: \(kinds)", table: "Events", bundle: L10n.bundle)
        }
        /// ブランド — 情報パネルの行の名前: ブランド
        static var infoMetaBrand: LocalizedStringResource {
            LocalizedStringResource("events.info.meta.brand", defaultValue: "ブランド", table: "Events", bundle: L10n.bundle)
        }
        /// 年度 — 情報パネルの行の名前: 開催年
        static var infoMetaYear: LocalizedStringResource {
            LocalizedStringResource("events.info.meta.year", defaultValue: "年度", table: "Events", bundle: L10n.bundle)
        }
        /// {year}年 — 情報パネルの開催年の値 — 引数: year (int)
        static func infoMetaYearValue(year: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.info.meta.year_value", defaultValue: "\(String(year))年", table: "Events", bundle: L10n.bundle)
        }
        /// キャスト — 情報パネルの数字のタイル: 出演者数
        static var infoStatsCast: LocalizedStringResource {
            LocalizedStringResource("events.info.stats.cast", defaultValue: "キャスト", table: "Events", bundle: L10n.bundle)
        }
        /// 公演 — 情報パネルの数字のタイル: 公演数
        static var infoStatsShows: LocalizedStringResource {
            LocalizedStringResource("events.info.stats.shows", defaultValue: "公演", table: "Events", bundle: L10n.bundle)
        }
        /// 曲（延べ） — 情報パネルの数字のタイル: 全公演で歌われた曲数 (同じ曲も数える)
        static var infoStatsTotalSongs: LocalizedStringResource {
            LocalizedStringResource("events.info.stats.total_songs", defaultValue: "曲（延べ）", table: "Events", bundle: L10n.bundle)
        }
        /// ユニーク曲 — 情報パネルの数字のタイル: 歌われた曲の種類数 (同じ曲は 1 回)
        static var infoStatsUniqueSongs: LocalizedStringResource {
            LocalizedStringResource("events.info.stats.unique_songs", defaultValue: "ユニーク曲", table: "Events", bundle: L10n.bundle)
        }
        /// 編集 — チケット情報の見出しの右のボタン (情報があるとき)
        static var infoTicketActionEdit: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.action.edit", defaultValue: "編集", table: "Events", bundle: L10n.bundle)
        }
        /// 登録 — チケット情報の見出しの右のボタン (まだ情報が無いとき)
        static var infoTicketActionRegister: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.action.register", defaultValue: "登録", table: "Events", bundle: L10n.bundle)
        }
        /// チケット情報は未登録です — チケット情報が無いとき
        static var infoTicketEmpty: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.empty", defaultValue: "チケット情報は未登録です", table: "Events", bundle: L10n.bundle)
        }
        /// チケット情報 — 情報パネル: チケット情報の節の見出し
        static var infoTicketHeader: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.header", defaultValue: "チケット情報", table: "Events", bundle: L10n.bundle)
        }
        /// 公式チケットページを開く — チケット情報: 公式のチケットページへのリンク
        static var infoTicketOpenOfficial: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.open_official", defaultValue: "公式チケットページを開く", table: "Events", bundle: L10n.bundle)
        }
        /// チケット情報を登録 — チケット情報が無いときの登録ボタン (編集できる人だけ)
        static var infoTicketRegister: LocalizedStringResource {
            LocalizedStringResource("events.info.ticket.register", defaultValue: "チケット情報を登録", table: "Events", bundle: L10n.bundle)
        }
        /// フィルタを解除 — 絞り込みを全部外す (右上メニューと、絞り込みで 0 件のときの空状態のボタン)
        static var listActionClearFilters: LocalizedStringResource {
            LocalizedStringResource("events.list.action.clear_filters", defaultValue: "フィルタを解除", table: "Events", bundle: L10n.bundle)
        }
        /// フィルタ条件に合うライブが見つかりませんでした。 — フィルタで 1 件も残らなかったときの説明
        static var listEmptyFilteredMessage: LocalizedStringResource {
            LocalizedStringResource("events.list.empty.filtered.message", defaultValue: "フィルタ条件に合うライブが見つかりませんでした。", table: "Events", bundle: L10n.bundle)
        }
        /// 開催済みのライブはまだ登録されていません。 — 「開催済み」に 1 件も無いときの説明
        static var listEmptyPastMessage: LocalizedStringResource {
            LocalizedStringResource("events.list.empty.past.message", defaultValue: "開催済みのライブはまだ登録されていません。", table: "Events", bundle: L10n.bundle)
        }
        /// 開催済みのライブがありません — 「開催済み」に 1 件も無いときの空状態の見出し
        static var listEmptyPastTitle: LocalizedStringResource {
            LocalizedStringResource("events.list.empty.past.title", defaultValue: "開催済みのライブがありません", table: "Events", bundle: L10n.bundle)
        }
        /// 現在、登録されている今後のライブはありません。「開催済み」タブもご確認ください。 — 「今後の予定」に 1 件も無いときの説明。「開催済み」は list.tab.past のタブの名前
        static var listEmptyUpcomingMessage: LocalizedStringResource {
            LocalizedStringResource("events.list.empty.upcoming.message", defaultValue: "現在、登録されている今後のライブはありません。「開催済み」タブもご確認ください。", table: "Events", bundle: L10n.bundle)
        }
        /// 今後の予定はありません — 「今後の予定」に 1 件も無いときの空状態の見出し
        static var listEmptyUpcomingTitle: LocalizedStringResource {
            LocalizedStringResource("events.list.empty.upcoming.title", defaultValue: "今後の予定はありません", table: "Events", bundle: L10n.bundle)
        }
        /// お気に入り — 適用中の絞り込みのチップ: お気に入りだけ
        static var listFilterChipFavorite: LocalizedStringResource {
            LocalizedStringResource("events.list.filter_chip.favorite", defaultValue: "お気に入り", table: "Events", bundle: L10n.bundle)
        }
        /// メモあり — 適用中の絞り込みのチップ: メモがあるライブだけ
        static var listFilterChipHasNote: LocalizedStringResource {
            LocalizedStringResource("events.list.filter_chip.has_note", defaultValue: "メモあり", table: "Events", bundle: L10n.bundle)
        }
        /// 絞り込みを解除 — 名前の絞り込みを消すボタン。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var listFilterEmptyAction: LocalizedStringResource {
            LocalizedStringResource("events.list.filter_empty.action", defaultValue: "絞り込みを解除", table: "Events", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するライブがありません — 名前の絞り込みで 1 件も残らなかったときの説明。query は入力した語 — 引数: query (string)
        static func listFilterEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("events.list.filter_empty.message", defaultValue: "「\(query)」に一致するライブがありません", table: "Events", bundle: L10n.bundle)
        }
        /// 絞り込み結果がありません — 名前の絞り込みで 1 件も残らなかったときの空状態の見出し。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var listFilterEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.list.filter_empty.title", defaultValue: "絞り込み結果がありません", table: "Events", bundle: L10n.bundle)
        }
        /// イベントを追加 — ライブ一覧の右上メニュー: 新しいライブを作る
        static var listMenuAddEvent: LocalizedStringResource {
            LocalizedStringResource("events.list.menu.add_event", defaultValue: "イベントを追加", table: "Events", bundle: L10n.bundle)
        }
        /// ライブ名・会場 — ナビバーの絞り込み欄のプレースホルダ (虫眼鏡が付くので対象だけ)
        static var listSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("events.list.search_prompt", defaultValue: "ライブ名・会場", table: "Events", bundle: L10n.bundle)
        }
        /// 開催済み — ライブ一覧のセグメント: 終わったライブ。list.empty.upcoming.message が「開催済み」タブと呼ぶ
        static var listTabPast: LocalizedStringResource {
            LocalizedStringResource("events.list.tab.past", defaultValue: "開催済み", table: "Events", bundle: L10n.bundle)
        }
        /// 今後の予定 — ライブ一覧のセグメント: これからのライブ
        static var listTabUpcoming: LocalizedStringResource {
            LocalizedStringResource("events.list.tab.upcoming", defaultValue: "今後の予定", table: "Events", bundle: L10n.bundle)
        }
        /// ライブ — ライブ一覧の画面の見出し
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("events.list.title", defaultValue: "ライブ", table: "Events", bundle: L10n.bundle)
        }
        /// 参加の記録 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名
        static var localWriteRecordAttendance: LocalizedStringResource {
            LocalizedStringResource("events.local_write.record_attendance", defaultValue: "参加の記録", table: "Events", bundle: L10n.bundle)
        }
        /// 所有の記録 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 (映像円盤の所有)
        static var localWriteRecordOwned: LocalizedStringResource {
            LocalizedStringResource("events.local_write.record_owned", defaultValue: "所有の記録", table: "Events", bundle: L10n.bundle)
        }
        /// メモの保存 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名
        static var localWriteSaveNote: LocalizedStringResource {
            LocalizedStringResource("events.local_write.save_note", defaultValue: "メモの保存", table: "Events", bundle: L10n.bundle)
        }
        /// 座席の保存 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名
        static var localWriteSaveSeat: LocalizedStringResource {
            LocalizedStringResource("events.local_write.save_seat", defaultValue: "座席の保存", table: "Events", bundle: L10n.bundle)
        }
        /// {mark}の切り替え — 端末への書き込みに失敗したときの知らせに入る操作名。mark はマークの種類名 (お気に入りなど) — 引数: mark (text)
        static func localWriteToggle(mark: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("events.local_write.toggle", defaultValue: "\(mark)の切り替え", table: "Events", bundle: L10n.bundle)
        }
        ///  ・  — 項目を 1 行に並べるときの区切り (前後に空白)。公演の「会場 ・ 日付」、会場の「キャパ ・ 旧名」など
        static var metaSeparator: LocalizedStringResource {
            LocalizedStringResource("events.meta.separator", defaultValue: " ・ ", table: "Events", bundle: L10n.bundle)
        }
        /// 未来公演のセトリ予想で投票すると、ここに表示されます — マイ予想: 1 つも投票していないときの説明
        static var myPredictionsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("events.my_predictions.empty.message", defaultValue: "未来公演のセトリ予想で投票すると、ここに表示されます", table: "Events", bundle: L10n.bundle)
        }
        /// まだ予想していません — マイ予想: 1 つも投票していないときの見出し
        static var myPredictionsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.my_predictions.empty.title", defaultValue: "まだ予想していません", table: "Events", bundle: L10n.bundle)
        }
        /// Apple Sign In すると、投票した予想がここにまとまります — マイ予想: 未ログインのときの説明
        static var myPredictionsLoginMessage: LocalizedStringResource {
            LocalizedStringResource("events.my_predictions.login.message", defaultValue: "Apple Sign In すると、投票した予想がここにまとまります", table: "Events", bundle: L10n.bundle)
        }
        /// ログインが必要です — マイ予想: 未ログインのときの見出し
        static var myPredictionsLoginTitle: LocalizedStringResource {
            LocalizedStringResource("events.my_predictions.login.title", defaultValue: "ログインが必要です", table: "Events", bundle: L10n.bundle)
        }
        /// マイ予想 — 自分が投票したセトリ予想の一覧の見出し
        static var myPredictionsTitle: LocalizedStringResource {
            LocalizedStringResource("events.my_predictions.title", defaultValue: "マイ予想", table: "Events", bundle: L10n.bundle)
        }
        /// メモ — メモの入力シート・ダイアログの見出し
        static var noteEditorTitle: LocalizedStringResource {
            LocalizedStringResource("events.note_editor.title", defaultValue: "メモ", table: "Events", bundle: L10n.bundle)
        }
        /// 再生停止 — プレビュー再生中の音楽メニュー: 止める
        static var playlistActionStop: LocalizedStringResource {
            LocalizedStringResource("events.playlist.action.stop", defaultValue: "再生停止", table: "Events", bundle: L10n.bundle)
        }
        /// プレイリスト — プレイリストを作った結果のアラートの見出し
        static var playlistAlertTitle: LocalizedStringResource {
            LocalizedStringResource("events.playlist.alert.title", defaultValue: "プレイリスト", table: "Events", bundle: L10n.bundle)
        }
        /// 「{name}」プレイリストを作成しました（{count}曲） — プレイリストを作ったとき。name はプレイリスト名。1000 以上は桁区切りが付く (ありえない) — 引数: name (string), count (count)
        static func playlistCreated(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.playlist.created", defaultValue: "「\(name)」プレイリストを作成しました（\(count)曲）", table: "Events", bundle: L10n.bundle)
        }
        /// アイドルライブDB 予想セトリから作成 — セトリ予想から Apple Music に作るプレイリストの説明欄。アプリ名 (アイドルライブDB) は訳さない
        static var playlistDescriptionPrediction: LocalizedStringResource {
            LocalizedStringResource("events.playlist.description.prediction", defaultValue: "アイドルライブDB 予想セトリから作成", table: "Events", bundle: L10n.bundle)
        }
        /// アイドルライブDB から作成 — Apple Music に作るプレイリストの説明欄。アプリ名 (アイドルライブDB) は訳さない
        static var playlistDescriptionSetlist: LocalizedStringResource {
            LocalizedStringResource("events.playlist.description.setlist", defaultValue: "アイドルライブDB から作成", table: "Events", bundle: L10n.bundle)
        }
        /// プレイリスト作成に失敗しました: {error} — プレイリストを作れなかったとき。error は OS のエラーの説明 — 引数: error (string)
        static func playlistErrorFailed(error: String) -> LocalizedStringResource {
            LocalizedStringResource("events.playlist.error.failed", defaultValue: "プレイリスト作成に失敗しました: \(error)", table: "Events", bundle: L10n.bundle)
        }
        /// Apple Music IDが登録されている曲がありません — プレイリストに入れられる曲が無いとき
        static var playlistErrorNoIds: LocalizedStringResource {
            LocalizedStringResource("events.playlist.error.no_ids", defaultValue: "Apple Music IDが登録されている曲がありません", table: "Events", bundle: L10n.bundle)
        }
        /// Apple Musicのサブスクリプションが必要です — Apple Music を契約していないとき
        static var playlistErrorSubscription: LocalizedStringResource {
            LocalizedStringResource("events.playlist.error.subscription", defaultValue: "Apple Musicのサブスクリプションが必要です", table: "Events", bundle: L10n.bundle)
        }
        /// プレイリスト作成中… {current}/{total} — プレイリストを作っている間の進み具合 (何曲目 / 全曲数) — 引数: current (int), total (int)
        static func playlistProgress(current: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.playlist.progress", defaultValue: "プレイリスト作成中… \(String(current))/\(String(total))", table: "Events", bundle: L10n.bundle)
        }
        /// プレイリスト作成中… — プレイリストを作っている間 (曲数が決まる前)
        static var playlistProgressIndeterminate: LocalizedStringResource {
            LocalizedStringResource("events.playlist.progress_indeterminate", defaultValue: "プレイリスト作成中…", table: "Events", bundle: L10n.bundle)
        }
        /// 予想を追加 — セトリ予想の見出しの右のボタン: 曲を選んで投票する。prediction.empty.message が「予想を追加」と呼ぶ
        static var predictionActionAdd: LocalizedStringResource {
            LocalizedStringResource("events.prediction.action.add", defaultValue: "予想を追加", table: "Events", bundle: L10n.bundle)
        }
        /// {count}曲の追加に失敗しました — まとめて投票したうち、失敗した曲があったとき。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func predictionAddFailed(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.add.failed", defaultValue: "\(count)曲の追加に失敗しました", table: "Events", bundle: L10n.bundle)
        }
        /// 1公演{limit}票までなので、{count}曲は投票できませんでした — 選んだ曲が残りの票より多かったとき。limit は 1 公演の上限、count は投票できなかった曲数 — 引数: limit (int), count (count)
        static func predictionAddOverflow(limit: Int, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.add.overflow", defaultValue: "1公演\(String(limit))票までなので、\(count)曲は投票できませんでした", table: "Events", bundle: L10n.bundle)
        }
        /// 「予想を追加」から、来そうな曲に投票しよう — セトリ予想が 1 つも無いときの説明。「予想を追加」は prediction.action.add のボタン
        static var predictionEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("events.prediction.empty.message", defaultValue: "「予想を追加」から、来そうな曲に投票しよう", table: "Events", bundle: L10n.bundle)
        }
        /// まだ予想がありません — セトリ予想が 1 つも無いときの見出し
        static var predictionEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.prediction.empty.title", defaultValue: "まだ予想がありません", table: "Events", bundle: L10n.bundle)
        }
        /// サーバーからの応答が不正です — セトリ予想のエラー: サーバの応答が読めない
        static var predictionErrorInvalidResponse: LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.invalid_response", defaultValue: "サーバーからの応答が不正です", table: "Events", bundle: L10n.bundle)
        }
        /// 対象が見つかりませんでした — セトリ予想の投票のエラー: 公演・曲が無い
        static var predictionErrorNotFound: LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.not_found", defaultValue: "対象が見つかりませんでした", table: "Events", bundle: L10n.bundle)
        }
        /// 投票の制限に達しました。明日またお試しください — セトリ予想の投票のエラー: 回数の制限
        static var predictionErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.rate_limited", defaultValue: "投票の制限に達しました。明日またお試しください", table: "Events", bundle: L10n.bundle)
        }
        /// サーバーエラー: {message} — セトリ予想のエラー: サーバのエラー。message はサーバの文言 (訳さない) — 引数: message (string)
        static func predictionErrorServer(message: String) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.server", defaultValue: "サーバーエラー: \(message)", table: "Events", bundle: L10n.bundle)
        }
        /// 1曲につき予想できるのは8人までです — 歌唱メンバー予想の投票のエラー: 1 曲 8 人まで
        static var predictionErrorTooManyPerformers: LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.too_many_performers", defaultValue: "1曲につき予想できるのは8人までです", table: "Events", bundle: L10n.bundle)
        }
        /// 投票にはApple Sign Inが必要です — セトリ予想の投票のエラー: 未ログイン
        static var predictionErrorUnauthorized: LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.unauthorized", defaultValue: "投票にはApple Sign Inが必要です", table: "Events", bundle: L10n.bundle)
        }
        /// 1公演につき投票できるのは{count}曲までです — セトリ予想の投票のエラー: 1 公演の上限。count は上限の曲数 — 引数: count (count)
        static func predictionErrorVoteLimit(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.error.vote_limit", defaultValue: "1公演につき投票できるのは\(count)曲までです", table: "Events", bundle: L10n.bundle)
        }
        /// 過去のセトリから推定 — 機械予測の節の見出しの下の説明
        static var predictionForecastCaption: LocalizedStringResource {
            LocalizedStringResource("events.prediction.forecast.caption", defaultValue: "過去のセトリから推定", table: "Events", bundle: L10n.bundle)
        }
        /// 予想に入れる — 機械予測の曲の行のボタン: その曲に投票する
        static var predictionForecastPromote: LocalizedStringResource {
            LocalizedStringResource("events.prediction.forecast.promote", defaultValue: "予想に入れる", table: "Events", bundle: L10n.bundle)
        }
        /// {title}を予想に入れる — 機械予測の曲の行のボタンの読み上げ。title は曲名 — 引数: title (string)
        static func predictionForecastPromoteA11y(title: String) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.forecast.promote.a11y", defaultValue: "\(title)を予想に入れる", table: "Events", bundle: L10n.bundle)
        }
        /// 機械予測 — 過去のセトリから機械的に出した予測の節の見出し
        static var predictionForecastTitle: LocalizedStringResource {
            LocalizedStringResource("events.prediction.forecast.title", defaultValue: "機械予測", table: "Events", bundle: L10n.bundle)
        }
        /// セトリ予想 — セトリ予想の節の見出し
        static var predictionHeader: LocalizedStringResource {
            LocalizedStringResource("events.prediction.header", defaultValue: "セトリ予想", table: "Events", bundle: L10n.bundle)
        }
        /// セトリ予想の投票にはログインが必要です — セトリ予想の節の未ログインの人への案内
        static var predictionLoginPrompt: LocalizedStringResource {
            LocalizedStringResource("events.prediction.login_prompt", defaultValue: "セトリ予想の投票にはログインが必要です", table: "Events", bundle: L10n.bundle)
        }
        /// 操作 — セトリ予想の ⋯ メニューボタンの読み上げ
        static var predictionMenuA11y: LocalizedStringResource {
            LocalizedStringResource("events.prediction.menu.a11y", defaultValue: "操作", table: "Events", bundle: L10n.bundle)
        }
        /// Appleプレイリスト作成 — セトリ予想の ⋯ メニュー: 上位の曲で Apple Music のプレイリストを作る
        static var predictionMenuCreatePlaylist: LocalizedStringResource {
            LocalizedStringResource("events.prediction.menu.create_playlist", defaultValue: "Appleプレイリスト作成", table: "Events", bundle: L10n.bundle)
        }
        /// 上位曲をプレビュー再生 — セトリ予想の ⋯ メニュー: 上位の曲の試聴を順に流す
        static var predictionMenuPreviewTop: LocalizedStringResource {
            LocalizedStringResource("events.prediction.menu.preview_top", defaultValue: "上位曲をプレビュー再生", table: "Events", bundle: L10n.bundle)
        }
        /// あなたの予想 {count}/{limit} — 自分が投票した曲数 / 1 公演の上限 (シェアの帯) — 引数: count (int), limit (int)
        static func predictionMyVotes(count: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.my_votes", defaultValue: "あなたの予想 \(String(count))/\(String(limit))", table: "Events", bundle: L10n.bundle)
        }
        /// 出演キャスト情報がありません — 歌唱メンバー予想: 公演の出演者が登録されていないとき
        static var predictionPerformersEmpty: LocalizedStringResource {
            LocalizedStringResource("events.prediction.performers.empty", defaultValue: "出演キャスト情報がありません", table: "Events", bundle: L10n.bundle)
        }
        /// {name} の予想を取り消す (現在{count}票) — 歌唱メンバー予想のアイドルのチップの読み上げ (投票済みのとき)。name はアイドル名。1000 以上は桁区切りが付く — 引数: name (string), count (count)
        static func predictionPerformersUnvoteA11y(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.performers.unvote.a11y", defaultValue: "\(name) の予想を取り消す (現在\(count)票)", table: "Events", bundle: L10n.bundle)
        }
        /// {name} を予想 (現在{count}票) — 歌唱メンバー予想のアイドルのチップの読み上げ (まだ投票していないとき)。name はアイドル名。1000 以上は桁区切りが付く — 引数: name (string), count (count)
        static func predictionPerformersVoteA11y(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.performers.vote.a11y", defaultValue: "\(name) を予想 (現在\(count)票)", table: "Events", bundle: L10n.bundle)
        }
        /// {show} 予想セトリ — セトリ予想から Apple Music に作るプレイリストの名前。show は公演名 — 引数: show (string)
        static func predictionPlaylistName(show: String) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.playlist.name", defaultValue: "\(show) 予想セトリ", table: "Events", bundle: L10n.bundle)
        }
        /// 残り{remaining}/{limit} — セトリ予想の見出し: 自分の残りの票数 / 1 公演の上限 — 引数: remaining (int), limit (int)
        static func predictionRemaining(remaining: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.remaining", defaultValue: "残り\(String(remaining))/\(String(limit))", table: "Events", bundle: L10n.bundle)
        }
        /// 歌唱メンバー予想 — セトリ予想の曲の行の下の、誰が歌うかの予想を開くボタン
        static var predictionRowPerformersToggle: LocalizedStringResource {
            LocalizedStringResource("events.prediction.row.performers_toggle", defaultValue: "歌唱メンバー予想", table: "Events", bundle: L10n.bundle)
        }
        /// 投票を取り消す — セトリ予想の曲の行の投票ボタンの読み上げ (投票済みのとき)
        static var predictionRowUnvoteA11y: LocalizedStringResource {
            LocalizedStringResource("events.prediction.row.unvote.a11y", defaultValue: "投票を取り消す", table: "Events", bundle: L10n.bundle)
        }
        /// 予想 — セトリ予想の曲の行の投票ボタン (まだ投票していないとき)
        static var predictionRowVote: LocalizedStringResource {
            LocalizedStringResource("events.prediction.row.vote", defaultValue: "予想", table: "Events", bundle: L10n.bundle)
        }
        /// この曲に投票 — セトリ予想の曲の行の投票ボタンの読み上げ (まだ投票していないとき)
        static var predictionRowVoteA11y: LocalizedStringResource {
            LocalizedStringResource("events.prediction.row.vote.a11y", defaultValue: "この曲に投票", table: "Events", bundle: L10n.bundle)
        }
        /// 投票済 — セトリ予想の曲の行の投票ボタン (投票済みのとき。押すと取り消す)
        static var predictionRowVoted: LocalizedStringResource {
            LocalizedStringResource("events.prediction.row.voted", defaultValue: "投票済", table: "Events", bundle: L10n.bundle)
        }
        /// 自分のセトリ予想をシェア — 自分の予想をシェアするボタンの読み上げ
        static var predictionShareA11y: LocalizedStringResource {
            LocalizedStringResource("events.prediction.share.a11y", defaultValue: "自分のセトリ予想をシェア", table: "Events", bundle: L10n.bundle)
        }
        /// 予想をシェア — 自分の予想をシェアするボタン
        static var predictionShareButton: LocalizedStringResource {
            LocalizedStringResource("events.prediction.share.button", defaultValue: "予想をシェア", table: "Events", bundle: L10n.bundle)
        }
        /// {count}票 — セトリ予想の票数 (見出しの合計・曲ごと・歌唱メンバー予想の合計)。1000 以上は桁区切りが付く — 引数: count (count)
        static func predictionVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.prediction.votes", defaultValue: "\(count)票", table: "Events", bundle: L10n.bundle)
        }
        /// {title} を所有に追加 — 映像円盤の所有トグルの読み上げ (持っていないとき)。title は円盤名 — 引数: title (string)
        static func releasesAddA11y(title: String) -> LocalizedStringResource {
            LocalizedStringResource("events.releases.add.a11y", defaultValue: "\(title) を所有に追加", table: "Events", bundle: L10n.bundle)
        }
        /// 持っている円盤に印を付けられます。 — 映像円盤の節の下の説明
        static var releasesCaption: LocalizedStringResource {
            LocalizedStringResource("events.releases.caption", defaultValue: "持っている円盤に印を付けられます。", table: "Events", bundle: L10n.bundle)
        }
        /// 映像円盤 — ライブの情報パネル: 映像円盤 (Blu-ray / DVD) の節の見出し
        static var releasesHeader: LocalizedStringResource {
            LocalizedStringResource("events.releases.header", defaultValue: "映像円盤", table: "Events", bundle: L10n.bundle)
        }
        /// 未所有 — 映像円盤の行の所有トグル (持っていないとき)
        static var releasesNotOwned: LocalizedStringResource {
            LocalizedStringResource("events.releases.not_owned", defaultValue: "未所有", table: "Events", bundle: L10n.bundle)
        }
        /// 所有 — 映像円盤の行の所有トグル (持っているとき)
        static var releasesOwned: LocalizedStringResource {
            LocalizedStringResource("events.releases.owned", defaultValue: "所有", table: "Events", bundle: L10n.bundle)
        }
        /// {owned}/{total} 所有 — 映像円盤の節の見出しの右: 持っている数 / 全部の数 — 引数: owned (int), total (int)
        static func releasesOwnedCount(owned: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.releases.owned_count", defaultValue: "\(String(owned))/\(String(total)) 所有", table: "Events", bundle: L10n.bundle)
        }
        /// 購入ページ — 映像円盤の行の、購入ページへのリンク
        static var releasesPurchase: LocalizedStringResource {
            LocalizedStringResource("events.releases.purchase", defaultValue: "購入ページ", table: "Events", bundle: L10n.bundle)
        }
        /// {title} を所有から外す — 映像円盤の所有トグルの読み上げ (持っているとき)。title は円盤名 — 引数: title (string)
        static func releasesRemoveA11y(title: String) -> LocalizedStringResource {
            LocalizedStringResource("events.releases.remove.a11y", defaultValue: "\(title) を所有から外す", table: "Events", bundle: L10n.bundle)
        }
        /// ブロック・列・番号など、自由に記録できます。 — 座席の入力欄の下の説明
        static var seatEditorFooter: LocalizedStringResource {
            LocalizedStringResource("events.seat_editor.footer", defaultValue: "ブロック・列・番号など、自由に記録できます。", table: "Events", bundle: L10n.bundle)
        }
        /// 例: アリーナ A6 12列 34番 — 座席の入力欄のプレースホルダ。Android は seat_editor.placeholder_android (ja が違う)
        static var seatEditorPlaceholderIos: LocalizedStringResource {
            LocalizedStringResource("events.seat_editor.placeholder_ios", defaultValue: "例: アリーナ A6 12列 34番", table: "Events", bundle: L10n.bundle)
        }
        /// 座席 — 座席の入力シート・ダイアログの見出し
        static var seatEditorTitle: LocalizedStringResource {
            LocalizedStringResource("events.seat_editor.title", defaultValue: "座席", table: "Events", bundle: L10n.bundle)
        }
        /// {type}で参加 — 参加の形態を選ぶダイアログの選択肢。type は形態 (現地・配信など。コアの語) — 引数: type (core)
        static func setlistAttendanceJoin(type: String) -> LocalizedStringResource {
            LocalizedStringResource("events.setlist.attendance.join", defaultValue: "\(type)で参加", table: "Events", bundle: L10n.bundle)
        }
        /// 参加を取り消す — 参加の形態を選ぶダイアログの、参加を外すボタン
        static var setlistAttendanceRemove: LocalizedStringResource {
            LocalizedStringResource("events.setlist.attendance.remove", defaultValue: "参加を取り消す", table: "Events", bundle: L10n.bundle)
        }
        /// この公演への参加 — 参加の形態を選ぶダイアログの見出し
        static var setlistAttendanceTitle: LocalizedStringResource {
            LocalizedStringResource("events.setlist.attendance.title", defaultValue: "この公演への参加", table: "Events", bundle: L10n.bundle)
        }
        /// 上の階層 — セトリ画面の上の「ブランド › イベント」のパンくずの読み上げ
        static var setlistBreadcrumbA11y: LocalizedStringResource {
            LocalizedStringResource("events.setlist.breadcrumb.a11y", defaultValue: "上の階層", table: "Events", bundle: L10n.bundle)
        }
        /// 衣装 ・ {count} 着 — セトリ画面の衣装の節の見出し。1000 以上は桁区切りが付く (ありえない) — 引数: count (count)
        static func setlistCostumeHeader(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.setlist.costume.header", defaultValue: "衣装 ・ \(count) 着", table: "Events", bundle: L10n.bundle)
        }
        /// セトリを追加 — セトリが無い過去の公演の空状態のボタン (編集できる人だけ)
        static var setlistEmptyAction: LocalizedStringResource {
            LocalizedStringResource("events.setlist.empty.action", defaultValue: "セトリを追加", table: "Events", bundle: L10n.bundle)
        }
        /// セトリは公演後に登録されます — セトリが無い未来の公演の空状態の説明
        static var setlistEmptyFutureMessage: LocalizedStringResource {
            LocalizedStringResource("events.setlist.empty.future.message", defaultValue: "セトリは公演後に登録されます", table: "Events", bundle: L10n.bundle)
        }
        /// 公演前です — セトリが無い未来の公演の空状態の見出し
        static var setlistEmptyFutureTitle: LocalizedStringResource {
            LocalizedStringResource("events.setlist.empty.future.title", defaultValue: "公演前です", table: "Events", bundle: L10n.bundle)
        }
        /// このライブのセトリはまだ登録されていません。ログインして編集に参加できます — セトリが無い過去の公演の空状態の説明
        static var setlistEmptyPastMessage: LocalizedStringResource {
            LocalizedStringResource("events.setlist.empty.past.message", defaultValue: "このライブのセトリはまだ登録されていません。ログインして編集に参加できます", table: "Events", bundle: L10n.bundle)
        }
        /// セトリ未登録 — セトリが無い過去の公演の空状態の見出し
        static var setlistEmptyPastTitle: LocalizedStringResource {
            LocalizedStringResource("events.setlist.empty.past.title", defaultValue: "セトリ未登録", table: "Events", bundle: L10n.bundle)
        }
        /// キャパ — セトリ画面の会場カードの行の名前: 会場の収容人数
        static var setlistInfoCapacity: LocalizedStringResource {
            LocalizedStringResource("events.setlist.info.capacity", defaultValue: "キャパ", table: "Events", bundle: L10n.bundle)
        }
        /// 日付 — セトリ画面の会場カードの行の名前: 公演日
        static var setlistInfoDate: LocalizedStringResource {
            LocalizedStringResource("events.setlist.info.date", defaultValue: "日付", table: "Events", bundle: L10n.bundle)
        }
        /// 配信 — セトリ画面の会場カードの行の名前: 配信サービス
        static var setlistInfoStream: LocalizedStringResource {
            LocalizedStringResource("events.setlist.info.stream", defaultValue: "配信", table: "Events", bundle: L10n.bundle)
        }
        /// 会場 — セトリ画面の会場カードの行の名前: 会場
        static var setlistInfoVenue: LocalizedStringResource {
            LocalizedStringResource("events.setlist.info.venue", defaultValue: "会場", table: "Events", bundle: L10n.bundle)
        }
        /// この曲が良かった — セトリの行の 👍 ボタンの読み上げ (まだ押していないとき)
        static var setlistLikeAddA11y: LocalizedStringResource {
            LocalizedStringResource("events.setlist.like.add.a11y", defaultValue: "この曲が良かった", table: "Events", bundle: L10n.bundle)
        }
        /// Like するには Apple Sign In が必要です — 未ログインで 👍 したときのエラー。Android は setlist.like.error.unauthorized_android
        static var setlistLikeErrorUnauthorizedIos: LocalizedStringResource {
            LocalizedStringResource("events.setlist.like.error.unauthorized_ios", defaultValue: "Like するには Apple Sign In が必要です", table: "Events", bundle: L10n.bundle)
        }
        /// Good を取り消す — セトリの行の 👍 ボタンの読み上げ (押してあるとき)
        static var setlistLikeRemoveA11y: LocalizedStringResource {
            LocalizedStringResource("events.setlist.like.remove.a11y", defaultValue: "Good を取り消す", table: "Events", bundle: L10n.bundle)
        }
        /// Apple Musicプレイリストに追加 — セトリ画面の音楽メニュー: セトリの曲で Apple Music のプレイリストを作る
        static var setlistMenuAddToAppleMusic: LocalizedStringResource {
            LocalizedStringResource("events.setlist.menu.add_to_apple_music", defaultValue: "Apple Musicプレイリストに追加", table: "Events", bundle: L10n.bundle)
        }
        /// 表示 — セトリ画面の右上メニューの、表示の詳しさを選ぶ項目の名前
        static var setlistMenuDisplay: LocalizedStringResource {
            LocalizedStringResource("events.setlist.menu.display", defaultValue: "表示", table: "Events", bundle: L10n.bundle)
        }
        /// セトリを編集 — セトリ画面の右上メニュー
        static var setlistMenuEdit: LocalizedStringResource {
            LocalizedStringResource("events.setlist.menu.edit", defaultValue: "セトリを編集", table: "Events", bundle: L10n.bundle)
        }
        /// セトリの編集履歴 — セトリ画面の右上メニュー
        static var setlistMenuHistory: LocalizedStringResource {
            LocalizedStringResource("events.setlist.menu.history", defaultValue: "セトリの編集履歴", table: "Events", bundle: L10n.bundle)
        }
        /// 全曲プレビュー再生 — セトリ画面の音楽メニュー: 全曲の試聴を順に流す
        static var setlistMenuPreviewAll: LocalizedStringResource {
            LocalizedStringResource("events.setlist.menu.preview_all", defaultValue: "全曲プレビュー再生", table: "Events", bundle: L10n.bundle)
        }
        /// 感想カードを作る — セトリの行の長押しメニュー: 曲名と感想のシェア画像を作る
        static var setlistRowCommentCard: LocalizedStringResource {
            LocalizedStringResource("events.setlist.row.comment_card", defaultValue: "感想カードを作る", table: "Events", bundle: L10n.bundle)
        }
        /// 演者をコピー — シンプル表示のセトリの行の長押しメニュー (歌った人の名前)
        static var setlistRowCopyPerformers: LocalizedStringResource {
            LocalizedStringResource("events.setlist.row.copy.performers", defaultValue: "演者をコピー", table: "Events", bundle: L10n.bundle)
        }
        /// 曲名をコピー — シンプル表示のセトリの行の長押しメニュー
        static var setlistRowCopyTitle: LocalizedStringResource {
            LocalizedStringResource("events.setlist.row.copy.title", defaultValue: "曲名をコピー", table: "Events", bundle: L10n.bundle)
        }
        /// 全員 — セトリの行の札: 出演者全員で歌った曲
        static var setlistRowFullCast: LocalizedStringResource {
            LocalizedStringResource("events.setlist.row.full_cast", defaultValue: "全員", table: "Events", bundle: L10n.bundle)
        }
        /// アンコール — セトリの区切りの見出し: アンコール (コアがアンコール類をこの語に畳む)
        static var setlistSectionEncore: LocalizedStringResource {
            LocalizedStringResource("events.setlist.section.encore", defaultValue: "アンコール", table: "Events", bundle: L10n.bundle)
        }
        /// 本編 — セトリの区切りの見出し: 本編 (コアの見出し「本編」とメタ未取得のときに出す)
        static var setlistSectionMain: LocalizedStringResource {
            LocalizedStringResource("events.setlist.section.main", defaultValue: "本編", table: "Events", bundle: L10n.bundle)
        }
        /// この公演をシェア — セトリ画面の右上の共有ボタンの読み上げ
        static var setlistShareA11y: LocalizedStringResource {
            LocalizedStringResource("events.setlist.share.a11y", defaultValue: "この公演をシェア", table: "Events", bundle: L10n.bundle)
        }
        /// 予想 — 未来の公演でセトリと予想が両方あるときのセグメント: セトリ予想
        static var setlistTabPrediction: LocalizedStringResource {
            LocalizedStringResource("events.setlist.tab.prediction", defaultValue: "予想", table: "Events", bundle: L10n.bundle)
        }
        /// セットリスト — 未来の公演でセトリと予想が両方あるときのセグメント: 実際のセトリ
        static var setlistTabSetlist: LocalizedStringResource {
            LocalizedStringResource("events.setlist.tab.setlist", defaultValue: "セットリスト", table: "Events", bundle: L10n.bundle)
        }
        /// チケット — セトリ画面のチケット価格の節の見出し
        static var setlistTicketHeader: LocalizedStringResource {
            LocalizedStringResource("events.setlist.ticket.header", defaultValue: "チケット", table: "Events", bundle: L10n.bundle)
        }
        /// {kind}・{name} — 券の形態が 1 種類だけのときの行の名前。kind は形態 (コアの語)、name は券種名 — 引数: kind (core), name (string)
        static func setlistTicketKindName(kind: String, name: String) -> LocalizedStringResource {
            LocalizedStringResource("events.setlist.ticket.kind_name", defaultValue: "\(kind)・\(name)", table: "Events", bundle: L10n.bundle)
        }
        /// {name} (推定) — 推定の価格の券種名。name は券種名 (データ) — 引数: name (string)
        static func setlistTicketNameEstimate(name: String) -> LocalizedStringResource {
            LocalizedStringResource("events.setlist.ticket.name_estimate", defaultValue: "\(name) (推定)", table: "Events", bundle: L10n.bundle)
        }
        /// {range} (推定含む) — 券の形態ごとの価格帯に推定の価格が混じるとき。range はコアが作った価格帯 — 引数: range (core)
        static func setlistTicketRangeEstimate(range: String) -> LocalizedStringResource {
            LocalizedStringResource("events.setlist.ticket.range_estimate", defaultValue: "\(range) (推定含む)", table: "Events", bundle: L10n.bundle)
        }
        /// セットリスト — 公演のセトリ画面の見出し
        static var setlistTitle: LocalizedStringResource {
            LocalizedStringResource("events.setlist.title", defaultValue: "セットリスト", table: "Events", bundle: L10n.bundle)
        }
        /// 👍 で投票するにはログインが必要です — セトリの上の案内 (未ログイン)
        static var setlistVoteHintLogin: LocalizedStringResource {
            LocalizedStringResource("events.setlist.vote_hint.login", defaultValue: "👍 で投票するにはログインが必要です", table: "Events", bundle: L10n.bundle)
        }
        /// 良かったと思った曲に 👍 で投票しよう！ — セトリの上の案内 (ログイン済み)
        static var setlistVoteHintSignedIn: LocalizedStringResource {
            LocalizedStringResource("events.setlist.vote_hint.signed_in", defaultValue: "良かったと思った曲に 👍 で投票しよう！", table: "Events", bundle: L10n.bundle)
        }
        /// 参加した公演を編集 — ライブ詳細のマイマークの帯の参加ボタンの読み上げ (参加済みの公演があるとき)
        static var userMarkAttendedEditA11y: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.attended.edit.a11y", defaultValue: "参加した公演を編集", table: "Events", bundle: L10n.bundle)
        }
        /// 参加した公演を選ぶ — ライブ詳細のマイマークの帯の参加ボタンの読み上げ (まだ参加が無いとき)
        static var userMarkAttendedSelectA11y: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.attended.select.a11y", defaultValue: "参加した公演を選ぶ", table: "Events", bundle: L10n.bundle)
        }
        /// 参加 — マークの種類名: 公演に参加した。マイマークの帯のボタンの名前にもなる
        static var userMarkKindAttended: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.attended", defaultValue: "参加", table: "Events", bundle: L10n.bundle)
        }
        /// 回収済 — マークの種類名: 楽曲をライブで聴いた (現地回収した)
        static var userMarkKindCollected: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.collected", defaultValue: "回収済", table: "Events", bundle: L10n.bundle)
        }
        /// お気に入り — マークの種類名: お気に入り。マイマークの帯のボタンの名前にもなる
        static var userMarkKindFavorite: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.favorite", defaultValue: "お気に入り", table: "Events", bundle: L10n.bundle)
        }
        /// 習熟度 — マークの種類名: 楽曲の習熟度 (段階)
        static var userMarkKindMastery: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.mastery", defaultValue: "習熟度", table: "Events", bundle: L10n.bundle)
        }
        /// 担当 — マークの種類名: 担当 (推しのアイドル)
        static var userMarkKindMyPick: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.my_pick", defaultValue: "担当", table: "Events", bundle: L10n.bundle)
        }
        /// メモ — マークの種類名: 自分用のメモ。マイマークの帯のボタンの名前にもなる
        static var userMarkKindNote: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.note", defaultValue: "メモ", table: "Events", bundle: L10n.bundle)
        }
        /// 所有 — マークの種類名: 映像円盤・カードを持っている
        static var userMarkKindOwned: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.owned", defaultValue: "所有", table: "Events", bundle: L10n.bundle)
        }
        /// 座席 — マークの種類名: 参加した公演の座席。マイマークの帯のボタンの名前にもなる
        static var userMarkKindSeat: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.kind.seat", defaultValue: "座席", table: "Events", bundle: L10n.bundle)
        }
        /// メモあり — マイマークの帯のメモボタンの読み上げ (メモが書いてあるとき)
        static var userMarkNoteFilledA11y: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.note.filled.a11y", defaultValue: "メモあり", table: "Events", bundle: L10n.bundle)
        }
        /// 座席を記録 — マイマークの帯の座席ボタンの読み上げ (まだ座席が無いとき)
        static var userMarkSeatEmptyA11y: LocalizedStringResource {
            LocalizedStringResource("events.user_mark.seat.empty.a11y", defaultValue: "座席を記録", table: "Events", bundle: L10n.bundle)
        }
        /// 座席: {seat} — マイマークの帯の座席ボタンの読み上げ (座席が書いてあるとき。seat は入力した座席) — 引数: seat (string)
        static func userMarkSeatFilledA11y(seat: String) -> LocalizedStringResource {
            LocalizedStringResource("events.user_mark.seat.filled.a11y", defaultValue: "座席: \(seat)", table: "Events", bundle: L10n.bundle)
        }
        /// {count}人 — 会場のキャパ (収容人数)。1000 以上は桁区切りが付く (14,500人) — 引数: count (count)
        static func venueCapacity(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("events.venue.capacity", defaultValue: "\(count)人", table: "Events", bundle: L10n.bundle)
        }
        /// {prefecture}・{name} — 都道府県つきの会場名 (東京・日本武道館)。どちらもデータ — 引数: prefecture (string), name (string)
        static func venueNameWithArea(prefecture: String, name: String) -> LocalizedStringResource {
            LocalizedStringResource("events.venue.name_with_area", defaultValue: "\(prefecture)・\(name)", table: "Events", bundle: L10n.bundle)
        }
        /// 「{query}」に一致する会場がありません — 会場の絞り込みで 1 件も残らなかったときの説明。query は入力した語 — 引数: query (string)
        static func venuePickerEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.empty.message", defaultValue: "「\(query)」に一致する会場がありません", table: "Events", bundle: L10n.bundle)
        }
        /// 見つかりません — 会場の絞り込みで 1 件も残らなかったときの見出し
        static var venuePickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.empty.title", defaultValue: "見つかりません", table: "Events", bundle: L10n.bundle)
        }
        /// 旧: {name} — 会場の行の副題: 以前の名前 (データ) — 引数: name (string)
        static func venuePickerFormerName(name: String) -> LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.former_name", defaultValue: "旧: \(name)", table: "Events", bundle: L10n.bundle)
        }
        /// 選択なし — 会場を選ぶ画面の先頭の行: 会場で絞らない
        static var venuePickerNone: LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.none", defaultValue: "選択なし", table: "Events", bundle: L10n.bundle)
        }
        /// 会場名・旧名・地域で検索 — 会場を選ぶ画面の検索欄のプレースホルダ
        static var venuePickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.search_prompt", defaultValue: "会場名・旧名・地域で検索", table: "Events", bundle: L10n.bundle)
        }
        /// 会場 — 会場を選ぶ画面の見出し
        static var venuePickerTitle: LocalizedStringResource {
            LocalizedStringResource("events.venue_picker.title", defaultValue: "会場", table: "Events", bundle: L10n.bundle)
        }
    }
}
