// 生成物: i18n/catalog/idols.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/idols.json の文言。L10n.Idols から引く (iOS の L10n.Idols と同じ名前)。 */
object L10nIdols {
    /** エンジェル — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。ミリオンライブ・765AS */
    val attributeAngel: DisplayText get() = DisplayText.Res(R.string.idols_attribute_angel)
    /** クール — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。シンデレラガールズ */
    val attributeCool: DisplayText get() = DisplayText.Res(R.string.idols_attribute_cool)
    /** キュート — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。シンデレラガールズ */
    val attributeCute: DisplayText get() = DisplayText.Res(R.string.idols_attribute_cute)
    /** フェアリー — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。ミリオンライブ・765AS */
    val attributeFairy: DisplayText get() = DisplayText.Res(R.string.idols_attribute_fairy)
    /** インテリ — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。SideM */
    val attributeIntelli: DisplayText get() = DisplayText.Res(R.string.idols_attribute_intelli)
    /** メンタル — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。SideM */
    val attributeMental: DisplayText get() = DisplayText.Res(R.string.idols_attribute_mental)
    /** パッション — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。シンデレラガールズ */
    val attributePassion: DisplayText get() = DisplayText.Res(R.string.idols_attribute_passion)
    /** フィジカル — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。SideM */
    val attributePhysical: DisplayText get() = DisplayText.Res(R.string.idols_attribute_physical)
    /** プリンセス — ブランド内の属性の名前 (ゲームの公式の属性名)。Android のフィルタシートの属性チップ。判定は英字の内部値で行う。ko は韓国のファンが使う音訳。ミリオンライブ・765AS */
    val attributePrincess: DisplayText get() = DisplayText.Res(R.string.idols_attribute_princess)
    /** アイドルが見つかりません — 誕生月で絞ったアイドル一覧が空のとき (Android) */
    val birthMonthEmpty: DisplayText get() = DisplayText.Res(R.string.idols_birth_month_empty)
    /** {month}月生まれのアイドル — 誕生月で絞ったアイドル一覧の見出し (Android)。month は 1〜12。iOS の同じ画面は FilteredIdolsView (filtered) — 引数: month (int) */
    fun birthMonthTitle(month: Int): DisplayText = DisplayText.Res(R.string.idols_birth_month_title, listOf(month))
    /** 出演履歴 — ライブのタブの節の見出し。このアイドルが出演した公演 (右に件数) */
    val detailCastShowsHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_cast_shows_header)
    /** タグ付け・投票にはログインが必要です。 — 未ログインでタグを付けようとしたときのダイアログの本文 (Android) */
    val detailCommunityLoginDialog: DisplayText get() = DisplayText.Res(R.string.idols_detail_community_login_dialog)
    /** タグ付け・投票にはログインが必要です — コミュニティのタブの先頭に出す、未ログインの人への案内 */
    val detailCommunityLoginPrompt: DisplayText get() = DisplayText.Res(R.string.idols_detail_community_login_prompt)
    /** アイコン写真を変更 — アバター右下のカメラボタンの読み上げ (Android)。選んだ写真がアイコンになる */
    val detailHeroChangeIconA11y: DisplayText get() = DisplayText.Res(R.string.idols_detail_hero_change_icon_a11y)
    /** お気に入り — 詳細の上部のボタン。お気に入りにする (Android は状態によらずこの文言) */
    val detailHeroFavorite: DisplayText get() = DisplayText.Res(R.string.idols_detail_hero_favorite)
    /** 担当 — 詳細の上部のボタン。担当 (推し) にする/外す。担当にしているときも同じ文言 */
    val detailHeroPick: DisplayText get() = DisplayText.Res(R.string.idols_detail_hero_pick)
    /** このアイドルのライブ出演・歌唱記録はまだ登録されていません。 — ライブのタブで記録が 1 件も無いときの説明 */
    val detailLiveEmptyMessage: DisplayText get() = DisplayText.Res(R.string.idols_detail_live_empty_message)
    /** ライブ記録はまだありません — Android の文言。iOS の detail.live.empty.title と ja が違う (統一はオーナーが別 PR で) */
    val detailLiveEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.idols_detail_live_empty_title_android)
    /** その他 — 詳細の上部バー右のメニューボタン (︙) の読み上げ (Android) */
    val detailMenuA11y: DisplayText get() = DisplayText.Res(R.string.idols_detail_menu_a11y)
    /** 編集 — 詳細のメニュー項目。アイドル情報を編集する */
    val detailMenuEdit: DisplayText get() = DisplayText.Res(R.string.idols_detail_menu_edit)
    /** 編集履歴 — 詳細のメニュー項目。このアイドルの編集履歴を見る */
    val detailMenuHistory: DisplayText get() = DisplayText.Res(R.string.idols_detail_menu_history)
    /** ライブ歌唱曲 — ライブのタブの節の見出し。このアイドルがライブで歌った曲 (右に曲数) */
    val detailPerformedSongsHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_performed_songs_header)
    /** プロフィール — プロフィールのタブの節の見出し (Android) */
    val detailProfileHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_profile_header)
    /** {place}出身 — 出身地のチップ。place は DB の出身地 (都道府県名など。訳さない) — 引数: place (string) */
    fun detailSameProfileBirthPlace(place: String): DisplayText = DisplayText.Res(R.string.idols_detail_same_profile_birth_place, listOf(place))
    /** {type}型 — 血液型のチップ。type は DB の血液型 (A・B・O・AB) — 引数: type (string) */
    fun detailSameProfileBloodType(type: String): DisplayText = DisplayText.Res(R.string.idols_detail_same_profile_blood_type, listOf(type))
    /** 同じプロフィールのアイドル — プロフィールの属性 (ブランド・星座・出身地・血液型) から同じ人の一覧へ飛ぶチップの節の見出し (Android) */
    val detailSameProfileHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_same_profile_header)
    /** ゲスト — 出演履歴の行のタグ。その公演にゲストで出た */
    val detailShowGuest: DisplayText get() = DisplayText.Res(R.string.idols_detail_show_guest)
    /** 主演 — 出演履歴の行のタグ。その公演の主演 */
    val detailShowLead: DisplayText get() = DisplayText.Res(R.string.idols_detail_show_lead)
    /** タグが似ているアイドル — タグが似ているアイドル (サーバ算出のおすすめ) の節の見出し */
    val detailSimilarHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_similar_header)
    /** {count}回 — ライブ歌唱曲の行に出す、この曲を歌った回数。1000 回以上なら桁区切りが付く — 引数: count (count) */
    fun detailSongPerformCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.idols_detail_song_perform_count, count, listOf(count))
    /** 原曲・所属ユニットの情報はまだ登録されていません。 — Android の文言 (楽曲・ユニットのタブ)。iOS の detail.songs.empty.message と ja が違う */
    val detailSongsEmptyMessageAndroid: DisplayText get() = DisplayText.Res(R.string.idols_detail_songs_empty_message_android)
    /** 楽曲・ユニットがありません — Android の文言 (楽曲・ユニットのタブ)。iOS の detail.songs.empty.title と ja が違う */
    val detailSongsEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.idols_detail_songs_empty_title_android)
    /** コミュニティ — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ) */
    val detailTabCommunity: DisplayText get() = DisplayText.Res(R.string.idols_detail_tab_community)
    /** ライブ — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ) */
    val detailTabLive: DisplayText get() = DisplayText.Res(R.string.idols_detail_tab_live)
    /** プロフィール — 詳細の中のセグメント (ライブ / 楽曲 / プロフィール / コミュニティ) */
    val detailTabProfile: DisplayText get() = DisplayText.Res(R.string.idols_detail_tab_profile)
    /** 楽曲・ユニット — Android の詳細の中のセグメント。iOS の detail.tab.songs と ja が違う (Android はこのタブに所属ユニットも出す) */
    val detailTabSongsAndroid: DisplayText get() = DisplayText.Res(R.string.idols_detail_tab_songs_android)
    /** タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ */
    val detailTagsActionAdd: DisplayText get() = DisplayText.Res(R.string.idols_detail_tags_action_add)
    /** タグはまだありません — タグが 1 つも無いとき */
    val detailTagsEmptyTitle: DisplayText get() = DisplayText.Res(R.string.idols_detail_tags_empty_title)
    /** タグ — コミュニティタグの節の見出し */
    val detailTagsHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_tags_header)
    /** 所属ユニット — 所属ユニットの節の見出し (右に数)。iOS はプロフィールのタブ、Android は楽曲・ユニットのタブ */
    val detailUnitsHeader: DisplayText get() = DisplayText.Res(R.string.idols_detail_units_header)
    /** 曲なしユニット — 持ち歌の無いユニットの折りたたみ見出し (右に数) */
    val detailUnitsWithoutSongs: DisplayText get() = DisplayText.Res(R.string.idols_detail_units_without_songs)
    /** 次の出演 ・ {date} — 次に出演する公演のカードの一行目。date は公演日を「6/21」の形 (月/日の数字) にしたもの — 引数: date (string) */
    fun detailUpcomingLabel(date: String): DisplayText = DisplayText.Res(R.string.idols_detail_upcoming_label, listOf(date))
    /** CV名 — 表示形式の選択肢 (名前を CV = 声優の名前で出す)。iOS は IdolDisplayMode.label (保存値の rawValue とは別)、Android はフィルタシートのセグメント */
    val displayModeCvName: DisplayText get() = DisplayText.Res(R.string.idols_display_mode_cv_name)
    /** アイドル名 — 表示形式の選択肢 (名前をアイドル名で出す)。iOS は IdolDisplayMode.label (保存値の rawValue とは別)、Android はフィルタシートのセグメント */
    val displayModeIdolName: DisplayText get() = DisplayText.Res(R.string.idols_display_mode_idol_name)
    /** 適用 — Android のアイドル一覧のフィルタシート。ボタン。条件を一覧に当てて閉じる */
    val filterActionApply: DisplayText get() = DisplayText.Res(R.string.idols_filter_action_apply)
    /** リセット — Android のアイドル一覧のフィルタシート。ボタン。条件を既定に戻す */
    val filterActionReset: DisplayText get() = DisplayText.Res(R.string.idols_filter_action_reset)
    /** 全て — Android のアイドル一覧のフィルタシート。属性のチップ。属性で絞らない */
    val filterAttributeAll: DisplayText get() = DisplayText.Res(R.string.idols_filter_attribute_all)
    /** 属性 — Android のアイドル一覧のフィルタシート。属性 (キュート/クール/パッション等) の節の見出し。ブランドを 1 つだけ選んだとき出る */
    val filterAttributeHeader: DisplayText get() = DisplayText.Res(R.string.idols_filter_attribute_header)
    /** ブランド — Android のアイドル一覧のフィルタシート。ブランドの節の見出し */
    val filterBrandHeader: DisplayText get() = DisplayText.Res(R.string.idols_filter_brand_header)
    /** 表示形式 — Android のアイドル一覧のフィルタシート。表示形式 (アイドル名 / CV名) の節の見出し */
    val filterDisplayModeHeader: DisplayText get() = DisplayText.Res(R.string.idols_filter_display_mode_header)
    /** お気に入りのみ — Android のアイドル一覧のフィルタシート。スイッチ。お気に入りのアイドルだけ出す */
    val filterMyMarkFavoriteOnly: DisplayText get() = DisplayText.Res(R.string.idols_filter_my_mark_favorite_only)
    /** マイマーク — Android のアイドル一覧のフィルタシート。マイマーク (担当・お気に入り・メモ) の節の見出し */
    val filterMyMarkHeader: DisplayText get() = DisplayText.Res(R.string.idols_filter_my_mark_header)
    /** メモがあるアイドルのみ — Android のアイドル一覧のフィルタシート。スイッチ。メモを書いたアイドルだけ出す */
    val filterMyMarkNoteOnly: DisplayText get() = DisplayText.Res(R.string.idols_filter_my_mark_note_only)
    /** 担当のみ — Android のアイドル一覧のフィルタシート。スイッチ。担当のアイドルだけ出す */
    val filterMyMarkPickOnly: DisplayText get() = DisplayText.Res(R.string.idols_filter_my_mark_pick_only)
    /** アイドル名表示中、CV名を別行で表示する — Android のアイドル一覧のフィルタシート。「CV名を併記」スイッチの説明 */
    val filterShowCvSubtitle: DisplayText get() = DisplayText.Res(R.string.idols_filter_show_cv_subtitle)
    /** CV名を併記 — Android のアイドル一覧のフィルタシート。スイッチの名前。アイドル名の下に CV (声優) 名も出す */
    val filterShowCvTitle: DisplayText get() = DisplayText.Res(R.string.idols_filter_show_cv_title)
    /** ブランドの区切りを外して通しで並べます — Android のアイドル一覧のフィルタシート。公式順以外を選んだときの注記 */
    val filterSortFlatNote: DisplayText get() = DisplayText.Res(R.string.idols_filter_sort_flat_note)
    /** 並び順 — Android のアイドル一覧のフィルタシート。並び順の節の見出し */
    val filterSortHeader: DisplayText get() = DisplayText.Res(R.string.idols_filter_sort_header)
    /** フィルタ — Android のアイドル一覧のフィルタシート。シートの見出し */
    val filterTitle: DisplayText get() = DisplayText.Res(R.string.idols_filter_title)
    /** 追加 — ギャラリーの見出し右の、画像を選んで足すボタン */
    val galleryActionAdd: DisplayText get() = DisplayText.Res(R.string.idols_gallery_action_add)
    /** 削除 — ギャラリーの画像の長押しメニュー。画像を消す */
    val galleryActionDelete: DisplayText get() = DisplayText.Res(R.string.idols_gallery_action_delete)
    /** アイコンにする — ギャラリーの画像の長押しメニュー。その画像をアイコン (先頭) にする。ko は汎用ギャラリーの gallery.action.set_primary_label (既定の呼称で「아이콘 설정」) と長押しの案内 (gallery.idol.long_press_hint の「아이콘 설정」) にそろえる */
    val galleryActionSetPrimary: DisplayText get() = DisplayText.Res(R.string.idols_gallery_action_set_primary)
    /** ギャラリー — 取り込んだ画像のギャラリーの節の見出し (右に枚数) */
    val galleryHeader: DisplayText get() = DisplayText.Res(R.string.idols_gallery_header)
    /** 画像を追加すると、先頭の1枚がアイコンになります。画像はこの端末の中だけに保存され、どこにも送信されません。 — Android の文言。iOS の gallery.idol.empty_hint と ja が違う */
    val galleryIdolEmptyHintAndroid: DisplayText get() = DisplayText.Res(R.string.idols_gallery_idol_empty_hint_android)
    /** 長押しでアイコン設定・ウィジェットのスライドショー対象・削除を切り替えられます。 — Android の文言。iOS の gallery.idol.long_press_hint と ja が違う (Android は削除もここから) */
    val galleryIdolLongPressHintAndroid: DisplayText get() = DisplayText.Res(R.string.idols_gallery_idol_long_press_hint_android)
    /** アイコン — ギャラリーの先頭の画像に付くバッジ (その画像がアイコンになる)。iOS の GallerySectionView では呼称 (entityLabel) の既定値にも使う */
    val galleryPrimaryBadge: DisplayText get() = DisplayText.Res(R.string.idols_gallery_primary_badge)
    /** スライドショーに入れる — ギャラリーの画像の長押しメニュー。ウィジェットのスライドショーに出す */
    val gallerySlideshowAdd: DisplayText get() = DisplayText.Res(R.string.idols_gallery_slideshow_add)
    /** スライドショーから外す — ギャラリーの画像の長押しメニュー。ウィジェットのスライドショーに出さない */
    val gallerySlideshowRemove: DisplayText get() = DisplayText.Res(R.string.idols_gallery_slideshow_remove)
    /** フィルタを解除 — フィルタ (ブランド・属性・表示形式・マイマーク) をまとめて外す。iOS はメニュー項目と空状態のボタン、Android は空状態のボタン */
    val listActionClearFilters: DisplayText get() = DisplayText.Res(R.string.idols_list_action_clear_filters)
    /** フィルタ — 上部バーのフィルタボタンの読み上げ (Android)。iOS は共通のツールバー部品が持つ */
    val listFilterA11y: DisplayText get() = DisplayText.Res(R.string.idols_list_filter_a11y)
    /** 「{query}」に一致するアイドルはいません。 — Android の文言。iOS の list.filter_empty.message と ja が違う (統一はオーナーが別 PR で)。query は利用者が打った語 — 引数: query (string) */
    fun listFilterEmptyMessageAndroid(query: String): DisplayText = DisplayText.Res(R.string.idols_list_filter_empty_message_android, listOf(query))
    /** 見つかりませんでした — Android の文言。iOS の list.filter_empty.title と ja が違う (統一はオーナーが別 PR で) */
    val listFilterEmptyTitleAndroid: DisplayText get() = DisplayText.Res(R.string.idols_list_filter_empty_title_android)
    /** {order}順 ・ {count}人 — 公式順以外で並べたとき (ブランドの区切りを外した通し表示) の見出し。order は並び順の名前 (sort_order.*。ko は「〜순」まで含む)、count は人数。ja は order のあとに「順」を足すので、五十音順では「五十音順順」になる (今の表示のまま。直すのは別 PR)。1000 人以上なら桁区切りが付く (1,000人) — 引数: order (text), count (count) */
    fun listFlatHeader(order: DisplayText, count: Int): DisplayText = DisplayText.Plural(R.plurals.idols_list_flat_header, count, listOf(order, count))
    /** {count}人 — アイドルの人数。iOS は通し並びの見出しの右、Android は誕生月のアイドル一覧の先頭。1000 人以上なら桁区切りが付く (1,000人) — 引数: count (count) */
    fun listIdolCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.idols_list_idol_count, count, listOf(count))
    /** アイドル・CV名で絞り込み — 一覧の先頭の絞り込み欄のプレースホルダ (Android)。アイドル名と CV (声優) 名の両方で絞れる */
    val listNameFilterPrompt: DisplayText get() = DisplayText.Res(R.string.idols_list_name_filter_prompt)
    /** フィルタ条件を変更するか、フィルタを解除してください。 — フィルタで 1 人も残らなかったときの空状態の説明 */
    val listNoMatchMessage: DisplayText get() = DisplayText.Res(R.string.idols_list_no_match_message)
    /** 該当するアイドルがいません — フィルタ (ブランド・属性・マイマーク) で 1 人も残らなかったときの空状態の見出し */
    val listNoMatchTitle: DisplayText get() = DisplayText.Res(R.string.idols_list_no_match_title)
    /** 担当に追加 — 一覧の行のハートボタンの読み上げ (まだ担当でないとき)。Android だけ (iOS は共通部品 MyPickToggleButton) */
    val listRowPickAddA11y: DisplayText get() = DisplayText.Res(R.string.idols_list_row_pick_add_a11y)
    /** 担当解除 — 一覧の行のハートボタンの読み上げ (担当にしているとき)。Android だけ (iOS は共通部品 MyPickToggleButton) */
    val listRowPickRemoveA11y: DisplayText get() = DisplayText.Res(R.string.idols_list_row_pick_remove_a11y)
    /** アイドル — 一覧の上のセグメント (アイドル / ユニット) のアイドル側 */
    val listTabIdols: DisplayText get() = DisplayText.Res(R.string.idols_list_tab_idols)
    /** ユニット — 一覧の上のセグメント (アイドル / ユニット) のユニット側 */
    val listTabUnits: DisplayText get() = DisplayText.Res(R.string.idols_list_tab_units)
    /** アイドル — アイドル一覧の見出し (iOS はナビゲーションタイトル、Android は上部バーでアイドルのタブを選んでいるとき) */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.idols_list_title)
    /** ユニット — Android のアイドル一覧の上部バーの見出し (ユニットのタブを選んでいるとき)。iOS のユニット一覧の見出しは units.list.title */
    val listTitleUnits: DisplayText get() = DisplayText.Res(R.string.idols_list_title_units)
    /** グリッド表示 — 一覧/グリッドの切替 (今はリスト表示で、押すとグリッド表示になる)。iOS はアイドル一覧のメニュー項目と選択画面のボタンの読み上げ、Android は上部バーのボタンの読み上げ */
    val listViewModeGrid: DisplayText get() = DisplayText.Res(R.string.idols_list_view_mode_grid)
    /** リスト表示 — 一覧/グリッドの切替 (今はグリッド表示で、押すとリスト表示になる)。iOS はアイドル一覧のメニュー項目と選択画面のボタンの読み上げ、Android は上部バーのボタンの読み上げ */
    val listViewModeList: DisplayText get() = DisplayText.Res(R.string.idols_list_view_mode_list)
    /**  ・  — 日付・会場・公演名を 1 行に並べるときの区切り (前後の空白込み)。出演履歴・次の出演・披露履歴の行 */
    val metaSeparator: DisplayText get() = DisplayText.Res(R.string.idols_meta_separator)
    /** {idol} による「{song}」の披露記録はありません — 披露履歴が 1 件も無いときの説明。idol はアイドル名、song は曲名 (どちらもデータ。訳さない) — 引数: idol (string), song (string) */
    fun songHistoryEmptyMessage(idol: String, song: String): DisplayText = DisplayText.Res(R.string.idols_song_history_empty_message, listOf(idol, song))
    /** 披露履歴がありません — 披露履歴が 1 件も無いときの見出し */
    val songHistoryEmptyTitle: DisplayText get() = DisplayText.Res(R.string.idols_song_history_empty_title)
    /** 披露履歴 — アイドル × 曲の披露履歴 (この人がこの曲を歌った公演) の節の見出し (右に件数) */
    val songHistoryHeader: DisplayText get() = DisplayText.Res(R.string.idols_song_history_header)
    /** 年齢 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。年齢順 */
    val sortOrderAge: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_age)
    /** 誕生日 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。誕生日 (月日) 順 */
    val sortOrderBirthday: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_birthday)
    /** デビュー日 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。デビュー日 (実装日) 順 */
    val sortOrderDebut: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_debut)
    /** 身長 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。身長順 */
    val sortOrderHeight: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_height)
    /** 五十音順 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。名前の日本語のよみ (かな) の五十音順。ko は「50음순」(「가나다순」はハングルの順と読めるので使わない) */
    val sortOrderNameKana: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_name_kana)
    /** 公式順 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。公式 = ブランドごとの公式の並び */
    val sortOrderOfficial: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_official)
    /** 体重 — アイドル一覧の並び順の名前。表示用で、保存値 (iOS の rawValue・Android の enum 名) とは別。ja は今の表示 (コアの表示名と同じ) のまま。ko は「〜순」まで含める (ja は見出し list.flat_header の側で「順」を足す)。体重順 */
    val sortOrderWeight: DisplayText get() = DisplayText.Res(R.string.idols_sort_order_weight)
    /** マイタグの追加 — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。Android のマイタグの追加 */
    val writeActionAddPersonalTag: DisplayText get() = DisplayText.Res(R.string.idols_write_action_add_personal_tag)
    /** マイタグの削除 — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。Android のマイタグの削除 */
    val writeActionRemovePersonalTag: DisplayText get() = DisplayText.Res(R.string.idols_write_action_remove_personal_tag)
    /** お気に入りの切り替え — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。お気に入りにする/外す */
    val writeActionToggleFavorite: DisplayText get() = DisplayText.Res(R.string.idols_write_action_toggle_favorite)
    /** 担当の切り替え — 端末への書き込みに失敗したときの知らせに入る操作の名前 (LocalWriteFailure の action。知らせの本文は「{action}に失敗しました。…」)。名詞句で訳す。担当にする/外す */
    val writeActionTogglePick: DisplayText get() = DisplayText.Res(R.string.idols_write_action_toggle_pick)
}
