// 生成物: i18n/catalog/idols.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/idols.json の文言 (表 Idols)
    enum Idols {
        /// CV名をコピー — 詳細の名前の長押しメニュー。CV = 担当声優
        static var copyCv: LocalizedStringResource {
            LocalizedStringResource("idols.copy.cv", defaultValue: "CV名をコピー", table: "Idols", bundle: L10n.bundle)
        }
        /// よみをコピー — アイドル名の長押しメニュー。よみ = 名前の読み仮名
        static var copyKana: LocalizedStringResource {
            LocalizedStringResource("idols.copy.kana", defaultValue: "よみをコピー", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル名をコピー — アイドル名の長押しメニュー (一覧の行・詳細の名前)
        static var copyName: LocalizedStringResource {
            LocalizedStringResource("idols.copy.name", defaultValue: "アイドル名をコピー", table: "Idols", bundle: L10n.bundle)
        }
        /// 出演履歴 — ライブのタブの節の見出し。このアイドルが出演した公演 (右に件数)
        static var detailCastShowsHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.cast_shows.header", defaultValue: "出演履歴", table: "Idols", bundle: L10n.bundle)
        }
        /// タグ付け・投票にはログインが必要です — コミュニティのタブの先頭に出す、未ログインの人への案内
        static var detailCommunityLoginPrompt: LocalizedStringResource {
            LocalizedStringResource("idols.detail.community.login_prompt", defaultValue: "タグ付け・投票にはログインが必要です", table: "Idols", bundle: L10n.bundle)
        }
        /// お気に入り — 詳細の上部のボタン。お気に入りにする (Android は状態によらずこの文言)
        static var detailHeroFavorite: LocalizedStringResource {
            LocalizedStringResource("idols.detail.hero.favorite", defaultValue: "お気に入り", table: "Idols", bundle: L10n.bundle)
        }
        /// お気に入り済 — 詳細の上部のボタン。お気に入りにしているとき。ko は状態を表す「즐겨찾기됨」(「즐겨찾기함」は「お気に入りの箱・フォルダ」と読めるので使わない)
        static var detailHeroFavoriteOn: LocalizedStringResource {
            LocalizedStringResource("idols.detail.hero.favorite_on", defaultValue: "お気に入り済", table: "Idols", bundle: L10n.bundle)
        }
        /// メモ — 詳細の上部のボタン。メモを書く
        static var detailHeroNote: LocalizedStringResource {
            LocalizedStringResource("idols.detail.hero.note", defaultValue: "メモ", table: "Idols", bundle: L10n.bundle)
        }
        /// メモあり — 詳細の上部のボタン。メモを書いてあるとき
        static var detailHeroNoteOn: LocalizedStringResource {
            LocalizedStringResource("idols.detail.hero.note_on", defaultValue: "メモあり", table: "Idols", bundle: L10n.bundle)
        }
        /// 担当 — 詳細の上部のボタン。担当 (推し) にする/外す。担当にしているときも同じ文言
        static var detailHeroPick: LocalizedStringResource {
            LocalizedStringResource("idols.detail.hero.pick", defaultValue: "担当", table: "Idols", bundle: L10n.bundle)
        }
        /// このアイドルのライブ出演・歌唱記録はまだ登録されていません。 — ライブのタブで記録が 1 件も無いときの説明
        static var detailLiveEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("idols.detail.live.empty.message", defaultValue: "このアイドルのライブ出演・歌唱記録はまだ登録されていません。", table: "Idols", bundle: L10n.bundle)
        }
        /// ライブ情報がありません — ライブのタブで出演・歌唱の記録が 1 件も無いときの見出し
        static var detailLiveEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.detail.live.empty.title", defaultValue: "ライブ情報がありません", table: "Idols", bundle: L10n.bundle)
        }
        /// 編集 — 詳細のメニュー項目。アイドル情報を編集する
        static var detailMenuEdit: LocalizedStringResource {
            LocalizedStringResource("idols.detail.menu.edit", defaultValue: "編集", table: "Idols", bundle: L10n.bundle)
        }
        /// 編集履歴 — 詳細のメニュー項目。このアイドルの編集履歴を見る
        static var detailMenuHistory: LocalizedStringResource {
            LocalizedStringResource("idols.detail.menu.history", defaultValue: "編集履歴", table: "Idols", bundle: L10n.bundle)
        }
        /// ライブ歌唱曲 — ライブのタブの節の見出し。このアイドルがライブで歌った曲 (右に曲数)
        static var detailPerformedSongsHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.performed_songs.header", defaultValue: "ライブ歌唱曲", table: "Idols", bundle: L10n.bundle)
        }
        /// マイタグを削除 — マイタグの長押しメニュー
        static var detailPersonalTagsActionRemove: LocalizedStringResource {
            LocalizedStringResource("idols.detail.personal_tags.action.remove", defaultValue: "マイタグを削除", table: "Idols", bundle: L10n.bundle)
        }
        /// 自分だけに表示されます (コミュニティには公開されません) — マイタグの節の見出しの下の説明
        static var detailPersonalTagsCaption: LocalizedStringResource {
            LocalizedStringResource("idols.detail.personal_tags.caption", defaultValue: "自分だけに表示されます (コミュニティには公開されません)", table: "Idols", bundle: L10n.bundle)
        }
        /// マイタグ — マイタグ (自分だけのタグ) の節の見出し。Android は共通部品 PersonalTagsSection にある
        static var detailPersonalTagsHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.personal_tags.header", defaultValue: "マイタグ", table: "Idols", bundle: L10n.bundle)
        }
        /// マイタグを追加 (例: 聞いた) — マイタグの入力欄のプレースホルダ。例の語も訳す
        static var detailPersonalTagsPlaceholder: LocalizedStringResource {
            LocalizedStringResource("idols.detail.personal_tags.placeholder", defaultValue: "マイタグを追加 (例: 聞いた)", table: "Idols", bundle: L10n.bundle)
        }
        /// ゲスト — 出演履歴の行のタグ。その公演にゲストで出た
        static var detailShowGuest: LocalizedStringResource {
            LocalizedStringResource("idols.detail.show.guest", defaultValue: "ゲスト", table: "Idols", bundle: L10n.bundle)
        }
        /// 主演 — 出演履歴の行のタグ。その公演の主演
        static var detailShowLead: LocalizedStringResource {
            LocalizedStringResource("idols.detail.show.lead", defaultValue: "主演", table: "Idols", bundle: L10n.bundle)
        }
        /// つけられたタグが似ているアイドル — タグが似ているアイドルの節の見出しの下の説明
        static var detailSimilarCaption: LocalizedStringResource {
            LocalizedStringResource("idols.detail.similar.caption", defaultValue: "つけられたタグが似ているアイドル", table: "Idols", bundle: L10n.bundle)
        }
        /// タグが似ているアイドル — タグが似ているアイドル (サーバ算出のおすすめ) の節の見出し
        static var detailSimilarHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.similar.header", defaultValue: "タグが似ているアイドル", table: "Idols", bundle: L10n.bundle)
        }
        /// タグ{count}個一致 — おすすめのアイドルの下に出す、共通するタグの数 — 引数: count (count)
        static func detailSimilarSharedTags(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.detail.similar.shared_tags", defaultValue: "タグ\(count)個一致", table: "Idols", bundle: L10n.bundle)
        }
        /// 回収済 — 楽曲の行のバッジ。ライブでその曲を聴いた (現地回収した)。ko は用語集 (回収済み → 회수함) に合わせる。units.detail.songs.collected (今は「회수 완료」) もそろえる
        static var detailSongCollected: LocalizedStringResource {
            LocalizedStringResource("idols.detail.song.collected", defaultValue: "回収済", table: "Idols", bundle: L10n.bundle)
        }
        /// {count}回 — ライブ歌唱曲の行に出す、この曲を歌った回数。1000 回以上なら桁区切りが付く — 引数: count (count)
        static func detailSongPerformCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.detail.song.perform_count", defaultValue: "\(count)回", table: "Idols", bundle: L10n.bundle)
        }
        /// 原曲の情報はまだ登録されていません。 — 楽曲のタブで原曲が 1 曲も無いときの説明。原曲 = このアイドルが持ち歌として歌う曲
        static var detailSongsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("idols.detail.songs.empty.message", defaultValue: "原曲の情報はまだ登録されていません。", table: "Idols", bundle: L10n.bundle)
        }
        /// 楽曲がありません — 楽曲のタブで原曲が 1 曲も無いときの見出し
        static var detailSongsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.detail.songs.empty.title", defaultValue: "楽曲がありません", table: "Idols", bundle: L10n.bundle)
        }
        /// コミュニティ — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ)
        static var detailTabCommunity: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tab.community", defaultValue: "コミュニティ", table: "Idols", bundle: L10n.bundle)
        }
        /// ライブ — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ)
        static var detailTabLive: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tab.live", defaultValue: "ライブ", table: "Idols", bundle: L10n.bundle)
        }
        /// プロフィール — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ)
        static var detailTabProfile: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tab.profile", defaultValue: "プロフィール", table: "Idols", bundle: L10n.bundle)
        }
        /// 楽曲 — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ)
        static var detailTabSongs: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tab.songs", defaultValue: "楽曲", table: "Idols", bundle: L10n.bundle)
        }
        /// タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ
        static var detailTagsActionAdd: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.action.add", defaultValue: "タグを追加", table: "Idols", bundle: L10n.bundle)
        }
        /// タグを外す — 自分が付けたタグの長押しメニュー
        static var detailTagsActionRemove: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.action.remove", defaultValue: "タグを外す", table: "Idols", bundle: L10n.bundle)
        }
        /// タグ詳細を見る — タグの長押しメニュー
        static var detailTagsActionShowDetail: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.action.show_detail", defaultValue: "タグ詳細を見る", table: "Idols", bundle: L10n.bundle)
        }
        /// タグ — タグの節の見出し右の ＋ 付きボタン (短い形)
        static var detailTagsAddButton: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.add_button", defaultValue: "タグ", table: "Idols", bundle: L10n.bundle)
        }
        /// このアイドルを一言で表すタグを付けてみませんか？ — タグが 1 つも無いときの誘い文句
        static var detailTagsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.empty.message", defaultValue: "このアイドルを一言で表すタグを付けてみませんか？", table: "Idols", bundle: L10n.bundle)
        }
        /// タグはまだありません — タグが 1 つも無いとき
        static var detailTagsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.empty.title", defaultValue: "タグはまだありません", table: "Idols", bundle: L10n.bundle)
        }
        /// タグ — コミュニティタグの節の見出し
        static var detailTagsHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.tags.header", defaultValue: "タグ", table: "Idols", bundle: L10n.bundle)
        }
        /// 所属ユニット — 所属ユニットの節の見出し (右に数)。iOS はプロフィールのタブ、Android は楽曲・ユニットのタブ
        static var detailUnitsHeader: LocalizedStringResource {
            LocalizedStringResource("idols.detail.units.header", defaultValue: "所属ユニット", table: "Idols", bundle: L10n.bundle)
        }
        /// 曲なしユニット — 持ち歌の無いユニットの折りたたみ見出し (右に数)
        static var detailUnitsWithoutSongs: LocalizedStringResource {
            LocalizedStringResource("idols.detail.units.without_songs", defaultValue: "曲なしユニット", table: "Idols", bundle: L10n.bundle)
        }
        /// 次の出演 ・ {date} — 次に出演する公演のカードの一行目。date は公演日を「6/21」の形 (月/日の数字) にしたもの — 引数: date (string)
        static func detailUpcomingLabel(date: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.detail.upcoming.label", defaultValue: "次の出演 ・ \(date)", table: "Idols", bundle: L10n.bundle)
        }
        /// CV名 — 表示形式の選択肢 (名前を CV = 声優の名前で出す)。iOS は IdolDisplayMode.label (保存値の rawValue とは別)、Android はフィルタシートのセグメント
        static var displayModeCvName: LocalizedStringResource {
            LocalizedStringResource("idols.display_mode.cv_name", defaultValue: "CV名", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル名 — 表示形式の選択肢 (名前をアイドル名で出す)。iOS は IdolDisplayMode.label (保存値の rawValue とは別)、Android はフィルタシートのセグメント
        static var displayModeIdolName: LocalizedStringResource {
            LocalizedStringResource("idols.display_mode.idol_name", defaultValue: "アイドル名", table: "Idols", bundle: L10n.bundle)
        }
        /// 追加 — ギャラリーの見出し右の、画像を選んで足すボタン
        static var galleryActionAdd: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.action.add", defaultValue: "追加", table: "Idols", bundle: L10n.bundle)
        }
        /// 削除 — ギャラリーの画像の長押しメニュー。画像を消す
        static var galleryActionDelete: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.action.delete", defaultValue: "削除", table: "Idols", bundle: L10n.bundle)
        }
        /// アイコンにする — ギャラリーの画像の長押しメニュー。その画像をアイコン (先頭) にする。ko は汎用ギャラリーの gallery.action.set_primary_label (既定の呼称で「아이콘 설정」) と長押しの案内 (gallery.idol.long_press_hint の「아이콘 설정」) にそろえる
        static var galleryActionSetPrimary: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.action.set_primary", defaultValue: "アイコンにする", table: "Idols", bundle: L10n.bundle)
        }
        /// {label}にする — 汎用ギャラリー (GallerySectionView、今はユニット詳細) の長押しメニュー。label は呼称 (既定は gallery.primary_badge =「アイコン」)。ko は助詞を使わない「{label} 설정」(label の終わりの音で助詞の形が変わらないように。アイドルの gallery.action.set_primary「아이콘 설정」・案内の gallery.long_press_hint_label「{label} 설정·삭제」とそろえる) — 引数: label (string)
        static func galleryActionSetPrimaryLabel(label: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.gallery.action.set_primary_label", defaultValue: "\(label)にする", table: "Idols", bundle: L10n.bundle)
        }
        /// 画像を追加すると、先頭の1枚が{label}になります。 — 汎用ギャラリー (GallerySectionView) で画像が無いときの説明。label は呼称 (既定は「アイコン」)。ko は名詞の終わりで形が変わらない助詞「에」を使う — 引数: label (string)
        static func galleryEmptyHintLabel(label: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.gallery.empty_hint_label", defaultValue: "画像を追加すると、先頭の1枚が\(label)になります。", table: "Idols", bundle: L10n.bundle)
        }
        /// ギャラリー — 取り込んだ画像のギャラリーの節の見出し (右に枚数)
        static var galleryHeader: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.header", defaultValue: "ギャラリー", table: "Idols", bundle: L10n.bundle)
        }
        /// 画像を追加すると、先頭の1枚がアイコンになります。ホーム画面ウィジェットにも使えます。 — アイドル詳細のギャラリーで画像が無いときの説明
        static var galleryIdolEmptyHint: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.idol.empty_hint", defaultValue: "画像を追加すると、先頭の1枚がアイコンになります。ホーム画面ウィジェットにも使えます。", table: "Idols", bundle: L10n.bundle)
        }
        /// 長押しでアイコン設定・ウィジェットのスライドショー対象を切り替えられます。 — アイドル詳細のギャラリーの下の操作の案内。スライドショー = ホーム画面ウィジェットで順に出す画像
        static var galleryIdolLongPressHint: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.idol.long_press_hint", defaultValue: "長押しでアイコン設定・ウィジェットのスライドショー対象を切り替えられます。", table: "Idols", bundle: L10n.bundle)
        }
        /// 長押しで{label}に設定・削除できます。 — 汎用ギャラリー (GallerySectionView) の下の操作の案内。label は呼称 (既定は「アイコン」) — 引数: label (string)
        static func galleryLongPressHintLabel(label: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.gallery.long_press_hint_label", defaultValue: "長押しで\(label)に設定・削除できます。", table: "Idols", bundle: L10n.bundle)
        }
        /// アイコン — ギャラリーの先頭の画像に付くバッジ (その画像がアイコンになる)。iOS の GallerySectionView では呼称 (entityLabel) の既定値にも使う
        static var galleryPrimaryBadge: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.primary_badge", defaultValue: "アイコン", table: "Idols", bundle: L10n.bundle)
        }
        /// スライドショーに入れる — ギャラリーの画像の長押しメニュー。ウィジェットのスライドショーに出す
        static var gallerySlideshowAdd: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.slideshow.add", defaultValue: "スライドショーに入れる", table: "Idols", bundle: L10n.bundle)
        }
        /// スライドショー対象外 — ギャラリーの画像の右下の印の読み上げ。ウィジェットのスライドショーに出さない画像
        static var gallerySlideshowExcludedA11y: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.slideshow.excluded.a11y", defaultValue: "スライドショー対象外", table: "Idols", bundle: L10n.bundle)
        }
        /// スライドショーから外す — ギャラリーの画像の長押しメニュー。ウィジェットのスライドショーに出さない
        static var gallerySlideshowRemove: LocalizedStringResource {
            LocalizedStringResource("idols.gallery.slideshow.remove", defaultValue: "スライドショーから外す", table: "Idols", bundle: L10n.bundle)
        }
        /// フィルタを解除 — フィルタ (ブランド・属性・表示形式・マイマーク) をまとめて外す。iOS はメニュー項目と空状態のボタン、Android は空状態のボタン
        static var listActionClearFilters: LocalizedStringResource {
            LocalizedStringResource("idols.list.action.clear_filters", defaultValue: "フィルタを解除", table: "Idols", bundle: L10n.bundle)
        }
        /// 絞り込みを解除 — 絞り込みの語 (一覧の上の入力欄に打った語) を消すボタン。ko はフィルタ (ブランド・属性など) をまとめて外す list.action.clear_filters (필터 해제) と分けるため、用語集の絞り込みの別訳「찾기」を使う
        static var listFilterEmptyActionClear: LocalizedStringResource {
            LocalizedStringResource("idols.list.filter_empty.action.clear", defaultValue: "絞り込みを解除", table: "Idols", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するアイドルがいません — 絞り込みの語で 1 人も残らなかったときの説明。query は利用者が打った語 — 引数: query (string)
        static func listFilterEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.list.filter_empty.message", defaultValue: "「\(query)」に一致するアイドルがいません", table: "Idols", bundle: L10n.bundle)
        }
        /// 絞り込み結果がありません — 絞り込みの語で 1 人も残らなかったときの空状態の見出し。ko は list.filter_empty.action.clear と同じく「찾기」を使う (フィルタの「필터」と分ける)
        static var listFilterEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.list.filter_empty.title", defaultValue: "絞り込み結果がありません", table: "Idols", bundle: L10n.bundle)
        }
        /// {order}順 ・ {count}人 — 公式順以外で並べたとき (ブランドの区切りを外した通し表示) の見出し。order は並び順の名前 (sort_order.*。ko は「〜순」まで含む)、count は人数。ja は order のあとに「順」を足すので、五十音順では「五十音順順」になる (今の表示のまま。直すのは別 PR)。1000 人以上なら桁区切りが付く (1,000人) — 引数: order (text), count (count)
        static func listFlatHeader(order: LocalizedStringResource, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.list.flat_header", defaultValue: "\(order)順 ・ \(count)人", table: "Idols", bundle: L10n.bundle)
        }
        /// {order}順 — リスト表示の通し並び (公式順以外) の左の見出し。右に人数 (list.idol_count)。order は sort_order.* (ko は「〜순」まで含むので、ko はそのまま出す) — 引数: order (text)
        static func listFlatListHeading(order: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("idols.list.flat_list.heading", defaultValue: "\(order)順", table: "Idols", bundle: L10n.bundle)
        }
        /// {count}人 — アイドルの人数。iOS は通し並びの見出しの右、Android は誕生月のアイドル一覧の先頭。1000 人以上なら桁区切りが付く (1,000人) — 引数: count (count)
        static func listIdolCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.list.idol_count", defaultValue: "\(count)人", table: "Idols", bundle: L10n.bundle)
        }
        /// フィルタ条件を変更するか、フィルタを解除してください。 — フィルタで 1 人も残らなかったときの空状態の説明
        static var listNoMatchMessage: LocalizedStringResource {
            LocalizedStringResource("idols.list.no_match.message", defaultValue: "フィルタ条件を変更するか、フィルタを解除してください。", table: "Idols", bundle: L10n.bundle)
        }
        /// 該当するアイドルがいません — フィルタ (ブランド・属性・マイマーク) で 1 人も残らなかったときの空状態の見出し
        static var listNoMatchTitle: LocalizedStringResource {
            LocalizedStringResource("idols.list.no_match.title", defaultValue: "該当するアイドルがいません", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル名・CV名 — ナビバーの中の絞り込み欄のプレースホルダ。アイドル名と CV (声優) 名の両方で絞れる
        static var listSearchFieldPrompt: LocalizedStringResource {
            LocalizedStringResource("idols.list.search_field.prompt", defaultValue: "アイドル名・CV名", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル — 一覧の上のセグメント (アイドル / ユニット) のアイドル側
        static var listTabIdols: LocalizedStringResource {
            LocalizedStringResource("idols.list.tab.idols", defaultValue: "アイドル", table: "Idols", bundle: L10n.bundle)
        }
        /// ユニット — 一覧の上のセグメント (アイドル / ユニット) のユニット側
        static var listTabUnits: LocalizedStringResource {
            LocalizedStringResource("idols.list.tab.units", defaultValue: "ユニット", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル — アイドル一覧の見出し (iOS はナビゲーションタイトル、Android は上部バーでアイドルのタブを選んでいるとき)
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("idols.list.title", defaultValue: "アイドル", table: "Idols", bundle: L10n.bundle)
        }
        /// グリッド表示 — 一覧/グリッドの切替 (今はリスト表示で、押すとグリッド表示になる)。iOS はアイドル一覧のメニュー項目と選択画面のボタンの読み上げ、Android は上部バーのボタンの読み上げ
        static var listViewModeGrid: LocalizedStringResource {
            LocalizedStringResource("idols.list.view_mode.grid", defaultValue: "グリッド表示", table: "Idols", bundle: L10n.bundle)
        }
        /// リスト表示 — 一覧/グリッドの切替 (今はグリッド表示で、押すとリスト表示になる)。iOS はアイドル一覧のメニュー項目と選択画面のボタンの読み上げ、Android は上部バーのボタンの読み上げ
        static var listViewModeList: LocalizedStringResource {
            LocalizedStringResource("idols.list.view_mode.list", defaultValue: "リスト表示", table: "Idols", bundle: L10n.bundle)
        }
        ///  ・  — 日付・会場・公演名を 1 行に並べるときの区切り (前後の空白込み)。出演履歴・次の出演・披露履歴の行
        static var metaSeparator: LocalizedStringResource {
            LocalizedStringResource("idols.meta.separator", defaultValue: " ・ ", table: "Idols", bundle: L10n.bundle)
        }
        /// キャンセル — アイドル・ユニットの選択画面の左上のボタン。選ばずに閉じる
        static var pickerActionCancel: LocalizedStringResource {
            LocalizedStringResource("idols.picker.action.cancel", defaultValue: "キャンセル", table: "Idols", bundle: L10n.bundle)
        }
        /// 決定 — アイドル・ユニットの選択画面の右上のボタン。選んだものを確定して閉じる
        static var pickerActionDone: LocalizedStringResource {
            LocalizedStringResource("idols.picker.action.done", defaultValue: "決定", table: "Idols", bundle: L10n.bundle)
        }
        /// ユニットから追加 — アイドル選択画面 (IdolPickerView)。ユニットを選んでメンバーをまとめて足す。ボタンの読み上げと、ユニットを選ぶ画面の見出し
        static var pickerAddFromUnit: LocalizedStringResource {
            LocalizedStringResource("idols.picker.add_from_unit", defaultValue: "ユニットから追加", table: "Idols", bundle: L10n.bundle)
        }
        /// すべて — 選択画面の上のブランドのチップ。ブランドで絞らない
        static var pickerBrandFilterAll: LocalizedStringResource {
            LocalizedStringResource("idols.picker.brand_filter.all", defaultValue: "すべて", table: "Idols", bundle: L10n.bundle)
        }
        /// このブランドに該当するアイドルがいません — アイドル選択画面 (IdolPickerView)。選んだブランドに 1 人もいないときの説明
        static var pickerEmptyMessageBrand: LocalizedStringResource {
            LocalizedStringResource("idols.picker.empty.message_brand", defaultValue: "このブランドに該当するアイドルがいません", table: "Idols", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するアイドルがいません — アイドル選択画面 (IdolPickerView)。検索の語で 1 人も残らなかったときの説明。query は利用者が打った語 — 引数: query (string)
        static func pickerEmptyMessageQuery(query: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.picker.empty.message_query", defaultValue: "「\(query)」に一致するアイドルがいません", table: "Idols", bundle: L10n.bundle)
        }
        /// 見つかりません — アイドル選択画面 (IdolPickerView)。1 人も残らなかったときの見出し
        static var pickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.picker.empty.title", defaultValue: "見つかりません", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル名 / CV名で検索 — アイドル選択画面 (IdolPickerView)。検索欄のプレースホルダ
        static var pickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("idols.picker.search_prompt", defaultValue: "アイドル名 / CV名で検索", table: "Idols", bundle: L10n.bundle)
        }
        /// アイドル — アイドル選択画面 (IdolPickerView)。既定のナビゲーションタイトル (呼び出し元が別のタイトルを渡すこともある)。ツールバーが混むので短く
        static var pickerTitle: LocalizedStringResource {
            LocalizedStringResource("idols.picker.title", defaultValue: "アイドル", table: "Idols", bundle: L10n.bundle)
        }
        /// ユニット名で検索 — ユニットを選ぶ画面の検索欄のプレースホルダ
        static var pickerUnitSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("idols.picker.unit_search_prompt", defaultValue: "ユニット名で検索", table: "Idols", bundle: L10n.bundle)
        }
        /// {month}月{day}日 — 誕生日の表示 (Idol.birthdayDisplay。カレンダーの日の詳細などに出る)。month・day は数字 (桁区切りなし) — 引数: month (int), day (int)
        static func profileBirthday(month: Int, day: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.profile.birthday", defaultValue: "\(String(month))月\(String(day))日", table: "Idols", bundle: L10n.bundle)
        }
        /// {idol} による「{song}」の披露記録はありません — 披露履歴が 1 件も無いときの説明。idol はアイドル名、song は曲名 (どちらもデータ。訳さない) — 引数: idol (string), song (string)
        static func songHistoryEmptyMessage(idol: String, song: String) -> LocalizedStringResource {
            LocalizedStringResource("idols.song_history.empty.message", defaultValue: "\(idol) による「\(song)」の披露記録はありません", table: "Idols", bundle: L10n.bundle)
        }
        /// 披露履歴がありません — 披露履歴が 1 件も無いときの見出し
        static var songHistoryEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("idols.song_history.empty.title", defaultValue: "披露履歴がありません", table: "Idols", bundle: L10n.bundle)
        }
        /// 披露履歴 — アイドル × 曲の披露履歴 (この人がこの曲を歌った公演) の節の見出し (右に件数)
        static var songHistoryHeader: LocalizedStringResource {
            LocalizedStringResource("idols.song_history.header", defaultValue: "披露履歴", table: "Idols", bundle: L10n.bundle)
        }
        /// 年齢 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。年齢順
        static var sortOrderAge: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.age", defaultValue: "年齢", table: "Idols", bundle: L10n.bundle)
        }
        /// 誕生日 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。誕生日 (月日) 順
        static var sortOrderBirthday: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.birthday", defaultValue: "誕生日", table: "Idols", bundle: L10n.bundle)
        }
        /// デビュー日 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。デビュー日 (実装日) 順
        static var sortOrderDebut: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.debut", defaultValue: "デビュー日", table: "Idols", bundle: L10n.bundle)
        }
        /// 身長 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。身長順
        static var sortOrderHeight: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.height", defaultValue: "身長", table: "Idols", bundle: L10n.bundle)
        }
        /// 五十音順 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。名前の日本語のよみ (かな) の五十音順。ko は「50음순」(「가나다순」はハングルの順と読めるので使わない)
        static var sortOrderNameKana: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.name_kana", defaultValue: "五十音順", table: "Idols", bundle: L10n.bundle)
        }
        /// 公式順 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。公式 = ブランドごとの公式の並び
        static var sortOrderOfficial: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.official", defaultValue: "公式順", table: "Idols", bundle: L10n.bundle)
        }
        /// 体重 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。体重順
        static var sortOrderWeight: LocalizedStringResource {
            LocalizedStringResource("idols.sort_order.weight", defaultValue: "体重", table: "Idols", bundle: L10n.bundle)
        }
        /// 出演者 {count}名 — 出演者のアイコンを重ねて並べた部品 (StackedAvatars) の読み上げ。count は人数。1000 人以上なら桁区切りが付く — 引数: count (count)
        static func stackedAvatarsA11y(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.stacked_avatars.a11y", defaultValue: "出演者 \(count)名", table: "Idols", bundle: L10n.bundle)
        }
        /// ユニットを選択 ({count}) — ユニットを複数選ぶ画面 (お題の作成・投票) のナビゲーションタイトル。count は選んでいる数。1000 以上なら桁区切りが付く (もとの navigationTitle の文字列補間も LocalizedStringKey なので同じ) — 引数: count (count)
        static func unitPickerTitle(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("idols.unit_picker.title", defaultValue: "ユニットを選択 (\(count))", table: "Idols", bundle: L10n.bundle)
        }
        /// お気に入りの切り替え — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。お気に入りにする/外す
        static var writeActionToggleFavorite: LocalizedStringResource {
            LocalizedStringResource("idols.write_action.toggle_favorite", defaultValue: "お気に入りの切り替え", table: "Idols", bundle: L10n.bundle)
        }
        /// 担当の切り替え — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。担当にする/外す
        static var writeActionTogglePick: LocalizedStringResource {
            LocalizedStringResource("idols.write_action.toggle_pick", defaultValue: "担当の切り替え", table: "Idols", bundle: L10n.bundle)
        }
    }
}
