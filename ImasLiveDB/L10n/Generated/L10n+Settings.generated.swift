// 生成物: i18n/catalog/settings.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/settings.json の文言 (表 Settings)
    enum Settings {
        /// アカウントを削除 — アカウントを削除するボタン (確認ダイアログが出る)
        static var accountDeleteButton: LocalizedStringResource {
            LocalizedStringResource("settings.account.delete.button", defaultValue: "アカウントを削除", table: "Settings", bundle: L10n.bundle)
        }
        /// 削除する — アカウント削除の確認ダイアログの実行ボタン (赤)
        static var accountDeleteConfirm: LocalizedStringResource {
            LocalizedStringResource("settings.account.delete.confirm", defaultValue: "削除する", table: "Settings", bundle: L10n.bundle)
        }
        /// サーバー上のあなたの編集・Good・予想・ユーザー情報がすべて削除され、サインアウトされます。この操作は取り消せません。 — アカウント削除の確認ダイアログの本文 (iOS)。Good = 編集への「いいね」(機能名なので訳さない)。予想 = セトリ予想
        static var accountDeleteConfirmMessage: LocalizedStringResource {
            LocalizedStringResource("settings.account.delete.confirm_message", defaultValue: "サーバー上のあなたの編集・Good・予想・ユーザー情報がすべて削除され、サインアウトされます。この操作は取り消せません。", table: "Settings", bundle: L10n.bundle)
        }
        /// アカウントを削除しますか? — アカウント削除の確認ダイアログの見出し
        static var accountDeleteConfirmTitle: LocalizedStringResource {
            LocalizedStringResource("settings.account.delete.confirm_title", defaultValue: "アカウントを削除しますか?", table: "Settings", bundle: L10n.bundle)
        }
        /// 削除に失敗しました — アカウントを削除できなかったときのダイアログの見出し
        static var accountDeleteErrorTitle: LocalizedStringResource {
            LocalizedStringResource("settings.account.delete.error_title", defaultValue: "削除に失敗しました", table: "Settings", bundle: L10n.bundle)
        }
        /// 表示名を変更 — 名前の右の鉛筆ボタンの読み上げ
        static var accountEditNameA11y: LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.a11y", defaultValue: "表示名を変更", table: "Settings", bundle: L10n.bundle)
        }
        /// 今日はこれ以上、表示名を変更できません。明日また試してください — 表示名の変更が 1 日の上限に達したとき (429)
        static var accountEditNameErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.error_rate_limited", defaultValue: "今日はこれ以上、表示名を変更できません。明日また試してください", table: "Settings", bundle: L10n.bundle)
        }
        /// 表示名の保存に失敗 — 表示名を保存できなかったときのダイアログの見出し
        static var accountEditNameErrorTitle: LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.error_title", defaultValue: "表示名の保存に失敗", table: "Settings", bundle: L10n.bundle)
        }
        /// コミュニティ投稿で表示される名前です ({max}文字以内) — 表示名の変更ダイアログの説明。max = 上限の文字数 (コアが決める。今は 40 なので桁区切りは付かない) — 引数: max (count)
        static func accountEditNameMessage(max: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.message", defaultValue: "コミュニティ投稿で表示される名前です (\(max)文字以内)", table: "Settings", bundle: L10n.bundle)
        }
        /// 表示名 — 表示名の入力欄のプレースホルダ
        static var accountEditNamePlaceholder: LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.placeholder", defaultValue: "表示名", table: "Settings", bundle: L10n.bundle)
        }
        /// 表示名を変更 — 表示名の変更ダイアログの見出し
        static var accountEditNameTitle: LocalizedStringResource {
            LocalizedStringResource("settings.account.edit_name.title", defaultValue: "表示名を変更", table: "Settings", bundle: L10n.bundle)
        }
        /// アカウント — 設定のアカウントの節の見出し
        static var accountHeader: LocalizedStringResource {
            LocalizedStringResource("settings.account.header", defaultValue: "アカウント", table: "Settings", bundle: L10n.bundle)
        }
        /// ログインするとライブ・セトリ・楽曲データの編集や Good ができます — 未ログインのときのアカウントの節の案内 (下に Apple でサインインのボタン)
        static var accountSignInPrompt: LocalizedStringResource {
            LocalizedStringResource("settings.account.sign_in_prompt", defaultValue: "ログインするとライブ・セトリ・楽曲データの編集や Good ができます", table: "Settings", bundle: L10n.bundle)
        }
        /// ログアウト — ログアウトボタン
        static var accountSignOut: LocalizedStringResource {
            LocalizedStringResource("settings.account.sign_out", defaultValue: "ログアウト", table: "Settings", bundle: L10n.bundle)
        }
        /// ユーザー — 表示名がまだ無いときに名前の代わりに出す語
        static var accountUserFallback: LocalizedStringResource {
            LocalizedStringResource("settings.account.user_fallback", defaultValue: "ユーザー", table: "Settings", bundle: L10n.bundle)
        }
        /// キャンセル — 設定画面のダイアログを閉じるボタン (表示名の変更・画像の取り込み・削除の確認など)
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("settings.action.cancel", defaultValue: "キャンセル", table: "Settings", bundle: L10n.bundle)
        }
        /// 閉じる — 設定・お知らせのシートを閉じるボタン (右上)
        static var actionClose: LocalizedStringResource {
            LocalizedStringResource("settings.action.close", defaultValue: "閉じる", table: "Settings", bundle: L10n.bundle)
        }
        /// コピー — 発行した引き継ぎコードをコピーするボタン
        static var actionCopy: LocalizedStringResource {
            LocalizedStringResource("settings.action.copy", defaultValue: "コピー", table: "Settings", bundle: L10n.bundle)
        }
        /// インポート — 画像の一括取り込みダイアログの実行ボタン
        static var actionImport: LocalizedStringResource {
            LocalizedStringResource("settings.action.import", defaultValue: "インポート", table: "Settings", bundle: L10n.bundle)
        }
        /// 保存 — 表示名の変更ダイアログの保存ボタン
        static var actionSave: LocalizedStringResource {
            LocalizedStringResource("settings.action.save", defaultValue: "保存", table: "Settings", bundle: L10n.bundle)
        }
        /// アプリについて — アプリの紹介の画面へ進む行
        static var appInfoAbout: LocalizedStringResource {
            LocalizedStringResource("settings.app_info.about", defaultValue: "アプリについて", table: "Settings", bundle: L10n.bundle)
        }
        /// アプリ情報 — アプリについて・規約などの節の見出し
        static var appInfoHeader: LocalizedStringResource {
            LocalizedStringResource("settings.app_info.header", defaultValue: "アプリ情報", table: "Settings", bundle: L10n.bundle)
        }
        /// プライバシーポリシー — プライバシーポリシーの画面へ進む行
        static var appInfoPrivacy: LocalizedStringResource {
            LocalizedStringResource("settings.app_info.privacy", defaultValue: "プライバシーポリシー", table: "Settings", bundle: L10n.bundle)
        }
        /// サポート — サポート (問い合わせ) の画面へ進む行
        static var appInfoSupport: LocalizedStringResource {
            LocalizedStringResource("settings.app_info.support", defaultValue: "サポート", table: "Settings", bundle: L10n.bundle)
        }
        /// 利用規約 — 利用規約の画面へ進む行
        static var appInfoTerms: LocalizedStringResource {
            LocalizedStringResource("settings.app_info.terms", defaultValue: "利用規約", table: "Settings", bundle: L10n.bundle)
        }
        /// 引き継ぎコードの発行に失敗しました — 引き継ぎコードを発行できなかったときのアラートの見出し
        static var backupCodeErrorTitle: LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.error_title", defaultValue: "引き継ぎコードの発行に失敗しました", table: "Settings", bundle: L10n.bundle)
        }
        /// 24時間有効・1回のみ使用可能です (期限: {expires}) — 発行した引き継ぎコードの下の説明。expires = 期限の日時 (表示言語で書式済み) — 引数: expires (string)
        static func backupCodeExpiry(expires: String) -> LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.expiry", defaultValue: "24時間有効・1回のみ使用可能です (期限: \(expires))", table: "Settings", bundle: L10n.bundle)
        }
        /// 引き継ぎコード — 引き継ぎコードの入力欄のプレースホルダ・ラベル
        static var backupCodeField: LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.field", defaultValue: "引き継ぎコード", table: "Settings", bundle: L10n.bundle)
        }
        /// 引き継ぎコードを発行する — 引き継ぎコード (機種変更用のワンタイムコード) を発行するボタン
        static var backupCodeIssue: LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.issue", defaultValue: "引き継ぎコードを発行する", table: "Settings", bundle: L10n.bundle)
        }
        /// 発行中... — 引き継ぎコードを発行している間の表示
        static var backupCodeIssuing: LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.issuing", defaultValue: "発行中...", table: "Settings", bundle: L10n.bundle)
        }
        /// 復元 — 入力した引き継ぎコードで復元するボタン (入力欄の右)
        static var backupCodeRestore: LocalizedStringResource {
            LocalizedStringResource("settings.backup.code.restore", defaultValue: "復元", table: "Settings", bundle: L10n.bundle)
        }
        /// データが破損しています — バックアップのチェックサムが合わないとき
        static var backupErrorChecksum: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.checksum", defaultValue: "データが破損しています", table: "Settings", bundle: L10n.bundle)
        }
        /// コードが無効か期限切れです — 引き継ぎコードが無いか期限切れ (404)
        static var backupErrorInvalidCode: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.invalid_code", defaultValue: "コードが無効か期限切れです", table: "Settings", bundle: L10n.bundle)
        }
        /// ログインが必要です — 引き継ぎコードの発行・復元にログインが要るとき (401)
        static var backupErrorLoginRequired: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.login_required", defaultValue: "ログインが必要です", table: "Settings", bundle: L10n.bundle)
        }
        /// ファイルの形式が正しくありません — バックアップの中身が読めないとき (壊れた・別の形式)
        static var backupErrorMalformed: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.malformed", defaultValue: "ファイルの形式が正しくありません", table: "Settings", bundle: L10n.bundle)
        }
        /// 通信エラーが発生しました — 引き継ぎコードの通信が失敗したとき
        static var backupErrorNetwork: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.network", defaultValue: "通信エラーが発生しました", table: "Settings", bundle: L10n.bundle)
        }
        /// サーバーエラー — サーバーがエラー文を返さなかったときの代わりの文言
        static var backupErrorServer: LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.server", defaultValue: "サーバーエラー", table: "Settings", bundle: L10n.bundle)
        }
        /// 対応していないバックアップ形式です (schemaVersion: {version}) — バックアップの形式の版が新しすぎて読めないとき。version = ファイルの版 (整数)。schemaVersion は項目名なので訳さない — 引数: version (int)
        static func backupErrorUnsupportedSchema(version: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.backup.error.unsupported_schema", defaultValue: "対応していないバックアップ形式です (schemaVersion: \(String(version)))", table: "Settings", bundle: L10n.bundle)
        }
        /// バックアップの保存に失敗しました — バックアップをファイルに書き出せなかったときのアラートの見出し
        static var backupExportErrorTitle: LocalizedStringResource {
            LocalizedStringResource("settings.backup.export.error_title", defaultValue: "バックアップの保存に失敗しました", table: "Settings", bundle: L10n.bundle)
        }
        /// ファイルから復元する — バックアップファイルを選んで復元するボタン
        static var backupFileRestore: LocalizedStringResource {
            LocalizedStringResource("settings.backup.file.restore", defaultValue: "ファイルから復元する", table: "Settings", bundle: L10n.bundle)
        }
        /// ファイルに保存する — バックアップをファイルに書き出すボタン
        static var backupFileSave: LocalizedStringResource {
            LocalizedStringResource("settings.backup.file.save", defaultValue: "ファイルに保存する", table: "Settings", bundle: L10n.bundle)
        }
        /// バックアップファイルを共有 — 書き出したバックアップファイルを共有するボタン
        static var backupFileShare: LocalizedStringResource {
            LocalizedStringResource("settings.backup.file.share", defaultValue: "バックアップファイルを共有", table: "Settings", bundle: L10n.bundle)
        }
        /// 担当/お気に入りはiCloudで自動バックアップされていますが、これは投票履歴・端末IDも含めた手動バックアップです。機種変更やAndroid版への移行、iCloudが使えない場合にご利用ください。同一端末からの復元でない場合は「端末IDも引き継ぐ」はオフのままにしてください。引き継ぎコードの発行・復元にはログインが必要です。ファイル保存はログイン不要です。 — バックアップの節の下の説明。「端末IDも引き継ぐ」は同じ節のスイッチ (backup.restore_device_id) の名前
        static var backupFooter: LocalizedStringResource {
            LocalizedStringResource("settings.backup.footer", defaultValue: "担当/お気に入りはiCloudで自動バックアップされていますが、これは投票履歴・端末IDも含めた手動バックアップです。機種変更やAndroid版への移行、iCloudが使えない場合にご利用ください。同一端末からの復元でない場合は「端末IDも引き継ぐ」はオフのままにしてください。引き継ぎコードの発行・復元にはログインが必要です。ファイル保存はログイン不要です。", table: "Settings", bundle: L10n.bundle)
        }
        /// バックアップ — バックアップ (引き継ぎコード・ファイル) の節の見出し
        static var backupHeader: LocalizedStringResource {
            LocalizedStringResource("settings.backup.header", defaultValue: "バックアップ", table: "Settings", bundle: L10n.bundle)
        }
        /// 復元しました — 復元が終わったときのアラートの見出し (本文は入った件数。コアが作る)
        static var backupRestoreDoneTitle: LocalizedStringResource {
            LocalizedStringResource("settings.backup.restore.done_title", defaultValue: "復元しました", table: "Settings", bundle: L10n.bundle)
        }
        /// 復元に失敗しました — 復元できなかったときのダイアログの見出し
        static var backupRestoreFailedTitle: LocalizedStringResource {
            LocalizedStringResource("settings.backup.restore.failed_title", defaultValue: "復元に失敗しました", table: "Settings", bundle: L10n.bundle)
        }
        /// 復元時に端末IDも引き継ぐ(上級者向け・通常はOFF) — 復元のときに端末 ID も書き戻すかのスイッチ。同じ端末に戻すとき以外は OFF
        static var backupRestoreDeviceId: LocalizedStringResource {
            LocalizedStringResource("settings.backup.restore_device_id", defaultValue: "復元時に端末IDも引き継ぐ(上級者向け・通常はOFF)", table: "Settings", bundle: L10n.bundle)
        }
        /// 回収はリアルライブ(ライブ/フェス)の現地参加のみが対象です。配信でしか観られない方は、配信参加も回収に含められます。 — 回収の節の説明
        static var collectionFooter: LocalizedStringResource {
            LocalizedStringResource("settings.collection.footer", defaultValue: "回収はリアルライブ(ライブ/フェス)の現地参加のみが対象です。配信でしか観られない方は、配信参加も回収に含められます。", table: "Settings", bundle: L10n.bundle)
        }
        /// 披露回収 — 回収 (ライブで曲を生で聴いたこと) の数え方の節の見出し
        static var collectionHeader: LocalizedStringResource {
            LocalizedStringResource("settings.collection.header", defaultValue: "披露回収", table: "Settings", bundle: L10n.bundle)
        }
        /// 配信参加も回収に含める — 配信で観たライブの曲も回収済みにするかのスイッチ
        static var collectionIncludeStream: LocalizedStringResource {
            LocalizedStringResource("settings.collection.include_stream", defaultValue: "配信参加も回収に含める", table: "Settings", bundle: L10n.bundle)
        }
        /// アプリバージョン — アプリの版の行の見出し (右に 1.2.3 など)
        static var creditsAppVersion: LocalizedStringResource {
            LocalizedStringResource("settings.credits.app_version", defaultValue: "アプリバージョン", table: "Settings", bundle: L10n.bundle)
        }
        /// クレジット — クレジット (データの出どころ・非公式の断り) の節の見出し
        static var creditsHeader: LocalizedStringResource {
            LocalizedStringResource("settings.credits.header", defaultValue: "クレジット", table: "Settings", bundle: L10n.bundle)
        }
        /// 本アプリは非公式のファンメイドアプリです。 — 非公式のアプリである断り書き
        static var creditsUnofficial: LocalizedStringResource {
            LocalizedStringResource("settings.credits.unofficial", defaultValue: "本アプリは非公式のファンメイドアプリです。", table: "Settings", bundle: L10n.bundle)
        }
        /// すべて — デフォルトブランドの選択肢: 絞り込まない
        static var defaultBrandAll: LocalizedStringResource {
            LocalizedStringResource("settings.default_brand.all", defaultValue: "すべて", table: "Settings", bundle: L10n.bundle)
        }
        /// デフォルトブランド — 一覧を開いたときに最初に絞り込むブランドの選択
        static var defaultBrandLabel: LocalizedStringResource {
            LocalizedStringResource("settings.default_brand.label", defaultValue: "デフォルトブランド", table: "Settings", bundle: L10n.bundle)
        }
        /// ライブ名を省略表示 — ライブ名の頭の作品名 (THE IDOLM@STER … など) を省くかのスイッチ
        static var eventNameAbbreviateLabel: LocalizedStringResource {
            LocalizedStringResource("settings.event_name_abbreviate.label", defaultValue: "ライブ名を省略表示", table: "Settings", bundle: L10n.bundle)
        }
        /// 設定 — 表示などの一般設定の節の見出し (デフォルトブランド・文字サイズ・歌唱者の名前…)
        static var generalHeader: LocalizedStringResource {
            LocalizedStringResource("settings.general.header", defaultValue: "設定", table: "Settings", bundle: L10n.bundle)
        }
        /// 使い方を見る — 設定の先頭の、使い方 (ヘルプ) を開くボタン
        static var helpOpen: LocalizedStringResource {
            LocalizedStringResource("settings.help.open", defaultValue: "使い方を見る", table: "Settings", bundle: L10n.bundle)
        }
        /// ブランド画像をインポート — ブランドのアイコン画像を一括で取り込むボタン
        static var imageImportBrandButton: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.brand.button", defaultValue: "ブランド画像をインポート", table: "Settings", bundle: L10n.bundle)
        }
        /// ブランド名(または short_name / id)と画像URLのJSONファイルのURLを入力してください。\n形式: {{"765AS": "画像URL", ...}} — ブランド画像の取り込みダイアログの説明。short_name / id は JSON のキーに使える項目名なので訳さない。765AS はブランドの略称の例
        static var imageImportBrandDialogMessage: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.brand.dialog_message", defaultValue: "ブランド名(または short_name / id)と画像URLのJSONファイルのURLを入力してください。\n形式: {\"765AS\": \"画像URL\", ...}", table: "Settings", bundle: L10n.bundle)
        }
        /// ブランド画像インポート — ブランド画像の取り込みで JSON の URL を入れるダイアログの見出し
        static var imageImportBrandDialogTitle: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.brand.dialog_title", defaultValue: "ブランド画像インポート", table: "Settings", bundle: L10n.bundle)
        }
        /// 型紙 JSON をダウンロード (ブランド) — ブランド名だけ埋めた JSON (型紙) を書き出すボタン
        static var imageImportBrandTemplate: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.brand.template", defaultValue: "型紙 JSON をダウンロード (ブランド)", table: "Settings", bundle: L10n.bundle)
        }
        /// カスタム画像を全削除 — 取り込んだ画像をすべて消すボタン (赤)
        static var imageImportClear: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.clear", defaultValue: "カスタム画像を全削除", table: "Settings", bundle: L10n.bundle)
        }
        /// ブランド ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるブランドが無い
        static var imageImportFailureBrandNotFound: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failure.brand_not_found", defaultValue: "ブランド ID が見つからない", table: "Settings", bundle: L10n.bundle)
        }
        /// 画像デコード失敗 — 失敗内訳の理由: 取ってきたデータを画像として読めない
        static var imageImportFailureDecodeFailed: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failure.decode_failed", defaultValue: "画像デコード失敗", table: "Settings", bundle: L10n.bundle)
        }
        /// アイドル ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるアイドルがいない
        static var imageImportFailureIdolNotFound: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failure.idol_not_found", defaultValue: "アイドル ID が見つからない", table: "Settings", bundle: L10n.bundle)
        }
        /// URL が不正 — 失敗内訳の理由: 画像の URL が URL として読めない
        static var imageImportFailureInvalidUrl: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failure.invalid_url", defaultValue: "URL が不正", table: "Settings", bundle: L10n.bundle)
        }
        /// ユニット ID が見つからない — 失敗内訳の理由: JSON のキーの名前に当たるユニットが無い
        static var imageImportFailureUnitNotFound: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failure.unit_not_found", defaultValue: "ユニット ID が見つからない", table: "Settings", bundle: L10n.bundle)
        }
        /// 失敗内訳 ({count} 件) — 取り込めなかった名前の一覧の見出し。1000 以上は桁区切りが付く — 引数: count (count)
        static func imageImportFailures(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.image_import.failures", defaultValue: "失敗内訳 (\(count) 件)", table: "Settings", bundle: L10n.bundle)
        }
        /// 型紙 JSON をダウンロード → URL を埋めて GitHub Gist 等にアップ → そのファイル URL をインポートに貼り付け。既存画像は上書きされます。 — 画像の取り込みの手順の説明 (節の下)
        static var imageImportFooter: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.footer", defaultValue: "型紙 JSON をダウンロード → URL を埋めて GitHub Gist 等にアップ → そのファイル URL をインポートに貼り付け。既存画像は上書きされます。", table: "Settings", bundle: L10n.bundle)
        }
        /// 画像インポート — アイコン画像の一括取り込みの節の見出し
        static var imageImportHeader: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.header", defaultValue: "画像インポート", table: "Settings", bundle: L10n.bundle)
        }
        /// キャラクター画像をインポート — アイドルのアイコン画像を一括で取り込むボタン
        static var imageImportIdolButton: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.idol.button", defaultValue: "キャラクター画像をインポート", table: "Settings", bundle: L10n.bundle)
        }
        /// アイドル名と画像URLのJSONファイルのURLを入力してください。\n形式: {{"アイドル名": "画像URL", ...}} — アイドル画像の取り込みダイアログの説明。2 行目は JSON の書き方の例 (キーの説明語は訳す)
        static var imageImportIdolDialogMessage: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.idol.dialog_message", defaultValue: "アイドル名と画像URLのJSONファイルのURLを入力してください。\n形式: {\"アイドル名\": \"画像URL\", ...}", table: "Settings", bundle: L10n.bundle)
        }
        /// 画像一括インポート — アイドル画像の取り込みで JSON の URL を入れるダイアログの見出し
        static var imageImportIdolDialogTitle: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.idol.dialog_title", defaultValue: "画像一括インポート", table: "Settings", bundle: L10n.bundle)
        }
        /// 型紙 JSON をダウンロード (アイドル) — 名前だけ埋めた JSON (型紙) を書き出すボタン。型紙 = URL を埋めて使う雛形
        static var imageImportIdolTemplate: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.idol.template", defaultValue: "型紙 JSON をダウンロード (アイドル)", table: "Settings", bundle: L10n.bundle)
        }
        /// 削除エラー: {detail} — 取り込んだ画像を消せなかったときの状態の表示。detail = OS のエラー文 — 引数: detail (string)
        static func imageImportStatusClearFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.clear_failed", defaultValue: "削除エラー: \(detail)", table: "Settings", bundle: L10n.bundle)
        }
        /// カスタム画像を全削除しました — 取り込んだ画像をすべて消したあとの状態の表示
        static var imageImportStatusCleared: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.cleared", defaultValue: "カスタム画像を全削除しました", table: "Settings", bundle: L10n.bundle)
        }
        /// 完了: {succeeded}件成功, {failed}件失敗 — 取り込みが終わったときの結果。件数は 2 つあり count は 1 キーに 1 つまでなので、どちらも int (今と同じく桁区切りなし) — 引数: succeeded (int), failed (int)
        static func imageImportStatusDone(succeeded: Int, failed: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.done", defaultValue: "完了: \(String(succeeded))件成功, \(String(failed))件失敗", table: "Settings", bundle: L10n.bundle)
        }
        /// エラー: {detail} — 取り込みの途中で失敗したとき。detail = OS のエラー文 — 引数: detail (string)
        static func imageImportStatusError(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.error", defaultValue: "エラー: \(detail)", table: "Settings", bundle: L10n.bundle)
        }
        /// データ取得中... — JSON を取りに行っている間の状態の表示
        static var imageImportStatusFetching: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.fetching", defaultValue: "データ取得中...", table: "Settings", bundle: L10n.bundle)
        }
        /// JSONの形式が正しくありません — 取ってきた JSON が「名前: URL」の 1 階層のオブジェクトでないとき
        static var imageImportStatusInvalidJson: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.invalid_json", defaultValue: "JSONの形式が正しくありません", table: "Settings", bundle: L10n.bundle)
        }
        /// 無効なURLです — 入力された JSON の URL が URL として読めないとき
        static var imageImportStatusInvalidUrl: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.invalid_url", defaultValue: "無効なURLです", table: "Settings", bundle: L10n.bundle)
        }
        /// {imported}/{total} ダウンロード中... — 画像を 1 枚ずつ落としている間の進み具合。進捗の分数なので桁区切りは付けない (int) — 引数: imported (int), total (int)
        static func imageImportStatusProgress(imported: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.image_import.status.progress", defaultValue: "\(String(imported))/\(String(total)) ダウンロード中...", table: "Settings", bundle: L10n.bundle)
        }
        /// ユニット画像をインポート — ユニットのアイコン画像を一括で取り込むボタン
        static var imageImportUnitButton: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.unit.button", defaultValue: "ユニット画像をインポート", table: "Settings", bundle: L10n.bundle)
        }
        /// ユニット名(または id)と画像URLのJSONファイルのURLを入力してください。\n形式: {{"S.E.M": "画像URL", ...}} — ユニット画像の取り込みダイアログの説明。S.E.M はユニット名の例 (固有名詞)
        static var imageImportUnitDialogMessage: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.unit.dialog_message", defaultValue: "ユニット名(または id)と画像URLのJSONファイルのURLを入力してください。\n形式: {\"S.E.M\": \"画像URL\", ...}", table: "Settings", bundle: L10n.bundle)
        }
        /// ユニット画像インポート — ユニット画像の取り込みで JSON の URL を入れるダイアログの見出し
        static var imageImportUnitDialogTitle: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.unit.dialog_title", defaultValue: "ユニット画像インポート", table: "Settings", bundle: L10n.bundle)
        }
        /// 型紙 JSON をダウンロード (ユニット) — ユニット名だけ埋めた JSON (型紙) を書き出すボタン
        static var imageImportUnitTemplate: LocalizedStringResource {
            LocalizedStringResource("settings.image_import.unit.template", defaultValue: "型紙 JSON をダウンロード (ユニット)", table: "Settings", bundle: L10n.bundle)
        }
        /// お知らせはありません — お知らせが 1 件も無いときの空状態
        static var inboxEmpty: LocalizedStringResource {
            LocalizedStringResource("settings.inbox.empty", defaultValue: "お知らせはありません", table: "Settings", bundle: L10n.bundle)
        }
        /// すべて既読 — お知らせを全部読んだことにするボタン
        static var inboxMarkAllRead: LocalizedStringResource {
            LocalizedStringResource("settings.inbox.mark_all_read", defaultValue: "すべて既読", table: "Settings", bundle: L10n.bundle)
        }
        /// お知らせ — お知らせ (アプリの更新情報) の一覧・詳細の画面タイトル
        static var inboxTitle: LocalizedStringResource {
            LocalizedStringResource("settings.inbox.title", defaultValue: "お知らせ", table: "Settings", bundle: L10n.bundle)
        }
        /// 使い方を見る — ウィジェットのお知らせの下の、ウィジェットの使い方を開くボタン
        static var inboxWidgetHowTo: LocalizedStringResource {
            LocalizedStringResource("settings.inbox.widget_how_to", defaultValue: "使い方を見る", table: "Settings", bundle: L10n.bundle)
        }
        /// 曲一覧にイントロドン導線を表示 — 曲一覧の下に出る「この絞り込みでイントロドン」の帯を出すかのスイッチ
        static var introdonBarLabel: LocalizedStringResource {
            LocalizedStringResource("settings.introdon_bar.label", defaultValue: "曲一覧にイントロドン導線を表示", table: "Settings", bundle: L10n.bundle)
        }
        /// 段の数と名前を変えられます。段を減らすと、その段の曲は 1 つ下に移ります (記録は消えません)。 — 習熟度の節の説明
        static var masteryFooter: LocalizedStringResource {
            LocalizedStringResource("settings.mastery.footer", defaultValue: "段の数と名前を変えられます。段を減らすと、その段の曲は 1 つ下に移ります (記録は消えません)。", table: "Settings", bundle: L10n.bundle)
        }
        /// 習熟度 — 習熟度 (曲をどれだけ覚えたかの段階) の節の見出し
        static var masteryHeader: LocalizedStringResource {
            LocalizedStringResource("settings.mastery.header", defaultValue: "習熟度", table: "Settings", bundle: L10n.bundle)
        }
        /// 習熟度の段階 — 習熟度の段階の設定画面へ進む行 (右に今の段階の名前が並ぶ)
        static var masteryLink: LocalizedStringResource {
            LocalizedStringResource("settings.mastery.link", defaultValue: "習熟度の段階", table: "Settings", bundle: L10n.bundle)
        }
        /// 通知が拒否されています。設定アプリから許可してください。 — 通知が OS で拒否されているときの案内
        static var notificationsDenied: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.denied", defaultValue: "通知が拒否されています。設定アプリから許可してください。", table: "Settings", bundle: L10n.bundle)
        }
        /// お気に入りまたは参加マークしたイベントにライブ前・チケット通知を送ります。 — 通知の節の説明
        static var notificationsFooter: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.footer", defaultValue: "お気に入りまたは参加マークしたイベントにライブ前・チケット通知を送ります。", table: "Settings", bundle: L10n.bundle)
        }
        /// 通知 — 通知の設定の節の見出し
        static var notificationsHeader: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.header", defaultValue: "通知", table: "Settings", bundle: L10n.bundle)
        }
        /// ライブ1週間前 — 通知の種類のスイッチ: ライブの 1 週間前
        static var notificationsLiveWeek: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.live_week", defaultValue: "ライブ1週間前", table: "Settings", bundle: L10n.bundle)
        }
        /// 月曜が近いことを知らせる (日曜 20:00) — 通知の種類のスイッチ: 日曜の夜に「月曜が近いよ」と知らせる (ファンの間のネタ)
        static var notificationsMonday: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.monday", defaultValue: "月曜が近いことを知らせる (日曜 20:00)", table: "Settings", bundle: L10n.bundle)
        }
        /// 担当アイドルの誕生日 — 通知の種類のスイッチ: 担当アイドルの誕生日
        static var notificationsOshiBirthday: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.oshi_birthday", defaultValue: "担当アイドルの誕生日", table: "Settings", bundle: L10n.bundle)
        }
        /// 通知を許可する — 通知の許可を求めるボタン (まだ許可していないとき)
        static var notificationsRequest: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.request", defaultValue: "通知を許可する", table: "Settings", bundle: L10n.bundle)
        }
        /// チケット締切・当落通知 — 通知の種類のスイッチ: チケットの申込締切と当落発表
        static var notificationsTicket: LocalizedStringResource {
            LocalizedStringResource("settings.notifications.ticket", defaultValue: "チケット締切・当落通知", table: "Settings", bundle: L10n.bundle)
        }
        /// セトリの歌唱者 — セトリの歌唱者をアイドル名・声優名のどちらで出すかの選択。選択肢はコアの語彙
        static var performerNameLabel: LocalizedStringResource {
            LocalizedStringResource("settings.performer_name.label", defaultValue: "セトリの歌唱者", table: "Settings", bundle: L10n.bundle)
        }
        /// 設定 — 設定画面のタイトル (iOS はシートのナビゲーションタイトル、Android はタブの上のバー)
        static var screenTitle: LocalizedStringResource {
            LocalizedStringResource("settings.screen.title", defaultValue: "設定", table: "Settings", bundle: L10n.bundle)
        }
        /// イベント数 — データ統計: イベント (ライブ) の数の行の見出し
        static var statsEventsLabel: LocalizedStringResource {
            LocalizedStringResource("settings.stats.events.label", defaultValue: "イベント数", table: "Settings", bundle: L10n.bundle)
        }
        /// {count}件 — データ統計: イベントの件数。1000 以上は桁区切りが付く — 引数: count (count)
        static func statsEventsValue(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.stats.events.value", defaultValue: "\(count)件", table: "Settings", bundle: L10n.bundle)
        }
        /// データ統計 — 端末に入っているデータの件数の節の見出し
        static var statsHeader: LocalizedStringResource {
            LocalizedStringResource("settings.stats.header", defaultValue: "データ統計", table: "Settings", bundle: L10n.bundle)
        }
        /// アイドル数 — データ統計: アイドルの人数の行の見出し
        static var statsIdolsLabel: LocalizedStringResource {
            LocalizedStringResource("settings.stats.idols.label", defaultValue: "アイドル数", table: "Settings", bundle: L10n.bundle)
        }
        /// {count}人 — データ統計: アイドルの人数。1000 以上は桁区切りが付く — 引数: count (count)
        static func statsIdolsValue(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.stats.idols.value", defaultValue: "\(count)人", table: "Settings", bundle: L10n.bundle)
        }
        /// 公演数 — データ統計: 公演の数の行の見出し
        static var statsShowsLabel: LocalizedStringResource {
            LocalizedStringResource("settings.stats.shows.label", defaultValue: "公演数", table: "Settings", bundle: L10n.bundle)
        }
        /// {count}公演 — データ統計: 公演の数。1000 以上は桁区切りが付く (公演は 1000 を超えうる) — 引数: count (count)
        static func statsShowsValue(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.stats.shows.value", defaultValue: "\(count)公演", table: "Settings", bundle: L10n.bundle)
        }
        /// 楽曲数 — データ統計: 曲の数の行の見出し
        static var statsSongsLabel: LocalizedStringResource {
            LocalizedStringResource("settings.stats.songs.label", defaultValue: "楽曲数", table: "Settings", bundle: L10n.bundle)
        }
        /// {count}曲 — データ統計: 曲の数。1000 以上は桁区切りが付く (今は付いていない。曲は 1000 を超えるので表示が 1,234曲 に変わる) — 引数: count (count)
        static func statsSongsValue(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("settings.stats.songs.value", defaultValue: "\(count)曲", table: "Settings", bundle: L10n.bundle)
        }
        /// 全データ同期 — データをすべて取り直すボタン
        static var syncFull: LocalizedStringResource {
            LocalizedStringResource("settings.sync.full", defaultValue: "全データ同期", table: "Settings", bundle: L10n.bundle)
        }
        /// データ同期 — データ同期の節の見出し
        static var syncHeader: LocalizedStringResource {
            LocalizedStringResource("settings.sync.header", defaultValue: "データ同期", table: "Settings", bundle: L10n.bundle)
        }
        /// 差分更新 — 前回から変わったデータだけ取り直すボタン
        static var syncIncremental: LocalizedStringResource {
            LocalizedStringResource("settings.sync.incremental", defaultValue: "差分更新", table: "Settings", bundle: L10n.bundle)
        }
        /// 文字サイズ — アプリ内の文字の大きさの選択
        static var textScaleLabel: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.label", defaultValue: "文字サイズ", table: "Settings", bundle: L10n.bundle)
        }
        /// 大 — 文字サイズの選択肢 (5 段の 4 番目)
        static var textScaleLarge: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.large", defaultValue: "大", table: "Settings", bundle: L10n.bundle)
        }
        /// 中 — 文字サイズの選択肢 (5 段の真ん中 = 既定)
        static var textScaleMedium: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.medium", defaultValue: "中", table: "Settings", bundle: L10n.bundle)
        }
        /// プレビュー — 文字サイズの下の見本 (曲名と歌唱者の行) の見出し
        static var textScalePreview: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.preview", defaultValue: "プレビュー", table: "Settings", bundle: L10n.bundle)
        }
        /// 小 — 文字サイズの選択肢 (5 段の 2 番目)
        static var textScaleSmall: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.small", defaultValue: "小", table: "Settings", bundle: L10n.bundle)
        }
        /// 特大 — 文字サイズの選択肢 (5 段の 1 番大きい)。セグメントに 5 つ並ぶので短く
        static var textScaleXlarge: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.xlarge", defaultValue: "特大", table: "Settings", bundle: L10n.bundle)
        }
        /// 極小 — 文字サイズの選択肢 (5 段の 1 番小さい)。セグメントに 5 つ並ぶので短く
        static var textScaleXsmall: LocalizedStringResource {
            LocalizedStringResource("settings.text_scale.xsmall", defaultValue: "極小", table: "Settings", bundle: L10n.bundle)
        }
        /// ONにすると、選んだ担当のイメージカラーがアプリ全体のアクセントカラーになります。 — テーマの節の説明
        static var themeFooter: LocalizedStringResource {
            LocalizedStringResource("settings.theme.footer", defaultValue: "ONにすると、選んだ担当のイメージカラーがアプリ全体のアクセントカラーになります。", table: "Settings", bundle: L10n.bundle)
        }
        /// テーマ — 担当の色をアプリのテーマに使う設定の節の見出し
        static var themeHeader: LocalizedStringResource {
            LocalizedStringResource("settings.theme.header", defaultValue: "テーマ", table: "Settings", bundle: L10n.bundle)
        }
        /// アイドル詳細で担当(推し)に設定すると、ここで色を選べます。 — 担当のアイドルがまだいないときの案内
        static var themeNoPicks: LocalizedStringResource {
            LocalizedStringResource("settings.theme.no_picks", defaultValue: "アイドル詳細で担当(推し)に設定すると、ここで色を選べます。", table: "Settings", bundle: L10n.bundle)
        }
        /// テーマにする担当 — テーマの色にする担当アイドルの選択
        static var themePickerLabel: LocalizedStringResource {
            LocalizedStringResource("settings.theme.picker_label", defaultValue: "テーマにする担当", table: "Settings", bundle: L10n.bundle)
        }
        /// 担当の色をテーマに使う — 担当アイドルのイメージカラーをアプリ全体のアクセントにするスイッチ
        static var themeUseOshiColor: LocalizedStringResource {
            LocalizedStringResource("settings.theme.use_oshi_color", defaultValue: "担当の色をテーマに使う", table: "Settings", bundle: L10n.bundle)
        }
    }
}
