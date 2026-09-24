// 生成物: i18n/catalog/app.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/app.json の文言。L10n.App から引く (iOS の L10n.App と同じ名前)。 */
object L10nApp {
    /** {message}\n(詳細: {detail}) — マスタデータを読み込めなかったときのエラーの本文 (Android)。message は何が起きたか (model.snapshot.unavailable)、detail は原因の本文か boot.load_error.unknown_detail — 引数: message (text), detail (text) */
    fun bootLoadErrorMessage(message: DisplayText, detail: DisplayText): DisplayText = DisplayText.Res(R.string.app_boot_load_error_message, listOf(message, detail))
    /** 不明 — boot.load_error.message の詳細。原因が分からないとき (Android) */
    val bootLoadErrorUnknownDetail: DisplayText get() = DisplayText.Res(R.string.app_boot_load_error_unknown_detail)
    /** データを準備中… — 起動時にデータを用意している間の表示 (Android)。iOS の boot.preparing と ja が違う (統一はオーナーが別 PR で) */
    val bootPreparingAndroid: DisplayText get() = DisplayText.Res(R.string.app_boot_preparing_android)
    /** 詳細: {detail} — 復旧画面の下に小さく出す技術的な詳細。detail はエラーの本文 (訳さない) — 引数: detail (string) */
    fun bootRecoveryDetail(detail: String): DisplayText = DisplayText.Res(R.string.app_boot_recovery_detail, listOf(detail))
    /** 端末に保存しているデータを開く途中で問題が起きました。データは消えていません。もう一度試しても開けないときは、アプリを最新版に更新してください。 — 復旧画面の説明。データは消していないので再インストールは勧めない */
    val bootRecoveryMessage: DisplayText get() = DisplayText.Res(R.string.app_boot_recovery_message)
    /** もう一度試す — 復旧画面のボタン。DB をもう一度開く */
    val bootRecoveryRetry: DisplayText get() = DisplayText.Res(R.string.app_boot_recovery_retry)
    /** データを開けませんでした — 端末の DB を開けなかったときの復旧画面の見出し */
    val bootRecoveryTitle: DisplayText get() = DisplayText.Res(R.string.app_boot_recovery_title)
    /** データの取得に失敗しました — 起動時にデータを用意できなかったときの見出し (Android)。下にエラーの本文と再試行ボタン */
    val bootSyncErrorTitle: DisplayText get() = DisplayText.Res(R.string.app_boot_sync_error_title)
    /** {label} を取得中… ({step}/{total}) — 起動時の同期の進み具合 (Android)。label は同期している段の名前 (コア由来)、step / total は何段目か — 引数: label (core), step (int), total (int) */
    fun bootSyncProgress(label: String, step: Int, total: Int): DisplayText = DisplayText.Res(R.string.app_boot_sync_progress, listOf(label, step, total))
}
