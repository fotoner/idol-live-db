// 生成物: i18n/catalog/share.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/share.json の文言。L10n.Share から引く (iOS の L10n.Share と同じ名前)。 */
object L10nShare {
    /** 画像を準備中… — シェアボタン。カードに焼くジャケ写を読み込んでいる間 (押せない) */
    val actionPreparing: DisplayText get() = DisplayText.Res(R.string.share_action_preparing)
    /** 保存 — シェアカードの下のボタン (端末の写真に保存する) */
    val actionSave: DisplayText get() = DisplayText.Res(R.string.share_action_save)
    /** シェアする — シェアカードの下のボタン (OS の共有シートを開く) */
    val actionShare: DisplayText get() = DisplayText.Res(R.string.share_action_share)
    /** 楽曲回収率 — 回収率カードの左上の種別ラベル */
    val collectionBadge: DisplayText get() = DisplayText.Res(R.string.share_collection_badge)
    /** {collected}/{total}曲 — 回収率カードの担当アイドルごとの行の右。collected は回収した曲数 (桁区切り済みの文字列)、total はその担当のオリジナル曲数。1000 以上は桁区切りが付く — 引数: collected (string), total (count) */
    fun collectionIdolCount(collected: String, total: Int): DisplayText = DisplayText.Plural(R.plurals.share_collection_idol_count, total, listOf(collected, total))
    /** ライブで聴けた曲 — 回収率カードの大きな % の上の見出し */
    val collectionLead: DisplayText get() = DisplayText.Res(R.string.share_collection_lead)
    /** 回収率をシェア — 回収率カードのシートの見出し */
    val collectionSheetTitle: DisplayText get() = DisplayText.Res(R.string.share_collection_sheet_title)
    /** {collected} / {total} 曲を回収 — 回収率カードの大きな % の下。collected は回収した曲数 (桁区切り済みの文字列)、total は全曲数。どちらも 1000 以上は桁区切りが付く (iOS は従来どおり、Android は今回から) — 引数: collected (string), total (count) */
    fun collectionSummary(collected: String, total: Int): DisplayText = DisplayText.Plural(R.plurals.share_collection_summary, total, listOf(collected, total))
    /** セトリの感想 — 感想カードの左上の種別ラベル */
    val commentBadge: DisplayText get() = DisplayText.Res(R.string.share_comment_badge)
    /** この曲の感想 — 感想の入力欄の上の見出し */
    val commentFieldLabel: DisplayText get() = DisplayText.Res(R.string.share_comment_field_label)
    /** 最高だった！ 泣いた…など — 感想の入力欄のプレースホルダ。書き方の例も訳す */
    val commentFieldPlaceholder: DisplayText get() = DisplayText.Res(R.string.share_comment_field_placeholder)
    /** ここに感想が入ります — 感想カードのプレビュー。感想をまだ書いていないときに出す見本の文 */
    val commentPlaceholderCard: DisplayText get() = DisplayText.Res(R.string.share_comment_placeholder_card)
    /** 感想カードを作る — 感想カードのシートの見出し */
    val commentSheetTitle: DisplayText get() = DisplayText.Res(R.string.share_comment_sheet_title)
    /** #アイドルライブDB — 全カード共通のフッターのハッシュタグ (SNS からの流入導線)。SNS で検索される識別子なので、どの言語でも訳さずそのまま出し、シェアが 1 つのタグに集まるようにする。言語ごとに別のタグにするかはオーナーが決める (変えるならここの訳を上書きする) */
    val footerHashtag: DisplayText get() = DisplayText.Res(R.string.share_footer_hashtag)
    /** 縦長 — カードの縦横比の補助ラベル (4:5) */
    val ratioPortrait: DisplayText get() = DisplayText.Res(R.string.share_ratio_portrait)
    /** 正方形 — カードの縦横比の補助ラベル (1:1) */
    val ratioSquare: DisplayText get() = DisplayText.Res(R.string.share_ratio_square)
    /** ストーリーズ — カードの縦横比の補助ラベル (9:16、SNS のストーリーズ向け) */
    val ratioStory: DisplayText get() = DisplayText.Res(R.string.share_ratio_story)
    /** シェア画像の生成に失敗しました — カードを画像にできなかったとき。iOS はアラートの見出し、Android はトースト */
    val renderErrorTitle: DisplayText get() = DisplayText.Res(R.string.share_render_error_title)
    /** 画像を保存しました — 保存先を選んで画像を保存できたときのトースト (Android 9 以下) */
    val saveDone: DisplayText get() = DisplayText.Res(R.string.share_save_done)
    /** ピクチャに保存しました — 画像を端末のピクチャ (Pictures フォルダ) に保存できたときのトースト */
    val saveDonePictures: DisplayText get() = DisplayText.Res(R.string.share_save_done_pictures)
    /** 保存に失敗しました — 画像を保存できなかったときのトースト */
    val saveFailed: DisplayText get() = DisplayText.Res(R.string.share_save_failed)
    /** その他でシェア — テキストシェアのメニュー項目 (OS の共有シートを開く) */
    val socialOther: DisplayText get() = DisplayText.Res(R.string.share_social_other)
    /** X にポスト — テキストシェアのメニュー項目 (X の投稿画面を開く) */
    val socialPostX: DisplayText get() = DisplayText.Res(R.string.share_social_post_x)
    /** シェア — シェアのアイコンボタンの読み上げの既定 */
    val socialShareA11y: DisplayText get() = DisplayText.Res(R.string.share_social_share_a11y)
    /** タグを追加しました！ — タグ付与カードの左上の種別ラベル */
    val tagBadge: DisplayText get() = DisplayText.Res(R.string.share_tag_badge)
    /** せっかくなのでカードでシェアしませんか？ — タグを付け終えたあとの完了画面の誘い文句 (カードでのシェア) */
    val tagDoneMessage: DisplayText get() = DisplayText.Res(R.string.share_tag_done_message)
    /** タグを付けました！ — タグを付け終えたあとの完了画面の見出し */
    val tagDoneTitle: DisplayText get() = DisplayText.Res(R.string.share_tag_done_title)
}
