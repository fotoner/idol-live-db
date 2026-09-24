// 生成物: i18n/catalog/songs.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/songs.json の文言。L10n.Songs から引く (iOS の L10n.Songs と同じ名前)。 */
object L10nSongs {
    /** あなたが思うこの曲のペンライト色を投票しませんか？ — ペンライト投票が無いときの誘い文句 */
    val communityPenlightEmptyMessage: DisplayText get() = DisplayText.Res(R.string.songs_community_penlight_empty_message)
    /** まだ投票がありません — ペンライト投票が 1 票も無いとき */
    val communityPenlightEmptyTitle: DisplayText get() = DisplayText.Res(R.string.songs_community_penlight_empty_title)
    /** ペンライト — コミュニティタブの節の見出し。Android の文言。iOS の community.penlight.header_ios と ja が違う */
    val communityPenlightHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.songs_community_penlight_header_android)
    /** 投票する — ペンライト投票の節の見出し右のボタン (iOS) / ＋ ボタンの読み上げ (Android) */
    val communityPenlightVote: DisplayText get() = DisplayText.Res(R.string.songs_community_penlight_vote)
    /** {count}票 — ペンライトの色の組ごとの票数 (iOS) / 節の見出しの右の票の合計 (Android)。1000 以上は桁区切りが付く — 引数: count (count) */
    fun communityPenlightVotes(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_community_penlight_votes, count, listOf(count))
    /** この曲が好きな人にはこれも — タグが似ている曲 (サーバ算出のおすすめ) の節の見出し */
    val communitySimilarHeader: DisplayText get() = DisplayText.Res(R.string.songs_community_similar_header)
    /** タグ{count}個一致 — おすすめの曲の行に出す、共通するタグの数。1000 以上は桁区切りが付く (実際には届かない) — 引数: count (count) */
    fun communitySimilarSharedTags(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_community_similar_shared_tags, count, listOf(count))
    /** タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ */
    val communityTagsAdd: DisplayText get() = DisplayText.Res(R.string.songs_community_tags_add)
    /** タグはまだありません — タグが 1 つも無いとき */
    val communityTagsEmptyTitle: DisplayText get() = DisplayText.Res(R.string.songs_community_tags_empty_title)
    /** タグ — コミュニティタブの節の見出し */
    val communityTagsHeader: DisplayText get() = DisplayText.Res(R.string.songs_community_tags_header)
    /** 参考動画を追加 — 参考動画の ＋ ボタンの読み上げ */
    val communityVideosAddA11y: DisplayText get() = DisplayText.Res(R.string.songs_community_videos_add_a11y)
    /** 投稿者: {name} — 参考動画を投稿した人。name は表示名 — 引数: name (string) */
    fun communityVideosAuthor(name: String): DisplayText = DisplayText.Res(R.string.songs_community_videos_author, listOf(name))
    /** 参考動画を編集 — 参考動画の行の ✎ ボタンの読み上げ */
    val communityVideosEditA11y: DisplayText get() = DisplayText.Res(R.string.songs_community_videos_edit_a11y)
    /** ライブ映像などの参考動画を共有しませんか？ — 参考動画が無いときの誘い文句。Android の文言。iOS の community.videos.empty.message_ios と ja が違う */
    val communityVideosEmptyMessageAndroid: DisplayText get() = DisplayText.Res(R.string.songs_community_videos_empty_message_android)
    /** 参考動画はまだありません — 参考動画が 1 本も無いとき */
    val communityVideosEmptyTitle: DisplayText get() = DisplayText.Res(R.string.songs_community_videos_empty_title)
    /** 参考動画 — コミュニティタブの節の見出し */
    val communityVideosHeader: DisplayText get() = DisplayText.Res(R.string.songs_community_videos_header)
    /** 歌唱者をコピー — 曲の長押しメニュー。歌唱者の表記をコピーする */
    val copyArtists: DisplayText get() = DisplayText.Res(R.string.songs_copy_artists)
    /** 曲名をコピー — 曲の行・曲詳細の曲名を長押ししたときのメニュー */
    val copyTitle: DisplayText get() = DisplayText.Res(R.string.songs_copy_title)
    /** お気に入り — 曲詳細のお気に入りボタン (入っていないとき) */
    val detailFavoriteOff: DisplayText get() = DisplayText.Res(R.string.songs_detail_favorite_off)
    /** お気に入り済み — 曲詳細のお気に入りボタン (お気に入りに入っているとき) */
    val detailFavoriteOn: DisplayText get() = DisplayText.Res(R.string.songs_detail_favorite_on)
    /** KAMISABIカード — 曲詳細の KAMISABI カードの節の見出し */
    val detailKamisabiHeader: DisplayText get() = DisplayText.Res(R.string.songs_detail_kamisabi_header)
    /** カード所持 — KAMISABI のカードを持っているかのスイッチ */
    val detailKamisabiToggle: DisplayText get() = DisplayText.Res(R.string.songs_detail_kamisabi_toggle)
    /** タグ・動画・投票にはログインが必要です。 — 未ログインでタグ・動画・投票をしようとしたときのダイアログの本文 */
    val detailLoginDialog: DisplayText get() = DisplayText.Res(R.string.songs_detail_login_dialog)
    /** タグ・動画・投票にはログインが必要です — コミュニティタブの先頭に出す、未ログインの人への案内 */
    val detailLoginPrompt: DisplayText get() = DisplayText.Res(R.string.songs_detail_login_prompt)
    /** Apple Musicで開く — 曲詳細の … メニュー (Apple Music は固有名詞) */
    val detailMenuAppleMusic: DisplayText get() = DisplayText.Res(R.string.songs_detail_menu_apple_music)
    /** この楽曲を編集 — 曲詳細の … メニュー */
    val detailMenuEdit: DisplayText get() = DisplayText.Res(R.string.songs_detail_menu_edit)
    /** 編集履歴 — 曲詳細の … メニュー */
    val detailMenuEditHistory: DisplayText get() = DisplayText.Res(R.string.songs_detail_menu_edit_history)
    /** 歌詞を見る — 曲詳細の … メニュー。外部の歌詞サイトを開く。Android の文言。iOS の detail.menu.lyrics_site_ios と ja が違う */
    val detailMenuLyricsSiteAndroid: DisplayText get() = DisplayText.Res(R.string.songs_detail_menu_lyrics_site_android)
    /** その他 — 曲詳細の … ボタンの読み上げ */
    val detailMenuMoreA11y: DisplayText get() = DisplayText.Res(R.string.songs_detail_menu_more_a11y)
    /** 再生 — 曲詳細の再生ボタン */
    val detailPlay: DisplayText get() = DisplayText.Res(R.string.songs_detail_play)
    /** 公演 — 統計タイルの数字の単位 (現地回収した公演の数) */
    val detailStatUnitShows: DisplayText get() = DisplayText.Res(R.string.songs_detail_stat_unit_shows)
    /** 回 — 統計タイルの数字の単位 (披露回数など) */
    val detailStatUnitTimes: DisplayText get() = DisplayText.Res(R.string.songs_detail_stat_unit_times)
    /** 停止 — 曲詳細の再生ボタン (再生中) */
    val detailStop: DisplayText get() = DisplayText.Res(R.string.songs_detail_stop)
    /** コミュニティ — 曲詳細のタブ (タグ・参考動画・ペンライト投票) */
    val detailTabCommunity: DisplayText get() = DisplayText.Res(R.string.songs_detail_tab_community)
    /** 披露履歴 — 曲詳細のタブ (ライブで歌われた記録) */
    val detailTabHistory: DisplayText get() = DisplayText.Res(R.string.songs_detail_tab_history)
    /** 情報・歌唱 — 曲詳細のタブ (曲の情報と歌唱アイドル) */
    val detailTabInfo: DisplayText get() = DisplayText.Res(R.string.songs_detail_tab_info)
    /** カード所持の記録 — 端末への保存に失敗したときの知らせに入る操作の名前 (KAMISABI のカード所持) */
    val detailWriteActionCardOwned: DisplayText get() = DisplayText.Res(R.string.songs_detail_write_action_card_owned)
    /** お気に入りの切り替え — 端末への保存に失敗したときの知らせに入る操作の名前 (「{操作}に失敗しました」の {操作}) */
    val detailWriteActionFavorite: DisplayText get() = DisplayText.Res(R.string.songs_detail_write_action_favorite)
    /** 全て — フィルタシートのチップ。絞り込まない (曲タイプ・ブランド・アイドル選択のブランド) */
    val filterAll: DisplayText get() = DisplayText.Res(R.string.songs_filter_all)
    /** 適用 — フィルタシートの条件を一覧に反映するボタン */
    val filterApply: DisplayText get() = DisplayText.Res(R.string.songs_filter_apply)
    /** ブランド — フィルタシートの節の見出し */
    val filterBrandHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_brand_header)
    /** CDシリーズ — フィルタシートの CD シリーズ選択の行・節の見出しと、選択画面のタイトル */
    val filterCdSeriesHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_cd_series_header)
    /** すべて — 現地回収の絞り込みの選択肢。iOS は SongCollectFilter の rawValue (保存値。変えない) を表示に使っていたもの */
    val filterCollectAll: DisplayText get() = DisplayText.Res(R.string.songs_filter_collect_all)
    /** 回収済のみ — 現地回収の絞り込みの選択肢。現地で聴いた曲だけ */
    val filterCollectCollected: DisplayText get() = DisplayText.Res(R.string.songs_filter_collect_collected)
    /** 現地回収 — フィルタシートの節の見出し (現地で聴いたかどうかで絞る) */
    val filterCollectHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_collect_header)
    /** 未回収のみ — 現地回収の絞り込みの選択肢。まだ現地で聴いていない曲だけ */
    val filterCollectUncollected: DisplayText get() = DisplayText.Res(R.string.songs_filter_collect_uncollected)
    /** 作詞 / 作曲 / 編曲者 — フィルタシートの節の見出し (作家の名前で絞る) */
    val filterCreatorHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_creator_header)
    /** 名前を入力 — 作家の名前の入力欄のプレースホルダ */
    val filterCreatorPlaceholder: DisplayText get() = DisplayText.Res(R.string.songs_filter_creator_placeholder)
    /** アイドル — フィルタシートのアイドル選択の行 (iOS は節の見出しとアイドル選択画面のタイトルにも使う) */
    val filterIdolHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_idol_header)
    /** {names} 他{count}人 — 選んだアイドルが 4 人以上のときの表示。names は先頭 2 人の名前 (・ で連結済み)、count は残りの人数 — 引数: names (string), count (count) */
    fun filterIdolSummaryMore(names: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_filter_idol_summary_more, count, listOf(names, count))
    /** 音楽カードゲーム KAMISABI にカードがある曲だけ表示 — KAMISABI のスイッチの説明。Android の文言。iOS の filter.kamisabi.caption_ios と ja が違う */
    val filterKamisabiCaptionAndroid: DisplayText get() = DisplayText.Res(R.string.songs_filter_kamisabi_caption_android)
    /** KAMISABI収録のみ — KAMISABI の絞り込みのスイッチ。Android の文言。iOS の filter.kamisabi.toggle_ios と ja が違う */
    val filterKamisabiToggleAndroid: DisplayText get() = DisplayText.Res(R.string.songs_filter_kamisabi_toggle_android)
    /** アルバム — 表示形式のセグメント。CD 単位のカードで並べる */
    val filterListModeAlbums: DisplayText get() = DisplayText.Res(R.string.songs_filter_list_mode_albums)
    /** 表示形式 — フィルタシートの節の見出し (曲 / アルバム / シリーズ) */
    val filterListModeHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_list_mode_header)
    /** シリーズ — 表示形式のセグメント。シリーズ単位のカードで並べる */
    val filterListModeSeries: DisplayText get() = DisplayText.Res(R.string.songs_filter_list_mode_series)
    /** 楽曲 — 表示形式のセグメント。曲を 1 行ずつ並べる */
    val filterListModeSongs: DisplayText get() = DisplayText.Res(R.string.songs_filter_list_mode_songs)
    /** ライブで絞込 — フィルタシートのライブ選択の行・節の見出し */
    val filterLiveHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_live_header)
    /** ライブ — ライブを選ぶ画面のタイトル */
    val filterLivePickerTitle: DisplayText get() = DisplayText.Res(R.string.songs_filter_live_picker_title)
    /** セトリにしか無い曲(カバー等)を一覧から隠します。既定 ON — ライブ限定曲を隠す のスイッチの説明 */
    val filterLiveOnlyCaption: DisplayText get() = DisplayText.Res(R.string.songs_filter_live_only_caption)
    /** ライブ限定曲を隠す — フィルタシートのスイッチ */
    val filterLiveOnlyTitle: DisplayText get() = DisplayText.Res(R.string.songs_filter_live_only_title)
    /** お気に入りのみ — マイマークの絞り込みのスイッチ */
    val filterMyMarkFavorite: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_favorite)
    /** チェック ON で AND 条件絞り込み — マイマークの節の注記。ON にした条件すべてに当てはまる曲だけ残る */
    val filterMyMarkFooter: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_footer)
    /** マイマーク — フィルタシートの節の見出し (担当・お気に入り・メモで絞る) */
    val filterMyMarkHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_header)
    /** 担当アイドルの曲のみ — マイマークの絞り込みのスイッチ */
    val filterMyMarkMyPick: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_my_pick)
    /** 担当アイドルが歌唱者にいる曲だけ表示 — 担当アイドルの曲のみ のスイッチの説明 */
    val filterMyMarkMyPickCaption: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_my_pick_caption)
    /** メモがある曲のみ — マイマークの絞り込みのスイッチ */
    val filterMyMarkNote: DisplayText get() = DisplayText.Res(R.string.songs_filter_my_mark_note)
    /** 選択なし — シリーズ・CD シリーズ・ライブ・アイドルを選んでいないときの表示 / 選択を外す行 */
    val filterNone: DisplayText get() = DisplayText.Res(R.string.songs_filter_none)
    /** 歌枠で歌っただけのカバー等。既定では隠しています — 「その他」を表示 のスイッチの説明。歌枠 = 歌の配信 */
    val filterOtherBrandCaption: DisplayText get() = DisplayText.Res(R.string.songs_filter_other_brand_caption)
    /** 「その他」を表示 — フィルタシートのスイッチ。「その他」はどのブランドにも属さない曲の分類 */
    val filterOtherBrandTitle: DisplayText get() = DisplayText.Res(R.string.songs_filter_other_brand_title)
    /** フィルタに戻る — 選択ページの ← の読み上げ */
    val filterPickerBackA11y: DisplayText get() = DisplayText.Res(R.string.songs_filter_picker_back_a11y)
    /** 選択をすべて解除 — アイドル選択ページで選択をすべて外す行 */
    val filterPickerClearAll: DisplayText get() = DisplayText.Res(R.string.songs_filter_picker_clear_all)
    /** アイドル名で絞り込み — アイドル選択ページの絞り込み欄のプレースホルダ */
    val filterPickerIdolSearchPrompt: DisplayText get() = DisplayText.Res(R.string.songs_filter_picker_idol_search_prompt)
    /** アイドル ({count}) — アイドル選択ページのタイトル。count は選んだ人数 — 引数: count (count) */
    fun filterPickerIdolsTitle(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_filter_picker_idols_title, count, listOf(count))
    /** {title}で絞り込み — 選択ページの絞り込み欄のプレースホルダ。title はページの名前 (シリーズ / CDシリーズ / ライブ) — 引数: title (text) */
    fun filterPickerSearchPrompt(title: DisplayText): DisplayText = DisplayText.Res(R.string.songs_filter_picker_search_prompt, listOf(title))
    /** アレンジ・リミックス曲を表示 — リミックスを含む のスイッチの説明 */
    val filterRemixCaption: DisplayText get() = DisplayText.Res(R.string.songs_filter_remix_caption)
    /** リミックスを含む — フィルタシートのスイッチ */
    val filterRemixTitle: DisplayText get() = DisplayText.Res(R.string.songs_filter_remix_title)
    /** リセット — フィルタシートの条件をすべて戻すボタン。Android の文言。iOS の filter.reset_ios と ja が違う */
    val filterResetAndroid: DisplayText get() = DisplayText.Res(R.string.songs_filter_reset_android)
    /** シリーズ — フィルタシートのシリーズ選択の行・節の見出しと、選択画面のタイトル */
    val filterSeriesHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_series_header)
    /** 曲タイプ — フィルタシートの節の見出し (ソロ / ユニット / 全体曲。語はコアの vocabulary) */
    val filterSongTypeHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_song_type_header)
    /** 並び順 — フィルタシートの節の見出し */
    val filterSortHeader: DisplayText get() = DisplayText.Res(R.string.songs_filter_sort_header)
    /** フィルター・並び替え — 曲一覧のフィルタシートの見出し */
    val filterTitle: DisplayText get() = DisplayText.Res(R.string.songs_filter_title)
    /** アルバムが見つかりません — 表示形式がアルバムで 1 件も無いとき */
    val gridAlbumsEmpty: DisplayText get() = DisplayText.Res(R.string.songs_grid_albums_empty)
    /** {count}枚 — シリーズのカードの CD の枚数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun gridCdCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_grid_cd_count, count, listOf(count))
    /** シリーズが見つかりません — 表示形式がシリーズで 1 件も無いとき */
    val gridSeriesEmpty: DisplayText get() = DisplayText.Res(R.string.songs_grid_series_empty)
    /** {count}曲 — アルバム・シリーズのカードの曲数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun gridSongCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_grid_song_count, count, listOf(count))
    /** 同じ公演で歌われた曲 — 披露履歴タブの節の見出し */
    val historyCoOccurringHeader: DisplayText get() = DisplayText.Res(R.string.songs_history_co_occurring_header)
    /** 同じ公演に両方あった公演数です (1 公演で 2 回歌っても 1 公演)。次のライブで一緒に来るとは限りません。 — 同じ公演で歌われた曲 の節の注記 */
    val historyCoOccurringNote: DisplayText get() = DisplayText.Res(R.string.songs_history_co_occurring_note)
    /** いっしょに{together}公演 ／ 全{performances}公演 — 同じ公演で歌われた曲の行の副題。together は一緒に歌われた公演数、performances はその曲が歌われた公演数。together は 1000 以上は桁区切りが付く (実際には届かない) — 引数: together (count), performances (int) */
    fun historyCoOccurringRow(together: Int, performances: Int): DisplayText = DisplayText.Plural(R.plurals.songs_history_co_occurring_row, together, listOf(together, performances))
    /** この曲がライブで披露されると、ここに記録されます。 — ライブで一度も歌われていないときの説明 */
    val historyEmptyMessage: DisplayText get() = DisplayText.Res(R.string.songs_history_empty_message)
    /** 披露履歴はまだありません — ライブで一度も歌われていないとき */
    val historyEmptyTitle: DisplayText get() = DisplayText.Res(R.string.songs_history_empty_title)
    /** {count}回 — ライブ披露履歴 の見出しの右の回数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun historyLogCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_history_log_count, count, listOf(count))
    /** ライブ披露履歴 — 披露履歴タブの節の見出し (公演ごとの一覧) */
    val historyLogHeader: DisplayText get() = DisplayText.Res(R.string.songs_history_log_header)
    /** この曲を歌った人 — 披露履歴タブの節の見出し (歌った回数の多い順) */
    val historySingersHeader: DisplayText get() = DisplayText.Res(R.string.songs_history_singers_header)
    /** セトリに残っている歌唱の集計です。分母は上の「総披露」と同じ回数です。 — この曲を歌った人 の節の注記 */
    val historySingersNote: DisplayText get() = DisplayText.Res(R.string.songs_history_singers_note)
    /** {times}回 ／ 全{total}回 — 歌った人の行の副題。times はその人が歌った回数、total は全体の披露回数。times は 1000 以上は桁区切りが付く (実際には届かない) — 引数: times (count), total (int) */
    fun historySingersTimes(times: Int, total: Int): DisplayText = DisplayText.Plural(R.plurals.songs_history_singers_times, times, listOf(times, total))
    /** 初披露 — 統計タイルのラベル。初めて歌われた年月 */
    val historyStatFirst: DisplayText get() = DisplayText.Res(R.string.songs_history_stat_first)
    /** 最終披露 — 統計タイルのラベル。最後に歌われた年月 */
    val historyStatLast: DisplayText get() = DisplayText.Res(R.string.songs_history_stat_last)
    /** 総披露 — 統計タイルのラベル。ライブで歌われた回数の合計 */
    val historyStatTotal: DisplayText get() = DisplayText.Res(R.string.songs_history_stat_total)
    /** ライブ歌唱歴 — 情報タブの節の見出し (ライブで歌ったことがあるアイドル) */
    val infoLiveSingersHeader: DisplayText get() = DisplayText.Res(R.string.songs_info_live_singers_header)
    /** 参加ライブを登録して現地回収 — 参加したライブを登録する導線 (登録すると現地回収に数えられる) */
    val infoRegisterAttendance: DisplayText get() = DisplayText.Res(R.string.songs_info_register_attendance)
    /** 関連楽曲 — 情報タブの節の見出し (同じシリーズ・ユニット・歌唱者の曲) */
    val infoRelatedHeader: DisplayText get() = DisplayText.Res(R.string.songs_info_related_header)
    /** 編曲 — 楽曲情報の行 */
    val infoRowArranger: DisplayText get() = DisplayText.Res(R.string.songs_info_row_arranger)
    /** アーティスト — 楽曲情報の行 */
    val infoRowArtist: DisplayText get() = DisplayText.Res(R.string.songs_info_row_artist)
    /** ブランド — 楽曲情報の行 (アイマスのシリーズ) */
    val infoRowBrand: DisplayText get() = DisplayText.Res(R.string.songs_info_row_brand)
    /** CDシリーズ — 楽曲情報の行 */
    val infoRowCdSeries: DisplayText get() = DisplayText.Res(R.string.songs_info_row_cd_series)
    /** 収録 — 楽曲情報の行。収録されている CD の名前 */
    val infoRowCdTitle: DisplayText get() = DisplayText.Res(R.string.songs_info_row_cd_title)
    /** 作曲 — 楽曲情報の行 */
    val infoRowComposer: DisplayText get() = DisplayText.Res(R.string.songs_info_row_composer)
    /** 再生時間 — 楽曲情報の行 (曲の長さ) */
    val infoRowDuration: DisplayText get() = DisplayText.Res(R.string.songs_info_row_duration)
    /** よみ — 楽曲情報の行。曲名の読み仮名 */
    val infoRowKana: DisplayText get() = DisplayText.Res(R.string.songs_info_row_kana)
    /** 作詞 — 楽曲情報の行 */
    val infoRowLyricist: DisplayText get() = DisplayText.Res(R.string.songs_info_row_lyricist)
    /** リリース日 — 楽曲情報の行 */
    val infoRowReleaseDate: DisplayText get() = DisplayText.Res(R.string.songs_info_row_release_date)
    /** シリーズ — 楽曲情報の行 */
    val infoRowSeries: DisplayText get() = DisplayText.Res(R.string.songs_info_row_series)
    /** タイプ — 楽曲情報の行 (ソロ / ユニット / 全体曲) */
    val infoRowType: DisplayText get() = DisplayText.Res(R.string.songs_info_row_type)
    /** ユニット — 楽曲情報の行 */
    val infoRowUnit: DisplayText get() = DisplayText.Res(R.string.songs_info_row_unit)
    /** 楽曲情報 — 情報タブの節の見出し */
    val infoSectionHeader: DisplayText get() = DisplayText.Res(R.string.songs_info_section_header)
    /** 歌唱アイドル — 情報タブの節の見出し (オリジナルの歌唱メンバー) */
    val infoSingersHeader: DisplayText get() = DisplayText.Res(R.string.songs_info_singers_header)
    /** 現地回収 — 統計タイルのラベル。自分が現地で聴いた公演の数 */
    val infoStatCollected: DisplayText get() = DisplayText.Res(R.string.songs_info_stat_collected)
    /** 披露回数 — 統計タイルのラベル。ライブで歌われた回数 */
    val infoStatPerformances: DisplayText get() = DisplayText.Res(R.string.songs_info_stat_performances)
    /** 曲を追加 — 曲を新しく登録するボタン (iOS はメニューの項目、Android は ＋ の読み上げ) */
    val listActionAdd: DisplayText get() = DisplayText.Res(R.string.songs_list_action_add)
    /** フィルター — フィルタシートを開くボタンの読み上げ */
    val listActionFilterA11y: DisplayText get() = DisplayText.Res(R.string.songs_list_action_filter_a11y)
    /** タグで絞り込み — タグを選んで絞り込むボタン (iOS はメニューの項目、Android はボタンの読み上げ) */
    val listActionTagFilter: DisplayText get() = DisplayText.Res(R.string.songs_list_action_tag_filter)
    /** 現地回収済 — 適用中の絞り込みのチップ。現地で聴いた (回収した) 曲だけ */
    val listChipCollected: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_collected)
    /** お気に入り — 適用中の絞り込みのチップ。お気に入りの曲だけ */
    val listChipFavorite: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_favorite)
    /** アイドル {count}人 — 適用中の絞り込みのチップ。選んだアイドルの人数 — 引数: count (count) */
    fun listChipIdols(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_chip_idols, count, listOf(count))
    /** KAMISABI収録 — 適用中の絞り込みのチップ。音楽カードゲーム KAMISABI に収録された曲だけ (KAMISABI は固有名詞) */
    val listChipKamisabi: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_kamisabi)
    /** 担当 — 適用中の絞り込みのチップ (× で外す)。担当アイドルの曲だけ */
    val listChipMyPick: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_my_pick)
    /** メモあり — 適用中の絞り込みのチップ。メモがある曲だけ */
    val listChipNote: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_note)
    /** {name} {count}曲 — 適用中のタグのチップ (タグ 1 つのとき)。name はタグ名、count はそのタグの曲数。1000 以上は桁区切りが付く — 引数: name (string), count (count) */
    fun listChipTagCount(name: String, count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_chip_tag_count, count, listOf(name, count))
    /** 未回収 — 適用中の絞り込みのチップ。まだ現地で聴いていない曲だけ */
    val listChipUncollected: DisplayText get() = DisplayText.Res(R.string.songs_list_chip_uncollected)
    /** {count}枚 — 表示形式がアルバムのときの件数 (CD の枚数)。1000 以上は桁区切りが付く — 引数: count (count) */
    fun listCountAlbums(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_count_albums, count, listOf(count))
    /** {count}シリーズ — 表示形式がシリーズのときの件数。1000 以上は桁区切りが付く — 引数: count (count) */
    fun listCountSeries(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_count_series, count, listOf(count))
    /** {count}件 — 一覧の上の件数。Android の文言。iOS の list.count.songs_ios と ja が違う。1000 以上は桁区切りが付く (以前の Android は付かなかった) — 引数: count (count) */
    fun listCountSongsAndroid(count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_count_songs_android, count, listOf(count))
    /** フィルタ条件を変更するか、フィルタを解除してください。 — フィルタで 1 曲も残らなかったときの説明 */
    val listEmptyFilterMessage: DisplayText get() = DisplayText.Res(R.string.songs_list_empty_filter_message)
    /** 条件に一致する楽曲がありません — フィルタで 1 曲も残らなかったときの空状態の見出し */
    val listEmptyFilterTitle: DisplayText get() = DisplayText.Res(R.string.songs_list_empty_filter_title)
    /** 「{query}」に一致する楽曲がありません — 検索欄の語で 1 曲も残らなかったときの説明。query は利用者が打った語 — 引数: query (string) */
    fun listEmptySearchMessage(query: String): DisplayText = DisplayText.Res(R.string.songs_list_empty_search_message, listOf(query))
    /** 絞り込み結果がありません — 検索欄の語で 1 曲も残らなかったときの空状態の見出し */
    val listEmptySearchTitle: DisplayText get() = DisplayText.Res(R.string.songs_list_empty_search_title)
    /** もしかして — 打った語に完全には一致しないが近い曲 (あいまい検索の候補) の節の見出し */
    val listFuzzyHeader: DisplayText get() = DisplayText.Res(R.string.songs_list_fuzzy_header)
    /** 楽曲の追加にはログインが必要です。 — 未ログインで曲を追加しようとしたときのダイアログの本文 */
    val listLoginDialog: DisplayText get() = DisplayText.Res(R.string.songs_list_login_dialog)
    /** 習熟度の記録 — 端末への保存に失敗したときの知らせに入る操作の名前 (「{操作}に失敗しました」の {操作})。長押しで習熟度を付けたとき */
    val listMasteryWriteAction: DisplayText get() = DisplayText.Res(R.string.songs_list_mastery_write_action)
    /** アルバム名 — 検索欄の頭のチップ。表示形式がアルバムのとき */
    val listNameFilterAlbums: DisplayText get() = DisplayText.Res(R.string.songs_list_name_filter_albums)
    /** シリーズ名 — 検索欄の頭のチップ。表示形式がシリーズのとき */
    val listNameFilterSeries: DisplayText get() = DisplayText.Res(R.string.songs_list_name_filter_series)
    /** 曲名 — 検索欄の頭のチップ (何で絞るか)。表示形式が曲のとき */
    val listNameFilterSongs: DisplayText get() = DisplayText.Res(R.string.songs_list_name_filter_songs)
    /** 作詞作曲 — 検索対象の切り替え。作詞・作曲・編曲者の名前で探す */
    val listScopeCreator: DisplayText get() = DisplayText.Res(R.string.songs_list_scope_creator)
    /** 歌唱 — 検索対象の切り替え。歌唱したアイドルの名前で探す */
    val listScopePerformer: DisplayText get() = DisplayText.Res(R.string.songs_list_scope_performer)
    /** {scope} {count}件 — 別の検索対象に切り替えると何件当たるかのチップ。scope は検索対象の名前 (list.name_filter.* / list.scope.*)。1000 以上は桁区切りが付く — 引数: scope (text), count (count) */
    fun listScopeSuggestionCount(scope: DisplayText, count: Int): DisplayText = DisplayText.Plural(R.plurals.songs_list_scope_suggestion_count, count, listOf(scope, count))
    /** ほかに — 検索欄の下の行の頭。続けて「歌唱 3件」のような別の検索対象のチップが並ぶ */
    val listScopeSuggestionLead: DisplayText get() = DisplayText.Res(R.string.songs_list_scope_suggestion_lead)
    /** 絞り込み — 曲一覧の検索欄のプレースホルダ (何で絞るかは頭のチップが示すので動詞だけ) */
    val listSearchPrompt: DisplayText get() = DisplayText.Res(R.string.songs_list_search_prompt)
    /** 検索対象を切り替え — 検索対象のチップの ▼ の読み上げ */
    val listSearchModeSwitchA11y: DisplayText get() = DisplayText.Res(R.string.songs_list_search_mode_switch_a11y)
    /** 並び替え — 並び替えメニューの ▼ の読み上げ */
    val listSortMenuA11y: DisplayText get() = DisplayText.Res(R.string.songs_list_sort_menu_a11y)
    /** 選択中 — 並び替えメニューで選ばれている項目のチェックの読み上げ */
    val listSortSelectedA11y: DisplayText get() = DisplayText.Res(R.string.songs_list_sort_selected_a11y)
    /** タグ絞り込みの取得に失敗しました。表示中の一覧にはタグ条件が反映されていません。 — タグで絞り込むための情報を取れなかった (オフライン等) ときのバナー。一覧は絞られていない */
    val listTagFilterError: DisplayText get() = DisplayText.Res(R.string.songs_list_tag_filter_error)
    /** 楽曲 — 曲一覧 (楽曲タブ) のナビゲーションタイトル */
    val listTitle: DisplayText get() = DisplayText.Res(R.string.songs_list_title)
    /** 一時停止 — 再生中バーの ‖ ボタンの読み上げ */
    val nowPlayingPauseA11y: DisplayText get() = DisplayText.Res(R.string.songs_now_playing_pause_a11y)
    /** 再生 — 再生中バーの ▶ ボタンの読み上げ */
    val nowPlayingPlayA11y: DisplayText get() = DisplayText.Res(R.string.songs_now_playing_play_a11y)
    /** 取消 — ペンライト投票シートを閉じるボタン */
    val penlightCancel: DisplayText get() = DisplayText.Res(R.string.songs_penlight_cancel)
    /** ペンライトの色を選んで投票してください。複数選択できます。 — ペンライト投票シートの説明 */
    val penlightInstructions: DisplayText get() = DisplayText.Res(R.string.songs_penlight_instructions)
    /** 投票する — ペンライト投票シートの送信ボタン */
    val penlightSubmit: DisplayText get() = DisplayText.Res(R.string.songs_penlight_submit)
    /** ペンライトカラーを投票 — ペンライト投票シートの見出し */
    val penlightTitle: DisplayText get() = DisplayText.Res(R.string.songs_penlight_title)
    /** 習熟度を変える — 曲の行の長押しメニュー。習熟度の段階を付け替える */
    val rowEditMastery: DisplayText get() = DisplayText.Res(R.string.songs_row_edit_mastery)
    /** 担当 — 曲の行の印。担当アイドルが歌っている曲 */
    val rowMyPick: DisplayText get() = DisplayText.Res(R.string.songs_row_my_pick)
    /** 昇順 — 並びの方向 (小さい順・古い順) */
    val sortAscending: DisplayText get() = DisplayText.Res(R.string.songs_sort_ascending)
    /** 現地回収回数順 — 曲の並び順。自分が現地で聴いた (回収した) 回数の順 */
    val sortCollectedCount: DisplayText get() = DisplayText.Res(R.string.songs_sort_collected_count)
    /** 回収率順 — 曲の並び順。披露回数のうち自分が現地で聴いた割合の順 */
    val sortCollectedRate: DisplayText get() = DisplayText.Res(R.string.songs_sort_collected_rate)
    /** 既定 — フィルタシートの並びの方向で「並び順ごとの既定の向き」を選ぶチップ */
    val sortDefault: DisplayText get() = DisplayText.Res(R.string.songs_sort_default)
    /** 降順 — 並びの方向 (大きい順・新しい順) */
    val sortDescending: DisplayText get() = DisplayText.Res(R.string.songs_sort_descending)
    /** 披露回数順 — 曲の並び順。ライブで歌われた回数の順 */
    val sortPerformanceCount: DisplayText get() = DisplayText.Res(R.string.songs_sort_performance_count)
    /** リリース日順 — 曲の並び順。発売日の順 */
    val sortReleaseDate: DisplayText get() = DisplayText.Res(R.string.songs_sort_release_date)
    /** 五十音順 — 曲の並び順。曲名の読み (日本語の仮名) の順。iOS は SongSortOrder の rawValue (保存値ではない) を表示に使っていたもの */
    val sortTitleKana: DisplayText get() = DisplayText.Res(R.string.songs_sort_title_kana)
}
