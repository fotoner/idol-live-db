// 生成物: i18n/catalog/announcements.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/announcements.json の文言 (表 Announcements)
    enum Announcements {
        /// プロデュースに「コールガイド」を追加しました。コールが入っている曲、最近誰がどの曲を書いたか、「コール曲」タグが付いているのにまだ書かれていない曲が、1 つの画面で見られます。 — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の本文 1 段落目 (iOS だけにあるお知らせ)
        static var callGuideDashboardBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.body.p1", defaultValue: "プロデュースに「コールガイド」を追加しました。コールが入っている曲、最近誰がどの曲を書いたか、「コール曲」タグが付いているのにまだ書かれていない曲が、1 つの画面で見られます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 書かれていない曲の行から「書く」を押すと、その曲の歌詞タブがそのまま開きます。歌詞の語をタップしてコールを付けて保存するだけです。ログインしていれば誰でも書けます。 — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の本文 2 段落目 (iOS だけにあるお知らせ)
        static var callGuideDashboardBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.body.p2", defaultValue: "書かれていない曲の行から「書く」を押すと、その曲の歌詞タブがそのまま開きます。歌詞の語をタップしてコールを付けて保存するだけです。ログインしていれば誰でも書けます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲一覧の絞り込みに「コールガイドがある曲のみ」を追加しました。ライブ前に、コールのある曲だけを並べて予習できます。 — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の本文 3 段落目 (iOS だけにあるお知らせ)
        static var callGuideDashboardBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.body.p3", defaultValue: "曲一覧の絞り込みに「コールガイドがある曲のみ」を追加しました。ライブ前に、コールのある曲だけを並べて予習できます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// コールの編集には履歴が残るようになりました。誰がいつどの曲を書いたかが「最近の編集」に出ます (歌詞やコールの中身は履歴に残しません)。 — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の本文 4 段落目 (iOS だけにあるお知らせ)
        static var callGuideDashboardBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.body.p4", defaultValue: "コールの編集には履歴が残るようになりました。誰がいつどの曲を書いたかが「最近の編集」に出ます (歌詞やコールの中身は履歴に残しません)。", table: "Announcements", bundle: L10n.bundle)
        }
        /// コールが入っている曲・最近の編集・まだ書かれていない曲を 1 枚にまとめました。 — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の一覧に出す要約 (iOS だけにあるお知らせ)
        static var callGuideDashboardSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.summary", defaultValue: "コールが入っている曲・最近の編集・まだ書かれていない曲を 1 枚にまとめました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// コールガイドを、みんなで書けるように — お知らせ (id: v2.3.0_call_guide_dashboard, 2026-09-04) の見出し (iOS だけにあるお知らせ)
        static var callGuideDashboardTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.call_guide_dashboard.title", defaultValue: "コールガイドを、みんなで書けるように", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲の「コミュニティ」にあった「コーレス」(曲ごとにコールを文章で書く欄) をなくしました。歌詞の行ごとに「ここでこう叫ぶ」を付けられるコールガイドができて、役目が重なっていたためです。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の本文 1 段落目 (iOS。Android は p*_android)
        static var callResponseRetiredBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.call_response_retired.body.p1", defaultValue: "曲の「コミュニティ」にあった「コーレス」(曲ごとにコールを文章で書く欄) をなくしました。歌詞の行ごとに「ここでこう叫ぶ」を付けられるコールガイドができて、役目が重なっていたためです。", table: "Announcements", bundle: L10n.bundle)
        }
        /// コールを書きたいときは、曲の歌詞タブで語をタップして付けてください。書いたコールは歌詞の下にそのまま出るので、読む側もどこで叫ぶかで迷いません。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の本文 2 段落目 (iOS。Android は p*_android)
        static var callResponseRetiredBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.call_response_retired.body.p2", defaultValue: "コールを書きたいときは、曲の歌詞タブで語をタップして付けてください。書いたコールは歌詞の下にそのまま出るので、読む側もどこで叫ぶかで迷いません。", table: "Announcements", bundle: L10n.bundle)
        }
        /// これまでのコーレス投稿はアプリに表示されなくなります (データは残していますが、コールガイドへの自動の移し替えはしていません)。マイページの投稿累計にもコーレスは数えなくなります。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の本文 3 段落目 (iOS。Android は p*_android)
        static var callResponseRetiredBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.call_response_retired.body.p3", defaultValue: "これまでのコーレス投稿はアプリに表示されなくなります (データは残していますが、コールガイドへの自動の移し替えはしていません)。マイページの投稿累計にもコーレスは数えなくなります。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲ごとに文章で書くコールは、歌詞の行につけるコールガイドに一本化しました。 — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の一覧に出す要約
        static var callResponseRetiredSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.call_response_retired.summary", defaultValue: "曲ごとに文章で書くコールは、歌詞の行につけるコールガイドに一本化しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 「コーレス」の投稿を終了しました — お知らせ (id: 20260906_call_response_retired, 2026-09-06) の見出し
        static var callResponseRetiredTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.call_response_retired.title", defaultValue: "「コーレス」の投稿を終了しました", table: "Announcements", bundle: L10n.bundle)
        }
        /// 検索の絞り込みを 7 倍速くしました。曲名で絞る処理が 8.8ms から 1.2ms、ライブ検索が 11.9ms から 2.2ms です。読み込み時に一度だけ下ごしらえしておく形に変えたので、打つたびに計算し直さなくなりました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 1 段落目
        static var crossTabSearchBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p1", defaultValue: "検索の絞り込みを 7 倍速くしました。曲名で絞る処理が 8.8ms から 1.2ms、ライブ検索が 11.9ms から 2.2ms です。読み込み時に一度だけ下ごしらえしておく形に変えたので、打つたびに計算し直さなくなりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 虫眼鏡を畳みました。検索は各一覧の中にあり、そちらの方が強い (ブランド絞り込みや並び順と組み合わせられる) ので、別画面で完結する横断検索の役目が終わっていました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 2 段落目
        static var crossTabSearchBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p2", defaultValue: "虫眼鏡を畳みました。検索は各一覧の中にあり、そちらの方が強い (ブランド絞り込みや並び順と組み合わせられる) ので、別画面で完結する横断検索の役目が終わっていました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 代わりに、各一覧が「別のタブ ライブに 8」のように他のタブの件数を出します。押すとそのタブへ移って同じ語で絞り込みます。当たりが開催済みのライブしか無いときは、開催済み側に着地するので空振りしません。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 3 段落目
        static var crossTabSearchBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p3", defaultValue: "代わりに、各一覧が「別のタブ ライブに 8」のように他のタブの件数を出します。押すとそのタブへ移って同じ語で絞り込みます。当たりが開催済みのライブしか無いときは、開催済み側に着地するので空振りしません。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 4 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var crossTabSearchBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p4", defaultValue: "ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞ぎました。同じ語を打てば、どの画面でも同じように当たります。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 5 段落目
        static var crossTabSearchBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p5", defaultValue: "会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞ぎました。同じ語を打てば、どの画面でも同じように当たります。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲の分類の誤りを直しました。MILLIONSTARS の Team 曲 8 曲が全体曲扱いに、Dreaming! や 初 が逆にユニット曲扱いになっていました。Cookie Dough の二重登録も統合し、Alice or Guilty の別バージョンを原曲に紐付けました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 6 段落目
        static var crossTabSearchBodyP6: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p6", defaultValue: "曲の分類の誤りを直しました。MILLIONSTARS の Team 曲 8 曲が全体曲扱いに、Dreaming! や 初 が逆にユニット曲扱いになっていました。Cookie Dough の二重登録も統合し、Alice or Guilty の別バージョンを原曲に紐付けました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 同期のたびに曲のユニット版が無印へ戻る不具合も直しました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 7 段落目
        static var crossTabSearchBodyP7: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p7", defaultValue: "同期のたびに曲のユニット版が無印へ戻る不具合も直しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 秋月涼が 2 人に分かれていたのを 1 人にまとめました。ブランドを兼任しているだけなので、画像を入れた側と入れていない側で別人のように見えていました。姫野かのんの新しい声優 (伊能幸輝さん) と、初星学園の根緒亜紗里先生も登録しました。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の本文 8 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var crossTabSearchBodyP8: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.body.p8", defaultValue: "秋月涼が 2 人に分かれていたのを 1 人にまとめました。ブランドを兼任しているだけなので、画像を入れた側と入れていない側で別人のように見えていました。姫野かのんの新しい声優 (伊能幸輝さん) と、初星学園の根緒亜紗里先生も登録しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 検索を作り直して 7 倍速くしました。虫眼鏡を畳んで、各一覧が「他のタブに何件あるか」を出します。 — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の一覧に出す要約
        static var crossTabSearchSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.summary", defaultValue: "検索を作り直して 7 倍速くしました。虫眼鏡を畳んで、各一覧が「他のタブに何件あるか」を出します。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 探すのがもっと速く、まっすぐに — お知らせ (id: v2.1.0_cross_tab_search, 2026-09-01) の見出し
        static var crossTabSearchTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.cross_tab_search.title", defaultValue: "探すのがもっと速く、まっすぐに", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲だけでなく、アイドルにもみんなでタグを付けられるようになりました。タグはタップで自分の一票をオン/オフ、長押しでそのタグが付いた他の曲・アイドルのランキングが見られます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 1 段落目
        static var idolTagsCommunityBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.body.p1", defaultValue: "曲だけでなく、アイドルにもみんなでタグを付けられるようになりました。タグはタップで自分の一票をオン/オフ、長押しでそのタグが付いた他の曲・アイドルのランキングが見られます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アイドル詳細に「コミュニティ」タブを追加。タグ一覧に加えて、「みんなの投票」で過去に獲得した順位 (優勝/第N位) バッジもここにまとまりました。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 2 段落目
        static var idolTagsCommunityBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.body.p2", defaultValue: "アイドル詳細に「コミュニティ」タブを追加。タグ一覧に加えて、「みんなの投票」で過去に獲得した順位 (優勝/第N位) バッジもここにまとまりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 投票お題への曲候補ピッカーを大幅強化。作詞作曲者やタグ、CDシリーズ、アイドルからも曲を探せるようになり、通常の楽曲一覧と同じ絞り込みが使えます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 3 段落目
        static var idolTagsCommunityBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.body.p3", defaultValue: "投票お題への曲候補ピッカーを大幅強化。作詞作曲者やタグ、CDシリーズ、アイドルからも曲を探せるようになり、通常の楽曲一覧と同じ絞り込みが使えます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// プロデュースタブに「タグの動き」を追加。伸びてるタグ・タグが急上昇中の曲やアイドル・最近つけられたタグをまとめてチェックできます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の本文 4 段落目
        static var idolTagsCommunityBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.body.p4", defaultValue: "プロデュースタブに「タグの動き」を追加。伸びてるタグ・タグが急上昇中の曲やアイドル・最近つけられたタグをまとめてチェックできます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アイドル詳細に「コミュニティ」タブが登場。タグ付けや投票の実績がまとめて見られます。 — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の一覧に出す要約
        static var idolTagsCommunitySummary: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.summary", defaultValue: "アイドル詳細に「コミュニティ」タブが登場。タグ付けや投票の実績がまとめて見られます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アイドルにもタグ付けできるように — お知らせ (id: v1.9.0_idol_tags_community, 2026-07-10) の見出し
        static var idolTagsCommunityTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.idol_tags_community.title", defaultValue: "アイドルにもタグ付けできるように", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲の詳細に「歌詞」が増えました。2,128 曲ぶんあります。JASRAC の許諾 (第J260943703号) を受けて掲載しています。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の本文 1 段落目 (iOS だけにあるお知らせ)
        static var lyricsBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.body.p1", defaultValue: "曲の詳細に「歌詞」が増えました。2,128 曲ぶんあります。JASRAC の許諾 (第J260943703号) を受けて掲載しています。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 歌詞の中の言葉で曲を探せます。曲一覧の検索で「歌詞」に切り替えると、うろ覚えのフレーズから曲にたどり着けます。当たった箇所の前後が抜き出して表示されます。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の本文 2 段落目 (iOS だけにあるお知らせ)
        static var lyricsBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.body.p2", defaultValue: "歌詞の中の言葉で曲を探せます。曲一覧の検索で「歌詞」に切り替えると、うろ覚えのフレーズから曲にたどり着けます。当たった箇所の前後が抜き出して表示されます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 歌詞の表示にはログインが必要です。許諾の条件で「まとめてダウンロードできない形」で配信することになっているため、1 曲ずつの取得になっていて、端末にも残りません。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の本文 3 段落目 (iOS だけにあるお知らせ)
        static var lyricsBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.body.p3", defaultValue: "歌詞の表示にはログインが必要です。許諾の条件で「まとめてダウンロードできない形」で配信することになっているため、1 曲ずつの取得になっていて、端末にも残りません。", table: "Announcements", bundle: L10n.bundle)
        }
        /// カバー曲と、アイマス以外の曲 (合同ライブで披露されたもの) には歌詞を付けていません。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の本文 4 段落目 (iOS だけにあるお知らせ)
        static var lyricsBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.body.p4", defaultValue: "カバー曲と、アイマス以外の曲 (合同ライブで披露されたもの) には歌詞を付けていません。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アルストロメリアの「Bloomy!」が曲一覧に出てこない不具合を直しました。電音部の同名曲の別バージョンとして登録されてしまい、派生曲として隠されていました。「Fly High!」も同じ形で隠れていたので直しています。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の本文 5 段落目 (iOS だけにあるお知らせ)。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var lyricsBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.body.p5", defaultValue: "アルストロメリアの「Bloomy!」が曲一覧に出てこない不具合を直しました。電音部の同名曲の別バージョンとして登録されてしまい、派生曲として隠されていました。「Fly High!」も同じ形で隠れていたので直しています。", table: "Announcements", bundle: L10n.bundle)
        }
        /// JASRAC の許諾を受けて、2,128 曲の歌詞を掲載しました。歌詞の中の言葉から曲を探すこともできます。 — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の一覧に出す要約 (iOS だけにあるお知らせ)
        static var lyricsSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.summary", defaultValue: "JASRAC の許諾を受けて、2,128 曲の歌詞を掲載しました。歌詞の中の言葉から曲を探すこともできます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 歌詞が読めるようになりました — お知らせ (id: v2.2.0_lyrics, 2026-09-03) の見出し (iOS だけにあるお知らせ)
        static var lyricsTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.lyrics.title", defaultValue: "歌詞が読めるようになりました", table: "Announcements", bundle: L10n.bundle)
        }
        /// アイドル詳細の「ギャラリー」に画像を何枚でも追加できるようになりました。先頭の1枚がアイコンになります。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 1 段落目
        static var oshiWidgetBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.oshi_widget.body.p1", defaultValue: "アイドル詳細の「ギャラリー」に画像を何枚でも追加できるようになりました。先頭の1枚がアイコンになります。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ホーム画面ウィジェット「担当の画像」を追加すると、選んだアイドルの画像を表示。タップで次の画像に切り替わり、放っておいても自動でローテーションします。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 2 段落目
        static var oshiWidgetBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.oshi_widget.body.p2", defaultValue: "ホーム画面ウィジェット「担当の画像」を追加すると、選んだアイドルの画像を表示。タップで次の画像に切り替わり、放っておいても自動でローテーションします。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 「タップでアプリ」版もあるので、お気に入りの起動ショートカットとしても使えます。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の本文 3 段落目。「お気に入りの」は「自分の好きな」の意味で、アプリのお気に入り機能ではないので ko は 즐겨찾기 を使わない (用語集の警告は承知の上)
        static var oshiWidgetBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.oshi_widget.body.p3", defaultValue: "「タップでアプリ」版もあるので、お気に入りの起動ショートカットとしても使えます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ホーム画面ウィジェットに、自分で入れた推しの画像を表示できるようになりました。 — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の一覧に出す要約
        static var oshiWidgetSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.oshi_widget.summary", defaultValue: "ホーム画面ウィジェットに、自分で入れた推しの画像を表示できるようになりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 担当の画像をホーム画面に — お知らせ (id: v1.7_oshi_widget, 2026-06-17) の見出し
        static var oshiWidgetTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.oshi_widget.title", defaultValue: "担当の画像をホーム画面に", table: "Announcements", bundle: L10n.bundle)
        }
        /// 「みんなの投票」のランキングから、曲やアイドルをタップして詳細を開けるようになりました。投票受付中のお題は、まだ投票していないものが選ばれて表示されます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 1 段落目
        static var pollsPolishBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.body.p1", defaultValue: "「みんなの投票」のランキングから、曲やアイドルをタップして詳細を開けるようになりました。投票受付中のお題は、まだ投票していないものが選ばれて表示されます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 終了したお題で1位になった曲・アイドルには、詳細画面に「優勝」バッジが付くように。タップでそのお題の最終結果も見られます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 2 段落目
        static var pollsPolishBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.body.p2", defaultValue: "終了したお題で1位になった曲・アイドルには、詳細画面に「優勝」バッジが付くように。タップでそのお題の最終結果も見られます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 楽曲の歌唱メンバー情報を、実際のCD編成に合わせて正確に直しました。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 3 段落目
        static var pollsPolishBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.body.p3", defaultValue: "楽曲の歌唱メンバー情報を、実際のCD編成に合わせて正確に直しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 担当・お気に入り・メモを iCloud に自動バックアップ。再インストールや機種変更でも復元されます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 4 段落目
        static var pollsPolishBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.body.p4", defaultValue: "担当・お気に入り・メモを iCloud に自動バックアップ。再インストールや機種変更でも復元されます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 一覧の読み込み表示をスケルトンに変更し、検索・ツールバーの操作感も整えました。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の本文 5 段落目
        static var pollsPolishBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.body.p5", defaultValue: "一覧の読み込み表示をスケルトンに変更し、検索・ツールバーの操作感も整えました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ランキングから曲・アイドル詳細へ。優勝した曲には王冠バッジが付きます。 — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の一覧に出す要約
        static var pollsPolishSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.summary", defaultValue: "ランキングから曲・アイドル詳細へ。優勝した曲には王冠バッジが付きます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// みんなの投票がもっと便利に — お知らせ (id: v1.8.0_polls_polish, 2026-06-27) の見出し
        static var pollsPolishTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_polish.title", defaultValue: "みんなの投票がもっと便利に", table: "Announcements", bundle: L10n.bundle)
        }
        /// 「お題を投稿」で、投票候補を「全て」「ブランド限定」「候補指定」から選べるようになりました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 1 段落目
        static var pollsScopeBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p1", defaultValue: "「お題を投稿」で、投票候補を「全て」「ブランド限定」「候補指定」から選べるようになりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ブランド限定: 選んだブランドの曲/アイドルだけが候補。「シャニ限定で好きな曲は？」のような企画に。複数ブランド選択で合同ライブの予想にも。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 2 段落目
        static var pollsScopeBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p2", defaultValue: "ブランド限定: 選んだブランドの曲/アイドルだけが候補。「シャニ限定で好きな曲は？」のような企画に。複数ブランド選択で合同ライブの予想にも。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 候補指定: 作成者が候補を直接ピック。「この5曲のうちどれが好き？」のような企画に。最低2件あれば作成可能。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 3 段落目
        static var pollsScopeBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p3", defaultValue: "候補指定: 作成者が候補を直接ピック。「この5曲のうちどれが好き？」のような企画に。最低2件あれば作成可能。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲のピッカーがリフレッシュ。右上のフィルターから並び順 (五十音 / リリース日 / 披露回数)、ライブ履歴のみ曲を隠す、リミックスを含める、などを切り替えられます。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 4 段落目
        static var pollsScopeBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p4", defaultValue: "曲のピッカーがリフレッシュ。右上のフィルターから並び順 (五十音 / リリース日 / 披露回数)、ライブ履歴のみ曲を隠す、リミックスを含める、などを切り替えられます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// セトリ予想画面の行間と「歌唱メンバー予想」ボタンの見た目を整理しました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 5 段落目
        static var pollsScopeBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p5", defaultValue: "セトリ予想画面の行間と「歌唱メンバー予想」ボタンの見た目を整理しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アイドル詳細のタブを切り替えるとスクロール位置がリセットされるように。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の本文 6 段落目
        static var pollsScopeBodyP6: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.body.p6", defaultValue: "アイドル詳細のタブを切り替えるとスクロール位置がリセットされるように。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ブランド限定や候補リスト指定で、企画ものの「お題」が立てやすくなりました。 — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の一覧に出す要約
        static var pollsScopeSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.summary", defaultValue: "ブランド限定や候補リスト指定で、企画ものの「お題」が立てやすくなりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 投票の候補を絞り込める — お知らせ (id: v1.8.1_polls_scope, 2026-06-29) の見出し
        static var pollsScopeTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.polls_scope.title", defaultValue: "投票の候補を絞り込める", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲名・会場名・ライブ名・作詞作曲の読み仮名を全件そろえました。漢字の曲名をひらがなで打っても見つかります。「おねがいしんでれら」で「お願い！シンデレラ」が出ます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 1 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var readingsAndroidParityBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p1", defaultValue: "曲名・会場名・ライブ名・作詞作曲の読み仮名を全件そろえました。漢字の曲名をひらがなで打っても見つかります。「おねがいしんでれら」で「お願い！シンデレラ」が出ます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 読みは 1 件ずつ裏取りしました。当て字が多く、素直に読むと外れます。独奏歌=アリア、前奏曲=プレリュード、木苺=ラズベリー、283体操=ツバサ体操、Get lol! Get lol! SONG=げろげろそんぐ。熟語の読み違いも直しました (泥濘=でいねい、傀儡=かいらい、雪月風花=せつげつふうか)。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 2 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var readingsAndroidParityBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p2", defaultValue: "読みは 1 件ずつ裏取りしました。当て字が多く、素直に読むと外れます。独奏歌=アリア、前奏曲=プレリュード、木苺=ラズベリー、283体操=ツバサ体操、Get lol! Get lol! SONG=げろげろそんぐ。熟語の読み違いも直しました (泥濘=でいねい、傀儡=かいらい、雪月風花=せつげつふうか)。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 外部の読み仮名データベースとも全曲を突き合わせました。向こうが正しかったぶんは直し、こちらが正しかったぶんは残しています。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 3 段落目
        static var readingsAndroidParityBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p3", defaultValue: "外部の読み仮名データベースとも全曲を突き合わせました。向こうが正しかったぶんは直し、こちらが正しかったぶんは残しています。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 4 段落目。曲名・ユニット名・アイドル名と読み仮名の例は訳さない
        static var readingsAndroidParityBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p4", defaultValue: "ユニット名も かなで探せるようになりました。「あたらよづき」で「可惜夜月」、「はごろもこまち」で「羽衣小町」が出ます。読みが素直でないものが多いので、1 件ずつ出典を当たっています (凸レーション=でこれーしょん、夕星灯=ゆうづつひ、≡君彩≡=きみどり)。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 検索の当たり方を全部そろえました。これまでは一覧・ピッカー・ウィジェット設定で当たり方がまちまちで、同じ語を打っても場所によって出たり出なかったりしていました。会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞いでいます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 5 段落目
        static var readingsAndroidParityBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p5", defaultValue: "検索の当たり方を全部そろえました。これまでは一覧・ピッカー・ウィジェット設定で当たり方がまちまちで、同じ語を打っても場所によって出たり出なかったりしていました。会場を選ぶ画面が読みを見ていない、曲を選ぶ画面が曲名しか見ていない、といった取りこぼしも塞いでいます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 起動時の「今日の1曲」を日替わりにし、奇数日は「今日のアイドル」を出すようにしました。アイドルにもタグを付けてもらえます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 6 段落目
        static var readingsAndroidParityBodyP6: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p6", defaultValue: "起動時の「今日の1曲」を日替わりにし、奇数日は「今日のアイドル」を出すようにしました。アイドルにもタグを付けてもらえます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// Android 版に通知 (担当の誕生日・ライブ1週間前・チケット締切・月曜予告)、ホーム画面ウィジェット5種、キャラクター画像の取り込み、画像シェアカードを追加しました。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 7 段落目
        static var readingsAndroidParityBodyP7: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p7", defaultValue: "Android 版に通知 (担当の誕生日・ライブ1週間前・チケット締切・月曜予告)、ホーム画面ウィジェット5種、キャラクター画像の取り込み、画像シェアカードを追加しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// Android 版の絞り込みを iOS と同じところまで広げました。曲は表示形式・アイドル・作詞作曲・シリーズ・CDシリーズ・曲タイプで、ライブは種別・参加状態・お気に入り・メモで絞れます。検索も曲名/アイドル/作詞作曲を切り替えられ、当たった箇所に色が付きます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 8 段落目
        static var readingsAndroidParityBodyP8: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p8", defaultValue: "Android 版の絞り込みを iOS と同じところまで広げました。曲は表示形式・アイドル・作詞作曲・シリーズ・CDシリーズ・曲タイプで、ライブは種別・参加状態・お気に入り・メモで絞れます。検索も曲名/アイドル/作詞作曲を切り替えられ、当たった箇所に色が付きます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// セトリの曲が 9 件、統合で消えた曲を指したままになっていたのを直しました。同じ壊れ方を次から検査で捕まえます。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の本文 9 段落目
        static var readingsAndroidParityBodyP9: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.body.p9", defaultValue: "セトリの曲が 9 件、統合で消えた曲を指したままになっていたのを直しました。同じ壊れ方を次から検査で捕まえます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲・会場・ライブ名・作詞作曲の読み仮名を全部入れました。Android 版も iOS に大きく追いつきました。 — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の一覧に出す要約
        static var readingsAndroidParitySummary: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.summary", defaultValue: "曲・会場・ライブ名・作詞作曲の読み仮名を全部入れました。Android 版も iOS に大きく追いつきました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// かなで引けるようになりました — お知らせ (id: v2.0.0_readings_android_parity, 2026-08-28) の見出し
        static var readingsAndroidParityTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.readings_android_parity.title", defaultValue: "かなで引けるようになりました", table: "Announcements", bundle: L10n.bundle)
        }
        /// ライブ・楽曲・アイドルの各一覧に検索欄が付きました。これまでは虫眼鏡を押すと別画面に飛んで、そこで結果が完結してしまい、ブランド絞り込みや並び順と組み合わせられませんでした。今は同じ画面で絞れるので、「シャニマスの曲を配信日順に並べて、そこから名前で絞る」がそのままできます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 1 段落目
        static var searchTimelineBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p1", defaultValue: "ライブ・楽曲・アイドルの各一覧に検索欄が付きました。これまでは虫眼鏡を押すと別画面に飛んで、そこで結果が完結してしまい、ブランド絞り込みや並び順と組み合わせられませんでした。今は同じ画面で絞れるので、「シャニマスの曲を配信日順に並べて、そこから名前で絞る」がそのままできます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲は曲名だけでなく、アイドル名や作詞・作曲でも探せます。ほかの対象に何件あるかも出るので、「曲名では見つからないけどアイドル名なら97件」がひと目で分かり、そのまま切り替えられます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 2 段落目
        static var searchTimelineBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p2", defaultValue: "曲は曲名だけでなく、アイドル名や作詞・作曲でも探せます。ほかの対象に何件あるかも出るので、「曲名では見つからないけどアイドル名なら97件」がひと目で分かり、そのまま切り替えられます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 検索結果の各行が「なぜ出てきたか」を見せます。当たった箇所に色が付き、アイドルで探したときは当たった名前が、作詞作曲で探したときはその名前が行に出ます。並び順を披露回数順や回収率順にすると、その数字も行に並びます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 3 段落目
        static var searchTimelineBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p3", defaultValue: "検索結果の各行が「なぜ出てきたか」を見せます。当たった箇所に色が付き、アイドルで探したときは当たった名前が、作詞作曲で探したときはその名前が行に出ます。並び順を披露回数順や回収率順にすると、その数字も行に並びます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 見出しと検索欄で2行あったヘッダーを1行に畳みました。一覧が見え始めるまでが近くなっています。絞り込みの動作そのものも12倍速くしました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 4 段落目
        static var searchTimelineBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p4", defaultValue: "見出しと検索欄で2行あったヘッダーを1行に畳みました。一覧が見え始めるまでが近くなっています。絞り込みの動作そのものも12倍速くしました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// プロデュースタブに「年表」を追加。ライブ・楽曲シリーズ・節目を1枚で俯瞰できます。周年やアニメ放映などの節目を34件収録しました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 5 段落目
        static var searchTimelineBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p5", defaultValue: "プロデュースタブに「年表」を追加。ライブ・楽曲シリーズ・節目を1枚で俯瞰できます。周年やアニメ放映などの節目を34件収録しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 声優さんの情報を「いつからいつまでが誰」の形に作り直しました。交代のあったアイドルは、歴代のキャストが期間付きで見られます。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 6 段落目
        static var searchTimelineBodyP6: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p6", defaultValue: "声優さんの情報を「いつからいつまでが誰」の形に作り直しました。交代のあったアイドルは、歴代のキャストが期間付きで見られます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 週替わりでソロCDが出ていた「SPECIAL SOLO RECORDS」を全468曲そろえました。ギネス世界記録に認定された52週連続リリースの企画です。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 7 段落目
        static var searchTimelineBodyP7: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p7", defaultValue: "週替わりでソロCDが出ていた「SPECIAL SOLO RECORDS」を全468曲そろえました。ギネス世界記録に認定された52週連続リリースの企画です。", table: "Announcements", bundle: L10n.bundle)
        }
        /// アプリアイコンを新しくしました。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の本文 8 段落目
        static var searchTimelineBodyP8: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.body.p8", defaultValue: "アプリアイコンを新しくしました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 検索が各一覧の中に入り、絞り込みや並び順とそのまま組み合わせられるようになりました。年表も追加。 — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の一覧に出す要約
        static var searchTimelineSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.summary", defaultValue: "検索が各一覧の中に入り、絞り込みや並び順とそのまま組み合わせられるようになりました。年表も追加。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 探しかたが変わりました — お知らせ (id: v1.11.0_search_timeline, 2026-08-24) の見出し
        static var searchTimelineTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.search_timeline.title", defaultValue: "探しかたが変わりました", table: "Announcements", bundle: L10n.bundle)
        }
        /// セットリストの各行に「初披露」「3 年 10 か月ぶり」が出るようになりました。久しぶりに来た曲がその場で分かります。 — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の本文 1 段落目 (iOS だけにあるお知らせ)
        static var setlistGapBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.body.p1", defaultValue: "セットリストの各行に「初披露」「3 年 10 か月ぶり」が出るようになりました。久しぶりに来た曲がその場で分かります。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 数えるのは「その公演の時点で何年ぶりだったか」です。昔のライブを開いたときも、当時の間隔が出ます。1 年未満の間隔は出しません (ほとんどの曲が当てはまってしまい、かえって読みにくいため)。 — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の本文 2 段落目 (iOS だけにあるお知らせ)
        static var setlistGapBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.body.p2", defaultValue: "数えるのは「その公演の時点で何年ぶりだったか」です。昔のライブを開いたときも、当時の間隔が出ます。1 年未満の間隔は出しません (ほとんどの曲が当てはまってしまい、かえって読みにくいため)。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 歌った人の名義の出し方も直しました。これまでは歌った顔ぶれがユニットの人数とぴったり合うと、その曲がユニット名義でなくてもユニット名を出していました。ユニットとして歌った曲と、たまたま同じ顔ぶれで歌った曲を取り違えなくなります。ユニット名の表記の誤り (「315 ALLSTARS」→「315 STARS」など) もあわせて直しています。 — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の本文 3 段落目 (iOS だけにあるお知らせ)
        static var setlistGapBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.body.p3", defaultValue: "歌った人の名義の出し方も直しました。これまでは歌った顔ぶれがユニットの人数とぴったり合うと、その曲がユニット名義でなくてもユニット名を出していました。ユニットとして歌った曲と、たまたま同じ顔ぶれで歌った曲を取り違えなくなります。ユニット名の表記の誤り (「315 ALLSTARS」→「315 STARS」など) もあわせて直しています。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ライブに種別が付きました。周年ライブ・オーケストラ・他社イベント・リリースイベント・バースデーライブなどで見分けられます。 — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の本文 4 段落目 (iOS だけにあるお知らせ)
        static var setlistGapBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.body.p4", defaultValue: "ライブに種別が付きました。周年ライブ・オーケストラ・他社イベント・リリースイベント・バースデーライブなどで見分けられます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// その曲が前にいつ歌われたかを、セットリストの行にそのまま出します。 — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の一覧に出す要約 (iOS だけにあるお知らせ)
        static var setlistGapSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.summary", defaultValue: "その曲が前にいつ歌われたかを、セットリストの行にそのまま出します。", table: "Announcements", bundle: L10n.bundle)
        }
        /// セトリに「何年ぶり」が出るようになりました — お知らせ (id: v2.3.0_setlist_gap, 2026-09-20) の見出し (iOS だけにあるお知らせ)
        static var setlistGapTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.setlist_gap.title", defaultValue: "セトリに「何年ぶり」が出るようになりました", table: "Announcements", bundle: L10n.bundle)
        }
        /// 会場マスタを追加しました。ライブ一覧を会場で絞り込めるほか、公演の会場名やキャパシティが見られます。改名した会場は、その公演当時の名前で表示します。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 1 段落目
        static var venuesSetlistCopyBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p1", defaultValue: "会場マスタを追加しました。ライブ一覧を会場で絞り込めるほか、公演の会場名やキャパシティが見られます。改名した会場は、その公演当時の名前で表示します。", table: "Announcements", bundle: L10n.bundle)
        }
        /// セトリに「シンプル表示」を追加。曲名だけを詰めて並べるので、現地でさっと確認したり、そのまま共有したりしやすくなりました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 2 段落目
        static var venuesSetlistCopyBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p2", defaultValue: "セトリに「シンプル表示」を追加。曲名だけを詰めて並べるので、現地でさっと確認したり、そのまま共有したりしやすくなりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 曲名・アイドル名・よみ・CV名などを長押しでコピーできるようになりました。コーレスやタグの説明は、文字を選んで一部だけコピーできます。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 3 段落目
        static var venuesSetlistCopyBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p3", defaultValue: "曲名・アイドル名・よみ・CV名などを長押しでコピーできるようになりました。コーレスやタグの説明は、文字を選んで一部だけコピーできます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ユニット詳細を大幅に拡張。タグ付けや投票の対象になり、画像も登録できます。アイドル一覧はアイドル/ユニットの2タブになりました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 4 段落目
        static var venuesSetlistCopyBodyP4: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p4", defaultValue: "ユニット詳細を大幅に拡張。タグ付けや投票の対象になり、画像も登録できます。アイドル一覧はアイドル/ユニットの2タブになりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 「この曲が好きな人にはこれも」のおすすめを作り直しました。タグがたくさん付いた有名曲ばかり出ていたのを、本当にタグの傾向が近い曲が出るように。開くたびに顔ぶれが変わります。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 5 段落目
        static var venuesSetlistCopyBodyP5: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p5", defaultValue: "「この曲が好きな人にはこれも」のおすすめを作り直しました。タグがたくさん付いた有名曲ばかり出ていたのを、本当にタグの傾向が近い曲が出るように。開くたびに顔ぶれが変わります。", table: "Announcements", bundle: L10n.bundle)
        }
        /// お気に入り・担当・投票履歴の引き継ぎコードとバックアップに対応しました。機種変更時にご利用ください。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の本文 6 段落目
        static var venuesSetlistCopyBodyP6: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.body.p6", defaultValue: "お気に入り・担当・投票履歴の引き継ぎコードとバックアップに対応しました。機種変更時にご利用ください。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ライブを会場で絞り込めるように。セトリのシンプル表示と、画面の文字をコピーする機能も追加しました。 — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の一覧に出す要約
        static var venuesSetlistCopySummary: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.summary", defaultValue: "ライブを会場で絞り込めるように。セトリのシンプル表示と、画面の文字をコピーする機能も追加しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// 会場から探せる・セトリが見やすく — お知らせ (id: v1.10.0_venues_setlist_copy, 2026-07-27) の見出し
        static var venuesSetlistCopyTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.venues_setlist_copy.title", defaultValue: "会場から探せる・セトリが見やすく", table: "Announcements", bundle: L10n.bundle)
        }
        /// ウィジェットのスライドショーに出す画像を、ギャラリーで1枚ずつ選べるようになりました。サムネを長押しして「スライドショーから外す/入れる」を切り替えられます。お気に入りだけを回すこともできます。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 1 段落目
        static var widgetPolishBodyP1: LocalizedStringResource {
            LocalizedStringResource("announcements.widget_polish.body.p1", defaultValue: "ウィジェットのスライドショーに出す画像を、ギャラリーで1枚ずつ選べるようになりました。サムネを長押しして「スライドショーから外す/入れる」を切り替えられます。お気に入りだけを回すこともできます。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ウィジェット編集でアイドルを選ぶとき、検索で絞り込めるようになり、ブランド名も表示されるようになりました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 2 段落目
        static var widgetPolishBodyP2: LocalizedStringResource {
            LocalizedStringResource("announcements.widget_polish.body.p2", defaultValue: "ウィジェット編集でアイドルを選ぶとき、検索で絞り込めるようになり、ブランド名も表示されるようになりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ギャラリーの表示や、画像まわりの細かな不具合を修正しました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の本文 3 段落目
        static var widgetPolishBodyP3: LocalizedStringResource {
            LocalizedStringResource("announcements.widget_polish.body.p3", defaultValue: "ギャラリーの表示や、画像まわりの細かな不具合を修正しました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// ウィジェットに出す画像を選べるようになり、アイドル選択も探しやすくなりました。 — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の一覧に出す要約
        static var widgetPolishSummary: LocalizedStringResource {
            LocalizedStringResource("announcements.widget_polish.summary", defaultValue: "ウィジェットに出す画像を選べるようになり、アイドル選択も探しやすくなりました。", table: "Announcements", bundle: L10n.bundle)
        }
        /// スライドショーの画像を選べるように — お知らせ (id: v1.7.1_widget_polish, 2026-06-19) の見出し
        static var widgetPolishTitle: LocalizedStringResource {
            LocalizedStringResource("announcements.widget_polish.title", defaultValue: "スライドショーの画像を選べるように", table: "Announcements", bundle: L10n.bundle)
        }
    }
}
