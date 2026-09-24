// 生成物: i18n/catalog/mypage.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/mypage.json の文言 (表 Mypage)
    enum Mypage {
        /// {count}件 — 参加したライブ一覧の件数 (リストの節の見出し)。1000 以上は桁区切りが付く (1,234件) — 引数: count (count)
        static func attendedCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mypage.attended.count", defaultValue: "\(count)件", table: "Mypage", bundle: L10n.bundle)
        }
        /// 現地参加のライブがありません — 参加したライブ一覧で「現地」(または「すべて」) に 1 件も無いときの空状態
        static var attendedEmptyLive: LocalizedStringResource {
            LocalizedStringResource("mypage.attended.empty.live", defaultValue: "現地参加のライブがありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// ライブビューイング参加のライブがありません — 参加したライブ一覧で「ライブビューイング」(映画館での中継) に 1 件も無いときの空状態
        static var attendedEmptyLiveViewing: LocalizedStringResource {
            LocalizedStringResource("mypage.attended.empty.live_viewing", defaultValue: "ライブビューイング参加のライブがありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// 配信参加のライブがありません — 参加したライブ一覧で「配信」に 1 件も無いときの空状態
        static var attendedEmptyStream: LocalizedStringResource {
            LocalizedStringResource("mypage.attended.empty.stream", defaultValue: "配信参加のライブがありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// すべて — 参加したライブ一覧の絞り込みセグメントの先頭 (形態で絞らない)。ほかの選択肢 (現地・配信・LV) はコアの語彙をそのまま出す
        static var attendedFilterAll: LocalizedStringResource {
            LocalizedStringResource("mypage.attended.filter.all", defaultValue: "すべて", table: "Mypage", bundle: L10n.bundle)
        }
        /// 参加したライブ — 参加したライブ一覧の画面タイトル (プロデュースの「参加したライブ すべて見る」から開く)
        static var attendedTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.attended.title", defaultValue: "参加したライブ", table: "Mypage", bundle: L10n.bundle)
        }
        /// ブロンズ — 貢献バッジの段階: 銅
        static var badgeTierBronze: LocalizedStringResource {
            LocalizedStringResource("mypage.badge.tier.bronze", defaultValue: "ブロンズ", table: "Mypage", bundle: L10n.bundle)
        }
        /// ゴールド — 貢献バッジの段階: 金
        static var badgeTierGold: LocalizedStringResource {
            LocalizedStringResource("mypage.badge.tier.gold", defaultValue: "ゴールド", table: "Mypage", bundle: L10n.bundle)
        }
        /// なし — 貢献バッジの段階: まだ無い
        static var badgeTierNone: LocalizedStringResource {
            LocalizedStringResource("mypage.badge.tier.none", defaultValue: "なし", table: "Mypage", bundle: L10n.bundle)
        }
        /// プラチナ — 貢献バッジの段階: 最上位
        static var badgeTierPlatinum: LocalizedStringResource {
            LocalizedStringResource("mypage.badge.tier.platinum", defaultValue: "プラチナ", table: "Mypage", bundle: L10n.bundle)
        }
        /// シルバー — 貢献バッジの段階: 銀
        static var badgeTierSilver: LocalizedStringResource {
            LocalizedStringResource("mypage.badge.tier.silver", defaultValue: "シルバー", table: "Mypage", bundle: L10n.bundle)
        }
        /// 内訳 — 投稿の種類ごとの件数を並べる節の見出し
        static var contributionsBreakdownHeader: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.breakdown.header", defaultValue: "内訳", table: "Mypage", bundle: L10n.bundle)
        }
        /// ライブ・楽曲・セトリの編集履歴 — 上の行の補足 (何の編集が並ぶか)
        static var contributionsEditsLinkCaption: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.edits_link.caption", defaultValue: "ライブ・楽曲・セトリの編集履歴", table: "Mypage", bundle: L10n.bundle)
        }
        /// 自分の編集を確認・取り消す — マイ投稿の画面から自分の編集一覧へ進む行の見出し。取り消す = サーバに記録された編集を元に戻す
        static var contributionsEditsLinkTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.edits_link.title", defaultValue: "自分の編集を確認・取り消す", table: "Mypage", bundle: L10n.bundle)
        }
        /// セトリ編集・動画追加・タグ追加が累計に含まれます。再インストールするとカウントはリセットされます (端末ローカル記録)。 — マイ投稿の画面の下の注意書き。数は端末にだけ記録している
        static var contributionsHelp: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.help", defaultValue: "セトリ編集・動画追加・タグ追加が累計に含まれます。再インストールするとカウントはリセットされます (端末ローカル記録)。", table: "Mypage", bundle: L10n.bundle)
        }
        /// セトリ編集 — 投稿の種類: セットリストの編集
        static var contributionsKindSetlistEdit: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.kind.setlist_edit", defaultValue: "セトリ編集", table: "Mypage", bundle: L10n.bundle)
        }
        /// タグ — 投稿の種類: タグの追加
        static var contributionsKindTag: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.kind.tag", defaultValue: "タグ", table: "Mypage", bundle: L10n.bundle)
        }
        /// 動画 — 投稿の種類: 参考動画の追加
        static var contributionsKindVideo: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.kind.video", defaultValue: "動画", table: "Mypage", bundle: L10n.bundle)
        }
        /// マイ投稿 — 自分の投稿累計の画面タイトル (プロデュースの「投稿」タイルから開く)。投稿 = セトリ編集・動画追加・タグ追加
        static var contributionsTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.title", defaultValue: "マイ投稿", table: "Mypage", bundle: L10n.bundle)
        }
        /// コミュニティへの投稿累計 — 累計の大きな数字の下の説明
        static var contributionsTotalCaption: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.total_caption", defaultValue: "コミュニティへの投稿累計", table: "Mypage", bundle: L10n.bundle)
        }
        /// 件 — 投稿の件数の右に添える単位。数字は大きく別に出すので単位だけの文言 (累計のカードと内訳の各行)
        static var contributionsUnit: LocalizedStringResource {
            LocalizedStringResource("mypage.contributions.unit", defaultValue: "件", table: "Mypage", bundle: L10n.bundle)
        }
        /// 取り消す — 編集を取り消す (編集前に戻す) ボタン。各行のボタンと確認ダイアログの実行ボタン
        static var editsActionRevert: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.action.revert", defaultValue: "取り消す", table: "Mypage", bundle: L10n.bundle)
        }
        /// ライブ・楽曲・セトリを編集すると、ここに履歴が残り、後から取り消せます。 — 自分の編集が 1 件も無いときの空状態の説明
        static var editsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.empty.message", defaultValue: "ライブ・楽曲・セトリを編集すると、ここに履歴が残り、後から取り消せます。", table: "Mypage", bundle: L10n.bundle)
        }
        /// まだ編集がありません — 自分の編集が 1 件も無いときの空状態の見出し
        static var editsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.empty.title", defaultValue: "まだ編集がありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// 認証の有効期限が切れています。再度サインインしてください。 — 取り消しでログインの期限切れが分かったとき
        static var editsErrorAuthExpired: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.auth_expired", defaultValue: "認証の有効期限が切れています。再度サインインしてください。", table: "Mypage", bundle: L10n.bundle)
        }
        /// 別のユーザーがこの後に編集したため取り消せませんでした。 — 取り消そうとした編集の後に別の人の編集があって、取り消せなかったとき
        static var editsErrorConflict: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.conflict", defaultValue: "別のユーザーがこの後に編集したため取り消せませんでした。", table: "Mypage", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました: {detail} — 自分の編集一覧の読み込みが失敗したとき。detail = OS やサーバのエラー文 — 引数: detail (string)
        static func editsErrorLoadFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.load_failed", defaultValue: "読み込みに失敗しました: \(detail)", table: "Mypage", bundle: L10n.bundle)
        }
        /// 操作が多すぎます。しばらく待ってからお試しください。 — 自分の編集一覧の読み込みがレート制限 (429) に当たったとき
        static var editsErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.rate_limited", defaultValue: "操作が多すぎます。しばらく待ってからお試しください。", table: "Mypage", bundle: L10n.bundle)
        }
        /// 取り消しに失敗しました: {detail} — 取り消しの通信が失敗したとき。detail = OS やサーバのエラー文 — 引数: detail (string)
        static func editsErrorRevertFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.revert_failed", defaultValue: "取り消しに失敗しました: \(detail)", table: "Mypage", bundle: L10n.bundle)
        }
        /// 取り消せませんでした ({outcome})。 — 取り消しがほかの理由で行われなかったとき。outcome = サーバの結果の表示名 (管理者画面と共用の語。今は訳さずそのまま出る) — 引数: outcome (string)
        static func editsErrorRevertOutcome(outcome: String) -> LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.revert_outcome", defaultValue: "取り消せませんでした (\(outcome))。", table: "Mypage", bundle: L10n.bundle)
        }
        /// エラー — 自分の編集一覧で失敗したときのアラートの見出し
        static var editsErrorTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.error.title", defaultValue: "エラー", table: "Mypage", bundle: L10n.bundle)
        }
        /// 読み込み中... — 自分の編集一覧の最初の読み込み中の表示
        static var editsLoading: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.loading", defaultValue: "読み込み中...", table: "Mypage", bundle: L10n.bundle)
        }
        /// やめる — 取り消しの確認ダイアログで何もしないで閉じるボタン
        static var editsRevertCancel: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.revert.cancel", defaultValue: "やめる", table: "Mypage", bundle: L10n.bundle)
        }
        /// 「{summary}」を編集前の状態に戻します。この操作も履歴に記録されます。 — 取り消しの確認ダイアログの本文。summary = 編集の要約 (サーバの文言) か、無ければ記録の種類名 — 引数: summary (string)
        static func editsRevertConfirmMessage(summary: String) -> LocalizedStringResource {
            LocalizedStringResource("mypage.edits.revert.confirm_message", defaultValue: "「\(summary)」を編集前の状態に戻します。この操作も履歴に記録されます。", table: "Mypage", bundle: L10n.bundle)
        }
        /// この編集を取り消しますか？ — 編集を取り消す前の確認ダイアログの見出し
        static var editsRevertConfirmTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.revert.confirm_title", defaultValue: "この編集を取り消しますか？", table: "Mypage", bundle: L10n.bundle)
        }
        /// 差戻し済み — 取り消し済みの編集の行に付く小さなバッジ。編集履歴のバッジ (edit_feed.badge.reverted) と訳をそろえる
        static var editsRowReverted: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.row.reverted", defaultValue: "差戻し済み", table: "Mypage", bundle: L10n.bundle)
        }
        /// 自分の編集 — 自分の編集一覧の画面タイトル。サーバに記録された編集を後から取り消せる
        static var editsTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.edits.title", defaultValue: "自分の編集", table: "Mypage", bundle: L10n.bundle)
        }
        /// {count}件 — お気に入りのライブの件数 (リストの節の見出し)。1000 以上は桁区切りが付く — 引数: count (count)
        static func favoritesEventsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.events.count", defaultValue: "\(count)件", table: "Mypage", bundle: L10n.bundle)
        }
        /// お気に入りのライブがありません — お気に入りのライブが 1 つも無いときの空状態
        static var favoritesEventsEmpty: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.events.empty", defaultValue: "お気に入りのライブがありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// {count}人 — お気に入りのアイドルの人数 (リストの節の見出し)。1000 以上は桁区切りが付く — 引数: count (count)
        static func favoritesIdolsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.idols.count", defaultValue: "\(count)人", table: "Mypage", bundle: L10n.bundle)
        }
        /// お気に入りのアイドルがいません — お気に入りのアイドルが 1 人もいないときの空状態
        static var favoritesIdolsEmpty: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.idols.empty", defaultValue: "お気に入りのアイドルがいません", table: "Mypage", bundle: L10n.bundle)
        }
        /// {count}曲 — お気に入りの曲の数 (リストの節の見出し)。1000 以上は桁区切りが付く (1,234曲) — 引数: count (count)
        static func favoritesSongsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.songs.count", defaultValue: "\(count)曲", table: "Mypage", bundle: L10n.bundle)
        }
        /// お気に入りの曲がありません — お気に入りの曲が 1 つも無いときの空状態
        static var favoritesSongsEmpty: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.songs.empty", defaultValue: "お気に入りの曲がありません", table: "Mypage", bundle: L10n.bundle)
        }
        /// ライブ — お気に入り一覧のセグメント: ライブ (イベント)
        static var favoritesTabEvents: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.tab.events", defaultValue: "ライブ", table: "Mypage", bundle: L10n.bundle)
        }
        /// アイドル — お気に入り一覧のセグメント: アイドル
        static var favoritesTabIdols: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.tab.idols", defaultValue: "アイドル", table: "Mypage", bundle: L10n.bundle)
        }
        /// 曲 — お気に入り一覧のセグメント: 曲
        static var favoritesTabSongs: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.tab.songs", defaultValue: "曲", table: "Mypage", bundle: L10n.bundle)
        }
        /// お気に入り — お気に入り一覧の画面タイトル (プロデュースの「お気に入り」タイルから開く)
        static var favoritesTitle: LocalizedStringResource {
            LocalizedStringResource("mypage.favorites.title", defaultValue: "お気に入り", table: "Mypage", bundle: L10n.bundle)
        }
    }
}
