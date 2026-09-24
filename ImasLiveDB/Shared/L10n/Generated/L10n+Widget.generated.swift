// 生成物: i18n/catalog/widget.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/widget.json の文言 (表 Widget)
    enum Widget {
        /// あと{days}日 — 「次のライブ」ウィジェットのカウントダウン。days は初日までの日数。1000 以上は桁区切りが付く (実際には出ない値) — 引数: days (count)
        static func nextLiveDaysLeft(days: Int) -> LocalizedStringResource {
            LocalizedStringResource("widget.next_live.days_left", defaultValue: "あと\(days)日", table: "Widget", bundle: L10n.bundle)
        }
        /// 直近のライブまでのカウントダウンを表示します。 — iOS のウィジェット選択に出る説明 (configurationDisplayName の下)。Android の next_live.description と ja が違う (統一はオーナーが別 PR で)
        static var nextLiveDescriptionIos: LocalizedStringResource {
            LocalizedStringResource("widget.next_live.description_ios", defaultValue: "直近のライブまでのカウントダウンを表示します。", table: "Widget", bundle: L10n.bundle)
        }
        /// 次のライブ情報なし — 「次のライブ」ウィジェット。予定しているライブが無いとき
        static var nextLiveEmpty: LocalizedStringResource {
            LocalizedStringResource("widget.next_live.empty", defaultValue: "次のライブ情報なし", table: "Widget", bundle: L10n.bundle)
        }
        /// 次のライブ — 「次のライブ」ウィジェットの左上の小さな見出し
        static var nextLiveHeader: LocalizedStringResource {
            LocalizedStringResource("widget.next_live.header", defaultValue: "次のライブ", table: "Widget", bundle: L10n.bundle)
        }
        /// 次のライブ — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)
        static var nextLiveName: LocalizedStringResource {
            LocalizedStringResource("widget.next_live.name", defaultValue: "次のライブ", table: "Widget", bundle: L10n.bundle)
        }
        /// 今日！ — 「次のライブ」ウィジェットのカウントダウン (当日)
        static var nextLiveToday: LocalizedStringResource {
            LocalizedStringResource("widget.next_live.today", defaultValue: "今日！", table: "Widget", bundle: L10n.bundle)
        }
        /// アプリで画像を追加 — 担当画像ウィジェット。画像を取り込んだアイドルがまだいない (出せる画像が無い) ときの案内
        static var oshiPlaceholderAddImage: LocalizedStringResource {
            LocalizedStringResource("widget.oshi.placeholder.add_image", defaultValue: "アプリで画像を追加", table: "Widget", bundle: L10n.bundle)
        }
        /// 担当を選択 — 担当画像ウィジェット。表示するアイドルは決まっているが画像を出せないときの案内 (ウィジェットの編集で担当を選び直す)
        static var oshiPlaceholderSelect: LocalizedStringResource {
            LocalizedStringResource("widget.oshi.placeholder.select", defaultValue: "担当を選択", table: "Widget", bundle: L10n.bundle)
        }
        /// 選んだアイドルの画像を表示。タップで次の画像に切り替わります。 — iOS のウィジェット選択に出る説明 (タップで次の画像へ送る版)。Android の oshi_image.description と ja が違う (統一はオーナーが別 PR で)
        static var oshiImageDescriptionIos: LocalizedStringResource {
            LocalizedStringResource("widget.oshi_image.description_ios", defaultValue: "選んだアイドルの画像を表示。タップで次の画像に切り替わります。", table: "Widget", bundle: L10n.bundle)
        }
        /// 担当の画像（タップで切替） — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)。タップで次の画像へ送る版
        static var oshiImageName: LocalizedStringResource {
            LocalizedStringResource("widget.oshi_image.name", defaultValue: "担当の画像（タップで切替）", table: "Widget", bundle: L10n.bundle)
        }
        /// 選んだアイドルの画像を表示。タップでアプリを開きます。 — iOS のウィジェット選択に出る説明 (タップでアプリを開く版)。Android の oshi_launcher.description と ja が違う (統一はオーナーが別 PR で)
        static var oshiLauncherDescriptionIos: LocalizedStringResource {
            LocalizedStringResource("widget.oshi_launcher.description_ios", defaultValue: "選んだアイドルの画像を表示。タップでアプリを開きます。", table: "Widget", bundle: L10n.bundle)
        }
        /// 担当の画像（タップでアプリ） — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)。タップでアプリを開く版 (絵は oshi_image と同じ)
        static var oshiLauncherName: LocalizedStringResource {
            LocalizedStringResource("widget.oshi_launcher.name", defaultValue: "担当の画像（タップでアプリ）", table: "Widget", bundle: L10n.bundle)
        }
        /// チケット締切が近いイベントを最大3件表示します。 — iOS のウィジェット選択に出る説明。Android の ticket_deadline.description と ja が違う (統一はオーナーが別 PR で)
        static var ticketDeadlineDescriptionIos: LocalizedStringResource {
            LocalizedStringResource("widget.ticket_deadline.description_ios", defaultValue: "チケット締切が近いイベントを最大3件表示します。", table: "Widget", bundle: L10n.bundle)
        }
        /// 締切近いチケットなし — 「チケット締切」ウィジェット。締切が近い先行受付が無いとき
        static var ticketDeadlineEmpty: LocalizedStringResource {
            LocalizedStringResource("widget.ticket_deadline.empty", defaultValue: "締切近いチケットなし", table: "Widget", bundle: L10n.bundle)
        }
        /// チケット締切 — 「チケット締切」ウィジェットの小さな見出し
        static var ticketDeadlineHeader: LocalizedStringResource {
            LocalizedStringResource("widget.ticket_deadline.header", defaultValue: "チケット締切", table: "Widget", bundle: L10n.bundle)
        }
        /// チケット締切 — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)
        static var ticketDeadlineName: LocalizedStringResource {
            LocalizedStringResource("widget.ticket_deadline.name", defaultValue: "チケット締切", table: "Widget", bundle: L10n.bundle)
        }
        /// 日替わりで1曲をピックして表示します。 — iOS のウィジェット選択に出る説明。Android の today_song.description と ja が違う (統一はオーナーが別 PR で)
        static var todaySongDescriptionIos: LocalizedStringResource {
            LocalizedStringResource("widget.today_song.description_ios", defaultValue: "日替わりで1曲をピックして表示します。", table: "Widget", bundle: L10n.bundle)
        }
        /// 今日の1曲を準備中 — 「今日の1曲」ウィジェット。今日の曲のデータがまだ無いとき
        static var todaySongEmpty: LocalizedStringResource {
            LocalizedStringResource("widget.today_song.empty", defaultValue: "今日の1曲を準備中", table: "Widget", bundle: L10n.bundle)
        }
        /// 今日の1曲 — 「今日の1曲」ウィジェットの小さな見出し
        static var todaySongHeader: LocalizedStringResource {
            LocalizedStringResource("widget.today_song.header", defaultValue: "今日の1曲", table: "Widget", bundle: L10n.bundle)
        }
        /// 今日の1曲 — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)
        static var todaySongName: LocalizedStringResource {
            LocalizedStringResource("widget.today_song.name", defaultValue: "今日の1曲", table: "Widget", bundle: L10n.bundle)
        }
    }
}
