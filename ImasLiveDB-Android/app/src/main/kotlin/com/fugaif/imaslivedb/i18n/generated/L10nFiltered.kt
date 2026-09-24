// 生成物: i18n/catalog/filtered.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/filtered.json の文言。L10n.Filtered から引く (iOS の L10n.Filtered と同じ名前)。 */
object L10nFiltered {
    /** {count}件 — 絞り込んだライブ一覧の先頭の件数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun eventsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.filtered_events_count, count, listOf(count))
    /** ライブが見つかりません — 絞り込んだライブが 1 件も無いとき */
    val eventsEmpty: DisplayText get() = DisplayText.Res(R.string.filtered_events_empty)
    /** {brand}のライブ — 絞り込んだライブ一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string) */
    fun eventsTitleBrand(brand: String): DisplayText = DisplayText.Res(R.string.filtered_events_title_brand, listOf(brand))
    /** {year}年のライブ — 絞り込んだライブ一覧のタイトル (開催年で) — 引数: year (int) */
    fun eventsTitleYear(year: Int): DisplayText = DisplayText.Res(R.string.filtered_events_title_year, listOf(year))
    /** {count}人 — 絞り込んだアイドル一覧の先頭の人数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun idolsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.filtered_idols_count, count, listOf(count))
    /** アイドルが見つかりません — 絞り込んだアイドルが 1 人もいないとき */
    val idolsEmpty: DisplayText get() = DisplayText.Res(R.string.filtered_idols_empty)
    /** {place}出身のアイドル — 絞り込んだアイドル一覧のタイトル (出身地で)。place はデータの地名 — 引数: place (string) */
    fun idolsTitleBirthPlace(place: String): DisplayText = DisplayText.Res(R.string.filtered_idols_title_birth_place, listOf(place))
    /** {blood_type}型のアイドル — 絞り込んだアイドル一覧のタイトル (血液型で)。blood_type は A / B / O / AB — 引数: blood_type (string) */
    fun idolsTitleBloodType(bloodType: String): DisplayText = DisplayText.Res(R.string.filtered_idols_title_blood_type, listOf(bloodType))
    /** {brand}のアイドル — 絞り込んだアイドル一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string) */
    fun idolsTitleBrand(brand: String): DisplayText = DisplayText.Res(R.string.filtered_idols_title_brand, listOf(brand))
    /** {constellation}のアイドル — 絞り込んだアイドル一覧のタイトル (星座で)。constellation はデータの星座名 (おひつじ座 など。訳さない) — 引数: constellation (string) */
    fun idolsTitleConstellation(constellation: String): DisplayText = DisplayText.Res(R.string.filtered_idols_title_constellation, listOf(constellation))
    /** お気に入り — ライブの行の右の ☆ (お気に入り) ボタンの読み上げ */
    val rowFavoriteA11y: DisplayText get() = DisplayText.Res(R.string.filtered_row_favorite_a11y)
    /** {count}公演 — 絞り込んだ公演一覧の先頭の公演数 (Android)。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった (count 型の規則に合わせた)。 — 引数: count (count) */
    fun showsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.filtered_shows_count, count, listOf(count))
    /** 公演が見つかりません — 絞り込んだ公演が 1 件も無いとき */
    val showsEmpty: DisplayText get() = DisplayText.Res(R.string.filtered_shows_empty)
    /**  ・  — 公演の行の副題で、月日・公演名・会場を並べるときの区切り (前後の空白込み。Android) */
    val showsRowSeparator: DisplayText get() = DisplayText.Res(R.string.filtered_shows_row_separator)
    /** {date}の公演 — 日付で絞り込んだ公演一覧のタイトル。date は YYYY-MM-DD の文字列 — 引数: date (string) */
    fun showsTitleDate(date: String): DisplayText = DisplayText.Res(R.string.filtered_shows_title_date, listOf(date))
    /** {venue}での公演 — 会場で絞り込んだ公演一覧のタイトル。venue は会場名 (引けなければ会場 ID) — 引数: venue (string) */
    fun showsTitleVenue(venue: String): DisplayText = DisplayText.Res(R.string.filtered_shows_title_venue, listOf(venue))
    /** {count}曲 — 絞り込んだ楽曲一覧の先頭の曲数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count) */
    fun songsCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.filtered_songs_count, count, listOf(count))
    /** 楽曲が見つかりません — 絞り込んだ楽曲が 1 曲も無いとき */
    val songsEmpty: DisplayText get() = DisplayText.Res(R.string.filtered_songs_empty)
    /** {brand}の楽曲 — 絞り込んだ楽曲一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string) */
    fun songsTitleBrand(brand: String): DisplayText = DisplayText.Res(R.string.filtered_songs_title_brand, listOf(brand))
    /** {name}が関わった楽曲 — 絞り込んだ楽曲一覧のタイトル (作詞・作曲・編曲のクレジットで)。name はクリエイター名 (データ) — 引数: name (string) */
    fun songsTitleCreator(name: String): DisplayText = DisplayText.Res(R.string.filtered_songs_title_creator, listOf(name))
    /** {year}年リリースの楽曲 — 絞り込んだ楽曲一覧のタイトル (リリース年で)。year は経路に載った YYYY の文字列をそのまま渡す — 引数: year (string) */
    fun songsTitleReleaseYear(year: String): DisplayText = DisplayText.Res(R.string.filtered_songs_title_release_year, listOf(year))
    /** {song_type}の楽曲 — 絞り込んだ楽曲一覧のタイトル (曲の種類で)。song_type は曲の種類。Android は imas-core の Vocab の表示名 (shortLabel)、iOS は DB の生の値をそのまま渡す — 引数: song_type (core) */
    fun songsTitleSongType(songType: String): DisplayText = DisplayText.Res(R.string.filtered_songs_title_song_type, listOf(songType))
}
