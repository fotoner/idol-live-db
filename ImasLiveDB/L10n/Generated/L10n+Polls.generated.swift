// 生成物: i18n/catalog/polls.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/polls.json の文言 (表 Polls)
    enum Polls {
        /// 閉じる — 曲・アイドル・ユニット詳細の実績バッジから開いたお題詳細のシートを閉じるボタン
        static var achievementsSheetClose: LocalizedStringResource {
            LocalizedStringResource("polls.achievements.sheet.close", defaultValue: "閉じる", table: "Polls", bundle: L10n.bundle)
        }
        /// キャンセル — 投票の画面のキャンセルボタン (iOS: お題作成のツールバー・削除の確認。Android: お題作成・候補ピッカー・削除の確認ダイアログ)
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("polls.action.cancel", defaultValue: "キャンセル", table: "Polls", bundle: L10n.bundle)
        }
        /// OK — お題の削除に失敗したときのアラートを閉じるボタン
        static var actionOk: LocalizedStringResource {
            LocalizedStringResource("polls.action.ok", defaultValue: "OK", table: "Polls", bundle: L10n.bundle)
        }
        /// 説明（任意） — お題作成シートの説明の欄の見出し。任意 = 書かなくてよい
        static var createDescriptionFieldHeader: LocalizedStringResource {
            LocalizedStringResource("polls.create.description_field.header", defaultValue: "説明（任意）", table: "Polls", bundle: L10n.bundle)
        }
        /// 補足やルールがあれば（任意） — お題作成シートの説明の欄のプレースホルダ
        static var createDescriptionFieldPlaceholder: LocalizedStringResource {
            LocalizedStringResource("polls.create.description_field.placeholder", defaultValue: "補足やルールがあれば（任意）", table: "Polls", bundle: L10n.bundle)
        }
        /// {days}日間 — 募集期間の選択肢 (7 / 14 / 30 日間) — 引数: days (count)
        static func createDurationDays(days: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.create.duration.days", defaultValue: "\(days)日間", table: "Polls", bundle: L10n.bundle)
        }
        /// 募集期間 — お題作成シートの投票を受け付ける期間の節の見出し
        static var createDurationHeader: LocalizedStringResource {
            LocalizedStringResource("polls.create.duration.header", defaultValue: "募集期間", table: "Polls", bundle: L10n.bundle)
        }
        /// 作成に失敗しました。時間をおいて再試行してください。 — お題の作成に失敗したとき (サーバからの説明が無いとき)
        static var createErrorFailed: LocalizedStringResource {
            LocalizedStringResource("polls.create.error.failed", defaultValue: "作成に失敗しました。時間をおいて再試行してください。", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補アイドル — 候補指定でアイドルを選ぶピッカーのナビゲーションタイトル (短く)
        static var createIdolPickerTitle: LocalizedStringResource {
            LocalizedStringResource("polls.create.idol_picker.title", defaultValue: "候補アイドル", table: "Polls", bundle: L10n.bundle)
        }
        /// お題を作って、みんなに推しを投票してもらおう。期間中は誰でも{limit}票まで投票できます。 — お題作成シートの先頭の説明。推し = 好きなアイドル・曲。limit は 1 人が入れられる票の数 (今は 3) — 引数: limit (count)
        static func createIntro(limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.create.intro", defaultValue: "お題を作って、みんなに推しを投票してもらおう。期間中は誰でも\(limit)票まで投票できます。", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補を追加 — 候補指定で候補を選ぶピッカーを開くボタン
        static var createScopeAddCandidate: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.add_candidate", defaultValue: "候補を追加", table: "Polls", bundle: L10n.bundle)
        }
        /// 全て — 候補の範囲の切り替え: すべての曲・アイドル・ユニットが候補
        static var createScopeAll: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.all", defaultValue: "全て", table: "Polls", bundle: L10n.bundle)
        }
        /// 全{target}から自由に投票できます。 — 候補の範囲が「全て」のときの説明。target は投票対象の種類 (target.song / target.idol / target.unit) — 引数: target (text)
        static func createScopeAllHint(target: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.all_hint", defaultValue: "全\(target)から自由に投票できます。", table: "Polls", bundle: L10n.bundle)
        }
        /// ブランド限定 — 候補の範囲の切り替え: 選んだブランドのものだけが候補
        static var createScopeBrand: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.brand", defaultValue: "ブランド限定", table: "Polls", bundle: L10n.bundle)
        }
        /// チェックしたブランドの{target}だけが候補になります。複数選択可。 — 候補の範囲が「ブランド限定」のときの説明。target は投票対象の種類 (target.*) — 引数: target (text)
        static func createScopeBrandHint(target: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.brand_hint", defaultValue: "チェックしたブランドの\(target)だけが候補になります。複数選択可。", table: "Polls", bundle: L10n.bundle)
        }
        /// 1つ以上選択してください — ブランド限定でブランドを 1 つも選んでいないときの案内
        static var createScopeBrandRequired: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.brand_required", defaultValue: "1つ以上選択してください", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票候補 — お題作成シートの候補の範囲を選ぶ節の見出し
        static var createScopeHeader: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.header", defaultValue: "投票候補", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補指定 — 候補の範囲の切り替え: 作成者が選んだものだけが候補
        static var createScopeManual: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.manual", defaultValue: "候補指定", table: "Polls", bundle: L10n.bundle)
        }
        /// 「候補を追加」から選んでください — 候補指定で候補を 1 つも選んでいないときの案内。「候補を追加」は下のボタン (create.scope.add_candidate)
        static var createScopeManualEmpty: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.manual_empty", defaultValue: "「候補を追加」から選んでください", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補は2件以上必要です。 — 候補指定のときの条件の説明
        static var createScopeManualMin: LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.manual_min", defaultValue: "候補は2件以上必要です。", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}件選択中 — 候補指定で今選んでいる候補の数 (上限 500 なので桁区切りは付かない) — 引数: count (count)
        static func createScopeManualSelected(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.create.scope.manual_selected", defaultValue: "\(count)件選択中", table: "Polls", bundle: L10n.bundle)
        }
        /// 作成 — お題作成シートの送信ボタン
        static var createSubmit: LocalizedStringResource {
            LocalizedStringResource("polls.create.submit", defaultValue: "作成", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票対象 — お題作成シートの対象 (曲 / アイドル / ユニット) を選ぶ節の見出し
        static var createTargetHeader: LocalizedStringResource {
            LocalizedStringResource("polls.create.target.header", defaultValue: "投票対象", table: "Polls", bundle: L10n.bundle)
        }
        /// お題を投稿 — お題作成シートの見出し
        static var createTitle: LocalizedStringResource {
            LocalizedStringResource("polls.create.title", defaultValue: "お題を投稿", table: "Polls", bundle: L10n.bundle)
        }
        /// タイトル — お題作成シートの題名の欄の見出し (Android は入力欄のラベル)
        static var createTitleFieldHeader: LocalizedStringResource {
            LocalizedStringResource("polls.create.title_field.header", defaultValue: "タイトル", table: "Polls", bundle: L10n.bundle)
        }
        /// 例: 夏に聴きたい曲は？ — お題作成シートの題名の欄のプレースホルダ。例の文も訳す
        static var createTitleFieldPlaceholder: LocalizedStringResource {
            LocalizedStringResource("polls.create.title_field.placeholder", defaultValue: "例: 夏に聴きたい曲は？", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補を追加して投票（残り{remaining}/{limit}） — ランキングに無い候補を選んで投票するボタン。remaining は残りの票、limit は 1 人が入れられる票の数 — 引数: remaining (int), limit (int)
        static func detailAddVoteButton(remaining: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.add_vote.button", defaultValue: "候補を追加して投票（残り\(String(remaining))/\(String(limit))）", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票済み（{voted}/{limit}） — 票を使い切ったときの、候補を追加するボタン (押せない)。voted と limit はどちらも 1 人が入れられる票の数 — 引数: voted (int), limit (int)
        static func detailAddVoteDone(voted: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.add_vote.done", defaultValue: "投票済み（\(String(voted))/\(String(limit))）", table: "Polls", bundle: L10n.bundle)
        }
        /// このお題を削除 — 詳細のツールバーのゴミ箱ボタンの読み上げ (作成者・管理者だけに出る)
        static var detailDeleteA11y: LocalizedStringResource {
            LocalizedStringResource("polls.detail.delete.a11y", defaultValue: "このお題を削除", table: "Polls", bundle: L10n.bundle)
        }
        /// 削除 — お題を削除する前の確認の実行ボタン
        static var detailDeleteConfirmAction: LocalizedStringResource {
            LocalizedStringResource("polls.detail.delete_confirm.action", defaultValue: "削除", table: "Polls", bundle: L10n.bundle)
        }
        /// ランキング・投票データも一緒に削除され、元に戻せません。 — お題を削除する前の確認の本文
        static var detailDeleteConfirmMessage: LocalizedStringResource {
            LocalizedStringResource("polls.detail.delete_confirm.message", defaultValue: "ランキング・投票データも一緒に削除され、元に戻せません。", table: "Polls", bundle: L10n.bundle)
        }
        /// このお題を削除しますか？ — お題を削除する前の確認の見出し
        static var detailDeleteConfirmTitle: LocalizedStringResource {
            LocalizedStringResource("polls.detail.delete_confirm.title", defaultValue: "このお題を削除しますか？", table: "Polls", bundle: L10n.bundle)
        }
        /// エラー — お題の削除に失敗したときのアラートの見出し
        static var detailDeleteErrorTitle: LocalizedStringResource {
            LocalizedStringResource("polls.detail.delete_error.title", defaultValue: "エラー", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票を取消 — ランキングの行の投票ボタンの読み上げ (投票済みの候補。押すと取り消す)
        static var detailEntryUnvoteA11y: LocalizedStringResource {
            LocalizedStringResource("polls.detail.entry.unvote.a11y", defaultValue: "投票を取消", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票 — ランキングの行の投票ボタンの読み上げ (まだ投票していない候補)
        static var detailEntryVoteA11y: LocalizedStringResource {
            LocalizedStringResource("polls.detail.entry.vote.a11y", defaultValue: "投票", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}票 — ランキングの行の票の数。1000 以上は桁区切りが付く — 引数: count (count)
        static func detailEntryVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.entry.votes", defaultValue: "\(count)票", table: "Polls", bundle: L10n.bundle)
        }
        /// 削除に失敗しました。時間をおいて再試行してください。 — お題の削除に失敗したときの本文 (サーバからの説明が無いとき)
        static var detailErrorDeleteFailed: LocalizedStringResource {
            LocalizedStringResource("polls.detail.error.delete_failed", defaultValue: "削除に失敗しました。時間をおいて再試行してください。", table: "Polls", bundle: L10n.bundle)
        }
        /// 取消できませんでした — 投票の取り消しに失敗したときに詳細に出す赤い文
        static var detailErrorUnvoteFailed: LocalizedStringResource {
            LocalizedStringResource("polls.detail.error.unvote_failed", defaultValue: "取消できませんでした", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票できませんでした — 投票に失敗したときに詳細に出す赤い文
        static var detailErrorVoteFailed: LocalizedStringResource {
            LocalizedStringResource("polls.detail.error.vote_failed", defaultValue: "投票できませんでした", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票する — アイドルのお題で候補を選ぶピッカーのナビゲーションタイトル (短く)
        static var detailIdolPickerTitle: LocalizedStringResource {
            LocalizedStringResource("polls.detail.idol_picker.title", defaultValue: "投票する", table: "Polls", bundle: L10n.bundle)
        }
        /// あなたの投票 {count}/{limit} — 自分の投票のシェアの横に出す、入れた票の数 / 1 人が入れられる票の数 — 引数: count (int), limit (int)
        static func detailMyVotesProgress(count: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.my_votes.progress", defaultValue: "あなたの投票 \(String(count))/\(String(limit))", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}人 — ランキングの見出しの右に出す候補の数 (アイドルのお題)。1000 以上は桁区切りが付く (もとは桁区切りなし) — 引数: count (count)
        static func detailRankingCountIdol(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.count.idol", defaultValue: "\(count)人", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}曲 — ランキングの見出しの右に出す候補の数 (曲のお題)。1000 以上は桁区切りが付く (もとは桁区切りなし) — 引数: count (count)
        static func detailRankingCountSong(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.count.song", defaultValue: "\(count)曲", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}組 — ランキングの見出しの右に出す候補の数 (ユニットのお題)。1000 以上は桁区切りが付く (もとは桁区切りなし) — 引数: count (count)
        static func detailRankingCountUnit(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.count.unit", defaultValue: "\(count)組", table: "Polls", bundle: L10n.bundle)
        }
        /// 最初の一票を入れましょう！ — ランキングに 1 票も無いときの空状態の誘い文句
        static var detailRankingEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.empty.message", defaultValue: "最初の一票を入れましょう！", table: "Polls", bundle: L10n.bundle)
        }
        /// まだ票がありません — ランキングに 1 票も無いときの空状態の見出し
        static var detailRankingEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.empty.title", defaultValue: "まだ票がありません", table: "Polls", bundle: L10n.bundle)
        }
        /// ランキング — 詳細の票数の順位の節の見出し (右に候補の数)
        static var detailRankingHeader: LocalizedStringResource {
            LocalizedStringResource("polls.detail.ranking.header", defaultValue: "ランキング", table: "Polls", bundle: L10n.bundle)
        }
        /// 候補{count}件から選択 — 詳細の見出しの下のチップ。作成者が候補を指定したお題で、その候補の数 (上限 500 なので桁区切りは付かない) — 引数: count (count)
        static func detailScopeManual(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.scope.manual", defaultValue: "候補\(count)件から選択", table: "Polls", bundle: L10n.bundle)
        }
        /// 自分の投票をシェア — 自分が投票した候補をシェアするボタンの読み上げ
        static var detailShareVotesA11y: LocalizedStringResource {
            LocalizedStringResource("polls.detail.share_votes.a11y", defaultValue: "自分の投票をシェア", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票をシェア — 自分が投票した候補をシェアするボタン
        static var detailShareVotesButton: LocalizedStringResource {
            LocalizedStringResource("polls.detail.share_votes.button", defaultValue: "投票をシェア", table: "Polls", bundle: L10n.bundle)
        }
        /// お題 — お題詳細のナビゲーションタイトル。お題を読み込む前・失敗したときだけ出る (読めたらお題の題名)
        static var detailTitleFallback: LocalizedStringResource {
            LocalizedStringResource("polls.detail.title_fallback", defaultValue: "お題", table: "Polls", bundle: L10n.bundle)
        }
        /// 👍 上のランキングをタップで投票/取消（残り{remaining}/{limit}） — 開催中のお題で、ランキングの行を押すと投票・取り消しができることの案内。remaining は残りの票、limit は 1 人が入れられる票の数 — 引数: remaining (int), limit (int)
        static func detailVoteHint(remaining: Int, limit: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.detail.vote_hint", defaultValue: "👍 上のランキングをタップで投票/取消（残り\(String(remaining))/\(String(limit))）", table: "Polls", bundle: L10n.bundle)
        }
        /// 通信エラー — お題の一覧・殿堂の読み込みに失敗し、サーバからの説明も無いときの説明
        static var errorNetwork: LocalizedStringResource {
            LocalizedStringResource("polls.error.network", defaultValue: "通信エラー", table: "Polls", bundle: L10n.bundle)
        }
        /// お題が終了すると、ここに優勝した曲やアイドルが並びます。 — 殿堂に 1 件も無いときの空状態の説明
        static var hallOfFameEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("polls.hall_of_fame.empty.message", defaultValue: "お題が終了すると、ここに優勝した曲やアイドルが並びます。", table: "Polls", bundle: L10n.bundle)
        }
        /// まだ優勝者がいません — 殿堂に 1 件も無いときの空状態の見出し
        static var hallOfFameEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("polls.hall_of_fame.empty.title", defaultValue: "まだ優勝者がいません", table: "Polls", bundle: L10n.bundle)
        }
        /// {count}票 — 殿堂の行の優勝者の票の数。1000 以上は桁区切りが付く (Android はもとは桁区切りなし) — 引数: count (count)
        static func hallOfFameRowVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.hall_of_fame.row.votes", defaultValue: "\(count)票", table: "Polls", bundle: L10n.bundle)
        }
        /// 優勝 — 殿堂の行の右に出す札 (そのお題で 1 位)
        static var hallOfFameRowWinner: LocalizedStringResource {
            LocalizedStringResource("polls.hall_of_fame.row.winner", defaultValue: "優勝", table: "Polls", bundle: L10n.bundle)
        }
        /// 殿堂 — 終了したお題の優勝者を並べる画面のタイトル
        static var hallOfFameTitle: LocalizedStringResource {
            LocalizedStringResource("polls.hall_of_fame.title", defaultValue: "殿堂", table: "Polls", bundle: L10n.bundle)
        }
        /// お題を作成 — 一覧の右上の ＋ ボタンの読み上げ
        static var listCreateA11y: LocalizedStringResource {
            LocalizedStringResource("polls.list.create.a11y", defaultValue: "お題を作成", table: "Polls", bundle: L10n.bundle)
        }
        /// 右上の「＋」から新しいお題を投稿できます。 — 開催中のお題が 1 件も無いときの空状態の説明。＋ は右上の作成ボタン
        static var listEmptyActiveMessage: LocalizedStringResource {
            LocalizedStringResource("polls.list.empty.active.message", defaultValue: "右上の「＋」から新しいお題を投稿できます。", table: "Polls", bundle: L10n.bundle)
        }
        /// 開催中のお題がありません — 開催中のお題が 1 件も無いときの空状態の見出し
        static var listEmptyActiveTitle: LocalizedStringResource {
            LocalizedStringResource("polls.list.empty.active.title", defaultValue: "開催中のお題がありません", table: "Polls", bundle: L10n.bundle)
        }
        /// 終了したお題がありません — 終了したお題が 1 件も無いときの空状態の見出し
        static var listEmptyEndedTitle: LocalizedStringResource {
            LocalizedStringResource("polls.list.empty.ended.title", defaultValue: "終了したお題がありません", table: "Polls", bundle: L10n.bundle)
        }
        /// 殿堂を見る — 一覧の左上の王冠ボタンの読み上げ (終了したお題の優勝者の一覧へ)
        static var listHallOfFameA11y: LocalizedStringResource {
            LocalizedStringResource("polls.list.hall_of_fame.a11y", defaultValue: "殿堂を見る", table: "Polls", bundle: L10n.bundle)
        }
        /// 計{count}票 — 一覧の行に出す、お題の票の合計。1000 以上は桁区切りが付く (1,234票。Android はもとは桁区切りなし) — 引数: count (count)
        static func listRowTotalVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.list.row.total_votes", defaultValue: "計\(count)票", table: "Polls", bundle: L10n.bundle)
        }
        /// 開催中 — お題一覧の切り替え (開催中 / 終了)
        static var listSegmentActive: LocalizedStringResource {
            LocalizedStringResource("polls.list.segment.active", defaultValue: "開催中", table: "Polls", bundle: L10n.bundle)
        }
        /// 終了 — お題一覧の切り替え (開催中 / 終了)
        static var listSegmentEnded: LocalizedStringResource {
            LocalizedStringResource("polls.list.segment.ended", defaultValue: "終了", table: "Polls", bundle: L10n.bundle)
        }
        /// みんなの投票 — お題一覧のナビゲーションタイトル (機能の名前)
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("polls.list.title", defaultValue: "みんなの投票", table: "Polls", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました — お題の一覧・詳細・殿堂の読み込みに失敗したときの空状態の見出し
        static var loadErrorTitle: LocalizedStringResource {
            LocalizedStringResource("polls.load_error.title", defaultValue: "読み込みに失敗しました", table: "Polls", bundle: L10n.bundle)
        }
        /// 投票にはログインが必要です — 未ログインの人に出す案内 (iOS: 詳細のインラインのログイン導線。Android: 一覧・詳細のバナー)
        static var loginPromptMessage: LocalizedStringResource {
            LocalizedStringResource("polls.login_prompt.message", defaultValue: "投票にはログインが必要です", table: "Polls", bundle: L10n.bundle)
        }
        /// (削除済み) — 投票した候補の曲・アイドル・ユニットがデータから消えていて名前を出せないとき
        static var myVotesDeletedChoice: LocalizedStringResource {
            LocalizedStringResource("polls.my_votes.deleted_choice", defaultValue: "(削除済み)", table: "Polls", bundle: L10n.bundle)
        }
        /// みんなの投票でお題に投票すると、ここに履歴が残ります — 投票の履歴が 1 件も無いときの空状態の説明。みんなの投票 = 機能の名前 (list.title)
        static var myVotesEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("polls.my_votes.empty.message", defaultValue: "みんなの投票でお題に投票すると、ここに履歴が残ります", table: "Polls", bundle: L10n.bundle)
        }
        /// まだ投票していません — 投票の履歴が 1 件も無いときの空状態の見出し
        static var myVotesEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("polls.my_votes.empty.title", defaultValue: "まだ投票していません", table: "Polls", bundle: L10n.bundle)
        }
        /// マイ投票 — 自分が投票したお題の履歴の画面のタイトル
        static var myVotesTitle: LocalizedStringResource {
            LocalizedStringResource("polls.my_votes.title", defaultValue: "マイ投票", table: "Polls", bundle: L10n.bundle)
        }
        /// ブランド限定 — お題の候補の範囲を示す小さなバッジ。1 つのブランドの曲・アイドル・ユニットだけが候補
        static var scopeBadgeBrand: LocalizedStringResource {
            LocalizedStringResource("polls.scope.badge.brand", defaultValue: "ブランド限定", table: "Polls", bundle: L10n.bundle)
        }
        /// ブランド限定×{count} — お題の候補の範囲を示す小さなバッジ。count は候補に選ばれたブランドの数 (2 以上)。助数詞が無いので int — 引数: count (int)
        static func scopeBadgeBrandMulti(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.scope.badge.brand_multi", defaultValue: "ブランド限定×\(String(count))", table: "Polls", bundle: L10n.bundle)
        }
        /// 指定候補{count}件 — お題の候補の範囲を示す小さなバッジ。作成者が指定した候補の数 (上限 500 なので桁区切りは付かない) — 引数: count (count)
        static func scopeBadgeManual(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.scope.badge.manual", defaultValue: "指定候補\(count)件", table: "Polls", bundle: L10n.bundle)
        }
        /// このお題をシェア — お題そのものをシェアするボタンの読み上げ (iOS: 詳細のツールバー。Android: 一覧の行と詳細のツールバー)
        static var sharePollA11y: LocalizedStringResource {
            LocalizedStringResource("polls.share_poll.a11y", defaultValue: "このお題をシェア", table: "Polls", bundle: L10n.bundle)
        }
        /// 本日締切 — お題の状態の札。今日が締切の開催中のお題
        static var statusClosesToday: LocalizedStringResource {
            LocalizedStringResource("polls.status.closes_today", defaultValue: "本日締切", table: "Polls", bundle: L10n.bundle)
        }
        /// 残り{days}日 — お題の状態の札。締切までの日数。ふつうは最長 30 日で桁区切りは付かない。Android で締切が不明 (endsAtMs = Long.MAX_VALUE) のときだけ Int.MAX_VALUE に頭打ちになり 2,147,483,647 と桁区切り付きで出る (もとは Long のままの日数で 1067 億あまり、桁区切りなし) — 引数: days (count)
        static func statusDaysLeft(days: Int) -> LocalizedStringResource {
            LocalizedStringResource("polls.status.days_left", defaultValue: "残り\(days)日", table: "Polls", bundle: L10n.bundle)
        }
        /// 終了 — お題の状態の札。締切を過ぎた (または止められた) お題
        static var statusEnded: LocalizedStringResource {
            LocalizedStringResource("polls.status.ended", defaultValue: "終了", table: "Polls", bundle: L10n.bundle)
        }
        /// アイドル — お題の投票対象の種類 (アイドル)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る
        static var targetIdol: LocalizedStringResource {
            LocalizedStringResource("polls.target.idol", defaultValue: "アイドル", table: "Polls", bundle: L10n.bundle)
        }
        /// 曲 — お題の投票対象の種類 (曲)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る
        static var targetSong: LocalizedStringResource {
            LocalizedStringResource("polls.target.song", defaultValue: "曲", table: "Polls", bundle: L10n.bundle)
        }
        /// ユニット — お題の投票対象の種類 (ユニット)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る
        static var targetUnit: LocalizedStringResource {
            LocalizedStringResource("polls.target.unit", defaultValue: "ユニット", table: "Polls", bundle: L10n.bundle)
        }
    }
}
