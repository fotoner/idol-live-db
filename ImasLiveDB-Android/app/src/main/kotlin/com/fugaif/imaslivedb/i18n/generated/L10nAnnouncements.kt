// 生成物: i18n/catalog/announcements.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/announcements.json の文言。L10n.Announcements から引く (iOS の L10n.Announcements と同じ名前)。 */
object L10nAnnouncements {
    /** 曲の詳細にあった「コーレス」(曲ごとにコールを文章で書く欄) をなくしました。歌詞の行ごとに「ここでこう叫ぶ」を付けられるコールガイドができて、役目が重なっていたためです。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の本文 1 段落目 (Android。iOS の本文と ja が違う) */
    val callResponseRetiredBodyP1Android: DisplayText get() = DisplayText.Res(R.string.announcements_call_response_retired_body_p1_android)
    /** これまでのコーレス投稿はアプリに表示されなくなります (データは残していますが、コールガイドへの自動の移し替えはしていません)。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の本文 2 段落目 (Android。iOS の本文と ja が違う) */
    val callResponseRetiredBodyP2Android: DisplayText get() = DisplayText.Res(R.string.announcements_call_response_retired_body_p2_android)
    /** 曲ごとに文章で書くコールは、歌詞の行につけるコールガイドに一本化しました。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の一覧に出す要約 */
    val callResponseRetiredSummary: DisplayText get() = DisplayText.Res(R.string.announcements_call_response_retired_summary)
    /** 「コーレス」の投稿を終了しました — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の見出し */
    val callResponseRetiredTitle: DisplayText get() = DisplayText.Res(R.string.announcements_call_response_retired_title)
    /** 検索の絞り込みを 7 倍速くしました。曲名で絞る処理が 8.8ms から 1.2ms、ライブ検索が 11.9ms から 2.2ms です。読み込み時に一度だけ下ごしらえしておく形に変えたので、打つたびに計算し直さなくなりました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 1 段落目 */
    val crossTabSearchBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p1)
    /** 虫眼鏡を畳みました。検索は各一覧の中にあり、そちらの方が強い (ブランド絞り込みや並び順と組み合わせられる) ので、別画面で完結する横断検索の役目が終わっていました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 2 段落目 */
    val crossTabSearchBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p2)
    /** 代わりに、各一覧が「別のタブ ライブに 8」のように他のタブの件数を出します。押すとそのタブへ移って同じ語で絞り込みます。当たりが開催済みのライブしか無いときは、開催済み側に着地するので空振りしません。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 3 段落目 */
    val crossTabSearchBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p3)
    /** ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 4 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない */
    val crossTabSearchBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p4)
    /** 会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞ぎました。同じ語を打てば、どの画面でも同じように当たります。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 5 段落目 */
    val crossTabSearchBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p5)
    /** 曲の分類の誤りを直しました。MILLIONSTARS の Team 曲 8 曲が全体曲扱いに、Dreaming! や 初 が逆にユニット曲扱いになっていました。Cookie Dough の二重登録も統合し、Alice or Guilty の別バージョンを原曲に紐付けました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 6 段落目 */
    val crossTabSearchBodyP6: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p6)
    /** 同期のたびに曲のユニット版が無印へ戻る不具合も直しました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 7 段落目 */
    val crossTabSearchBodyP7: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p7)
    /** 秋月涼が 2 人に分かれていたのを 1 人にまとめました。ブランドを兼任しているだけなので、画像を入れた側と入れていない側で別人のように見えていました。姫野かのんの新しい声優 (伊能幸輝さん) と、初星学園の根緒亜紗里先生も登録しました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 8 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない */
    val crossTabSearchBodyP8: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_body_p8)
    /** 検索を作り直して 7 倍速くしました。虫眼鏡を畳んで、各一覧が「他のタブに何件あるか」を出します。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の一覧に出す要約 */
    val crossTabSearchSummary: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_summary)
    /** 探すのがもっと速く、まっすぐに — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の見出し */
    val crossTabSearchTitle: DisplayText get() = DisplayText.Res(R.string.announcements_cross_tab_search_title)
    /** 曲だけでなく、アイドルにもみんなでタグを付けられるようになりました。タグはタップで自分の一票をオン/オフ、長押しでそのタグが付いた他の曲・アイドルのランキングが見られます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 1 段落目 */
    val idolTagsCommunityBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_body_p1)
    /** アイドル詳細に「コミュニティ」タブを追加。タグ一覧に加えて、「みんなの投票」で過去に獲得した順位 (優勝/第N位) バッジもここにまとまりました。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 2 段落目 */
    val idolTagsCommunityBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_body_p2)
    /** 投票お題への曲候補ピッカーを大幅強化。作詞作曲者やタグ、CDシリーズ、アイドルからも曲を探せるようになり、通常の楽曲一覧と同じ絞り込みが使えます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 3 段落目 */
    val idolTagsCommunityBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_body_p3)
    /** プロデュースタブに「タグの動き」を追加。伸びてるタグ・タグが急上昇中の曲やアイドル・最近つけられたタグをまとめてチェックできます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 4 段落目 */
    val idolTagsCommunityBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_body_p4)
    /** アイドル詳細に「コミュニティ」タブが登場。タグ付けや投票の実績がまとめて見られます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の一覧に出す要約 */
    val idolTagsCommunitySummary: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_summary)
    /** アイドルにもタグ付けできるように — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の見出し */
    val idolTagsCommunityTitle: DisplayText get() = DisplayText.Res(R.string.announcements_idol_tags_community_title)
    /** アイドル詳細の「ギャラリー」に画像を何枚でも追加できるようになりました。先頭の1枚がアイコンになります。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 1 段落目 */
    val oshiWidgetBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_oshi_widget_body_p1)
    /** ホーム画面ウィジェット「担当の画像」を追加すると、選んだアイドルの画像を表示。タップで次の画像に切り替わり、放っておいても自動でローテーションします。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 2 段落目 */
    val oshiWidgetBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_oshi_widget_body_p2)
    /** 「タップでアプリ」版もあるので、お気に入りの起動ショートカットとしても使えます。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 3 段落目。「お気に入りの」は「自分の好きな」の意味で、アプリのお気に入り機能ではないので ko は 즐겨찾기 を使わない (用語集の警告は承知の上) */
    val oshiWidgetBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_oshi_widget_body_p3)
    /** ホーム画面ウィジェットに、自分で入れた推しの画像を表示できるようになりました。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の一覧に出す要約 */
    val oshiWidgetSummary: DisplayText get() = DisplayText.Res(R.string.announcements_oshi_widget_summary)
    /** 担当の画像をホーム画面に — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の見出し */
    val oshiWidgetTitle: DisplayText get() = DisplayText.Res(R.string.announcements_oshi_widget_title)
    /** 「みんなの投票」のランキングから、曲やアイドルをタップして詳細を開けるようになりました。投票受付中のお題は、まだ投票していないものが選ばれて表示されます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 1 段落目 */
    val pollsPolishBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_body_p1)
    /** 終了したお題で1位になった曲・アイドルには、詳細画面に「優勝」バッジが付くように。タップでそのお題の最終結果も見られます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 2 段落目 */
    val pollsPolishBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_body_p2)
    /** 楽曲の歌唱メンバー情報を、実際のCD編成に合わせて正確に直しました。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 3 段落目 */
    val pollsPolishBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_body_p3)
    /** 担当・お気に入り・メモを iCloud に自動バックアップ。再インストールや機種変更でも復元されます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 4 段落目 */
    val pollsPolishBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_body_p4)
    /** 一覧の読み込み表示をスケルトンに変更し、検索・ツールバーの操作感も整えました。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 5 段落目 */
    val pollsPolishBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_body_p5)
    /** ランキングから曲・アイドル詳細へ。優勝した曲には王冠バッジが付きます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の一覧に出す要約 */
    val pollsPolishSummary: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_summary)
    /** みんなの投票がもっと便利に — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の見出し */
    val pollsPolishTitle: DisplayText get() = DisplayText.Res(R.string.announcements_polls_polish_title)
    /** 「お題を投稿」で、投票候補を「全て」「ブランド限定」「候補指定」から選べるようになりました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 1 段落目 */
    val pollsScopeBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p1)
    /** ブランド限定: 選んだブランドの曲/アイドルだけが候補。「シャニ限定で好きな曲は？」のような企画に。複数ブランド選択で合同ライブの予想にも。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 2 段落目 */
    val pollsScopeBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p2)
    /** 候補指定: 作成者が候補を直接ピック。「この5曲のうちどれが好き？」のような企画に。最低2件あれば作成可能。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 3 段落目 */
    val pollsScopeBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p3)
    /** 曲のピッカーがリフレッシュ。右上のフィルターから並び順 (五十音 / リリース日 / 披露回数)、ライブ履歴のみ曲を隠す、リミックスを含める、などを切り替えられます。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 4 段落目 */
    val pollsScopeBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p4)
    /** セトリ予想画面の行間と「歌唱メンバー予想」ボタンの見た目を整理しました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 5 段落目 */
    val pollsScopeBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p5)
    /** アイドル詳細のタブを切り替えるとスクロール位置がリセットされるように。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 6 段落目 */
    val pollsScopeBodyP6: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_body_p6)
    /** ブランド限定や候補リスト指定で、企画ものの「お題」が立てやすくなりました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の一覧に出す要約 */
    val pollsScopeSummary: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_summary)
    /** 投票の候補を絞り込める — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の見出し */
    val pollsScopeTitle: DisplayText get() = DisplayText.Res(R.string.announcements_polls_scope_title)
    /** 曲名・会場名・ライブ名・作詞作曲の読み仮名を全件そろえました。漢字の曲名をひらがなで打っても見つかります。「おねがいしんでれら」で「お願い！シンデレラ」が出ます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 1 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない */
    val readingsAndroidParityBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p1)
    /** 読みは 1 件ずつ裏取りしました。当て字が多く、素直に読むと外れます。独奏歌=アリア、前奏曲=プレリュード、木苺=ラズベリー、283体操=ツバサ体操、Get lol! Get lol! SONG=げろげろそんぐ。熟語の読み違いも直しました (泥濘=でいねい、傀儡=かいらい、雪月風花=せつげつふうか)。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 2 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない */
    val readingsAndroidParityBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p2)
    /** 外部の読み仮名データベースとも全曲を突き合わせました。向こうが正しかったぶんは直し、こちらが正しかったぶんは残しています。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 3 段落目 */
    val readingsAndroidParityBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p3)
    /** ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 4 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない */
    val readingsAndroidParityBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p4)
    /** 検索の当たり方を全部そろえました。これまでは一覧・ピッカー・ウィジェット設定で当たり方がまちまちで、同じ語を打っても場所によって出たり出なかったりしていました。会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞いでいます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 5 段落目 */
    val readingsAndroidParityBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p5)
    /** 起動時の「今日の1曲」を日替わりにし、奇数日は「今日のアイドル」を出すようにしました。アイドルにもタグを付けてもらえます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 6 段落目 */
    val readingsAndroidParityBodyP6: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p6)
    /** Android 版に通知 (担当の誕生日・ライブ1週間前・チケット締切・月曜予告)、ホーム画面ウィジェット5種、キャラクター画像の取り込み、画像シェアカードを追加しました。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 7 段落目 */
    val readingsAndroidParityBodyP7: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p7)
    /** Android 版の絞り込みを iOS と同じところまで広げました。曲は表示形式・アイドル・作詞作曲・シリーズ・CDシリーズ・曲タイプで、ライブは種別・参加状態・お気に入り・メモで絞れます。検索も曲名/アイドル/作詞作曲を切り替えられ、当たった箇所に色が付きます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 8 段落目 */
    val readingsAndroidParityBodyP8: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p8)
    /** セトリの曲が 9 件、統合で消えた曲を指したままになっていたのを直しました。同じ壊れ方を次から検査で捕まえます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 9 段落目 */
    val readingsAndroidParityBodyP9: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_body_p9)
    /** 曲・会場・ライブ名・作詞作曲の読み仮名を全部入れました。Android 版も iOS に大きく追いつきました。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の一覧に出す要約 */
    val readingsAndroidParitySummary: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_summary)
    /** かなで引けるようになりました — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の見出し */
    val readingsAndroidParityTitle: DisplayText get() = DisplayText.Res(R.string.announcements_readings_android_parity_title)
    /** ライブ・楽曲・アイドルの各一覧に検索欄が付きました。これまでは虫眼鏡を押すと別画面に飛んで、そこで結果が完結してしまい、ブランド絞り込みや並び順と組み合わせられませんでした。今は同じ画面で絞れるので、「シャニマスの曲を配信日順に並べて、そこから名前で絞る」がそのままできます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 1 段落目 */
    val searchTimelineBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p1)
    /** 曲は曲名だけでなく、アイドル名や作詞・作曲でも探せます。ほかの対象に何件あるかも出るので、「曲名では見つからないけどアイドル名なら97件」がひと目で分かり、そのまま切り替えられます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 2 段落目 */
    val searchTimelineBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p2)
    /** 検索結果の各行が「なぜ出てきたか」を見せます。当たった箇所に色が付き、アイドルで探したときは当たった名前が、作詞作曲で探したときはその名前が行に出ます。並び順を披露回数順や回収率順にすると、その数字も行に並びます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 3 段落目 */
    val searchTimelineBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p3)
    /** 見出しと検索欄で2行あったヘッダーを1行に畳みました。一覧が見え始めるまでが近くなっています。絞り込みの動作そのものも12倍速くしました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 4 段落目 */
    val searchTimelineBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p4)
    /** プロデュースタブに「年表」を追加。ライブ・楽曲シリーズ・節目を1枚で俯瞰できます。周年やアニメ放映などの節目を34件収録しました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 5 段落目 */
    val searchTimelineBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p5)
    /** 声優さんの情報を「いつからいつまでが誰」の形に作り直しました。交代のあったアイドルは、歴代のキャストが期間付きで見られます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 6 段落目 */
    val searchTimelineBodyP6: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p6)
    /** 週替わりでソロCDが出ていた「SPECIAL SOLO RECORDS」を全468曲そろえました。ギネス世界記録に認定された52週連続リリースの企画です。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 7 段落目 */
    val searchTimelineBodyP7: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p7)
    /** アプリアイコンを新しくしました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 8 段落目 */
    val searchTimelineBodyP8: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_body_p8)
    /** 検索が各一覧の中に入り、絞り込みや並び順とそのまま組み合わせられるようになりました。年表も追加。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の一覧に出す要約 */
    val searchTimelineSummary: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_summary)
    /** 探しかたが変わりました — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の見出し */
    val searchTimelineTitle: DisplayText get() = DisplayText.Res(R.string.announcements_search_timeline_title)
    /** 会場マスタを追加しました。ライブ一覧を会場で絞り込めるほか、公演の会場名やキャパシティが見られます。改名した会場は、その公演当時の名前で表示します。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 1 段落目 */
    val venuesSetlistCopyBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p1)
    /** セトリに「シンプル表示」を追加。曲名だけを詰めて並べるので、現地でさっと確認したり、そのまま共有したりしやすくなりました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 2 段落目 */
    val venuesSetlistCopyBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p2)
    /** 曲名・アイドル名・よみ・CV名などを長押しでコピーできるようになりました。コーレスやタグの説明は、文字を選んで一部だけコピーできます。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 3 段落目 */
    val venuesSetlistCopyBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p3)
    /** ユニット詳細を大幅に拡張。タグ付けや投票の対象になり、画像も登録できます。アイドル一覧はアイドル/ユニットの2タブになりました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 4 段落目 */
    val venuesSetlistCopyBodyP4: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p4)
    /** 「この曲が好きな人にはこれも」のおすすめを作り直しました。タグがたくさん付いた有名曲ばかり出ていたのを、本当にタグの傾向が近い曲が出るように。開くたびに顔ぶれが変わります。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 5 段落目 */
    val venuesSetlistCopyBodyP5: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p5)
    /** お気に入り・担当・投票履歴の引き継ぎコードとバックアップに対応しました。機種変更時にご利用ください。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 6 段落目 */
    val venuesSetlistCopyBodyP6: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_body_p6)
    /** ライブを会場で絞り込めるように。セトリのシンプル表示と、画面の文字をコピーする機能も追加しました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の一覧に出す要約 */
    val venuesSetlistCopySummary: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_summary)
    /** 会場から探せる・セトリが見やすく — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の見出し */
    val venuesSetlistCopyTitle: DisplayText get() = DisplayText.Res(R.string.announcements_venues_setlist_copy_title)
    /** ウィジェットのスライドショーに出す画像を、ギャラリーで1枚ずつ選べるようになりました。サムネを長押しして「スライドショーから外す/入れる」を切り替えられます。お気に入りだけを回すこともできます。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 1 段落目 */
    val widgetPolishBodyP1: DisplayText get() = DisplayText.Res(R.string.announcements_widget_polish_body_p1)
    /** ウィジェット編集でアイドルを選ぶとき、検索で絞り込めるようになり、ブランド名も表示されるようになりました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 2 段落目 */
    val widgetPolishBodyP2: DisplayText get() = DisplayText.Res(R.string.announcements_widget_polish_body_p2)
    /** ギャラリーの表示や、画像まわりの細かな不具合を修正しました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 3 段落目 */
    val widgetPolishBodyP3: DisplayText get() = DisplayText.Res(R.string.announcements_widget_polish_body_p3)
    /** ウィジェットに出す画像を選べるようになり、アイドル選択も探しやすくなりました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の一覧に出す要約 */
    val widgetPolishSummary: DisplayText get() = DisplayText.Res(R.string.announcements_widget_polish_summary)
    /** スライドショーの画像を選べるように — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の見出し */
    val widgetPolishTitle: DisplayText get() = DisplayText.Res(R.string.announcements_widget_polish_title)
}
