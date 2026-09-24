// 生成物: i18n/catalog/share.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/share.json の文言 (表 Share)
    enum Share {
        /// 画像を準備中… — シェアボタン。カードに焼くジャケ写を読み込んでいる間 (押せない)
        static var actionPreparing: LocalizedStringResource {
            LocalizedStringResource("share.action.preparing", defaultValue: "画像を準備中…", table: "Share", bundle: L10n.bundle)
        }
        /// シェアする — シェアカードの下のボタン (OS の共有シートを開く)
        static var actionShare: LocalizedStringResource {
            LocalizedStringResource("share.action.share", defaultValue: "シェアする", table: "Share", bundle: L10n.bundle)
        }
        /// 楽曲回収率 — 回収率カードの左上の種別ラベル
        static var collectionBadge: LocalizedStringResource {
            LocalizedStringResource("share.collection.badge", defaultValue: "楽曲回収率", table: "Share", bundle: L10n.bundle)
        }
        /// {collected}/{total}曲 — 回収率カードの担当アイドルごとの行の右。collected は回収した曲数 (桁区切り済みの文字列)、total はその担当のオリジナル曲数。1000 以上は桁区切りが付く — 引数: collected (string), total (count)
        static func collectionIdolCount(collected: String, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("share.collection.idol_count", defaultValue: "\(collected)/\(total)曲", table: "Share", bundle: L10n.bundle)
        }
        /// ライブで聴けた曲 — 回収率カードの大きな % の上の見出し
        static var collectionLead: LocalizedStringResource {
            LocalizedStringResource("share.collection.lead", defaultValue: "ライブで聴けた曲", table: "Share", bundle: L10n.bundle)
        }
        /// 回収率をシェア — 回収率カードのシートの見出し
        static var collectionSheetTitle: LocalizedStringResource {
            LocalizedStringResource("share.collection.sheet_title", defaultValue: "回収率をシェア", table: "Share", bundle: L10n.bundle)
        }
        /// {collected} / {total} 曲を回収 — 回収率カードの大きな % の下。collected は回収した曲数 (桁区切り済みの文字列)、total は全曲数。どちらも 1000 以上は桁区切りが付く (iOS は従来どおり、Android は今回から) — 引数: collected (string), total (count)
        static func collectionSummary(collected: String, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("share.collection.summary", defaultValue: "\(collected) / \(total) 曲を回収", table: "Share", bundle: L10n.bundle)
        }
        /// セトリの感想 — 感想カードの左上の種別ラベル
        static var commentBadge: LocalizedStringResource {
            LocalizedStringResource("share.comment.badge", defaultValue: "セトリの感想", table: "Share", bundle: L10n.bundle)
        }
        /// この曲の感想 — 感想の入力欄の上の見出し
        static var commentFieldLabel: LocalizedStringResource {
            LocalizedStringResource("share.comment.field_label", defaultValue: "この曲の感想", table: "Share", bundle: L10n.bundle)
        }
        /// 最高だった！ 泣いた…など — 感想の入力欄のプレースホルダ。書き方の例も訳す
        static var commentFieldPlaceholder: LocalizedStringResource {
            LocalizedStringResource("share.comment.field_placeholder", defaultValue: "最高だった！ 泣いた…など", table: "Share", bundle: L10n.bundle)
        }
        /// ここに感想が入ります — 感想カードのプレビュー。感想をまだ書いていないときに出す見本の文
        static var commentPlaceholderCard: LocalizedStringResource {
            LocalizedStringResource("share.comment.placeholder_card", defaultValue: "ここに感想が入ります", table: "Share", bundle: L10n.bundle)
        }
        /// 感想カードを作る — 感想カードのシートの見出し
        static var commentSheetTitle: LocalizedStringResource {
            LocalizedStringResource("share.comment.sheet_title", defaultValue: "感想カードを作る", table: "Share", bundle: L10n.bundle)
        }
        /// #アイドルライブDB — 全カード共通のフッターのハッシュタグ (SNS からの流入導線)。SNS で検索される識別子なので、どの言語でも訳さずそのまま出し、シェアが 1 つのタグに集まるようにする。言語ごとに別のタグにするかはオーナーが決める (変えるならここの訳を上書きする)
        static var footerHashtag: LocalizedStringResource {
            LocalizedStringResource("share.footer.hashtag", defaultValue: "#アイドルライブDB", table: "Share", bundle: L10n.bundle)
        }
        /// 縦長 — カードの縦横比の補助ラベル (4:5)
        static var ratioPortrait: LocalizedStringResource {
            LocalizedStringResource("share.ratio.portrait", defaultValue: "縦長", table: "Share", bundle: L10n.bundle)
        }
        /// 正方形 — カードの縦横比の補助ラベル (1:1)
        static var ratioSquare: LocalizedStringResource {
            LocalizedStringResource("share.ratio.square", defaultValue: "正方形", table: "Share", bundle: L10n.bundle)
        }
        /// ストーリーズ — カードの縦横比の補助ラベル (9:16、SNS のストーリーズ向け)
        static var ratioStory: LocalizedStringResource {
            LocalizedStringResource("share.ratio.story", defaultValue: "ストーリーズ", table: "Share", bundle: L10n.bundle)
        }
        /// もう一度試すか、アプリを再起動してください。 — カードを画像にできなかったときのアラートの本文
        static var renderErrorMessage: LocalizedStringResource {
            LocalizedStringResource("share.render_error.message", defaultValue: "もう一度試すか、アプリを再起動してください。", table: "Share", bundle: L10n.bundle)
        }
        /// シェア画像の生成に失敗しました — カードを画像にできなかったとき。iOS はアラートの見出し、Android はトースト
        static var renderErrorTitle: LocalizedStringResource {
            LocalizedStringResource("share.render_error.title", defaultValue: "シェア画像の生成に失敗しました", table: "Share", bundle: L10n.bundle)
        }
        /// その他でシェア — テキストシェアのメニュー項目 (OS の共有シートを開く)
        static var socialOther: LocalizedStringResource {
            LocalizedStringResource("share.social.other", defaultValue: "その他でシェア", table: "Share", bundle: L10n.bundle)
        }
        /// X にポスト — テキストシェアのメニュー項目 (X の投稿画面を開く)
        static var socialPostX: LocalizedStringResource {
            LocalizedStringResource("share.social.post_x", defaultValue: "X にポスト", table: "Share", bundle: L10n.bundle)
        }
        /// タグを追加しました！ — タグ付与カードの左上の種別ラベル
        static var tagBadge: LocalizedStringResource {
            LocalizedStringResource("share.tag.badge", defaultValue: "タグを追加しました！", table: "Share", bundle: L10n.bundle)
        }
        /// せっかくなのでカードでシェアしませんか？ — タグを付け終えたあとの完了画面の誘い文句 (カードでのシェア)
        static var tagDoneMessage: LocalizedStringResource {
            LocalizedStringResource("share.tag.done.message", defaultValue: "せっかくなのでカードでシェアしませんか？", table: "Share", bundle: L10n.bundle)
        }
        /// タグを付けました！ — タグを付け終えたあとの完了画面の見出し
        static var tagDoneTitle: LocalizedStringResource {
            LocalizedStringResource("share.tag.done.title", defaultValue: "タグを付けました！", table: "Share", bundle: L10n.bundle)
        }
    }
}
