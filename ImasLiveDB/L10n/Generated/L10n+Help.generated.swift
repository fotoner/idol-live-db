// 生成物: i18n/catalog/help.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/help.json の文言 (表 Help)
    enum Help {
        /// それぞれ別色で表示。タップで詳細にジャンプ。 — ヘルプ「カレンダー」の項目の説明
        static var categoryCalendarColorsDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.colors.detail", defaultValue: "それぞれ別色で表示。タップで詳細にジャンプ。", table: "Help", bundle: L10n.bundle)
        }
        /// ライブ・リリース・誕生日を色分け — ヘルプ「カレンダー」の項目の見出し
        static var categoryCalendarColorsLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.colors.label", defaultValue: "ライブ・リリース・誕生日を色分け", table: "Help", bundle: L10n.bundle)
        }
        /// 月単位で全アイマスイベントを俯瞰。 — ヘルプ「カレンダー」の項目の説明
        static var categoryCalendarOpenDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.open.detail", defaultValue: "月単位で全アイマスイベントを俯瞰。", table: "Help", bundle: L10n.bundle)
        }
        /// プロデュースタブ → カレンダー — ヘルプ「カレンダー」の項目の見出し。iOS の文言 (カレンダーの場所。Android は label_android)。タブの名前は nav.tab.* の訳に合わせる
        static var categoryCalendarOpenLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.open.label", defaultValue: "プロデュースタブ → カレンダー", table: "Help", bundle: L10n.bundle)
        }
        /// ライブ・CD リリース・アイドル誕生日を月別に表示。 — ヘルプの機能カテゴリ「カレンダー」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryCalendarSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.summary", defaultValue: "ライブ・CD リリース・アイドル誕生日を月別に表示。", table: "Help", bundle: L10n.bundle)
        }
        /// カレンダー — ヘルプの機能カテゴリ「カレンダー」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryCalendarTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.calendar.title", defaultValue: "カレンダー", table: "Help", bundle: L10n.bundle)
        }
        /// 編集した数と「良かった」をもらった数で貢献度が積み上がり、マイページに称号バッジとして表示されます。 — ヘルプ「みんなで編集」の項目の説明。「良かった」は編集に付けるリアクションのボタンの文言 (ko はそちらの訳に合わせる)
        static var categoryEditContributionDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.contribution.detail", defaultValue: "編集した数と「良かった」をもらった数で貢献度が積み上がり、マイページに称号バッジとして表示されます。", table: "Help", bundle: L10n.bundle)
        }
        /// 貢献が積み上がる — ヘルプ「みんなで編集」の項目の見出し
        static var categoryEditContributionLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.contribution.label", defaultValue: "貢献が積み上がる", table: "Help", bundle: L10n.bundle)
        }
        /// 承認待ちはありません。ログインユーザーがセトリ・新曲・新イベント・参考動画などを直接追加・修正でき、CloudKit 経由ですぐ全員の端末に届きます。Wikipedia のような共同編集スタイルです。 — ヘルプ「みんなで編集」の項目の説明。CloudKit・Wikipedia はサービス名なので訳さない
        static var categoryEditDirectDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.direct.detail", defaultValue: "承認待ちはありません。ログインユーザーがセトリ・新曲・新イベント・参考動画などを直接追加・修正でき、CloudKit 経由ですぐ全員の端末に届きます。Wikipedia のような共同編集スタイルです。", table: "Help", bundle: L10n.bundle)
        }
        /// 直接編集して、すぐ反映 — ヘルプ「みんなで編集」の項目の見出し
        static var categoryEditDirectLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.direct.label", defaultValue: "直接編集して、すぐ反映", table: "Help", bundle: L10n.bundle)
        }
        /// 誰がいつ何を変えたかが変更前後つきで記録されます。各データの編集履歴や、プロデュースタブの「最近の編集」フィードからたどれます。 — ヘルプ「みんなで編集」の項目の説明。「最近の編集」はプロデュースタブの節の文言 (ko はそちらの訳に合わせる)
        static var categoryEditHistoryDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.history.detail", defaultValue: "誰がいつ何を変えたかが変更前後つきで記録されます。各データの編集履歴や、プロデュースタブの「最近の編集」フィードからたどれます。", table: "Help", bundle: L10n.bundle)
        }
        /// すべての編集に履歴が残る — ヘルプ「みんなで編集」の項目の見出し
        static var categoryEditHistoryLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.history.label", defaultValue: "すべての編集に履歴が残る", table: "Help", bundle: L10n.bundle)
        }
        /// 他の人の編集に「良かった」を付けられます。人気・感謝の指標で、付けた数・もらった数がマイページに表示されます。 — ヘルプ「みんなで編集」の項目の説明。「良かった」は編集に付けるリアクションのボタンの文言 (ko はそちらの訳に合わせる)
        static var categoryEditLikesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.likes.detail", defaultValue: "他の人の編集に「良かった」を付けられます。人気・感謝の指標で、付けた数・もらった数がマイページに表示されます。", table: "Help", bundle: L10n.bundle)
        }
        /// 「良かった」で感謝を伝える — ヘルプ「みんなで編集」の項目の見出し
        static var categoryEditLikesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.likes.label", defaultValue: "「良かった」で感謝を伝える", table: "Help", bundle: L10n.bundle)
        }
        /// 閲覧はログイン不要。編集に参加したい時だけマイページからログインしてください。各画面の「+」や鉛筆アイコンから編集できます。 — ヘルプ「みんなで編集」の項目の説明。iOS の文言 (Android はログインの手段と場所が違うので *_android)。Sign in with Apple はサービス名なので訳さない
        static var categoryEditLoginDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.login.detail", defaultValue: "閲覧はログイン不要。編集に参加したい時だけマイページからログインしてください。各画面の「+」や鉛筆アイコンから編集できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 編集には Sign in with Apple — ヘルプ「みんなで編集」の項目の見出し。iOS の文言 (Android はログインの手段と場所が違うので *_android)。ko は Apple の公式表記『Apple로 로그인』(ボタンの表示と同じ)
        static var categoryEditLoginLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.login.label", defaultValue: "編集には Sign in with Apple", table: "Help", bundle: L10n.bundle)
        }
        /// 自分の編集はいつでも取り消せます。誤りや荒らしはワンタップで元に戻され、悪質な場合はアカウントが利用停止になります。安心して編集してください。 — ヘルプ「みんなで編集」の項目の説明
        static var categoryEditRevertDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.revert.detail", defaultValue: "自分の編集はいつでも取り消せます。誤りや荒らしはワンタップで元に戻され、悪質な場合はアカウントが利用停止になります。安心して編集してください。", table: "Help", bundle: L10n.bundle)
        }
        /// 間違いはすぐ戻せる — ヘルプ「みんなで編集」の項目の見出し
        static var categoryEditRevertLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.revert.label", defaultValue: "間違いはすぐ戻せる", table: "Help", bundle: L10n.bundle)
        }
        /// ログインすればセトリ・楽曲・ライブ情報を直接編集でき、その場で全員に反映されます。 — ヘルプの機能カテゴリ「みんなで編集」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryEditSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.summary", defaultValue: "ログインすればセトリ・楽曲・ライブ情報を直接編集でき、その場で全員に反映されます。", table: "Help", bundle: L10n.bundle)
        }
        /// みんなで編集 — ヘルプの機能カテゴリ「みんなで編集」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryEditTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.edit.title", defaultValue: "みんなで編集", table: "Help", bundle: L10n.bundle)
        }
        /// 詳細画面から「参加した」をオンにすると、マイページの参加カウントに加算されます。 — ヘルプ「ライブを探す」の項目の説明。「参加した」はライブ詳細のトグルの文言 (ko はそちらの訳に合わせる)
        static var categoryEventsAttendedDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.events.attended.detail", defaultValue: "詳細画面から「参加した」をオンにすると、マイページの参加カウントに加算されます。", table: "Help", bundle: L10n.bundle)
        }
        /// 参加したライブを記録 — ヘルプ「ライブを探す」の項目の見出し
        static var categoryEventsAttendedLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.events.attended.label", defaultValue: "参加したライブを記録", table: "Help", bundle: L10n.bundle)
        }
        /// 右上の絞り込みボタンから、765AS / シンデレラ / ミリオン / SideM / シャニ / 学マス / ヴイアラ など特定ブランドだけに絞れます。 — ヘルプ「ライブを探す」の項目の説明。ブランドの略称は ko のファンが使う呼び方にした (ヴイアラは正式表記の vα-liv)
        static var categoryEventsBrandFilterDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.events.brand_filter.detail", defaultValue: "右上の絞り込みボタンから、765AS / シンデレラ / ミリオン / SideM / シャニ / 学マス / ヴイアラ など特定ブランドだけに絞れます。", table: "Help", bundle: L10n.bundle)
        }
        /// ブランドでフィルタ — ヘルプ「ライブを探す」の項目の見出し
        static var categoryEventsBrandFilterLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.events.brand_filter.label", defaultValue: "ブランドでフィルタ", table: "Help", bundle: L10n.bundle)
        }
        /// ライブをタップすると、公演日ごとのセトリ、出演アイドル、参考動画、チケット情報まで確認できます。 — ヘルプ「ライブを探す」の項目の説明
        static var categoryEventsEventDetailDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.events.event_detail.detail", defaultValue: "ライブをタップすると、公演日ごとのセトリ、出演アイドル、参考動画、チケット情報まで確認できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 詳細でセトリ・出演者・チケット情報を確認 — ヘルプ「ライブを探す」の項目の見出し
        static var categoryEventsEventDetailLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.events.event_detail.label", defaultValue: "詳細でセトリ・出演者・チケット情報を確認", table: "Help", bundle: L10n.bundle)
        }
        /// 本ライブ・配信・イベント・その他を切り替え可能。配信中心の活動だけ追いたい時に便利。 — ヘルプ「ライブを探す」の項目の説明。live / stream / event / other はデータの種別の名前なので訳さない
        static var categoryEventsKindFilterDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.events.kind_filter.detail", defaultValue: "本ライブ・配信・イベント・その他を切り替え可能。配信中心の活動だけ追いたい時に便利。", table: "Help", bundle: L10n.bundle)
        }
        /// 種別 (live / stream / event / other) で絞れる — ヘルプ「ライブを探す」の項目の見出し
        static var categoryEventsKindFilterLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.events.kind_filter.label", defaultValue: "種別 (live / stream / event / other) で絞れる", table: "Help", bundle: L10n.bundle)
        }
        /// 全ブランドのライブ・公演・セットリストを年別に閲覧できます。 — ヘルプの機能カテゴリ「ライブを探す」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryEventsSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.events.summary", defaultValue: "全ブランドのライブ・公演・セットリストを年別に閲覧できます。", table: "Help", bundle: L10n.bundle)
        }
        /// ライブを探す — ヘルプの機能カテゴリ「ライブを探す」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryEventsTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.events.title", defaultValue: "ライブを探す", table: "Help", bundle: L10n.bundle)
        }
        /// 1000公演以上を年で分けて表示。新しい順なので、最新のライブから過去まで一気に俯瞰できます。 — ヘルプ「ライブを探す」の項目の説明
        static var categoryEventsYearListDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.events.year_list.detail", defaultValue: "1000公演以上を年で分けて表示。新しい順なので、最新のライブから過去まで一気に俯瞰できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 年別リストで時系列に追える — ヘルプ「ライブを探す」の項目の見出し
        static var categoryEventsYearListLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.events.year_list.label", defaultValue: "年別リストで時系列に追える", table: "Help", bundle: L10n.bundle)
        }
        /// ロコ ↔ 伴田路子 のような別名表記も内部で同一アイドルとして紐づいています。 — ヘルプ「アイドル・CVを探す」の項目の説明。ロコ・伴田路子 はアイドル名 (データ。検索も ja の名前で引く) なので訳さない
        static var categoryIdolsAliasesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.aliases.detail", defaultValue: "ロコ ↔ 伴田路子 のような別名表記も内部で同一アイドルとして紐づいています。", table: "Help", bundle: L10n.bundle)
        }
        /// 別名 (aliases) も検索対象 — ヘルプ「アイドル・CVを探す」の項目の見出し
        static var categoryIdolsAliasesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.aliases.label", defaultValue: "別名 (aliases) も検索対象", table: "Help", bundle: L10n.bundle)
        }
        /// キュート/クール/パッション (CG)、 Fairy/Angel/Princess (ML)、 1年/3年 (学マス) などブランドごとの属性で絞れます。 — ヘルプ「アイドル・CVを探す」の項目の説明。属性の名前は絞り込みパネルの文言 (ko はそちらの訳に合わせる)。CG / ML はブランドの略号
        static var categoryIdolsAttributesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.attributes.detail", defaultValue: "キュート/クール/パッション (CG)、 Fairy/Angel/Princess (ML)、 1年/3年 (学マス) などブランドごとの属性で絞れます。", table: "Help", bundle: L10n.bundle)
        }
        /// 属性で絞り込み — ヘルプ「アイドル・CVを探す」の項目の見出し
        static var categoryIdolsAttributesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.attributes.label", defaultValue: "属性で絞り込み", table: "Help", bundle: L10n.bundle)
        }
        /// 絞り込みパネルから「CV名で表示」に切り替えると、 声優名で一覧化されます。 — ヘルプ「アイドル・CVを探す」の項目の説明。「CV名で表示」は絞り込みパネルの文言 (ko はそちらの訳に合わせる)
        static var categoryIdolsCvNamesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.cv_names.detail", defaultValue: "絞り込みパネルから「CV名で表示」に切り替えると、 声優名で一覧化されます。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル名 ↔ CV 名 で表示切替 — ヘルプ「アイドル・CVを探す」の項目の見出し
        static var categoryIdolsCvNamesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.cv_names.label", defaultValue: "アイドル名 ↔ CV 名 で表示切替", table: "Help", bundle: L10n.bundle)
        }
        /// アイドルをタップすると、担当曲リスト・出演ライブ・誕生日・カラーが見られます。 — ヘルプ「アイドル・CVを探す」の項目の説明。ここの担当曲はそのアイドルが歌う曲 (ユーザーの担当ではない)
        static var categoryIdolsIdolDetailDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.idol_detail.detail", defaultValue: "アイドルをタップすると、担当曲リスト・出演ライブ・誕生日・カラーが見られます。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル詳細で担当曲・出演ライブを確認 — ヘルプ「アイドル・CVを探す」の項目の見出し。ここの担当曲はそのアイドルが歌う曲 (ユーザーの担当ではない)
        static var categoryIdolsIdolDetailLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.idol_detail.label", defaultValue: "アイドル詳細で担当曲・出演ライブを確認", table: "Help", bundle: L10n.bundle)
        }
        /// 上部の切り替えボタンで、密な一覧 (リスト) と画像中心のグリッドを切り替えられます。 — ヘルプ「アイドル・CVを探す」の項目の説明
        static var categoryIdolsLayoutDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.layout.detail", defaultValue: "上部の切り替えボタンで、密な一覧 (リスト) と画像中心のグリッドを切り替えられます。", table: "Help", bundle: L10n.bundle)
        }
        /// リスト / グリッド 切り替え — ヘルプ「アイドル・CVを探す」の項目の見出し
        static var categoryIdolsLayoutLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.layout.label", defaultValue: "リスト / グリッド 切り替え", table: "Help", bundle: L10n.bundle)
        }
        /// 全ブランドのアイドルを名前・CV名・属性で横断検索できます。 — ヘルプの機能カテゴリ「アイドル・CVを探す」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryIdolsSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.summary", defaultValue: "全ブランドのアイドルを名前・CV名・属性で横断検索できます。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル・CVを探す — ヘルプの機能カテゴリ「アイドル・CVを探す」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryIdolsTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.idols.title", defaultValue: "アイドル・CVを探す", table: "Help", bundle: L10n.bundle)
        }
        /// 型紙には別名表記も含まれているので、 ロコ でも 伴田路子 でも好きな表記の URL を書けます。 — ヘルプ「画像インポート」の項目の説明。ロコ・伴田路子 はアイドル名 (データ。型紙の JSON のキーも ja の名前) なので訳さない
        static var categoryImageImportAliasesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.aliases.detail", defaultValue: "型紙には別名表記も含まれているので、 ロコ でも 伴田路子 でも好きな表記の URL を書けます。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル別名にも対応 — ヘルプ「画像インポート」の項目の見出し
        static var categoryImageImportAliasesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.aliases.label", defaultValue: "アイドル別名にも対応", table: "Help", bundle: L10n.bundle)
        }
        /// JSON で {{アイドル名: 画像URL}} の形式を渡せば、まとめてダウンロード+保存できます。 — ヘルプ「画像インポート」の項目の説明。{アイドル名: 画像URL} は取り込む JSON の形の説明 (キーがアイドル名、値が画像の URL)
        static var categoryImageImportOpenDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.open.detail", defaultValue: "JSON で {アイドル名: 画像URL} の形式を渡せば、まとめてダウンロード+保存できます。", table: "Help", bundle: L10n.bundle)
        }
        /// マイページ → 画像インポート — ヘルプ「画像インポート」の項目の見出し。iOS の文言 (画像の取り込みの場所。Android は label_android)。メニューの名前は ko もそちらの訳に合わせる
        static var categoryImageImportOpenLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.open.label", defaultValue: "マイページ → 画像インポート", table: "Help", bundle: L10n.bundle)
        }
        /// 失敗したり差し替えたい時は「カスタム画像を全削除」でリセットできます。 — ヘルプ「画像インポート」の項目の説明。「カスタム画像を全削除」は画像の取り込み画面のボタンの文言 (ko はそちらの訳に合わせる)
        static var categoryImageImportResetDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.reset.detail", defaultValue: "失敗したり差し替えたい時は「カスタム画像を全削除」でリセットできます。", table: "Help", bundle: L10n.bundle)
        }
        /// 全画像リセット可能 — ヘルプ「画像インポート」の項目の見出し
        static var categoryImageImportResetLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.reset.label", defaultValue: "全画像リセット可能", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル・ブランドのアイコン画像を一括取り込み。 — ヘルプの機能カテゴリ「画像インポート」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryImageImportSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.summary", defaultValue: "アイドル・ブランドのアイコン画像を一括取り込み。", table: "Help", bundle: L10n.bundle)
        }
        /// アプリ内から型紙 (全アイドル/全ブランド名がキーになった JSON) を書き出せます。それに画像URLを書き足すだけ。 — ヘルプ「画像インポート」の項目の説明。型紙 = 取り込み用の JSON のひな形
        static var categoryImageImportTemplateDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.template.detail", defaultValue: "アプリ内から型紙 (全アイドル/全ブランド名がキーになった JSON) を書き出せます。それに画像URLを書き足すだけ。", table: "Help", bundle: L10n.bundle)
        }
        /// 型紙 JSON をダウンロード — ヘルプ「画像インポート」の項目の見出し
        static var categoryImageImportTemplateLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.template.label", defaultValue: "型紙 JSON をダウンロード", table: "Help", bundle: L10n.bundle)
        }
        /// 画像インポート — ヘルプの機能カテゴリ「画像インポート」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryImageImportTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.image_import.title", defaultValue: "画像インポート", table: "Help", bundle: L10n.bundle)
        }
        /// ブランドごとに自己ベストが残ります。 — ヘルプ「イントロドン」の項目の説明
        static var categoryIntroBestDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.best.detail", defaultValue: "ブランドごとに自己ベストが残ります。", table: "Help", bundle: L10n.bundle)
        }
        /// ベストスコアを記録 — ヘルプ「イントロドン」の項目の見出し
        static var categoryIntroBestLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.best.label", defaultValue: "ベストスコアを記録", table: "Help", bundle: L10n.bundle)
        }
        /// ブランド絞り込みや、再生秒数で難易度調整できます。 — ヘルプ「イントロドン」の項目の説明
        static var categoryIntroDifficultyDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.difficulty.detail", defaultValue: "ブランド絞り込みや、再生秒数で難易度調整できます。", table: "Help", bundle: L10n.bundle)
        }
        /// ブランド・難易度を選択 — ヘルプ「イントロドン」の項目の見出し
        static var categoryIntroDifficultyLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.difficulty.label", defaultValue: "ブランド・難易度を選択", table: "Help", bundle: L10n.bundle)
        }
        /// Apple Music サブスク加入者はカタログのフル再生、未加入でも 30 秒プレビューで遊べます。 — ヘルプ「イントロドン」の項目の説明。iOS だけの項目 (Android は intro.streamable)。サブスク = Apple Music の定額契約
        static var categoryIntroPreviewDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.preview.detail", defaultValue: "Apple Music サブスク加入者はカタログのフル再生、未加入でも 30 秒プレビューで遊べます。", table: "Help", bundle: L10n.bundle)
        }
        /// 未加入でもプレビュー再生で遊べる — ヘルプ「イントロドン」の項目の見出し。iOS だけの項目 (Android は intro.streamable)。サブスク = Apple Music の定額契約
        static var categoryIntroPreviewLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.preview.label", defaultValue: "未加入でもプレビュー再生で遊べる", table: "Help", bundle: L10n.bundle)
        }
        /// 曲のイントロを聴いて曲名を当てるクイズ。 — ヘルプの機能カテゴリ「イントロドン」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryIntroSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.summary", defaultValue: "曲のイントロを聴いて曲名を当てるクイズ。", table: "Help", bundle: L10n.bundle)
        }
        /// イントロドン — ヘルプの機能カテゴリ「イントロドン」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryIntroTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.title", defaultValue: "イントロドン", table: "Help", bundle: L10n.bundle)
        }
        /// マイクで曲名を読み上げると、 Speech 認識で自動回答できます。 — ヘルプ「イントロドン」の項目の説明。iOS だけの項目 (Android は intro.choices)。Speech は Apple の音声認識のフレームワーク名
        static var categoryIntroVoiceDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.voice.detail", defaultValue: "マイクで曲名を読み上げると、 Speech 認識で自動回答できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 音声入力で回答可能 — ヘルプ「イントロドン」の項目の見出し。iOS だけの項目 (Android は intro.choices)。Speech は Apple の音声認識のフレームワーク名
        static var categoryIntroVoiceLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.intro.voice.label", defaultValue: "音声入力で回答可能", table: "Help", bundle: L10n.bundle)
        }
        /// ライブ詳細から「参加した」を付けると、マイページに参加履歴が積み上がります。 — ヘルプ「マイマーク（記録）」の項目の説明。「参加した」はライブ詳細のトグルの文言 (ko はそちらの訳に合わせる)
        static var categoryMarksAttendedDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.attended.detail", defaultValue: "ライブ詳細から「参加した」を付けると、マイページに参加履歴が積み上がります。", table: "Help", bundle: L10n.bundle)
        }
        /// 参加ライブ — ヘルプ「マイマーク（記録）」の項目の見出し
        static var categoryMarksAttendedLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.attended.label", defaultValue: "参加ライブ", table: "Help", bundle: L10n.bundle)
        }
        /// 曲詳細から「回収済」を付けると、自分のコレクション管理ができます。楽曲一覧で「回収済のみ」表示も可能。 — ヘルプ「マイマーク（記録）」の項目の説明。「回収済」「回収済のみ」は楽曲の画面の文言 (ko はそちらの訳に合わせる)
        static var categoryMarksCollectedDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.collected.detail", defaultValue: "曲詳細から「回収済」を付けると、自分のコレクション管理ができます。楽曲一覧で「回収済のみ」表示も可能。", table: "Help", bundle: L10n.bundle)
        }
        /// 回収済 (持ってる) 楽曲 — ヘルプ「マイマーク（記録）」の項目の見出し
        static var categoryMarksCollectedLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.collected.label", defaultValue: "回収済 (持ってる) 楽曲", table: "Help", bundle: L10n.bundle)
        }
        /// ローカル保存されるので、ログインなしで使えます。 CloudKit 同期にも対応 (端末間で同期可能)。 — ヘルプ「マイマーク（記録）」の項目の説明。iOS の文言 (Android は端末間の移し方が違うので detail_android)
        static var categoryMarksLocalDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.local.detail", defaultValue: "ローカル保存されるので、ログインなしで使えます。 CloudKit 同期にも対応 (端末間で同期可能)。", table: "Help", bundle: L10n.bundle)
        }
        /// マイマークは端末に保存 — ヘルプ「マイマーク（記録）」の項目の見出し
        static var categoryMarksLocalLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.local.label", defaultValue: "マイマークは端末に保存", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル詳細から「担当」を付けると、マイページに集約されて確認できます。 — ヘルプ「マイマーク（記録）」の項目の説明。「担当」はアイドル詳細のマイマークの文言
        static var categoryMarksOshiDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.oshi.detail", defaultValue: "アイドル詳細から「担当」を付けると、マイページに集約されて確認できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 担当アイドル — ヘルプ「マイマーク（記録）」の項目の見出し
        static var categoryMarksOshiLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.oshi.label", defaultValue: "担当アイドル", table: "Help", bundle: L10n.bundle)
        }
        /// 担当アイドル・回収済楽曲・参加ライブを記録できます。 — ヘルプの機能カテゴリ「マイマーク（記録）」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryMarksSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.summary", defaultValue: "担当アイドル・回収済楽曲・参加ライブを記録できます。", table: "Help", bundle: L10n.bundle)
        }
        /// マイマーク（記録） — ヘルプの機能カテゴリ「マイマーク（記録）」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryMarksTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.marks.title", defaultValue: "マイマーク（記録）", table: "Help", bundle: L10n.bundle)
        }
        /// 同じ曲に複数回投票しても、最新の選択で上書きされます (端末単位)。 — ヘルプ「ペンライト投票」の項目の説明
        static var categoryPenlightOneVoteDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.one_vote.detail", defaultValue: "同じ曲に複数回投票しても、最新の選択で上書きされます (端末単位)。", table: "Help", bundle: L10n.bundle)
        }
        /// 1 端末 1 票で差し替え可能 — ヘルプ「ペンライト投票」の項目の見出し
        static var categoryPenlightOneVoteLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.one_vote.label", defaultValue: "1 端末 1 票で差し替え可能", table: "Help", bundle: L10n.bundle)
        }
        /// 投票結果は色セット別の票数で表示。ライブ前の「色合わせ」用にどうぞ。 — ヘルプ「ペンライト投票」の項目の説明
        static var categoryPenlightResultsDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.results.detail", defaultValue: "投票結果は色セット別の票数で表示。ライブ前の「色合わせ」用にどうぞ。", table: "Help", bundle: L10n.bundle)
        }
        /// 集計結果を確認 — ヘルプ「ペンライト投票」の項目の見出し
        static var categoryPenlightResultsLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.results.label", defaultValue: "集計結果を確認", table: "Help", bundle: L10n.bundle)
        }
        /// 曲ごとの「振る色」をみんなで投票して可視化。 — ヘルプの機能カテゴリ「ペンライト投票」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryPenlightSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.summary", defaultValue: "曲ごとの「振る色」をみんなで投票して可視化。", table: "Help", bundle: L10n.bundle)
        }
        /// ペンライト投票 — ヘルプの機能カテゴリ「ペンライト投票」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryPenlightTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.title", defaultValue: "ペンライト投票", table: "Help", bundle: L10n.bundle)
        }
        /// 公式パレットの中から、その曲で振りたい色 (単色 / 複数色) を選んで投票できます。 — ヘルプ「ペンライト投票」の項目の説明
        static var categoryPenlightVoteDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.vote.detail", defaultValue: "公式パレットの中から、その曲で振りたい色 (単色 / 複数色) を選んで投票できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 曲詳細から好きな色セットを投票 — ヘルプ「ペンライト投票」の項目の見出し
        static var categoryPenlightVoteLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.penlight.vote.label", defaultValue: "曲詳細から好きな色セットを投票", table: "Help", bundle: L10n.bundle)
        }
        /// 「ロコ」と検索しても「伴田路子」がヒット。シャニやミリの別名表記も内部で名寄せ済み。 — ヘルプ「検索」の項目の説明。ロコ・伴田路子 はアイドル名 (データ。検索も ja の名前で引く) なので訳さない。シャニ・ミリはブランドの略称 (ko のファンの呼び方にする。events.brand_filter と揃える)
        static var categorySearchAliasesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.search.aliases.detail", defaultValue: "「ロコ」と検索しても「伴田路子」がヒット。シャニやミリの別名表記も内部で名寄せ済み。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル別名にも対応 — ヘルプ「検索」の項目の見出し
        static var categorySearchAliasesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.search.aliases.label", defaultValue: "アイドル別名にも対応", table: "Help", bundle: L10n.bundle)
        }
        /// タブ内検索で結果が無いときは「全体から検索」ボタンが出ます。同じ語句のまま 1 タップで横断検索に切り替えられます。 — ヘルプ「検索」の項目の説明。「全体から検索」は検索結果が無いときに出るボタンの文言 (ko はそちらの訳に合わせる)
        static var categorySearchFallbackDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.search.fallback.detail", defaultValue: "タブ内検索で結果が無いときは「全体から検索」ボタンが出ます。同じ語句のまま 1 タップで横断検索に切り替えられます。", table: "Help", bundle: L10n.bundle)
        }
        /// 見つからなければ全体検索へ — ヘルプ「検索」の項目の見出し
        static var categorySearchFallbackLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.search.fallback.label", defaultValue: "見つからなければ全体検索へ", table: "Help", bundle: L10n.bundle)
        }
        /// 左上のキラキラ虫眼鏡から、楽曲・アイドル・ライブをまとめて横断検索できます。タブをまたいで一気に目的の項目へ飛べます。 — ヘルプ「検索」の項目の説明。iOS の文言 (全体検索のボタンの位置と形が Android と違う)
        static var categorySearchGlobalDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.search.global.detail", defaultValue: "左上のキラキラ虫眼鏡から、楽曲・アイドル・ライブをまとめて横断検索できます。タブをまたいで一気に目的の項目へ飛べます。", table: "Help", bundle: L10n.bundle)
        }
        /// 全体検索 = 横断して探す — ヘルプ「検索」の項目の見出し
        static var categorySearchGlobalLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.search.global.label", defaultValue: "全体検索 = 横断して探す", table: "Help", bundle: L10n.bundle)
        }
        /// ライブ / 楽曲 / アイドル 各タブの検索バーは、いま表示中の一覧 (適用中の絞り込みも含む) をその場で絞り込みます。 — ヘルプ「検索」の項目の説明。ライブ / 楽曲 / アイドル は下のタブの名前 (nav.tab.* の訳に合わせる)
        static var categorySearchInTabDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.search.in_tab.detail", defaultValue: "ライブ / 楽曲 / アイドル 各タブの検索バーは、いま表示中の一覧 (適用中の絞り込みも含む) をその場で絞り込みます。", table: "Help", bundle: L10n.bundle)
        }
        /// タブ内検索 = この一覧を絞り込む — ヘルプ「検索」の項目の見出し
        static var categorySearchInTabLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.search.in_tab.label", defaultValue: "タブ内検索 = この一覧を絞り込む", table: "Help", bundle: L10n.bundle)
        }
        /// 「このタブを絞り込む」検索と、「全体を横断する」検索の 2 種類があります。 — ヘルプの機能カテゴリ「検索」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categorySearchSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.search.summary", defaultValue: "「このタブを絞り込む」検索と、「全体を横断する」検索の 2 種類があります。", table: "Help", bundle: L10n.bundle)
        }
        /// 検索 — ヘルプの機能カテゴリ「検索」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categorySearchTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.search.title", defaultValue: "検索", table: "Help", bundle: L10n.bundle)
        }
        /// Apple Music に契約していればプレビュー再生 / フル再生 OK。ジャケ写も自動取得。 — ヘルプ「楽曲を探す」の項目の説明。iOS だけの項目 (Android は songs.preview)。ジャケ写 = ジャケット写真
        static var categorySongsAppleMusicDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.apple_music.detail", defaultValue: "Apple Music に契約していればプレビュー再生 / フル再生 OK。ジャケ写も自動取得。", table: "Help", bundle: L10n.bundle)
        }
        /// Apple Music 連携 — ヘルプ「楽曲を探す」の項目の見出し。iOS だけの項目 (Android は songs.preview)。ジャケ写 = ジャケット写真
        static var categorySongsAppleMusicLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.apple_music.label", defaultValue: "Apple Music 連携", table: "Help", bundle: L10n.bundle)
        }
        /// マイマークで「回収済」を付けた曲だけ、または未回収だけを表示できます。 — ヘルプ「楽曲を探す」の項目の説明。「回収済」は楽曲のマイマークの文言 (ko はそちらの訳に合わせる)
        static var categorySongsCollectFilterDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.collect_filter.detail", defaultValue: "マイマークで「回収済」を付けた曲だけ、または未回収だけを表示できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 回収済 / 未回収で絞り込み — ヘルプ「楽曲を探す」の項目の見出し
        static var categorySongsCollectFilterLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.collect_filter.label", defaultValue: "回収済 / 未回収で絞り込み", table: "Help", bundle: L10n.bundle)
        }
        /// 曲詳細から「どのライブで何回歌われたか」を一覧表示。担当曲の披露頻度がわかります。 — ヘルプ「楽曲を探す」の項目の説明
        static var categorySongsHistoryDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.history.detail", defaultValue: "曲詳細から「どのライブで何回歌われたか」を一覧表示。担当曲の披露頻度がわかります。", table: "Help", bundle: L10n.bundle)
        }
        /// 歌唱履歴で深掘り — ヘルプ「楽曲を探す」の項目の見出し
        static var categorySongsHistoryLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.history.label", defaultValue: "歌唱履歴で深掘り", table: "Help", bundle: L10n.bundle)
        }
        /// 曲のアイコン群はオリジナル歌唱メンバー (ライブ歌唱者ではなく)。ユニット曲はユニット名で表示されます。 — ヘルプ「楽曲を探す」の項目の説明
        static var categorySongsOriginalMembersDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.original_members.detail", defaultValue: "曲のアイコン群はオリジナル歌唱メンバー (ライブ歌唱者ではなく)。ユニット曲はユニット名で表示されます。", table: "Help", bundle: L10n.bundle)
        }
        /// オリジナルメンバーを表示 — ヘルプ「楽曲を探す」の項目の見出し
        static var categorySongsOriginalMembersLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.original_members.label", defaultValue: "オリジナルメンバーを表示", table: "Help", bundle: L10n.bundle)
        }
        /// 2300曲以上を曲名・アルバム・シリーズで探索できます。 — ヘルプの機能カテゴリ「楽曲を探す」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categorySongsSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.summary", defaultValue: "2300曲以上を曲名・アルバム・シリーズで探索できます。", table: "Help", bundle: L10n.bundle)
        }
        /// 楽曲を探す — ヘルプの機能カテゴリ「楽曲を探す」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categorySongsTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.title", defaultValue: "楽曲を探す", table: "Help", bundle: L10n.bundle)
        }
        /// 曲一覧 / アルバムグリッド / シリーズグリッド を絞り込みパネルから切り替え可能。 — ヘルプ「楽曲を探す」の項目の説明
        static var categorySongsViewModesDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.view_modes.detail", defaultValue: "曲一覧 / アルバムグリッド / シリーズグリッド を絞り込みパネルから切り替え可能。", table: "Help", bundle: L10n.bundle)
        }
        /// 3 つの表示モード — ヘルプ「楽曲を探す」の項目の見出し
        static var categorySongsViewModesLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.songs.view_modes.label", defaultValue: "3 つの表示モード", table: "Help", bundle: L10n.bundle)
        }
        /// 新しいライブやセトリは CloudKit から差分配信されます。アプリ更新を待たずに最新化されます。 — ヘルプ「同期とアカウント」の項目の説明
        static var categorySyncCloudkitDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.cloudkit.detail", defaultValue: "新しいライブやセトリは CloudKit から差分配信されます。アプリ更新を待たずに最新化されます。", table: "Help", bundle: L10n.bundle)
        }
        /// マスタデータは CloudKit で自動同期 — ヘルプ「同期とアカウント」の項目の見出し
        static var categorySyncCloudkitLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.cloudkit.label", defaultValue: "マスタデータは CloudKit で自動同期", table: "Help", bundle: L10n.bundle)
        }
        /// マイページ → アカウントを削除 で、サーバー上の編集履歴とユーザー情報をすべて削除します。 — ヘルプ「同期とアカウント」の項目の説明。「アカウントを削除」はマイページのボタンの文言 (ko はそちらの訳に合わせる)
        static var categorySyncDeleteAccountDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.delete_account.detail", defaultValue: "マイページ → アカウントを削除 で、サーバー上の編集履歴とユーザー情報をすべて削除します。", table: "Help", bundle: L10n.bundle)
        }
        /// アカウント削除も可能 — ヘルプ「同期とアカウント」の項目の見出し
        static var categorySyncDeleteAccountLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.delete_account.label", defaultValue: "アカウント削除も可能", table: "Help", bundle: L10n.bundle)
        }
        /// 閲覧機能には不要。データを編集したい時だけログインしてください。 — ヘルプ「同期とアカウント」の項目の説明
        static var categorySyncLoginDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.login.detail", defaultValue: "閲覧機能には不要。データを編集したい時だけログインしてください。", table: "Help", bundle: L10n.bundle)
        }
        /// Sign in with Apple は編集用 — ヘルプ「同期とアカウント」の項目の見出し。iOS の文言 (Android はログインの手段が違うので label_android)。ko は Apple の公式表記『Apple로 로그인』(ボタンの表示と同じ)
        static var categorySyncLoginLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.login.label", defaultValue: "Sign in with Apple は編集用", table: "Help", bundle: L10n.bundle)
        }
        /// CloudKit で常に最新のデータ、 Sign in with Apple で編集に参加。 — ヘルプの機能カテゴリ「同期とアカウント」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)。Android でも ja は Sign in with Apple のまま (文面の見直しはオーナーが別 PR で)。ko は Apple の公式表記『Apple로 로그인』(ボタンの表示と同じ)
        static var categorySyncSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.summary", defaultValue: "CloudKit で常に最新のデータ、 Sign in with Apple で編集に参加。", table: "Help", bundle: L10n.bundle)
        }
        /// 同期とアカウント — ヘルプの機能カテゴリ「同期とアカウント」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categorySyncTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.sync.title", defaultValue: "同期とアカウント", table: "Help", bundle: L10n.bundle)
        }
        /// 曲詳細から既存のタグを付けたり、新しいタグを作って付けたりできます。 — ヘルプ「タグ」の項目の説明
        static var categoryTagsAttachDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.attach.detail", defaultValue: "曲詳細から既存のタグを付けたり、新しいタグを作って付けたりできます。", table: "Help", bundle: L10n.bundle)
        }
        /// 曲にタグを付ける — ヘルプ「タグ」の項目の見出し
        static var categoryTagsAttachLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.attach.label", defaultValue: "曲にタグを付ける", table: "Help", bundle: L10n.bundle)
        }
        /// タグ一覧 → タグ詳細から、そのタグが付いた曲を一覧表示。「夏曲」「バラード」「神曲」など好きな切り口で検索可能。 — ヘルプ「タグ」の項目の説明。「夏曲」「バラード」「神曲」はタグの例 (例も訳す)
        static var categoryTagsBrowseDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.browse.detail", defaultValue: "タグ一覧 → タグ詳細から、そのタグが付いた曲を一覧表示。「夏曲」「バラード」「神曲」など好きな切り口で検索可能。", table: "Help", bundle: L10n.bundle)
        }
        /// タグから曲を辿る — ヘルプ「タグ」の項目の見出し
        static var categoryTagsBrowseLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.browse.label", defaultValue: "タグから曲を辿る", table: "Help", bundle: L10n.bundle)
        }
        /// 誰でもタグの説明を書き加えられます。Wikipedia のような共同編集スタイル。 — ヘルプ「タグ」の項目の説明
        static var categoryTagsDescriptionDetail: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.description.detail", defaultValue: "誰でもタグの説明を書き加えられます。Wikipedia のような共同編集スタイル。", table: "Help", bundle: L10n.bundle)
        }
        /// タグの説明文を編集 — ヘルプ「タグ」の項目の見出し
        static var categoryTagsDescriptionLabel: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.description.label", defaultValue: "タグの説明文を編集", table: "Help", bundle: L10n.bundle)
        }
        /// ユーザー投稿のタグで曲を自由に分類できます。 — ヘルプの機能カテゴリ「タグ」の一行説明 (一覧の行の見出しの下と詳細画面の先頭)
        static var categoryTagsSummary: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.summary", defaultValue: "ユーザー投稿のタグで曲を自由に分類できます。", table: "Help", bundle: L10n.bundle)
        }
        /// タグ — ヘルプの機能カテゴリ「タグ」の名前 (一覧の行の見出しと詳細画面のタイトル)
        static var categoryTagsTitle: LocalizedStringResource {
            LocalizedStringResource("help.category.tags.title", defaultValue: "タグ", table: "Help", bundle: L10n.bundle)
        }
        /// できること — カテゴリの詳細画面の節の見出し。下に「こんなことができる」の項目が並ぶ
        static var detailFeaturesHeader: LocalizedStringResource {
            LocalizedStringResource("help.detail.features.header", defaultValue: "できること", table: "Help", bundle: L10n.bundle)
        }
        /// 閉じる — ヘルプ (シート) を閉じるボタン。右上のツールバー
        static var topActionClose: LocalizedStringResource {
            LocalizedStringResource("help.top.action.close", defaultValue: "閉じる", table: "Help", bundle: L10n.bundle)
        }
        /// 機能カテゴリ — ヘルプのトップの節の見出し。下に機能ごとのカテゴリ (ライブを探す・楽曲を探す…) が並ぶ
        static var topCategoriesHeader: LocalizedStringResource {
            LocalizedStringResource("help.top.categories.header", defaultValue: "機能カテゴリ", table: "Help", bundle: L10n.bundle)
        }
        /// 特集 — ヘルプのトップの節の見出し。下に「担当ウィジェットの使い方」への導線
        static var topFeaturedHeader: LocalizedStringResource {
            LocalizedStringResource("help.top.featured.header", defaultValue: "特集", table: "Help", bundle: L10n.bundle)
        }
        /// 使い方は今後さらに増えていく予定です。データの間違いに気づいたらログインしてその場で直せます。要望や不具合は GitHub Issue からお寄せください。 — ヘルプのトップのいちばん下の注記。GitHub Issue はサービス名なので訳さない
        static var topFooter: LocalizedStringResource {
            LocalizedStringResource("help.top.footer", defaultValue: "使い方は今後さらに増えていく予定です。データの間違いに気づいたらログインしてその場で直せます。要望や不具合は GitHub Issue からお寄せください。", table: "Help", bundle: L10n.bundle)
        }
        /// アイドルライブDB の使い方 — ヘルプの先頭の見出し。アプリ名 (system.app.display_name) の ko 表記はオーナー確定待ち。それまでは ko の画面に仮名を出さないよう「아이돌 라이브 DB」と訳しておき、確定したら「<ko のアプリ名> 사용법」に合わせる
        static var topHeading: LocalizedStringResource {
            LocalizedStringResource("help.top.heading", defaultValue: "アイドルライブDB の使い方", table: "Help", bundle: L10n.bundle)
        }
        /// 各カテゴリで「こんなことができる」を一覧で紹介しています。気になる項目から覗いてみてください。 — ヘルプの先頭の見出しの下の説明
        static var topIntro: LocalizedStringResource {
            LocalizedStringResource("help.top.intro", defaultValue: "各カテゴリで「こんなことができる」を一覧で紹介しています。気になる項目から覗いてみてください。", table: "Help", bundle: L10n.bundle)
        }
        /// ヘルプ — ヘルプ画面のナビゲーションタイトル (iOS。Android は top.title_android)
        static var topTitle: LocalizedStringResource {
            LocalizedStringResource("help.top.title", defaultValue: "ヘルプ", table: "Help", bundle: L10n.bundle)
        }
        /// 推しの画像をホーム画面に。画像付きで手順を案内します。 — 「特集」の「担当ウィジェットの使い方」の行の説明 (2 行まで)。推し = 最も好きなアイドル。画像付き = 手順の画面にイラストが付いている (ユーザーの画像のことではない)
        static var topWidgetHowtoSummary: LocalizedStringResource {
            LocalizedStringResource("help.top.widget_howto.summary", defaultValue: "推しの画像をホーム画面に。画像付きで手順を案内します。", table: "Help", bundle: L10n.bundle)
        }
        /// 編集 — 担当ウィジェットの使い方の画面の手順 4 のイラスト。ウィジェットの設定を開くボタンの絵に書く語
        static var widgetHowtoEditArtLabel: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.edit_art.label", defaultValue: "編集", table: "Help", bundle: L10n.bundle)
        }
        /// 自分でアプリに入れた画像だけを表示します。版権画像は使いません。 — 担当ウィジェットの使い方の画面の先頭の見出しの下の説明。版権画像 = 権利元の公式画像
        static var widgetHowtoHeaderCaption: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.header.caption", defaultValue: "自分でアプリに入れた画像だけを表示します。版権画像は使いません。", table: "Help", bundle: L10n.bundle)
        }
        /// 推しの画像をホーム画面に — 担当ウィジェットの使い方の画面の先頭のイラストの下の見出し。推し = 最も好きなアイドル
        static var widgetHowtoHeaderTitle: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.header.title", defaultValue: "推しの画像をホーム画面に", table: "Help", bundle: L10n.bundle)
        }
        /// 担当 — 担当ウィジェットの使い方の画面の手順 3 のイラスト。ウィジェットの検索欄に打ち込んだ語 (手順 3 の「担当」と同じにする)
        static var widgetHowtoSearchArtQuery: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.search_art.query", defaultValue: "担当", table: "Help", bundle: L10n.bundle)
        }
        /// アイドル詳細 → プロフィール下の「ギャラリー」→「追加」から、好きな画像を何枚でも入れられます。先頭の1枚がアイコンになります。 — 担当ウィジェットの使い方の画面の手順 1 の説明。「ギャラリー」「追加」はアイドル詳細の画面の文言 (ko はそちらの訳に合わせる)
        static var widgetHowtoStep1Detail: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step1.detail", defaultValue: "アイドル詳細 → プロフィール下の「ギャラリー」→「追加」から、好きな画像を何枚でも入れられます。先頭の1枚がアイコンになります。", table: "Help", bundle: L10n.bundle)
        }
        /// アプリで担当に画像を追加 — 担当ウィジェットの使い方の画面の手順 1 の見出し
        static var widgetHowtoStep1Title: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step1.title", defaultValue: "アプリで担当に画像を追加", table: "Help", bundle: L10n.bundle)
        }
        /// ホーム画面の何もない所を長押し → 左上の「＋」をタップ。 — 担当ウィジェットの使い方の画面の手順 2 の説明 (iOS のホーム画面の操作)
        static var widgetHowtoStep2Detail: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step2.detail", defaultValue: "ホーム画面の何もない所を長押し → 左上の「＋」をタップ。", table: "Help", bundle: L10n.bundle)
        }
        /// ホーム画面にウィジェットを追加 — 担当ウィジェットの使い方の画面の手順 2 の見出し
        static var widgetHowtoStep2Title: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step2.title", defaultValue: "ホーム画面にウィジェットを追加", table: "Help", bundle: L10n.bundle)
        }
        /// ウィジェット一覧で「担当」と検索。「担当の画像（タップで切替）」と「（タップでアプリ）」の2種類があります。好きな方を追加。 — 担当ウィジェットの使い方の画面の手順 3 の説明。「」の中はウィジェットの名前 (ImasLiveDBWidget の configurationDisplayName。ko は widget.oshi_image.name / widget.oshi_launcher.name の訳に合わせる)
        static var widgetHowtoStep3Detail: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step3.detail", defaultValue: "ウィジェット一覧で「担当」と検索。「担当の画像（タップで切替）」と「（タップでアプリ）」の2種類があります。好きな方を追加。", table: "Help", bundle: L10n.bundle)
        }
        /// 「担当」で検索して選ぶ — 担当ウィジェットの使い方の画面の手順 3 の見出し。検索する語は widget_howto.search_art.query と同じにする
        static var widgetHowtoStep3Title: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step3.title", defaultValue: "「担当」で検索して選ぶ", table: "Help", bundle: L10n.bundle)
        }
        /// 置いたウィジェットを長押し →「ウィジェットを編集」→ アイドルを選択。画像を入れた担当が候補に出ます。 — 担当ウィジェットの使い方の画面の手順 4 の説明。「ウィジェットを編集」は iOS の長押しメニューの項目 (ko は iOS の表記「위젯 편집」)
        static var widgetHowtoStep4Detail: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step4.detail", defaultValue: "置いたウィジェットを長押し →「ウィジェットを編集」→ アイドルを選択。画像を入れた担当が候補に出ます。", table: "Help", bundle: L10n.bundle)
        }
        /// どのアイドルを出すか選ぶ — 担当ウィジェットの使い方の画面の手順 4 の見出し
        static var widgetHowtoStep4Title: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step4.title", defaultValue: "どのアイドルを出すか選ぶ", table: "Help", bundle: L10n.bundle)
        }
        /// 「タップで切替」版はタップするたびに次の画像にローテーション。放っておいても30分ごとに自動で切り替わります。「タップでアプリ」版はタップでアプリが開きます。 — 担当ウィジェットの使い方の画面の手順 5 の説明。「タップで切替」「タップでアプリ」はウィジェットの名前の括弧の中 (手順 3 と同じ訳にする)
        static var widgetHowtoStep5Detail: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step5.detail", defaultValue: "「タップで切替」版はタップするたびに次の画像にローテーション。放っておいても30分ごとに自動で切り替わります。「タップでアプリ」版はタップでアプリが開きます。", table: "Help", bundle: L10n.bundle)
        }
        /// タップで次の画像へ — 担当ウィジェットの使い方の画面の手順 5 の見出し
        static var widgetHowtoStep5Title: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.step5.title", defaultValue: "タップで次の画像へ", table: "Help", bundle: L10n.bundle)
        }
        /// ロック画面ウィジェットは仕様上フルカラー写真を出せません（ホーム画面向けの機能です）。 — 担当ウィジェットの使い方の画面の最後の注意書き (ロック画面のアイコン付き)
        static var widgetHowtoTipsLockScreen: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.tips.lock_screen", defaultValue: "ロック画面ウィジェットは仕様上フルカラー写真を出せません（ホーム画面向けの機能です）。", table: "Help", bundle: L10n.bundle)
        }
        /// 画像を足した・消した時は、アプリを一度開くとウィジェットも更新されます。 — 担当ウィジェットの使い方の画面の最後の注意書き (更新のアイコン付き)
        static var widgetHowtoTipsRefresh: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.tips.refresh", defaultValue: "画像を足した・消した時は、アプリを一度開くとウィジェットも更新されます。", table: "Help", bundle: L10n.bundle)
        }
        /// 担当ウィジェットの使い方 — 担当画像ウィジェットの使い方の画面のタイトル。ヘルプのトップの「特集」の行の見出しにも使う
        static var widgetHowtoTitle: LocalizedStringResource {
            LocalizedStringResource("help.widget_howto.title", defaultValue: "担当ウィジェットの使い方", table: "Help", bundle: L10n.bundle)
        }
    }
}
