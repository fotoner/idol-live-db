// 生成物: i18n/catalog/widget.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/widget.json の文言。L10n.Widget から引く (iOS の L10n.Widget と同じ名前)。 */
object L10nWidget {
    /** 次のライブまでの日数を表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description)。iOS の説明 (InfoWidgets.swift) とは ja が違うので iOS を移すときは別のキーにする */
    val nextLiveDescription: DisplayText get() = DisplayText.Res(R.string.widget_next_live_description)
    /** 次のライブ — ホーム画面のウィジェット選択に出る名前 (Android の receiver の android:label) */
    val nextLiveName: DisplayText get() = DisplayText.Res(R.string.widget_next_live_name)
    /** 担当アイドルの取り込んだ画像をホーム画面に出します。タップで次の画像に切り替わります。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description) */
    val oshiImageDescription: DisplayText get() = DisplayText.Res(R.string.widget_oshi_image_description)
    /** 担当の画像（タップで切替） — ホーム画面のウィジェット選択に出る名前 (Android の receiver の android:label)。タップで次の画像へ送る版 */
    val oshiImageName: DisplayText get() = DisplayText.Res(R.string.widget_oshi_image_name)
    /** 担当アイドルの取り込んだ画像をホーム画面に出します。タップするとアプリが開きます。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description) */
    val oshiLauncherDescription: DisplayText get() = DisplayText.Res(R.string.widget_oshi_launcher_description)
    /** 担当の画像（タップでアプリ） — ホーム画面のウィジェット選択に出る名前 (Android の receiver の android:label)。タップでアプリを開く版 (絵は oshi_image と同じ) */
    val oshiLauncherName: DisplayText get() = DisplayText.Res(R.string.widget_oshi_launcher_name)
    /** 担当を選ぶ — 担当画像ウィジェットの設定画面の名前 (Android の設定 Activity の android:label)。iOS の AppIntent (SelectOshiIntent.title) を移すときに両方で使う */
    val selectOshiTitle: DisplayText get() = DisplayText.Res(R.string.widget_select_oshi_title)
    /** 締切が近いチケットの先行受付を表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description) */
    val ticketDeadlineDescription: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_description)
    /** チケット締切 — ホーム画面のウィジェット選択に出る名前 (Android の receiver の android:label) */
    val ticketDeadlineName: DisplayText get() = DisplayText.Res(R.string.widget_ticket_deadline_name)
    /** 日替わりで1曲をジャケット付きで表示します。 — ウィジェット選択に出る説明 (Android の res/xml/ *_widget_info.xml の android:description) */
    val todaySongDescription: DisplayText get() = DisplayText.Res(R.string.widget_today_song_description)
    /** 今日の1曲 — ホーム画面のウィジェット選択に出る名前 (Android の receiver の android:label) */
    val todaySongName: DisplayText get() = DisplayText.Res(R.string.widget_today_song_name)
}
