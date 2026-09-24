// 生成物: i18n/catalog/settings.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/settings.json の文言。L10n.Settings から引く (iOS の L10n.Settings と同じ名前)。 */
object L10nSettings {
    /** アカウントを削除 — アカウントを削除するボタン (確認ダイアログが出る) */
    val accountDeleteButton: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_button)
    /** 削除する — アカウント削除の確認ダイアログの実行ボタン (赤) */
    val accountDeleteConfirm: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_confirm)
    /** サーバー上のあなたの編集・Good・投票・ユーザー情報がすべて削除され、サインアウトされます。この操作は取り消せません。 — Android の文言。iOS の account.delete.confirm_message と ja が違う (予想 / 投票。統一はオーナーが別 PR で) */
    val accountDeleteConfirmMessageAndroid: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_confirm_message_android)
    /** アカウントを削除しますか? — アカウント削除の確認ダイアログの見出し */
    val accountDeleteConfirmTitle: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_confirm_title)
    /** 削除中... — アカウントを削除している間のボタンの表示 */
    val accountDeleteDeleting: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_deleting)
    /** 削除に失敗しました — アカウントを削除できなかったときのダイアログの本文 */
    val accountDeleteErrorMessage: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_error_message)
    /** 削除に失敗しました — アカウントを削除できなかったときのダイアログの見出し */
    val accountDeleteErrorTitle: DisplayText get() = DisplayText.Res(R.string.settings_account_delete_error_title)
    /** 表示名を変更 — 名前の右の鉛筆ボタンの読み上げ */
    val accountEditNameA11y: DisplayText get() = DisplayText.Res(R.string.settings_account_edit_name_a11y)
    /** 表示名の保存に失敗しました — 表示名を保存できなかったときのダイアログの本文 */
    val accountEditNameErrorMessage: DisplayText get() = DisplayText.Res(R.string.settings_account_edit_name_error_message)
    /** 表示名の保存に失敗 — 表示名を保存できなかったときのダイアログの見出し */
    val accountEditNameErrorTitle: DisplayText get() = DisplayText.Res(R.string.settings_account_edit_name_error_title)
    /** コミュニティ投稿で表示される名前です ({max}文字以内) — 表示名の変更ダイアログの説明。max = 上限の文字数 (コアが決める。今は 40 なので桁区切りは付かない) — 引数: max (count) */
    fun accountEditNameMessage(max: Int): DisplayText = DisplayText.Plural(R.plurals.settings_account_edit_name_message, max, listOf(max))
    /** 表示名を変更 — 表示名の変更ダイアログの見出し */
    val accountEditNameTitle: DisplayText get() = DisplayText.Res(R.string.settings_account_edit_name_title)
    /** Googleでログイン — Google アカウントでログインするボタン */
    val accountGoogleSignIn: DisplayText get() = DisplayText.Res(R.string.settings_account_google_sign_in)
    /** アカウント — 設定のアカウントの節の見出し */
    val accountHeader: DisplayText get() = DisplayText.Res(R.string.settings_account_header)
    /** 投票 (お題) にはログインが必要です — Android の文言。未ログインのときのアカウントの節の案内。iOS の account.sign_in_prompt と ja が違う */
    val accountSignInPromptAndroid: DisplayText get() = DisplayText.Res(R.string.settings_account_sign_in_prompt_android)
    /** ログアウト — ログアウトボタン */
    val accountSignOut: DisplayText get() = DisplayText.Res(R.string.settings_account_sign_out)
    /** ログイン済み — 表示名がまだ無いときに名前の代わりに出す語 */
    val accountSignedInFallback: DisplayText get() = DisplayText.Res(R.string.settings_account_signed_in_fallback)
    /** キャンセル — 設定画面のダイアログを閉じるボタン (表示名の変更・画像の取り込み・削除の確認など) */
    val actionCancel: DisplayText get() = DisplayText.Res(R.string.settings_action_cancel)
    /** インポート — 画像の一括取り込みダイアログの実行ボタン */
    val actionImport: DisplayText get() = DisplayText.Res(R.string.settings_action_import)
    /** 保存 — 表示名の変更ダイアログの保存ボタン */
    val actionSave: DisplayText get() = DisplayText.Res(R.string.settings_action_save)
    /** 開発をサポートする — 開発者への寄付 (Ko-fi) を開く行 */
    val appInfoDonate: DisplayText get() = DisplayText.Res(R.string.settings_app_info_donate)
    /** アプリ情報 — アプリについて・規約などの節の見出し */
    val appInfoHeader: DisplayText get() = DisplayText.Res(R.string.settings_app_info_header)
    /** 使い方 — 使い方 (ヘルプ) の画面を開く行 */
    val appInfoHelp: DisplayText get() = DisplayText.Res(R.string.settings_app_info_help)
    /** お知らせ — お知らせ (アプリの更新情報) の一覧を開く行 */
    val appInfoInbox: DisplayText get() = DisplayText.Res(R.string.settings_app_info_inbox)
    /** オープンソースライセンス — 使っているオープンソースのライセンス一覧を開く行 */
    val appInfoLicenses: DisplayText get() = DisplayText.Res(R.string.settings_app_info_licenses)
    /** プライバシーポリシー — プライバシーポリシーの画面へ進む行 */
    val appInfoPrivacy: DisplayText get() = DisplayText.Res(R.string.settings_app_info_privacy)
    /** アプリを評価する — ストアのアプリのページを開いて評価してもらう行 */
    val appInfoRate: DisplayText get() = DisplayText.Res(R.string.settings_app_info_rate)
    /** サポート — サポート (問い合わせ) の画面へ進む行 */
    val appInfoSupport: DisplayText get() = DisplayText.Res(R.string.settings_app_info_support)
    /** 利用規約 — 利用規約の画面へ進む行 */
    val appInfoTerms: DisplayText get() = DisplayText.Res(R.string.settings_app_info_terms)
    /** 発行に失敗しました — 引き継ぎコードを発行できなかったときのダイアログの本文 (理由が分からないとき) */
    val backupCodeErrorMessage: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_error_message)
    /** 発行に失敗しました — Android の文言。引き継ぎコードを発行できなかったときのダイアログの見出し。iOS の backup.code.error_title と ja が違う */
    val backupCodeErrorTitleAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_error_title_android)
    /** 引き継ぎコード — 引き継ぎコードの入力欄のプレースホルダ・ラベル */
    val backupCodeField: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_field)
    /** 長押しでコピー・24時間有効・1回のみ使用可能です — 発行した引き継ぎコードの下の説明 */
    val backupCodeHint: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_hint)
    /** 引き継ぎコードを発行する — 引き継ぎコード (機種変更用のワンタイムコード) を発行するボタン */
    val backupCodeIssue: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_issue)
    /** 発行中... — 引き継ぎコードを発行している間の表示 */
    val backupCodeIssuing: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_issuing)
    /** 引き継ぎコードで復元する — Android の文言。入力した引き継ぎコードで復元するボタン。iOS の backup.code.restore と ja が違う */
    val backupCodeRestoreAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_restore_android)
    /** 復元中... — 引き継ぎコードで復元している間のボタンの表示 */
    val backupCodeRestoring: DisplayText get() = DisplayText.Res(R.string.settings_backup_code_restoring)
    /** データが不正です — サーバーが送ったデータを不正と判断したとき (400) */
    val backupErrorBadData: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_bad_data)
    /** サーバーからの応答が不正です — サーバーの応答が読めなかったとき */
    val backupErrorBadResponse: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_bad_response)
    /** データが破損しているか改ざんされている可能性があります — Android の文言。iOS の backup.error.checksum と ja が違う */
    val backupErrorChecksumAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_checksum_android)
    /** 通信に失敗しました (HTTP {status}) — ほかの HTTP エラー。status = HTTP の状態コード (int) — 引数: status (int) */
    fun backupErrorHttp(status: Int): DisplayText = DisplayText.Res(R.string.settings_backup_error_http, listOf(status))
    /** コードが無効か期限切れです — 引き継ぎコードが無いか期限切れ (404) */
    val backupErrorInvalidCode: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_invalid_code)
    /** ログインが必要です — 引き継ぎコードの発行・復元にログインが要るとき (401) */
    val backupErrorLoginRequired: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_login_required)
    /** 壊れたファイルです — Android の文言。iOS の backup.error.malformed と ja が違う */
    val backupErrorMalformedAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_malformed_android)
    /** しばらく待ってから再試行してください — 引き継ぎコードの操作がレート制限 (429) に当たったとき */
    val backupErrorRateLimited: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_rate_limited)
    /** 通信に失敗しました — 引き継ぎコードの通信が失敗したとき */
    val backupErrorTransport: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_transport)
    /** 新しいバージョンのアプリで作成されたファイルです — Android の文言。iOS の backup.error.unsupported_schema と ja が違う */
    val backupErrorUnsupportedSchemaAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_error_unsupported_schema_android)
    /** 書き出しに失敗しました — バックアップをファイルに書き出せなかったとき (復元失敗のダイアログに出る) */
    val backupFileExportFailed: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_export_failed)
    /** 読み込み中... — バックアップファイルを読んでいる間のボタンの表示 */
    val backupFileLoading: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_loading)
    /** ファイルから復元する — バックアップファイルを選んで復元するボタン */
    val backupFileRestore: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_restore)
    /** ファイルに保存する — バックアップをファイルに書き出すボタン */
    val backupFileSave: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_save)
    /** 書き出し中... — バックアップをファイルに書き出している間のボタンの表示 */
    val backupFileSaving: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_saving)
    /** ファイルを読み込めませんでした — 選んだバックアップファイルを開けなかったとき */
    val backupFileUnreadable: DisplayText get() = DisplayText.Res(R.string.settings_backup_file_unreadable)
    /** バックアップ — バックアップ (引き継ぎコード・ファイル) の節の見出し */
    val backupHeader: DisplayText get() = DisplayText.Res(R.string.settings_backup_header)
    /** 機種変更やアプリの再インストール時に、お気に入り・担当・投票履歴を引き継げます — バックアップの節の先頭の説明 */
    val backupIntro: DisplayText get() = DisplayText.Res(R.string.settings_backup_intro)
    /** 復元が完了しました — Android の文言。iOS の backup.restore.done_title と ja が違う */
    val backupRestoreDoneTitleAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_restore_done_title_android)
    /** 読み込みに失敗しました — 復元できなかったときのダイアログの本文 (理由が分からないとき) */
    val backupRestoreFailedMessage: DisplayText get() = DisplayText.Res(R.string.settings_backup_restore_failed_message)
    /** 復元に失敗しました — 復元できなかったときのダイアログの見出し */
    val backupRestoreFailedTitle: DisplayText get() = DisplayText.Res(R.string.settings_backup_restore_failed_title)
    /** 復元時に端末IDも引き継ぐ (上級者向け・通常はオフ) — Android の文言。iOS の backup.restore_device_id と空白と OFF / オフが違う */
    val backupRestoreDeviceIdAndroid: DisplayText get() = DisplayText.Res(R.string.settings_backup_restore_device_id_android)
    /** 回収はリアルライブ (ライブ/フェス) の現地参加のみが対象です。配信でしか観られない方は、配信参加も回収に含められます。 — Android の文言。iOS の collection.footer と括弧の前後の空白だけ違う */
    val collectionFooterAndroid: DisplayText get() = DisplayText.Res(R.string.settings_collection_footer_android)
    /** 披露回収 — 回収 (ライブで曲を生で聴いたこと) の数え方の節の見出し */
    val collectionHeader: DisplayText get() = DisplayText.Res(R.string.settings_collection_header)
    /** 配信参加も回収に含める — 配信で観たライブの曲も回収済みにするかのスイッチ */
    val collectionIncludeStream: DisplayText get() = DisplayText.Res(R.string.settings_collection_include_stream)
    /** アプリバージョン — アプリの版の行の見出し (右に 1.2.3 など) */
    val creditsAppVersion: DisplayText get() = DisplayText.Res(R.string.settings_credits_app_version)
    /** クレジット — クレジット (データの出どころ・非公式の断り) の節の見出し */
    val creditsHeader: DisplayText get() = DisplayText.Res(R.string.settings_credits_header)
    /** ※各情報源のデータは独自に集計・整形して利用しています — データの出どころの注記 */
    val creditsNote: DisplayText get() = DisplayText.Res(R.string.settings_credits_note)
    /** 楽曲・ライブ等のデータ参照元: アイマスDB (https://imas-db.jp/) — データの出どころ。アイマスDB はサイト名 (ko は読みを音写) */
    val creditsSourceImasDb: DisplayText get() = DisplayText.Res(R.string.settings_credits_source_imas_db)
    /** 楽曲・ライブセトリのデータ参照元: music765plus (https://music765plus.com/) — データの出どころ。music765plus はサイト名なので訳さない */
    val creditsSourceMusic765plus: DisplayText get() = DisplayText.Res(R.string.settings_credits_source_music765plus)
    /** アイドルのイメージカラー: imas-palette (https://github.com/arrow2nd/imas-palette) — データの出どころ。imas-palette はリポジトリ名なので訳さない */
    val creditsSourcePalette: DisplayText get() = DisplayText.Res(R.string.settings_credits_source_palette)
    /** アイドルのプロフィール(CV/カラー等): im@sparql (https://sparql.crssnky.xyz/imas/) — データの出どころ。im@sparql はサービス名なので訳さない */
    val creditsSourceSparql: DisplayText get() = DisplayText.Res(R.string.settings_credits_source_sparql)
    /** 本アプリは株式会社バンダイナムコエンターテインメント様とは一切関係のない非公式ファンメイドアプリです。 — Android の文言。非公式のアプリである断り書き (権利元と無関係であることを明記)。会社名は訳さず公式の英字表記にする */
    val creditsUnofficialAndroid: DisplayText get() = DisplayText.Res(R.string.settings_credits_unofficial_android)
    /** データバージョン — 端末に入っているデータの版 */
    val dataDataVersion: DisplayText get() = DisplayText.Res(R.string.settings_data_data_version)
    /** データ — データのバージョンと同期の節の見出し */
    val dataHeader: DisplayText get() = DisplayText.Res(R.string.settings_data_header)
    /** スキーマバージョン — 端末のデータベースの形の版 */
    val dataSchemaVersion: DisplayText get() = DisplayText.Res(R.string.settings_data_schema_version)
    /** 不明 — データベースの版が読めなかったときの値 */
    val dataUnknown: DisplayText get() = DisplayText.Res(R.string.settings_data_unknown)
    /** すべて — デフォルトブランドの選択肢: 絞り込まない */
    val defaultBrandAll: DisplayText get() = DisplayText.Res(R.string.settings_default_brand_all)
    /** デフォルトブランド — 一覧を開いたときに最初に絞り込むブランドの選択 */
    val defaultBrandLabel: DisplayText get() = DisplayText.Res(R.string.settings_default_brand_label)
    /** 開発者 — 開発者と公開リポジトリの節の見出し */
    val developerHeader: DisplayText get() = DisplayText.Res(R.string.settings_developer_header)
    /** 開発 — 開発者の行の見出し (右に開発者名 fuga-if) */
    val developerLabel: DisplayText get() = DisplayText.Res(R.string.settings_developer_label)
    /** 非公式のファンメイドアプリです。データの誤りや要望は GitHub Issue からお知らせください。 — 開発者の節の説明 */
    val developerNote: DisplayText get() = DisplayText.Res(R.string.settings_developer_note)
    /** 表示 — 文字サイズ・歌唱者の名前・ライブ名の省略の節の見出し */
    val displayHeader: DisplayText get() = DisplayText.Res(R.string.settings_display_header)
    /** ライブ名を省略表示 — ライブ名の頭の作品名 (THE IDOLM@STER … など) を省くかのスイッチ */
    val eventNameAbbreviateLabel: DisplayText get() = DisplayText.Res(R.string.settings_event_name_abbreviate_label)
    /** フィルタ設定 — デフォルトブランドの節の見出し */
    val filterHeader: DisplayText get() = DisplayText.Res(R.string.settings_filter_header)
    /** バージョン {version} — 設定の先頭のアプリ名の下の版の表示。version = 1.2.3 など — 引数: version (string) */
    fun headerVersion(version: String): DisplayText = DisplayText.Res(R.string.settings_header_version, listOf(version))
    /** バージョン {version} (Build {build}) — 設定の先頭のアプリ名の下の版の表示 (ビルド番号つき)。build = ビルド番号 (int。桁区切りなし) — 引数: version (string), build (int) */
    fun headerVersionBuild(version: String, build: Int): DisplayText = DisplayText.Res(R.string.settings_header_version_build, listOf(version, build))
    /** ブランド画像をインポート — ブランドのアイコン画像を一括で取り込むボタン */
    val imageImportBrandButton: DisplayText get() = DisplayText.Res(R.string.settings_image_import_brand_button)
    /** ブランド画像の一括インポート — Android の文言。iOS の image_import.brand.dialog_title と ja が違う */
    val imageImportBrandDialogTitleAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_brand_dialog_title_android)
    /** カスタム画像をすべて削除 — Android の文言。取り込んだ画像をすべて消すボタン (確認ダイアログが出る)。iOS の image_import.clear と ja が違う */
    val imageImportClearAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_clear_android)
    /** 削除 — 取り込んだ画像をすべて消す確認ダイアログの実行ボタン (赤) */
    val imageImportClearConfirmAction: DisplayText get() = DisplayText.Res(R.string.settings_image_import_clear_confirm_action)
    /** 取り込んだアイドル・ユニット・ブランドの画像をすべて消します。元に戻せません。 — 取り込んだ画像をすべて消す前の確認ダイアログの本文 */
    val imageImportClearConfirmMessage: DisplayText get() = DisplayText.Res(R.string.settings_image_import_clear_confirm_message)
    /** カスタム画像をすべて削除 — 取り込んだ画像をすべて消す前の確認ダイアログの見出し */
    val imageImportClearConfirmTitle: DisplayText get() = DisplayText.Res(R.string.settings_image_import_clear_confirm_title)
    /** {{ "名前": "画像URL" }} 形式の JSON を置いた URL を入力してください。 — 画像の取り込みダイアログの説明 (JSON の書き方の例つき) */
    val imageImportDialogMessage: DisplayText get() = DisplayText.Res(R.string.settings_image_import_dialog_message)
    /** ブランド ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるブランドが無い */
    val imageImportFailureBrandNotFound: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_brand_not_found)
    /** 画像デコード失敗 — 失敗内訳の理由: 取ってきたデータを画像として読めない */
    val imageImportFailureDecodeFailed: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_decode_failed)
    /** 取得失敗 — 失敗内訳の理由: 画像を取りに行けなかった (エラー文が無い場合) */
    val imageImportFailureFetchFailed: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_fetch_failed)
    /** アイドル ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるアイドルがいない */
    val imageImportFailureIdolNotFound: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_idol_not_found)
    /** URL が不正 — 失敗内訳の理由: 画像の URL が URL として読めない */
    val imageImportFailureInvalidUrl: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_invalid_url)
    /** ユニット ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるユニットが無い */
    val imageImportFailureUnitNotFound: DisplayText get() = DisplayText.Res(R.string.settings_image_import_failure_unit_not_found)
    /** 失敗内訳 ({count} 件) — 取り込めなかった名前の一覧の見出し。1000 以上は桁区切りが付く — 引数: count (count) */
    fun imageImportFailures(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_image_import_failures, count, listOf(count))
    /** ほか {count} 件 — 失敗内訳を 20 件まで出したあとに残りの件数をまとめる行。1000 以上は桁区切りが付く — 引数: count (count) */
    fun imageImportFailuresMore(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_image_import_failures_more, count, listOf(count))
    /** キャラクター画像 — Android の文言。アイコン画像の一括取り込みの節の見出し。iOS の image_import.header と ja が違う */
    val imageImportHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_header_android)
    /** アイドル画像をインポート — Android の文言。iOS の image_import.idol.button と ja が違う */
    val imageImportIdolButtonAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_idol_button_android)
    /** アイドル画像の一括インポート — Android の文言。iOS の image_import.idol.dialog_title と ja が違う */
    val imageImportIdolDialogTitleAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_idol_dialog_title_android)
    /** 「名前 → 画像URL」の JSON を指定すると、アイコン画像をまとめて取り込めます。画像はこの端末の中だけに保存され、サーバーには送信されません。 — 画像の一括取り込みの節の先頭の説明 */
    val imageImportIntro: DisplayText get() = DisplayText.Res(R.string.settings_image_import_intro)
    /** カスタム画像を全削除しました — 取り込んだ画像をすべて消したあとの状態の表示 */
    val imageImportStatusCleared: DisplayText get() = DisplayText.Res(R.string.settings_image_import_status_cleared)
    /** 完了: {succeeded}件成功, {failed}件失敗 — 取り込みが終わったときの結果。件数は 2 つあり count は 1 キーに 1 つまでなので、どちらも int (今と同じく桁区切りなし) — 引数: succeeded (int), failed (int) */
    fun imageImportStatusDone(succeeded: Int, failed: Int): DisplayText = DisplayText.Res(R.string.settings_image_import_status_done, listOf(succeeded, failed))
    /** エラー: {detail} — 取り込みの途中で失敗したとき。detail = OS のエラー文 — 引数: detail (string) */
    fun imageImportStatusError(detail: String): DisplayText = DisplayText.Res(R.string.settings_image_import_status_error, listOf(detail))
    /** データ取得中... — JSON を取りに行っている間の状態の表示 */
    val imageImportStatusFetching: DisplayText get() = DisplayText.Res(R.string.settings_image_import_status_fetching)
    /** JSONの形式が正しくありません — 取ってきた JSON が「名前: URL」の 1 階層のオブジェクトでないとき */
    val imageImportStatusInvalidJson: DisplayText get() = DisplayText.Res(R.string.settings_image_import_status_invalid_json)
    /** 無効なURLです — 入力された JSON の URL が URL として読めないとき */
    val imageImportStatusInvalidUrl: DisplayText get() = DisplayText.Res(R.string.settings_image_import_status_invalid_url)
    /** {imported}/{total} ダウンロード中... — 画像を 1 枚ずつ落としている間の進み具合。進捗の分数なので桁区切りは付けない (int) — 引数: imported (int), total (int) */
    fun imageImportStatusProgress(imported: Int, total: Int): DisplayText = DisplayText.Res(R.string.settings_image_import_status_progress, listOf(imported, total))
    /** エラー: 名前の解決に失敗しました — 名前と ID の対応表を作れなかったとき (エラー文が無い場合) */
    val imageImportStatusResolveFailed: DisplayText get() = DisplayText.Res(R.string.settings_image_import_status_resolve_failed)
    /** 型紙 — 取り込みボタンの右の、名前だけ埋めた JSON (型紙) を保存するボタン */
    val imageImportTemplate: DisplayText get() = DisplayText.Res(R.string.settings_image_import_template)
    /** ユニット画像をインポート — ユニットのアイコン画像を一括で取り込むボタン */
    val imageImportUnitButton: DisplayText get() = DisplayText.Res(R.string.settings_image_import_unit_button)
    /** ユニット画像の一括インポート — Android の文言。iOS の image_import.unit.dialog_title と ja が違う */
    val imageImportUnitDialogTitleAndroid: DisplayText get() = DisplayText.Res(R.string.settings_image_import_unit_dialog_title_android)
    /** JSON の URL — 画像の取り込みダイアログの入力欄のラベル */
    val imageImportUrlLabel: DisplayText get() = DisplayText.Res(R.string.settings_image_import_url_label)
    /** すべて既読 — お知らせを全部読んだことにするボタン */
    val inboxMarkAllRead: DisplayText get() = DisplayText.Res(R.string.settings_inbox_mark_all_read)
    /** お知らせ — お知らせ (アプリの更新情報) の一覧・詳細の画面タイトル */
    val inboxTitle: DisplayText get() = DisplayText.Res(R.string.settings_inbox_title)
    /** ウィジェットの使い方を見る — Android の文言。iOS の inbox.widget_how_to と ja が違う */
    val inboxWidgetHowToAndroid: DisplayText get() = DisplayText.Res(R.string.settings_inbox_widget_how_to_android)
    /** 段を追加 — 習熟度の段を 1 つ増やすボタン */
    val masteryAddLevel: DisplayText get() = DisplayText.Res(R.string.settings_mastery_add_level)
    /** この段階にする — 編集した習熟度の段を保存するボタン */
    val masteryApply: DisplayText get() = DisplayText.Res(R.string.settings_mastery_apply)
    /** 習熟度 — 習熟度 (曲をどれだけ覚えたかの段階) の節の見出し */
    val masteryHeader: DisplayText get() = DisplayText.Res(R.string.settings_mastery_header)
    /** 下から順に積み上がります。段を減らすと、その段の曲は 1 つ下に移ります (記録は消えません)。どのラベルも 4 文字以内にしておくと一覧で切れません。 — 習熟度の段の編集欄の下の説明 */
    val masteryHelp: DisplayText get() = DisplayText.Res(R.string.settings_mastery_help)
    /** 削除 — 習熟度の一番上の段を消すボタン */
    val masteryRemoveLevel: DisplayText get() = DisplayText.Res(R.string.settings_mastery_remove_level)
    /** お気に入り/参加マークしたライブの初日 1 週間前に 10:00 にお知らせします。 — OS の通知設定に出る通知チャンネルの説明 */
    val notificationsChannelLiveWeekDescription: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_live_week_description)
    /** ライブ1週間前 — OS の通知設定に出る通知チャンネルの名前 */
    val notificationsChannelLiveWeekName: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_live_week_name)
    /** 日曜 20:00 に月曜が近いことをお知らせします。 — OS の通知設定に出る通知チャンネルの説明 */
    val notificationsChannelMondayDescription: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_monday_description)
    /** 月曜が近いよ — OS の通知設定に出る通知チャンネルの名前 (ファンの間のネタ) */
    val notificationsChannelMondayName: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_monday_name)
    /** 担当マークしたアイドルの誕生日に 9:00 にお知らせします。 — OS の通知設定に出る通知チャンネルの説明 */
    val notificationsChannelOshiBirthdayDescription: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_oshi_birthday_description)
    /** 担当アイドルの誕生日 — OS の通知設定に出る通知チャンネルの名前 */
    val notificationsChannelOshiBirthdayName: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_oshi_birthday_name)
    /** チケット申込締切の前日 18:00 と、当落発表日の 9:00 にお知らせします。 — OS の通知設定に出る通知チャンネルの説明 */
    val notificationsChannelTicketDescription: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_ticket_description)
    /** チケット締切・当落 — OS の通知設定に出る通知チャンネルの名前 */
    val notificationsChannelTicketName: DisplayText get() = DisplayText.Res(R.string.settings_notifications_channel_ticket_name)
    /** 通知が拒否されています。システムの通知設定から許可してください。 — Android の文言。iOS の notifications.denied と ja が違う */
    val notificationsDeniedAndroid: DisplayText get() = DisplayText.Res(R.string.settings_notifications_denied_android)
    /** お気に入りまたは参加マークしたイベントにライブ前・チケット通知を送ります。 — 通知の節の説明 */
    val notificationsFooter: DisplayText get() = DisplayText.Res(R.string.settings_notifications_footer)
    /** 通知 — 通知の設定の節の見出し */
    val notificationsHeader: DisplayText get() = DisplayText.Res(R.string.settings_notifications_header)
    /** ライブ1週間前 — 通知の種類のスイッチ: ライブの 1 週間前 */
    val notificationsLiveWeek: DisplayText get() = DisplayText.Res(R.string.settings_notifications_live_week)
    /** 月曜が近いことを知らせる (日曜 20:00) — 通知の種類のスイッチ: 日曜の夜に「月曜が近いよ」と知らせる (ファンの間のネタ) */
    val notificationsMonday: DisplayText get() = DisplayText.Res(R.string.settings_notifications_monday)
    /** システムの通知設定を開く — このアプリの OS の通知設定を開く行 */
    val notificationsOpenSystemSettings: DisplayText get() = DisplayText.Res(R.string.settings_notifications_open_system_settings)
    /** 担当アイドルの誕生日 — 通知の種類のスイッチ: 担当アイドルの誕生日 */
    val notificationsOshiBirthday: DisplayText get() = DisplayText.Res(R.string.settings_notifications_oshi_birthday)
    /** 通知を許可する — 通知の許可を求めるボタン (まだ許可していないとき) */
    val notificationsRequest: DisplayText get() = DisplayText.Res(R.string.settings_notifications_request)
    /** チケット締切・当落通知 — 通知の種類のスイッチ: チケットの申込締切と当落発表 */
    val notificationsTicket: DisplayText get() = DisplayText.Res(R.string.settings_notifications_ticket)
    /** セトリの歌唱者 — セトリの歌唱者をアイドル名・声優名のどちらで出すかの選択。選択肢はコアの語彙 */
    val performerNameLabel: DisplayText get() = DisplayText.Res(R.string.settings_performer_name_label)
    /** 設定 — 設定画面のタイトル (iOS はシートのナビゲーションタイトル、Android はタブの上のバー) */
    val screenTitle: DisplayText get() = DisplayText.Res(R.string.settings_screen_title)
    /** イベント数 — データ統計: イベント (ライブ) の数の行の見出し */
    val statsEventsLabel: DisplayText get() = DisplayText.Res(R.string.settings_stats_events_label)
    /** {count}件 — データ統計: イベントの件数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun statsEventsValue(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_stats_events_value, count, listOf(count))
    /** データ統計 — 端末に入っているデータの件数の節の見出し */
    val statsHeader: DisplayText get() = DisplayText.Res(R.string.settings_stats_header)
    /** アイドル数 — データ統計: アイドルの人数の行の見出し */
    val statsIdolsLabel: DisplayText get() = DisplayText.Res(R.string.settings_stats_idols_label)
    /** {count}人 — データ統計: アイドルの人数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun statsIdolsValue(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_stats_idols_value, count, listOf(count))
    /** 公演数 — データ統計: 公演の数の行の見出し */
    val statsShowsLabel: DisplayText get() = DisplayText.Res(R.string.settings_stats_shows_label)
    /** {count}公演 — データ統計: 公演の数。1000 以上は桁区切りが付く (公演は 1000 を超えうる) — 引数: count (count) */
    fun statsShowsValue(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_stats_shows_value, count, listOf(count))
    /** 楽曲数 — データ統計: 曲の数の行の見出し */
    val statsSongsLabel: DisplayText get() = DisplayText.Res(R.string.settings_stats_songs_label)
    /** {count}曲 — データ統計: 曲の数。1000 以上は桁区切りが付く (今は付いていない。曲は 1000 を超えるので表示が 1,234曲 に変わる) — 引数: count (count) */
    fun statsSongsValue(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_stats_songs_value, count, listOf(count))
    /** 全データ同期 — データをすべて取り直すボタン */
    val syncFull: DisplayText get() = DisplayText.Res(R.string.settings_sync_full)
    /** 差分更新 — 前回から変わったデータだけ取り直すボタン */
    val syncIncremental: DisplayText get() = DisplayText.Res(R.string.settings_sync_incremental)
    /** 完了 ({count}件) — 同期の状態: 終わった。count = 取ってきた件数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun syncStateCompleted(count: Int): DisplayText = DisplayText.Plural(R.plurals.settings_sync_state_completed, count, listOf(count))
    /** 失敗: {message} — 同期の状態: 失敗した。message = エラー文 — 引数: message (string) */
    fun syncStateError(message: String): DisplayText = DisplayText.Res(R.string.settings_sync_state_error, listOf(message))
    /** 待機中 — 同期の状態: 何もしていない */
    val syncStateIdle: DisplayText get() = DisplayText.Res(R.string.settings_sync_state_idle)
    /** 同期中 ({step}/{total}) {label} — 同期の状態: 取っている途中。step/total = 何段目か、label = 取っているデータの種類 (コアの語) — 引数: step (int), total (int), label (core) */
    fun syncStateSyncing(step: Int, total: Int, label: String): DisplayText = DisplayText.Res(R.string.settings_sync_state_syncing, listOf(step, total, label))
    /** OS のフォントサイズ設定に掛け合わせた倍率です。 — 文字サイズの説明 (端末の文字の大きさの設定とかけ合わせる) */
    val textScaleCaption: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_caption)
    /** 文字サイズ — アプリ内の文字の大きさの選択 */
    val textScaleLabel: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_label)
    /** 大 — 文字サイズの選択肢 (5 段の 4 番目) */
    val textScaleLarge: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_large)
    /** 中 — 文字サイズの選択肢 (5 段の真ん中 = 既定) */
    val textScaleMedium: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_medium)
    /** プレビュー — 文字サイズの下の見本 (曲名と歌唱者の行) の見出し */
    val textScalePreview: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_preview)
    /** 小 — 文字サイズの選択肢 (5 段の 2 番目) */
    val textScaleSmall: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_small)
    /** 特大 — 文字サイズの選択肢 (5 段の 1 番大きい)。セグメントに 5 つ並ぶので短く */
    val textScaleXlarge: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_xlarge)
    /** 極小 — 文字サイズの選択肢 (5 段の 1 番小さい)。セグメントに 5 つ並ぶので短く */
    val textScaleXsmall: DisplayText get() = DisplayText.Res(R.string.settings_text_scale_xsmall)
    /** ON にすると、選んだ担当のイメージカラーがアプリ全体のアクセントカラーになります。 — Android の文言。iOS の theme.footer と ON の後ろの空白だけ違う */
    val themeFooterAndroid: DisplayText get() = DisplayText.Res(R.string.settings_theme_footer_android)
    /** テーマ — 担当の色をアプリのテーマに使う設定の節の見出し */
    val themeHeader: DisplayText get() = DisplayText.Res(R.string.settings_theme_header)
    /** アイドル詳細で担当 (推し) に設定すると、ここで色を選べます。 — Android の文言。iOS の theme.no_picks と括弧の前後の空白だけ違う */
    val themeNoPicksAndroid: DisplayText get() = DisplayText.Res(R.string.settings_theme_no_picks_android)
    /** 未選択 — テーマにする担当がまだ選ばれていないときの表示 */
    val themeNotSelected: DisplayText get() = DisplayText.Res(R.string.settings_theme_not_selected)
    /** テーマにする担当 — テーマの色にする担当アイドルの選択 */
    val themePickerLabel: DisplayText get() = DisplayText.Res(R.string.settings_theme_picker_label)
    /** 担当の色をテーマに使う — 担当アイドルのイメージカラーをアプリ全体のアクセントにするスイッチ */
    val themeUseOshiColor: DisplayText get() = DisplayText.Res(R.string.settings_theme_use_oshi_color)
}
