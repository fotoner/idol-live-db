// 生成物: i18n/catalog/edit.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/edit.json の文言。L10n.Edit から引く (iOS の L10n.Edit と同じ名前)。 */
object L10nEdit {
    /** キャンセル — 編集フォーム・ピッカー・シートを閉じるボタン (Android は閉じる/戻るアイコンの読み上げにも使う) */
    val actionCancel: DisplayText get() = DisplayText.Res(R.string.edit_action_cancel)
    /** 保存 — 編集フォームの保存ボタン */
    val actionSave: DisplayText get() = DisplayText.Res(R.string.edit_action_save)
    /** 認証の有効期限が切れています。再度サインインしてください。 — 編集の送信で認証が切れていたとき (HTTP 401) */
    val errorAuthExpired: DisplayText get() = DisplayText.Res(R.string.edit_error_auth_expired)
    /** この操作は制限されています。 — 編集の送信で利用停止 (BAN) と返されたとき (HTTP 403) */
    val errorBanned: DisplayText get() = DisplayText.Res(R.string.edit_error_banned)
    /** 投稿が多すぎます。しばらく待ってからお試しください。 — 編集の送信がレート制限に当たったとき (HTTP 429) */
    val errorRateLimited: DisplayText get() = DisplayText.Res(R.string.edit_error_rate_limited)
    /** 保存に失敗しました ({status}) — 編集の送信でサーバがエラーを返したとき。status は HTTP の状態コード — 引数: status (int) */
    fun errorServer(status: Int): DisplayText = DisplayText.Res(R.string.edit_error_server, listOf(status))
    /** 通信に失敗しました: {detail} — 編集の送信が通信エラーで失敗したとき。detail は通信ライブラリの説明 (訳さない) — 引数: detail (string) */
    fun errorTransport(detail: String): DisplayText = DisplayText.Res(R.string.edit_error_transport, listOf(detail))
    /** 合同ブランドはブランド ID をカンマ区切りで (例: 315,283)。 — ライブの編集フォームの基本情報の節の下の説明 */
    val eventBasicFooter: DisplayText get() = DisplayText.Res(R.string.edit_event_basic_footer)
    /** イベント名を入力してください — ライブの編集フォームで名前を空のまま保存しようとしたとき */
    val eventErrorNameRequired: DisplayText get() = DisplayText.Res(R.string.edit_event_error_name_required)
    /** 合同ブランド (カンマ区切り) — ライブの編集フォームの合同ブランド (ブランド ID をカンマで並べる) の入力欄 */
    val eventFieldJointBrands: DisplayText get() = DisplayText.Res(R.string.edit_event_field_joint_brands)
    /** 種別 — ライブの編集フォームの種別 (ライブ・フェス・リリイベ…) の選択欄 */
    val eventFieldKind: DisplayText get() = DisplayText.Res(R.string.edit_event_field_kind)
    /** イベント名 — ライブの編集フォームの名前の入力欄 */
    val eventFieldName: DisplayText get() = DisplayText.Res(R.string.edit_event_field_name)
    /** 変更しない ({raw}) — 種別の選択肢。アプリが知らない種別のイベントを直すとき、元の値のまま送り返す。raw は元の種別の生の値 (訳さない) — 引数: raw (string) */
    fun eventKindUnchanged(raw: String): DisplayText = DisplayText.Res(R.string.edit_event_kind_unchanged, listOf(raw))
    /** チケット — ライブの編集フォームのチケットの日程の節の見出し */
    val eventSectionTicket: DisplayText get() = DisplayText.Res(R.string.edit_event_section_ticket)
    /** ライブを追加 — ライブの新規作成フォームの見出し (Android の文言。iOS は create_ios) */
    val eventTitleCreateAndroid: DisplayText get() = DisplayText.Res(R.string.edit_event_title_create_android)
    /** ライブ編集 — ライブの編集フォームの見出し (Android の文言。iOS は edit_ios) */
    val eventTitleEditAndroid: DisplayText get() = DisplayText.Res(R.string.edit_event_title_edit_android)
    /** 名無しのプロデューサー — 最近の編集で、編集者の表示名が無い・メールアドレスの形のときに代わりに出す名前。最近の編集 (edit_feed) の画面と iOS の EditFeedService もこのキーを使う (同じ文言の別キーを作らない)。iOS から引くようになったら platforms を外す */
    val feedEditorAnonymous: DisplayText get() = DisplayText.Res(R.string.edit_feed_editor_anonymous)
    /** 保存に失敗しました (ID 未確定) — 管理者の即時反映でサーバが確定 ID を返さなかったとき (ライブ・公演・マスタ編集) */
    val formErrorIdUnresolved: DisplayText get() = DisplayText.Res(R.string.edit_form_error_id_unresolved)
    /** 保存失敗: {detail} — 編集フォームの保存が例外で失敗したとき。detail は OS / 通信ライブラリが返すエラーの説明 (訳さない) — 引数: detail (string) */
    fun formErrorSaveFailed(detail: String): DisplayText = DisplayText.Res(R.string.edit_form_error_save_failed, listOf(detail))
    /** エラー — 編集フォームで保存・検証に失敗したときのダイアログの見出し */
    val formErrorTitle: DisplayText get() = DisplayText.Res(R.string.edit_form_error_title)
    /** ブランド — 編集フォームのブランドの選択欄 (ライブ・曲・アイドル) */
    val formFieldBrand: DisplayText get() = DisplayText.Res(R.string.edit_form_field_brand)
    /** 未指定 — 選択欄の「選ばない」選択肢 (ブランド・公演の出演形態) */
    val formOptionUnspecified: DisplayText get() = DisplayText.Res(R.string.edit_form_option_unspecified)
    /** 保存中… — 編集フォームで保存を送っている間の全面オーバーレイ */
    val formSaving: DisplayText get() = DisplayText.Res(R.string.edit_form_saving)
    /** 基本情報 — ライブ・公演・曲の編集フォームの最初の節の見出し */
    val formSectionBasic: DisplayText get() = DisplayText.Res(R.string.edit_form_section_basic)
    /** 並び順: {value} — マスタ (アイドル・公演) の並び順 (sortOrder) を ± で変える行 (Android)。value は並び順の番号で、以前の Android と同じく桁区切りしない (1001)。iOS は桁区切りするので form.sort_order_ios に分けた — 引数: value (int) */
    fun formSortOrderAndroid(value: Int): DisplayText = DisplayText.Res(R.string.edit_form_sort_order_android, listOf(value))
    /** 別名 (カンマ区切り) — アイドルの編集フォームの別名の入力欄 */
    val idolFieldAliases: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_aliases)
    /** 属性 (cute/cool/passion 等) — アイドルの編集フォームの属性の入力欄。例の値 (cute/cool/passion) は入力する値なので訳さない */
    val idolFieldAttribute: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_attribute)
    /** 誕生日 (MM-DD) — アイドルの編集フォームの誕生日の入力欄 */
    val idolFieldBirthday: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_birthday)
    /** 出身地 — アイドルの編集フォームの出身地の入力欄 */
    val idolFieldBirthplace: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_birthplace)
    /** 血液型 — アイドルの編集フォームの血液型の入力欄 */
    val idolFieldBloodType: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_blood_type)
    /** カラー (#hex) — アイドルの編集フォームのイメージカラーの入力欄 */
    val idolFieldColor: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_color)
    /** 実装日 (YYYY-MM-DD) — アイドルの編集フォームの実装日 (ゲームに登場した日) の入力欄 */
    val idolFieldDebutDate: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_debut_date)
    /** カナ — アイドルの編集フォームの名前の読み (カタカナ) の入力欄 */
    val idolFieldKana: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_kana)
    /** 名前 — アイドルの編集フォームの名前の入力欄 */
    val idolFieldName: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_name)
    /** ローマ字 — アイドルの編集フォームの名前のローマ字の入力欄 */
    val idolFieldRomaji: DisplayText get() = DisplayText.Res(R.string.edit_idol_field_romaji)
    /** カラーは #RRGGBB。# を省いても保存時に補います。 — アイドルの編集フォームのプロフィールの節の下の説明 */
    val idolProfileFooter: DisplayText get() = DisplayText.Res(R.string.edit_idol_profile_footer)
    /** 分類 — アイドルの編集フォームの分類 (ブランド・属性・並び順) の節の見出し */
    val idolSectionCategory: DisplayText get() = DisplayText.Res(R.string.edit_idol_section_category)
    /** 名前 — アイドルの編集フォームの名前の節の見出し */
    val idolSectionName: DisplayText get() = DisplayText.Res(R.string.edit_idol_section_name)
    /** プロフィール — アイドルの編集フォームのプロフィールの節の見出し */
    val idolSectionProfile: DisplayText get() = DisplayText.Res(R.string.edit_idol_section_profile)
    /** アイドル編集 — アイドルの編集フォームの見出し */
    val idolTitle: DisplayText get() = DisplayText.Res(R.string.edit_idol_title)
    /** 決定 — アイドルを複数選ぶシートの確定ボタン */
    val idolPickerActionConfirm: DisplayText get() = DisplayText.Res(R.string.edit_idol_picker_action_confirm)
    /** {title} ({count}) — アイドルを複数選ぶシートの見出し。title は用途 (出演者を選択・歌唱アイドル)、count は選んだ人数 (桁区切りしない) — 引数: title (text), count (int) */
    fun idolPickerHeader(title: DisplayText, count: Int): DisplayText = DisplayText.Res(R.string.edit_idol_picker_header, listOf(title, count))
    /** アイドル名で検索 — アイドルを複数選ぶシートの検索欄のプレースホルダ */
    val idolPickerSearchPrompt: DisplayText get() = DisplayText.Res(R.string.edit_idol_picker_search_prompt)
    /** 出演者を選択 — セトリの 1 行の出演者を選ぶシートの見出し (既定) */
    val idolPickerTitle: DisplayText get() = DisplayText.Res(R.string.edit_idol_picker_title)
    /** クリア — ピッカーの検索欄の × ボタンの読み上げ */
    val pickerClearA11y: DisplayText get() = DisplayText.Res(R.string.edit_picker_clear_a11y)
    /** 見つかりません — ライブ・公演・曲を選ぶピッカーで、検索に一致するものが無いときの空状態の見出し */
    val pickerEmptyTitle: DisplayText get() = DisplayText.Res(R.string.edit_picker_empty_title)
    /** この編集はすぐには反映されず、承認後に反映されます。 — 修正リクエストを送ったときのダイアログの本文 */
    val requestSentMessage: DisplayText get() = DisplayText.Res(R.string.edit_request_sent_message)
    /** 進捗を見る — 修正リクエストの進み具合 (GitHub の issue) を開くリンク */
    val requestSentProgress: DisplayText get() = DisplayText.Res(R.string.edit_request_sent_progress)
    /** 編集リクエストを送信しました — 一般ユーザーの編集が修正リクエスト (承認待ち) になったときのダイアログの見出し。iOS は別の部品 (EditRequestAlert) が出す */
    val requestSentTitle: DisplayText get() = DisplayText.Res(R.string.edit_request_sent_title)
    /** 曲を追加 — セトリの末尾に行を足すボタン */
    val setlistActionAddSong: DisplayText get() = DisplayText.Res(R.string.edit_setlist_action_add_song)
    /** 削除する — セトリ全削除の確認で削除を実行するボタン */
    val setlistClearConfirm: DisplayText get() = DisplayText.Res(R.string.edit_setlist_clear_confirm)
    /** この公演のセトリ {count} 件をすべて削除します。この操作は取り消せません。 — セトリ全削除の確認の本文 (Android の文言。iOS は message_ios)。count は消える行の数 (1000 以上なら桁区切りが付くが、セトリの行数なので実際には出ない) — 引数: count (count) */
    fun setlistClearMessageAndroid(count: Int): DisplayText = DisplayText.Plural(R.plurals.edit_setlist_clear_message_android, count, listOf(count))
    /** セトリを全削除しますか? — 既存のセトリを 0 行にして保存しようとしたときの確認の見出し */
    val setlistClearTitle: DisplayText get() = DisplayText.Res(R.string.edit_setlist_clear_title)
    /** セトリ読み込み失敗: {detail} — セトリの編集画面で今のセトリを読めなかったとき。detail はエラーの説明 (訳さない) — 引数: detail (string) */
    fun setlistErrorLoadFailed(detail: String): DisplayText = DisplayText.Res(R.string.edit_setlist_error_load_failed, listOf(detail))
    /** 曲が未選択の行があります — 曲を選んでいない行があるまま保存しようとしたとき */
    val setlistErrorSongMissing: DisplayText get() = DisplayText.Res(R.string.edit_setlist_error_song_missing)
    /** {event} ・ {show} — セトリの編集画面の上に出す対象。event はイベント名、show は公演名 — 引数: event (string), show (string) */
    fun setlistHeaderEventShow(event: String, show: String): DisplayText = DisplayText.Res(R.string.edit_setlist_header_event_show, listOf(event, show))
    /** 下へ — セトリの行を 1 つ下へ動かすボタンの読み上げ */
    val setlistRowMoveDownA11y: DisplayText get() = DisplayText.Res(R.string.edit_setlist_row_move_down_a11y)
    /** 上へ — セトリの行を 1 つ上へ動かすボタンの読み上げ */
    val setlistRowMoveUpA11y: DisplayText get() = DisplayText.Res(R.string.edit_setlist_row_move_up_a11y)
    /** (出演者なし — タップで追加) — セトリの行で出演者を 1 人も選んでいないときの表示 (押すと出演者を選ぶ) */
    val setlistRowNoCast: DisplayText get() = DisplayText.Res(R.string.edit_setlist_row_no_cast)
    /** 削除 — セトリの行を消すボタンの読み上げ */
    val setlistRowRemoveA11y: DisplayText get() = DisplayText.Res(R.string.edit_setlist_row_remove_a11y)
    /** (曲を選択) — セトリの行で、まだ曲を選んでいないときの表示 */
    val setlistRowSongPlaceholder: DisplayText get() = DisplayText.Res(R.string.edit_setlist_row_song_placeholder)
    /** ダブルアンコール — セトリの行の区分の選択肢: ダブルアンコール */
    val setlistSectionDoubleEncore: DisplayText get() = DisplayText.Res(R.string.edit_setlist_section_double_encore)
    /** アンコール — セトリの行の区分の選択肢: アンコール */
    val setlistSectionEncore: DisplayText get() = DisplayText.Res(R.string.edit_setlist_section_encore)
    /** 本編 — セトリの行の区分の選択肢: 本編 (区分なし) */
    val setlistSectionMain: DisplayText get() = DisplayText.Res(R.string.edit_setlist_section_main)
    /** MC — セトリの行の区分の選択肢: MC (トーク) */
    val setlistSectionMc: DisplayText get() = DisplayText.Res(R.string.edit_setlist_section_mc)
    /** セトリ編集 — セトリの編集画面の見出し */
    val setlistTitle: DisplayText get() = DisplayText.Res(R.string.edit_setlist_title)
    /** 日付は YYYY-MM-DD 形式で入力してください — 公演の編集フォームで日付の形が正しくないとき */
    val showErrorDateFormat: DisplayText get() = DisplayText.Res(R.string.edit_show_error_date_format)
    /** 公演名と日付は必須です — 公演の編集フォームで名前か日付が空のまま保存しようとしたとき */
    val showErrorRequired: DisplayText get() = DisplayText.Res(R.string.edit_show_error_required)
    /** 日付 (YYYY-MM-DD) — 公演の編集フォームの公演日の入力欄 */
    val showFieldDate: DisplayText get() = DisplayText.Res(R.string.edit_show_field_date)
    /** 公演名 — 公演の編集フォームの名前の入力欄 */
    val showFieldName: DisplayText get() = DisplayText.Res(R.string.edit_show_field_name)
    /** 出演形態 — 公演の編集フォームの出演形態 (character / cast / mixed。選択肢の値は訳さない) の選択欄 */
    val showFieldPerformerType: DisplayText get() = DisplayText.Res(R.string.edit_show_field_performer_type)
    /** 開演時刻 (HH:mm) — 公演の編集フォームの開演時刻の入力欄 */
    val showFieldStartTime: DisplayText get() = DisplayText.Res(R.string.edit_show_field_start_time)
    /** 会場 — 公演の編集フォームの会場名の入力欄 */
    val showFieldVenue: DisplayText get() = DisplayText.Res(R.string.edit_show_field_venue)
    /** 会場所在地 — 公演の編集フォームの会場の所在地 (都市) の入力欄 */
    val showFieldVenueCity: DisplayText get() = DisplayText.Res(R.string.edit_show_field_venue_city)
    /** 公演を追加 — 公演の新規作成フォームの見出し (Android の文言。iOS は create_ios) */
    val showTitleCreateAndroid: DisplayText get() = DisplayText.Res(R.string.edit_show_title_create_android)
    /** 公演編集 — 公演の編集フォームの見出し */
    val showTitleEdit: DisplayText get() = DisplayText.Res(R.string.edit_show_title_edit)
    /** 「{query}」に一致する公演がありません — 公演のピッカーで検索に一致するものが無いとき。query は入力した検索語 — 引数: query (string) */
    fun showPickerEmptyNoMatch(query: String): DisplayText = DisplayText.Res(R.string.edit_show_picker_empty_no_match, listOf(query))
    /** 最近の公演がここに表示されます — 公演のピッカーで、未入力なのに結果が無いときの説明 */
    val showPickerEmptyRecent: DisplayText get() = DisplayText.Res(R.string.edit_show_picker_empty_recent)
    /** {name} ・ {date} — 公演のピッカーの行の 2 行目。name は公演名、date は公演日 (YYYY-MM-DD。書式済み) — 引数: name (string), date (string) */
    fun showPickerRowSubtitle(name: String, date: String): DisplayText = DisplayText.Res(R.string.edit_show_picker_row_subtitle, listOf(name, date))
    /** 公演名・イベント名で検索 — 公演のピッカーの検索欄のプレースホルダ */
    val showPickerSearchPrompt: DisplayText get() = DisplayText.Res(R.string.edit_show_picker_search_prompt)
    /** 公演を選択 — 公演を 1 つ選ぶピッカーの見出し */
    val showPickerTitle: DisplayText get() = DisplayText.Res(R.string.edit_show_picker_title)
    /** Apple Music 関連を全て空にする — 曲の編集フォームで Apple Music の ID・ジャケ写・試聴の URL をまとめて消すボタン */
    val songAppleMusicClear: DisplayText get() = DisplayText.Res(R.string.edit_song_apple_music_clear)
    /** 誤紐付けで他の曲が再生されるときに使う。サブスク未配信の曲はクリアすべき。 — Apple Music の項目を空にするボタンの下の説明 (サブスク = 定額の配信サービス) */
    val songAppleMusicClearFooter: DisplayText get() = DisplayText.Res(R.string.edit_song_apple_music_clear_footer)
    /** 誤紐付けの修正 — 曲の編集フォームの Apple Music の項目を空にする節の見出し */
    val songAppleMusicFixHeader: DisplayText get() = DisplayText.Res(R.string.edit_song_apple_music_fix_header)
    /** 一覧でアイコンを出すために必要です。ソロ曲なら 1 名、ユニット曲なら全員を選んでください。 — 歌唱アイドルの節の下の説明 */
    val songArtistsFooter: DisplayText get() = DisplayText.Res(R.string.edit_song_artists_footer)
    /** 歌唱アイドル ({count}) — 歌唱アイドルを選ぶ行のラベル。count は選んだ人数 (桁区切りしない) — 引数: count (int) */
    fun songArtistsLabelCount(count: Int): DisplayText = DisplayText.Res(R.string.edit_song_artists_label_count, listOf(count))
    /** 歌唱アイドルを選択 — 歌唱アイドルをまだ選んでいないときの表示 (押すと選ぶ画面) */
    val songArtistsPlaceholder: DisplayText get() = DisplayText.Res(R.string.edit_song_artists_placeholder)
    /** 歌唱アイドル — 曲の新規作成で歌うアイドル (オリジナルメンバー) を選ぶ節の見出しと、アイドルを選ぶ画面の見出し */
    val songArtistsTitle: DisplayText get() = DisplayText.Res(R.string.edit_song_artists_title)
    /** 歌唱アイドルを 1 名以上選択してください — 曲の新規作成で歌唱アイドルを選ばずに保存しようとしたとき */
    val songErrorArtistsRequired: DisplayText get() = DisplayText.Res(R.string.edit_song_error_artists_required)
    /** Apple Music ID を設定する場合は artwork URL も必須です (一覧のジャケ写表示に使います) — Apple Music の ID だけ入れてジャケ写の URL が空のまま保存しようとしたとき */
    val songErrorArtworkRequired: DisplayText get() = DisplayText.Res(R.string.edit_song_error_artwork_required)
    /** 再生時間は秒数 (整数) で入力してください — 曲の編集フォームで再生時間が数でないとき */
    val songErrorDurationFormat: DisplayText get() = DisplayText.Res(R.string.edit_song_error_duration_format)
    /** リリース日は YYYY-MM-DD 形式で入力してください — 曲の編集フォームでリリース日の形が正しくないとき */
    val songErrorReleaseDateFormat: DisplayText get() = DisplayText.Res(R.string.edit_song_error_release_date_format)
    /** タイトルを入力してください — 曲の編集フォームで曲名を空のまま保存しようとしたとき */
    val songErrorTitleRequired: DisplayText get() = DisplayText.Res(R.string.edit_song_error_title_required)
    /** 編曲 — 曲の編集フォームの編曲者の入力欄 */
    val songFieldArranger: DisplayText get() = DisplayText.Res(R.string.edit_song_field_arranger)
    /** 作曲 — 曲の編集フォームの作曲者の入力欄 */
    val songFieldComposer: DisplayText get() = DisplayText.Res(R.string.edit_song_field_composer)
    /** 再生時間 (秒) — 曲の編集フォームの再生時間 (秒数) の入力欄 */
    val songFieldDuration: DisplayText get() = DisplayText.Res(R.string.edit_song_field_duration)
    /** 作詞 — 曲の編集フォームの作詞者の入力欄 */
    val songFieldLyricist: DisplayText get() = DisplayText.Res(R.string.edit_song_field_lyricist)
    /** 歌詞 URL — 曲の編集フォームの歌詞ページの URL の入力欄 */
    val songFieldLyricsUrl: DisplayText get() = DisplayText.Res(R.string.edit_song_field_lyrics_url)
    /** リリース日 (YYYY-MM-DD) — 曲の編集フォームのリリース日の入力欄 */
    val songFieldReleaseDate: DisplayText get() = DisplayText.Res(R.string.edit_song_field_release_date)
    /** 歌唱表記 (例: 春香・千早) — 曲の編集フォームの歌唱者の表記の入力欄。例はマスタに入る書き方そのもの (アイドル名と区切りの ・) なので訳さない */
    val songFieldSingerLabel: DisplayText get() = DisplayText.Res(R.string.edit_song_field_singer_label)
    /** タイトル — 曲の編集フォームの曲名の入力欄 */
    val songFieldTitle: DisplayText get() = DisplayText.Res(R.string.edit_song_field_title)
    /** タイトル (カナ) — 曲の編集フォームの曲名の読みの入力欄 */
    val songFieldTitleKana: DisplayText get() = DisplayText.Res(R.string.edit_song_field_title_kana)
    /** 種別 — 曲の編集フォームの曲種別 (ソロ・ユニット…。語はコアの語彙) の選択欄 */
    val songFieldType: DisplayText get() = DisplayText.Res(R.string.edit_song_field_type)
    /** ユニット名 — 曲の編集フォームのユニット名の入力欄 */
    val songFieldUnitName: DisplayText get() = DisplayText.Res(R.string.edit_song_field_unit_name)
    /** 保存すると、この編集は「最近の編集」に記録されます。 — 曲の編集フォームの最後の注意書き。「最近の編集」は編集の一覧画面の名前 */
    val songSaveNotice: DisplayText get() = DisplayText.Res(R.string.edit_song_save_notice)
    /** CD / その他 — 曲の編集フォームの CD・ISRC・歌詞 URL の節の見出し */
    val songSectionCdOther: DisplayText get() = DisplayText.Res(R.string.edit_song_section_cd_other)
    /** 制作情報 — 曲の編集フォームの作家・リリースの節の見出し */
    val songSectionCredits: DisplayText get() = DisplayText.Res(R.string.edit_song_section_credits)
    /** 曲を追加 — 曲の新規作成フォームの見出し */
    val songTitleCreate: DisplayText get() = DisplayText.Res(R.string.edit_song_title_create)
    /** 曲編集 — 曲の編集フォームの見出し */
    val songTitleEdit: DisplayText get() = DisplayText.Res(R.string.edit_song_title_edit)
    /** 「{query}」に一致する楽曲がありません — 曲のピッカーで検索に一致するものが無いとき。query は入力した検索語 — 引数: query (string) */
    fun songPickerEmptyNoMatch(query: String): DisplayText = DisplayText.Res(R.string.edit_song_picker_empty_no_match, listOf(query))
    /** 曲名で検索 — 曲のピッカーの検索欄のプレースホルダ */
    val songPickerSearchPrompt: DisplayText get() = DisplayText.Res(R.string.edit_song_picker_search_prompt)
    /** 曲を選択 — セトリの 1 行に曲を 1 つ選ぶピッカーの見出し */
    val songPickerSelectTitle: DisplayText get() = DisplayText.Res(R.string.edit_song_picker_select_title)
    /** 保存に失敗しました: {detail} — 参考動画の保存が例外で失敗したとき。detail はエラーの説明 (訳さない) — 引数: detail (string) */
    fun videoErrorSaveFailed(detail: String): DisplayText = DisplayText.Res(R.string.edit_video_error_save_failed, listOf(detail))
    /** メモ (任意) — 参考動画のフォームのメモの入力欄 (省略できる) */
    val videoFieldNote: DisplayText get() = DisplayText.Res(R.string.edit_video_field_note)
    /** 動画タイトル (任意) — 参考動画のフォームの動画タイトルの入力欄 (省略できる) */
    val videoFieldTitle: DisplayText get() = DisplayText.Res(R.string.edit_video_field_title)
    /** どの公演の映像かなどの補足。メモ {length}/{max} 文字 — 参考動画のシートのメモの入力欄の下の説明と文字数 (Android)。length は今の文字数、max は上限 (1000)。以前の Android と同じく両方とも桁区切りしない (1000)。iOS は桁区切りするので video.note.footer_ios に分けた — 引数: length (int), max (int) */
    fun videoNoteFooterAndroid(length: Int, max: Int): DisplayText = DisplayText.Res(R.string.edit_video_note_footer_android, listOf(length, max))
    /** 参考動画を投稿 — 参考動画の投稿フォームの見出し */
    val videoTitleCreate: DisplayText get() = DisplayText.Res(R.string.edit_video_title_create)
    /** 参考動画を編集 — 参考動画の編集フォームの見出し */
    val videoTitleEdit: DisplayText get() = DisplayText.Res(R.string.edit_video_title_edit)
    /** YouTube の watch / youtu.be / shorts / embed URL に対応。 — 参考動画の URL の入力欄の下の説明。watch などは URL の形の名前なので訳さない */
    val videoUrlFooter: DisplayText get() = DisplayText.Res(R.string.edit_video_url_footer)
}
