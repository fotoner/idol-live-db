// 生成物: i18n/catalog/app.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/app.json の文言 (表 App)
    enum App {
        /// データを準備しています — 起動時に端末の DB を開くのが長引いたとき、起動画面のロゴの下に出す (iOS)
        static var bootPreparing: LocalizedStringResource {
            LocalizedStringResource("app.boot.preparing", defaultValue: "データを準備しています", table: "App", bundle: L10n.bundle)
        }
        /// 詳細: {detail} — 復旧画面の下に小さく出す技術的な詳細。detail はエラーの本文 (訳さない) — 引数: detail (string)
        static func bootRecoveryDetail(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("app.boot.recovery.detail", defaultValue: "詳細: \(detail)", table: "App", bundle: L10n.bundle)
        }
        /// 端末に保存しているデータを開く途中で問題が起きました。データは消えていません。もう一度試しても開けないときは、アプリを最新版に更新してください。 — 復旧画面の説明。データは消していないので再インストールは勧めない
        static var bootRecoveryMessage: LocalizedStringResource {
            LocalizedStringResource("app.boot.recovery.message", defaultValue: "端末に保存しているデータを開く途中で問題が起きました。データは消えていません。もう一度試しても開けないときは、アプリを最新版に更新してください。", table: "App", bundle: L10n.bundle)
        }
        /// もう一度試す — 復旧画面のボタン。DB をもう一度開く
        static var bootRecoveryRetry: LocalizedStringResource {
            LocalizedStringResource("app.boot.recovery.retry", defaultValue: "もう一度試す", table: "App", bundle: L10n.bundle)
        }
        /// データを開けませんでした — 端末の DB を開けなかったときの復旧画面の見出し
        static var bootRecoveryTitle: LocalizedStringResource {
            LocalizedStringResource("app.boot.recovery.title", defaultValue: "データを開けませんでした", table: "App", bundle: L10n.bundle)
        }
        /// リンク先の読み込み中にエラーが発生しました。もう一度お試しください。 — deeplink.load_failed.title のアラートの本文
        static var deeplinkLoadFailedMessage: LocalizedStringResource {
            LocalizedStringResource("app.deeplink.load_failed.message", defaultValue: "リンク先の読み込み中にエラーが発生しました。もう一度お試しください。", table: "App", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました — リンク先を開く途中で DB のエラーが起きたときのアラートの見出し
        static var deeplinkLoadFailedTitle: LocalizedStringResource {
            LocalizedStringResource("app.deeplink.load_failed.title", defaultValue: "読み込みに失敗しました", table: "App", bundle: L10n.bundle)
        }
        /// このイベント・公演はまだ同期されていない可能性があります。しばらくしてからもう一度お試しください。 — deeplink.not_found.title のアラートの本文
        static var deeplinkNotFoundMessage: LocalizedStringResource {
            LocalizedStringResource("app.deeplink.not_found.message", defaultValue: "このイベント・公演はまだ同期されていない可能性があります。しばらくしてからもう一度お試しください。", table: "App", bundle: L10n.bundle)
        }
        /// リンク先が見つかりません — 共有されたリンクやウィジェットから開いたイベント・公演が端末のデータに無いときのアラートの見出し
        static var deeplinkNotFoundTitle: LocalizedStringResource {
            LocalizedStringResource("app.deeplink.not_found.title", defaultValue: "リンク先が見つかりません", table: "App", bundle: L10n.bundle)
        }
        /// 最新のデータ更新を取り込めませんでした。これまでのデータのまま使えます (次に起動したときにもう一度試します)。\n(詳細: {detail}) — reseed_failed.title のアラートの本文。detail はエラーの本文 (訳さない)。再インストールは勧めない (端末にしか無いデータが消える) — 引数: detail (string)
        static func reseedFailedMessage(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("app.reseed_failed.message", defaultValue: "最新のデータ更新を取り込めませんでした。これまでのデータのまま使えます (次に起動したときにもう一度試します)。\n(詳細: \(detail))", table: "App", bundle: L10n.bundle)
        }
        /// データ更新に失敗しました — アプリ更新後にマスタデータの入れ直し (reseed) が失敗したときのアラートの見出し
        static var reseedFailedTitle: LocalizedStringResource {
            LocalizedStringResource("app.reseed_failed.title", defaultValue: "データ更新に失敗しました", table: "App", bundle: L10n.bundle)
        }
        /// 後で — update.title のアラートの閉じるボタン
        static var updateActionLater: LocalizedStringResource {
            LocalizedStringResource("app.update.action.later", defaultValue: "後で", table: "App", bundle: L10n.bundle)
        }
        /// 更新 — update.title のアラートのボタン。App Store を開く
        static var updateActionUpdate: LocalizedStringResource {
            LocalizedStringResource("app.update.action.update", defaultValue: "更新", table: "App", bundle: L10n.bundle)
        }
        /// バージョン {version} が App Store で公開されています。 — update.title のアラートの本文。version は版番号 (例: 2.3.0) — 引数: version (string)
        static func updateMessage(version: String) -> LocalizedStringResource {
            LocalizedStringResource("app.update.message", defaultValue: "バージョン \(version) が App Store で公開されています。", table: "App", bundle: L10n.bundle)
        }
        /// 新しいバージョンがあります — App Store に新しい版が出ているときに起動時に出すアラートの見出し
        static var updateTitle: LocalizedStringResource {
            LocalizedStringResource("app.update.title", defaultValue: "新しいバージョンがあります", table: "App", bundle: L10n.bundle)
        }
    }
}
