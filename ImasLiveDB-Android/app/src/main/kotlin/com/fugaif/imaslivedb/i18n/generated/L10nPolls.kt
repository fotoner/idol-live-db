// 生成物: i18n/catalog/polls.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/polls.json の文言。L10n.Polls から引く (iOS の L10n.Polls と同じ名前)。 */
object L10nPolls {
    /** キャンセル — 投票の画面のキャンセルボタン (iOS: お題作成のツールバー・削除の確認。Android: お題作成・候補ピッカー・削除の確認ダイアログ) */
    val actionCancel: DisplayText get() = DisplayText.Res(R.string.polls_action_cancel)
    /** OK — お題の削除に失敗したときのアラートを閉じるボタン */
    val actionOk: DisplayText get() = DisplayText.Res(R.string.polls_action_ok)
    /** {length} / {max}文字 — お題作成シートの入力欄の下の文字数 (Android。iOS は数字だけ)。length は今の文字数、max は上限 — 引数: length (int), max (int) */
    fun createCharCounter(length: Int, max: Int): DisplayText = DisplayText.Res(R.string.polls_create_char_counter, listOf(length, max))
    /** 説明(任意) — Android の文言。iOS の create.description_field.header と ja が違う (括弧が半角)。任意 = 書かなくてよい */
    val createDescriptionFieldHeaderAndroid: DisplayText get() = DisplayText.Res(R.string.polls_create_description_field_header_android)
    /** 補足やルールがあれば — Android の文言。iOS の create.description_field.placeholder と ja が違う */
    val createDescriptionFieldPlaceholderAndroid: DisplayText get() = DisplayText.Res(R.string.polls_create_description_field_placeholder_android)
    /** {days}日間 — 募集期間の選択肢 (7 / 14 / 30 日間) — 引数: days (count) */
    fun createDurationDays(days: Int): DisplayText = DisplayText.Plural(R.plurals.polls_create_duration_days, days, listOf(days))
    /** 募集期間 — お題作成シートの投票を受け付ける期間の節の見出し */
    val createDurationHeader: DisplayText get() = DisplayText.Res(R.string.polls_create_duration_header)
    /** 作成に失敗しました。時間をおいて再試行してください。 — お題の作成に失敗したとき (サーバからの説明が無いとき) */
    val createErrorFailed: DisplayText get() = DisplayText.Res(R.string.polls_create_error_failed)
    /** 本日のお題作成上限に達しました。明日また試してください。 — 1 日に作れるお題の数の上限に達したとき (Android) */
    val createErrorRateLimited: DisplayText get() = DisplayText.Res(R.string.polls_create_error_rate_limited)
    /** お題を作って、みんなに推しを投票してもらおう。期間中は誰でも{limit}票まで投票できます。 — お題作成シートの先頭の説明。推し = 好きなアイドル・曲。limit は 1 人が入れられる票の数 (今は 3) — 引数: limit (count) */
    fun createIntro(limit: Int): DisplayText = DisplayText.Plural(R.plurals.polls_create_intro, limit, listOf(limit))
    /** 候補を追加 — 候補指定で候補を選ぶピッカーを開くボタン */
    val createScopeAddCandidate: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_add_candidate)
    /** 全て — 候補の範囲の切り替え: すべての曲・アイドル・ユニットが候補 */
    val createScopeAll: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_all)
    /** 全{target}から自由に投票できます。 — 候補の範囲が「全て」のときの説明。target は投票対象の種類 (target.song / target.idol / target.unit) — 引数: target (text) */
    fun createScopeAllHint(target: DisplayText): DisplayText = DisplayText.Res(R.string.polls_create_scope_all_hint, listOf(target))
    /** ブランド限定 — 候補の範囲の切り替え: 選んだブランドのものだけが候補 */
    val createScopeBrand: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_brand)
    /** 選んだブランドの{target}だけが候補になります。複数選択可。 — Android の文言。iOS の create.scope.brand_hint と ja が違う。target は投票対象の種類 (target.*) — 引数: target (text) */
    fun createScopeBrandHintAndroid(target: DisplayText): DisplayText = DisplayText.Res(R.string.polls_create_scope_brand_hint_android, listOf(target))
    /** 1つ以上選択してください — ブランド限定でブランドを 1 つも選んでいないときの案内 */
    val createScopeBrandRequired: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_brand_required)
    /** 投票候補 — お題作成シートの候補の範囲を選ぶ節の見出し */
    val createScopeHeader: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_header)
    /** 候補指定 — 候補の範囲の切り替え: 作成者が選んだものだけが候補 */
    val createScopeManual: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_manual)
    /** 候補は2件以上必要です。 — 候補指定のときの条件の説明 */
    val createScopeManualMin: DisplayText get() = DisplayText.Res(R.string.polls_create_scope_manual_min)
    /** {count}件選択中 — 候補指定で今選んでいる候補の数 (上限 500 なので桁区切りは付かない) — 引数: count (count) */
    fun createScopeManualSelected(count: Int): DisplayText = DisplayText.Plural(R.plurals.polls_create_scope_manual_selected, count, listOf(count))
    /** 作成 — お題作成シートの送信ボタン */
    val createSubmit: DisplayText get() = DisplayText.Res(R.string.polls_create_submit)
    /** 投票対象 — お題作成シートの対象 (曲 / アイドル / ユニット) を選ぶ節の見出し */
    val createTargetHeader: DisplayText get() = DisplayText.Res(R.string.polls_create_target_header)
    /** お題を投稿 — お題作成シートの見出し */
    val createTitle: DisplayText get() = DisplayText.Res(R.string.polls_create_title)
    /** タイトル — お題作成シートの題名の欄の見出し (Android は入力欄のラベル) */
    val createTitleFieldHeader: DisplayText get() = DisplayText.Res(R.string.polls_create_title_field_header)
    /** 例: 夏に聴きたい曲は？ — お題作成シートの題名の欄のプレースホルダ。例の文も訳す */
    val createTitleFieldPlaceholder: DisplayText get() = DisplayText.Res(R.string.polls_create_title_field_placeholder)
    /** 候補を追加して投票 (残り{remaining}/{limit}) — Android の文言。iOS の detail.add_vote.button と ja が違う (括弧が半角)。remaining は残りの票、limit は 1 人が入れられる票の数 — 引数: remaining (int), limit (int) */
    fun detailAddVoteButtonAndroid(remaining: Int, limit: Int): DisplayText = DisplayText.Res(R.string.polls_detail_add_vote_button_android, listOf(remaining, limit))
    /** 投票済み ({voted}/{limit}) — Android の文言。iOS の detail.add_vote.done と ja が違う (括弧が半角)。voted と limit はどちらも 1 人が入れられる票の数 — 引数: voted (int), limit (int) */
    fun detailAddVoteDoneAndroid(voted: Int, limit: Int): DisplayText = DisplayText.Res(R.string.polls_detail_add_vote_done_android, listOf(voted, limit))
    /** このお題を削除 — 詳細のツールバーのゴミ箱ボタンの読み上げ (作成者・管理者だけに出る) */
    val detailDeleteA11y: DisplayText get() = DisplayText.Res(R.string.polls_detail_delete_a11y)
    /** 削除 — お題を削除する前の確認の実行ボタン */
    val detailDeleteConfirmAction: DisplayText get() = DisplayText.Res(R.string.polls_detail_delete_confirm_action)
    /** ランキング・投票データも一緒に削除され、元に戻せません。 — お題を削除する前の確認の本文 */
    val detailDeleteConfirmMessage: DisplayText get() = DisplayText.Res(R.string.polls_detail_delete_confirm_message)
    /** このお題を削除しますか？ — お題を削除する前の確認の見出し */
    val detailDeleteConfirmTitle: DisplayText get() = DisplayText.Res(R.string.polls_detail_delete_confirm_title)
    /** エラー — お題の削除に失敗したときのアラートの見出し */
    val detailDeleteErrorTitle: DisplayText get() = DisplayText.Res(R.string.polls_detail_delete_error_title)
    /** 投票を取消 — ランキングの行の投票ボタンの読み上げ (投票済みの候補。押すと取り消す) */
    val detailEntryUnvoteA11y: DisplayText get() = DisplayText.Res(R.string.polls_detail_entry_unvote_a11y)
    /** 投票 — ランキングの行の投票ボタンの読み上げ (まだ投票していない候補) */
    val detailEntryVoteA11y: DisplayText get() = DisplayText.Res(R.string.polls_detail_entry_vote_a11y)
    /** 削除に失敗しました。時間をおいて再試行してください。 — お題の削除に失敗したときの本文 (サーバからの説明が無いとき) */
    val detailErrorDeleteFailed: DisplayText get() = DisplayText.Res(R.string.polls_detail_error_delete_failed)
    /** あなたの投票 {count}/{limit} — 自分の投票のシェアの横に出す、入れた票の数 / 1 人が入れられる票の数 — 引数: count (int), limit (int) */
    fun detailMyVotesProgress(count: Int, limit: Int): DisplayText = DisplayText.Res(R.string.polls_detail_my_votes_progress, listOf(count, limit))
    /** 投票をシェア — 自分が投票した候補をシェアするボタン */
    val detailShareVotesButton: DisplayText get() = DisplayText.Res(R.string.polls_detail_share_votes_button)
    /** {votes}票 ・ {candidates}件の候補 — Android の詳細の見出しの下の要約 (iOS には無い)。votes は票の合計 (1000 以上は桁区切りが付く。もとは桁区切りなし)、candidates は候補の数 — 引数: votes (count), candidates (int) */
    fun detailSummary(votes: Int, candidates: Int): DisplayText = DisplayText.Plural(R.plurals.polls_detail_summary, votes, listOf(votes, candidates))
    /** タップで投票/取消 (残り{remaining}/{limit}) — Android の文言。iOS の detail.vote_hint と ja が違う (統一はオーナーが別 PR で)。remaining は残りの票、limit は 1 人が入れられる票の数 — 引数: remaining (int), limit (int) */
    fun detailVoteHintAndroid(remaining: Int, limit: Int): DisplayText = DisplayText.Res(R.string.polls_detail_vote_hint_android, listOf(remaining, limit))
    /** 通信エラー — お題の一覧・殿堂の読み込みに失敗し、サーバからの説明も無いときの説明 */
    val errorNetwork: DisplayText get() = DisplayText.Res(R.string.polls_error_network)
    /** お題が終了すると、ここに優勝した曲やアイドルが並びます。 — 殿堂に 1 件も無いときの空状態の説明 */
    val hallOfFameEmptyMessage: DisplayText get() = DisplayText.Res(R.string.polls_hall_of_fame_empty_message)
    /** まだ優勝者がいません — 殿堂に 1 件も無いときの空状態の見出し */
    val hallOfFameEmptyTitle: DisplayText get() = DisplayText.Res(R.string.polls_hall_of_fame_empty_title)
    /** {count}票 — 殿堂の行の優勝者の票の数。1000 以上は桁区切りが付く (Android はもとは桁区切りなし) — 引数: count (count) */
    fun hallOfFameRowVotes(count: Int): DisplayText = DisplayText.Plural(R.plurals.polls_hall_of_fame_row_votes, count, listOf(count))
    /** 優勝 — 殿堂の行の右に出す札 (そのお題で 1 位) */
    val hallOfFameRowWinner: DisplayText get() = DisplayText.Res(R.string.polls_hall_of_fame_row_winner)
    /** 殿堂 — 終了したお題の優勝者を並べる画面のタイトル */
    val hallOfFameTitle: DisplayText get() = DisplayText.Res(R.string.polls_hall_of_fame_title)
    /** お題を作成 — 一覧の右上の ＋ ボタンの読み上げ */
    val listCreateA11y: DisplayText get() = DisplayText.Res(R.string.polls_list_create_a11y)
    /** 右上の「＋」から新しいお題を投稿できます。 — 開催中のお題が 1 件も無いときの空状態の説明。＋ は右上の作成ボタン */
    val listEmptyActiveMessage: DisplayText get() = DisplayText.Res(R.string.polls_list_empty_active_message)
    /** 開催中のお題がありません — 開催中のお題が 1 件も無いときの空状態の見出し */
    val listEmptyActiveTitle: DisplayText get() = DisplayText.Res(R.string.polls_list_empty_active_title)
    /** 終了したお題がありません — 終了したお題が 1 件も無いときの空状態の見出し */
    val listEmptyEndedTitle: DisplayText get() = DisplayText.Res(R.string.polls_list_empty_ended_title)
    /** 殿堂を見る — 一覧の左上の王冠ボタンの読み上げ (終了したお題の優勝者の一覧へ) */
    val listHallOfFameA11y: DisplayText get() = DisplayText.Res(R.string.polls_list_hall_of_fame_a11y)
    /** 1位 {name} — 一覧の行に出す、いま 1 位の候補 (Android)。name は曲名・アイドル名・ユニット名 — 引数: name (string) */
    fun listRowTopEntity(name: String): DisplayText = DisplayText.Res(R.string.polls_list_row_top_entity, listOf(name))
    /** 計{count}票 — 一覧の行に出す、お題の票の合計。1000 以上は桁区切りが付く (1,234票。Android はもとは桁区切りなし) — 引数: count (count) */
    fun listRowTotalVotes(count: Int): DisplayText = DisplayText.Plural(R.plurals.polls_list_row_total_votes, count, listOf(count))
    /** 開催中 — お題一覧の切り替え (開催中 / 終了) */
    val listSegmentActive: DisplayText get() = DisplayText.Res(R.string.polls_list_segment_active)
    /** 終了 — お題一覧の切り替え (開催中 / 終了) */
    val listSegmentEnded: DisplayText get() = DisplayText.Res(R.string.polls_list_segment_ended)
    /** 投票・予想 — Android のお題一覧の見出し。iOS の list.title と ja が違う (統一はオーナーが別 PR で) */
    val listTitleAndroid: DisplayText get() = DisplayText.Res(R.string.polls_list_title_android)
    /** 読み込みに失敗しました — お題の一覧・詳細・殿堂の読み込みに失敗したときの空状態の見出し */
    val loadErrorTitle: DisplayText get() = DisplayText.Res(R.string.polls_load_error_title)
    /** Googleでログイン — ログインの案内のバナーのボタン (Android)。Google は社名なので訳さない */
    val loginPromptGoogleSignIn: DisplayText get() = DisplayText.Res(R.string.polls_login_prompt_google_sign_in)
    /** 投票にはログインが必要です — 未ログインの人に出す案内 (iOS: 詳細のインラインのログイン導線。Android: 一覧・詳細のバナー) */
    val loginPromptMessage: DisplayText get() = DisplayText.Res(R.string.polls_login_prompt_message)
    /** (削除済み) — 投票した候補の曲・アイドル・ユニットがデータから消えていて名前を出せないとき */
    val myVotesDeletedChoice: DisplayText get() = DisplayText.Res(R.string.polls_my_votes_deleted_choice)
    /** みんなの投票でお題に投票すると、ここに履歴が残ります — 投票の履歴が 1 件も無いときの空状態の説明。みんなの投票 = 機能の名前 (list.title) */
    val myVotesEmptyMessage: DisplayText get() = DisplayText.Res(R.string.polls_my_votes_empty_message)
    /** まだ投票していません — 投票の履歴が 1 件も無いときの空状態の見出し */
    val myVotesEmptyTitle: DisplayText get() = DisplayText.Res(R.string.polls_my_votes_empty_title)
    /** マイ投票 — 自分が投票したお題の履歴の画面のタイトル */
    val myVotesTitle: DisplayText get() = DisplayText.Res(R.string.polls_my_votes_title)
    /** 決定 — 候補ピッカーの確定ボタン */
    val pickerConfirm: DisplayText get() = DisplayText.Res(R.string.polls_picker_confirm)
    /** 残り{remaining}人まで選べます (現在+{added}人) — アイドルの候補を選びすぎたときの注意。remaining は追加できる残りの人数、added は今回新しく選んだ人数 — 引数: remaining (count), added (int) */
    fun pickerIdolOverLimit(remaining: Int, added: Int): DisplayText = DisplayText.Plural(R.plurals.polls_picker_idol_over_limit, remaining, listOf(remaining, added))
    /** アイドル名 / CV名で検索 — アイドルの候補を選ぶピッカーの検索欄のプレースホルダ。CV = 声優 */
    val pickerIdolSearchPrompt: DisplayText get() = DisplayText.Res(R.string.polls_picker_idol_search_prompt)
    /** 出演者を選択 ({count}) — アイドルの候補を選ぶピッカーの見出し。count は今選んでいる人数 — 引数: count (int) */
    fun pickerIdolTitle(count: Int): DisplayText = DisplayText.Res(R.string.polls_picker_idol_title, listOf(count))
    /** クリア — 候補ピッカーの検索欄の × ボタンの読み上げ (入力を消す) */
    val pickerSearchClearA11y: DisplayText get() = DisplayText.Res(R.string.polls_picker_search_clear_a11y)
    /** 詳細検索 — 曲の候補を選ぶピッカーの詳細検索を開くボタンの読み上げ */
    val pickerSongAdvancedA11y: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_advanced_a11y)
    /** 該当する曲がありません — 曲の候補を選ぶピッカーで検索に一致する曲が無いとき */
    val pickerSongEmpty: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_empty)
    /** 残り{remaining}曲まで選べます (現在+{added}曲) — 曲の候補を選びすぎたときの注意。remaining は追加できる残りの曲数、added は今回新しく選んだ曲数 — 引数: remaining (count), added (int) */
    fun pickerSongOverLimit(remaining: Int, added: Int): DisplayText = DisplayText.Plural(R.plurals.polls_picker_song_over_limit, remaining, listOf(remaining, added))
    /** 曲名で検索 — 曲の候補を選ぶピッカーの検索欄のプレースホルダ */
    val pickerSongSearchPrompt: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_search_prompt)
    /** 作詞・作曲・編曲者で検索 — 曲の候補を選ぶピッカーの詳細検索の欄のプレースホルダ */
    val pickerSongSongwriterPrompt: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_songwriter_prompt)
    /** タグで絞り込み — 曲の候補を選ぶピッカーのタグ絞り込みのチップ (タグを選ぶとタグ名に変わる) */
    val pickerSongTagFilter: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_tag_filter)
    /**  ＋  — 曲ピッカーのタグ絞り込みチップで、選んだタグ名をつなぐ記号 (「タグA ＋ タグB」)。前後の空白も含む */
    val pickerSongTagSeparator: DisplayText get() = DisplayText.Res(R.string.polls_picker_song_tag_separator)
    /** 楽曲を選択 ({count}) — 曲の候補を選ぶピッカーの見出し。count は今選んでいる曲数 — 引数: count (int) */
    fun pickerSongTitle(count: Int): DisplayText = DisplayText.Res(R.string.polls_picker_song_title, listOf(count))
    /** 残り{remaining}件まで選べます (現在+{added}件) — ユニットの候補を選びすぎたときの注意。remaining は追加できる残りの数、added は今回新しく選んだ数 — 引数: remaining (count), added (int) */
    fun pickerUnitOverLimit(remaining: Int, added: Int): DisplayText = DisplayText.Plural(R.plurals.polls_picker_unit_over_limit, remaining, listOf(remaining, added))
    /** ユニット名で検索 — ユニットの候補を選ぶピッカーの検索欄のプレースホルダ */
    val pickerUnitSearchPrompt: DisplayText get() = DisplayText.Res(R.string.polls_picker_unit_search_prompt)
    /** ユニットを選択 ({count}) — ユニットの候補を選ぶピッカーの見出し。count は今選んでいる数 — 引数: count (int) */
    fun pickerUnitTitle(count: Int): DisplayText = DisplayText.Res(R.string.polls_picker_unit_title, listOf(count))
    /** グリッド表示 — 候補ピッカーの表示切り替えボタンの読み上げ (今はリストで、押すとグリッドになる) */
    val pickerViewModeGridA11y: DisplayText get() = DisplayText.Res(R.string.polls_picker_view_mode_grid_a11y)
    /** リスト表示 — 候補ピッカーの表示切り替えボタンの読み上げ (今はグリッドで、押すとリストになる) */
    val pickerViewModeListA11y: DisplayText get() = DisplayText.Res(R.string.polls_picker_view_mode_list_a11y)
    /** ブランド限定 — お題の候補の範囲を示す小さなバッジ。1 つのブランドの曲・アイドル・ユニットだけが候補 */
    val scopeBadgeBrand: DisplayText get() = DisplayText.Res(R.string.polls_scope_badge_brand)
    /** ブランド限定×{count} — お題の候補の範囲を示す小さなバッジ。count は候補に選ばれたブランドの数 (2 以上)。助数詞が無いので int — 引数: count (int) */
    fun scopeBadgeBrandMulti(count: Int): DisplayText = DisplayText.Res(R.string.polls_scope_badge_brand_multi, listOf(count))
    /** 指定候補{count}件 — お題の候補の範囲を示す小さなバッジ。作成者が指定した候補の数 (上限 500 なので桁区切りは付かない) — 引数: count (count) */
    fun scopeBadgeManual(count: Int): DisplayText = DisplayText.Plural(R.plurals.polls_scope_badge_manual, count, listOf(count))
    /** このお題をシェア — お題そのものをシェアするボタンの読み上げ (iOS: 詳細のツールバー。Android: 一覧の行と詳細のツールバー) */
    val sharePollA11y: DisplayText get() = DisplayText.Res(R.string.polls_share_poll_a11y)
    /** 本日締切 — お題の状態の札。今日が締切の開催中のお題 */
    val statusClosesToday: DisplayText get() = DisplayText.Res(R.string.polls_status_closes_today)
    /** 残り{days}日 — お題の状態の札。締切までの日数。ふつうは最長 30 日で桁区切りは付かない。Android で締切が不明 (endsAtMs = Long.MAX_VALUE) のときだけ Int.MAX_VALUE に頭打ちになり 2,147,483,647 と桁区切り付きで出る (もとは Long のままの日数で 1067 億あまり、桁区切りなし) — 引数: days (count) */
    fun statusDaysLeft(days: Int): DisplayText = DisplayText.Plural(R.plurals.polls_status_days_left, days, listOf(days))
    /** 終了 — お題の状態の札。締切を過ぎた (または止められた) お題 */
    val statusEnded: DisplayText get() = DisplayText.Res(R.string.polls_status_ended)
    /** アイドル — お題の投票対象の種類 (アイドル)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る */
    val targetIdol: DisplayText get() = DisplayText.Res(R.string.polls_target_idol)
    /** 曲 — お題の投票対象の種類 (曲)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る */
    val targetSong: DisplayText get() = DisplayText.Res(R.string.polls_target_song)
    /** ユニット — お題の投票対象の種類 (ユニット)。作成シートの対象の選択肢・詳細の種類のチップ・create.scope.*_hint の target に入る */
    val targetUnit: DisplayText get() = DisplayText.Res(R.string.polls_target_unit)
}
