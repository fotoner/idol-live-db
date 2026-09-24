// 生成物: i18n/catalog/widget.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/widget.json の文言。L10n.Widget から引く (iOS の L10n.Widget と同じ名前)。 */
object L10nWidget {
    /** ウィジェットに出すアイドルを選びます。画像を取り込んであるアイドルが並びます。 — 担当画像ウィジェットの設定画面の見出しの下の説明 */
    val configureDescription: DisplayText get() = DisplayText.Res(R.string.widget_configure_description)
    /** 表示できるアイドルがいません。\nアプリのアイドル詳細から画像を取り込むと、ここに並びます。 — 担当画像ウィジェットの設定画面。画像を取り込んだアイドルが 1 人もいないとき (2 行) */
    val configureEmpty: DisplayText get() = DisplayText.Res(R.string.widget_configure_empty)
    /** 名前・ブランドで絞り込む — 担当画像ウィジェットの設定画面の絞り込み欄のプレースホルダ */
    val configureSearchPrompt: DisplayText get() = DisplayText.Res(R.string.widget_configure_search_prompt)
    /** 選択中 — 担当画像ウィジェットの設定画面。今選ばれているアイドルの行のチェックの読み上げ */
    val configureSelectedA11y: DisplayText get() = DisplayText.Res(R.string.widget_configure_selected_a11y)
    /** あと{days}日 — 「次のライブ」ウィジェットのカウントダウン。days は初日までの日数。1000 以上は桁区切りが付く (実際には出ない値) — 引数: days (count) */
    fun nextLiveDaysLeft(days: Int): DisplayText = DisplayText.Plural(R.plurals.widget_next_live_days_left, days, listOf(days))
    /** 次のライブまでの日数を表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明は ja が違うので別のキー (next_live.description_ios) */
    val nextLiveDescription: DisplayText get() = DisplayText.Res(R.string.widget_next_live_description)
    /** 次のライブ情報なし — 「次のライブ」ウィジェット。予定しているライブが無いとき */
    val nextLiveEmpty: DisplayText get() = DisplayText.Res(R.string.widget_next_live_empty)
    /** 次のライブ — 「次のライブ」ウィジェットの左上の小さな見出し */
    val nextLiveHeader: DisplayText get() = DisplayText.Res(R.string.widget_next_live_header)
    /** 次のライブ — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label) */
    val nextLiveName: DisplayText get() = DisplayText.Res(R.string.widget_next_live_name)
    /** 今日 — Android の文言。iOS の next_live.today と ja が違う (！の有無。統一はオーナーが別 PR で)。「次のライブ」ウィジェットのカウントダウン (当日) */
    val nextLiveTodayAndroid: DisplayText get() = DisplayText.Res(R.string.widget_next_live_today_android)
    /** アプリで画像を追加 — 担当画像ウィジェット。画像を取り込んだアイドルがまだいない (出せる画像が無い) ときの案内 */
    val oshiPlaceholderAddImage: DisplayText get() = DisplayText.Res(R.string.widget_oshi_placeholder_add_image)
    /** アイドル詳細から取り込めます — 担当画像ウィジェットの「アプリで画像を追加」の下の補足 */
    val oshiPlaceholderAddImageHint: DisplayText get() = DisplayText.Res(R.string.widget_oshi_placeholder_add_image_hint)
    /** 担当アイドルの取り込んだ画像をホーム画面に出します。タップで次の画像に切り替わります。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明は ja が違うので別のキー (oshi_image.description_ios) */
    val oshiImageDescription: DisplayText get() = DisplayText.Res(R.string.widget_oshi_image_description)
    /** 担当の画像（タップで切替） — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)。タップで次の画像へ送る版 */
    val oshiImageName: DisplayText get() = DisplayText.Res(R.string.widget_oshi_image_name)
    /** 担当アイドルの取り込んだ画像をホーム画面に出します。タップするとアプリが開きます。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明は ja が違うので別のキー (oshi_launcher.description_ios) */
    val oshiLauncherDescription: DisplayText get() = DisplayText.Res(R.string.widget_oshi_launcher_description)
    /** 担当の画像（タップでアプリ） — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label)。タップでアプリを開く版 (絵は oshi_image と同じ) */
    val oshiLauncherName: DisplayText get() = DisplayText.Res(R.string.widget_oshi_launcher_name)
    /** 担当を選ぶ — 担当画像ウィジェットの設定の名前。iOS はウィジェットの編集で出る AppIntent (SelectOshiIntent) の名前、Android は設定 Activity の android:label と画面の見出し */
    val selectOshiTitle: DisplayText get() = DisplayText.Res(R.string.widget_select_oshi_title)
    /** 締切が近いチケットの先行受付を表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明は ja が違うので別のキー (ticket_deadline.description_ios) */
    val ticketDeadlineDescription: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_description)
    /** 締切近いチケットなし — 「チケット締切」ウィジェット。締切が近い先行受付が無いとき */
    val ticketDeadlineEmpty: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_empty)
    /** チケット締切 — 「チケット締切」ウィジェットの小さな見出し */
    val ticketDeadlineHeader: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_header)
    /** チケット締切 — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label) */
    val ticketDeadlineName: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_name)
    /** 日替わりで1曲をジャケット付きで表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明は ja が違うので別のキー (today_song.description_ios) */
    val todaySongDescription: DisplayText get() = DisplayText.Res(R.string.widget_today_song_description)
    /** 今日の1曲を準備中 — 「今日の1曲」ウィジェット。今日の曲のデータがまだ無いとき */
    val todaySongEmpty: DisplayText get() = DisplayText.Res(R.string.widget_today_song_empty)
    /** データの取得が終わると出ます — 「今日の1曲」ウィジェットの準備中の下の補足 */
    val todaySongEmptyHint: DisplayText get() = DisplayText.Res(R.string.widget_today_song_empty_hint)
    /** 今日の1曲 — 「今日の1曲」ウィジェットの小さな見出し */
    val todaySongHeader: DisplayText get() = DisplayText.Res(R.string.widget_today_song_header)
    /** 今日の1曲 — ホーム画面のウィジェット選択に出る名前 (iOS の configurationDisplayName / Android の receiver の android:label) */
    val todaySongName: DisplayText get() = DisplayText.Res(R.string.widget_today_song_name)
}
