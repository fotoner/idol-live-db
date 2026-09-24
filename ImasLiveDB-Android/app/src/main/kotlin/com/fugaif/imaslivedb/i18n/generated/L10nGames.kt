// 生成物: i18n/catalog/games.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/games.json の文言。L10n.Games から引く (iOS の L10n.Games と同じ名前)。 */
object L10nGames {
    /** もう一度 — 結果画面で同じ設定のままもう 1 回遊ぶボタン (メンバーカラー合わせ・アイドル当て・ソロ曲クイズ) */
    val actionReplay: DisplayText get() = DisplayText.Res(R.string.games_action_replay)
    /** 全て — 出題ブランドの選択で「全ブランド」を表す項目 (iOS は丸アイコンの下のラベル、Android はチップ) */
    val brandFilterAll: DisplayText get() = DisplayText.Res(R.string.games_brand_filter_all)
    /** 出題ブランド — 出題するブランドを選ぶ節の見出し (メンバーカラー合わせ・アイドル当てクイズ・ソロ曲クイズの設定) */
    val brandFilterHeader: DisplayText get() = DisplayText.Res(R.string.games_brand_filter_header)
    /** やさしい — 難易度 (色がばらけて見分けやすい)。設定のセグメントと、ゲーム中の進捗の行に出る */
    val colorMatchDifficultyEasy: DisplayText get() = DisplayText.Res(R.string.games_color_match_difficulty_easy)
    /** むずい — 難易度 (いちばん近い色・人数が多い)。くだけた言い方。設定のセグメントと、ゲーム中の進捗の行に出る */
    val colorMatchDifficultyHard: DisplayText get() = DisplayText.Res(R.string.games_color_match_difficulty_hard)
    /** ふつう — 難易度 (ランダム)。設定のセグメントと、ゲーム中の進捗の行に出る */
    val colorMatchDifficultyNormal: DisplayText get() = DisplayText.Res(R.string.games_color_match_difficulty_normal)
    /** 正解 — 答え合わせのあと、間違えた行に出す正しい色のラベル (右に色と HEX) */
    val colorMatchPlayAnswerLabel: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_answer_label)
    /** 色をタップして選択、メンバーをタップで割当 — ゲーム中の見出し (まだ答え合わせしていないとき)。Android はドラッグが無くタップだけ。iOS の color_match.play.instruction_ios と ja が違う */
    val colorMatchPlayInstructionAndroid: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_instruction_android)
    /** 判定する — 全員に色を割り当てたあとに押す答え合わせのボタン */
    val colorMatchPlayJudge: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_judge)
    /** 答え合わせ — ゲーム中の見出し (答え合わせのあと) */
    val colorMatchPlayJudged: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_judged)
    /** メンバーカラー — 答え合わせのあと、正しく割り当てた行に出す色見本のラベル (右に色と HEX) */
    val colorMatchPlayMemberColor: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_member_color)
    /** 次へ（第{number}問） — 答え合わせのあとに次の問へ進むボタン。number は次が何問目か — 引数: number (int) */
    fun colorMatchPlayNext(number: Int): DisplayText = DisplayText.Res(R.string.games_color_match_play_next, listOf(number))
    /** 第{current}問 / 全{total}問 ・ {level} — ゲーム中の見出しの下。current は何問目か、total は全問数、level は難易度 (color_match.difficulty.*) — 引数: current (int), total (count), level (text) */
    fun colorMatchPlayProgress(current: Int, total: Int, level: DisplayText): DisplayText = DisplayText.Plural(R.plurals.games_color_match_play_progress, total, listOf(current, total, level))
    /** やめる — ゲーム中の右上のボタン。設定画面に戻る */
    val colorMatchPlayQuit: DisplayText get() = DisplayText.Res(R.string.games_color_match_play_quit)
    /** {score} / {total} 正解 — 答え合わせのあとの、この問の正解数 / 人数 — 引数: score (int), total (int) */
    fun colorMatchPlayScore(score: Int, total: Int): DisplayText = DisplayText.Res(R.string.games_color_match_play_score, listOf(score, total))
    /** 設定を変える — 結果画面のボタン。設定画面に戻る */
    val colorMatchResultChangeSettings: DisplayText get() = DisplayText.Res(R.string.games_color_match_result_change_settings)
    /** 正答率 {rate}% — メンバーカラー合わせの結果の大きな数字。rate は 0–100 の整数 — 引数: rate (int) */
    fun colorMatchResultRate(rate: Int): DisplayText = DisplayText.Res(R.string.games_color_match_result_rate, listOf(rate))
    /** {correct} / {answered} 正解（全{count}問） — 結果の正答率の下。correct は正解した人数の合計、answered は答えた人数の合計、count は問題数 — 引数: correct (int), answered (int), count (count) */
    fun colorMatchResultSummary(correct: Int, answered: Int, count: Int): DisplayText = DisplayText.Plural(R.plurals.games_color_match_result_summary, count, listOf(correct, answered, count))
    /** 未選択なら全ブランドから出題 — 出題ブランドの見出しの下の説明 */
    val colorMatchSetupBrandsCaption: DisplayText get() = DisplayText.Res(R.string.games_color_match_setup_brands_caption)
    /** 難易度 — メンバーカラー合わせの設定。難易度を選ぶ節の見出し */
    val colorMatchSetupDifficulty: DisplayText get() = DisplayText.Res(R.string.games_color_match_setup_difficulty)
    /** 出題ブランドを選んで、似た色のメンバーの色を当てよう。 — メンバーカラー合わせの設定画面の先頭の説明 */
    val colorMatchSetupLead: DisplayText get() = DisplayText.Res(R.string.games_color_match_setup_lead)
    /** 問題数 — メンバーカラー合わせの設定。問題数を選ぶ節の見出し */
    val colorMatchSetupQuestionCount: DisplayText get() = DisplayText.Res(R.string.games_color_match_setup_question_count)
    /** {count}問 — 問題数のセグメントの選択肢 (5問 / 10問) — 引数: count (count) */
    fun colorMatchSetupQuestionCountOption(count: Int): DisplayText = DisplayText.Plural(R.plurals.games_color_match_setup_question_count_option, count, listOf(count))
    /** はじめる（全{count}問） — ゲームを始めるボタン。count は選んだ問題数 — 引数: count (count) */
    fun colorMatchSetupStart(count: Int): DisplayText = DisplayText.Plural(R.plurals.games_color_match_setup_start, count, listOf(count))
    /** 閉じる — 日替わりピックを閉じるボタン (iOS は文字のボタン、Android は × の読み上げ) */
    val dailyPickActionClose: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_action_close)
    /** 各ブランドから今日のアイドルをピックしました。性格でも髪型でも口ぐせでも、思いついたタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。 — 日替わりピック (アイドルの日) の先頭の説明 */
    val dailyPickLeadIdol: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_lead_idol)
    /** 各ブランドから今日の1曲をピックしました。ジャケットをタップで試聴、気になる曲にタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。 — 日替わりピック (曲の日) の先頭の説明 */
    val dailyPickLeadSong: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_lead_song)
    /** タグ — カードの右のボタン。タグを付けて投票するピッカーを開く */
    val dailyPickTag: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_tag)
    /** 今日のアイドル — 起動時に出る日替わりピックの画面タイトル (アイドルの日)。カレンダーのツールバーのボタンの読み上げにも使う */
    val dailyPickTitleIdol: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_title_idol)
    /** 今日の1曲 — 起動時に出る日替わりピックの画面タイトル (曲の日)。カレンダーのツールバーのボタンの読み上げにも使う */
    val dailyPickTitleSong: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_title_song)
    /** 投票済 — カードの右。この曲・アイドルにタグを付けて投票したあと */
    val dailyPickVoted: DisplayText get() = DisplayText.Res(R.string.games_daily_pick_voted)
    /** 最高 {rate}% — ハブのカードの自己ベスト (正答率で記録するゲーム = メンバーカラー合わせ)。rate は 0–100 の整数 — 引数: rate (int) */
    fun hubBestPercent(rate: Int): DisplayText = DisplayText.Res(R.string.games_hub_best_percent, listOf(rate))
    /** 最高 {points}pt — ハブのカードの自己ベスト (獲得ポイントで記録するクイズ)。1 回の満点は 100pt 程度なので桁区切りは出ない — 引数: points (count) */
    fun hubBestPoints(points: Int): DisplayText = DisplayText.Plural(R.plurals.games_hub_best_points, points, listOf(points))
    /** 似た色のメンバーを正しいカラーに紐づける — ハブのカードの説明 (メンバーカラー合わせ) */
    val hubEntryColorMatchBlurb: DisplayText get() = DisplayText.Res(R.string.games_hub_entry_color_match_blurb)
    /** プロフィールから4択で誰かを当てる — ハブのカードの説明 (アイドル当てクイズ) */
    val hubEntryIdolQuizBlurb: DisplayText get() = DisplayText.Res(R.string.games_hub_entry_idol_quiz_blurb)
    /** イントロを聴いて曲名を当てる — ハブのカードの説明 (イントロドン) */
    val hubEntryIntroDonBlurb: DisplayText get() = DisplayText.Res(R.string.games_hub_entry_intro_don_blurb)
    /** ソロ曲を歌うアイドルを4択で当てる — ハブのカードの説明 (ソロ曲クイズ) */
    val hubEntrySongQuizBlurb: DisplayText get() = DisplayText.Res(R.string.games_hub_entry_song_quiz_blurb)
    /** ゲーム — ハブのゲーム一覧の節の見出し (右にゲームの数) */
    val hubHeader: DisplayText get() = DisplayText.Res(R.string.games_hub_header)
    /** 未プレイ — ハブのカード。まだ 1 度も遊んでいないゲーム */
    val hubNotPlayed: DisplayText get() = DisplayText.Res(R.string.games_hub_not_played)
    /** {count}回 — ハブのカードの右下に出すプレイ回数。1000 以上は桁区切りが付く (1,000回) — 引数: count (count) */
    fun hubPlayCount(count: Int): DisplayText = DisplayText.Plural(R.plurals.games_hub_play_count, count, listOf(count))
    /** クイズ・ゲーム — クイズ・ゲームのハブ (プロデュースから開く) の画面タイトル */
    val hubTitle: DisplayText get() = DisplayText.Res(R.string.games_hub_title)
    /** 出題できる候補が不足しています — 出題画面で問題を 1 つも作れなかったときの空状態の見出し */
    val idolQuizEmpty: DisplayText get() = DisplayText.Res(R.string.games_idol_quiz_empty)
    /** ヒント: {label}を見る — まだ開いていないプロフィールの項目を開くボタン。label は項目名 (血液型・誕生日など。imas-core が作る日本語) — 引数: label (core) */
    fun idolQuizHintTitle(label: String): DisplayText = DisplayText.Res(R.string.games_idol_quiz_hint_title, listOf(label))
    /** プロフィール問題 — 結果画面の振り返りの行の題 (アイドル当てはシルエット出題なので題材名の代わりに出す) */
    val idolQuizHistorySubject: DisplayText get() = DisplayText.Res(R.string.games_idol_quiz_history_subject)
    /** このプロフィールは誰？ — 出題カードの問いかけ */
    val idolQuizPrompt: DisplayText get() = DisplayText.Res(R.string.games_idol_quiz_prompt)
    /** 出題候補: {count} 名 — 選んだブランドで出題できるアイドルの数 — 引数: count (count) */
    fun idolQuizSetupCandidates(count: Int): DisplayText = DisplayText.Plural(R.plurals.games_idol_quiz_setup_candidates, count, listOf(count))
    /** 4 択を出すにはアイドルが最低 4 名必要です。ブランドの選択を増やしてください。 — 候補が足りず始められないときの注意 */
    val idolQuizSetupInsufficient: DisplayText get() = DisplayText.Res(R.string.games_idol_quiz_setup_insufficient)
    /** プロフィールのヒントを手がかりに誰かを 4 択で当てよう — アイドル当てクイズの設定画面の見出しカードの説明 */
    val idolQuizSetupSubtitle: DisplayText get() = DisplayText.Res(R.string.games_idol_quiz_setup_subtitle)
    /** メンバーカラー合わせ — ゲーム名 (似た色のメンバーにメンバーカラーを割り当てる)。ハブのカードとゲーム画面のタイトル */
    val nameColorMatch: DisplayText get() = DisplayText.Res(R.string.games_name_color_match)
    /** アイドル当てクイズ — ゲーム名 (プロフィールから誰かを 4 択で当てる)。ハブのカード・出題設定と出題画面のタイトル・設定画面の見出しカード */
    val nameIdolQuiz: DisplayText get() = DisplayText.Res(R.string.games_name_idol_quiz)
    /** イントロドン — ゲーム名 (イントロを聴いて曲を当てるゲーム)。クイズ・ゲームのハブのカードの見出し */
    val nameIntroDon: DisplayText get() = DisplayText.Res(R.string.games_name_intro_don)
    /** ソロ曲クイズ — ゲーム名 (ソロ曲を歌うアイドルを 4 択で当てる)。ハブのカード・出題設定と出題画面のタイトル・設定画面の見出しカード */
    val nameSongQuiz: DisplayText get() = DisplayText.Res(R.string.games_name_song_quiz)
    /** 次の問題 — 解答したあとに次の問へ進むボタン */
    val quizActionNext: DisplayText get() = DisplayText.Res(R.string.games_quiz_action_next)
    /** 結果を見る — 最後の問を解答したあとに結果画面へ進むボタン (メンバーカラー合わせの最後の問でも使う) */
    val quizActionShowResult: DisplayText get() = DisplayText.Res(R.string.games_quiz_action_show_result)
    /** 開いた後は正解で +{points}pt — ヒントを開くボタンの副題。そのヒントを開いたあとに正解すると入る点 (開くほど下がる) — 引数: points (count) */
    fun quizHintNextValue(points: Int): DisplayText = DisplayText.Plural(R.plurals.games_quiz_hint_next_value, points, listOf(points))
    /** 正解 — 振り返りの行の、正解のアイドルに付けるチップのラベル (右にアイドル名) */
    val quizHistoryAnswer: DisplayText get() = DisplayText.Res(R.string.games_quiz_history_answer)
    /** 出題の振り返り — 結果画面の、各問で何が出て何を選んだかの一覧の見出し */
    val quizHistoryHeader: DisplayText get() = DisplayText.Res(R.string.games_quiz_history_header)
    /** ヒント{count} — 振り返りの行。その問で開いたヒントの数 — 引数: count (count) */
    fun quizHistoryHints(count: Int): DisplayText = DisplayText.Plural(R.plurals.games_quiz_history_hints, count, listOf(count))
    /** 選択 — 振り返りの行の、間違えたときに自分が選んだアイドルに付けるチップのラベル (右にアイドル名) */
    val quizHistoryPicked: DisplayText get() = DisplayText.Res(R.string.games_quiz_history_picked)
    /** 第 {current} / {total} 問 — クイズの上の進捗。current は何問目か、total は全問数 — 引数: current (int), total (int) */
    fun quizProgress(current: Int, total: Int): DisplayText = DisplayText.Res(R.string.games_quiz_progress, listOf(current, total))
    /** 自己ベスト更新！ — 結果画面のバッジ。今回が自己ベストを更新したとき */
    val quizResultNewBest: DisplayText get() = DisplayText.Res(R.string.games_quiz_result_new_best)
    /** 結果をシェア — 結果画面のボタン。結果の文をシェアシートで送る */
    val quizResultShare: DisplayText get() = DisplayText.Res(R.string.games_quiz_result_share)
    /** 自己ベスト — 結果画面の小さな統計のラベル (上に これまでの最高の正答率%) */
    val quizResultStatBest: DisplayText get() = DisplayText.Res(R.string.games_quiz_result_stat_best)
    /** 正解 — 結果画面の小さな統計のラベル (上に 正解数/問題数) */
    val quizResultStatCorrect: DisplayText get() = DisplayText.Res(R.string.games_quiz_result_stat_correct)
    /** 正答率 — 結果画面の小さな統計のラベル (上に 今回の正答率%) */
    val quizResultStatRate: DisplayText get() = DisplayText.Res(R.string.games_quiz_result_stat_rate)
    /** 複数選択可 · 空=全ブランド対象 — 出題ブランドの見出しの下の説明。何も選ばなければ全ブランドから出す */
    val quizSetupBrandsCaption: DisplayText get() = DisplayText.Res(R.string.games_quiz_setup_brands_caption)
    /** 候補を計算中… — 出題できる候補の数を数えている間の表示 */
    val quizSetupEstimating: DisplayText get() = DisplayText.Res(R.string.games_quiz_setup_estimating)
    /** 全てに戻す — 出題ブランドの見出しの右のボタン。選択を外して全ブランドに戻す */
    val quizSetupResetBrands: DisplayText get() = DisplayText.Res(R.string.games_quiz_setup_reset_brands)
    /** スタート — 出題設定画面の、クイズを始めるボタン */
    val quizSetupStart: DisplayText get() = DisplayText.Res(R.string.games_quiz_setup_start)
    /** 正解で +{points}pt — 出題カードのバッジ。いまの開示のまま正解したときに入る点 (最大 10pt 程度) — 引数: points (count) */
    fun quizValueBadge(points: Int): DisplayText = DisplayText.Plural(R.plurals.games_quiz_value_badge, points, listOf(points))
    /** 正解: {name} — 解答したあとに出す正解のアイドル名。name はアイドル名 (データ) — 引数: name (string) */
    fun songQuizAnswer(name: String): DisplayText = DisplayText.Res(R.string.games_song_quiz_answer, listOf(name))
    /** 出題できるソロ曲が不足しています — 出題画面で問題を 1 つも作れなかったときの空状態の見出し */
    val songQuizEmpty: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_empty)
    /** ヒント: ジャケットを見る — ヒント 1 段目のボタン。伏せていたジャケットを見せる */
    val songQuizHintArtwork: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_hint_artwork)
    /** ヒント: プレビューを再生する — ヒント 2 段目のボタン。曲の試聴を流す */
    val songQuizHintPreview: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_hint_preview)
    /** 出題候補: {songs} 曲 / {singers} 歌手 — 選んだブランドで出題できるソロ曲の数と、その歌手の数。songs は曲数 (count。全ブランドだと 1000 曲を超え、1000 以上は桁区切りが付く: 1,488 曲。format_change: grouping。iOS は元から桁区切りあり、Android は以前 1488 曲)、singers は人数 (int。キーに count は 1 つまでなので桁区切りなし) — 引数: songs (count), singers (int) */
    fun songQuizSetupCandidates(songs: Int, singers: Int): DisplayText = DisplayText.Plural(R.plurals.games_song_quiz_setup_candidates, songs, listOf(songs, singers))
    /** 4択の選択肢は歌手数が基準です — 候補数の下の補足。選択肢を作れるかは歌手の数で決まる */
    val songQuizSetupCandidatesNote: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_setup_candidates_note)
    /** 4 択を出すには原唱歌手が最低 4 名必要です。ブランドの選択を増やしてください。 — 候補が足りず始められないときの注意。原唱歌手 = その曲をもともと歌ったアイドル */
    val songQuizSetupInsufficient: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_setup_insufficient)
    /** ソロ曲を聴いてその歌手を 4 択で当てよう — ソロ曲クイズの設定画面の見出しカードの説明 */
    val songQuizSetupSubtitle: DisplayText get() = DisplayText.Res(R.string.games_song_quiz_setup_subtitle)
}
