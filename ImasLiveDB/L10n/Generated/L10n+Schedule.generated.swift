// 生成物: i18n/catalog/schedule.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/schedule.json の文言 (表 Schedule)
    enum Schedule {
        /// キャンセル — スケジュール画面の確認シート・アラートのキャンセルボタン
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("schedule.action.cancel", defaultValue: "キャンセル", table: "Schedule", bundle: L10n.bundle)
        }
        /// 閉じる — スケジュール画面のアラートの閉じるボタンと、マイ予定の詳細シートの × の読み上げ
        static var actionClose: LocalizedStringResource {
            LocalizedStringResource("schedule.action.close", defaultValue: "閉じる", table: "Schedule", bundle: L10n.bundle)
        }
        /// 設定を開く — 権限が無いときのアラートの、設定アプリを開くボタン
        static var actionOpenSettings: LocalizedStringResource {
            LocalizedStringResource("schedule.action.open_settings", defaultValue: "設定を開く", table: "Schedule", bundle: L10n.bundle)
        }
        /// 受付 {event} — チケットの受付期間を表す横帯のラベル。event はライブ名 — 引数: event (string)
        static func bandTicketPeriod(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.band.ticket_period", defaultValue: "受付 \(event)", table: "Schedule", bundle: L10n.bundle)
        }
        /// リリース — 月のセル・週の段の色帯。リリースの曲名が引けなかったときの代わりの文字
        static var barReleaseFallback: LocalizedStringResource {
            LocalizedStringResource("schedule.bar.release_fallback", defaultValue: "リリース", table: "Schedule", bundle: L10n.bundle)
        }
        /// {kind}・{event} — 月のセル・週の段の色帯 (チケットの申込締切 / 当落発表)。kind はコアの語彙 (申込締切 など)、event はライブ名 — 引数: kind (core), event (string)
        static func barTicket(kind: String, event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.bar.ticket", defaultValue: "\(kind)・\(event)", table: "Schedule", bundle: L10n.bundle)
        }
        /// 受付・{event} — 週の時間グリッドのブロック (チケットの受付期間)。event はライブ名 — 引数: event (string)
        static func barTicketPeriod(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.bar.ticket_period", defaultValue: "受付・\(event)", table: "Schedule", bundle: L10n.bundle)
        }
        /// この日はライブ・リリース・誕生日の記録がありません — 選んだ日・日の詳細シートで、予定が 1 件も無いときの説明
        static var dayEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("schedule.day.empty.message", defaultValue: "この日はライブ・リリース・誕生日の記録がありません", table: "Schedule", bundle: L10n.bundle)
        }
        /// 予定なし — 選んだ日に予定が 1 件も無いときの空状態の見出し (iOS の月表示)
        static var dayEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.day.empty.title", defaultValue: "予定なし", table: "Schedule", bundle: L10n.bundle)
        }
        /// イベントなし — 日の詳細シートで予定が 1 件も無いときの空状態の見出し
        static var daySheetEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.day_sheet.empty.title", defaultValue: "イベントなし", table: "Schedule", bundle: L10n.bundle)
        }
        /// {count}件のイベント — 日の詳細シートの見出しの下の件数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func daySheetEventCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("schedule.day_sheet.event_count", defaultValue: "\(count)件のイベント", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダーに追加 — 公演を端末のカレンダーに追加する操作。iOS は確認シートのタイトル、Android はボタンの読み上げ
        static var exportAction: LocalizedStringResource {
            LocalizedStringResource("schedule.export.action", defaultValue: "カレンダーに追加", table: "Schedule", bundle: L10n.bundle)
        }
        /// 「{event}」をカレンダーに追加しました。 — カレンダーに追加できたときのアラートの説明。event はライブ名 — 引数: event (string)
        static func exportAddedMessage(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.added.message", defaultValue: "「\(event)」をカレンダーに追加しました。", table: "Schedule", bundle: L10n.bundle)
        }
        /// 追加しました — カレンダーに追加できたときのアラートの見出し
        static var exportAddedTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.export.added.title", defaultValue: "追加しました", table: "Schedule", bundle: L10n.bundle)
        }
        /// 「{event}」はすでにカレンダーに追加されています。 — もう追加してあった公演のときのアラートの説明。event はライブ名 — 引数: event (string)
        static func exportAlreadyMessage(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.already.message", defaultValue: "「\(event)」はすでにカレンダーに追加されています。", table: "Schedule", bundle: L10n.bundle)
        }
        /// 追加済み — もう追加してあった公演のときのアラートの見出し
        static var exportAlreadyTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.export.already.title", defaultValue: "追加済み", table: "Schedule", bundle: L10n.bundle)
        }
        /// 「{event}」を追加する — カレンダーに追加の確認シートのボタン。event はライブ名 — 引数: event (string)
        static func exportConfirmAdd(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.confirm.add", defaultValue: "「\(event)」を追加する", table: "Schedule", bundle: L10n.bundle)
        }
        /// 「{event}」をデバイスのカレンダーに追加します。 — カレンダーに追加の確認シートの説明。event はライブ名 — 引数: event (string)
        static func exportConfirmMessage(event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.confirm.message", defaultValue: "「\(event)」をデバイスのカレンダーに追加します。", table: "Schedule", bundle: L10n.bundle)
        }
        /// ライブの予定をカレンダーに追加するには、設定アプリでカレンダーへのアクセスを許可してください。 — カレンダーの権限が無くて追加できなかったときのアラートの説明
        static var exportDeniedMessage: LocalizedStringResource {
            LocalizedStringResource("schedule.export.denied.message", defaultValue: "ライブの予定をカレンダーに追加するには、設定アプリでカレンダーへのアクセスを許可してください。", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダーへのアクセスが拒否されています — カレンダーの権限が無くて追加できなかったときのアラートの見出し
        static var exportDeniedTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.export.denied.title", defaultValue: "カレンダーへのアクセスが拒否されています", table: "Schedule", bundle: L10n.bundle)
        }
        /// イベント情報の取得に失敗しました。 — カレンダーへ追加しようとしたライブの情報が読めなかったとき
        static var exportErrorEventNotFound: LocalizedStringResource {
            LocalizedStringResource("schedule.export.error.event_not_found", defaultValue: "イベント情報の取得に失敗しました。", table: "Schedule", bundle: L10n.bundle)
        }
        /// 日付の解析に失敗しました: {date} — 公演の日付が読めずに書き出せなかったときのエラー (アラートの説明に出る)。date はデータの日付の文字列 — 引数: date (string)
        static func exportErrorInvalidDate(date: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.error.invalid_date", defaultValue: "日付の解析に失敗しました: \(date)", table: "Schedule", bundle: L10n.bundle)
        }
        /// デフォルトカレンダーが見つかりませんでした。設定でカレンダーへのアクセスを許可してください。 — 書き出し先の既定のカレンダーが無いときのエラー (アラートの説明に出る)
        static var exportErrorNoDefaultCalendar: LocalizedStringResource {
            LocalizedStringResource("schedule.export.error.no_default_calendar", defaultValue: "デフォルトカレンダーが見つかりませんでした。設定でカレンダーへのアクセスを許可してください。", table: "Schedule", bundle: L10n.bundle)
        }
        /// エラー — カレンダーへの追加に失敗したときのアラートの見出し
        static var exportErrorTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.export.error.title", defaultValue: "エラー", table: "Schedule", bundle: L10n.bundle)
        }
        /// 都市: {city} — 端末のカレンダーに書き出す予定のメモ欄の 1 行。city は会場のある都市 (データ)。書き出したときの言語で残る — 引数: city (string)
        static func exportNotesCity(city: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.notes.city", defaultValue: "都市: \(city)", table: "Schedule", bundle: L10n.bundle)
        }
        /// 会場: {venue} — 端末のカレンダーに書き出す予定のメモ欄の 1 行。venue は会場名 (データ)。書き出したときの言語で残る — 引数: venue (string)
        static func exportNotesVenue(venue: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.export.notes.venue", defaultValue: "会場: \(venue)", table: "Schedule", bundle: L10n.bundle)
        }
        /// もう一度追加 — 追加済みのアラートのボタン (記録を消してもう一度追加する)
        static var exportReadd: LocalizedStringResource {
            LocalizedStringResource("schedule.export.readd", defaultValue: "もう一度追加", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダー — 公演の行を右へスワイプしたときのボタン (端末のカレンダーに追加)
        static var exportSwipe: LocalizedStringResource {
            LocalizedStringResource("schedule.export.swipe", defaultValue: "カレンダー", table: "Schedule", bundle: L10n.bundle)
        }
        /// 記念日 — 上のカテゴリチップ。ブランドの記念日 (サービス開始など) の表示を切り替える
        static var filterAnniversaries: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.anniversaries", defaultValue: "記念日", table: "Schedule", bundle: L10n.bundle)
        }
        /// 誕生日 — 上のカテゴリチップ。アイドルの誕生日の表示を切り替える
        static var filterBirthdays: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.birthdays", defaultValue: "誕生日", table: "Schedule", bundle: L10n.bundle)
        }
        /// 非表示 — カテゴリチップの状態の読み上げ (accessibilityValue)。オフのとき
        static var filterHiddenA11y: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.hidden.a11y", defaultValue: "非表示", table: "Schedule", bundle: L10n.bundle)
        }
        /// マイ予定 — 上のカテゴリチップ。端末のカレンダーの予定 (マイ予定) を重ねて出す
        static var filterPersonal: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.personal", defaultValue: "マイ予定", table: "Schedule", bundle: L10n.bundle)
        }
        /// リリース — 上のカテゴリチップ。CD・配信のリリース日の表示を切り替える
        static var filterReleases: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.releases", defaultValue: "リリース", table: "Schedule", bundle: L10n.bundle)
        }
        /// 表示 — カテゴリチップの状態の読み上げ (accessibilityValue)。オンのとき
        static var filterShownA11y: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.shown.a11y", defaultValue: "表示", table: "Schedule", bundle: L10n.bundle)
        }
        /// 公演 — 上のカテゴリチップ。公演 (ライブの各日) の表示を切り替える
        static var filterShows: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.shows", defaultValue: "公演", table: "Schedule", bundle: L10n.bundle)
        }
        /// 事務員 — 上のカテゴリチップ。事務員 (音無小鳥・千川ちひろなど、アイドルでない関係者) の誕生日の表示を切り替える
        static var filterStaff: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.staff", defaultValue: "事務員", table: "Schedule", bundle: L10n.bundle)
        }
        /// チケット — 上のカテゴリチップ。チケットの受付期間・締切・当落発表の表示を切り替える
        static var filterTickets: LocalizedStringResource {
            LocalizedStringResource("schedule.filter.tickets", defaultValue: "チケット", table: "Schedule", bundle: L10n.bundle)
        }
        /// 月 — 月表示と週表示の切り替え (セグメント) の「月」
        static var modeMonth: LocalizedStringResource {
            LocalizedStringResource("schedule.mode.month", defaultValue: "月", table: "Schedule", bundle: L10n.bundle)
        }
        /// 週 — 月表示と週表示の切り替え (セグメント) の「週」
        static var modeWeek: LocalizedStringResource {
            LocalizedStringResource("schedule.mode.week", defaultValue: "週", table: "Schedule", bundle: L10n.bundle)
        }
        /// {year}年 {month}月 — 月表示のグリッドの上の見出し。年と月の間に空白がある (今の表示のまま) — 引数: year (int), month (int)
        static func monthTitle(year: Int, month: Int) -> LocalizedStringResource {
            LocalizedStringResource("schedule.month.title", defaultValue: "\(String(year))年 \(String(month))月", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダー — マイ予定の所属カレンダーの名前が引けないときの代わりの表示
        static var personalCalendarFallback: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.calendar_fallback", defaultValue: "カレンダー", table: "Schedule", bundle: L10n.bundle)
        }
        /// {date} 終日 — マイ予定の詳細の日時 (1 日だけの終日の予定)。date は書式済みの日付 — 引数: date (string)
        static func personalDetailAllDay(date: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.all_day", defaultValue: "\(date) 終日", table: "Schedule", bundle: L10n.bundle)
        }
        /// {start} 〜 {end} 終日 — マイ予定の詳細の日時 (何日かにまたがる終日の予定)。start / end は書式済みの月日 — 引数: start (string), end (string)
        static func personalDetailAllDayRange(start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.all_day_range", defaultValue: "\(start) 〜 \(end) 終日", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダー — マイ予定の詳細シートの行の見出し (所属カレンダー)
        static var personalDetailCalendar: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.calendar", defaultValue: "カレンダー", table: "Schedule", bundle: L10n.bundle)
        }
        /// 日時 — マイ予定の詳細シートの行の見出し (日時)
        static var personalDetailDate: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.date", defaultValue: "日時", table: "Schedule", bundle: L10n.bundle)
        }
        /// 場所 — マイ予定の詳細シートの行の見出し (場所)
        static var personalDetailLocation: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.location", defaultValue: "場所", table: "Schedule", bundle: L10n.bundle)
        }
        /// {start} 〜 {end} — マイ予定の詳細の日時 (日をまたぐ時刻付きの予定)。start / end は書式済みの日時 — 引数: start (string), end (string)
        static func personalDetailRange(start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.range", defaultValue: "\(start) 〜 \(end)", table: "Schedule", bundle: L10n.bundle)
        }
        /// マイ予定 — マイ予定の詳細シートのタイトルの下の種別
        static var personalDetailSubtitle: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.subtitle", defaultValue: "マイ予定", table: "Schedule", bundle: L10n.bundle)
        }
        /// {day} {start} 〜 {end} — マイ予定の詳細の日時 (1 日の中の時刻付きの予定)。day は書式済みの日付、start / end は時刻 — 引数: day (string), start (string), end (string)
        static func personalDetailTimeRange(day: String, start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.personal.detail.time_range", defaultValue: "\(day) \(start) 〜 \(end)", table: "Schedule", bundle: L10n.bundle)
        }
        /// マイ予定を読み込めませんでした — マイ予定の取り込みに失敗したときのアラートの見出し (説明は OS のエラー文)
        static var personalLoadErrorTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.load_error.title", defaultValue: "マイ予定を読み込めませんでした", table: "Schedule", bundle: L10n.bundle)
        }
        /// マイ予定を重ねて表示するには、設定アプリでカレンダーへの「フルアクセス」を許可してください。 — マイ予定をオンにしたが権限が無いときのアラートの説明。「フルアクセス」は iOS の設定の項目名
        static var personalPermissionMessage: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.permission.message", defaultValue: "マイ予定を重ねて表示するには、設定アプリでカレンダーへの「フルアクセス」を許可してください。", table: "Schedule", bundle: L10n.bundle)
        }
        /// カレンダーへのアクセスが必要です — マイ予定をオンにしたが権限が無いときのアラートの見出し
        static var personalPermissionTitle: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.permission.title", defaultValue: "カレンダーへのアクセスが必要です", table: "Schedule", bundle: L10n.bundle)
        }
        /// (タイトルなし) — タイトルの無いマイ予定の代わりの表示
        static var personalUntitled: LocalizedStringResource {
            LocalizedStringResource("schedule.personal.untitled", defaultValue: "(タイトルなし)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {label} (初日) — 記念日の行のタイトル。起点の年 (0 周年) の当日。label は記念日の名前 (データ) — 引数: label (string)
        static func rowAnniversaryFirstDay(label: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.anniversary.first_day", defaultValue: "\(label) (初日)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {year} 起点 — 記念日の行の副題。year は起点の年 (日付の先頭 4 文字をそのまま渡す) — 引数: year (string)
        static func rowAnniversarySince(year: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.anniversary.since", defaultValue: "\(year) 起点", table: "Schedule", bundle: L10n.bundle)
        }
        /// {years}周年 ・ {label} — 記念日の行のタイトル (例: 21周年 ・ アーケード版稼働)。years は何周年か、label は記念日の名前 (データ) — 引数: years (int), label (string)
        static func rowAnniversaryYears(years: Int, label: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.anniversary.years", defaultValue: "\(String(years))周年 ・ \(label)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {name} 誕生日 — 誕生日の行のタイトル。name はアイドル名 / 事務員名 (Android は事務員の行だけ) — 引数: name (string)
        static func rowBirthdayTitle(name: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.birthday.title", defaultValue: "\(name) 誕生日", table: "Schedule", bundle: L10n.bundle)
        }
        /// 終日 — マイ予定 (端末のカレンダーの予定) の行の時刻の欄。終日の予定
        static var rowPersonalAllDay: LocalizedStringResource {
            LocalizedStringResource("schedule.row.personal.all_day", defaultValue: "終日", table: "Schedule", bundle: L10n.bundle)
        }
        /// {time} ・ {calendar} — マイ予定の行の副題。time は時刻の欄 (終日 / 10:00 〜 12:00)、calendar は端末のカレンダーの名前 — 引数: time (string), calendar (string)
        static func rowPersonalSubtitle(time: String, calendar: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.personal.subtitle", defaultValue: "\(time) ・ \(calendar)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {start} 〜 {end} — マイ予定の行の時刻の欄。start / end は書式済みの時刻 — 引数: start (string), end (string)
        static func rowPersonalTimeRange(start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.personal.time_range", defaultValue: "\(start) 〜 \(end)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {count}曲リリース: {title} 他 — 同じ日に複数の曲がリリースされる日の行のタイトル。title は 1 曲目の曲名。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: count (count), title (string)
        static func rowReleaseMulti(count: Int, title: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.release.multi", defaultValue: "\(count)曲リリース: \(title) 他", table: "Schedule", bundle: L10n.bundle)
        }
        /// CDリリース — リリースの行の副題
        static var rowReleaseSubtitle: LocalizedStringResource {
            LocalizedStringResource("schedule.row.release.subtitle", defaultValue: "CDリリース", table: "Schedule", bundle: L10n.bundle)
        }
        ///  ・  — 予定の行の副題で、公演名・開始時刻・会場などを並べるときの区切り (前後の空白込み)
        static var rowSeparator: LocalizedStringResource {
            LocalizedStringResource("schedule.row.separator", defaultValue: " ・ ", table: "Schedule", bundle: L10n.bundle)
        }
        /// セトリ — 公演の行からセトリ (公演詳細) へ飛ぶ操作。iOS は行のスワイプボタン、Android はボタンの読み上げ
        static var rowSetlist: LocalizedStringResource {
            LocalizedStringResource("schedule.row.setlist", defaultValue: "セトリ", table: "Schedule", bundle: L10n.bundle)
        }
        /// チケット申込の締切 — チケットの申込締切の行の副題
        static var rowTicketDeadlineSubtitle: LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket.deadline_subtitle", defaultValue: "チケット申込の締切", table: "Schedule", bundle: L10n.bundle)
        }
        /// チケット当落発表 — チケットの当落発表の行の副題
        static var rowTicketLotterySubtitle: LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket.lottery_subtitle", defaultValue: "チケット当落発表", table: "Schedule", bundle: L10n.bundle)
        }
        /// {kind} ・ {event} — チケットの申込締切 / 当落発表の行のタイトル。kind はコアの語彙、event はライブ名 — 引数: kind (core), event (string)
        static func rowTicketTitle(kind: String, event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket.title", defaultValue: "\(kind) ・ \(event)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {start} 〜 {end} — チケットの受付期間 (受付開始 〜 申込締切)。start / end は 6/13 のような月日 — 引数: start (string), end (string)
        static func rowTicketPeriodRange(start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket_period.range", defaultValue: "\(start) 〜 \(end)", table: "Schedule", bundle: L10n.bundle)
        }
        /// チケット受付期間 — チケットの受付期間の行の副題 (日付が読めないとき)
        static var rowTicketPeriodSubtitle: LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket_period.subtitle", defaultValue: "チケット受付期間", table: "Schedule", bundle: L10n.bundle)
        }
        /// チケット受付  {range} — チケットの受付期間の行の副題。range は期間 (row.ticket_period.range) か片方の日付 (6/13)。語と期間の間は空白 2 つ — 引数: range (string)
        static func rowTicketPeriodSubtitleRange(range: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket_period.subtitle_range", defaultValue: "チケット受付  \(range)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {label} ・ {event} — チケットの受付期間の行のタイトル。label はコアの語彙 (受付期間)、event はライブ名 — 引数: label (core), event (string)
        static func rowTicketPeriodTitle(label: String, event: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.row.ticket_period.title", defaultValue: "\(label) ・ \(event)", table: "Schedule", bundle: L10n.bundle)
        }
        /// {date} ・ {count}件 — 月表示で選んだ日の小見出し。date は書式済みの日付 (例: 9月24日(木))、count はその日の予定の数。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: date (string), count (count)
        static func selectedDayHeader(date: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("schedule.selected_day.header", defaultValue: "\(date) ・ \(count)件", table: "Schedule", bundle: L10n.bundle)
        }
        /// {date} ・ 今日 ・ {count}件 — 月表示で選んだ日が今日のときの小見出し。date は書式済みの日付、count はその日の予定の数。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: date (string), count (count)
        static func selectedDayHeaderToday(date: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("schedule.selected_day.header_today", defaultValue: "\(date) ・ 今日 ・ \(count)件", table: "Schedule", bundle: L10n.bundle)
        }
        /// スケジュール — スケジュールタブ (カレンダー) の画面タイトル。iOS はナビゲーションタイトル、Android は TopAppBar
        static var title: LocalizedStringResource {
            LocalizedStringResource("schedule.title", defaultValue: "スケジュール", table: "Schedule", bundle: L10n.bundle)
        }
        /// 各ブランドの日替わりピックにタグを付けて投票します — 右上の「今日の1曲/今日のアイドル」ボタンの読み上げのヒント (VoiceOver)
        static var toolbarDailyPickA11yHint: LocalizedStringResource {
            LocalizedStringResource("schedule.toolbar.daily_pick.a11y_hint", defaultValue: "各ブランドの日替わりピックにタグを付けて投票します", table: "Schedule", bundle: L10n.bundle)
        }
        /// 終日 — 週表示の、時刻の無い予定を並べる段の左のラベル
        static var weekAllDay: LocalizedStringResource {
            LocalizedStringResource("schedule.week.all_day", defaultValue: "終日", table: "Schedule", bundle: L10n.bundle)
        }
        /// {start} 〜 {end} — 週表示の上の見出し (その週の最初の日と最後の日)。start / end は書式済みの月日 — 引数: start (string), end (string)
        static func weekRange(start: String, end: String) -> LocalizedStringResource {
            LocalizedStringResource("schedule.week.range", defaultValue: "\(start) 〜 \(end)", table: "Schedule", bundle: L10n.bundle)
        }
    }
}
