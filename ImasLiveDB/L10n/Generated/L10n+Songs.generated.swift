// 生成物: i18n/catalog/songs.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/songs.json の文言 (表 Songs)
    enum Songs {
        /// あなたが思うこの曲のペンライト色を投票しませんか？ — ペンライト投票が無いときの誘い文句
        static var communityPenlightEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.empty.message", defaultValue: "あなたが思うこの曲のペンライト色を投票しませんか？", table: "Songs", bundle: L10n.bundle)
        }
        /// まだ投票がありません — ペンライト投票が 1 票も無いとき
        static var communityPenlightEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.empty.title", defaultValue: "まだ投票がありません", table: "Songs", bundle: L10n.bundle)
        }
        /// ペンライト投票 — コミュニティタブの節の見出し。iOS の文言。Android の community.penlight.header_android と ja が違う
        static var communityPenlightHeaderIos: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.header_ios", defaultValue: "ペンライト投票", table: "Songs", bundle: L10n.bundle)
        }
        /// 自分の投票 — 自分が投票した色の組に付ける印
        static var communityPenlightMine: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.mine", defaultValue: "自分の投票", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲のペンライト色 ・ {count}票 — ペンライト投票の結果の下の注記。count は票の合計。1000 以上は桁区切りが付く — 引数: count (count)
        static func communityPenlightSummary(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.summary", defaultValue: "この曲のペンライト色 ・ \(count)票", table: "Songs", bundle: L10n.bundle)
        }
        /// 投票する — ペンライト投票の節の見出し右のボタン (iOS) / ＋ ボタンの読み上げ (Android)
        static var communityPenlightVote: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.vote", defaultValue: "投票する", table: "Songs", bundle: L10n.bundle)
        }
        /// ペンライト色を投票 — ペンライト投票が無いときの空状態のボタン
        static var communityPenlightVoteAction: LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.vote_action", defaultValue: "ペンライト色を投票", table: "Songs", bundle: L10n.bundle)
        }
        /// {count}票 — ペンライトの色の組ごとの票数 (iOS) / 節の見出しの右の票の合計 (Android)。1000 以上は桁区切りが付く — 引数: count (count)
        static func communityPenlightVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.community.penlight.votes", defaultValue: "\(count)票", table: "Songs", bundle: L10n.bundle)
        }
        /// つけられたタグが似ている楽曲 — おすすめの節の見出しの下の説明
        static var communitySimilarCaption: LocalizedStringResource {
            LocalizedStringResource("songs.community.similar.caption", defaultValue: "つけられたタグが似ている楽曲", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲が好きな人にはこれも — タグが似ている曲 (サーバ算出のおすすめ) の節の見出し
        static var communitySimilarHeader: LocalizedStringResource {
            LocalizedStringResource("songs.community.similar.header", defaultValue: "この曲が好きな人にはこれも", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ{count}個一致 — おすすめの曲の行に出す、共通するタグの数。1000 以上は桁区切りが付く (実際には届かない) — 引数: count (count)
        static func communitySimilarSharedTags(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.community.similar.shared_tags", defaultValue: "タグ\(count)個一致", table: "Songs", bundle: L10n.bundle)
        }
        /// タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ
        static var communityTagsAdd: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.add", defaultValue: "タグを追加", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ — タグの節の見出し右の ＋ 付きボタン (短い形)
        static var communityTagsAddButton: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.add_button", defaultValue: "タグ", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲を一言で表すタグを付けてみませんか？ — タグが 1 つも無いときの誘い文句
        static var communityTagsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.empty.message", defaultValue: "この曲を一言で表すタグを付けてみませんか？", table: "Songs", bundle: L10n.bundle)
        }
        /// タグはまだありません — タグが 1 つも無いとき
        static var communityTagsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.empty.title", defaultValue: "タグはまだありません", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ — コミュニティタブの節の見出し
        static var communityTagsHeader: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.header", defaultValue: "タグ", table: "Songs", bundle: L10n.bundle)
        }
        /// タグを外す — 自分が付けたタグの長押しメニュー
        static var communityTagsRemove: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.remove", defaultValue: "タグを外す", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ詳細を見る — タグの長押しメニュー
        static var communityTagsShowDetail: LocalizedStringResource {
            LocalizedStringResource("songs.community.tags.show_detail", defaultValue: "タグ詳細を見る", table: "Songs", bundle: L10n.bundle)
        }
        /// 動画 — 参考動画の節の見出し右の ▶ 付きボタン (短い形)
        static var communityVideosAddButton: LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.add_button", defaultValue: "動画", table: "Songs", bundle: L10n.bundle)
        }
        /// 投稿者: {name} — 参考動画を投稿した人。name は表示名 — 引数: name (string)
        static func communityVideosAuthor(name: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.author", defaultValue: "投稿者: \(name)", table: "Songs", bundle: L10n.bundle)
        }
        /// 最初の1本を投稿しませんか？ — 参考動画が無いときの誘い文句。iOS の文言。Android の community.videos.empty.message_android と ja が違う
        static var communityVideosEmptyMessageIos: LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.empty.message_ios", defaultValue: "最初の1本を投稿しませんか？", table: "Songs", bundle: L10n.bundle)
        }
        /// 参考動画はまだありません — 参考動画が 1 本も無いとき
        static var communityVideosEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.empty.title", defaultValue: "参考動画はまだありません", table: "Songs", bundle: L10n.bundle)
        }
        /// 参考動画 — コミュニティタブの節の見出し
        static var communityVideosHeader: LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.header", defaultValue: "参考動画", table: "Songs", bundle: L10n.bundle)
        }
        /// 動画を投稿 — 参考動画が無いときの空状態のボタン
        static var communityVideosPost: LocalizedStringResource {
            LocalizedStringResource("songs.community.videos.post", defaultValue: "動画を投稿", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌唱者をコピー — 曲の長押しメニュー。歌唱者の表記をコピーする
        static var copyArtists: LocalizedStringResource {
            LocalizedStringResource("songs.copy.artists", defaultValue: "歌唱者をコピー", table: "Songs", bundle: L10n.bundle)
        }
        /// よみをコピー — 曲の長押しメニュー。よみ = 曲名の読み仮名
        static var copyKana: LocalizedStringResource {
            LocalizedStringResource("songs.copy.kana", defaultValue: "よみをコピー", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲名をコピー — 曲の行・曲詳細の曲名を長押ししたときのメニュー
        static var copyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.copy.title", defaultValue: "曲名をコピー", table: "Songs", bundle: L10n.bundle)
        }
        /// お気に入り — 曲詳細のお気に入りボタン (入っていないとき)
        static var detailFavoriteOff: LocalizedStringResource {
            LocalizedStringResource("songs.detail.favorite.off", defaultValue: "お気に入り", table: "Songs", bundle: L10n.bundle)
        }
        /// お気に入り済み — 曲詳細のお気に入りボタン (お気に入りに入っているとき)
        static var detailFavoriteOn: LocalizedStringResource {
            LocalizedStringResource("songs.detail.favorite.on", defaultValue: "お気に入り済み", table: "Songs", bundle: L10n.bundle)
        }
        /// カード所持済み — KAMISABI (音楽カードゲーム) のカードを持っていると記録済みのときのボタン
        static var detailKamisabiOwned: LocalizedStringResource {
            LocalizedStringResource("songs.detail.kamisabi.owned", defaultValue: "カード所持済み", table: "Songs", bundle: L10n.bundle)
        }
        /// カード所持を記録 — KAMISABI のカードを持っていると記録するボタン
        static var detailKamisabiRecord: LocalizedStringResource {
            LocalizedStringResource("songs.detail.kamisabi.record", defaultValue: "カード所持を記録", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ・動画・投票にはログインが必要です — コミュニティタブの先頭に出す、未ログインの人への案内
        static var detailLoginPrompt: LocalizedStringResource {
            LocalizedStringResource("songs.detail.login.prompt", defaultValue: "タグ・動画・投票にはログインが必要です", table: "Songs", bundle: L10n.bundle)
        }
        /// Apple Musicで開く — 曲詳細の … メニュー (Apple Music は固有名詞)
        static var detailMenuAppleMusic: LocalizedStringResource {
            LocalizedStringResource("songs.detail.menu.apple_music", defaultValue: "Apple Musicで開く", table: "Songs", bundle: L10n.bundle)
        }
        /// この楽曲を編集 — 曲詳細の … メニュー
        static var detailMenuEdit: LocalizedStringResource {
            LocalizedStringResource("songs.detail.menu.edit", defaultValue: "この楽曲を編集", table: "Songs", bundle: L10n.bundle)
        }
        /// 編集履歴 — 曲詳細の … メニュー
        static var detailMenuEditHistory: LocalizedStringResource {
            LocalizedStringResource("songs.detail.menu.edit_history", defaultValue: "編集履歴", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞サイトで探す — 曲詳細の … メニュー。外部の歌詞サイトを開く。iOS の文言。Android の detail.menu.lyrics_site_android と ja が違う
        static var detailMenuLyricsSiteIos: LocalizedStringResource {
            LocalizedStringResource("songs.detail.menu.lyrics_site_ios", defaultValue: "歌詞サイトで探す", table: "Songs", bundle: L10n.bundle)
        }
        /// 再生 — 曲詳細の再生ボタン
        static var detailPlay: LocalizedStringResource {
            LocalizedStringResource("songs.detail.play", defaultValue: "再生", table: "Songs", bundle: L10n.bundle)
        }
        /// 公演 — 統計タイルの数字の単位 (現地回収した公演の数)
        static var detailStatUnitShows: LocalizedStringResource {
            LocalizedStringResource("songs.detail.stat.unit_shows", defaultValue: "公演", table: "Songs", bundle: L10n.bundle)
        }
        /// 回 — 統計タイルの数字の単位 (披露回数など)
        static var detailStatUnitTimes: LocalizedStringResource {
            LocalizedStringResource("songs.detail.stat.unit_times", defaultValue: "回", table: "Songs", bundle: L10n.bundle)
        }
        /// 停止 — 曲詳細の再生ボタン (再生中)
        static var detailStop: LocalizedStringResource {
            LocalizedStringResource("songs.detail.stop", defaultValue: "停止", table: "Songs", bundle: L10n.bundle)
        }
        /// コミュニティ — 曲詳細のタブ (タグ・参考動画・ペンライト投票)
        static var detailTabCommunity: LocalizedStringResource {
            LocalizedStringResource("songs.detail.tab.community", defaultValue: "コミュニティ", table: "Songs", bundle: L10n.bundle)
        }
        /// 披露履歴 — 曲詳細のタブ (ライブで歌われた記録)
        static var detailTabHistory: LocalizedStringResource {
            LocalizedStringResource("songs.detail.tab.history", defaultValue: "披露履歴", table: "Songs", bundle: L10n.bundle)
        }
        /// 情報・歌唱 — 曲詳細のタブ (曲の情報と歌唱アイドル)
        static var detailTabInfo: LocalizedStringResource {
            LocalizedStringResource("songs.detail.tab.info", defaultValue: "情報・歌唱", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞 — 曲詳細のタブ (歌詞とコールガイド)
        static var detailTabLyrics: LocalizedStringResource {
            LocalizedStringResource("songs.detail.tab.lyrics", defaultValue: "歌詞", table: "Songs", bundle: L10n.bundle)
        }
        /// カード所持の記録 — 端末への保存に失敗したときの知らせに入る操作の名前 (KAMISABI のカード所持)
        static var detailWriteActionCardOwned: LocalizedStringResource {
            LocalizedStringResource("songs.detail.write_action.card_owned", defaultValue: "カード所持の記録", table: "Songs", bundle: L10n.bundle)
        }
        /// お気に入りの切り替え — 端末への保存に失敗したときの知らせに入る操作の名前 (「{操作}に失敗しました」の {操作})
        static var detailWriteActionFavorite: LocalizedStringResource {
            LocalizedStringResource("songs.detail.write_action.favorite", defaultValue: "お気に入りの切り替え", table: "Songs", bundle: L10n.bundle)
        }
        /// 全て — フィルタシートのチップ。絞り込まない (曲タイプ・ブランド・アイドル選択のブランド)
        static var filterAll: LocalizedStringResource {
            LocalizedStringResource("songs.filter.all", defaultValue: "全て", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞の行にコール・手拍子が書き込まれている曲だけを表示します (通信が必要)。 — コールガイドの節の注記
        static var filterCallGuideFooter: LocalizedStringResource {
            LocalizedStringResource("songs.filter.call_guide.footer", defaultValue: "歌詞の行にコール・手拍子が書き込まれている曲だけを表示します (通信が必要)。", table: "Songs", bundle: L10n.bundle)
        }
        /// コールガイド — フィルタシートの節の見出し
        static var filterCallGuideHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.call_guide.header", defaultValue: "コールガイド", table: "Songs", bundle: L10n.bundle)
        }
        /// コールガイドがある曲のみ — コールガイドの絞り込みのスイッチ
        static var filterCallGuideToggle: LocalizedStringResource {
            LocalizedStringResource("songs.filter.call_guide.toggle", defaultValue: "コールガイドがある曲のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// CDシリーズ — フィルタシートの CD シリーズ選択の行・節の見出しと、選択画面のタイトル
        static var filterCdSeriesHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.cd_series.header", defaultValue: "CDシリーズ", table: "Songs", bundle: L10n.bundle)
        }
        /// すべて — 現地回収の絞り込みの選択肢。iOS は SongCollectFilter の rawValue (保存値。変えない) を表示に使っていたもの
        static var filterCollectAll: LocalizedStringResource {
            LocalizedStringResource("songs.filter.collect.all", defaultValue: "すべて", table: "Songs", bundle: L10n.bundle)
        }
        /// 回収済のみ — 現地回収の絞り込みの選択肢。現地で聴いた曲だけ
        static var filterCollectCollected: LocalizedStringResource {
            LocalizedStringResource("songs.filter.collect.collected", defaultValue: "回収済のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// 現地回収 — フィルタシートの節の見出し (現地で聴いたかどうかで絞る)
        static var filterCollectHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.collect.header", defaultValue: "現地回収", table: "Songs", bundle: L10n.bundle)
        }
        /// 未回収のみ — 現地回収の絞り込みの選択肢。まだ現地で聴いていない曲だけ
        static var filterCollectUncollected: LocalizedStringResource {
            LocalizedStringResource("songs.filter.collect.uncollected", defaultValue: "未回収のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// 作詞 / 作曲 / 編曲者 — フィルタシートの節の見出し (作家の名前で絞る)
        static var filterCreatorHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.creator.header", defaultValue: "作詞 / 作曲 / 編曲者", table: "Songs", bundle: L10n.bundle)
        }
        /// 名前を入力 — 作家の名前の入力欄のプレースホルダ
        static var filterCreatorPlaceholder: LocalizedStringResource {
            LocalizedStringResource("songs.filter.creator.placeholder", defaultValue: "名前を入力", table: "Songs", bundle: L10n.bundle)
        }
        /// アイドル — フィルタシートのアイドル選択の行 (iOS は節の見出しとアイドル選択画面のタイトルにも使う)
        static var filterIdolHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.idol.header", defaultValue: "アイドル", table: "Songs", bundle: L10n.bundle)
        }
        /// 音楽カードゲーム「KAMISABI」にカードが収録されている曲だけを表示します。 — KAMISABI の節の注記。iOS の文言。Android の filter.kamisabi.caption_android と ja が違う
        static var filterKamisabiCaptionIos: LocalizedStringResource {
            LocalizedStringResource("songs.filter.kamisabi.caption_ios", defaultValue: "音楽カードゲーム「KAMISABI」にカードが収録されている曲だけを表示します。", table: "Songs", bundle: L10n.bundle)
        }
        /// KAMISABI収録曲のみ — KAMISABI (音楽カードゲーム。固有名詞) の絞り込みのスイッチ。iOS の文言。Android の filter.kamisabi.toggle_android と ja が違う
        static var filterKamisabiToggleIos: LocalizedStringResource {
            LocalizedStringResource("songs.filter.kamisabi.toggle_ios", defaultValue: "KAMISABI収録曲のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// アルバム — 表示形式のセグメント。CD 単位のカードで並べる
        static var filterListModeAlbums: LocalizedStringResource {
            LocalizedStringResource("songs.filter.list_mode.albums", defaultValue: "アルバム", table: "Songs", bundle: L10n.bundle)
        }
        /// 表示形式 — フィルタシートの節の見出し (曲 / アルバム / シリーズ)
        static var filterListModeHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.list_mode.header", defaultValue: "表示形式", table: "Songs", bundle: L10n.bundle)
        }
        /// 表示 — 表示形式を選ぶセグメントの名前 (読み上げに使う)
        static var filterListModePicker: LocalizedStringResource {
            LocalizedStringResource("songs.filter.list_mode.picker", defaultValue: "表示", table: "Songs", bundle: L10n.bundle)
        }
        /// シリーズ — 表示形式のセグメント。シリーズ単位のカードで並べる
        static var filterListModeSeries: LocalizedStringResource {
            LocalizedStringResource("songs.filter.list_mode.series", defaultValue: "シリーズ", table: "Songs", bundle: L10n.bundle)
        }
        /// 楽曲 — 表示形式のセグメント。曲を 1 行ずつ並べる
        static var filterListModeSongs: LocalizedStringResource {
            LocalizedStringResource("songs.filter.list_mode.songs", defaultValue: "楽曲", table: "Songs", bundle: L10n.bundle)
        }
        /// ライブで絞込 — フィルタシートのライブ選択の行・節の見出し
        static var filterLiveHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.live.header", defaultValue: "ライブで絞込", table: "Songs", bundle: L10n.bundle)
        }
        /// ライブ — ライブを選ぶ画面のタイトル
        static var filterLivePickerTitle: LocalizedStringResource {
            LocalizedStringResource("songs.filter.live.picker_title", defaultValue: "ライブ", table: "Songs", bundle: L10n.bundle)
        }
        /// セトリにしか無い曲(カバー等)を一覧から隠します。既定 ON — ライブ限定曲を隠す のスイッチの説明
        static var filterLiveOnlyCaption: LocalizedStringResource {
            LocalizedStringResource("songs.filter.live_only.caption", defaultValue: "セトリにしか無い曲(カバー等)を一覧から隠します。既定 ON", table: "Songs", bundle: L10n.bundle)
        }
        /// ライブ限定曲を隠す — フィルタシートのスイッチ
        static var filterLiveOnlyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.filter.live_only.title", defaultValue: "ライブ限定曲を隠す", table: "Songs", bundle: L10n.bundle)
        }
        /// お気に入りのみ — マイマークの絞り込みのスイッチ
        static var filterMyMarkFavorite: LocalizedStringResource {
            LocalizedStringResource("songs.filter.my_mark.favorite", defaultValue: "お気に入りのみ", table: "Songs", bundle: L10n.bundle)
        }
        /// チェック ON で AND 条件絞り込み — マイマークの節の注記。ON にした条件すべてに当てはまる曲だけ残る
        static var filterMyMarkFooter: LocalizedStringResource {
            LocalizedStringResource("songs.filter.my_mark.footer", defaultValue: "チェック ON で AND 条件絞り込み", table: "Songs", bundle: L10n.bundle)
        }
        /// マイマーク — フィルタシートの節の見出し (担当・お気に入り・メモで絞る)
        static var filterMyMarkHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.my_mark.header", defaultValue: "マイマーク", table: "Songs", bundle: L10n.bundle)
        }
        /// 担当アイドルの曲のみ — マイマークの絞り込みのスイッチ
        static var filterMyMarkMyPick: LocalizedStringResource {
            LocalizedStringResource("songs.filter.my_mark.my_pick", defaultValue: "担当アイドルの曲のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// メモがある曲のみ — マイマークの絞り込みのスイッチ
        static var filterMyMarkNote: LocalizedStringResource {
            LocalizedStringResource("songs.filter.my_mark.note", defaultValue: "メモがある曲のみ", table: "Songs", bundle: L10n.bundle)
        }
        /// 選択なし — シリーズ・CD シリーズ・ライブ・アイドルを選んでいないときの表示 / 選択を外す行
        static var filterNone: LocalizedStringResource {
            LocalizedStringResource("songs.filter.none", defaultValue: "選択なし", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌枠で歌っただけのカバー等。既定では隠しています — 「その他」を表示 のスイッチの説明。歌枠 = 歌の配信
        static var filterOtherBrandCaption: LocalizedStringResource {
            LocalizedStringResource("songs.filter.other_brand.caption", defaultValue: "歌枠で歌っただけのカバー等。既定では隠しています", table: "Songs", bundle: L10n.bundle)
        }
        /// 「その他」を表示 — フィルタシートのスイッチ。「その他」はどのブランドにも属さない曲の分類
        static var filterOtherBrandTitle: LocalizedStringResource {
            LocalizedStringResource("songs.filter.other_brand.title", defaultValue: "「その他」を表示", table: "Songs", bundle: L10n.bundle)
        }
        /// すべてリセット — フィルタシートの条件をすべて戻すボタン。iOS の文言。Android の filter.reset_android と ja が違う
        static var filterResetIos: LocalizedStringResource {
            LocalizedStringResource("songs.filter.reset_ios", defaultValue: "すべてリセット", table: "Songs", bundle: L10n.bundle)
        }
        /// シリーズ — フィルタシートのシリーズ選択の行・節の見出しと、選択画面のタイトル
        static var filterSeriesHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.series.header", defaultValue: "シリーズ", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲タイプ — フィルタシートの節の見出し (ソロ / ユニット / 全体曲。語はコアの vocabulary)
        static var filterSongTypeHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.song_type.header", defaultValue: "曲タイプ", table: "Songs", bundle: L10n.bundle)
        }
        /// 方向 — 昇順/降順を選ぶセグメントの名前 (読み上げに使う)
        static var filterSortDirection: LocalizedStringResource {
            LocalizedStringResource("songs.filter.sort.direction", defaultValue: "方向", table: "Songs", bundle: L10n.bundle)
        }
        /// 並び順 — フィルタシートの節の見出し
        static var filterSortHeader: LocalizedStringResource {
            LocalizedStringResource("songs.filter.sort.header", defaultValue: "並び順", table: "Songs", bundle: L10n.bundle)
        }
        /// ソート — 並び順を選ぶメニューの名前
        static var filterSortPicker: LocalizedStringResource {
            LocalizedStringResource("songs.filter.sort.picker", defaultValue: "ソート", table: "Songs", bundle: L10n.bundle)
        }
        /// アルバムが見つかりません — 表示形式がアルバムで 1 件も無いとき
        static var gridAlbumsEmpty: LocalizedStringResource {
            LocalizedStringResource("songs.grid.albums.empty", defaultValue: "アルバムが見つかりません", table: "Songs", bundle: L10n.bundle)
        }
        /// シリーズが見つかりません — 表示形式がシリーズで 1 件も無いとき
        static var gridSeriesEmpty: LocalizedStringResource {
            LocalizedStringResource("songs.grid.series.empty", defaultValue: "シリーズが見つかりません", table: "Songs", bundle: L10n.bundle)
        }
        /// 同じ公演で歌われた曲 — 披露履歴タブの節の見出し
        static var historyCoOccurringHeader: LocalizedStringResource {
            LocalizedStringResource("songs.history.co_occurring.header", defaultValue: "同じ公演で歌われた曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 同じ公演に両方あった公演数です (1 公演で 2 回歌っても 1 公演)。次のライブで一緒に来るとは限りません。 — 同じ公演で歌われた曲 の節の注記
        static var historyCoOccurringNote: LocalizedStringResource {
            LocalizedStringResource("songs.history.co_occurring.note", defaultValue: "同じ公演に両方あった公演数です (1 公演で 2 回歌っても 1 公演)。次のライブで一緒に来るとは限りません。", table: "Songs", bundle: L10n.bundle)
        }
        /// いっしょに{together}公演 ／ 全{performances}公演 — 同じ公演で歌われた曲の行の副題。together は一緒に歌われた公演数、performances はその曲が歌われた公演数。together は 1000 以上は桁区切りが付く (実際には届かない) — 引数: together (count), performances (int)
        static func historyCoOccurringRow(together: Int, performances: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.history.co_occurring.row", defaultValue: "いっしょに\(together)公演 ／ 全\(String(performances))公演", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲がライブで披露されると、ここに記録されます。 — ライブで一度も歌われていないときの説明
        static var historyEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("songs.history.empty.message", defaultValue: "この曲がライブで披露されると、ここに記録されます。", table: "Songs", bundle: L10n.bundle)
        }
        /// 披露履歴はまだありません — ライブで一度も歌われていないとき
        static var historyEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.history.empty.title", defaultValue: "披露履歴はまだありません", table: "Songs", bundle: L10n.bundle)
        }
        /// {count}回 — ライブ披露履歴 の見出しの右の回数。1000 以上は桁区切りが付く — 引数: count (count)
        static func historyLogCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.history.log.count", defaultValue: "\(count)回", table: "Songs", bundle: L10n.bundle)
        }
        /// ライブ披露履歴 — 披露履歴タブの節の見出し (公演ごとの一覧)
        static var historyLogHeader: LocalizedStringResource {
            LocalizedStringResource("songs.history.log.header", defaultValue: "ライブ披露履歴", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲を歌った人 — 披露履歴タブの節の見出し (歌った回数の多い順)
        static var historySingersHeader: LocalizedStringResource {
            LocalizedStringResource("songs.history.singers.header", defaultValue: "この曲を歌った人", table: "Songs", bundle: L10n.bundle)
        }
        /// セトリに残っている歌唱の集計です。分母は上の「総披露」と同じ回数です。 — この曲を歌った人 の節の注記
        static var historySingersNote: LocalizedStringResource {
            LocalizedStringResource("songs.history.singers.note", defaultValue: "セトリに残っている歌唱の集計です。分母は上の「総披露」と同じ回数です。", table: "Songs", bundle: L10n.bundle)
        }
        /// {times}回 ／ 全{total}回 — 歌った人の行の副題。times はその人が歌った回数、total は全体の披露回数。times は 1000 以上は桁区切りが付く (実際には届かない) — 引数: times (count), total (int)
        static func historySingersTimes(times: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.history.singers.times", defaultValue: "\(times)回 ／ 全\(String(total))回", table: "Songs", bundle: L10n.bundle)
        }
        /// 初披露 — 統計タイルのラベル。初めて歌われた年月
        static var historyStatFirst: LocalizedStringResource {
            LocalizedStringResource("songs.history.stat.first", defaultValue: "初披露", table: "Songs", bundle: L10n.bundle)
        }
        /// 最終披露 — 統計タイルのラベル。最後に歌われた年月
        static var historyStatLast: LocalizedStringResource {
            LocalizedStringResource("songs.history.stat.last", defaultValue: "最終披露", table: "Songs", bundle: L10n.bundle)
        }
        /// 総披露 — 統計タイルのラベル。ライブで歌われた回数の合計
        static var historyStatTotal: LocalizedStringResource {
            LocalizedStringResource("songs.history.stat.total", defaultValue: "総披露", table: "Songs", bundle: L10n.bundle)
        }
        /// ライブ歌唱歴 — 情報タブの節の見出し (ライブで歌ったことがあるアイドル)
        static var infoLiveSingersHeader: LocalizedStringResource {
            LocalizedStringResource("songs.info.live_singers.header", defaultValue: "ライブ歌唱歴", table: "Songs", bundle: L10n.bundle)
        }
        /// 参加ライブを登録して現地回収 — 参加したライブを登録する導線 (登録すると現地回収に数えられる)
        static var infoRegisterAttendance: LocalizedStringResource {
            LocalizedStringResource("songs.info.register_attendance", defaultValue: "参加ライブを登録して現地回収", table: "Songs", bundle: L10n.bundle)
        }
        /// 関連楽曲 — 情報タブの節の見出し (同じシリーズ・ユニット・歌唱者の曲)
        static var infoRelatedHeader: LocalizedStringResource {
            LocalizedStringResource("songs.info.related.header", defaultValue: "関連楽曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 編曲 — 楽曲情報の行
        static var infoRowArranger: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.arranger", defaultValue: "編曲", table: "Songs", bundle: L10n.bundle)
        }
        /// アーティスト — 楽曲情報の行
        static var infoRowArtist: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.artist", defaultValue: "アーティスト", table: "Songs", bundle: L10n.bundle)
        }
        /// ブランド — 楽曲情報の行 (アイマスのシリーズ)
        static var infoRowBrand: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.brand", defaultValue: "ブランド", table: "Songs", bundle: L10n.bundle)
        }
        /// CDシリーズ — 楽曲情報の行
        static var infoRowCdSeries: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.cd_series", defaultValue: "CDシリーズ", table: "Songs", bundle: L10n.bundle)
        }
        /// 作曲 — 楽曲情報の行
        static var infoRowComposer: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.composer", defaultValue: "作曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 作曲 / 編曲 — 楽曲情報の行。作曲者と編曲者が同じとき
        static var infoRowComposerArranger: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.composer_arranger", defaultValue: "作曲 / 編曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 再生時間 — 楽曲情報の行 (曲の長さ)
        static var infoRowDuration: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.duration", defaultValue: "再生時間", table: "Songs", bundle: L10n.bundle)
        }
        /// よみ — 楽曲情報の行。曲名の読み仮名
        static var infoRowKana: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.kana", defaultValue: "よみ", table: "Songs", bundle: L10n.bundle)
        }
        /// 作詞 — 楽曲情報の行
        static var infoRowLyricist: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.lyricist", defaultValue: "作詞", table: "Songs", bundle: L10n.bundle)
        }
        /// リリース日 — 楽曲情報の行
        static var infoRowReleaseDate: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.release_date", defaultValue: "リリース日", table: "Songs", bundle: L10n.bundle)
        }
        /// タイプ — 楽曲情報の行 (ソロ / ユニット / 全体曲)
        static var infoRowType: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.type", defaultValue: "タイプ", table: "Songs", bundle: L10n.bundle)
        }
        /// ユニット — 楽曲情報の行
        static var infoRowUnit: LocalizedStringResource {
            LocalizedStringResource("songs.info.row.unit", defaultValue: "ユニット", table: "Songs", bundle: L10n.bundle)
        }
        /// 楽曲情報 — 情報タブの節の見出し
        static var infoSectionHeader: LocalizedStringResource {
            LocalizedStringResource("songs.info.section.header", defaultValue: "楽曲情報", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌唱アイドル — 情報タブの節の見出し (オリジナルの歌唱メンバー)
        static var infoSingersHeader: LocalizedStringResource {
            LocalizedStringResource("songs.info.singers.header", defaultValue: "歌唱アイドル", table: "Songs", bundle: L10n.bundle)
        }
        /// 現地回収 — 統計タイルのラベル。自分が現地で聴いた公演の数
        static var infoStatCollected: LocalizedStringResource {
            LocalizedStringResource("songs.info.stat.collected", defaultValue: "現地回収", table: "Songs", bundle: L10n.bundle)
        }
        /// 披露回数 — 統計タイルのラベル。ライブで歌われた回数
        static var infoStatPerformances: LocalizedStringResource {
            LocalizedStringResource("songs.info.stat.performances", defaultValue: "披露回数", table: "Songs", bundle: L10n.bundle)
        }
        /// 別バージョン — 情報タブの節の見出し (同じ曲のソロ Ver. / Remix など)
        static var infoVariantsHeader: LocalizedStringResource {
            LocalizedStringResource("songs.info.variants.header", defaultValue: "別バージョン", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲を追加 — 曲を新しく登録するボタン (iOS はメニューの項目、Android は ＋ の読み上げ)
        static var listActionAdd: LocalizedStringResource {
            LocalizedStringResource("songs.list.action.add", defaultValue: "曲を追加", table: "Songs", bundle: L10n.bundle)
        }
        /// フィルタを解除 — 絞り込みをすべて外すメニュー項目
        static var listActionClearFilters: LocalizedStringResource {
            LocalizedStringResource("songs.list.action.clear_filters", defaultValue: "フィルタを解除", table: "Songs", bundle: L10n.bundle)
        }
        /// タグで絞り込み — タグを選んで絞り込むボタン (iOS はメニューの項目、Android はボタンの読み上げ)
        static var listActionTagFilter: LocalizedStringResource {
            LocalizedStringResource("songs.list.action.tag_filter", defaultValue: "タグで絞り込み", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ: {count}件 — タグで絞り込み中のメニュー項目。count は選んだタグの数 — 引数: count (count)
        static func listActionTagFilterCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.action.tag_filter_count", defaultValue: "タグ: \(count)件", table: "Songs", bundle: L10n.bundle)
        }
        /// コールガイドの情報を取得できませんでした。表示中の一覧にはコールガイド条件が反映されていません。 — コールガイドの有無で絞る情報を取れなかったときのバナー。一覧は絞られていない
        static var listCallGuideError: LocalizedStringResource {
            LocalizedStringResource("songs.list.call_guide.error", defaultValue: "コールガイドの情報を取得できませんでした。表示中の一覧にはコールガイド条件が反映されていません。", table: "Songs", bundle: L10n.bundle)
        }
        /// 最近更新された 200 曲で絞り込んでいます。 — コールガイドありで絞ると、サーバが 200 曲で打ち切るのでそれを知らせる
        static var listCallGuideTruncated: LocalizedStringResource {
            LocalizedStringResource("songs.list.call_guide.truncated", defaultValue: "最近更新された 200 曲で絞り込んでいます。", table: "Songs", bundle: L10n.bundle)
        }
        /// コールガイドあり — 適用中の絞り込みのチップ。コールガイドがある曲だけ
        static var listChipCallGuide: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.call_guide", defaultValue: "コールガイドあり", table: "Songs", bundle: L10n.bundle)
        }
        /// 現地回収済 — 適用中の絞り込みのチップ。現地で聴いた (回収した) 曲だけ
        static var listChipCollected: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.collected", defaultValue: "現地回収済", table: "Songs", bundle: L10n.bundle)
        }
        /// お気に入り — 適用中の絞り込みのチップ。お気に入りの曲だけ
        static var listChipFavorite: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.favorite", defaultValue: "お気に入り", table: "Songs", bundle: L10n.bundle)
        }
        /// KAMISABI収録 — 適用中の絞り込みのチップ。音楽カードゲーム KAMISABI に収録された曲だけ (KAMISABI は固有名詞)
        static var listChipKamisabi: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.kamisabi", defaultValue: "KAMISABI収録", table: "Songs", bundle: L10n.bundle)
        }
        /// 担当 — 適用中の絞り込みのチップ (× で外す)。担当アイドルの曲だけ
        static var listChipMyPick: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.my_pick", defaultValue: "担当", table: "Songs", bundle: L10n.bundle)
        }
        /// メモあり — 適用中の絞り込みのチップ。メモがある曲だけ
        static var listChipNote: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.note", defaultValue: "メモあり", table: "Songs", bundle: L10n.bundle)
        }
        /// {name} {count}曲 — 適用中のタグのチップ (タグ 1 つのとき)。name はタグ名、count はそのタグの曲数。1000 以上は桁区切りが付く — 引数: name (string), count (count)
        static func listChipTagCount(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.tag_count", defaultValue: "\(name) \(count)曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 未回収 — 適用中の絞り込みのチップ。まだ現地で聴いていない曲だけ
        static var listChipUncollected: LocalizedStringResource {
            LocalizedStringResource("songs.list.chip.uncollected", defaultValue: "未回収", table: "Songs", bundle: L10n.bundle)
        }
        /// {count} 件 — 一覧の上の件数 (数字だけ太字にする)。iOS の文言。Android の list.count.songs_android と ja が違う (空白の有無)。1000 以上は桁区切りが付く — 引数: count (count)
        static func listCountSongsIos(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.count.songs_ios", defaultValue: "\(count) 件", table: "Songs", bundle: L10n.bundle)
        }
        /// フィルタ条件を変更するか、フィルタを解除してください。 — フィルタで 1 曲も残らなかったときの説明
        static var listEmptyFilterMessage: LocalizedStringResource {
            LocalizedStringResource("songs.list.empty_filter.message", defaultValue: "フィルタ条件を変更するか、フィルタを解除してください。", table: "Songs", bundle: L10n.bundle)
        }
        /// 条件に一致する楽曲がありません — フィルタで 1 曲も残らなかったときの空状態の見出し
        static var listEmptyFilterTitle: LocalizedStringResource {
            LocalizedStringResource("songs.list.empty_filter.title", defaultValue: "条件に一致する楽曲がありません", table: "Songs", bundle: L10n.bundle)
        }
        /// 「{query}」に一致する楽曲がありません — 検索欄の語で 1 曲も残らなかったときの説明。query は利用者が打った語 — 引数: query (string)
        static func listEmptySearchMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.empty_search.message", defaultValue: "「\(query)」に一致する楽曲がありません", table: "Songs", bundle: L10n.bundle)
        }
        /// 絞り込み結果がありません — 検索欄の語で 1 曲も残らなかったときの空状態の見出し
        static var listEmptySearchTitle: LocalizedStringResource {
            LocalizedStringResource("songs.list.empty_search.title", defaultValue: "絞り込み結果がありません", table: "Songs", bundle: L10n.bundle)
        }
        /// もしかして — 打った語に完全には一致しないが近い曲 (あいまい検索の候補) の節の見出し
        static var listFuzzyHeader: LocalizedStringResource {
            LocalizedStringResource("songs.list.fuzzy.header", defaultValue: "もしかして", table: "Songs", bundle: L10n.bundle)
        }
        /// イントロドン導線を隠す — イントロドン導線の × の読み上げ
        static var listIntrodonHideA11y: LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.hide.a11y", defaultValue: "イントロドン導線を隠す", table: "Songs", bundle: L10n.bundle)
        }
        /// 4曲以上必要 — 出題に必要な曲数に足りないときの注記
        static var listIntrodonMinSongs: LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.min_songs", defaultValue: "4曲以上必要", table: "Songs", bundle: L10n.bundle)
        }
        /// {count}曲 — イントロドンに出せる曲数 (ボタンの横)。1000 以上は桁区切りが付く — 引数: count (count)
        static func listIntrodonPlayable(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.playable", defaultValue: "\(count)曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲一覧の絞り込み — イントロドンの設定に出す出題範囲の名前 (曲一覧で絞り込んだ曲)
        static var listIntrodonRangeDefault: LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.range_default", defaultValue: "曲一覧の絞り込み", table: "Songs", bundle: L10n.bundle)
        }
        /// 「{query}」検索 — イントロドンの設定に返す出題範囲の名前 (検索語で絞ったとき)。query は利用者が打った語 — 引数: query (string)
        static func listIntrodonRangeSearch(query: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.range_search", defaultValue: "「\(query)」検索", table: "Songs", bundle: L10n.bundle)
        }
        /// この範囲で出題 — イントロドンの設定から「絞り込んで出題」で来たときの確定ボタン
        static var listIntrodonSelect: LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.select", defaultValue: "この範囲で出題", table: "Songs", bundle: L10n.bundle)
        }
        /// この絞り込みでイントロドン — 絞り込み中の曲でイントロドン (イントロ当て) を始める導線
        static var listIntrodonStart: LocalizedStringResource {
            LocalizedStringResource("songs.list.introdon.start", defaultValue: "この絞り込みでイントロドン", table: "Songs", bundle: L10n.bundle)
        }
        /// アルバム名 — 検索欄の頭のチップ。表示形式がアルバムのとき
        static var listNameFilterAlbums: LocalizedStringResource {
            LocalizedStringResource("songs.list.name_filter.albums", defaultValue: "アルバム名", table: "Songs", bundle: L10n.bundle)
        }
        /// シリーズ名 — 検索欄の頭のチップ。表示形式がシリーズのとき
        static var listNameFilterSeries: LocalizedStringResource {
            LocalizedStringResource("songs.list.name_filter.series", defaultValue: "シリーズ名", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲名 — 検索欄の頭のチップ (何で絞るか)。表示形式が曲のとき
        static var listNameFilterSongs: LocalizedStringResource {
            LocalizedStringResource("songs.list.name_filter.songs", defaultValue: "曲名", table: "Songs", bundle: L10n.bundle)
        }
        /// 作詞作曲 — 検索対象の切り替え。作詞・作曲・編曲者の名前で探す
        static var listScopeCreator: LocalizedStringResource {
            LocalizedStringResource("songs.list.scope.creator", defaultValue: "作詞作曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞 — 検索対象の切り替え。歌詞の本文で探す (サーバに問い合わせる)
        static var listScopeLyrics: LocalizedStringResource {
            LocalizedStringResource("songs.list.scope.lyrics", defaultValue: "歌詞", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌唱 — 検索対象の切り替え。歌唱したアイドルの名前で探す
        static var listScopePerformer: LocalizedStringResource {
            LocalizedStringResource("songs.list.scope.performer", defaultValue: "歌唱", table: "Songs", bundle: L10n.bundle)
        }
        /// {scope} {count}件 — 別の検索対象に切り替えると何件当たるかのチップ。scope は検索対象の名前 (list.name_filter.* / list.scope.*)。1000 以上は桁区切りが付く — 引数: scope (text), count (count)
        static func listScopeSuggestionCount(scope: LocalizedStringResource, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.scope_suggestion.count", defaultValue: "\(scope) \(count)件", table: "Songs", bundle: L10n.bundle)
        }
        /// ほかに — 検索欄の下の行の頭。続けて「歌唱 3件」のような別の検索対象のチップが並ぶ
        static var listScopeSuggestionLead: LocalizedStringResource {
            LocalizedStringResource("songs.list.scope_suggestion.lead", defaultValue: "ほかに", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞で探す — 打った語を歌詞で探すチップ (件数は出さない)
        static var listScopeSuggestionLyrics: LocalizedStringResource {
            LocalizedStringResource("songs.list.scope_suggestion.lyrics", defaultValue: "歌詞で探す", table: "Songs", bundle: L10n.bundle)
        }
        /// 絞り込み — 曲一覧の検索欄のプレースホルダ (何で絞るかは頭のチップが示すので動詞だけ)
        static var listSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("songs.list.search.prompt", defaultValue: "絞り込み", table: "Songs", bundle: L10n.bundle)
        }
        /// 一節を入力 — 検索対象が歌詞のときの検索欄のプレースホルダ
        static var listSearchPromptLyrics: LocalizedStringResource {
            LocalizedStringResource("songs.list.search.prompt_lyrics", defaultValue: "一節を入力", table: "Songs", bundle: L10n.bundle)
        }
        /// 検索対象: {scope} — 検索対象のチップの読み上げ。scope は今の検索対象の名前 — 引数: scope (text)
        static func listSearchModeA11y(scope: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.search_mode.a11y", defaultValue: "検索対象: \(scope)", table: "Songs", bundle: L10n.bundle)
        }
        /// 検索対象 — 検索対象を選ぶメニューの見出し
        static var listSearchModePicker: LocalizedStringResource {
            LocalizedStringResource("songs.list.search_mode.picker", defaultValue: "検索対象", table: "Songs", bundle: L10n.bundle)
        }
        /// 並び替え: {order}、{direction} — 並び替えメニューの読み上げ。order は並び順 (sort.*)、direction は昇順/降順 — 引数: order (text), direction (text)
        static func listSortA11y(order: LocalizedStringResource, direction: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("songs.list.sort.a11y", defaultValue: "並び替え: \(order)、\(direction)", table: "Songs", bundle: L10n.bundle)
        }
        /// 方向 — 件数の横の並び替えメニューの中の、昇順/降順を選ぶ欄の見出し
        static var listSortDirection: LocalizedStringResource {
            LocalizedStringResource("songs.list.sort.direction", defaultValue: "方向", table: "Songs", bundle: L10n.bundle)
        }
        /// 並び順 — 件数の横の並び替えメニューの中の、並び順を選ぶ欄の見出し
        static var listSortPicker: LocalizedStringResource {
            LocalizedStringResource("songs.list.sort.picker", defaultValue: "並び順", table: "Songs", bundle: L10n.bundle)
        }
        /// タグ絞り込みの取得に失敗しました。表示中の一覧にはタグ条件が反映されていません。 — タグで絞り込むための情報を取れなかった (オフライン等) ときのバナー。一覧は絞られていない
        static var listTagFilterError: LocalizedStringResource {
            LocalizedStringResource("songs.list.tag_filter.error", defaultValue: "タグ絞り込みの取得に失敗しました。表示中の一覧にはタグ条件が反映されていません。", table: "Songs", bundle: L10n.bundle)
        }
        /// 楽曲 — 曲一覧 (楽曲タブ) のナビゲーションタイトル
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("songs.list.title", defaultValue: "楽曲", table: "Songs", bundle: L10n.bundle)
        }
        /// 裏拍 — 手拍子の指示 (★)。裏拍で手拍子する
        static var lyricsClapBackBeat: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.clap.back_beat", defaultValue: "裏拍", table: "Songs", bundle: L10n.bundle)
        }
        /// 4つ打ち — 手拍子の指示 (■)。1 拍ごとに手拍子する (4 つ打ち)
        static var lyricsClapFourOnFloor: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.clap.four_on_floor", defaultValue: "4つ打ち", table: "Songs", bundle: L10n.bundle)
        }
        /// コールなし — 手拍子の指示 (♥)。声を出さないという積極的な指示
        static var lyricsClapNoCall: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.clap.no_call", defaultValue: "コールなし", table: "Songs", bundle: L10n.bundle)
        }
        /// 指定なし — 行頭の手拍子の指示を外すメニュー項目
        static var lyricsClapUnset: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.clap.unset", defaultValue: "指定なし", table: "Songs", bundle: L10n.bundle)
        }
        /// コールを付ける — コールガイドの編集を始めるボタン (コールがまだ無いとき)
        static var lyricsEditBeginAdd: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.edit.begin_add", defaultValue: "コールを付ける", table: "Songs", bundle: L10n.bundle)
        }
        /// コールを編集 — コールガイドの編集を始めるボタン (コールがあるとき)
        static var lyricsEditBeginEdit: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.edit.begin_edit", defaultValue: "コールを編集", table: "Songs", bundle: L10n.bundle)
        }
        /// 編集を終了 — コールガイドの編集モードを抜けるボタン
        static var lyricsEditFinish: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.edit.finish", defaultValue: "編集を終了", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞の語をタップすると、その語に被せるコールを付けられます。行末の ＋ は追っかけ、行頭の記号は手拍子。語をまたぐ範囲は長押しからなぞって選びます。 — 編集モードの先頭の操作説明。追っかけ = 歌の後に客席が返すコール (ko は 후창)
        static var lyricsEditHint: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.edit.hint", defaultValue: "歌詞の語をタップすると、その語に被せるコールを付けられます。行末の ＋ は追っかけ、行頭の記号は手拍子。語をまたぐ範囲は長押しからなぞって選びます。", table: "Songs", bundle: L10n.bundle)
        }
        /// 保存 — コールガイドの保存ボタン
        static var lyricsEditSave: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.edit.save", defaultValue: "保存", table: "Songs", bundle: L10n.bundle)
        }
        /// 通常 — コールの強調度。通常 (凡例には出さない)
        static var lyricsEmphasisNormal: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.emphasis.normal", defaultValue: "通常", table: "Songs", bundle: L10n.bundle)
        }
        /// おこのみで — コールの強調度 (緑)。入れても入れなくてもよいコール
        static var lyricsEmphasisOptional: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.emphasis.optional", defaultValue: "おこのみで", table: "Songs", bundle: L10n.bundle)
        }
        /// 演者要望 — コールの強調度 (赤)。出演者が入れてほしいと言ったコール
        static var lyricsEmphasisPerformerRequest: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.emphasis.performer_request", defaultValue: "演者要望", table: "Songs", bundle: L10n.bundle)
        }
        /// この曲の歌詞はまだ登録されていません。 — 歌詞が登録されていないときの説明
        static var lyricsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.empty.message", defaultValue: "この曲の歌詞はまだ登録されていません。", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞はまだありません — 歌詞が登録されていないとき
        static var lyricsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.empty.title", defaultValue: "歌詞はまだありません", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞を表示できません — 歌詞の取得に失敗したときの見出し (説明はサーバ・通信のエラー文)
        static var lyricsLoadErrorTitle: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.load_error.title", defaultValue: "歌詞を表示できません", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌詞の表示にはログインが必要です — 未ログインの人への案内 (歌詞タブの先頭の導線と、歌詞の代わりに出す空状態の見出し)
        static var lyricsLoginRequired: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.login_required", defaultValue: "歌詞の表示にはログインが必要です", table: "Songs", bundle: L10n.bundle)
        }
        /// ログインすると、登録済みの曲の歌詞を表示できます。 — 未ログインで歌詞が出ないときの説明
        static var lyricsLoginRequiredMessage: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.login_required_message", defaultValue: "ログインすると、登録済みの曲の歌詞を表示できます。", table: "Songs", bundle: L10n.bundle)
        }
        /// セクション: {name} — 歌詞の構成マーカー (イントロ・サビ等) の読み上げ。name は歌詞データの語 — 引数: name (string)
        static func lyricsMarkerA11y(name: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.marker.a11y", defaultValue: "セクション: \(name)", table: "Songs", bundle: L10n.bundle)
        }
        /// 「{text}」の掛かる範囲を選び直しています。語をタップ、または長押しからなぞる。 — コールの掛かる範囲 (アンカー) を選び直している間のバナー。text はコールの文言 (利用者の入力) — 引数: text (string)
        static func lyricsReanchorBanner(text: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.reanchor.banner", defaultValue: "「\(text)」の掛かる範囲を選び直しています。語をタップ、または長押しからなぞる。", table: "Songs", bundle: L10n.bundle)
        }
        /// やめる — 範囲の選び直しをやめるボタン
        static var lyricsReanchorCancel: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.reanchor.cancel", defaultValue: "やめる", table: "Songs", bundle: L10n.bundle)
        }
        /// 保存できませんでした — コールガイドの保存に失敗したときのアラートの見出し
        static var lyricsSaveErrorTitle: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.save_error.title", defaultValue: "保存できませんでした", table: "Songs", bundle: L10n.bundle)
        }
        /// 出典: {source} — 歌詞の出典の表記。source はサーバのデータ — 引数: source (string)
        static func lyricsSource(source: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.source", defaultValue: "出典: \(source)", table: "Songs", bundle: L10n.bundle)
        }
        /// 元のアンカー: {anchor} — ズレたコールの元の範囲の歌詞。anchor は歌詞の一部 — 引数: anchor (string)
        static func lyricsStaleAnchor(anchor: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.stale.anchor", defaultValue: "元のアンカー: \(anchor)", table: "Songs", bundle: L10n.bundle)
        }
        /// 元のアンカー: （なし） — ズレたコールの元の範囲が空だったとき
        static var lyricsStaleAnchorNone: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.stale.anchor_none", defaultValue: "元のアンカー: （なし）", table: "Songs", bundle: L10n.bundle)
        }
        /// アンカーがズレたコール（{count} 件） — 歌詞が直されて掛かる範囲がズレたコールの一覧の見出し。アンカー = コールが掛かる歌詞の範囲。1000 以上は桁区切りが付く (実際には届かない) — 引数: count (count)
        static func lyricsStaleHeader(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.stale.header", defaultValue: "アンカーがズレたコール（\(count) 件）", table: "Songs", bundle: L10n.bundle)
        }
        /// 選び直す — ズレたコールの範囲を選び直すボタン
        static var lyricsStaleReanchor: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.stale.reanchor", defaultValue: "選び直す", table: "Songs", bundle: L10n.bundle)
        }
        /// 追っかけ — コールのタイミング。歌い終わってから返す (アイマスではこちらが主)
        static var lyricsTimingAfter: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.timing.after", defaultValue: "追っかけ", table: "Songs", bundle: L10n.bundle)
        }
        /// フレーズを聞いてから返す。アイマスではこちらが主。 — コールの編集シートで 追っかけ を選んだときの説明
        static var lyricsTimingAfterHint: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.timing.after_hint", defaultValue: "フレーズを聞いてから返す。アイマスではこちらが主。", table: "Songs", bundle: L10n.bundle)
        }
        /// 同時 — コールのタイミング。歌に被せて叫ぶ
        static var lyricsTimingOver: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.timing.over", defaultValue: "同時", table: "Songs", bundle: L10n.bundle)
        }
        /// 歌に被せて叫ぶ。歌詞と同じタイミング。 — コールの編集シートで 同時 を選んだときの説明
        static var lyricsTimingOverHint: LocalizedStringResource {
            LocalizedStringResource("songs.lyrics.timing.over_hint", defaultValue: "歌に被せて叫ぶ。歌詞と同じタイミング。", table: "Songs", bundle: L10n.bundle)
        }
        /// 閉じる — 再生中バーの読み上げの操作 (再生をやめてバーを消す)
        static var nowPlayingCloseA11y: LocalizedStringResource {
            LocalizedStringResource("songs.now_playing.close.a11y", defaultValue: "閉じる", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲の詳細を開く。下に払うと閉じる — 再生中バーの読み上げのヒント
        static var nowPlayingOpenA11yHint: LocalizedStringResource {
            LocalizedStringResource("songs.now_playing.open.a11y_hint", defaultValue: "曲の詳細を開く。下に払うと閉じる", table: "Songs", bundle: L10n.bundle)
        }
        /// 一時停止 — 再生中バーの ‖ ボタンの読み上げ
        static var nowPlayingPauseA11y: LocalizedStringResource {
            LocalizedStringResource("songs.now_playing.pause.a11y", defaultValue: "一時停止", table: "Songs", bundle: L10n.bundle)
        }
        /// 再生 — 再生中バーの ▶ ボタンの読み上げ
        static var nowPlayingPlayA11y: LocalizedStringResource {
            LocalizedStringResource("songs.now_playing.play.a11y", defaultValue: "再生", table: "Songs", bundle: L10n.bundle)
        }
        /// 取消 — ペンライト投票シートを閉じるボタン
        static var penlightCancel: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.cancel", defaultValue: "取消", table: "Songs", bundle: L10n.bundle)
        }
        /// 色: {name} — 色の候補の読み上げ。name はサーバの色の名前 — 引数: name (string)
        static func penlightColorA11y(name: String) -> LocalizedStringResource {
            LocalizedStringResource("songs.penlight.color.a11y", defaultValue: "色: \(name)", table: "Songs", bundle: L10n.bundle)
        }
        /// 投票エラー — 投票に失敗したときのアラートの見出し (本文はサーバ・通信のエラー文)
        static var penlightErrorTitle: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.error.title", defaultValue: "投票エラー", table: "Songs", bundle: L10n.bundle)
        }
        /// 不明なエラーが発生しました — エラー文が無いときのアラートの本文
        static var penlightErrorUnknown: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.error.unknown", defaultValue: "不明なエラーが発生しました", table: "Songs", bundle: L10n.bundle)
        }
        /// ペンライトの色を選んで投票してください。複数選択できます。 — ペンライト投票シートの説明
        static var penlightInstructions: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.instructions", defaultValue: "ペンライトの色を選んで投票してください。複数選択できます。", table: "Songs", bundle: L10n.bundle)
        }
        /// 読み込み中… — 色の候補を読み込んでいる間
        static var penlightLoading: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.loading", defaultValue: "読み込み中…", table: "Songs", bundle: L10n.bundle)
        }
        /// カラーを選択 — 色の候補の節の見出し
        static var penlightPaletteHeader: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.palette.header", defaultValue: "カラーを選択", table: "Songs", bundle: L10n.bundle)
        }
        /// 通信状況を確認して再度お試しください — 色の候補を取れなかったときの説明
        static var penlightPaletteErrorMessage: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.palette_error.message", defaultValue: "通信状況を確認して再度お試しください", table: "Songs", bundle: L10n.bundle)
        }
        /// カラーを取得できません — 色の候補を取れなかったとき
        static var penlightPaletteErrorTitle: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.palette_error.title", defaultValue: "カラーを取得できません", table: "Songs", bundle: L10n.bundle)
        }
        /// 選択中のセット — 選んだ色の組の節の見出し
        static var penlightSelectedHeader: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.selected.header", defaultValue: "選択中のセット", table: "Songs", bundle: L10n.bundle)
        }
        /// 投票する — ペンライト投票シートの送信ボタン
        static var penlightSubmit: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.submit", defaultValue: "投票する", table: "Songs", bundle: L10n.bundle)
        }
        /// ペンライトカラーを投票 — ペンライト投票シートの見出し
        static var penlightTitle: LocalizedStringResource {
            LocalizedStringResource("songs.penlight.title", defaultValue: "ペンライトカラーを投票", table: "Songs", bundle: L10n.bundle)
        }
        /// {title} / 出演者 {count}名 — セトリの行から開く出演者一覧のタイトル。title は曲名、count は人数。1000 以上は桁区切りが付く (実際には届かない) — 引数: title (string), count (count)
        static func performerTitle(title: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.performer.title", defaultValue: "\(title) / 出演者 \(count)名", table: "Songs", bundle: L10n.bundle)
        }
        /// 閉じる — 曲を選ぶ画面を閉じるボタン
        static var pickerClose: LocalizedStringResource {
            LocalizedStringResource("songs.picker.close", defaultValue: "閉じる", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲名で検索 — 曲を選ぶ画面の検索欄のプレースホルダ
        static var pickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("songs.picker.search_prompt", defaultValue: "曲名で検索", table: "Songs", bundle: L10n.bundle)
        }
        /// 曲を選択 — セトリ編集などで曲を 1 つ選ぶ画面のタイトル
        static var pickerTitle: LocalizedStringResource {
            LocalizedStringResource("songs.picker.title", defaultValue: "曲を選択", table: "Songs", bundle: L10n.bundle)
        }
        /// {rate}% / {total}回 — 回収率順で並べたときに行に出す回収率と披露回数。rate は 0〜100 の整数 — 引数: rate (int), total (count)
        static func rowMetricCollectRate(rate: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.row.metric.collect_rate", defaultValue: "\(String(rate))% / \(total)回", table: "Songs", bundle: L10n.bundle)
        }
        /// {count}回 — 披露回数順・回収率順で並べたときに行に出す披露回数。1000 以上は桁区切りが付く (実際には届かない) — 引数: count (count)
        static func rowMetricPerformances(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("songs.row.metric.performances", defaultValue: "\(count)回", table: "Songs", bundle: L10n.bundle)
        }
        /// 担当 — 曲の行の印。担当アイドルが歌っている曲
        static var rowMyPick: LocalizedStringResource {
            LocalizedStringResource("songs.row.my_pick", defaultValue: "担当", table: "Songs", bundle: L10n.bundle)
        }
        /// 昇順 — 並びの方向 (小さい順・古い順)
        static var sortAscending: LocalizedStringResource {
            LocalizedStringResource("songs.sort.ascending", defaultValue: "昇順", table: "Songs", bundle: L10n.bundle)
        }
        /// 現地回収回数順 — 曲の並び順。自分が現地で聴いた (回収した) 回数の順
        static var sortCollectedCount: LocalizedStringResource {
            LocalizedStringResource("songs.sort.collected_count", defaultValue: "現地回収回数順", table: "Songs", bundle: L10n.bundle)
        }
        /// 回収率順 — 曲の並び順。披露回数のうち自分が現地で聴いた割合の順
        static var sortCollectedRate: LocalizedStringResource {
            LocalizedStringResource("songs.sort.collected_rate", defaultValue: "回収率順", table: "Songs", bundle: L10n.bundle)
        }
        /// 降順 — 並びの方向 (大きい順・新しい順)
        static var sortDescending: LocalizedStringResource {
            LocalizedStringResource("songs.sort.descending", defaultValue: "降順", table: "Songs", bundle: L10n.bundle)
        }
        /// 披露回数順 — 曲の並び順。ライブで歌われた回数の順
        static var sortPerformanceCount: LocalizedStringResource {
            LocalizedStringResource("songs.sort.performance_count", defaultValue: "披露回数順", table: "Songs", bundle: L10n.bundle)
        }
        /// リリース日順 — 曲の並び順。発売日の順
        static var sortReleaseDate: LocalizedStringResource {
            LocalizedStringResource("songs.sort.release_date", defaultValue: "リリース日順", table: "Songs", bundle: L10n.bundle)
        }
        /// 五十音順 — 曲の並び順。曲名の読み (日本語の仮名) の順。iOS は SongSortOrder の rawValue (保存値ではない) を表示に使っていたもの
        static var sortTitleKana: LocalizedStringResource {
            LocalizedStringResource("songs.sort.title_kana", defaultValue: "五十音順", table: "Songs", bundle: L10n.bundle)
        }
    }
}
