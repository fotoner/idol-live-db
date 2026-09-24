// 生成物: i18n/catalog/legal.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/legal.json の文言 (表 Legal)
    enum Legal {
        /// • 端末識別子（UUID）: Keychain に保存される匿名の識別子です。個人情報と紐付けることはありません。\n• アプリ設定: お気に入りブランドなどの設定は UserDefaults に端末内のみ保存されます。\n• CloudKit 投稿内容: コミュニティ機能を利用する場合、Apple ID による認証が必要です。投稿したセットリスト・修正提案などのコンテンツは CloudKit Public Database に保存・公開されます。 — プライバシーポリシー「収集するデータ」の本文 (iOS。箇条書き 3 行)。Android は body_android。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyCollectedBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.collected.body_ios", defaultValue: "• 端末識別子（UUID）: Keychain に保存される匿名の識別子です。個人情報と紐付けることはありません。\n• アプリ設定: お気に入りブランドなどの設定は UserDefaults に端末内のみ保存されます。\n• CloudKit 投稿内容: コミュニティ機能を利用する場合、Apple ID による認証が必要です。投稿したセットリスト・修正提案などのコンテンツは CloudKit Public Database に保存・公開されます。", table: "Legal", bundle: L10n.bundle)
        }
        /// 収集するデータ — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyCollectedHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.collected.header", defaultValue: "収集するデータ", table: "Legal", bundle: L10n.bundle)
        }
        /// プライバシーに関するお問い合わせ・データ削除依頼は下記 GitHub Issue からお願いします。\nhttps://github.com/fuga-if/imas-live-privacy/issues/new — プライバシーポリシー「連絡先」の本文。2 行目の URL は変えない。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyContactBody: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.contact.body", defaultValue: "プライバシーに関するお問い合わせ・データ削除依頼は下記 GitHub Issue からお願いします。\nhttps://github.com/fuga-if/imas-live-privacy/issues/new", table: "Legal", bundle: L10n.bundle)
        }
        /// 連絡先 — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyContactHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.contact.header", defaultValue: "連絡先", table: "Legal", bundle: L10n.bundle)
        }
        /// • CloudKit: コミュニティデータの同期・投稿\n• MusicKit: Apple Music からのジャケット画像取得\n• Speech（音声認識）: セットリストスキャン機能\n• Vision: OCR によるセットリスト読み取り — プライバシーポリシー「使用する Apple フレームワーク」の本文 (iOS だけ。箇条書き 4 行。フレームワーク名は訳さない)。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyFrameworksBody: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.frameworks.body", defaultValue: "• CloudKit: コミュニティデータの同期・投稿\n• MusicKit: Apple Music からのジャケット画像取得\n• Speech（音声認識）: セットリストスキャン機能\n• Vision: OCR によるセットリスト読み取り", table: "Legal", bundle: L10n.bundle)
        }
        /// 使用する Apple フレームワーク — プライバシーポリシーの節の見出し (iOS だけ)。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyFrameworksHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.frameworks.header", defaultValue: "使用する Apple フレームワーク", table: "Legal", bundle: L10n.bundle)
        }
        /// 最終更新日: 2026年4月23日 — プライバシーポリシーの末尾の最終更新日。日付は文書の版の一部なので引数にしない (改訂したら ja ごと直す)。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyLastUpdated: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.last_updated", defaultValue: "最終更新日: 2026年4月23日", table: "Legal", bundle: L10n.bundle)
        }
        /// 本アプリ（ImasLiveDB）は、アイドルマスターシリーズのライブ・セットリスト情報を管理・閲覧するための非公式ファンメイドアプリです。株式会社バンダイナムコエンターテインメントをはじめとする権利者とは一切関係ありません。 — プライバシーポリシー「アプリの概要」の本文。会社名は訳さず、ko では各社の正式な英字表記を使う (カタカナは韓国語の利用者が読めないため。訳ではなく自社名の表記。この読み方はオーナーの確認待ち)。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyOverviewBody: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.overview.body", defaultValue: "本アプリ（ImasLiveDB）は、アイドルマスターシリーズのライブ・セットリスト情報を管理・閲覧するための非公式ファンメイドアプリです。株式会社バンダイナムコエンターテインメントをはじめとする権利者とは一切関係ありません。", table: "Legal", bundle: L10n.bundle)
        }
        /// アプリの概要 — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyOverviewHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.overview.header", defaultValue: "アプリの概要", table: "Legal", bundle: L10n.bundle)
        }
        /// 投稿データの削除を希望される場合は、GitHub Issue にてご連絡ください。対応いたします。 — プライバシーポリシー「ユーザーの権利」の本文 (iOS)。Android は body_android。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyRightsBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.rights.body_ios", defaultValue: "投稿データの削除を希望される場合は、GitHub Issue にてご連絡ください。対応いたします。", table: "Legal", bundle: L10n.bundle)
        }
        /// ユーザーの権利 — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyRightsHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.rights.header", defaultValue: "ユーザーの権利", table: "Legal", bundle: L10n.bundle)
        }
        /// コミュニティ機能で投稿したコンテンツ（セットリスト報告・修正提案など）は CloudKit Public Database を通じて他のユーザーに公開されます。投稿内容に個人情報を含めないようご注意ください。 — プライバシーポリシー「データの共有」の本文 (iOS)。Android は body_android。参考訳。release に上げる前にオーナーの確認が要る
        static var privacySharingBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.sharing.body_ios", defaultValue: "コミュニティ機能で投稿したコンテンツ（セットリスト報告・修正提案など）は CloudKit Public Database を通じて他のユーザーに公開されます。投稿内容に個人情報を含めないようご注意ください。", table: "Legal", bundle: L10n.bundle)
        }
        /// データの共有 — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacySharingHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.sharing.header", defaultValue: "データの共有", table: "Legal", bundle: L10n.bundle)
        }
        /// • Cloudflare Workers: アプリの API 通信先として利用しています。\n• Apple Music: ジャケット画像の取得に MusicKit API を利用しています（正式な Apple のサービスです）。 — プライバシーポリシー「サードパーティサービス」の本文 (iOS。箇条書き 2 行)。Android は body_android。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyThirdPartyBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.third_party.body_ios", defaultValue: "• Cloudflare Workers: アプリの API 通信先として利用しています。\n• Apple Music: ジャケット画像の取得に MusicKit API を利用しています（正式な Apple のサービスです）。", table: "Legal", bundle: L10n.bundle)
        }
        /// サードパーティサービス — プライバシーポリシーの節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var privacyThirdPartyHeader: LocalizedStringResource {
            LocalizedStringResource("legal.privacy.third_party.header", defaultValue: "サードパーティサービス", table: "Legal", bundle: L10n.bundle)
        }
        /// ご意見・不具合報告は GitHub Issue にてご連絡ください。\nhttps://github.com/fuga-if/imas-live-privacy/issues/new — 利用規約「連絡先」の本文。2 行目の URL は変えない。参考訳。release に上げる前にオーナーの確認が要る
        static var termsContactBody: LocalizedStringResource {
            LocalizedStringResource("legal.terms.contact.body", defaultValue: "ご意見・不具合報告は GitHub Issue にてご連絡ください。\nhttps://github.com/fuga-if/imas-live-privacy/issues/new", table: "Legal", bundle: L10n.bundle)
        }
        /// 連絡先 — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsContactHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.contact.header", defaultValue: "連絡先", table: "Legal", bundle: L10n.bundle)
        }
        /// ユーザーが投稿したコンテンツは CloudKit Public Database に保存され、本アプリを利用する他のユーザーに公開されます。投稿することで、当該コンテンツをアプリ内で表示・利用することに同意したものとみなします。 — 利用規約「投稿コンテンツのライセンス」の本文 (iOS)。Android は body_android。参考訳。release に上げる前にオーナーの確認が要る
        static var termsContentLicenseBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.terms.content_license.body_ios", defaultValue: "ユーザーが投稿したコンテンツは CloudKit Public Database に保存され、本アプリを利用する他のユーザーに公開されます。投稿することで、当該コンテンツをアプリ内で表示・利用することに同意したものとみなします。", table: "Legal", bundle: L10n.bundle)
        }
        /// 投稿コンテンツのライセンス — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsContentLicenseHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.content_license.header", defaultValue: "投稿コンテンツのライセンス", table: "Legal", bundle: L10n.bundle)
        }
        /// 本アプリは非公式のファン制作アプリです。株式会社バンダイナムコエンターテインメント、株式会社バンダイナムコミュージックライブ、その他アイドルマスターシリーズに関わる権利者とは一切関係ありません。 — 利用規約「免責・権利表記」の本文。会社名は訳さず、ko では各社の正式な英字表記を使う (カタカナは韓国語の利用者が読めないため。訳ではなく自社名の表記。社名の中の「ライブ」も訳さない。この読み方はオーナーの確認待ち)。参考訳。release に上げる前にオーナーの確認が要る
        static var termsDisclaimerBody: LocalizedStringResource {
            LocalizedStringResource("legal.terms.disclaimer.body", defaultValue: "本アプリは非公式のファン制作アプリです。株式会社バンダイナムコエンターテインメント、株式会社バンダイナムコミュージックライブ、その他アイドルマスターシリーズに関わる権利者とは一切関係ありません。", table: "Legal", bundle: L10n.bundle)
        }
        /// 免責・権利表記 — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsDisclaimerHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.disclaimer.header", defaultValue: "免責・権利表記", table: "Legal", bundle: L10n.bundle)
        }
        /// アイドルマスターシリーズおよび関連するキャラクター・楽曲・ロゴ・イラスト等の著作権・商標権はすべて各権利者に帰属します。本アプリはこれらを無断で使用・複製・配布しません。 — 利用規約「知的財産権」の本文。参考訳。release に上げる前にオーナーの確認が要る
        static var termsIpBody: LocalizedStringResource {
            LocalizedStringResource("legal.terms.ip.body", defaultValue: "アイドルマスターシリーズおよび関連するキャラクター・楽曲・ロゴ・イラスト等の著作権・商標権はすべて各権利者に帰属します。本アプリはこれらを無断で使用・複製・配布しません。", table: "Legal", bundle: L10n.bundle)
        }
        /// 知的財産権 — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsIpHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.ip.header", defaultValue: "知的財産権", table: "Legal", bundle: L10n.bundle)
        }
        /// 最終更新日: 2026年4月23日 — 利用規約の末尾の最終更新日。日付は文書の版の一部なので引数にしない (改訂したら ja ごと直す)。参考訳。release に上げる前にオーナーの確認が要る
        static var termsLastUpdated: LocalizedStringResource {
            LocalizedStringResource("legal.terms.last_updated", defaultValue: "最終更新日: 2026年4月23日", table: "Legal", bundle: L10n.bundle)
        }
        /// • ジャケット画像: Apple Music の正式 API（MusicKit）経由で取得したもののみを表示しています。\n• 歌詞: 使用していません。\n• キャラクターイラスト: 使用していません。\n• 公式ロゴ: 使用していません。 — 利用規約「使用している素材について」の本文 (iOS。箇条書き 4 行)。Android は body_android。「歌詞: 使用していません」は歌詞機能 (JASRAC 許諾) と食い違うが、文面を直すのはオーナー (移行では ja を変えない)。参考訳。release に上げる前にオーナーの確認が要る
        static var termsMaterialsBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.terms.materials.body_ios", defaultValue: "• ジャケット画像: Apple Music の正式 API（MusicKit）経由で取得したもののみを表示しています。\n• 歌詞: 使用していません。\n• キャラクターイラスト: 使用していません。\n• 公式ロゴ: 使用していません。", table: "Legal", bundle: L10n.bundle)
        }
        /// 使用している素材について — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsMaterialsHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.materials.header", defaultValue: "使用している素材について", table: "Legal", bundle: L10n.bundle)
        }
        /// 以下の行為を禁止します。\n• 他者の著作権・商標権・プライバシーを侵害するコンテンツの投稿\n• 他のユーザーへの嫌がらせ・誹謗中傷\n• スパムや虚偽情報の投稿\n• 本アプリのシステムへの不正アクセス・改ざん — 利用規約「禁止事項」の本文 (iOS。1 行の前置きと箇条書き 4 行)。Android は body_android (行頭の記号だけ違う)。参考訳。release に上げる前にオーナーの確認が要る
        static var termsProhibitedBodyIos: LocalizedStringResource {
            LocalizedStringResource("legal.terms.prohibited.body_ios", defaultValue: "以下の行為を禁止します。\n• 他者の著作権・商標権・プライバシーを侵害するコンテンツの投稿\n• 他のユーザーへの嫌がらせ・誹謗中傷\n• スパムや虚偽情報の投稿\n• 本アプリのシステムへの不正アクセス・改ざん", table: "Legal", bundle: L10n.bundle)
        }
        /// 禁止事項 — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsProhibitedHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.prohibited.header", defaultValue: "禁止事項", table: "Legal", bundle: L10n.bundle)
        }
        /// 開発者は予告なくアプリの機能変更・サービス停止を行う場合があります。これによって生じた損害について開発者は責任を負いません。 — 利用規約「サービスの変更・停止」の本文。参考訳。release に上げる前にオーナーの確認が要る
        static var termsServiceChangesBody: LocalizedStringResource {
            LocalizedStringResource("legal.terms.service_changes.body", defaultValue: "開発者は予告なくアプリの機能変更・サービス停止を行う場合があります。これによって生じた損害について開発者は責任を負いません。", table: "Legal", bundle: L10n.bundle)
        }
        /// サービスの変更・停止 — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsServiceChangesHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.service_changes.header", defaultValue: "サービスの変更・停止", table: "Legal", bundle: L10n.bundle)
        }
        /// コミュニティ機能への投稿（セットリスト情報・修正提案など）は、ユーザー自身の責任において行ってください。投稿コンテンツに起因する問題について、開発者は責任を負いません。 — 利用規約「ユーザー投稿コンテンツ」の本文。参考訳。release に上げる前にオーナーの確認が要る
        static var termsUserContentBody: LocalizedStringResource {
            LocalizedStringResource("legal.terms.user_content.body", defaultValue: "コミュニティ機能への投稿（セットリスト情報・修正提案など）は、ユーザー自身の責任において行ってください。投稿コンテンツに起因する問題について、開発者は責任を負いません。", table: "Legal", bundle: L10n.bundle)
        }
        /// ユーザー投稿コンテンツ — 利用規約の節の見出し。参考訳。release に上げる前にオーナーの確認が要る
        static var termsUserContentHeader: LocalizedStringResource {
            LocalizedStringResource("legal.terms.user_content.header", defaultValue: "ユーザー投稿コンテンツ", table: "Legal", bundle: L10n.bundle)
        }
    }
}
