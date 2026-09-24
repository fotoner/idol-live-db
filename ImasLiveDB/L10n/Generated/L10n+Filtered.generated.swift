// 生成物: i18n/catalog/filtered.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/filtered.json の文言 (表 Filtered)
    enum Filtered {
        /// {count}件 — 絞り込んだライブ一覧の先頭の件数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func eventsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("filtered.events.count", defaultValue: "\(count)件", table: "Filtered", bundle: L10n.bundle)
        }
        /// ライブが見つかりません — 絞り込んだライブが 1 件も無いとき
        static var eventsEmpty: LocalizedStringResource {
            LocalizedStringResource("filtered.events.empty", defaultValue: "ライブが見つかりません", table: "Filtered", bundle: L10n.bundle)
        }
        /// {brand}のライブ — 絞り込んだライブ一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string)
        static func eventsTitleBrand(brand: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.events.title.brand", defaultValue: "\(brand)のライブ", table: "Filtered", bundle: L10n.bundle)
        }
        /// {year}年のライブ — 絞り込んだライブ一覧のタイトル (開催年で) — 引数: year (int)
        static func eventsTitleYear(year: Int) -> LocalizedStringResource {
            LocalizedStringResource("filtered.events.title.year", defaultValue: "\(String(year))年のライブ", table: "Filtered", bundle: L10n.bundle)
        }
        /// {count}人 — 絞り込んだアイドル一覧の先頭の人数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func idolsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.count", defaultValue: "\(count)人", table: "Filtered", bundle: L10n.bundle)
        }
        /// アイドルが見つかりません — 絞り込んだアイドルが 1 人もいないとき
        static var idolsEmpty: LocalizedStringResource {
            LocalizedStringResource("filtered.idols.empty", defaultValue: "アイドルが見つかりません", table: "Filtered", bundle: L10n.bundle)
        }
        /// {month}月生まれのアイドル — 絞り込んだアイドル一覧のタイトル (誕生月で。Android は別の画面) — 引数: month (int)
        static func idolsTitleBirthMonth(month: Int) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.title.birth_month", defaultValue: "\(String(month))月生まれのアイドル", table: "Filtered", bundle: L10n.bundle)
        }
        /// {place}出身のアイドル — 絞り込んだアイドル一覧のタイトル (出身地で)。place はデータの地名 — 引数: place (string)
        static func idolsTitleBirthPlace(place: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.title.birth_place", defaultValue: "\(place)出身のアイドル", table: "Filtered", bundle: L10n.bundle)
        }
        /// {blood_type}型のアイドル — 絞り込んだアイドル一覧のタイトル (血液型で)。blood_type は A / B / O / AB — 引数: blood_type (string)
        static func idolsTitleBloodType(bloodType: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.title.blood_type", defaultValue: "\(bloodType)型のアイドル", table: "Filtered", bundle: L10n.bundle)
        }
        /// {brand}のアイドル — 絞り込んだアイドル一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string)
        static func idolsTitleBrand(brand: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.title.brand", defaultValue: "\(brand)のアイドル", table: "Filtered", bundle: L10n.bundle)
        }
        /// {constellation}のアイドル — 絞り込んだアイドル一覧のタイトル (星座で)。constellation はデータの星座名 (おひつじ座 など。訳さない) — 引数: constellation (string)
        static func idolsTitleConstellation(constellation: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.idols.title.constellation", defaultValue: "\(constellation)のアイドル", table: "Filtered", bundle: L10n.bundle)
        }
        /// ライブ名をコピー — 公演の行の長押しメニュー
        static var showsCopyEventName: LocalizedStringResource {
            LocalizedStringResource("filtered.shows.copy.event_name", defaultValue: "ライブ名をコピー", table: "Filtered", bundle: L10n.bundle)
        }
        /// 公演名をコピー — 公演の行の長押しメニュー
        static var showsCopyShowName: LocalizedStringResource {
            LocalizedStringResource("filtered.shows.copy.show_name", defaultValue: "公演名をコピー", table: "Filtered", bundle: L10n.bundle)
        }
        /// 公演が見つかりません — 絞り込んだ公演が 1 件も無いとき
        static var showsEmpty: LocalizedStringResource {
            LocalizedStringResource("filtered.shows.empty", defaultValue: "公演が見つかりません", table: "Filtered", bundle: L10n.bundle)
        }
        /// {date}の公演 — 日付で絞り込んだ公演一覧のタイトル。date は YYYY-MM-DD の文字列 — 引数: date (string)
        static func showsTitleDate(date: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.shows.title.date", defaultValue: "\(date)の公演", table: "Filtered", bundle: L10n.bundle)
        }
        /// {venue}での公演 — 会場で絞り込んだ公演一覧のタイトル。venue は会場名 (引けなければ会場 ID) — 引数: venue (string)
        static func showsTitleVenue(venue: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.shows.title.venue", defaultValue: "\(venue)での公演", table: "Filtered", bundle: L10n.bundle)
        }
        /// {count}曲 — 絞り込んだ楽曲一覧の先頭の曲数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func songsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("filtered.songs.count", defaultValue: "\(count)曲", table: "Filtered", bundle: L10n.bundle)
        }
        /// 楽曲が見つかりません — 絞り込んだ楽曲が 1 曲も無いとき
        static var songsEmpty: LocalizedStringResource {
            LocalizedStringResource("filtered.songs.empty", defaultValue: "楽曲が見つかりません", table: "Filtered", bundle: L10n.bundle)
        }
        /// {brand}の楽曲 — 絞り込んだ楽曲一覧のタイトル (ブランドで)。brand はブランドの略称 (データ) — 引数: brand (string)
        static func songsTitleBrand(brand: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.songs.title.brand", defaultValue: "\(brand)の楽曲", table: "Filtered", bundle: L10n.bundle)
        }
        /// {name}が関わった楽曲 — 絞り込んだ楽曲一覧のタイトル (作詞・作曲・編曲のクレジットで)。name はクリエイター名 (データ) — 引数: name (string)
        static func songsTitleCreator(name: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.songs.title.creator", defaultValue: "\(name)が関わった楽曲", table: "Filtered", bundle: L10n.bundle)
        }
        /// {year}年リリースの楽曲 — 絞り込んだ楽曲一覧のタイトル (リリース年で)。year は経路に載った YYYY の文字列をそのまま渡す — 引数: year (string)
        static func songsTitleReleaseYear(year: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.songs.title.release_year", defaultValue: "\(year)年リリースの楽曲", table: "Filtered", bundle: L10n.bundle)
        }
        /// {song_type}の楽曲 — 絞り込んだ楽曲一覧のタイトル (曲の種類で)。song_type は曲の種類。Android は imas-core の Vocab の表示名 (shortLabel)、iOS は DB の生の値をそのまま渡す — 引数: song_type (core)
        static func songsTitleSongType(songType: String) -> LocalizedStringResource {
            LocalizedStringResource("filtered.songs.title.song_type", defaultValue: "\(songType)の楽曲", table: "Filtered", bundle: L10n.bundle)
        }
    }
}
