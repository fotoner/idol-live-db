// 生成物: i18n/catalog/games.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/games.json の文言 (表 Games)
    enum Games {
        /// もう一度 — 結果画面で同じ設定のままもう 1 回遊ぶボタン (メンバーカラー合わせ・アイドル当て・ソロ曲クイズ)
        static var actionReplay: LocalizedStringResource {
            LocalizedStringResource("games.action.replay", defaultValue: "もう一度", table: "Games", bundle: L10n.bundle)
        }
        /// 全て — 出題ブランドの選択で「全ブランド」を表す項目 (iOS は丸アイコンの下のラベル、Android はチップ)
        static var brandFilterAll: LocalizedStringResource {
            LocalizedStringResource("games.brand_filter.all", defaultValue: "全て", table: "Games", bundle: L10n.bundle)
        }
        /// 全 — 「全て」の丸アイコンの中に出す短い文字 (ブランドの略称の代わり)。2 文字まで
        static var brandFilterAllIcon: LocalizedStringResource {
            LocalizedStringResource("games.brand_filter.all_icon", defaultValue: "全", table: "Games", bundle: L10n.bundle)
        }
        /// 出題ブランド — 出題するブランドを選ぶ節の見出し (メンバーカラー合わせ・アイドル当てクイズ・ソロ曲クイズの設定)
        static var brandFilterHeader: LocalizedStringResource {
            LocalizedStringResource("games.brand_filter.header", defaultValue: "出題ブランド", table: "Games", bundle: L10n.bundle)
        }
        /// やさしい — 難易度 (色がばらけて見分けやすい)。設定のセグメントと、ゲーム中の進捗の行に出る
        static var colorMatchDifficultyEasy: LocalizedStringResource {
            LocalizedStringResource("games.color_match.difficulty.easy", defaultValue: "やさしい", table: "Games", bundle: L10n.bundle)
        }
        /// むずい — 難易度 (いちばん近い色・人数が多い)。くだけた言い方。設定のセグメントと、ゲーム中の進捗の行に出る
        static var colorMatchDifficultyHard: LocalizedStringResource {
            LocalizedStringResource("games.color_match.difficulty.hard", defaultValue: "むずい", table: "Games", bundle: L10n.bundle)
        }
        /// ふつう — 難易度 (ランダム)。設定のセグメントと、ゲーム中の進捗の行に出る
        static var colorMatchDifficultyNormal: LocalizedStringResource {
            LocalizedStringResource("games.color_match.difficulty.normal", defaultValue: "ふつう", table: "Games", bundle: L10n.bundle)
        }
        /// 正解 — 答え合わせのあと、間違えた行に出す正しい色のラベル (右に色と HEX)
        static var colorMatchPlayAnswerLabel: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.answer_label", defaultValue: "正解", table: "Games", bundle: L10n.bundle)
        }
        /// 色をドラッグ、またはタップで割当 — ゲーム中の見出し (まだ答え合わせしていないとき)。色チップをメンバーの行へドラッグ、またはタップで割り当てる。iOS の文言 (Android はドラッグが無く color_match.play.instruction_android)
        static var colorMatchPlayInstructionIos: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.instruction_ios", defaultValue: "色をドラッグ、またはタップで割当", table: "Games", bundle: L10n.bundle)
        }
        /// 判定する — 全員に色を割り当てたあとに押す答え合わせのボタン
        static var colorMatchPlayJudge: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.judge", defaultValue: "判定する", table: "Games", bundle: L10n.bundle)
        }
        /// 答え合わせ — ゲーム中の見出し (答え合わせのあと)
        static var colorMatchPlayJudged: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.judged", defaultValue: "答え合わせ", table: "Games", bundle: L10n.bundle)
        }
        /// メンバーカラー — 答え合わせのあと、正しく割り当てた行に出す色見本のラベル (右に色と HEX)
        static var colorMatchPlayMemberColor: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.member_color", defaultValue: "メンバーカラー", table: "Games", bundle: L10n.bundle)
        }
        /// 次へ（第{number}問） — 答え合わせのあとに次の問へ進むボタン。number は次が何問目か — 引数: number (int)
        static func colorMatchPlayNext(number: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.next", defaultValue: "次へ（第\(String(number))問）", table: "Games", bundle: L10n.bundle)
        }
        /// 第{current}問 / 全{total}問 ・ {level} — ゲーム中の見出しの下。current は何問目か、total は全問数、level は難易度 (color_match.difficulty.*) — 引数: current (int), total (count), level (text)
        static func colorMatchPlayProgress(current: Int, total: Int, level: LocalizedStringResource) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.progress", defaultValue: "第\(String(current))問 / 全\(total)問 ・ \(level)", table: "Games", bundle: L10n.bundle)
        }
        /// やめる — ゲーム中の右上のボタン。設定画面に戻る
        static var colorMatchPlayQuit: LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.quit", defaultValue: "やめる", table: "Games", bundle: L10n.bundle)
        }
        /// {score} / {total} 正解 — 答え合わせのあとの、この問の正解数 / 人数 — 引数: score (int), total (int)
        static func colorMatchPlayScore(score: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.play.score", defaultValue: "\(String(score)) / \(String(total)) 正解", table: "Games", bundle: L10n.bundle)
        }
        /// 設定を変える — 結果画面のボタン。設定画面に戻る
        static var colorMatchResultChangeSettings: LocalizedStringResource {
            LocalizedStringResource("games.color_match.result.change_settings", defaultValue: "設定を変える", table: "Games", bundle: L10n.bundle)
        }
        /// 正答率 {rate}% — メンバーカラー合わせの結果の大きな数字。rate は 0–100 の整数 — 引数: rate (int)
        static func colorMatchResultRate(rate: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.result.rate", defaultValue: "正答率 \(String(rate))%", table: "Games", bundle: L10n.bundle)
        }
        /// {correct} / {answered} 正解（全{count}問） — 結果の正答率の下。correct は正解した人数の合計、answered は答えた人数の合計、count は問題数 — 引数: correct (int), answered (int), count (count)
        static func colorMatchResultSummary(correct: Int, answered: Int, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.result.summary", defaultValue: "\(String(correct)) / \(String(answered)) 正解（全\(count)問）", table: "Games", bundle: L10n.bundle)
        }
        /// 未選択なら全ブランドから出題 — 出題ブランドの見出しの下の説明
        static var colorMatchSetupBrandsCaption: LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.brands_caption", defaultValue: "未選択なら全ブランドから出題", table: "Games", bundle: L10n.bundle)
        }
        /// 難易度 — メンバーカラー合わせの設定。難易度を選ぶ節の見出し
        static var colorMatchSetupDifficulty: LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.difficulty", defaultValue: "難易度", table: "Games", bundle: L10n.bundle)
        }
        /// 出題ブランドを選んで、似た色のメンバーの色を当てよう。 — メンバーカラー合わせの設定画面の先頭の説明
        static var colorMatchSetupLead: LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.lead", defaultValue: "出題ブランドを選んで、似た色のメンバーの色を当てよう。", table: "Games", bundle: L10n.bundle)
        }
        /// 問題数 — メンバーカラー合わせの設定。問題数を選ぶ節の見出し
        static var colorMatchSetupQuestionCount: LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.question_count", defaultValue: "問題数", table: "Games", bundle: L10n.bundle)
        }
        /// {count}問 — 問題数のセグメントの選択肢 (5問 / 10問) — 引数: count (count)
        static func colorMatchSetupQuestionCountOption(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.question_count_option", defaultValue: "\(count)問", table: "Games", bundle: L10n.bundle)
        }
        /// はじめる（全{count}問） — ゲームを始めるボタン。count は選んだ問題数 — 引数: count (count)
        static func colorMatchSetupStart(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.color_match.setup.start", defaultValue: "はじめる（全\(count)問）", table: "Games", bundle: L10n.bundle)
        }
        /// 閉じる — 日替わりピックを閉じるボタン (iOS は文字のボタン、Android は × の読み上げ)
        static var dailyPickActionClose: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.action.close", defaultValue: "閉じる", table: "Games", bundle: L10n.bundle)
        }
        /// 各ブランドから今日のアイドルをピックしました。性格でも髪型でも口ぐせでも、思いついたタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。 — 日替わりピック (アイドルの日) の先頭の説明
        static var dailyPickLeadIdol: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.lead.idol", defaultValue: "各ブランドから今日のアイドルをピックしました。性格でも髪型でも口ぐせでも、思いついたタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。", table: "Games", bundle: L10n.bundle)
        }
        /// 各ブランドから今日の1曲をピックしました。ジャケットをタップで試聴、気になる曲にタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。 — 日替わりピック (曲の日) の先頭の説明
        static var dailyPickLeadSong: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.lead.song", defaultValue: "各ブランドから今日の1曲をピックしました。ジャケットをタップで試聴、気になる曲にタグを付けて投票しよう（複数OK・同じタグは人数が貯まります）。", table: "Games", bundle: L10n.bundle)
        }
        /// タグ — カードの右のボタン。タグを付けて投票するピッカーを開く
        static var dailyPickTag: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.tag", defaultValue: "タグ", table: "Games", bundle: L10n.bundle)
        }
        /// 今日のアイドル — 起動時に出る日替わりピックの画面タイトル (アイドルの日)。カレンダーのツールバーのボタンの読み上げにも使う
        static var dailyPickTitleIdol: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.title.idol", defaultValue: "今日のアイドル", table: "Games", bundle: L10n.bundle)
        }
        /// 今日の1曲 — 起動時に出る日替わりピックの画面タイトル (曲の日)。カレンダーのツールバーのボタンの読み上げにも使う
        static var dailyPickTitleSong: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.title.song", defaultValue: "今日の1曲", table: "Games", bundle: L10n.bundle)
        }
        /// 投票済 — カードの右。この曲・アイドルにタグを付けて投票したあと
        static var dailyPickVoted: LocalizedStringResource {
            LocalizedStringResource("games.daily_pick.voted", defaultValue: "投票済", table: "Games", bundle: L10n.bundle)
        }
        /// 最高 {rate}% — ハブのカードの自己ベスト (正答率で記録するゲーム = メンバーカラー合わせ)。rate は 0–100 の整数 — 引数: rate (int)
        static func hubBestPercent(rate: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.hub.best.percent", defaultValue: "最高 \(String(rate))%", table: "Games", bundle: L10n.bundle)
        }
        /// 最高 {points}pt — ハブのカードの自己ベスト (獲得ポイントで記録するクイズ)。1 回の満点は 100pt 程度なので桁区切りは出ない — 引数: points (count)
        static func hubBestPoints(points: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.hub.best.points", defaultValue: "最高 \(points)pt", table: "Games", bundle: L10n.bundle)
        }
        /// 似た色のメンバーを正しいカラーに紐づける — ハブのカードの説明 (メンバーカラー合わせ)
        static var hubEntryColorMatchBlurb: LocalizedStringResource {
            LocalizedStringResource("games.hub.entry.color_match.blurb", defaultValue: "似た色のメンバーを正しいカラーに紐づける", table: "Games", bundle: L10n.bundle)
        }
        /// プロフィールから4択で誰かを当てる — ハブのカードの説明 (アイドル当てクイズ)
        static var hubEntryIdolQuizBlurb: LocalizedStringResource {
            LocalizedStringResource("games.hub.entry.idol_quiz.blurb", defaultValue: "プロフィールから4択で誰かを当てる", table: "Games", bundle: L10n.bundle)
        }
        /// イントロを聴いて曲名を当てる — ハブのカードの説明 (イントロドン)
        static var hubEntryIntroDonBlurb: LocalizedStringResource {
            LocalizedStringResource("games.hub.entry.intro_don.blurb", defaultValue: "イントロを聴いて曲名を当てる", table: "Games", bundle: L10n.bundle)
        }
        /// ソロ曲を歌うアイドルを4択で当てる — ハブのカードの説明 (ソロ曲クイズ)
        static var hubEntrySongQuizBlurb: LocalizedStringResource {
            LocalizedStringResource("games.hub.entry.song_quiz.blurb", defaultValue: "ソロ曲を歌うアイドルを4択で当てる", table: "Games", bundle: L10n.bundle)
        }
        /// ゲーム — ハブのゲーム一覧の節の見出し (右にゲームの数)
        static var hubHeader: LocalizedStringResource {
            LocalizedStringResource("games.hub.header", defaultValue: "ゲーム", table: "Games", bundle: L10n.bundle)
        }
        /// 未プレイ — ハブのカード。まだ 1 度も遊んでいないゲーム
        static var hubNotPlayed: LocalizedStringResource {
            LocalizedStringResource("games.hub.not_played", defaultValue: "未プレイ", table: "Games", bundle: L10n.bundle)
        }
        /// {count}回 — ハブのカードの右下に出すプレイ回数。1000 以上は桁区切りが付く (1,000回) — 引数: count (count)
        static func hubPlayCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.hub.play_count", defaultValue: "\(count)回", table: "Games", bundle: L10n.bundle)
        }
        /// クイズ・ゲーム — クイズ・ゲームのハブ (プロデュースから開く) の画面タイトル
        static var hubTitle: LocalizedStringResource {
            LocalizedStringResource("games.hub.title", defaultValue: "クイズ・ゲーム", table: "Games", bundle: L10n.bundle)
        }
        /// 出題できる候補が不足しています — 出題画面で問題を 1 つも作れなかったときの空状態の見出し
        static var idolQuizEmpty: LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.empty", defaultValue: "出題できる候補が不足しています", table: "Games", bundle: L10n.bundle)
        }
        /// ヒント: {label}を見る — まだ開いていないプロフィールの項目を開くボタン。label は項目名 (血液型・誕生日など。imas-core が作る日本語) — 引数: label (core)
        static func idolQuizHintTitle(label: String) -> LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.hint.title", defaultValue: "ヒント: \(label)を見る", table: "Games", bundle: L10n.bundle)
        }
        /// プロフィール問題 — 結果画面の振り返りの行の題 (アイドル当てはシルエット出題なので題材名の代わりに出す)
        static var idolQuizHistorySubject: LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.history_subject", defaultValue: "プロフィール問題", table: "Games", bundle: L10n.bundle)
        }
        /// このプロフィールは誰？ — 出題カードの問いかけ
        static var idolQuizPrompt: LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.prompt", defaultValue: "このプロフィールは誰？", table: "Games", bundle: L10n.bundle)
        }
        /// 出題候補: {count} 名 — 選んだブランドで出題できるアイドルの数 — 引数: count (count)
        static func idolQuizSetupCandidates(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.setup.candidates", defaultValue: "出題候補: \(count) 名", table: "Games", bundle: L10n.bundle)
        }
        /// 4 択を出すにはアイドルが最低 4 名必要です。ブランドの選択を増やしてください。 — 候補が足りず始められないときの注意
        static var idolQuizSetupInsufficient: LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.setup.insufficient", defaultValue: "4 択を出すにはアイドルが最低 4 名必要です。ブランドの選択を増やしてください。", table: "Games", bundle: L10n.bundle)
        }
        /// プロフィールのヒントを手がかりに誰かを 4 択で当てよう — アイドル当てクイズの設定画面の見出しカードの説明
        static var idolQuizSetupSubtitle: LocalizedStringResource {
            LocalizedStringResource("games.idol_quiz.setup.subtitle", defaultValue: "プロフィールのヒントを手がかりに誰かを 4 択で当てよう", table: "Games", bundle: L10n.bundle)
        }
        /// メンバーカラー合わせ — ゲーム名 (似た色のメンバーにメンバーカラーを割り当てる)。ハブのカードとゲーム画面のタイトル
        static var nameColorMatch: LocalizedStringResource {
            LocalizedStringResource("games.name.color_match", defaultValue: "メンバーカラー合わせ", table: "Games", bundle: L10n.bundle)
        }
        /// アイドル当てクイズ — ゲーム名 (プロフィールから誰かを 4 択で当てる)。ハブのカード・出題設定と出題画面のタイトル・設定画面の見出しカード
        static var nameIdolQuiz: LocalizedStringResource {
            LocalizedStringResource("games.name.idol_quiz", defaultValue: "アイドル当てクイズ", table: "Games", bundle: L10n.bundle)
        }
        /// イントロドン — ゲーム名 (イントロを聴いて曲を当てるゲーム)。クイズ・ゲームのハブのカードの見出し
        static var nameIntroDon: LocalizedStringResource {
            LocalizedStringResource("games.name.intro_don", defaultValue: "イントロドン", table: "Games", bundle: L10n.bundle)
        }
        /// ソロ曲クイズ — ゲーム名 (ソロ曲を歌うアイドルを 4 択で当てる)。ハブのカード・出題設定と出題画面のタイトル・設定画面の見出しカード
        static var nameSongQuiz: LocalizedStringResource {
            LocalizedStringResource("games.name.song_quiz", defaultValue: "ソロ曲クイズ", table: "Games", bundle: L10n.bundle)
        }
        /// 次の問題 — 解答したあとに次の問へ進むボタン
        static var quizActionNext: LocalizedStringResource {
            LocalizedStringResource("games.quiz.action.next", defaultValue: "次の問題", table: "Games", bundle: L10n.bundle)
        }
        /// 結果を見る — 最後の問を解答したあとに結果画面へ進むボタン (メンバーカラー合わせの最後の問でも使う)
        static var quizActionShowResult: LocalizedStringResource {
            LocalizedStringResource("games.quiz.action.show_result", defaultValue: "結果を見る", table: "Games", bundle: L10n.bundle)
        }
        /// 開いた後は正解で +{points}pt — ヒントを開くボタンの副題。そのヒントを開いたあとに正解すると入る点 (開くほど下がる) — 引数: points (count)
        static func quizHintNextValue(points: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.quiz.hint.next_value", defaultValue: "開いた後は正解で +\(points)pt", table: "Games", bundle: L10n.bundle)
        }
        /// 正解 — 振り返りの行の、正解のアイドルに付けるチップのラベル (右にアイドル名)
        static var quizHistoryAnswer: LocalizedStringResource {
            LocalizedStringResource("games.quiz.history.answer", defaultValue: "正解", table: "Games", bundle: L10n.bundle)
        }
        /// 出題の振り返り — 結果画面の、各問で何が出て何を選んだかの一覧の見出し
        static var quizHistoryHeader: LocalizedStringResource {
            LocalizedStringResource("games.quiz.history.header", defaultValue: "出題の振り返り", table: "Games", bundle: L10n.bundle)
        }
        /// ヒント{count} — 振り返りの行。その問で開いたヒントの数 — 引数: count (count)
        static func quizHistoryHints(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.quiz.history.hints", defaultValue: "ヒント\(count)", table: "Games", bundle: L10n.bundle)
        }
        /// 選択 — 振り返りの行の、間違えたときに自分が選んだアイドルに付けるチップのラベル (右にアイドル名)
        static var quizHistoryPicked: LocalizedStringResource {
            LocalizedStringResource("games.quiz.history.picked", defaultValue: "選択", table: "Games", bundle: L10n.bundle)
        }
        /// 第 {current} / {total} 問 — クイズの上の進捗。current は何問目か、total は全問数 — 引数: current (int), total (int)
        static func quizProgress(current: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.quiz.progress", defaultValue: "第 \(String(current)) / \(String(total)) 問", table: "Games", bundle: L10n.bundle)
        }
        /// 自己ベスト更新！ — 結果画面のバッジ。今回が自己ベストを更新したとき
        static var quizResultNewBest: LocalizedStringResource {
            LocalizedStringResource("games.quiz.result.new_best", defaultValue: "自己ベスト更新！", table: "Games", bundle: L10n.bundle)
        }
        /// 結果をシェア — 結果画面のボタン。結果の文をシェアシートで送る
        static var quizResultShare: LocalizedStringResource {
            LocalizedStringResource("games.quiz.result.share", defaultValue: "結果をシェア", table: "Games", bundle: L10n.bundle)
        }
        /// 自己ベスト — 結果画面の小さな統計のラベル (上に これまでの最高の正答率%)
        static var quizResultStatBest: LocalizedStringResource {
            LocalizedStringResource("games.quiz.result.stat.best", defaultValue: "自己ベスト", table: "Games", bundle: L10n.bundle)
        }
        /// 正解 — 結果画面の小さな統計のラベル (上に 正解数/問題数)
        static var quizResultStatCorrect: LocalizedStringResource {
            LocalizedStringResource("games.quiz.result.stat.correct", defaultValue: "正解", table: "Games", bundle: L10n.bundle)
        }
        /// 正答率 — 結果画面の小さな統計のラベル (上に 今回の正答率%)
        static var quizResultStatRate: LocalizedStringResource {
            LocalizedStringResource("games.quiz.result.stat.rate", defaultValue: "正答率", table: "Games", bundle: L10n.bundle)
        }
        /// 複数選択可 · 空=全ブランド対象 — 出題ブランドの見出しの下の説明。何も選ばなければ全ブランドから出す
        static var quizSetupBrandsCaption: LocalizedStringResource {
            LocalizedStringResource("games.quiz.setup.brands_caption", defaultValue: "複数選択可 · 空=全ブランド対象", table: "Games", bundle: L10n.bundle)
        }
        /// 候補を計算中… — 出題できる候補の数を数えている間の表示
        static var quizSetupEstimating: LocalizedStringResource {
            LocalizedStringResource("games.quiz.setup.estimating", defaultValue: "候補を計算中…", table: "Games", bundle: L10n.bundle)
        }
        /// 全てに戻す — 出題ブランドの見出しの右のボタン。選択を外して全ブランドに戻す
        static var quizSetupResetBrands: LocalizedStringResource {
            LocalizedStringResource("games.quiz.setup.reset_brands", defaultValue: "全てに戻す", table: "Games", bundle: L10n.bundle)
        }
        /// スタート — 出題設定画面の、クイズを始めるボタン
        static var quizSetupStart: LocalizedStringResource {
            LocalizedStringResource("games.quiz.setup.start", defaultValue: "スタート", table: "Games", bundle: L10n.bundle)
        }
        /// 正解で +{points}pt — 出題カードのバッジ。いまの開示のまま正解したときに入る点 (最大 10pt 程度) — 引数: points (count)
        static func quizValueBadge(points: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.quiz.value_badge", defaultValue: "正解で +\(points)pt", table: "Games", bundle: L10n.bundle)
        }
        /// 正解: {name} — 解答したあとに出す正解のアイドル名。name はアイドル名 (データ) — 引数: name (string)
        static func songQuizAnswer(name: String) -> LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.answer", defaultValue: "正解: \(name)", table: "Games", bundle: L10n.bundle)
        }
        /// 出題できるソロ曲が不足しています — 出題画面で問題を 1 つも作れなかったときの空状態の見出し
        static var songQuizEmpty: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.empty", defaultValue: "出題できるソロ曲が不足しています", table: "Games", bundle: L10n.bundle)
        }
        /// ヒント: ジャケットを見る — ヒント 1 段目のボタン。伏せていたジャケットを見せる
        static var songQuizHintArtwork: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.hint.artwork", defaultValue: "ヒント: ジャケットを見る", table: "Games", bundle: L10n.bundle)
        }
        /// ヒント: プレビューを再生する — ヒント 2 段目のボタン。曲の試聴を流す
        static var songQuizHintPreview: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.hint.preview", defaultValue: "ヒント: プレビューを再生する", table: "Games", bundle: L10n.bundle)
        }
        /// このソロ曲を歌うのは？ — 出題カードの問いかけ (iOS だけ。Android のカードには無い)
        static var songQuizPrompt: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.prompt", defaultValue: "このソロ曲を歌うのは？", table: "Games", bundle: L10n.bundle)
        }
        /// 出題候補: {songs} 曲 / {singers} 歌手 — 選んだブランドで出題できるソロ曲の数と、その歌手の数。songs は曲数 (count。全ブランドだと 1000 曲を超え、1000 以上は桁区切りが付く: 1,488 曲。format_change: grouping。iOS は元から桁区切りあり、Android は以前 1488 曲)、singers は人数 (int。キーに count は 1 つまでなので桁区切りなし) — 引数: songs (count), singers (int)
        static func songQuizSetupCandidates(songs: Int, singers: Int) -> LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.setup.candidates", defaultValue: "出題候補: \(songs) 曲 / \(String(singers)) 歌手", table: "Games", bundle: L10n.bundle)
        }
        /// 4択の選択肢は歌手数が基準です — 候補数の下の補足。選択肢を作れるかは歌手の数で決まる
        static var songQuizSetupCandidatesNote: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.setup.candidates_note", defaultValue: "4択の選択肢は歌手数が基準です", table: "Games", bundle: L10n.bundle)
        }
        /// 4 択を出すには原唱歌手が最低 4 名必要です。ブランドの選択を増やしてください。 — 候補が足りず始められないときの注意。原唱歌手 = その曲をもともと歌ったアイドル
        static var songQuizSetupInsufficient: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.setup.insufficient", defaultValue: "4 択を出すには原唱歌手が最低 4 名必要です。ブランドの選択を増やしてください。", table: "Games", bundle: L10n.bundle)
        }
        /// ソロ曲を聴いてその歌手を 4 択で当てよう — ソロ曲クイズの設定画面の見出しカードの説明
        static var songQuizSetupSubtitle: LocalizedStringResource {
            LocalizedStringResource("games.song_quiz.setup.subtitle", defaultValue: "ソロ曲を聴いてその歌手を 4 択で当てよう", table: "Games", bundle: L10n.bundle)
        }
    }
}
