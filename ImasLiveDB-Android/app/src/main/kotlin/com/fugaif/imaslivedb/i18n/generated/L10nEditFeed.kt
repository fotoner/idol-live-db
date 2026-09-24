// 生成物: i18n/catalog/edit_feed.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/edit_feed.json の文言。L10n.EditFeed から引く (iOS の L10n.EditFeed と同じ名前)。 */
object L10nEditFeed {
    /** 差戻し済み — 差し戻された (取り消された) 編集に付けるバッジ。iOS は編集履歴の行、Android は「最近の編集」の自分の編集タブのカード */
    val badgeReverted: DisplayText get() = DisplayText.Res(R.string.edit_feed_badge_reverted)
    /** 名無しのプロデューサー — 編集者の表示名。名前が無いか、メールアドレスの形のとき (匿名にする) に代わりに出す */
    val editorAnonymous: DisplayText get() = DisplayText.Res(R.string.edit_feed_editor_anonymous)
    /** 変更履歴 — 各カードの下の導線。その編集の差分 (変更履歴) を開く */
    val feedCardHistory: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_card_history)
    /** あなたの編集 — 自分の編集のカードに、Good ボタンの代わりに出すラベル */
    val feedCardOwn: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_card_own)
    /** 取り消す — 自分の編集タブのカードのボタン。その編集を差し戻す確認を開く */
    val feedCardRevert: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_card_revert)
    /** 誰かがデータを編集すると、ここに新着順で表示されます。 — 「最近の編集」(みんなの編集) が空のときの説明 */
    val feedEmptyMessage: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_empty_message)
    /** ライブ・楽曲・セトリを編集すると、ここに履歴が残ります。 — 自分の編集が空のときの説明 */
    val feedEmptyMessageMine: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_empty_message_mine)
    /** まだ編集がありません — 「最近の編集」に 1 件も無いときの空状態の見出し */
    val feedEmptyTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_empty_title)
    /** この操作は利用できません。 — 編集を制限されている利用者が操作したときのエラー */
    val feedErrorBanned: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_error_banned)
    /** 読み込みに失敗しました。 — 「最近の編集」の読み込み・Good の失敗 (Android。iOS の同じ所はエラーの説明を後ろに付ける feed.error.load_failed_ios) */
    val feedErrorLoadFailedAndroid: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_error_load_failed_android)
    /** ログインが必要です。 — 「最近の編集」で認証が切れていたときのエラー */
    val feedErrorLoginRequired: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_error_login_required)
    /** 操作が多すぎます。しばらく待ってからお試しください。 — サーバに短時間に何度も送った (429) ときのエラー */
    val feedErrorRateLimited: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_error_rate_limited)
    /** エラー — 「最近の編集」で読み込みや Good に失敗したときのアラートの見出し */
    val feedErrorTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_error_title)
    /** Good を付ける — Good (編集へのいいね) ボタンの読み上げ。まだ付けていないとき。Good は機能名なのでそのまま */
    val feedGoodAddA11y: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_good_add_a11y)
    /** Good を取り消す — Good (編集へのいいね) ボタンの読み上げ。もう付けているとき */
    val feedGoodRemoveA11y: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_good_remove_a11y)
    /** 編集の提案や Good にはログインが必要です。 — 未ログインで編集の提案・Good を押したときのダイアログの本文 */
    val feedLoginMessage: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_login_message)
    /** 自分の編集履歴を見るにはログインしてください。 — 未ログインで自分の編集タブを開いたときの説明 */
    val feedMineLoginMessage: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_mine_login_message)
    /** ログインが必要です — 未ログインで自分の編集タブを開いたときの空状態の見出し */
    val feedMineLoginTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_mine_login_title)
    /** 編集を提案 — 「最近の編集」右下のボタン。編集の種類を選ぶシートを開く */
    val feedProposeFab: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_propose_fab)
    /** 取り消す — 差し戻しの確認ダイアログの実行ボタン */
    val feedRevertConfirmAction: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_revert_confirm_action)
    /** やめる — 差し戻しの確認ダイアログの中止ボタン */
    val feedRevertConfirmCancel: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_revert_confirm_cancel)
    /** 「{label}」を編集前の状態に戻します。この操作も履歴に記録されます。 — 差し戻しの確認の本文。label は編集の概要 (サーバの文言) か、無いときはレコードの種類 (record_type.*) — 引数: label (text) */
    fun feedRevertConfirmMessage(label: DisplayText): DisplayText = DisplayText.Res(R.string.edit_feed_feed_revert_confirm_message, listOf(label))
    /** この編集を取り消しますか？ — 自分の編集を差し戻す前の確認ダイアログの見出し */
    val feedRevertConfirmTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_revert_confirm_title)
    /** 別のユーザーがこの後に編集したため取り消せませんでした。 — 差し戻そうとした編集のあとに別の人の編集があって差し戻せなかったとき */
    val feedRevertErrorConflict: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_revert_error_conflict)
    /** みんなの編集 — 「最近の編集」画面上部の切り替え。全員の編集 */
    val feedTabAll: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_tab_all)
    /** 自分の編集 — 「最近の編集」画面上部の切り替え。自分の編集だけ */
    val feedTabMine: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_tab_mine)
    /** 最近の編集 — 「最近の編集」画面のタイトル (みんなの編集) */
    val feedTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_title)
    /** 自分の編集 — 「最近の編集」画面を自分の編集だけにしたときのタイトル */
    val feedTitleMine: DisplayText get() = DisplayText.Res(R.string.edit_feed_feed_title_mine)
    /** 履歴がありません — 変更履歴のシートで 1 件も無いとき (Android。iOS の同じ所は history.empty.title_ios) */
    val historyEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_empty_title_android)
    /** 変更履歴の取得に失敗しました — 変更履歴のシート (レコード・セトリ) の読み込みに失敗したとき (Android。iOS の同じ所は history.load_failed_ios) */
    val historyLoadFailedAndroid: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_load_failed_android)
    /** (差戻し済み) — 変更履歴のシートの行で、差し戻された編集に添える注記 */
    val historyRevertedParen: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_reverted_paren)
    /** まだ編集されていません — セトリの編集履歴が 1 件も無いとき */
    val historySetlistEmpty: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_setlist_empty)
    /** セトリの編集履歴 — 公演のセトリの編集履歴のシートの見出し (下に公演名) */
    val historySetlistTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_setlist_title)
    /** 変更履歴 — 1 レコードの変更履歴のシートの見出し (Android。iOS の同じ画面は「編集履歴」の history.title_ios) */
    val historyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.edit_feed_history_title_android)
    /** {action}に失敗しました。変更は保存されていません。もう一度お試しください。 — 端末ローカルの書き込み失敗のアラートの本文。action は操作名 (例: メモの保存)。呼び出し側の文言を同じ言語で文字列にしてから差し込む (まだ日本語の文字列のまま渡す画面もある) — 引数: action (string) */
    fun localWriteFailedMessage(action: String): DisplayText = DisplayText.Res(R.string.edit_feed_local_write_failed_message, listOf(action))
    /** 保存できませんでした — 端末にだけ保存するデータ (担当・参加・メモ・座席・習熟度・家計簿・マイタグ) の書き込みに失敗したときのアラートの見出し */
    val localWriteFailedTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_local_write_failed_title)
    /** キャンセル — ログインのダイアログの閉じるボタン */
    val loginDialogCancel: DisplayText get() = DisplayText.Res(R.string.edit_feed_login_dialog_cancel)
    /** タグ・動画・投票にはログインが必要です。 — ログインのダイアログ (CommunityLoginPromptDialog) の本文の既定値 (呼び出し側が渡さないとき) */
    val loginDialogDefaultMessage: DisplayText get() = DisplayText.Res(R.string.edit_feed_login_dialog_default_message)
    /** ログインが必要です — 未ログインで投稿・編集・Good を押したときのダイアログの見出し */
    val loginDialogTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_login_dialog_title)
    /** Googleでログイン — Google アカウントでログインするボタン (ログインのダイアログと、自分の編集タブの未ログイン表示) */
    val loginGoogle: DisplayText get() = DisplayText.Res(R.string.edit_feed_login_google)
    /** 追加 — 編集の操作のバッジ (create) */
    val opCreate: DisplayText get() = DisplayText.Res(R.string.edit_feed_op_create)
    /** 削除 — 編集の操作のバッジ (delete) */
    val opDelete: DisplayText get() = DisplayText.Res(R.string.edit_feed_op_delete)
    /** 差戻し — 編集の操作のバッジ (revert) */
    val opRevert: DisplayText get() = DisplayText.Res(R.string.edit_feed_op_revert)
    /** セトリ更新 — 編集の操作のバッジ (snapshot (公演のセトリをまとめて更新)) */
    val opSnapshot: DisplayText get() = DisplayText.Res(R.string.edit_feed_op_snapshot)
    /** 更新 — 編集の操作のバッジ (update / replace) */
    val opUpdate: DisplayText get() = DisplayText.Res(R.string.edit_feed_op_update)
    /** まだ登録されていないライブ・イベントを作る — 「ライブを追加」の説明 */
    val proposeEventSubtitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_event_subtitle)
    /** ライブを追加 — 編集の種類: 新しいライブを作る */
    val proposeEventTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_event_title)
    /** 既存の楽曲・アイドル・ライブの修正、公演の追加は、それぞれの詳細画面から行えます。 — 編集の種類のシートの下の注意書き */
    val proposeFootnote: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_footnote)
    /** 公演の楽曲・出演者の追加/修正/削除 — 「セトリを編集」の説明 */
    val proposeSetlistSubtitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_setlist_subtitle)
    /** セトリを編集 — 編集の種類: 公演のセトリを直す */
    val proposeSetlistTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_setlist_title)
    /** まだ登録されていない楽曲を作る — 「曲を追加」の説明 */
    val proposeSongSubtitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_song_subtitle)
    /** 曲を追加 — 編集の種類: 新しい曲を作る */
    val proposeSongTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_song_title)
    /** 編集の種類を選択 — 「編集を提案」で開くシートの見出し */
    val proposeTitle: DisplayText get() = DisplayText.Res(R.string.edit_feed_propose_title)
    /** ライブ・イベント — 編集されたレコードの種類 (Event)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeEvent: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_event)
    /** アイドル — 編集されたレコードの種類 (Idol)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeIdol: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_idol)
    /** セットリスト — 編集されたレコードの種類 (SetlistItem / ShowSetlist)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeSetlist: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_setlist)
    /** セトリ出演者 — 編集されたレコードの種類 (SetlistPerformer)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeSetlistPerformer: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_setlist_performer)
    /** 公演 — 編集されたレコードの種類 (Show)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeShow: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_show)
    /** 出演キャスト — 編集されたレコードの種類 (ShowCast)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeShowCast: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_show_cast)
    /** 楽曲 — 編集されたレコードの種類 (Song)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeSong: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_song)
    /** 楽曲アーティスト — 編集されたレコードの種類 (SongArtist)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う */
    val recordTypeSongArtist: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_song_artist)
    /** コーレス (終了) — 編集されたレコードの種類 (SongCall)。2026-09-06 に終わった投稿の種類で、過去の履歴だけに出る */
    val recordTypeSongCall: DisplayText get() = DisplayText.Res(R.string.edit_feed_record_type_song_call)
}
