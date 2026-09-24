// 生成物: i18n/catalog/about.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/about.json の文言 (表 About)
    enum About {
        /// 歌詞は JASRAC の許諾を受けて掲載しています。 — 「アプリについて」のライセンス情報の節。JASRAC の許諾番号 (JASRAC許諾第…号。許諾書の指定の表記なので訳さない) の下の説明
        static var jasracCaption: LocalizedStringResource {
            LocalizedStringResource("about.jasrac.caption", defaultValue: "歌詞は JASRAC の許諾を受けて掲載しています。", table: "About", bundle: L10n.bundle)
        }
        /// アプリ情報 — iOS の「アプリについて」画面 (AboutView)の節の見出し。プライバシーポリシー・利用規約・サポート・評価
        static var mainAppInfoHeader: LocalizedStringResource {
            LocalizedStringResource("about.main.app_info.header", defaultValue: "アプリ情報", table: "About", bundle: L10n.bundle)
        }
        /// アプリを評価する — iOS の「アプリについて」画面 (AboutView)。App Store のレビュー投稿画面を開くリンク
        static var mainAppInfoRate: LocalizedStringResource {
            LocalizedStringResource("about.main.app_info.rate", defaultValue: "アプリを評価する", table: "About", bundle: L10n.bundle)
        }
        /// 担当・お気に入り・メモは iCloud に自動バックアップされ、再インストールや機種変更でも復元されます (同じ Apple ID でのサインインが必要)。 — iOS の「アプリについて」画面 (AboutView)の下の方の注記
        static var mainBackupNote: LocalizedStringResource {
            LocalizedStringResource("about.main.backup_note", defaultValue: "担当・お気に入り・メモは iCloud に自動バックアップされ、再インストールや機種変更でも復元されます (同じ Apple ID でのサインインが必要)。", table: "About", bundle: L10n.bundle)
        }
        /// GitHub プロフィール — iOS の「アプリについて」画面 (AboutView)の開発者の節。開発者の GitHub のページを開くリンク
        static var mainDeveloperGithub: LocalizedStringResource {
            LocalizedStringResource("about.main.developer.github", defaultValue: "GitHub プロフィール", table: "About", bundle: L10n.bundle)
        }
        /// 開発者 — iOS の「アプリについて」画面 (AboutView)の節の見出し
        static var mainDeveloperHeader: LocalizedStringResource {
            LocalizedStringResource("about.main.developer.header", defaultValue: "開発者", table: "About", bundle: L10n.bundle)
        }
        /// 開発者 — iOS の「アプリについて」画面 (AboutView)の行の左の項目名。右に開発者名 (fuga-if) が出る
        static var mainDeveloperLabel: LocalizedStringResource {
            LocalizedStringResource("about.main.developer.label", defaultValue: "開発者", table: "About", bundle: L10n.bundle)
        }
        /// 本アプリはアイドルマスターシリーズの非公式ファンメイドアプリです。バンダイナムコエンターテインメント等の権利者とは一切関係ありません。 — iOS の「アプリについて」画面 (AboutView)の最下部の権利表記。会社名は訳さず、ko では各社の正式な英字表記を使う (カタカナは韓国語の利用者が読めないため。訳ではなく自社名の表記。この読み方はオーナーの確認待ち)
        static var mainDisclaimer: LocalizedStringResource {
            LocalizedStringResource("about.main.disclaimer", defaultValue: "本アプリはアイドルマスターシリーズの非公式ファンメイドアプリです。バンダイナムコエンターテインメント等の権利者とは一切関係ありません。", table: "About", bundle: L10n.bundle)
        }
        /// 開発をサポートする — iOS の「アプリについて」画面 (AboutView)。寄付 (Ko-fi) のページを開くリンク
        static var mainDonateAction: LocalizedStringResource {
            LocalizedStringResource("about.main.donate.action", defaultValue: "開発をサポートする", table: "About", bundle: L10n.bundle)
        }
        /// サーバー運用費等の足しにさせていただきます。任意のご支援です。 — iOS の「アプリについて」画面 (AboutView)。寄付のリンクの下の注記
        static var mainDonateFooter: LocalizedStringResource {
            LocalizedStringResource("about.main.donate.footer", defaultValue: "サーバー運用費等の足しにさせていただきます。任意のご支援です。", table: "About", bundle: L10n.bundle)
        }
        /// ライセンス情報 — iOS の「アプリについて」画面 (AboutView)の節の見出し。JASRAC の許諾と使っているライブラリ
        static var mainLicensesHeader: LocalizedStringResource {
            LocalizedStringResource("about.main.licenses.header", defaultValue: "ライセンス情報", table: "About", bundle: L10n.bundle)
        }
        /// 各情報源のデータはそのままの複製ではなく、独自の集計・整形を加えて利用しています。 — iOS の「アプリについて」画面 (AboutView)のデータ提供の節の下の注記
        static var mainSourcesFooter: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.footer", defaultValue: "各情報源のデータはそのままの複製ではなく、独自の集計・整形を加えて利用しています。", table: "About", bundle: L10n.bundle)
        }
        /// データ提供 — iOS の「アプリについて」画面 (AboutView)の節の見出し。データの参照元サイトの一覧
        static var mainSourcesHeader: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.header", defaultValue: "データ提供", table: "About", bundle: L10n.bundle)
        }
        /// 楽曲・ライブ等のデータ参照元 — iOS の「アプリについて」画面 (AboutView)のデータ提供の節。サイト「アイマスDB」の説明 (サイト名は訳さない)
        static var mainSourcesImasDb: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.imas_db", defaultValue: "楽曲・ライブ等のデータ参照元", table: "About", bundle: L10n.bundle)
        }
        /// アイドルのイメージカラー — iOS の「アプリについて」画面 (AboutView)のデータ提供の節。imas-palette の説明
        static var mainSourcesImasPalette: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.imas_palette", defaultValue: "アイドルのイメージカラー", table: "About", bundle: L10n.bundle)
        }
        /// アイドルのプロフィール (CV・カラー等) — iOS の「アプリについて」画面 (AboutView)のデータ提供の節。im@sparql の説明。CV = 声優
        static var mainSourcesImasparql: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.imasparql", defaultValue: "アイドルのプロフィール (CV・カラー等)", table: "About", bundle: L10n.bundle)
        }
        /// 楽曲・ライブセトリのデータ参照元 — iOS の「アプリについて」画面 (AboutView)のデータ提供の節。サイト music765plus の説明
        static var mainSourcesMusic765plus: LocalizedStringResource {
            LocalizedStringResource("about.main.sources.music765plus", defaultValue: "楽曲・ライブセトリのデータ参照元", table: "About", bundle: L10n.bundle)
        }
        /// 非公式ファンメイドアプリ — iOS の「アプリについて」画面 (AboutView)の先頭、アプリ名 (ImasLiveDB) の下の一言
        static var mainTagline: LocalizedStringResource {
            LocalizedStringResource("about.main.tagline", defaultValue: "非公式ファンメイドアプリ", table: "About", bundle: L10n.bundle)
        }
        /// アプリについて — iOS の「アプリについて」画面 (AboutView)のナビゲーションタイトル
        static var mainTitle: LocalizedStringResource {
            LocalizedStringResource("about.main.title", defaultValue: "アプリについて", table: "About", bundle: L10n.bundle)
        }
        /// プライバシーポリシー — プライバシーポリシーの画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー
        static var privacyTitle: LocalizedStringResource {
            LocalizedStringResource("about.privacy.title", defaultValue: "プライバシーポリシー", table: "About", bundle: L10n.bundle)
        }
        /// Apple Music のデータベースに登録されていない楽曲は画像が表示されません。また、MusicKit の利用には Apple Music サブスクリプションまたは無料トライアルが必要な場合があります。 — サポート画面のよくある質問の答え (iOS)。前に「A. 」が付く。Android は answer_android
        static var supportFaqArtworkAnswerIos: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.artwork.answer_ios", defaultValue: "Apple Music のデータベースに登録されていない楽曲は画像が表示されません。また、MusicKit の利用には Apple Music サブスクリプションまたは無料トライアルが必要な場合があります。", table: "About", bundle: L10n.bundle)
        }
        /// ジャケット画像が表示されない — サポート画面のよくある質問。前に「Q. 」が付く
        static var supportFaqArtworkQuestion: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.artwork.question", defaultValue: "ジャケット画像が表示されない", table: "About", bundle: L10n.bundle)
        }
        /// よくある質問 — サポート画面の節の見出し (Q&A)
        static var supportFaqHeader: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.header", defaultValue: "よくある質問", table: "About", bundle: L10n.bundle)
        }
        /// 設定 > プライバシーとセキュリティ > 音声認識・カメラ で本アプリへのアクセスを許可してください。 — サポート画面のよくある質問の答え (iOS だけ)。前に「A. 」が付く。「設定 > …」は iOS の設定アプリの道順 (ko は韓国語の iOS の表示に合わせる)
        static var supportFaqScannerAnswer: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.scanner.answer", defaultValue: "設定 > プライバシーとセキュリティ > 音声認識・カメラ で本アプリへのアクセスを許可してください。", table: "About", bundle: L10n.bundle)
        }
        /// セットリストスキャナーが認識しない — サポート画面のよくある質問 (iOS だけ)。前に「Q. 」が付く
        static var supportFaqScannerQuestion: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.scanner.question", defaultValue: "セットリストスキャナーが認識しない", table: "About", bundle: L10n.bundle)
        }
        /// GitHub Issue または コミュニティ機能の「修正提案」からご報告ください。確認後に反映します。 — サポート画面のよくある質問の答え。前に「A. 」が付く
        static var supportFaqStaleDataAnswer: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.stale_data.answer", defaultValue: "GitHub Issue または コミュニティ機能の「修正提案」からご報告ください。確認後に反映します。", table: "About", bundle: L10n.bundle)
        }
        /// データが古い・間違っている — サポート画面のよくある質問。前に「Q. 」が付く
        static var supportFaqStaleDataQuestion: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.stale_data.question", defaultValue: "データが古い・間違っている", table: "About", bundle: L10n.bundle)
        }
        /// iCloud にサインインしているか、設定 > Apple ID > iCloud で「ImasLiveDB」が有効になっているかご確認ください。 — サポート画面のよくある質問の答え (iOS)。前に「A. 」が付く。「設定 > …」は iOS の設定アプリの道順 (ko は韓国語の iOS の表示に合わせる)
        static var supportFaqSyncAnswerIos: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.sync.answer_ios", defaultValue: "iCloud にサインインしているか、設定 > Apple ID > iCloud で「ImasLiveDB」が有効になっているかご確認ください。", table: "About", bundle: L10n.bundle)
        }
        /// CloudKit 同期に失敗する — サポート画面のよくある質問 (iOS)。前に「Q. 」が付く。Android は question_android
        static var supportFaqSyncQuestionIos: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.sync.question_ios", defaultValue: "CloudKit 同期に失敗する", table: "About", bundle: L10n.bundle)
        }
        /// はい、本アプリは非公式のファンメイドアプリです。バンダイナムコエンターテインメント等とは一切関係ありません。 — サポート画面のよくある質問の答え。前に「A. 」が付く。会社名は訳さず、ko では各社の正式な英字表記を使う (カタカナは韓国語の利用者が読めないため。訳ではなく自社名の表記。この読み方はオーナーの確認待ち)
        static var supportFaqUnofficialAnswer: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.unofficial.answer", defaultValue: "はい、本アプリは非公式のファンメイドアプリです。バンダイナムコエンターテインメント等とは一切関係ありません。", table: "About", bundle: L10n.bundle)
        }
        /// アプリが公式アプリではないのですか? — サポート画面のよくある質問。前に「Q. 」が付く
        static var supportFaqUnofficialQuestion: LocalizedStringResource {
            LocalizedStringResource("about.support.faq.unofficial.question", defaultValue: "アプリが公式アプリではないのですか?", table: "About", bundle: L10n.bundle)
        }
        /// GitHub Issue で報告する — サポート画面。GitHub の Issue 作成ページを開くリンク
        static var supportFeedbackGithub: LocalizedStringResource {
            LocalizedStringResource("about.support.feedback.github", defaultValue: "GitHub Issue で報告する", table: "About", bundle: L10n.bundle)
        }
        /// フィードバック・バグ報告 — サポート画面の節の見出し
        static var supportFeedbackHeader: LocalizedStringResource {
            LocalizedStringResource("about.support.feedback.header", defaultValue: "フィードバック・バグ報告", table: "About", bundle: L10n.bundle)
        }
        /// サポート — サポート (問い合わせ・よくある質問) の画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー
        static var supportTitle: LocalizedStringResource {
            LocalizedStringResource("about.support.title", defaultValue: "サポート", table: "About", bundle: L10n.bundle)
        }
        /// 利用規約 — 利用規約の画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー
        static var termsTitle: LocalizedStringResource {
            LocalizedStringResource("about.terms.title", defaultValue: "利用規約", table: "About", bundle: L10n.bundle)
        }
    }
}
