// 生成物: i18n/catalog/introdon.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/introdon.json の文言。L10n.Introdon から引く (iOS の L10n.Introdon と同じ名前)。 */
object L10nIntrodon {
    /** 結果を見る — 最後の問題 (パーティ対戦は最後のラウンド) の答え合わせのあと、結果へ進むボタン */
    val actionSeeResults: DisplayText get() = DisplayText.Res(R.string.introdon_action_see_results)
    /** {title} {seconds}秒 — イントロを流した秒数の表示 (再生 1.2秒)。title は elapsed.title、seconds は小数 1 桁に書式済みの数字 — 引数: title (text), seconds (string) */
    fun elapsedLabel(title: DisplayText, seconds: String): DisplayText = DisplayText.Res(R.string.introdon_elapsed_label, listOf(title, seconds))
    /** 再生 — イントロを流した秒数の表示の前に付く見出し (elapsed.label の title に入る) */
    val elapsedTitle: DisplayText get() = DisplayText.Res(R.string.introdon_elapsed_title)
    /** 戻る — ゲームを始められないときのエラー表示の下のボタン (Android)。前の画面へ戻る */
    val errorBack: DisplayText get() = DisplayText.Res(R.string.introdon_error_back)
    /** 対象の曲が見つかりませんでした。ブランドを増やしてお試しください。 — 出題できる曲が足りずゲームを始められないとき */
    val errorNoSongs: DisplayText get() = DisplayText.Res(R.string.introdon_error_no_songs)
    /** 終了 — ゲーム・パーティ対戦の画面左上の × ボタンの読み上げ (Android) */
    val exitA11y: DisplayText get() = DisplayText.Res(R.string.introdon_exit_a11y)
    /** キャンセル — ゲームを終了するかの確認ダイアログの、やめるボタン */
    val exitCancel: DisplayText get() = DisplayText.Res(R.string.introdon_exit_cancel)
    /** 終了 — ゲームを終了するかの確認ダイアログの、終了するボタン */
    val exitConfirm: DisplayText get() = DisplayText.Res(R.string.introdon_exit_confirm)
    /** わかったらタップ — 中央の大きな「!」ボタン (早押し) の下の案内 */
    val gameBuzzHint: DisplayText get() = DisplayText.Res(R.string.introdon_game_buzz_hint)
    /** 再生中 — イントロの続きを流すボタンの下のラベル (流している間) */
    val gameControlPlaying: DisplayText get() = DisplayText.Res(R.string.introdon_game_control_playing)
    /** もう一度 — イントロを頭から流し直すボタンの下のラベル */
    val gameControlReplay: DisplayText get() = DisplayText.Res(R.string.introdon_game_control_replay)
    /** 続きから — イントロの続きを流すボタンの下のラベル (止まっているとき)。止めた位置から続きを流す */
    val gameControlResume: DisplayText get() = DisplayText.Res(R.string.introdon_game_control_resume)
    /** 次の曲 — 今の問題を飛ばして次の曲へ進むボタンの下のラベル */
    val gameControlSkip: DisplayText get() = DisplayText.Res(R.string.introdon_game_control_skip)
    /** ゲームを終了しますか？ — ゲーム中に × を押したときの確認ダイアログの見出し */
    val gameExitTitle: DisplayText get() = DisplayText.Res(R.string.introdon_game_exit_title)
    /** 次の問題へ — 答え合わせのあと、次の問題へ進むボタン */
    val gameNextQuestion: DisplayText get() = DisplayText.Res(R.string.introdon_game_next_question)
    /** 曲名を選んでください — 回答の番になったときの案内 (4択のモード) */
    val gamePromptAnswerChoice: DisplayText get() = DisplayText.Res(R.string.introdon_game_prompt_answer_choice)
    /** 曲名は？ — ラッシュ・全曲チャレンジで曲を流している間の問いかけ */
    val gamePromptGuess: DisplayText get() = DisplayText.Res(R.string.introdon_game_prompt_guess)
    /** もう少し！ — 成績 (正答率 40% 以上)。結果画面とシェア画像 */
    val gradeAlmost: DisplayText get() = DisplayText.Res(R.string.introdon_grade_almost)
    /** なかなか！ — 成績 (正答率 60% 以上)。結果画面とシェア画像 */
    val gradeGood: DisplayText get() = DisplayText.Res(R.string.introdon_grade_good)
    /** すごい！ — 成績 (正答率 80% 以上)。結果画面とシェア画像 */
    val gradeGreat: DisplayText get() = DisplayText.Res(R.string.introdon_grade_great)
    /** パーフェクト! 🎵 — 結果画面の成績バッジ (正答率 100%)。! は半角。シェア画像は grade.perfect_card */
    val gradePerfect: DisplayText get() = DisplayText.Res(R.string.introdon_grade_perfect)
    /** パーフェクト！ — 結果のシェア画像の成績 (正答率 100%)。結果画面の grade.perfect と ja が違う */
    val gradePerfectCard: DisplayText get() = DisplayText.Res(R.string.introdon_grade_perfect_card)
    /** 練習あるのみ！ — 成績 (正答率 40% 未満)。結果画面とシェア画像 */
    val gradePractice: DisplayText get() = DisplayText.Res(R.string.introdon_grade_practice)
    /** ゲームをはじめる — ホームの主ボタン。押すと設定画面へ進む */
    val homeActionStart: DisplayText get() = DisplayText.Res(R.string.introdon_home_action_start)
    /** 曲のイントロを聴いて\n曲名をいち早く当てよう — ホームの先頭カードの説明 (Android)。iOS の home.hero.caption_ios と ja が違う (Android は Apple Music を使わない) */
    val homeHeroCaptionAndroid: DisplayText get() = DisplayText.Res(R.string.introdon_home_hero_caption_android)
    /** イントロドン — ホーム画面の先頭カードの大きな見出し (ゲーム名)。上の小さな英字 INTRO DON は飾りで訳さない */
    val homeHeroTitle: DisplayText get() = DisplayText.Res(R.string.introdon_home_hero_title)
    /** 各曲の30秒プレビューからイントロ部分を再生します。プレビューを持たない曲は出題対象外です。 — ホームの案内カードの説明 (Android) */
    val homePreviewNoticeMessage: DisplayText get() = DisplayText.Res(R.string.introdon_home_preview_notice_message)
    /** プレビュー再生で出題します — ホームの案内カードの見出し (Android)。Android は曲の 30 秒プレビューでイントロを流す */
    val homePreviewNoticeTitle: DisplayText get() = DisplayText.Res(R.string.introdon_home_preview_notice_title)
    /** イントロドン — イントロドン (イントロ当てゲーム) のホーム画面の上のバーのタイトル */
    val homeTitle: DisplayText get() = DisplayText.Res(R.string.introdon_home_title)
    /** 問題を生成中... — 問題を作っている間の表示 (設定画面のボタン・ゲーム画面・パーティ対戦画面) */
    val loadingGenerating: DisplayText get() = DisplayText.Res(R.string.introdon_loading_generating)
    /** 全曲出し切るまで・タイムと正答率を競う — モード「全曲チャレンジ」の説明 (設定画面のモードの行) */
    val modeAllSongsCaption: DisplayText get() = DisplayText.Res(R.string.introdon_mode_all_songs_caption)
    /** 全曲チャレンジ — ゲームのモード名。出題範囲の全曲を出し切るまで挑戦し、タイムを競う */
    val modeAllSongsName: DisplayText get() = DisplayText.Res(R.string.introdon_mode_all_songs_name)
    /** 決めた問題数で挑戦 — モード「ノーマル」の説明 (設定画面のモードの行) */
    val modeNormalCaption: DisplayText get() = DisplayText.Res(R.string.introdon_mode_normal_caption)
    /** ノーマル — ゲームのモード名。決めた問題数で挑戦する (設定画面・結果のシェア画像) */
    val modeNormalName: DisplayText get() = DisplayText.Res(R.string.introdon_mode_normal_name)
    /** 1台2人・分割画面で早押し — モード「パーティ対戦」の説明 (設定画面のモードの行) */
    val modePartyCaption: DisplayText get() = DisplayText.Res(R.string.introdon_mode_party_caption)
    /** パーティ対戦 — ゲームのモード名。1 台の端末を 2 人で使い、画面を上下に分けて早押しで対戦する */
    val modePartyName: DisplayText get() = DisplayText.Res(R.string.introdon_mode_party_name)
    /** 制限時間内に何問正解できるか — モード「ラッシュ」の説明 (設定画面のモードの行) */
    val modeRushCaption: DisplayText get() = DisplayText.Res(R.string.introdon_mode_rush_caption)
    /** ラッシュ — ゲームのモード名。制限時間内に何問正解できるか */
    val modeRushName: DisplayText get() = DisplayText.Res(R.string.introdon_mode_rush_name)
    /** ラッシュ {seconds}秒 — 結果のシェア画像に出すモード名。seconds は制限時間 (30・60・120) — 引数: seconds (int) */
    fun modeRushNameWithTime(seconds: Int): DisplayText = DisplayText.Res(R.string.introdon_mode_rush_name_with_time, listOf(seconds))
    /** 退出 — パーティ対戦の結果のボタン。設定画面へ戻る */
    val partyActionLeave: DisplayText get() = DisplayText.Res(R.string.introdon_party_action_leave)
    /** もう一度 — パーティ対戦の結果のボタン。同じ設定でもう一度対戦する */
    val partyActionReplay: DisplayText get() = DisplayText.Res(R.string.introdon_party_action_replay)
    /** 正解 — 誰も正解しなかったときに出す、正解の曲名の上の小さな見出し */
    val partyAnswerLabel: DisplayText get() = DisplayText.Res(R.string.introdon_party_answer_label)
    /** {player} 回答中 — 早押しした人の半分の画面の上。player はプレイヤー名 (1P・2P) — 引数: player (string) */
    fun partyAnswering(player: String): DisplayText = DisplayText.Res(R.string.introdon_party_answering, listOf(player))
    /** タップで早押し！ — パーティ対戦の各プレイヤーの半分の画面。タップすると早押しになる */
    val partyBuzzPrompt: DisplayText get() = DisplayText.Res(R.string.introdon_party_buzz_prompt)
    /** 早押し成立！回答してください — 中央の帯。誰かが早押ししたとき */
    val partyBuzzed: DisplayText get() = DisplayText.Res(R.string.introdon_party_buzzed)
    /** 正解！ +1 — 正解した人の半分の画面。1 点入る */
    val partyCorrect: DisplayText get() = DisplayText.Res(R.string.introdon_party_correct)
    /** 引き分け — パーティ対戦の結果。同点のとき */
    val partyDraw: DisplayText get() = DisplayText.Res(R.string.introdon_party_draw)
    /** 対戦を終了しますか？ — パーティ対戦中に × を押したときの確認ダイアログの見出し */
    val partyExitTitle: DisplayText get() = DisplayText.Res(R.string.introdon_party_exit_title)
    /** わからない — 中央の帯のボタン。2 人とも分からないときに答えを見る */
    val partyGiveUp: DisplayText get() = DisplayText.Res(R.string.introdon_party_give_up)
    /** 次のラウンドへ — 答え合わせのあと、次のラウンドへ進むボタン */
    val partyNextRound: DisplayText get() = DisplayText.Res(R.string.introdon_party_next_round)
    /** 相手が回答中… — パーティ対戦で相手が先に押したとき、押されなかった側に出す */
    val partyOpponentAnswering: DisplayText get() = DisplayText.Res(R.string.introdon_party_opponent_answering)
    /** タップでもう一度 — 中央の帯の再生ボタンの横の案内 (Android)。タップでイントロを流し直す。iOS の party.play.hint と ja が違う */
    val partyPlayHintAndroid: DisplayText get() = DisplayText.Res(R.string.introdon_party_play_hint_android)
    /** {player} の勝ち！ — パーティ対戦の結果。player は勝ったプレイヤー名 (1P・2P) — 引数: player (string) */
    fun partyWinner(player: String): DisplayText = DisplayText.Res(R.string.introdon_party_winner, listOf(player))
    /** 正答率 {percent}% — 結果画面の大きな点数の下。percent は 0〜100 の整数 — 引数: percent (int) */
    fun resultAccuracy(percent: Int): DisplayText = DisplayText.Res(R.string.introdon_result_accuracy, listOf(percent))
    /** ホームに戻る — 結果画面のボタン。イントロドンのホームへ戻る */
    val resultActionHome: DisplayText get() = DisplayText.Res(R.string.introdon_result_action_home)
    /** もう一度 — 結果画面のボタン (Android)。同じ設定でもう一度遊ぶ。iOS の result.action.replay と ja が違う */
    val resultActionReplayAndroid: DisplayText get() = DisplayText.Res(R.string.introdon_result_action_replay_android)
    /** 結果をシェア — 結果画面のボタン (Android)。結果のカードの共有シートを開く */
    val resultActionShare: DisplayText get() = DisplayText.Res(R.string.introdon_result_action_share)
    /** 全問の結果 — 結果画面の節の見出し。1 問ずつの正誤の一覧 */
    val resultAllQuestionsHeader: DisplayText get() = DisplayText.Res(R.string.introdon_result_all_questions_header)
    /** ベストスコア更新！ — これまでより多く正解したときの帯。右の英字 NEW BEST は飾りで訳さない */
    val resultBestScore: DisplayText get() = DisplayText.Res(R.string.introdon_result_best_score)
    /** ベストタイム更新！ — 全曲チャレンジでこれまでより速く終えたときの帯。右の英字 NEW TIME は飾りで訳さない */
    val resultBestTime: DisplayText get() = DisplayText.Res(R.string.introdon_result_best_time)
    /** 回答: {title} — 1 問ずつの結果の、間違えた問題の下に出す自分の答え。title は選んだ曲名 (訳さない) — 引数: title (string) */
    fun resultRecordAnswer(title: String): DisplayText = DisplayText.Res(R.string.introdon_result_record_answer, listOf(title))
    /** スキップ — 1 問ずつの結果の、答えずに飛ばした問題の下の表示 */
    val resultRecordSkipped: DisplayText get() = DisplayText.Res(R.string.introdon_result_record_skipped)
    /** スタート — 設定画面の一番下の、ゲームを始めるボタン */
    val setupActionStart: DisplayText get() = DisplayText.Res(R.string.introdon_setup_action_start)
    /** 選択した出題範囲の全曲を出し切るまで挑戦。タイムと正答率を競います。 — 全曲チャレンジを選んだときの説明 */
    val setupAllSongsNote: DisplayText get() = DisplayText.Res(R.string.introdon_setup_all_songs_note)
    /** 出題候補: {count} 曲 — 設定画面の下の、出題できる曲の数 (Android)。1000 以上は桁区切りが付く (出題候補: 1,234 曲) — 引数: count (count) */
    fun setupCandidates(count: Int): DisplayText = DisplayText.Plural(R.plurals.introdon_setup_candidates, count, listOf(count))
    /** 問題数 — 設定画面の節の見出し。何問出すか (5・10・20 問) */
    val setupCountHeader: DisplayText get() = DisplayText.Res(R.string.introdon_setup_count_header)
    /** 難易度 (イントロ再生時間) — 設定の見出し。イントロを何秒流すか (短いほど難しい) */
    val setupDurationHeader: DisplayText get() = DisplayText.Res(R.string.introdon_setup_duration_header)
    /** 再生 — イントロ再生時間のボタン (2秒・5秒・10秒) の下の小さなラベル */
    val setupDurationPlay: DisplayText get() = DisplayText.Res(R.string.introdon_setup_duration_play)
    /** 再生時間 — イントロ再生時間のスライダーの上のラベル (1 秒以上のとき) */
    val setupDurationSliderLabel: DisplayText get() = DisplayText.Res(R.string.introdon_setup_duration_slider_label)
    /** 超イントロ — イントロ再生時間が 1 秒未満のときの呼び名。0.2秒 のボタンの下と、スライダーの上のラベルに出す */
    val setupDurationUltra: DisplayText get() = DisplayText.Res(R.string.introdon_setup_duration_ultra)
    /** 出題するにはプレビュー付きの曲が最低 4 曲必要です。ブランドの選択を増やしてください。 — 出題できる曲が 4 曲未満のときの警告 (Android)。4 は固定の値 */
    val setupInsufficient: DisplayText get() = DisplayText.Res(R.string.introdon_setup_insufficient)
    /** モード — 設定画面の節の見出し。ゲームのモード (ノーマル・ラッシュ…) を選ぶ */
    val setupModeHeader: DisplayText get() = DisplayText.Res(R.string.introdon_setup_mode_header)
    /** 出題範囲 — 設定画面の節の見出し。どの曲から出題するか */
    val setupRangeHeader: DisplayText get() = DisplayText.Res(R.string.introdon_setup_range_header)
    /** ブランドで絞る — 「出題範囲」の見出しの右の補足。下のブランドのアイコンで出題する曲を絞る */
    val setupRangeHint: DisplayText get() = DisplayText.Res(R.string.introdon_setup_range_hint)
    /** 制限時間 — 設定画面の節の見出し (ラッシュのとき)。30・60・120 秒から選ぶ */
    val setupRushTimeHeader: DisplayText get() = DisplayText.Res(R.string.introdon_setup_rush_time_header)
    /** {seconds}秒 — イントロ再生時間の秒数 (0.2秒・2秒・5.0秒 など)。seconds は書式済みの数字 (小数を含む) — 引数: seconds (string) */
    fun setupSeconds(seconds: String): DisplayText = DisplayText.Res(R.string.introdon_setup_seconds, listOf(seconds))
    /** 設定 — ゲームの設定画面の上のバーのタイトル */
    val setupTitle: DisplayText get() = DisplayText.Res(R.string.introdon_setup_title)
    /** 問 — 問題数のボタンの数字 (5・10・20) の下に出す単位 */
    val setupUnitQuestions: DisplayText get() = DisplayText.Res(R.string.introdon_setup_unit_questions)
    /** 秒 — 制限時間のボタンの数字 (30・60・120) の下に出す単位 */
    val setupUnitSeconds: DisplayText get() = DisplayText.Res(R.string.introdon_setup_unit_seconds)
    /** もっと遊ぶなら 本家アプリ — 結果のシェア画像の一番下の宣伝の 1 行目。本家アプリ = 姉妹アプリ「イントロクイズ」 */
    val shareCardFooterLead: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_footer_lead)
    /** Google Playで「イントロクイズ」 — 結果のシェア画像の宣伝の 2 行目 (Android)。「イントロクイズ」はストアでの本家アプリの名前 (固有名詞。検索語なので訳さない) */
    val shareCardFooterStoreAndroid: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_footer_store_android)
    /** ほか {count}曲 — 結果のシェア画像の曲別の内訳で、載せきれなかった曲の数。1000 以上は桁区切りが付く (ほか 1,234曲) — 引数: count (count) */
    fun shareCardMoreSongs(count: Int): DisplayText = DisplayText.Plural(R.plurals.introdon_share_card_more_songs, count, listOf(count))
    /** 結果をシェア — 結果のシェアシートの見出し (Android) */
    val shareCardSheetTitle: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_sheet_title)
    /** 正解率 — 結果のシェア画像の数字の下のラベル (正答率 %) */
    val shareCardStatAccuracy: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_stat_accuracy)
    /** 最大コンボ — 結果のシェア画像の数字の下のラベル (連続正解の最大数 ×N) */
    val shareCardStatMaxCombo: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_stat_max_combo)
    /** タイム — 結果のシェア画像の数字の下のラベル (全曲チャレンジのクリアタイム 分:秒) */
    val shareCardStatTime: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_stat_time)
    /** イントロドン — 結果のシェア画像の一番上の見出し (ゲーム名)。下の英字 PERFECT / RESULT は飾りで訳さない */
    val shareCardTitle: DisplayText get() = DisplayText.Res(R.string.introdon_share_card_title)
}
