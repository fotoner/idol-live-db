// 生成物: i18n/catalog/callguide.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/callguide.json の文言 (表 Callguide)
    enum Callguide {
        /// {count} 曲は、この端末の曲一覧に出ない曲 (別バージョン等) のため表示していません。 — サーバにはあるが端末の曲一覧に無いので出せない曲の数の断り書き。1000 以上は桁区切りが付く (今も同じ) — 引数: count (count)
        static func dashboardDropped(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.dropped", defaultValue: "\(count) 曲は、この端末の曲一覧に出ない曲 (別バージョン等) のため表示していません。", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールを付けた ({count}件・{lines}行) — 最近の編集の中身: コールが無かった曲に付けた。count はコールの数 (1000 以上は桁区切りが付く。今は付かないが 1 曲では出ない数)、lines は行数 — 引数: count (count), lines (int)
        static func dashboardEditAdded(count: Int, lines: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.edit.added", defaultValue: "コールを付けた (\(count)件・\(String(lines))行)", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールを削除した ({count}件→0) — 最近の編集の中身: コールを全部消した。count は消す前のコールの数 (1000 以上は桁区切りが付く。1 曲では出ない数) — 引数: count (count)
        static func dashboardEditRemoved(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.edit.removed", defaultValue: "コールを削除した (\(count)件→0)", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールを更新 ({before}→{count}件) — 最近の編集の中身: コールの数が変わった。before は前の数、count は後の数 (1000 以上は桁区切りが付く。1 曲では出ない数) — 引数: before (int), count (count)
        static func dashboardEditUpdated(before: Int, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.edit.updated", defaultValue: "コールを更新 (\(String(before))→\(count)件)", table: "Callguide", bundle: L10n.bundle)
        }
        /// {time}時点の情報です (最大 30 分ほど遅れます)。 — サーバが一覧を作った時刻の断り書き。time は相対時刻 (例: 5分前。コアが作る) — 引数: time (core)
        static func dashboardGeneratedAt(time: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.generated_at", defaultValue: "\(time)時点の情報です (最大 30 分ほど遅れます)。", table: "Callguide", bundle: L10n.bundle)
        }
        /// 歌詞の行ごとに「ここでこう叫ぶ」を書き込むのがコールガイドです。歌詞タブから直接付けられます。 — 画面の上の説明
        static var dashboardIntro: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.intro", defaultValue: "歌詞の行ごとに「ここでこう叫ぶ」を書き込むのがコールガイドです。歌詞タブから直接付けられます。", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールガイドの情報を取得できませんでした ({message}) — 読み込みに失敗したときの帯。message はエラーの文言 (model.api_error.* かサーバの文言) — 引数: message (string)
        static func dashboardLoadError(message: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.load_error", defaultValue: "コールガイドの情報を取得できませんでした (\(message))", table: "Callguide", bundle: L10n.bundle)
        }
        /// 誰かがコールを書き込むと、ここに残ります。 — 2 つ目の節が空のときの説明
        static var dashboardRecentEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.recent.empty.message", defaultValue: "誰かがコールを書き込むと、ここに残ります。", table: "Callguide", bundle: L10n.bundle)
        }
        /// まだ編集がありません — 2 つ目の節が空のときの見出し
        static var dashboardRecentEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.recent.empty.title", defaultValue: "まだ編集がありません", table: "Callguide", bundle: L10n.bundle)
        }
        /// 最近の編集 — 2 つ目の節の見出し (誰がいつコールを書いたか)
        static var dashboardRecentHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.recent.header", defaultValue: "最近の編集", table: "Callguide", bundle: L10n.bundle)
        }
        /// {detail} ・ {time} ・ {by} — 曲の行の下の 1 行。detail は dashboard.row.summary か dashboard.edit.*、time は相対時刻 (コアが作る)、by は書いた人の伏せ字の名前 (データ) — 引数: detail (text), time (core), by (string)
        static func dashboardRowSubtitle(detail: LocalizedStringResource, time: String, by: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.row.subtitle", defaultValue: "\(detail) ・ \(time) ・ \(by)", table: "Callguide", bundle: L10n.bundle)
        }
        /// {detail} ・ {by} — dashboard.row.subtitle の時刻が無い版 (更新の記録が無い曲) — 引数: detail (text), by (string)
        static func dashboardRowSubtitleNoTime(detail: LocalizedStringResource, by: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.row.subtitle_no_time", defaultValue: "\(detail) ・ \(by)", table: "Callguide", bundle: L10n.bundle)
        }
        /// {lines}行・{calls}コール — 曲の行の下に出す、コールが付いた行数とコールの数。calls は 1000 以上で桁区切りが付く (1 曲では実際には出ない) — 引数: lines (int), calls (count)
        static func dashboardRowSummary(lines: Int, calls: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.row.summary", defaultValue: "\(String(lines))行・\(calls)コール", table: "Callguide", bundle: L10n.bundle)
        }
        /// コール曲タグ — 上の数字のタイル: 「コール曲」タグ (コールのある曲に付けるタグ) の付いた曲の数
        static var dashboardStatTagged: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.stat.tagged", defaultValue: "コール曲タグ", table: "Callguide", bundle: L10n.bundle)
        }
        /// 曲 — 上の数字のタイルの単位 (数字の右に小さく出す)
        static var dashboardStatUnitSongs: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.stat.unit_songs", defaultValue: "曲", table: "Callguide", bundle: L10n.bundle)
        }
        /// 書き手募集中 — 上の数字のタイル: タグはあるのにまだコールが書かれていない曲の数
        static var dashboardStatWanted: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.stat.wanted", defaultValue: "書き手募集中", table: "Callguide", bundle: L10n.bundle)
        }
        /// ガイドあり — 上の数字のタイル: コールガイドが書かれている曲の数
        static var dashboardStatWithCalls: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.stat.with_calls", defaultValue: "ガイドあり", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールガイド — コールガイドの整備状況の画面のタイトル (プロデュース → コールガイド)
        static var dashboardTitle: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.title", defaultValue: "コールガイド", table: "Callguide", bundle: L10n.bundle)
        }
        /// 「コール曲」タグが付いた曲は、いまのところ全部書かれています。 — 3 つ目の節が空のときの説明。「コール曲」はコールのある曲に付けるタグ。ko は dashboard.stat.tagged・dashboard.wanted.header と同じく訳す (“콜 곡”)
        static var dashboardWantedEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.empty.message", defaultValue: "「コール曲」タグが付いた曲は、いまのところ全部書かれています。", table: "Callguide", bundle: L10n.bundle)
        }
        /// 未整備の曲はありません — 3 つ目の節が空のときの見出し
        static var dashboardWantedEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.empty.title", defaultValue: "未整備の曲はありません", table: "Callguide", bundle: L10n.bundle)
        }
        /// コール曲タグが付いているのに未整備 — 3 つ目の節の見出し (タグの内訳を読めないとき)。コール曲タグ = コールのある曲に付けるタグ
        static var dashboardWantedHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.header", defaultValue: "コール曲タグが付いているのに未整備", table: "Callguide", bundle: L10n.bundle)
        }
        /// コール曲タグが付いているのに未整備 ({count}曲) — 3 つ目の節の見出し。count はまだ書ける曲の数 (1000 以上は桁区切りが付く。今は付かない) — 引数: count (count)
        static func dashboardWantedHeaderCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.header_count", defaultValue: "コール曲タグが付いているのに未整備 (\(count)曲)", table: "Callguide", bundle: L10n.bundle)
        }
        /// ログインして書く — 3 つ目の節の曲の行のボタン (未ログインのとき。ログインの案内を開く)
        static var dashboardWantedLoginToWrite: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.login_to_write", defaultValue: "ログインして書く", table: "Callguide", bundle: L10n.bundle)
        }
        /// 「{tag}」タグを見る — タグの詳細へのリンク。tag はタグの名前 (データ) — 引数: tag (string)
        static func dashboardWantedSeeTag(tag: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.see_tag", defaultValue: "「\(tag)」タグを見る", table: "Callguide", bundle: L10n.bundle)
        }
        /// ここに出ているのは、タグの票が多い順に上位 100 件です。 — 3 つ目の節がサーバの上限で打ち切られているときの断り書き
        static var dashboardWantedTruncated: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.truncated", defaultValue: "ここに出ているのは、タグの票が多い順に上位 100 件です。", table: "Callguide", bundle: L10n.bundle)
        }
        /// 歌詞が未登録の {count} 曲は、歌詞が入るまで書けません。 — 3 つ目の節の下の断り書き。1000 以上は桁区切りが付く (今も同じ) — 引数: count (count)
        static func dashboardWantedWithoutLyrics(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.without_lyrics", defaultValue: "歌詞が未登録の \(count) 曲は、歌詞が入るまで書けません。", table: "Callguide", bundle: L10n.bundle)
        }
        /// 書く — 3 つ目の節の曲の行のボタン (歌詞タブを開く)
        static var dashboardWantedWrite: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.wanted.write", defaultValue: "書く", table: "Callguide", bundle: L10n.bundle)
        }
        /// 「コール曲」タグの付いた曲から書き始められます。 — 1 つ目の節が空のときの説明。「コール曲」はコールのある曲に付けるタグ。ko は dashboard.stat.tagged・dashboard.wanted.header と同じく訳す (“콜 곡”)
        static var dashboardWithCallsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.with_calls.empty.message", defaultValue: "「コール曲」タグの付いた曲から書き始められます。", table: "Callguide", bundle: L10n.bundle)
        }
        /// まだコールガイドがありません — 1 つ目の節が空のときの見出し
        static var dashboardWithCallsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.with_calls.empty.title", defaultValue: "まだコールガイドがありません", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールガイドがある曲 ({count}曲) — 1 つ目の節の見出し。count は曲数 (サーバの上限が 200 なので桁区切りは出ない) — 引数: count (count)
        static func dashboardWithCallsHeader(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.with_calls.header", defaultValue: "コールガイドがある曲 (\(count)曲)", table: "Callguide", bundle: L10n.bundle)
        }
        /// ここに出ているのは、最近更新された 200 曲です。 — 1 つ目の節がサーバの上限で打ち切られているときの断り書き
        static var dashboardWithCallsTruncated: LocalizedStringResource {
            LocalizedStringResource("callguide.dashboard.with_calls.truncated", defaultValue: "ここに出ているのは、最近更新された 200 曲です。", table: "Callguide", bundle: L10n.bundle)
        }
        /// アンカー — コールの入力シートの節の見出し。コールが掛かる歌詞の位置
        static var editorAnchorHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.anchor.header", defaultValue: "アンカー", table: "Callguide", bundle: L10n.bundle)
        }
        /// 行末（追っかけ）— 歌詞に被せず、この行の後で返すコール — アンカーが行末のとき (歌詞のどこにも掛からない) の説明。追っかけ = 歌い終わってから客が返すコール
        static var editorAnchorLineEnd: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.anchor.line_end", defaultValue: "行末（追っかけ）— 歌詞に被せず、この行の後で返すコール", table: "Callguide", bundle: L10n.bundle)
        }
        /// キャンセル — コールの入力シートの左上のボタン
        static var editorCancel: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.cancel", defaultValue: "キャンセル", table: "Callguide", bundle: L10n.bundle)
        }
        /// このコールを削除 — コールの入力シートの下の削除ボタン
        static var editorDelete: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.delete", defaultValue: "このコールを削除", table: "Callguide", bundle: L10n.bundle)
        }
        /// 完了 — コールの入力シートの右上のボタン (保存して閉じる)
        static var editorDone: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.done", defaultValue: "完了", table: "Callguide", bundle: L10n.bundle)
        }
        /// 強調 — コールの入力シートの節の見出し (普通 / おこのみで / 演者要望)
        static var editorEmphasisHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.emphasis.header", defaultValue: "強調", table: "Callguide", bundle: L10n.bundle)
        }
        /// 通常のコール。凡例には出ない。 — 強調の選択肢の説明 (通常)
        static var editorEmphasisHintNormal: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.emphasis.hint.normal", defaultValue: "通常のコール。凡例には出ない。", table: "Callguide", bundle: L10n.bundle)
        }
        /// おこのみで（緑）。やってもやらなくてもよい。 — 強調の選択肢の説明 (おこのみで = してもしなくてもよいコール。緑で出す)
        static var editorEmphasisHintOptional: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.emphasis.hint.optional", defaultValue: "おこのみで（緑）。やってもやらなくてもよい。", table: "Callguide", bundle: L10n.bundle)
        }
        /// 演者要望（赤）。演者から明示的に求められたもの。 — 強調の選択肢の説明 (演者要望 = 出演者から頼まれたコール。赤で出す)
        static var editorEmphasisHintPerformerRequest: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.emphasis.hint.performer_request", defaultValue: "演者要望（赤）。演者から明示的に求められたもの。", table: "Callguide", bundle: L10n.bundle)
        }
        /// コール文言 — コールの入力シートの節の見出し (叫ぶ言葉を入れる欄)
        static var editorInputHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.input.header", defaultValue: "コール文言", table: "Callguide", bundle: L10n.bundle)
        }
        /// 繰り返しは「× 26」のように文言へ直接書く。 — コールの入力欄の下の説明
        static var editorInputHint: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.input.hint", defaultValue: "繰り返しは「× 26」のように文言へ直接書く。", table: "Callguide", bundle: L10n.bundle)
        }
        /// (Hi!) など — コールの入力欄のプレースホルダ。(Hi!) はコールの例なので訳さない
        static var editorInputPlaceholder: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.input.placeholder", defaultValue: "(Hi!) など", table: "Callguide", bundle: L10n.bundle)
        }
        /// パレット（タップで末尾に追加） — よく使うコールの一覧の見出し。押すと入力欄の末尾に足す
        static var editorPaletteHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.palette.header", defaultValue: "パレット（タップで末尾に追加）", table: "Callguide", bundle: L10n.bundle)
        }
        /// 歌詞コール — パレットの組の名前 (選んだ歌詞の語をそのまま叫ぶコール)
        static var editorPaletteLyricCall: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.palette.lyric_call", defaultValue: "歌詞コール", table: "Callguide", bundle: L10n.bundle)
        }
        /// タイミング — コールの入力シートの節の見出し (歌に被せるか、後で返すか)
        static var editorTimingHeader: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.timing.header", defaultValue: "タイミング", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールを追加 — コールの入力シートのタイトル (新しく付ける)
        static var editorTitleAdd: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.title.add", defaultValue: "コールを追加", table: "Callguide", bundle: L10n.bundle)
        }
        /// コールを編集 — コールの入力シートのタイトル (付いているコールを直す)
        static var editorTitleEdit: LocalizedStringResource {
            LocalizedStringResource("callguide.editor.title.edit", defaultValue: "コールを編集", table: "Callguide", bundle: L10n.bundle)
        }
        /// 歌に被せる — コール表の凡例: 「同時」の札の意味 (歌に重ねて叫ぶ)
        static var legendOverTiming: LocalizedStringResource {
            LocalizedStringResource("callguide.legend.over_timing", defaultValue: "歌に被せる", table: "Callguide", bundle: L10n.bundle)
        }
        /// 行末にコールを追加 — 歌詞の行の末尾の ＋ ボタンの読み上げ
        static var lineAppendCallA11y: LocalizedStringResource {
            LocalizedStringResource("callguide.line.append_call.a11y", defaultValue: "行末にコールを追加", table: "Callguide", bundle: L10n.bundle)
        }
        /// {place}のコール: {text}。{emphasis} — コールの行の読み上げ。place は同時 / 追っかけ / 行末、text はコールの文言 (データ)、emphasis は強調の名前 — 引数: place (string), text (string), emphasis (string)
        static func lineCallA11y(place: String, text: String, emphasis: String) -> LocalizedStringResource {
            LocalizedStringResource("callguide.line.call.a11y", defaultValue: "\(place)のコール: \(text)。\(emphasis)", table: "Callguide", bundle: L10n.bundle)
        }
        /// 手拍子を指定 — 編集中、手拍子の記号が無い行の頭の ＋ の読み上げ
        static var lineClapA11y: LocalizedStringResource {
            LocalizedStringResource("callguide.line.clap.a11y", defaultValue: "手拍子を指定", table: "Callguide", bundle: L10n.bundle)
        }
        /// 行末 — 歌詞に掛からず行の後で返すコールの札。読み上げの「{place}のコール」の place にも使う
        static var lineLineEnd: LocalizedStringResource {
            LocalizedStringResource("callguide.line.line_end", defaultValue: "行末", table: "Callguide", bundle: L10n.bundle)
        }
        /// 語をタップすると、その語に被せるコールを付けられます。長押しからなぞると語をまたいだ範囲を選べます — 編集中の歌詞の行の読み上げのヒント
        static var lineSelectA11yHint: LocalizedStringResource {
            LocalizedStringResource("callguide.line.select.a11y_hint", defaultValue: "語をタップすると、その語に被せるコールを付けられます。長押しからなぞると語をまたいだ範囲を選べます", table: "Callguide", bundle: L10n.bundle)
        }
        /// ズレ — 歌詞が直されてアンカーの位置がずれたコールの札
        static var lineStale: LocalizedStringResource {
            LocalizedStringResource("callguide.line.stale", defaultValue: "ズレ", table: "Callguide", bundle: L10n.bundle)
        }
        /// クラップ — パレットの組の名前 (手拍子)
        static var paletteGroupClap: LocalizedStringResource {
            LocalizedStringResource("callguide.palette.group.clap", defaultValue: "クラップ", table: "Callguide", bundle: L10n.bundle)
        }
        /// カウント — パレットの組の名前 (3・2・1 などの数える掛け声)
        static var paletteGroupCount: LocalizedStringResource {
            LocalizedStringResource("callguide.palette.group.count", defaultValue: "カウント", table: "Callguide", bundle: L10n.bundle)
        }
        /// オーイング / 警報 — パレットの組の名前 (「オー」と伸ばす掛け声と、警報 (ハーイハーイ…) の掛け声)。ko の表記はオーナー確定待ち
        static var paletteGroupOh: LocalizedStringResource {
            LocalizedStringResource("callguide.palette.group.oh", defaultValue: "オーイング / 警報", table: "Callguide", bundle: L10n.bundle)
        }
        /// セクション — パレットの組の名前 (前奏・間奏など曲の区切り)
        static var paletteGroupSection: LocalizedStringResource {
            LocalizedStringResource("callguide.palette.group.section", defaultValue: "セクション", table: "Callguide", bundle: L10n.bundle)
        }
        /// 発声 — パレットの組の名前 ((Hi!) (Oi!) などの掛け声)
        static var paletteGroupVoice: LocalizedStringResource {
            LocalizedStringResource("callguide.palette.group.voice", defaultValue: "発声", table: "Callguide", bundle: L10n.bundle)
        }
    }
}
