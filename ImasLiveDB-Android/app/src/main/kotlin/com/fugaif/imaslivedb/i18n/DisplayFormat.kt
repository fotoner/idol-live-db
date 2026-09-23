package com.fugaif.imaslivedb.i18n

import android.text.format.DateFormat
import java.time.DayOfWeek
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.util.Locale

/**
 * 日付・曜日の表示書式 (iOS `DisplayFormat` と対)。カタログには入れず、ここで作った文字列を
 * string 引数として文言に渡す。ロケールは [DisplayLocale.formattingLocale] を渡す
 * (端末の言語ではなく、実際に画面に出ている言語で書く)。
 *
 * java.time は ISO 暦なので、暦の固定は要らない。
 */
object DisplayFormat {
    /** 年と月 (ja: 2026年9月 / ko: 2026년 9월)。並びと区切りはロケールの定型に任せる。 */
    fun yearMonth(date: LocalDate, locale: Locale): String =
        DateTimeFormatter.ofPattern(DateFormat.getBestDateTimePattern(locale, "yMMM"), locale).format(date)

    /** 曜日の一文字表記 (ja: 月 / ko: 월)。カレンダーの曜日見出しに使う。 */
    fun weekdayNarrow(day: DayOfWeek, locale: Locale): String = day.getDisplayName(TextStyle.NARROW, locale)
}
