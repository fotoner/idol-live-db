// 生成物: i18n/catalog/edit.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/edit.json の文言 (表 Edit)
    enum Edit {
        /// キャンセル — 編集フォーム・ピッカー・シートを閉じるボタン (Android は閉じる/戻るアイコンの読み上げにも使う)
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("edit.action.cancel", defaultValue: "キャンセル", table: "Edit", bundle: L10n.bundle)
        }
        /// 保存 — 編集フォームの保存ボタン
        static var actionSave: LocalizedStringResource {
            LocalizedStringResource("edit.action.save", defaultValue: "保存", table: "Edit", bundle: L10n.bundle)
        }
        /// 認証の有効期限が切れています。再度サインインしてください。 — 編集の送信で認証が切れていたとき (HTTP 401)
        static var errorAuthExpired: LocalizedStringResource {
            LocalizedStringResource("edit.error.auth_expired", defaultValue: "認証の有効期限が切れています。再度サインインしてください。", table: "Edit", bundle: L10n.bundle)
        }
        /// 投稿が多すぎます。しばらく待ってからお試しください。 — 編集の送信がレート制限に当たったとき (HTTP 429)
        static var errorRateLimited: LocalizedStringResource {
            LocalizedStringResource("edit.error.rate_limited", defaultValue: "投稿が多すぎます。しばらく待ってからお試しください。", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント名を入力してください — ライブの編集フォームで名前を空のまま保存しようとしたとき
        static var eventErrorNameRequired: LocalizedStringResource {
            LocalizedStringResource("edit.event.error.name_required", defaultValue: "イベント名を入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 合同ブランド (カンマ区切り) — ライブの編集フォームの合同ブランド (ブランド ID をカンマで並べる) の入力欄
        static var eventFieldJointBrands: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.joint_brands", defaultValue: "合同ブランド (カンマ区切り)", table: "Edit", bundle: L10n.bundle)
        }
        /// 種別 — ライブの編集フォームの種別 (ライブ・フェス・リリイベ…) の選択欄
        static var eventFieldKind: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.kind", defaultValue: "種別", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント名 — ライブの編集フォームの名前の入力欄
        static var eventFieldName: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.name", defaultValue: "イベント名", table: "Edit", bundle: L10n.bundle)
        }
        /// 先行締切 (YYYY-MM-DD) — チケットの先行受付の締切日の入力欄 (Android はコアの語彙「申込締切」から作る)
        static var eventFieldTicketDeadline: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.ticket_deadline", defaultValue: "先行締切 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 当落発表 (YYYY-MM-DD) — チケットの当落発表日の入力欄 (Android はコアの語彙から作る)
        static var eventFieldTicketLottery: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.ticket_lottery", defaultValue: "当落発表 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 受付開始 (YYYY-MM-DD) — チケットの受付開始日の入力欄 (Android はコアの語彙から作る)
        static var eventFieldTicketOpen: LocalizedStringResource {
            LocalizedStringResource("edit.event.field.ticket_open", defaultValue: "受付開始 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 変更しない ({raw}) — 種別の選択肢。アプリが知らない種別のイベントを直すとき、元の値のまま送り返す。raw は元の種別の生の値 (訳さない) — 引数: raw (string)
        static func eventKindUnchanged(raw: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.event.kind.unchanged", defaultValue: "変更しない (\(raw))", table: "Edit", bundle: L10n.bundle)
        }
        /// チケット — ライブの編集フォームのチケットの日程の節の見出し
        static var eventSectionTicket: LocalizedStringResource {
            LocalizedStringResource("edit.event.section.ticket", defaultValue: "チケット", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント追加 — ライブ (イベント) の新規作成フォームの見出し (iOS の文言。Android は create_android)
        static var eventTitleCreateIos: LocalizedStringResource {
            LocalizedStringResource("edit.event.title.create_ios", defaultValue: "イベント追加", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント編集 — ライブ (イベント) の編集フォームの見出し (iOS の文言。Android は edit_android)
        static var eventTitleEditIos: LocalizedStringResource {
            LocalizedStringResource("edit.event.title.edit_ios", defaultValue: "イベント編集", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント名を入力して検索してください — イベントのピッカーを開いた直後 (未入力) の空状態の説明
        static var eventPickerEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("edit.event_picker.empty.message", defaultValue: "イベント名を入力して検索してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するイベントがありません — イベントのピッカーで検索に一致するものが無いとき。query は入力した検索語 — 引数: query (string)
        static func eventPickerEmptyNoMatch(query: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.event_picker.empty.no_match", defaultValue: "「\(query)」に一致するイベントがありません", table: "Edit", bundle: L10n.bundle)
        }
        /// イベントを検索 — イベントのピッカーを開いた直後 (未入力) の空状態の見出し
        static var eventPickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("edit.event_picker.empty.title", defaultValue: "イベントを検索", table: "Edit", bundle: L10n.bundle)
        }
        /// イベント名で検索 — イベントのピッカーの検索欄のプレースホルダ
        static var eventPickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("edit.event_picker.search.prompt", defaultValue: "イベント名で検索", table: "Edit", bundle: L10n.bundle)
        }
        /// イベントを選択 — イベント (ライブ) を 1 つ選ぶピッカーの見出し
        static var eventPickerTitle: LocalizedStringResource {
            LocalizedStringResource("edit.event_picker.title", defaultValue: "イベントを選択", table: "Edit", bundle: L10n.bundle)
        }
        /// 保存に失敗しました (ID 未確定) — 管理者の即時反映でサーバが確定 ID を返さなかったとき (ライブ・公演・マスタ編集)
        static var formErrorIdUnresolved: LocalizedStringResource {
            LocalizedStringResource("edit.form.error.id_unresolved", defaultValue: "保存に失敗しました (ID 未確定)", table: "Edit", bundle: L10n.bundle)
        }
        /// 保存失敗: {detail} — 編集フォームの保存が例外で失敗したとき。detail は OS / 通信ライブラリが返すエラーの説明 (訳さない) — 引数: detail (string)
        static func formErrorSaveFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.form.error.save_failed", defaultValue: "保存失敗: \(detail)", table: "Edit", bundle: L10n.bundle)
        }
        /// エラー — 編集フォームで保存・検証に失敗したときのダイアログの見出し
        static var formErrorTitle: LocalizedStringResource {
            LocalizedStringResource("edit.form.error.title", defaultValue: "エラー", table: "Edit", bundle: L10n.bundle)
        }
        /// ブランド — 編集フォームのブランドの選択欄 (ライブ・曲・アイドル)
        static var formFieldBrand: LocalizedStringResource {
            LocalizedStringResource("edit.form.field.brand", defaultValue: "ブランド", table: "Edit", bundle: L10n.bundle)
        }
        /// 未指定 — 選択欄の「選ばない」選択肢 (ブランド・公演の出演形態)
        static var formOptionUnspecified: LocalizedStringResource {
            LocalizedStringResource("edit.form.option.unspecified", defaultValue: "未指定", table: "Edit", bundle: L10n.bundle)
        }
        /// 保存中… — 編集フォームで保存を送っている間の全面オーバーレイ
        static var formSaving: LocalizedStringResource {
            LocalizedStringResource("edit.form.saving", defaultValue: "保存中…", table: "Edit", bundle: L10n.bundle)
        }
        /// 基本情報 — ライブ・公演・曲の編集フォームの最初の節の見出し
        static var formSectionBasic: LocalizedStringResource {
            LocalizedStringResource("edit.form.section.basic", defaultValue: "基本情報", table: "Edit", bundle: L10n.bundle)
        }
        /// 並び順: {value} — マスタ (アイドル・公演) の並び順 (sortOrder) を ± で変える Stepper の見出し (iOS)。value は並び順の番号。数量ではないが、以前の iOS (SwiftUI の補間) と同じく桁区切りを付けるため count にした (アイドルの並び順は 1000 以上が普通で「並び順: 1,001」と出る)。ja・ko の複数形は other だけ。Android は区切らないので form.sort_order_android に分けた — 引数: value (count)
        static func formSortOrderIos(value: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.form.sort_order_ios", defaultValue: "並び順: \(value)", table: "Edit", bundle: L10n.bundle)
        }
        /// 別名 (カンマ区切り) — アイドルの編集フォームの別名の入力欄
        static var idolFieldAliases: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.aliases", defaultValue: "別名 (カンマ区切り)", table: "Edit", bundle: L10n.bundle)
        }
        /// 属性 (cute/cool/passion 等) — アイドルの編集フォームの属性の入力欄。例の値 (cute/cool/passion) は入力する値なので訳さない
        static var idolFieldAttribute: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.attribute", defaultValue: "属性 (cute/cool/passion 等)", table: "Edit", bundle: L10n.bundle)
        }
        /// 誕生日 (MM-DD) — アイドルの編集フォームの誕生日の入力欄
        static var idolFieldBirthday: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.birthday", defaultValue: "誕生日 (MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 出身地 — アイドルの編集フォームの出身地の入力欄
        static var idolFieldBirthplace: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.birthplace", defaultValue: "出身地", table: "Edit", bundle: L10n.bundle)
        }
        /// 血液型 — アイドルの編集フォームの血液型の入力欄
        static var idolFieldBloodType: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.blood_type", defaultValue: "血液型", table: "Edit", bundle: L10n.bundle)
        }
        /// カラー (#hex) — アイドルの編集フォームのイメージカラーの入力欄
        static var idolFieldColor: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.color", defaultValue: "カラー (#hex)", table: "Edit", bundle: L10n.bundle)
        }
        /// 実装日 (YYYY-MM-DD) — アイドルの編集フォームの実装日 (ゲームに登場した日) の入力欄
        static var idolFieldDebutDate: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.debut_date", defaultValue: "実装日 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// カナ — アイドルの編集フォームの名前の読み (カタカナ) の入力欄
        static var idolFieldKana: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.kana", defaultValue: "カナ", table: "Edit", bundle: L10n.bundle)
        }
        /// 名前 — アイドルの編集フォームの名前の入力欄
        static var idolFieldName: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.name", defaultValue: "名前", table: "Edit", bundle: L10n.bundle)
        }
        /// ローマ字 — アイドルの編集フォームの名前のローマ字の入力欄
        static var idolFieldRomaji: LocalizedStringResource {
            LocalizedStringResource("edit.idol.field.romaji", defaultValue: "ローマ字", table: "Edit", bundle: L10n.bundle)
        }
        /// 分類 — アイドルの編集フォームの分類 (ブランド・属性・並び順) の節の見出し
        static var idolSectionCategory: LocalizedStringResource {
            LocalizedStringResource("edit.idol.section.category", defaultValue: "分類", table: "Edit", bundle: L10n.bundle)
        }
        /// 名前 — アイドルの編集フォームの名前の節の見出し
        static var idolSectionName: LocalizedStringResource {
            LocalizedStringResource("edit.idol.section.name", defaultValue: "名前", table: "Edit", bundle: L10n.bundle)
        }
        /// プロフィール — アイドルの編集フォームのプロフィールの節の見出し
        static var idolSectionProfile: LocalizedStringResource {
            LocalizedStringResource("edit.idol.section.profile", defaultValue: "プロフィール", table: "Edit", bundle: L10n.bundle)
        }
        /// アイドル編集 — アイドルの編集フォームの見出し
        static var idolTitle: LocalizedStringResource {
            LocalizedStringResource("edit.idol.title", defaultValue: "アイドル編集", table: "Edit", bundle: L10n.bundle)
        }
        /// 見つかりません — ライブ・公演・曲を選ぶピッカーで、検索に一致するものが無いときの空状態の見出し
        static var pickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("edit.picker.empty.title", defaultValue: "見つかりません", table: "Edit", bundle: L10n.bundle)
        }
        /// 送信中 — 送信ボタン (PrimaryActionButton) が送信中のときの VoiceOver のヒント
        static var primaryButtonSendingA11yHint: LocalizedStringResource {
            LocalizedStringResource("edit.primary_button.sending.a11y_hint", defaultValue: "送信中", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲を追加 — セトリの末尾に行を足すボタン
        static var setlistActionAddSong: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.action.add_song", defaultValue: "曲を追加", table: "Edit", bundle: L10n.bundle)
        }
        /// 出演者 — セトリの 1 行の出演者を選ぶ画面の見出し
        static var setlistCastPickerTitle: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.cast_picker.title", defaultValue: "出演者", table: "Edit", bundle: L10n.bundle)
        }
        /// 削除する — セトリ全削除の確認で削除を実行するボタン
        static var setlistClearConfirm: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.clear.confirm", defaultValue: "削除する", table: "Edit", bundle: L10n.bundle)
        }
        /// この公演のセトリ {count} 件をすべて削除します。 この操作は取り消せません。 — セトリ全削除の確認の本文 (iOS の文言。「。」のあとに空白がある。Android は message_android)。count は消える行の数 (1000 以上なら桁区切りが付くが、セトリの行数なので実際には出ない) — 引数: count (count)
        static func setlistClearMessageIos(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.setlist.clear.message_ios", defaultValue: "この公演のセトリ \(count) 件をすべて削除します。 この操作は取り消せません。", table: "Edit", bundle: L10n.bundle)
        }
        /// セトリを全削除しますか? — 既存のセトリを 0 行にして保存しようとしたときの確認の見出し
        static var setlistClearTitle: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.clear.title", defaultValue: "セトリを全削除しますか?", table: "Edit", bundle: L10n.bundle)
        }
        /// セトリ読み込み失敗: {detail} — セトリの編集画面で今のセトリを読めなかったとき。detail はエラーの説明 (訳さない) — 引数: detail (string)
        static func setlistErrorLoadFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.setlist.error.load_failed", defaultValue: "セトリ読み込み失敗: \(detail)", table: "Edit", bundle: L10n.bundle)
        }
        /// {row} 行目: 曲が未選択 — 曲を選んでいない行があるまま保存しようとしたとき。row は行の番号 (1 から) — 引数: row (int)
        static func setlistErrorRowSongMissing(row: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.setlist.error.row_song_missing", defaultValue: "\(String(row)) 行目: 曲が未選択", table: "Edit", bundle: L10n.bundle)
        }
        /// (出演者なし — タップで追加) — セトリの行で出演者を 1 人も選んでいないときの表示 (押すと出演者を選ぶ)
        static var setlistRowNoCast: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.row.no_cast", defaultValue: "(出演者なし — タップで追加)", table: "Edit", bundle: L10n.bundle)
        }
        /// (曲を選択) — セトリの行で、まだ曲を選んでいないときの表示
        static var setlistRowSongPlaceholder: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.row.song_placeholder", defaultValue: "(曲を選択)", table: "Edit", bundle: L10n.bundle)
        }
        /// ダブルアンコール — セトリの行の区分の選択肢: ダブルアンコール
        static var setlistSectionDoubleEncore: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.section.double_encore", defaultValue: "ダブルアンコール", table: "Edit", bundle: L10n.bundle)
        }
        /// アンコール — セトリの行の区分の選択肢: アンコール
        static var setlistSectionEncore: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.section.encore", defaultValue: "アンコール", table: "Edit", bundle: L10n.bundle)
        }
        /// 本編 — セトリの行の区分の選択肢: 本編 (区分なし)
        static var setlistSectionMain: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.section.main", defaultValue: "本編", table: "Edit", bundle: L10n.bundle)
        }
        /// MC — セトリの行の区分の選択肢: MC (トーク)
        static var setlistSectionMc: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.section.mc", defaultValue: "MC", table: "Edit", bundle: L10n.bundle)
        }
        /// セトリ編集 — セトリの編集画面の見出し
        static var setlistTitle: LocalizedStringResource {
            LocalizedStringResource("edit.setlist.title", defaultValue: "セトリ編集", table: "Edit", bundle: L10n.bundle)
        }
        /// 日付は YYYY-MM-DD 形式で入力してください — 公演の編集フォームで日付の形が正しくないとき
        static var showErrorDateFormat: LocalizedStringResource {
            LocalizedStringResource("edit.show.error.date_format", defaultValue: "日付は YYYY-MM-DD 形式で入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演名と日付は必須です — 公演の編集フォームで名前か日付が空のまま保存しようとしたとき
        static var showErrorRequired: LocalizedStringResource {
            LocalizedStringResource("edit.show.error.required", defaultValue: "公演名と日付は必須です", table: "Edit", bundle: L10n.bundle)
        }
        /// 日付 (YYYY-MM-DD) — 公演の編集フォームの公演日の入力欄
        static var showFieldDate: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.date", defaultValue: "日付 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演名 — 公演の編集フォームの名前の入力欄
        static var showFieldName: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.name", defaultValue: "公演名", table: "Edit", bundle: L10n.bundle)
        }
        /// 出演形態 — 公演の編集フォームの出演形態 (character / cast / mixed。選択肢の値は訳さない) の選択欄
        static var showFieldPerformerType: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.performer_type", defaultValue: "出演形態", table: "Edit", bundle: L10n.bundle)
        }
        /// 開演時刻 (HH:mm) — 公演の編集フォームの開演時刻の入力欄
        static var showFieldStartTime: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.start_time", defaultValue: "開演時刻 (HH:mm)", table: "Edit", bundle: L10n.bundle)
        }
        /// 会場 — 公演の編集フォームの会場名の入力欄
        static var showFieldVenue: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.venue", defaultValue: "会場", table: "Edit", bundle: L10n.bundle)
        }
        /// 会場所在地 — 公演の編集フォームの会場の所在地 (都市) の入力欄
        static var showFieldVenueCity: LocalizedStringResource {
            LocalizedStringResource("edit.show.field.venue_city", defaultValue: "会場所在地", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演追加 — 公演の新規作成フォームの見出し (iOS の文言。Android は create_android)
        static var showTitleCreateIos: LocalizedStringResource {
            LocalizedStringResource("edit.show.title.create_ios", defaultValue: "公演追加", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演編集 — 公演の編集フォームの見出し
        static var showTitleEdit: LocalizedStringResource {
            LocalizedStringResource("edit.show.title.edit", defaultValue: "公演編集", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演名またはイベント名を入力して検索してください — 公演のピッカーを開いた直後 (未入力) の空状態の説明
        static var showPickerEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("edit.show_picker.empty.message", defaultValue: "公演名またはイベント名を入力して検索してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 「{query}」に一致する公演がありません — 公演のピッカーで検索に一致するものが無いとき。query は入力した検索語 — 引数: query (string)
        static func showPickerEmptyNoMatch(query: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.show_picker.empty.no_match", defaultValue: "「\(query)」に一致する公演がありません", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演を検索 — 公演のピッカーを開いた直後 (未入力) の空状態の見出し
        static var showPickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("edit.show_picker.empty.title", defaultValue: "公演を検索", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演名・イベント名で検索 — 公演のピッカーの検索欄のプレースホルダ
        static var showPickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("edit.show_picker.search.prompt", defaultValue: "公演名・イベント名で検索", table: "Edit", bundle: L10n.bundle)
        }
        /// 公演を選択 — 公演を 1 つ選ぶピッカーの見出し
        static var showPickerTitle: LocalizedStringResource {
            LocalizedStringResource("edit.show_picker.title", defaultValue: "公演を選択", table: "Edit", bundle: L10n.bundle)
        }
        /// Apple Music 関連を全て空にする — 曲の編集フォームで Apple Music の ID・ジャケ写・試聴の URL をまとめて消すボタン
        static var songAppleMusicClear: LocalizedStringResource {
            LocalizedStringResource("edit.song.apple_music.clear", defaultValue: "Apple Music 関連を全て空にする", table: "Edit", bundle: L10n.bundle)
        }
        /// 誤紐付けで他の曲が再生されるときに使う。サブスク未配信の曲はクリアすべき。 — Apple Music の項目を空にするボタンの下の説明 (サブスク = 定額の配信サービス)
        static var songAppleMusicClearFooter: LocalizedStringResource {
            LocalizedStringResource("edit.song.apple_music.clear_footer", defaultValue: "誤紐付けで他の曲が再生されるときに使う。サブスク未配信の曲はクリアすべき。", table: "Edit", bundle: L10n.bundle)
        }
        /// 一覧でアイコンを出すために必要です。ソロ曲なら 1 名、ユニット曲なら全員を選んでください。 — 歌唱アイドルの節の下の説明
        static var songArtistsFooter: LocalizedStringResource {
            LocalizedStringResource("edit.song.artists.footer", defaultValue: "一覧でアイコンを出すために必要です。ソロ曲なら 1 名、ユニット曲なら全員を選んでください。", table: "Edit", bundle: L10n.bundle)
        }
        /// 歌唱アイドルを選択 — 歌唱アイドルをまだ選んでいないときの表示 (押すと選ぶ画面)
        static var songArtistsPlaceholder: LocalizedStringResource {
            LocalizedStringResource("edit.song.artists.placeholder", defaultValue: "歌唱アイドルを選択", table: "Edit", bundle: L10n.bundle)
        }
        /// 歌唱アイドル — 曲の新規作成で歌うアイドル (オリジナルメンバー) を選ぶ節の見出しと、アイドルを選ぶ画面の見出し
        static var songArtistsTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song.artists.title", defaultValue: "歌唱アイドル", table: "Edit", bundle: L10n.bundle)
        }
        /// 歌唱アイドルを 1 名以上選択してください — 曲の新規作成で歌唱アイドルを選ばずに保存しようとしたとき
        static var songErrorArtistsRequired: LocalizedStringResource {
            LocalizedStringResource("edit.song.error.artists_required", defaultValue: "歌唱アイドルを 1 名以上選択してください", table: "Edit", bundle: L10n.bundle)
        }
        /// Apple Music ID を設定する場合は artwork URL も必須です (一覧のジャケ写表示に使います) — Apple Music の ID だけ入れてジャケ写の URL が空のまま保存しようとしたとき
        static var songErrorArtworkRequired: LocalizedStringResource {
            LocalizedStringResource("edit.song.error.artwork_required", defaultValue: "Apple Music ID を設定する場合は artwork URL も必須です (一覧のジャケ写表示に使います)", table: "Edit", bundle: L10n.bundle)
        }
        /// 再生時間は秒数 (整数) で入力してください — 曲の編集フォームで再生時間が数でないとき
        static var songErrorDurationFormat: LocalizedStringResource {
            LocalizedStringResource("edit.song.error.duration_format", defaultValue: "再生時間は秒数 (整数) で入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// リリース日は YYYY-MM-DD 形式で入力してください — 曲の編集フォームでリリース日の形が正しくないとき
        static var songErrorReleaseDateFormat: LocalizedStringResource {
            LocalizedStringResource("edit.song.error.release_date_format", defaultValue: "リリース日は YYYY-MM-DD 形式で入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// タイトルを入力してください — 曲の編集フォームで曲名を空のまま保存しようとしたとき
        static var songErrorTitleRequired: LocalizedStringResource {
            LocalizedStringResource("edit.song.error.title_required", defaultValue: "タイトルを入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 編曲 — 曲の編集フォームの編曲者の入力欄
        static var songFieldArranger: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.arranger", defaultValue: "編曲", table: "Edit", bundle: L10n.bundle)
        }
        /// 作曲 — 曲の編集フォームの作曲者の入力欄
        static var songFieldComposer: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.composer", defaultValue: "作曲", table: "Edit", bundle: L10n.bundle)
        }
        /// 再生時間 (秒) — 曲の編集フォームの再生時間 (秒数) の入力欄
        static var songFieldDuration: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.duration", defaultValue: "再生時間 (秒)", table: "Edit", bundle: L10n.bundle)
        }
        /// 作詞 — 曲の編集フォームの作詞者の入力欄
        static var songFieldLyricist: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.lyricist", defaultValue: "作詞", table: "Edit", bundle: L10n.bundle)
        }
        /// 歌詞 URL — 曲の編集フォームの歌詞ページの URL の入力欄
        static var songFieldLyricsUrl: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.lyrics_url", defaultValue: "歌詞 URL", table: "Edit", bundle: L10n.bundle)
        }
        /// リリース日 (YYYY-MM-DD) — 曲の編集フォームのリリース日の入力欄
        static var songFieldReleaseDate: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.release_date", defaultValue: "リリース日 (YYYY-MM-DD)", table: "Edit", bundle: L10n.bundle)
        }
        /// 歌唱表記 (例: 春香・千早) — 曲の編集フォームの歌唱者の表記の入力欄。例はマスタに入る書き方そのもの (アイドル名と区切りの ・) なので訳さない
        static var songFieldSingerLabel: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.singer_label", defaultValue: "歌唱表記 (例: 春香・千早)", table: "Edit", bundle: L10n.bundle)
        }
        /// タイトル — 曲の編集フォームの曲名の入力欄
        static var songFieldTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.title", defaultValue: "タイトル", table: "Edit", bundle: L10n.bundle)
        }
        /// タイトル (カナ) — 曲の編集フォームの曲名の読みの入力欄
        static var songFieldTitleKana: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.title_kana", defaultValue: "タイトル (カナ)", table: "Edit", bundle: L10n.bundle)
        }
        /// 種別 — 曲の編集フォームの曲種別 (ソロ・ユニット…。語はコアの語彙) の選択欄
        static var songFieldType: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.type", defaultValue: "種別", table: "Edit", bundle: L10n.bundle)
        }
        /// ユニット名 — 曲の編集フォームのユニット名の入力欄
        static var songFieldUnitName: LocalizedStringResource {
            LocalizedStringResource("edit.song.field.unit_name", defaultValue: "ユニット名", table: "Edit", bundle: L10n.bundle)
        }
        /// CD / その他 — 曲の編集フォームの CD・ISRC・歌詞 URL の節の見出し
        static var songSectionCdOther: LocalizedStringResource {
            LocalizedStringResource("edit.song.section.cd_other", defaultValue: "CD / その他", table: "Edit", bundle: L10n.bundle)
        }
        /// 制作情報 — 曲の編集フォームの作家・リリースの節の見出し
        static var songSectionCredits: LocalizedStringResource {
            LocalizedStringResource("edit.song.section.credits", defaultValue: "制作情報", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲を追加 — 曲の新規作成フォームの見出し
        static var songTitleCreate: LocalizedStringResource {
            LocalizedStringResource("edit.song.title.create", defaultValue: "曲を追加", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲編集 — 曲の編集フォームの見出し
        static var songTitleEdit: LocalizedStringResource {
            LocalizedStringResource("edit.song.title.edit", defaultValue: "曲編集", table: "Edit", bundle: L10n.bundle)
        }
        /// 追加 — 曲のピッカーの確定ボタン (まだ 1 曲も選んでいないとき)
        static var songPickerActionAdd: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.action.add", defaultValue: "追加", table: "Edit", bundle: L10n.bundle)
        }
        /// 追加 ({count}) — 曲のピッカーの確定ボタン (曲を選んだあと)。count は選んだ曲の数。1000 以上は桁区切りが付く (以前の iOS の SwiftUI の補間と同じ) — 引数: count (count)
        static func songPickerActionAddCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.action.add_count", defaultValue: "追加 (\(count))", table: "Edit", bundle: L10n.bundle)
        }
        /// 完了 — 曲のピッカーの絞り込みシートを閉じるボタン
        static var songPickerActionDone: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.action.done", defaultValue: "完了", table: "Edit", bundle: L10n.bundle)
        }
        /// リセット — 曲のピッカーの絞り込みシートで、絞り込みを全部外すボタン
        static var songPickerActionReset: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.action.reset", defaultValue: "リセット", table: "Edit", bundle: L10n.bundle)
        }
        /// CDシリーズ — 曲のピッカーの絞り込みシートの CD シリーズの節の見出しと、そこから開く一覧の見出し
        static var songPickerCdSeriesTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.cd_series.title", defaultValue: "CDシリーズ", table: "Edit", bundle: L10n.bundle)
        }
        /// 右上のフィルターか曲名で絞り込めます — 曲のピッカーで、未入力なのに結果が無いときの案内
        static var songPickerEmptyHint: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.empty.hint", defaultValue: "右上のフィルターか曲名で絞り込めます", table: "Edit", bundle: L10n.bundle)
        }
        /// 「{query}」に一致する楽曲がありません — 曲のピッカーで検索に一致するものが無いとき。query は入力した検索語 — 引数: query (string)
        static func songPickerEmptyNoMatch(query: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.empty.no_match", defaultValue: "「\(query)」に一致する楽曲がありません", table: "Edit", bundle: L10n.bundle)
        }
        /// フィルター — 曲のピッカーの右上の絞り込みボタンの読み上げ
        static var songPickerFilterA11y: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.a11y", defaultValue: "フィルター", table: "Edit", bundle: L10n.bundle)
        }
        /// 出演者のオリ曲のみ — 絞り込み: その公演の出演者がオリジナルメンバーの曲だけにするスイッチ (オリ曲 = オリジナル曲)
        static var songPickerFilterCastOriginalOnly: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.cast_original_only", defaultValue: "出演者のオリ曲のみ", table: "Edit", bundle: L10n.bundle)
        }
        /// 「ライブ履歴のみ」は、セトリ追加で生まれただけでカタログ情報が無い曲 (カバー・歌枠等) を隠します。 — 絞り込みの節の下の説明。「ライブ履歴のみ」は上のスイッチのこと。歌枠 = 配信で歌う枠
        static var songPickerFilterFooter: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.footer", defaultValue: "「ライブ履歴のみ」は、セトリ追加で生まれただけでカタログ情報が無い曲 (カバー・歌枠等) を隠します。", table: "Edit", bundle: L10n.bundle)
        }
        /// 絞り込み — 曲のピッカーの絞り込みシートのスイッチの節の見出し
        static var songPickerFilterHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.header", defaultValue: "絞り込み", table: "Edit", bundle: L10n.bundle)
        }
        /// ライブ履歴のみの曲を隠す — 絞り込み: セトリにしか出てこない (カタログ情報の無い) 曲を隠すスイッチ
        static var songPickerFilterHideLiveOnly: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.hide_live_only", defaultValue: "ライブ履歴のみの曲を隠す", table: "Edit", bundle: L10n.bundle)
        }
        /// リミックスを含める — 絞り込み: リミックス曲も出すスイッチ
        static var songPickerFilterIncludeRemixes: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter.include_remixes", defaultValue: "リミックスを含める", table: "Edit", bundle: L10n.bundle)
        }
        /// フィルター / 並び順 — 曲のピッカーの絞り込みシートの見出し
        static var songPickerFilterSheetTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.filter_sheet.title", defaultValue: "フィルター / 並び順", table: "Edit", bundle: L10n.bundle)
        }
        /// {count}曲 — 曲のピッカーの一覧の見出し (曲を選ぶ前)。count は一覧の曲数。1000 以上は桁区切りが付く (1,234曲) — 引数: count (count)
        static func songPickerHeaderCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.header.count", defaultValue: "\(count)曲", table: "Edit", bundle: L10n.bundle)
        }
        /// {count}曲 ・ {selected}曲選択中 — 曲のピッカーの一覧の見出し (曲を選んだあと)。count は一覧の曲数 (1000 以上は桁区切りが付く)、selected は選んだ曲の数を呼び出し側で桁区切りした文字列 (1,234。以前の iOS の SwiftUI の補間と同じ。count は 1 キーに 1 つまでなので文字列で渡す) — 引数: count (count), selected (string)
        static func songPickerHeaderSelected(count: Int, selected: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.header.selected", defaultValue: "\(count)曲 ・ \(selected)曲選択中", table: "Edit", bundle: L10n.bundle)
        }
        /// アイドル — 曲のピッカーの絞り込みシートのアイドルの節の見出しと、そこから開くアイドル選択の見出し
        static var songPickerIdolsHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.idols.header", defaultValue: "アイドル", table: "Edit", bundle: L10n.bundle)
        }
        /// お気に入りのみ — 絞り込み: お気に入りの曲だけにするスイッチ
        static var songPickerMarkFavoriteOnly: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.mark.favorite_only", defaultValue: "お気に入りのみ", table: "Edit", bundle: L10n.bundle)
        }
        /// マイマーク — 曲のピッカーの絞り込みシートのマイマーク (担当・お気に入り) の節の見出し
        static var songPickerMarkHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.mark.header", defaultValue: "マイマーク", table: "Edit", bundle: L10n.bundle)
        }
        /// 担当アイドルの曲のみ — 絞り込み: 担当アイドルが歌う曲だけにするスイッチ
        static var songPickerMarkMyPickOnly: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.mark.my_pick_only", defaultValue: "担当アイドルの曲のみ", table: "Edit", bundle: L10n.bundle)
        }
        /// 選択なし — 曲のピッカーの絞り込みシートで、タグ・アイドル・シリーズを何も選んでいないときの表示
        static var songPickerOptionNone: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.option.none", defaultValue: "選択なし", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲名で検索 — 曲のピッカーの検索欄のプレースホルダ
        static var songPickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.search.prompt", defaultValue: "曲名で検索", table: "Edit", bundle: L10n.bundle)
        }
        /// シリーズ — 曲のピッカーの絞り込みシートのシリーズの節の見出しと、そこから開く一覧の見出し
        static var songPickerSeriesTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.series.title", defaultValue: "シリーズ", table: "Edit", bundle: L10n.bundle)
        }
        /// 全て — 曲タイプの選択肢: 絞り込まない
        static var songPickerSongTypeAll: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.song_type.all", defaultValue: "全て", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲タイプ — 曲のピッカーの絞り込みシートの曲タイプ (ソロ・ユニット・全体曲) の節の見出し
        static var songPickerSongTypeHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.song_type.header", defaultValue: "曲タイプ", table: "Edit", bundle: L10n.bundle)
        }
        /// 作詞 / 作曲 / 編曲者 — 曲のピッカーの絞り込みシートの作家名の節の見出し
        static var songPickerSongwriterHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.songwriter.header", defaultValue: "作詞 / 作曲 / 編曲者", table: "Edit", bundle: L10n.bundle)
        }
        /// 名前を入力 — 作家名の入力欄のプレースホルダ
        static var songPickerSongwriterPlaceholder: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.songwriter.placeholder", defaultValue: "名前を入力", table: "Edit", bundle: L10n.bundle)
        }
        /// 並び順 — 曲のピッカーの絞り込みシートの並び順の選択欄と、その節の見出し
        static var songPickerSortTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.sort.title", defaultValue: "並び順", table: "Edit", bundle: L10n.bundle)
        }
        /// タグ絞り込みの取得に失敗しました。電波状況をご確認ください。 — 曲のピッカーで、タグの絞り込みを取れず結果が 0 件のときの注意
        static var songPickerTagFilterError: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.tag_filter.error", defaultValue: "タグ絞り込みの取得に失敗しました。電波状況をご確認ください。", table: "Edit", bundle: L10n.bundle)
        }
        /// タグ絞り込みの取得に失敗しました (表示中の結果には未反映です) — 曲のピッカーで、タグの絞り込みを取れなかったが前の結果を出し続けているときの注意
        static var songPickerTagFilterErrorStale: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.tag_filter.error_stale", defaultValue: "タグ絞り込みの取得に失敗しました (表示中の結果には未反映です)", table: "Edit", bundle: L10n.bundle)
        }
        /// 複数選択時は全てのタグを含む曲だけに絞り込みます。 — タグの節の下の説明 (複数のタグは AND で絞る)
        static var songPickerTagsFooter: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.tags.footer", defaultValue: "複数選択時は全てのタグを含む曲だけに絞り込みます。", table: "Edit", bundle: L10n.bundle)
        }
        /// タグ — 曲のピッカーの絞り込みシートのタグの節の見出し
        static var songPickerTagsHeader: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.tags.header", defaultValue: "タグ", table: "Edit", bundle: L10n.bundle)
        }
        /// 曲を追加 — 曲を複数選んで追加するピッカー (セトリ予想・投票のお題など) の見出し
        static var songPickerTitle: LocalizedStringResource {
            LocalizedStringResource("edit.song_picker.title", defaultValue: "曲を追加", table: "Edit", bundle: L10n.bundle)
        }
        /// メモは {max} 文字以内で入力してください — 参考動画のメモが長すぎるとき。max は上限の文字数 (桁区切りしない) — 引数: max (int)
        static func videoErrorNoteTooLong(max: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.video.error.note_too_long", defaultValue: "メモは \(String(max)) 文字以内で入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// 保存に失敗しました: {detail} — 参考動画の保存が例外で失敗したとき。detail はエラーの説明 (訳さない) — 引数: detail (string)
        static func videoErrorSaveFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("edit.video.error.save_failed", defaultValue: "保存に失敗しました: \(detail)", table: "Edit", bundle: L10n.bundle)
        }
        /// タイトルは {max} 文字以内で入力してください — 参考動画のタイトルが長すぎるとき。max は上限の文字数 — 引数: max (int)
        static func videoErrorTitleTooLong(max: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.video.error.title_too_long", defaultValue: "タイトルは \(String(max)) 文字以内で入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// YouTube の URL を入力してください — 参考動画のフォームで URL が YouTube の動画のものでないとき
        static var videoErrorUrlRequired: LocalizedStringResource {
            LocalizedStringResource("edit.video.error.url_required", defaultValue: "YouTube の URL を入力してください", table: "Edit", bundle: L10n.bundle)
        }
        /// メモ (任意) — 参考動画のフォームのメモの入力欄 (省略できる)
        static var videoFieldNote: LocalizedStringResource {
            LocalizedStringResource("edit.video.field.note", defaultValue: "メモ (任意)", table: "Edit", bundle: L10n.bundle)
        }
        /// 動画タイトル (任意) — 参考動画のフォームの動画タイトルの入力欄 (省略できる)
        static var videoFieldTitle: LocalizedStringResource {
            LocalizedStringResource("edit.video.field.title", defaultValue: "動画タイトル (任意)", table: "Edit", bundle: L10n.bundle)
        }
        /// どの公演の映像かなどの補足。メモ {length}/{max} 文字 — 参考動画のフォームのメモの節の下の説明と文字数 (iOS)。length は今の文字数を呼び出し側で桁区切りした文字列 (1000 以上は 1,234)、max は上限の 1000 で、いつも桁区切りが付く (1,000)。以前の iOS も SwiftUI の補間で桁区切りして出していた (Android は区切らないので video.note.footer_android に分けた) — 引数: length (string), max (count)
        static func videoNoteFooterIos(length: String, max: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit.video.note.footer_ios", defaultValue: "どの公演の映像かなどの補足。メモ \(length)/\(max) 文字", table: "Edit", bundle: L10n.bundle)
        }
        /// 補足 — 参考動画のフォームのタイトル・メモの節の見出し
        static var videoNoteHeader: LocalizedStringResource {
            LocalizedStringResource("edit.video.note.header", defaultValue: "補足", table: "Edit", bundle: L10n.bundle)
        }
        /// 参考動画を投稿 — 参考動画の投稿フォームの見出し
        static var videoTitleCreate: LocalizedStringResource {
            LocalizedStringResource("edit.video.title.create", defaultValue: "参考動画を投稿", table: "Edit", bundle: L10n.bundle)
        }
        /// 参考動画を編集 — 参考動画の編集フォームの見出し
        static var videoTitleEdit: LocalizedStringResource {
            LocalizedStringResource("edit.video.title.edit", defaultValue: "参考動画を編集", table: "Edit", bundle: L10n.bundle)
        }
        /// YouTube の watch / youtu.be / shorts / embed URL に対応。 — 参考動画の URL の入力欄の下の説明。watch などは URL の形の名前なので訳さない
        static var videoUrlFooter: LocalizedStringResource {
            LocalizedStringResource("edit.video.url.footer", defaultValue: "YouTube の watch / youtu.be / shorts / embed URL に対応。", table: "Edit", bundle: L10n.bundle)
        }
        /// 動画 URL — 参考動画のフォームの URL の節の見出し
        static var videoUrlHeader: LocalizedStringResource {
            LocalizedStringResource("edit.video.url.header", defaultValue: "動画 URL", table: "Edit", bundle: L10n.bundle)
        }
    }
}
