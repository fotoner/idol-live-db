// 生成物: i18n/catalog/about.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/about.json の文言。L10n.About から引く (iOS の L10n.About と同じ名前)。 */
object L10nAbout {
    /** iOS 版と共有する自作のコアライブラリです。外部ライセンスはありません。 — オープンソースライセンス画面。imas-core のライセンス欄 (Android) */
    val ossCoreLicense: DisplayText get() = DisplayText.Res(R.string.about_oss_core_license)
    /** 本アプリの一部 (Rust) — オープンソースライセンス画面。imas-core (自作のコアライブラリ) の作者欄 (Android) */
    val ossCoreOwner: DisplayText get() = DisplayText.Res(R.string.about_oss_core_owner)
    /** 本アプリは以下のオープンソースソフトウェアを利用しています。各ライセンスの全文はそれぞれのプロジェクトの配布物に含まれます。 — オープンソースライセンス画面の先頭の説明 (Android) */
    val ossIntro: DisplayText get() = DisplayText.Res(R.string.about_oss_intro)
    /** {owner} ・ {license} — オープンソースライセンス画面の各行の 2 行目 (Android)。owner = 作者 (Google など)、license = ライセンス名。どちらも訳さない名前か、上の oss.core.* の文言 — 引数: owner (text), license (text) */
    fun ossItemMeta(owner: DisplayText, license: DisplayText): DisplayText = DisplayText.Res(R.string.about_oss_item_meta, listOf(owner, license))
    /** Apache License 2.0 / LGPL 2.1 のデュアルライセンス — オープンソースライセンス画面。JNA のライセンスの種類 (Android) */
    val ossJnaLicense: DisplayText get() = DisplayText.Res(R.string.about_oss_jna_license)
    /** オープンソースライセンス — オープンソースライセンスの画面名 (Android。iOS は MyPage の節にある) */
    val ossTitle: DisplayText get() = DisplayText.Res(R.string.about_oss_title)
    /** プライバシーポリシー — プライバシーポリシーの画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー */
    val privacyTitle: DisplayText get() = DisplayText.Res(R.string.about_privacy_title)
    /** 配信ストアのデータベースに登録されていない楽曲は画像が表示されません。 — サポート画面のよくある質問の答え (Android)。前に「A. 」が付く。iOS の answer_ios と ja が違う */
    val supportFaqArtworkAnswerAndroid: DisplayText get() = DisplayText.Res(R.string.about_support_faq_artwork_answer_android)
    /** ジャケット画像が表示されない — サポート画面のよくある質問。前に「Q. 」が付く */
    val supportFaqArtworkQuestion: DisplayText get() = DisplayText.Res(R.string.about_support_faq_artwork_question)
    /** よくある質問 — サポート画面の節の見出し (Q&A) */
    val supportFaqHeader: DisplayText get() = DisplayText.Res(R.string.about_support_faq_header)
    /** GitHub Issue または コミュニティ機能の「修正提案」からご報告ください。確認後に反映します。 — サポート画面のよくある質問の答え。前に「A. 」が付く */
    val supportFaqStaleDataAnswer: DisplayText get() = DisplayText.Res(R.string.about_support_faq_stale_data_answer)
    /** データが古い・間違っている — サポート画面のよくある質問。前に「Q. 」が付く */
    val supportFaqStaleDataQuestion: DisplayText get() = DisplayText.Res(R.string.about_support_faq_stale_data_question)
    /** 通信環境をご確認のうえ、設定画面から「全データ同期」をお試しください。 — サポート画面のよくある質問の答え (Android)。前に「A. 」が付く。「全データ同期」は設定画面のボタンの名前 (settings スライスの訳と揃える) */
    val supportFaqSyncAnswerAndroid: DisplayText get() = DisplayText.Res(R.string.about_support_faq_sync_answer_android)
    /** 同期に失敗する — サポート画面のよくある質問 (Android)。前に「Q. 」が付く。iOS の question_ios と ja が違う */
    val supportFaqSyncQuestionAndroid: DisplayText get() = DisplayText.Res(R.string.about_support_faq_sync_question_android)
    /** はい、本アプリは非公式のファンメイドアプリです。バンダイナムコエンターテインメント等とは一切関係ありません。 — サポート画面のよくある質問の答え。前に「A. 」が付く。会社名は訳さず、ko では各社の正式な英字表記を使う (カタカナは韓国語の利用者が読めないため。訳ではなく自社名の表記。この読み方はオーナーの確認待ち) */
    val supportFaqUnofficialAnswer: DisplayText get() = DisplayText.Res(R.string.about_support_faq_unofficial_answer)
    /** アプリが公式アプリではないのですか? — サポート画面のよくある質問。前に「Q. 」が付く */
    val supportFaqUnofficialQuestion: DisplayText get() = DisplayText.Res(R.string.about_support_faq_unofficial_question)
    /** GitHub Issue で報告する — サポート画面。GitHub の Issue 作成ページを開くリンク */
    val supportFeedbackGithub: DisplayText get() = DisplayText.Res(R.string.about_support_feedback_github)
    /** フィードバック・バグ報告 — サポート画面の節の見出し */
    val supportFeedbackHeader: DisplayText get() = DisplayText.Res(R.string.about_support_feedback_header)
    /** サポート — サポート (問い合わせ・よくある質問) の画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー */
    val supportTitle: DisplayText get() = DisplayText.Res(R.string.about_support_title)
    /** 利用規約 — 利用規約の画面名。iOS は「アプリについて」の行とナビゲーションタイトル、Android は上のバー */
    val termsTitle: DisplayText get() = DisplayText.Res(R.string.about_terms_title)
}
