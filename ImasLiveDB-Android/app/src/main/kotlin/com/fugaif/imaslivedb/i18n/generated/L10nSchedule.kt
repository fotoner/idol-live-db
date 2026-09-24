// 生成物: i18n/catalog/schedule.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/schedule.json の文言。L10n.Schedule から引く (iOS の L10n.Schedule と同じ名前)。 */
object L10nSchedule {
    /** 受付 {event} — チケットの受付期間を表す横帯のラベル。event はライブ名 — 引数: event (string) */
    fun bandTicketPeriod(event: String): DisplayText = DisplayText.Res(R.string.schedule_band_ticket_period, listOf(event))
    /** リリース — 月のセル・週の段の色帯。リリースの曲名が引けなかったときの代わりの文字 */
    val barReleaseFallback: DisplayText get() = DisplayText.Res(R.string.schedule_bar_release_fallback)
    /** {kind}・{event} — 月のセル・週の段の色帯 (チケットの申込締切 / 当落発表)。kind はコアの語彙 (申込締切 など)、event はライブ名 — 引数: kind (core), event (string) */
    fun barTicket(kind: String, event: String): DisplayText = DisplayText.Res(R.string.schedule_bar_ticket, listOf(kind, event))
    /** 受付・{event} — 週の時間グリッドのブロック (チケットの受付期間)。event はライブ名 — 引数: event (string) */
    fun barTicketPeriod(event: String): DisplayText = DisplayText.Res(R.string.schedule_bar_ticket_period, listOf(event))
    /** この日はライブ・リリース・誕生日の記録がありません — 選んだ日・日の詳細シートで、予定が 1 件も無いときの説明 */
    val dayEmptyMessage: DisplayText get() = DisplayText.Res(R.string.schedule_day_empty_message)
    /** {year}年{month}月{day}日 — 日の詳細シートの見出しの日付 (Android) — 引数: year (int), month (int), day (int) */
    fun daySheetDate(year: Int, month: Int, day: Int): DisplayText = DisplayText.Res(R.string.schedule_day_sheet_date, listOf(year, month, day))
    /** {count}件のイベント — 日の詳細シートの見出しの下の件数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun daySheetEventCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.schedule_day_sheet_event_count, count, listOf(count))
    /** カレンダーに追加 — 公演を端末のカレンダーに追加する操作。iOS は確認シートのタイトル、Android はボタンの読み上げ */
    val exportAction: DisplayText get() = DisplayText.Res(R.string.schedule_export_action)
    /** 記念日 — 上のカテゴリチップ。ブランドの記念日 (サービス開始など) の表示を切り替える */
    val filterAnniversaries: DisplayText get() = DisplayText.Res(R.string.schedule_filter_anniversaries)
    /** 誕生日 — 上のカテゴリチップ。アイドルの誕生日の表示を切り替える */
    val filterBirthdays: DisplayText get() = DisplayText.Res(R.string.schedule_filter_birthdays)
    /** リリース — 上のカテゴリチップ。CD・配信のリリース日の表示を切り替える */
    val filterReleases: DisplayText get() = DisplayText.Res(R.string.schedule_filter_releases)
    /** 公演 — 上のカテゴリチップ。公演 (ライブの各日) の表示を切り替える */
    val filterShows: DisplayText get() = DisplayText.Res(R.string.schedule_filter_shows)
    /** 事務員 — 上のカテゴリチップ。事務員 (音無小鳥・千川ちひろなど、アイドルでない関係者) の誕生日の表示を切り替える */
    val filterStaff: DisplayText get() = DisplayText.Res(R.string.schedule_filter_staff)
    /** チケット — 上のカテゴリチップ。チケットの受付期間・締切・当落発表の表示を切り替える */
    val filterTickets: DisplayText get() = DisplayText.Res(R.string.schedule_filter_tickets)
    /** 月 — 月表示と週表示の切り替え (セグメント) の「月」 */
    val modeMonth: DisplayText get() = DisplayText.Res(R.string.schedule_mode_month)
    /** 週 — 月表示と週表示の切り替え (セグメント) の「週」 */
    val modeWeek: DisplayText get() = DisplayText.Res(R.string.schedule_mode_week)
    /** 次の月 — 月見出しの右の > ボタンの読み上げ */
    val monthNextA11y: DisplayText get() = DisplayText.Res(R.string.schedule_month_next_a11y)
    /** 前の月 — 月見出しの左の < ボタンの読み上げ */
    val monthPrevA11y: DisplayText get() = DisplayText.Res(R.string.schedule_month_prev_a11y)
    /** {year}年 {month}月 — 月表示のグリッドの上の見出し。年と月の間に空白がある (今の表示のまま) — 引数: year (int), month (int) */
    fun monthTitle(year: Int, month: Int): DisplayText = DisplayText.Res(R.string.schedule_month_title, listOf(year, month))
    /** {label} (初日) — 記念日の行のタイトル。起点の年 (0 周年) の当日。label は記念日の名前 (データ) — 引数: label (string) */
    fun rowAnniversaryFirstDay(label: String): DisplayText = DisplayText.Res(R.string.schedule_row_anniversary_first_day, listOf(label))
    /** {year} 起点 — 記念日の行の副題。year は起点の年 (日付の先頭 4 文字をそのまま渡す) — 引数: year (string) */
    fun rowAnniversarySince(year: String): DisplayText = DisplayText.Res(R.string.schedule_row_anniversary_since, listOf(year))
    /** {years}周年 ・ {label} — 記念日の行のタイトル (例: 21周年 ・ アーケード版稼働)。years は何周年か、label は記念日の名前 (データ) — 引数: years (int), label (string) */
    fun rowAnniversaryYears(years: Int, label: String): DisplayText = DisplayText.Res(R.string.schedule_row_anniversary_years, listOf(years, label))
    /** 誕生日 — アイドルの誕生日の行の、名前の上の種別ラベル (Android) */
    val rowBirthdayLabel: DisplayText get() = DisplayText.Res(R.string.schedule_row_birthday_label)
    /** {name} 誕生日 — 誕生日の行のタイトル。name はアイドル名 / 事務員名 (Android は事務員の行だけ) — 引数: name (string) */
    fun rowBirthdayTitle(name: String): DisplayText = DisplayText.Res(R.string.schedule_row_birthday_title, listOf(name))
    /** リリース — リリースの行の、曲名の上の種別ラベル (Android) */
    val rowReleaseLabel: DisplayText get() = DisplayText.Res(R.string.schedule_row_release_label)
    /**  ・  — 予定の行の副題で、公演名・開始時刻・会場などを並べるときの区切り (前後の空白込み) */
    val rowSeparator: DisplayText get() = DisplayText.Res(R.string.schedule_row_separator)
    /** セトリ — 公演の行からセトリ (公演詳細) へ飛ぶ操作。iOS は行のスワイプボタン、Android はボタンの読み上げ */
    val rowSetlist: DisplayText get() = DisplayText.Res(R.string.schedule_row_setlist)
    /** チケット申込の締切 — チケットの申込締切の行の副題 */
    val rowTicketDeadlineSubtitle: DisplayText get() = DisplayText.Res(R.string.schedule_row_ticket_deadline_subtitle)
    /** チケット当落発表 — チケットの当落発表の行の副題 */
    val rowTicketLotterySubtitle: DisplayText get() = DisplayText.Res(R.string.schedule_row_ticket_lottery_subtitle)
    /** {kind} ・ {event} — チケットの申込締切 / 当落発表の行のタイトル。kind はコアの語彙、event はライブ名 — 引数: kind (core), event (string) */
    fun rowTicketTitle(kind: String, event: String): DisplayText = DisplayText.Res(R.string.schedule_row_ticket_title, listOf(kind, event))
    /** {start} 〜 {end} — チケットの受付期間 (受付開始 〜 申込締切)。start / end は 6/13 のような月日 — 引数: start (string), end (string) */
    fun rowTicketPeriodRange(start: String, end: String): DisplayText = DisplayText.Res(R.string.schedule_row_ticket_period_range, listOf(start, end))
    /** チケット受付期間 — チケットの受付期間の行の副題 (日付が読めないとき) */
    val rowTicketPeriodSubtitle: DisplayText get() = DisplayText.Res(R.string.schedule_row_ticket_period_subtitle)
    /** チケット受付  {range} — チケットの受付期間の行の副題。range は期間 (row.ticket_period.range) か片方の日付 (6/13)。語と期間の間は空白 2 つ — 引数: range (string) */
    fun rowTicketPeriodSubtitleRange(range: String): DisplayText = DisplayText.Res(R.string.schedule_row_ticket_period_subtitle_range, listOf(range))
    /** {label} ・ {event} — チケットの受付期間の行のタイトル。label はコアの語彙 (受付期間)、event はライブ名 — 引数: label (core), event (string) */
    fun rowTicketPeriodTitle(label: String, event: String): DisplayText = DisplayText.Res(R.string.schedule_row_ticket_period_title, listOf(label, event))
    /** {count} 件 — 月表示で選んだ日の小見出しの右の件数 (Android)。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった (count 型の規則に合わせた)。 — 引数: count (count) */
    fun selectedDayCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.schedule_selected_day_count, count, listOf(count))
    /** {month}月{day}日 — 月表示で選んだ日の小見出し (Android) — 引数: month (int), day (int) */
    fun selectedDayDate(month: Int, day: Int): DisplayText = DisplayText.Res(R.string.schedule_selected_day_date, listOf(month, day))
    /** この日の詳細 — 選んだ日の小見出しの右の > (日の詳細シートを開く) の読み上げ */
    val selectedDayDetailA11y: DisplayText get() = DisplayText.Res(R.string.schedule_selected_day_detail_a11y)
    /** この日の記録はありません — 選んだ日に予定が 1 件も無いときの案内 (Android の月表示) */
    val selectedDayEmpty: DisplayText get() = DisplayText.Res(R.string.schedule_selected_day_empty)
    /** スケジュール — スケジュールタブ (カレンダー) の画面タイトル。iOS はナビゲーションタイトル、Android は TopAppBar */
    val title: DisplayText get() = DisplayText.Res(R.string.schedule_title)
    /** 終日 — 週表示の、時刻の無い予定を並べる段の左のラベル */
    val weekAllDay: DisplayText get() = DisplayText.Res(R.string.schedule_week_all_day)
    /** 次の週 — 週見出しの右の > ボタンの読み上げ */
    val weekNextA11y: DisplayText get() = DisplayText.Res(R.string.schedule_week_next_a11y)
    /** 前の週 — 週見出しの左の < ボタンの読み上げ */
    val weekPrevA11y: DisplayText get() = DisplayText.Res(R.string.schedule_week_prev_a11y)
    /** {start} 〜 {end} — 週表示の上の見出し (その週の最初の日と最後の日)。start / end は書式済みの月日 — 引数: start (string), end (string) */
    fun weekRange(start: String, end: String): DisplayText = DisplayText.Res(R.string.schedule_week_range, listOf(start, end))
}
