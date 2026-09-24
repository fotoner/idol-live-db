// 生成物: i18n/catalog/introdon.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/introdon.json の文言 (表 Introdon)
    enum Introdon {
        /// 結果を見る — 最後の問題 (パーティ対戦は最後のラウンド) の答え合わせのあと、結果へ進むボタン
        static var actionSeeResults: LocalizedStringResource {
            LocalizedStringResource("introdon.action.see_results", defaultValue: "結果を見る", table: "Introdon", bundle: L10n.bundle)
        }
        /// タップで回答 — 回答方式「4択」のボタンの下の説明
        static var answerModeChoicesCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.answer_mode.choices.caption", defaultValue: "タップで回答", table: "Introdon", bundle: L10n.bundle)
        }
        /// 4択 — 回答方式のボタン。4 つの曲名から選ぶ
        static var answerModeChoicesName: LocalizedStringResource {
            LocalizedStringResource("introdon.answer_mode.choices.name", defaultValue: "4択", table: "Introdon", bundle: L10n.bundle)
        }
        /// 声で曲名を回答 — 回答方式「音声判定」のボタンの下の説明
        static var answerModeVoiceCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.answer_mode.voice.caption", defaultValue: "声で曲名を回答", table: "Introdon", bundle: L10n.bundle)
        }
        /// 音声判定 — 回答方式のボタン。曲名を声で言って判定する
        static var answerModeVoiceName: LocalizedStringResource {
            LocalizedStringResource("introdon.answer_mode.voice.name", defaultValue: "音声判定", table: "Introdon", bundle: L10n.bundle)
        }
        /// Apple Music を許可する — Apple Music の利用許可を求めるボタン (ホーム・設定画面の警告カード)
        static var authActionAllow: LocalizedStringResource {
            LocalizedStringResource("introdon.auth.action.allow", defaultValue: "Apple Music を許可する", table: "Introdon", bundle: L10n.bundle)
        }
        /// Apple Music が未認証です — Apple Music の利用を許可していないときの警告 (ホーム・設定画面)
        static var authWarning: LocalizedStringResource {
            LocalizedStringResource("introdon.auth.warning", defaultValue: "Apple Music が未認証です", table: "Introdon", bundle: L10n.bundle)
        }
        /// {title} {seconds}秒 — イントロを流した秒数の表示 (再生 1.2秒)。title は elapsed.title、seconds は小数 1 桁に書式済みの数字 — 引数: title (text), seconds (string)
        static func elapsedLabel(title: LocalizedStringResource, seconds: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.elapsed.label", defaultValue: "\(title) \(seconds)秒", table: "Introdon", bundle: L10n.bundle)
        }
        /// 再生 — イントロを流した秒数の表示の前に付く見出し (elapsed.label の title に入る)
        static var elapsedTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.elapsed.title", defaultValue: "再生", table: "Introdon", bundle: L10n.bundle)
        }
        /// エラー: {message} — 問題の生成に失敗したとき (設定画面)。message は OS やサーバが返したエラーの説明 (訳さない) — 引数: message (string)
        static func errorGeneric(message: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.error.generic", defaultValue: "エラー: \(message)", table: "Introdon", bundle: L10n.bundle)
        }
        /// 対象の曲が見つかりませんでした。ブランドを増やしてお試しください。 — 出題できる曲が足りずゲームを始められないとき
        static var errorNoSongs: LocalizedStringResource {
            LocalizedStringResource("introdon.error.no_songs", defaultValue: "対象の曲が見つかりませんでした。ブランドを増やしてお試しください。", table: "Introdon", bundle: L10n.bundle)
        }
        /// キャンセル — ゲームを終了するかの確認ダイアログの、やめるボタン
        static var exitCancel: LocalizedStringResource {
            LocalizedStringResource("introdon.exit.cancel", defaultValue: "キャンセル", table: "Introdon", bundle: L10n.bundle)
        }
        /// 終了 — ゲームを終了するかの確認ダイアログの、終了するボタン
        static var exitConfirm: LocalizedStringResource {
            LocalizedStringResource("introdon.exit.confirm", defaultValue: "終了", table: "Introdon", bundle: L10n.bundle)
        }
        /// わかったらタップ — 中央の大きな「!」ボタン (早押し) の下の案内
        static var gameBuzzHint: LocalizedStringResource {
            LocalizedStringResource("introdon.game.buzz.hint", defaultValue: "わかったらタップ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 再生中 — イントロの続きを流すボタンの下のラベル (流している間)
        static var gameControlPlaying: LocalizedStringResource {
            LocalizedStringResource("introdon.game.control.playing", defaultValue: "再生中", table: "Introdon", bundle: L10n.bundle)
        }
        /// もう一度 — イントロを頭から流し直すボタンの下のラベル
        static var gameControlReplay: LocalizedStringResource {
            LocalizedStringResource("introdon.game.control.replay", defaultValue: "もう一度", table: "Introdon", bundle: L10n.bundle)
        }
        /// 続きから — イントロの続きを流すボタンの下のラベル (止まっているとき)。止めた位置から続きを流す
        static var gameControlResume: LocalizedStringResource {
            LocalizedStringResource("introdon.game.control.resume", defaultValue: "続きから", table: "Introdon", bundle: L10n.bundle)
        }
        /// 次の曲 — 今の問題を飛ばして次の曲へ進むボタンの下のラベル
        static var gameControlSkip: LocalizedStringResource {
            LocalizedStringResource("introdon.game.control.skip", defaultValue: "次の曲", table: "Introdon", bundle: L10n.bundle)
        }
        /// ゲームを終了しますか？ — ゲーム中に × を押したときの確認ダイアログの見出し
        static var gameExitTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.game.exit.title", defaultValue: "ゲームを終了しますか？", table: "Introdon", bundle: L10n.bundle)
        }
        /// 次の問題へ — 答え合わせのあと、次の問題へ進むボタン
        static var gameNextQuestion: LocalizedStringResource {
            LocalizedStringResource("introdon.game.next.question", defaultValue: "次の問題へ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 曲名を選んでください — 回答の番になったときの案内 (4択のモード)
        static var gamePromptAnswerChoice: LocalizedStringResource {
            LocalizedStringResource("introdon.game.prompt.answer_choice", defaultValue: "曲名を選んでください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 曲名を声で答えてください — 回答の番になったときの案内 (音声で答えるモード)
        static var gamePromptAnswerVoice: LocalizedStringResource {
            LocalizedStringResource("introdon.game.prompt.answer_voice", defaultValue: "曲名を声で答えてください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 曲名は？ — ラッシュ・全曲チャレンジで曲を流している間の問いかけ
        static var gamePromptGuess: LocalizedStringResource {
            LocalizedStringResource("introdon.game.prompt.guess", defaultValue: "曲名は？", table: "Introdon", bundle: L10n.bundle)
        }
        /// 設定アプリから「マイク」と「音声認識」の権限を許可してください。 — マイク・音声認識が許可されていないときのアラートの本文
        static var gameSpeechDeniedMessage: LocalizedStringResource {
            LocalizedStringResource("introdon.game.speech_denied.message", defaultValue: "設定アプリから「マイク」と「音声認識」の権限を許可してください。", table: "Introdon", bundle: L10n.bundle)
        }
        /// OK — マイク・音声認識が許可されていないときのアラートの閉じるボタン
        static var gameSpeechDeniedOk: LocalizedStringResource {
            LocalizedStringResource("introdon.game.speech_denied.ok", defaultValue: "OK", table: "Introdon", bundle: L10n.bundle)
        }
        /// 音声認識を許可してください — 音声で答えるモードでマイク・音声認識が許可されていないときのアラートの見出し
        static var gameSpeechDeniedTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.game.speech_denied.title", defaultValue: "音声認識を許可してください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 設定アプリでマイクと音声認識を許可してください — 音声で答える欄の案内。マイク・音声認識が拒否されているとき
        static var gameVoiceDenied: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.denied", defaultValue: "設定アプリでマイクと音声認識を許可してください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 聴取中… 曲名を声で答えてください — 音声で答える欄の案内。聞き取り中でまだ何も認識していないとき
        static var gameVoiceListening: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.listening", defaultValue: "聴取中… 曲名を声で答えてください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 「{text}」 — 音声で答える欄に出す、聞き取った言葉。text は音声認識の結果 (訳さない) — 引数: text (string)
        static func gameVoiceRecognized(text: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.recognized", defaultValue: "「\(text)」", table: "Introdon", bundle: L10n.bundle)
        }
        /// マイクで回答 — マイクのボタン。聞き取りを始める
        static var gameVoiceStart: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.start", defaultValue: "マイクで回答", table: "Introdon", bundle: L10n.bundle)
        }
        /// 聴取を停止 — マイクのボタン。聞き取りを止める
        static var gameVoiceStop: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.stop", defaultValue: "聴取を停止", table: "Introdon", bundle: L10n.bundle)
        }
        /// マイクをタップして回答 — 音声で答える欄の案内。聞き取りを止めているとき
        static var gameVoiceTapToAnswer: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.tap_to_answer", defaultValue: "マイクをタップして回答", table: "Introdon", bundle: L10n.bundle)
        }
        /// マイクをタップして声で回答 — 音声で答える欄の案内。まだマイクの許可を聞いていないとき
        static var gameVoiceTapToSpeak: LocalizedStringResource {
            LocalizedStringResource("introdon.game.voice.tap_to_speak", defaultValue: "マイクをタップして声で回答", table: "Introdon", bundle: L10n.bundle)
        }
        /// もう少し！ — 成績 (正答率 40% 以上)。結果画面とシェア画像
        static var gradeAlmost: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.almost", defaultValue: "もう少し！", table: "Introdon", bundle: L10n.bundle)
        }
        /// なかなか！ — 成績 (正答率 60% 以上)。結果画面とシェア画像
        static var gradeGood: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.good", defaultValue: "なかなか！", table: "Introdon", bundle: L10n.bundle)
        }
        /// すごい！ — 成績 (正答率 80% 以上)。結果画面とシェア画像
        static var gradeGreat: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.great", defaultValue: "すごい！", table: "Introdon", bundle: L10n.bundle)
        }
        /// パーフェクト! 🎵 — 結果画面の成績バッジ (正答率 100%)。! は半角。シェア画像は grade.perfect_card
        static var gradePerfect: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.perfect", defaultValue: "パーフェクト! 🎵", table: "Introdon", bundle: L10n.bundle)
        }
        /// パーフェクト！ — 結果のシェア画像の成績 (正答率 100%)。結果画面の grade.perfect と ja が違う
        static var gradePerfectCard: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.perfect_card", defaultValue: "パーフェクト！", table: "Introdon", bundle: L10n.bundle)
        }
        /// 練習あるのみ！ — 成績 (正答率 40% 未満)。結果画面とシェア画像
        static var gradePractice: LocalizedStringResource {
            LocalizedStringResource("introdon.grade.practice", defaultValue: "練習あるのみ！", table: "Introdon", bundle: L10n.bundle)
        }
        /// ゲームをはじめる — ホームの主ボタン。押すと設定画面へ進む
        static var homeActionStart: LocalizedStringResource {
            LocalizedStringResource("introdon.home.action.start", defaultValue: "ゲームをはじめる", table: "Introdon", bundle: L10n.bundle)
        }
        /// 対戦モード — ホームの節の見出し。姉妹アプリ (対戦できる本家アプリ) の案内カードの上
        static var homeBattleHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.home.battle.header", defaultValue: "対戦モード", table: "Introdon", bundle: L10n.bundle)
        }
        /// 姉妹アプリ「イントロドン」でローカル\n・オンライン対戦ができます — 姉妹アプリの案内カードの説明。「ローカル・オンライン対戦」の途中で改行している
        static var homeBattleMessage: LocalizedStringResource {
            LocalizedStringResource("introdon.home.battle.message", defaultValue: "姉妹アプリ「イントロドン」でローカル\n・オンライン対戦ができます", table: "Introdon", bundle: L10n.bundle)
        }
        /// App Store で開く — 姉妹アプリの案内カードのリンク。App Store の姉妹アプリのページを開く
        static var homeBattleOpenStore: LocalizedStringResource {
            LocalizedStringResource("introdon.home.battle.open_store", defaultValue: "App Store で開く", table: "Introdon", bundle: L10n.bundle)
        }
        /// 友達と対戦したい方へ — 姉妹アプリの案内カードの見出し。上の小さな英字 BATTLE MODE は飾りで訳さない
        static var homeBattleTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.home.battle.title", defaultValue: "友達と対戦したい方へ", table: "Introdon", bundle: L10n.bundle)
        }
        /// Apple Music のイントロを聴いて\n曲名をいち早く当てよう — ホームの先頭カードの説明 (iOS)。iOS は Apple Music でイントロを流す。Android の home.hero.caption_android と ja が違う
        static var homeHeroCaptionIos: LocalizedStringResource {
            LocalizedStringResource("introdon.home.hero.caption_ios", defaultValue: "Apple Music のイントロを聴いて\n曲名をいち早く当てよう", table: "Introdon", bundle: L10n.bundle)
        }
        /// イントロドン — ホーム画面の先頭カードの大きな見出し (ゲーム名)。上の小さな英字 INTRO DON は飾りで訳さない
        static var homeHeroTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.home.hero.title", defaultValue: "イントロドン", table: "Introdon", bundle: L10n.bundle)
        }
        /// イントロドン — イントロドン (イントロ当てゲーム) のホーム画面の上のバーのタイトル
        static var homeTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.home.title", defaultValue: "イントロドン", table: "Introdon", bundle: L10n.bundle)
        }
        /// 問題を生成中... — 問題を作っている間の表示 (設定画面のボタン・ゲーム画面・パーティ対戦画面)
        static var loadingGenerating: LocalizedStringResource {
            LocalizedStringResource("introdon.loading.generating", defaultValue: "問題を生成中...", table: "Introdon", bundle: L10n.bundle)
        }
        /// 全曲出し切るまで・タイムと正答率を競う — モード「全曲チャレンジ」の説明 (設定画面のモードの行)
        static var modeAllSongsCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.all_songs.caption", defaultValue: "全曲出し切るまで・タイムと正答率を競う", table: "Introdon", bundle: L10n.bundle)
        }
        /// 全曲チャレンジ — ゲームのモード名。出題範囲の全曲を出し切るまで挑戦し、タイムを競う
        static var modeAllSongsName: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.all_songs.name", defaultValue: "全曲チャレンジ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 決めた問題数で挑戦 — モード「ノーマル」の説明 (設定画面のモードの行)
        static var modeNormalCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.normal.caption", defaultValue: "決めた問題数で挑戦", table: "Introdon", bundle: L10n.bundle)
        }
        /// ノーマル — ゲームのモード名。決めた問題数で挑戦する (設定画面・結果のシェア画像)
        static var modeNormalName: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.normal.name", defaultValue: "ノーマル", table: "Introdon", bundle: L10n.bundle)
        }
        /// 1台2人・分割画面で早押し — モード「パーティ対戦」の説明 (設定画面のモードの行)
        static var modePartyCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.party.caption", defaultValue: "1台2人・分割画面で早押し", table: "Introdon", bundle: L10n.bundle)
        }
        /// パーティ対戦 — ゲームのモード名。1 台の端末を 2 人で使い、画面を上下に分けて早押しで対戦する
        static var modePartyName: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.party.name", defaultValue: "パーティ対戦", table: "Introdon", bundle: L10n.bundle)
        }
        /// 制限時間内に何問正解できるか — モード「ラッシュ」の説明 (設定画面のモードの行)
        static var modeRushCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.rush.caption", defaultValue: "制限時間内に何問正解できるか", table: "Introdon", bundle: L10n.bundle)
        }
        /// ラッシュ — ゲームのモード名。制限時間内に何問正解できるか
        static var modeRushName: LocalizedStringResource {
            LocalizedStringResource("introdon.mode.rush.name", defaultValue: "ラッシュ", table: "Introdon", bundle: L10n.bundle)
        }
        /// ラッシュ {seconds}秒 — 結果のシェア画像に出すモード名。seconds は制限時間 (30・60・120) — 引数: seconds (int)
        static func modeRushNameWithTime(seconds: Int) -> LocalizedStringResource {
            LocalizedStringResource("introdon.mode.rush.name_with_time", defaultValue: "ラッシュ \(String(seconds))秒", table: "Introdon", bundle: L10n.bundle)
        }
        /// 退出 — パーティ対戦の結果のボタン。設定画面へ戻る
        static var partyActionLeave: LocalizedStringResource {
            LocalizedStringResource("introdon.party.action.leave", defaultValue: "退出", table: "Introdon", bundle: L10n.bundle)
        }
        /// もう一度 — パーティ対戦の結果のボタン。同じ設定でもう一度対戦する
        static var partyActionReplay: LocalizedStringResource {
            LocalizedStringResource("introdon.party.action.replay", defaultValue: "もう一度", table: "Introdon", bundle: L10n.bundle)
        }
        /// 正解 — 誰も正解しなかったときに出す、正解の曲名の上の小さな見出し
        static var partyAnswerLabel: LocalizedStringResource {
            LocalizedStringResource("introdon.party.answer.label", defaultValue: "正解", table: "Introdon", bundle: L10n.bundle)
        }
        /// {player} 回答中 — 早押しした人の半分の画面の上。player はプレイヤー名 (1P・2P) — 引数: player (string)
        static func partyAnswering(player: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.party.answering", defaultValue: "\(player) 回答中", table: "Introdon", bundle: L10n.bundle)
        }
        /// タップで早押し！ — パーティ対戦の各プレイヤーの半分の画面。タップすると早押しになる
        static var partyBuzzPrompt: LocalizedStringResource {
            LocalizedStringResource("introdon.party.buzz.prompt", defaultValue: "タップで早押し！", table: "Introdon", bundle: L10n.bundle)
        }
        /// 早押し成立！回答してください — 中央の帯。誰かが早押ししたとき
        static var partyBuzzed: LocalizedStringResource {
            LocalizedStringResource("introdon.party.buzzed", defaultValue: "早押し成立！回答してください", table: "Introdon", bundle: L10n.bundle)
        }
        /// 正解！ +1 — 正解した人の半分の画面。1 点入る
        static var partyCorrect: LocalizedStringResource {
            LocalizedStringResource("introdon.party.correct", defaultValue: "正解！ +1", table: "Introdon", bundle: L10n.bundle)
        }
        /// 引き分け — パーティ対戦の結果。同点のとき
        static var partyDraw: LocalizedStringResource {
            LocalizedStringResource("introdon.party.draw", defaultValue: "引き分け", table: "Introdon", bundle: L10n.bundle)
        }
        /// 対戦を終了しますか？ — パーティ対戦中に × を押したときの確認ダイアログの見出し
        static var partyExitTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.party.exit.title", defaultValue: "対戦を終了しますか？", table: "Introdon", bundle: L10n.bundle)
        }
        /// わからない — 中央の帯のボタン。2 人とも分からないときに答えを見る
        static var partyGiveUp: LocalizedStringResource {
            LocalizedStringResource("introdon.party.give_up", defaultValue: "わからない", table: "Introdon", bundle: L10n.bundle)
        }
        /// 次のラウンドへ — 答え合わせのあと、次のラウンドへ進むボタン
        static var partyNextRound: LocalizedStringResource {
            LocalizedStringResource("introdon.party.next.round", defaultValue: "次のラウンドへ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 相手が回答中… — パーティ対戦で相手が先に押したとき、押されなかった側に出す
        static var partyOpponentAnswering: LocalizedStringResource {
            LocalizedStringResource("introdon.party.opponent_answering", defaultValue: "相手が回答中…", table: "Introdon", bundle: L10n.bundle)
        }
        /// 長押しでもう少し — 中央の帯の再生ボタンの横の案内 (iOS)。長押しの間イントロを流し続ける。Android の party.play.hint_android と ja が違う
        static var partyPlayHint: LocalizedStringResource {
            LocalizedStringResource("introdon.party.play.hint", defaultValue: "長押しでもう少し", table: "Introdon", bundle: L10n.bundle)
        }
        /// {player} の勝ち！ — パーティ対戦の結果。player は勝ったプレイヤー名 (1P・2P) — 引数: player (string)
        static func partyWinner(player: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.party.winner", defaultValue: "\(player) の勝ち！", table: "Introdon", bundle: L10n.bundle)
        }
        /// 実イントロ(要サブスク) — 再生方式「フル再生」の説明。Apple Music の購読が必要
        static var playbackFullCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.playback.full.caption", defaultValue: "実イントロ(要サブスク)", table: "Introdon", bundle: L10n.bundle)
        }
        /// フル再生 — 再生方式のボタン。Apple Music のカタログで曲の頭からイントロを流す
        static var playbackFullName: LocalizedStringResource {
            LocalizedStringResource("introdon.playback.full.name", defaultValue: "フル再生", table: "Introdon", bundle: L10n.bundle)
        }
        /// 30秒・サクサク — 再生方式「プレビュー」の説明 (30 秒の試聴で軽快に進む)
        static var playbackPreviewCaption: LocalizedStringResource {
            LocalizedStringResource("introdon.playback.preview.caption", defaultValue: "30秒・サクサク", table: "Introdon", bundle: L10n.bundle)
        }
        /// プレビュー — 再生方式のボタン。30 秒の試聴音源で流す
        static var playbackPreviewName: LocalizedStringResource {
            LocalizedStringResource("introdon.playback.preview.name", defaultValue: "プレビュー", table: "Introdon", bundle: L10n.bundle)
        }
        /// 正答率 {percent}% — 結果画面の大きな点数の下。percent は 0〜100 の整数 — 引数: percent (int)
        static func resultAccuracy(percent: Int) -> LocalizedStringResource {
            LocalizedStringResource("introdon.result.accuracy", defaultValue: "正答率 \(String(percent))%", table: "Introdon", bundle: L10n.bundle)
        }
        /// ホームに戻る — 結果画面のボタン。イントロドンのホームへ戻る
        static var resultActionHome: LocalizedStringResource {
            LocalizedStringResource("introdon.result.action.home", defaultValue: "ホームに戻る", table: "Introdon", bundle: L10n.bundle)
        }
        /// もう一度あそぶ — 結果画面のボタン。設定画面へ戻ってもう一度遊ぶ (iOS)。Android の result.action.replay_android と ja が違う
        static var resultActionReplay: LocalizedStringResource {
            LocalizedStringResource("introdon.result.action.replay", defaultValue: "もう一度あそぶ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 結果を画像でシェア — 結果画面のボタン。結果のカードを画像にして共有する
        static var resultActionShareImage: LocalizedStringResource {
            LocalizedStringResource("introdon.result.action.share_image", defaultValue: "結果を画像でシェア", table: "Introdon", bundle: L10n.bundle)
        }
        /// 全問の結果 — 結果画面の節の見出し。1 問ずつの正誤の一覧
        static var resultAllQuestionsHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.result.all_questions.header", defaultValue: "全問の結果", table: "Introdon", bundle: L10n.bundle)
        }
        /// ベストスコア更新！ — これまでより多く正解したときの帯。右の英字 NEW BEST は飾りで訳さない
        static var resultBestScore: LocalizedStringResource {
            LocalizedStringResource("introdon.result.best_score", defaultValue: "ベストスコア更新！", table: "Introdon", bundle: L10n.bundle)
        }
        /// ベストタイム更新！ — 全曲チャレンジでこれまでより速く終えたときの帯。右の英字 NEW TIME は飾りで訳さない
        static var resultBestTime: LocalizedStringResource {
            LocalizedStringResource("introdon.result.best_time", defaultValue: "ベストタイム更新！", table: "Introdon", bundle: L10n.bundle)
        }
        /// 回答: {title} — 1 問ずつの結果の、間違えた問題の下に出す自分の答え。title は選んだ曲名 (訳さない) — 引数: title (string)
        static func resultRecordAnswer(title: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.result.record.answer", defaultValue: "回答: \(title)", table: "Introdon", bundle: L10n.bundle)
        }
        /// スキップ — 1 問ずつの結果の、答えずに飛ばした問題の下の表示
        static var resultRecordSkipped: LocalizedStringResource {
            LocalizedStringResource("introdon.result.record.skipped", defaultValue: "スキップ", table: "Introdon", bundle: L10n.bundle)
        }
        /// 結果 — 結果画面の上のバーのタイトル
        static var resultTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.result.title", defaultValue: "結果", table: "Introdon", bundle: L10n.bundle)
        }
        /// スタート — 設定画面の一番下の、ゲームを始めるボタン
        static var setupActionStart: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.action.start", defaultValue: "スタート", table: "Introdon", bundle: L10n.bundle)
        }
        /// 詳細設定 — 設定画面の折りたたみの見出し (再生方式・難易度)
        static var setupAdvancedHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.advanced.header", defaultValue: "詳細設定", table: "Introdon", bundle: L10n.bundle)
        }
        /// 選択した出題範囲の全曲を出し切るまで挑戦。タイムと正答率を競います。 — 全曲チャレンジを選んだときの説明
        static var setupAllSongsNote: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.all_songs.note", defaultValue: "選択した出題範囲の全曲を出し切るまで挑戦。タイムと正答率を競います。", table: "Introdon", bundle: L10n.bundle)
        }
        /// 回答方式 — 設定画面の節の見出し (ノーマルのとき)。4択か音声で答えるか
        static var setupAnswerModeHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.answer_mode.header", defaultValue: "回答方式", table: "Introdon", bundle: L10n.bundle)
        }
        /// 全て — ブランドの選択の先頭の「すべてのブランド」のアイコンの下のラベル
        static var setupBrandAll: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.brand.all", defaultValue: "全て", table: "Introdon", bundle: L10n.bundle)
        }
        /// 全 — 「すべてのブランド」の丸いアイコンの中に書く文字 (ブランドのアイコンの略称と同じ位置)。1〜2 文字が望ましい
        static var setupBrandAllIcon: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.brand.all_icon", defaultValue: "全", table: "Introdon", bundle: L10n.bundle)
        }
        /// 問題数 — 設定画面の節の見出し。何問出すか (5・10・20 問)
        static var setupCountHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.count.header", defaultValue: "問題数", table: "Introdon", bundle: L10n.bundle)
        }
        /// 難易度 (イントロ再生時間) — 設定の見出し。イントロを何秒流すか (短いほど難しい)
        static var setupDurationHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.duration.header", defaultValue: "難易度 (イントロ再生時間)", table: "Introdon", bundle: L10n.bundle)
        }
        /// 再生 — イントロ再生時間のボタン (2秒・5秒・10秒) の下の小さなラベル
        static var setupDurationPlay: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.duration.play", defaultValue: "再生", table: "Introdon", bundle: L10n.bundle)
        }
        /// 再生時間 — イントロ再生時間のスライダーの上のラベル (1 秒以上のとき)
        static var setupDurationSliderLabel: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.duration.slider_label", defaultValue: "再生時間", table: "Introdon", bundle: L10n.bundle)
        }
        /// 超イントロ — イントロ再生時間が 1 秒未満のときの呼び名。0.2秒 のボタンの下と、スライダーの上のラベルに出す
        static var setupDurationUltra: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.duration.ultra", defaultValue: "超イントロ", table: "Introdon", bundle: L10n.bundle)
        }
        /// モード — 設定画面の節の見出し。ゲームのモード (ノーマル・ラッシュ…) を選ぶ
        static var setupModeHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.mode.header", defaultValue: "モード", table: "Introdon", bundle: L10n.bundle)
        }
        /// 再生方式 — 詳細設定の中の見出し。フル再生かプレビューか
        static var setupPlaybackHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.playback.header", defaultValue: "再生方式", table: "Introdon", bundle: L10n.bundle)
        }
        /// 出題範囲を変更 — 曲一覧で絞り込んだ範囲を出題中のとき、曲一覧を開き直して範囲を選び直すボタン
        static var setupRangeChange: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.change", defaultValue: "出題範囲を変更", table: "Introdon", bundle: L10n.bundle)
        }
        /// 出題範囲 — 設定画面の節の見出し。どの曲から出題するか
        static var setupRangeHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.header", defaultValue: "出題範囲", table: "Introdon", bundle: L10n.bundle)
        }
        /// ブランドで絞る — 「出題範囲」の見出しの右の補足。下のブランドのアイコンで出題する曲を絞る
        static var setupRangeHint: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.hint", defaultValue: "ブランドで絞る", table: "Introdon", bundle: L10n.bundle)
        }
        /// 曲一覧の絞り込み — 曲一覧で絞り込んだ範囲のカードの見出し。絞り込みの説明 (曲一覧が作る) が無いときに出す
        static var setupRangePresetDefault: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.preset_default", defaultValue: "曲一覧の絞り込み", table: "Introdon", bundle: L10n.bundle)
        }
        /// タグ・担当・検索で絞り込んで出題 — 曲一覧を開いてタグ・担当・検索で出題する曲を絞り込むボタン
        static var setupRangeRefine: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.refine", defaultValue: "タグ・担当・検索で絞り込んで出題", table: "Introdon", bundle: L10n.bundle)
        }
        /// {count}曲から出題 — 曲一覧で絞り込んだ範囲のカードの説明。count は出題できる曲の数。1000 以上は桁区切りが付く (1,234曲から出題) — 引数: count (count)
        static func setupRangeSongCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("introdon.setup.range.song_count", defaultValue: "\(count)曲から出題", table: "Introdon", bundle: L10n.bundle)
        }
        /// ラウンド数 — 設定画面の節の見出し (パーティ対戦のとき)。何ラウンド戦うか
        static var setupRoundsHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.rounds.header", defaultValue: "ラウンド数", table: "Introdon", bundle: L10n.bundle)
        }
        /// 制限時間 — 設定画面の節の見出し (ラッシュのとき)。30・60・120 秒から選ぶ
        static var setupRushTimeHeader: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.rush_time.header", defaultValue: "制限時間", table: "Introdon", bundle: L10n.bundle)
        }
        /// {seconds}秒 — イントロ再生時間の秒数 (0.2秒・2秒・5.0秒 など)。seconds は書式済みの数字 (小数を含む) — 引数: seconds (string)
        static func setupSeconds(seconds: String) -> LocalizedStringResource {
            LocalizedStringResource("introdon.setup.seconds", defaultValue: "\(seconds)秒", table: "Introdon", bundle: L10n.bundle)
        }
        /// 設定 — ゲームの設定画面の上のバーのタイトル
        static var setupTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.title", defaultValue: "設定", table: "Introdon", bundle: L10n.bundle)
        }
        /// 問 — 問題数のボタンの数字 (5・10・20) の下に出す単位
        static var setupUnitQuestions: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.unit.questions", defaultValue: "問", table: "Introdon", bundle: L10n.bundle)
        }
        /// 秒 — 制限時間のボタンの数字 (30・60・120) の下に出す単位
        static var setupUnitSeconds: LocalizedStringResource {
            LocalizedStringResource("introdon.setup.unit.seconds", defaultValue: "秒", table: "Introdon", bundle: L10n.bundle)
        }
        /// もっと遊ぶなら 本家アプリ — 結果のシェア画像の一番下の宣伝の 1 行目。本家アプリ = 姉妹アプリ「イントロクイズ」
        static var shareCardFooterLead: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.footer.lead", defaultValue: "もっと遊ぶなら 本家アプリ", table: "Introdon", bundle: L10n.bundle)
        }
        /// App Storeで「イントロクイズ」 — 結果のシェア画像の宣伝の 2 行目 (iOS)。「イントロクイズ」はストアでの本家アプリの名前 (固有名詞。検索語なので訳さない)
        static var shareCardFooterStoreIos: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.footer.store_ios", defaultValue: "App Storeで「イントロクイズ」", table: "Introdon", bundle: L10n.bundle)
        }
        /// ほか {count}曲 — 結果のシェア画像の曲別の内訳で、載せきれなかった曲の数。1000 以上は桁区切りが付く (ほか 1,234曲) — 引数: count (count)
        static func shareCardMoreSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.more_songs", defaultValue: "ほか \(count)曲", table: "Introdon", bundle: L10n.bundle)
        }
        /// 正解率 — 結果のシェア画像の数字の下のラベル (正答率 %)
        static var shareCardStatAccuracy: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.stat.accuracy", defaultValue: "正解率", table: "Introdon", bundle: L10n.bundle)
        }
        /// 最大コンボ — 結果のシェア画像の数字の下のラベル (連続正解の最大数 ×N)
        static var shareCardStatMaxCombo: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.stat.max_combo", defaultValue: "最大コンボ", table: "Introdon", bundle: L10n.bundle)
        }
        /// タイム — 結果のシェア画像の数字の下のラベル (全曲チャレンジのクリアタイム 分:秒)
        static var shareCardStatTime: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.stat.time", defaultValue: "タイム", table: "Introdon", bundle: L10n.bundle)
        }
        /// イントロドン — 結果のシェア画像の一番上の見出し (ゲーム名)。下の英字 PERFECT / RESULT は飾りで訳さない
        static var shareCardTitle: LocalizedStringResource {
            LocalizedStringResource("introdon.share_card.title", defaultValue: "イントロドン", table: "Introdon", bundle: L10n.bundle)
        }
    }
}
