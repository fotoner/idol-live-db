// 生成物: i18n/catalog/edit_feed.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/edit_feed.json の文言 (表 EditFeed)
    enum EditFeed {
        /// 差戻し済み — 差し戻された (取り消された) 編集に付けるバッジ。iOS は編集履歴の行、Android は「最近の編集」の自分の編集タブのカード
        static var badgeReverted: LocalizedStringResource {
            LocalizedStringResource("edit_feed.badge.reverted", defaultValue: "差戻し済み", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 運営の確認後に反映されます。ご協力ありがとうございます！ — 修正リクエストを送ったあとのアラートの本文
        static var editRequestSentMessage: LocalizedStringResource {
            LocalizedStringResource("edit_feed.edit_request.sent.message", defaultValue: "運営の確認後に反映されます。ご協力ありがとうございます！", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 修正リクエストを送信しました — ライブ・公演・セトリ・曲・アイドルの修正を送った (運営が確認して反映する) あとのアラートの見出し
        static var editRequestSentTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.edit_request.sent.title", defaultValue: "修正リクエストを送信しました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 名無しのプロデューサー — 編集者の表示名。名前が無いか、メールアドレスの形のとき (匿名にする) に代わりに出す
        static var editorAnonymous: LocalizedStringResource {
            LocalizedStringResource("edit_feed.editor.anonymous", defaultValue: "名無しのプロデューサー", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 変更履歴 — 各カードの下の導線。その編集の差分 (変更履歴) を開く
        static var feedCardHistory: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.card.history", defaultValue: "変更履歴", table: "EditFeed", bundle: L10n.bundle)
        }
        /// あなたの編集 — 自分の編集のカードに、Good ボタンの代わりに出すラベル
        static var feedCardOwn: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.card.own", defaultValue: "あなたの編集", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 誰かがデータを編集すると、ここに新着順で表示されます。 — 「最近の編集」(みんなの編集) が空のときの説明
        static var feedEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.empty.message", defaultValue: "誰かがデータを編集すると、ここに新着順で表示されます。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ライブ・楽曲・セトリを編集すると、ここに履歴が残ります。 — 自分の編集が空のときの説明
        static var feedEmptyMessageMine: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.empty.message_mine", defaultValue: "ライブ・楽曲・セトリを編集すると、ここに履歴が残ります。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// まだ編集がありません — 「最近の編集」に 1 件も無いときの空状態の見出し
        static var feedEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.empty.title", defaultValue: "まだ編集がありません", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました: {detail} — 「最近の編集」の読み込み・Good の失敗 (iOS。Android の同じ所は説明を付けない feed.error.load_failed_android)。detail はエラーの説明 (OS・サーバの文言。訳さない) — 引数: detail (string)
        static func feedErrorLoadFailedIos(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.error.load_failed_ios", defaultValue: "読み込みに失敗しました: \(detail)", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 操作が多すぎます。しばらく待ってからお試しください。 — サーバに短時間に何度も送った (429) ときのエラー
        static var feedErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.error.rate_limited", defaultValue: "操作が多すぎます。しばらく待ってからお試しください。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// エラー — 「最近の編集」で読み込みや Good に失敗したときのアラートの見出し
        static var feedErrorTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.error.title", defaultValue: "エラー", table: "EditFeed", bundle: L10n.bundle)
        }
        /// Good を付ける — Good (編集へのいいね) ボタンの読み上げ。まだ付けていないとき。Good は機能名なのでそのまま
        static var feedGoodAddA11y: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.good.add.a11y", defaultValue: "Good を付ける", table: "EditFeed", bundle: L10n.bundle)
        }
        /// Good を取り消す — Good (編集へのいいね) ボタンの読み上げ。もう付けているとき
        static var feedGoodRemoveA11y: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.good.remove.a11y", defaultValue: "Good を取り消す", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 最近の編集 — 「最近の編集」画面のタイトル (みんなの編集)
        static var feedTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.title", defaultValue: "最近の編集", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 自分の編集 — 「最近の編集」画面を自分の編集だけにしたときのタイトル
        static var feedTitleMine: LocalizedStringResource {
            LocalizedStringResource("edit_feed.feed.title_mine", defaultValue: "自分の編集", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 新規追加されました — 編集履歴の行: レコードが作られた
        static var historyDiffCreated: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.diff.created", defaultValue: "新規追加されました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 削除されました — 編集履歴の行: レコードが削除された
        static var historyDiffDeleted: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.diff.deleted", defaultValue: "削除されました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// セットリスト全体が更新されました — 編集履歴の行: 公演のセトリがまとめて更新された
        static var historyDiffSnapshot: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.diff.snapshot", defaultValue: "セットリスト全体が更新されました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 内容が更新されました — 編集履歴の行: 更新されたが、変わった項目が分からない
        static var historyDiffUpdated: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.diff.updated", defaultValue: "内容が更新されました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// このデータがまだ一度も編集されていないか、編集が反映待ちです。 — 編集履歴が 1 件も無いときの説明
        static var historyEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.empty.message", defaultValue: "このデータがまだ一度も編集されていないか、編集が反映待ちです。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 編集履歴はありません — 編集履歴が 1 件も無いときの見出し (iOS。説明は history.empty.message。Android の同じ所は history.empty.title_android)
        static var historyEmptyTitleIos: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.empty.title_ios", defaultValue: "編集履歴はありません", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 年齢 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド age (アイドル))
        static var historyFieldAge: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.age", defaultValue: "年齢", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ジャケット画像 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド artworkUrl (曲))
        static var historyFieldArtworkUrl: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.artwork_url", defaultValue: "ジャケット画像", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 誕生日 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド birthday (アイドル))
        static var historyFieldBirthday: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.birthday", defaultValue: "誕生日", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ブロック — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド blockLabel (セトリのブロック))
        static var historyFieldBlockLabel: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.block_label", defaultValue: "ブロック", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 血液型 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド bloodType (アイドル))
        static var historyFieldBloodType: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.blood_type", defaultValue: "血液型", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ブランド — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド brandId)
        static var historyFieldBrandId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.brand_id", defaultValue: "ブランド", table: "EditFeed", bundle: L10n.bundle)
        }
        /// キャスト — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド castId)
        static var historyFieldCastId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.cast_id", defaultValue: "キャスト", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 都市 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド city (ライブ))
        static var historyFieldCity: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.city", defaultValue: "都市", table: "EditFeed", bundle: L10n.bundle)
        }
        /// イメージカラー — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド color (アイドル))
        static var historyFieldColor: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.color", defaultValue: "イメージカラー", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 公演ラベル — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド dayLabel (DAY1 など))
        static var historyFieldDayLabel: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.day_label", defaultValue: "公演ラベル", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 削除フラグ — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド deletedAt)
        static var historyFieldDeletedAt: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.deleted_at", defaultValue: "削除フラグ", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 終了日 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド endDate (ライブ))
        static var historyFieldEndDate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.end_date", defaultValue: "終了日", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ライブ — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド eventId (公演が属するライブ))
        static var historyFieldEventId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.event_id", defaultValue: "ライブ", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 種別 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド eventType (ライブの種類))
        static var historyFieldEventType: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.event_type", defaultValue: "種別", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 身長 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド height (アイドル))
        static var historyFieldHeight: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.height", defaultValue: "身長", table: "EditFeed", bundle: L10n.bundle)
        }
        /// アイドル — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド idolId)
        static var historyFieldIdolId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.idol_id", defaultValue: "アイドル", table: "EditFeed", bundle: L10n.bundle)
        }
        /// アンコール — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド isEncore)。用語集の検査が「アンコール」の中の「コール」(콜) に反応して警告を出すが、別の語 (앙코르 でよい)
        static var historyFieldIsEncore: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.is_encore", defaultValue: "アンコール", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 読み (かな) — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド kana (曲) / kanaName (アイドル))
        static var historyFieldKana: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.kana", defaultValue: "読み (かな)", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 更新日時 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド modifiedAt)
        static var historyFieldModifiedAt: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.modified_at", defaultValue: "更新日時", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 名称 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド name)
        static var historyFieldName: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.name", defaultValue: "名称", table: "EditFeed", bundle: L10n.bundle)
        }
        /// メモ — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド note)
        static var historyFieldNote: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.note", defaultValue: "メモ", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 公式URL — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド officialUrl (ライブ))
        static var historyFieldOfficialUrl: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.official_url", defaultValue: "公式URL", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 開場 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド openTime (開場の時刻))
        static var historyFieldOpenTime: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.open_time", defaultValue: "開場", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 順番 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド position)
        static var historyFieldPosition: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.position", defaultValue: "順番", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 発売日 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド releaseDate (曲))
        static var historyFieldReleaseDate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.release_date", defaultValue: "発売日", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ローマ字 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド romaji)
        static var historyFieldRomaji: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.romaji", defaultValue: "ローマ字", table: "EditFeed", bundle: L10n.bundle)
        }
        /// セトリ項目 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド setlistItemId)
        static var historyFieldSetlistItemId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.setlist_item_id", defaultValue: "セトリ項目", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 公演日 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド showDate)
        static var historyFieldShowDate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.show_date", defaultValue: "公演日", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 公演 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド showId)
        static var historyFieldShowId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.show_id", defaultValue: "公演", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 曲 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド songId (セトリの曲))
        static var historyFieldSongId: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.song_id", defaultValue: "曲", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 並び順 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド sortOrder)
        static var historyFieldSortOrder: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.sort_order", defaultValue: "並び順", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 開始日 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド startDate (ライブ))
        static var historyFieldStartDate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.start_date", defaultValue: "開始日", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 開演 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド startTime (開演の時刻))
        static var historyFieldStartTime: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.start_time", defaultValue: "開演", table: "EditFeed", bundle: L10n.bundle)
        }
        /// タイトル — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド title)
        static var historyFieldTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.title", defaultValue: "タイトル", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 会場 — 編集履歴の差分の見出し: 変わった項目の名前 (CloudKit のフィールド venue (ライブ))
        static var historyFieldVenue: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.field.venue", defaultValue: "会場", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました — 編集履歴の読み込みに失敗したときの見出し。説明はエラーの文言 (iOS。Android の同じ所は history.load_failed_android)
        static var historyLoadFailedIos: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.load_failed_ios", defaultValue: "読み込みに失敗しました", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 運営 — 編集履歴の行のバッジ。運営 (管理者) による編集
        static var historySourceAdmin: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.source.admin", defaultValue: "運営", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 巻き戻し — 編集履歴の行のバッジ。差し戻しの操作で作られた編集
        static var historySourceRevert: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.source.revert", defaultValue: "巻き戻し", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 編集履歴 — レコードの編集履歴の画面のタイトル (iOS。Android の同じ画面は「変更履歴」の history.title_android)
        static var historyTitleIos: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.title_ios", defaultValue: "編集履歴", table: "EditFeed", bundle: L10n.bundle)
        }
        /// (空) — 編集履歴の差分の値: 空の文字列
        static var historyValueEmpty: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.value.empty", defaultValue: "(空)", table: "EditFeed", bundle: L10n.bundle)
        }
        /// {count} 件 — 編集履歴の差分の値: 配列の要素の数。1000 以上は桁区切りが付く (1,234 件) — 引数: count (count)
        static func historyValueItems(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.value.items", defaultValue: "\(count) 件", table: "EditFeed", bundle: L10n.bundle)
        }
        /// なし — 編集履歴の差分の値: 真偽値の偽
        static var historyValueNo: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.value.no", defaultValue: "なし", table: "EditFeed", bundle: L10n.bundle)
        }
        /// (なし) — 編集履歴の差分 (旧 → 新) の値: 値が無い (null・項目なし)
        static var historyValueNone: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.value.none", defaultValue: "(なし)", table: "EditFeed", bundle: L10n.bundle)
        }
        /// あり — 編集履歴の差分の値: 真偽値の真 (例: アンコール あり)
        static var historyValueYes: LocalizedStringResource {
            LocalizedStringResource("edit_feed.history.value.yes", defaultValue: "あり", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 投稿・投票にはログインが必要です — 未ログインの人に出すインライン導線 (InlineLoginPrompt) の文の既定値 (呼び出し側が渡さないとき)
        static var inlineLoginDefaultMessage: LocalizedStringResource {
            LocalizedStringResource("edit_feed.inline_login.default_message", defaultValue: "投稿・投票にはログインが必要です", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 読み込み中... — 最近の編集・編集履歴の一覧を読み込んでいる間、中央に出す表示
        static var listLoading: LocalizedStringResource {
            LocalizedStringResource("edit_feed.list.loading", defaultValue: "読み込み中...", table: "EditFeed", bundle: L10n.bundle)
        }
        /// {action}に失敗しました。変更は保存されていません。もう一度お試しください。 — 端末ローカルの書き込み失敗のアラートの本文。action は操作名 (例: メモの保存)。呼び出し側の文言を同じ言語で文字列にしてから差し込む (まだ日本語の文字列のまま渡す画面もある) — 引数: action (string)
        static func localWriteFailedMessage(action: String) -> LocalizedStringResource {
            LocalizedStringResource("edit_feed.local_write.failed.message", defaultValue: "\(action)に失敗しました。変更は保存されていません。もう一度お試しください。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 保存できませんでした — 端末にだけ保存するデータ (担当・参加・メモ・座席・習熟度・家計簿・マイタグ) の書き込みに失敗したときのアラートの見出し
        static var localWriteFailedTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.local_write.failed.title", defaultValue: "保存できませんでした", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 閉じる — ログインの誘導シートの左上のボタン
        static var loginSheetClose: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.close", defaultValue: "閉じる", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ライブ・公演・セトリ・楽曲の情報は、ログインしたユーザーみんなで編集できます。誤りの修正や新しいライブの追加に、ぜひ協力してください。 — ログインの誘導シートの説明
        static var loginSheetMessage: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.message", defaultValue: "ライブ・公演・セトリ・楽曲の情報は、ログインしたユーザーみんなで編集できます。誤りの修正や新しいライブの追加に、ぜひ協力してください。", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 閲覧はログイン不要。編集する時だけログインします — ログインの誘導シートの箇条書き (3 つ目)
        static var loginSheetPointBrowse: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.point.browse", defaultValue: "閲覧はログイン不要。編集する時だけログインします", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 変更履歴が残り、間違えてもいつでも戻せます — ログインの誘導シートの箇条書き (2 つ目)
        static var loginSheetPointHistory: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.point.history", defaultValue: "変更履歴が残り、間違えてもいつでも戻せます", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 編集は承認待ちなし。すぐ全員に反映されます — ログインの誘導シートの箇条書き (1 つ目)
        static var loginSheetPointInstant: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.point.instant", defaultValue: "編集は承認待ちなし。すぐ全員に反映されます", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ログインして編集に参加 — 未ログインで編集の導線を押したときのシートの見出し
        static var loginSheetTitle: LocalizedStringResource {
            LocalizedStringResource("edit_feed.login_sheet.title", defaultValue: "ログインして編集に参加", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 追加 — 編集の操作のバッジ (create)
        static var opCreate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.op.create", defaultValue: "追加", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 削除 — 編集の操作のバッジ (delete)
        static var opDelete: LocalizedStringResource {
            LocalizedStringResource("edit_feed.op.delete", defaultValue: "削除", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 差戻し — 編集の操作のバッジ (revert)
        static var opRevert: LocalizedStringResource {
            LocalizedStringResource("edit_feed.op.revert", defaultValue: "差戻し", table: "EditFeed", bundle: L10n.bundle)
        }
        /// セトリ更新 — 編集の操作のバッジ (snapshot (公演のセトリをまとめて更新))
        static var opSnapshot: LocalizedStringResource {
            LocalizedStringResource("edit_feed.op.snapshot", defaultValue: "セトリ更新", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 更新 — 編集の操作のバッジ (update / replace)
        static var opUpdate: LocalizedStringResource {
            LocalizedStringResource("edit_feed.op.update", defaultValue: "更新", table: "EditFeed", bundle: L10n.bundle)
        }
        /// ライブ・イベント — 編集されたレコードの種類 (Event)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeEvent: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.event", defaultValue: "ライブ・イベント", table: "EditFeed", bundle: L10n.bundle)
        }
        /// アイドル — 編集されたレコードの種類 (Idol)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeIdol: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.idol", defaultValue: "アイドル", table: "EditFeed", bundle: L10n.bundle)
        }
        /// セットリスト — 編集されたレコードの種類 (SetlistItem / ShowSetlist)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeSetlist: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.setlist", defaultValue: "セットリスト", table: "EditFeed", bundle: L10n.bundle)
        }
        /// セトリ出演者 — 編集されたレコードの種類 (SetlistPerformer)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeSetlistPerformer: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.setlist_performer", defaultValue: "セトリ出演者", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 公演 — 編集されたレコードの種類 (Show)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeShow: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.show", defaultValue: "公演", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 出演キャスト — 編集されたレコードの種類 (ShowCast)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeShowCast: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.show_cast", defaultValue: "出演キャスト", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 楽曲 — 編集されたレコードの種類 (Song)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeSong: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.song", defaultValue: "楽曲", table: "EditFeed", bundle: L10n.bundle)
        }
        /// 楽曲アーティスト — 編集されたレコードの種類 (SongArtist)。対象の名前が引けないときにカードの題に出す。変更履歴のシートの副題にも使う
        static var recordTypeSongArtist: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.song_artist", defaultValue: "楽曲アーティスト", table: "EditFeed", bundle: L10n.bundle)
        }
        /// コーレス (終了) — 編集されたレコードの種類 (SongCall)。2026-09-06 に終わった投稿の種類で、過去の履歴だけに出る
        static var recordTypeSongCall: LocalizedStringResource {
            LocalizedStringResource("edit_feed.record_type.song_call", defaultValue: "コーレス (終了)", table: "EditFeed", bundle: L10n.bundle)
        }
    }
}
