// 生成物: i18n/catalog/tags.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/tags.json の文言 (表 Tags)
    enum Tags {
        /// キャンセル — タグ画面群の取り消しボタン (作成・編集・絞り込み・追加のシート、通報の確認)
        static var actionCancel: LocalizedStringResource {
            LocalizedStringResource("tags.action.cancel", defaultValue: "キャンセル", table: "Tags", bundle: L10n.bundle)
        }
        /// OK — 通報の結果・エラー、タグ追加の失敗のアラートを閉じるボタン
        static var actionOk: LocalizedStringResource {
            LocalizedStringResource("tags.action.ok", defaultValue: "OK", table: "Tags", bundle: L10n.bundle)
        }
        /// タグを付けると、ここに反映されます。 — タグの動きがどのセグメントにも無いときの空状態の説明
        static var activityEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("tags.activity.empty.message", defaultValue: "タグを付けると、ここに反映されます。", table: "Tags", bundle: L10n.bundle)
        }
        /// アイドルにタグを付けると、ここに反映されます。 — 「アイドル」のセグメントにタグの動きが無いときの説明
        static var activityEmptyMessageIdols: LocalizedStringResource {
            LocalizedStringResource("tags.activity.empty.message_idols", defaultValue: "アイドルにタグを付けると、ここに反映されます。", table: "Tags", bundle: L10n.bundle)
        }
        /// 曲にタグを付けると、ここに反映されます。 — 「曲」のセグメントにタグの動きが無いときの説明
        static var activityEmptyMessageSongs: LocalizedStringResource {
            LocalizedStringResource("tags.activity.empty.message_songs", defaultValue: "曲にタグを付けると、ここに反映されます。", table: "Tags", bundle: L10n.bundle)
        }
        /// まだ動きがありません — タグの動きが 1 件も無いときの空状態の見出し
        static var activityEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("tags.activity.empty.title", defaultValue: "まだ動きがありません", table: "Tags", bundle: L10n.bundle)
        }
        /// アイドルを読み込み中 — タグの動きの行で、アイドルの情報をまだ手元のデータから読めていないとき (名前の代わり)
        static var activityLoadingIdol: LocalizedStringResource {
            LocalizedStringResource("tags.activity.loading.idol", defaultValue: "アイドルを読み込み中", table: "Tags", bundle: L10n.bundle)
        }
        /// 曲を読み込み中 — タグの動きの行で、曲の情報をまだ手元のデータから読めていないとき (曲名の代わり)
        static var activityLoadingSong: LocalizedStringResource {
            LocalizedStringResource("tags.activity.loading.song", defaultValue: "曲を読み込み中", table: "Tags", bundle: L10n.bundle)
        }
        /// 最近つけられたタグ — タグの動きの節の見出し (新しく付けられたタグの一覧)
        static var activityRecentHeader: LocalizedStringResource {
            LocalizedStringResource("tags.activity.recent.header", defaultValue: "最近つけられたタグ", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」タグが付きました — 最近つけられたタグの行の説明。name はタグ名 — 引数: name (string)
        static func activityRecentTagged(name: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.activity.recent.tagged", defaultValue: "「\(name)」タグが付きました", table: "Tags", bundle: L10n.bundle)
        }
        /// {count}件 — タグが急増中の行の右、直近に付けられた回数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func activityRisingCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.activity.rising.count", defaultValue: "\(count)件", table: "Tags", bundle: L10n.bundle)
        }
        /// タグが急増中 — タグの動きの節の見出し (直近でタグが急に増えている曲・アイドル)
        static var activityRisingHeader: LocalizedStringResource {
            LocalizedStringResource("tags.activity.rising.header", defaultValue: "タグが急増中", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」 — タグが急増中の行の、増えているタグの名前をかぎ括弧で囲んだもの。name はタグ名 — 引数: name (string)
        static func activityRisingTag(name: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.activity.rising.tag", defaultValue: "「\(name)」", table: "Tags", bundle: L10n.bundle)
        }
        /// アイドル — タグの動きの画面のセグメント (アイドルのタグ)
        static var activityTabIdols: LocalizedStringResource {
            LocalizedStringResource("tags.activity.tab.idols", defaultValue: "アイドル", table: "Tags", bundle: L10n.bundle)
        }
        /// 曲 — タグの動きの画面のセグメント (曲のタグ)
        static var activityTabSongs: LocalizedStringResource {
            LocalizedStringResource("tags.activity.tab.songs", defaultValue: "曲", table: "Tags", bundle: L10n.bundle)
        }
        /// タグの動き — タグ付けの盛り上がり (最近付いたタグ・伸びているタグ) の画面の見出し
        static var activityTitle: LocalizedStringResource {
            LocalizedStringResource("tags.activity.title", defaultValue: "タグの動き", table: "Tags", bundle: L10n.bundle)
        }
        /// 伸びてるタグ — タグの動きの節の見出し (直近でよく付けられているタグ)
        static var activityTrendingHeader: LocalizedStringResource {
            LocalizedStringResource("tags.activity.trending.header", defaultValue: "伸びてるタグ", table: "Tags", bundle: L10n.bundle)
        }
        /// 直近{count}件 — 伸びてるタグの行の右、直近 (7 日) に付けられた回数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func activityTrendingRecent(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.activity.trending.recent", defaultValue: "直近\(count)件", table: "Tags", bundle: L10n.bundle)
        }
        /// 累計{count} — 伸びてるタグの行の右、これまでに付けられた回数の合計。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func activityTrendingTotal(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.activity.trending.total", defaultValue: "累計\(count)", table: "Tags", bundle: L10n.bundle)
        }
        /// 追加済み — タグを付けるシートのタグのチップの読み上げの補足 (もう付けてある)
        static var chipAppliedA11yHint: LocalizedStringResource {
            LocalizedStringResource("tags.chip.applied.a11y_hint", defaultValue: "追加済み", table: "Tags", bundle: L10n.bundle)
        }
        /// 選択中 — タグを付けるシートのタグのチップの読み上げの補足 (選んでいて、まだ付けていない)
        static var chipSelectedA11yHint: LocalizedStringResource {
            LocalizedStringResource("tags.chip.selected.a11y_hint", defaultValue: "選択中", table: "Tags", bundle: L10n.bundle)
        }
        /// タップで追加 — タグを付けるシートのタグのチップの読み上げの補足 (まだ選んでいない)
        static var chipUnselectedA11yHint: LocalizedStringResource {
            LocalizedStringResource("tags.chip.unselected.a11y_hint", defaultValue: "タップで追加", table: "Tags", bundle: L10n.bundle)
        }
        /// カスタム色を選ぶ — タグの色の選択で、システムの色選択を開く行
        static var colorPickerCustom: LocalizedStringResource {
            LocalizedStringResource("tags.color_picker.custom", defaultValue: "カスタム色を選ぶ", table: "Tags", bundle: L10n.bundle)
        }
        /// 色なし — タグの色の選択で「色を付けない」スウォッチの読み上げ
        static var colorPickerNoneA11y: LocalizedStringResource {
            LocalizedStringResource("tags.color_picker.none.a11y", defaultValue: "色なし", table: "Tags", bundle: L10n.bundle)
        }
        /// 色 {hex} — タグの色の選択のスウォッチの読み上げ。hex は #RRGGBB の色の値 — 引数: hex (string)
        static func colorPickerSwatchA11y(hex: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.color_picker.swatch.a11y", defaultValue: "色 \(hex)", table: "Tags", bundle: L10n.bundle)
        }
        /// 作成 — 新規タグ作成シートの確定ボタン
        static var createActionCreate: LocalizedStringResource {
            LocalizedStringResource("tags.create.action.create", defaultValue: "作成", table: "Tags", bundle: L10n.bundle)
        }
        /// カテゴリ（任意） — 新規タグ作成シートのカテゴリの見出し (選ばなくてよい)
        static var createCategoryHeader: LocalizedStringResource {
            LocalizedStringResource("tags.create.category.header", defaultValue: "カテゴリ（任意）", table: "Tags", bundle: L10n.bundle)
        }
        /// 色（任意） — 新規タグ作成シートの色の見出し (選ばなくてよい)
        static var createColorHeader: LocalizedStringResource {
            LocalizedStringResource("tags.create.color.header", defaultValue: "色（任意）", table: "Tags", bundle: L10n.bundle)
        }
        /// 説明文（任意） — 新規タグ作成シートの説明文の欄の見出し (入れなくてよい)
        static var createDescriptionHeader: LocalizedStringResource {
            LocalizedStringResource("tags.create.description.header", defaultValue: "説明文（任意）", table: "Tags", bundle: L10n.bundle)
        }
        /// どんな時に使うタグか（任意） — 新規タグ作成シートの説明文の欄のプレースホルダ
        static var createDescriptionPlaceholder: LocalizedStringResource {
            LocalizedStringResource("tags.create.description.placeholder", defaultValue: "どんな時に使うタグか（任意）", table: "Tags", bundle: L10n.bundle)
        }
        /// 作成に失敗しました — タグを作れず、サーバから説明が来なかったとき
        static var createErrorFailed: LocalizedStringResource {
            LocalizedStringResource("tags.create.error.failed", defaultValue: "作成に失敗しました", table: "Tags", bundle: L10n.bundle)
        }
        /// 作成に失敗しました: {detail} — タグを作れなかったとき (通信の失敗など)。detail は OS・通信層の説明 (訳さない) — 引数: detail (string)
        static func createErrorFailedDetail(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.create.error.failed_detail", defaultValue: "作成に失敗しました: \(detail)", table: "Tags", bundle: L10n.bundle)
        }
        /// 1日10件まで作成できます。明日試してください — タグの作成が 1 日の上限 (10 件) に達したとき
        static var createErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("tags.create.error.rate_limited", defaultValue: "1日10件まで作成できます。明日試してください", table: "Tags", bundle: L10n.bundle)
        }
        /// タグ名 — 新規タグ作成シートの名前の欄の見出し
        static var createNameHeader: LocalizedStringResource {
            LocalizedStringResource("tags.create.name.header", defaultValue: "タグ名", table: "Tags", bundle: L10n.bundle)
        }
        /// 例: エモい — 新規タグ作成シートの名前の欄のプレースホルダ。例の語も訳す (エモい = 胸にくる・エモーショナル)
        static var createNamePlaceholder: LocalizedStringResource {
            LocalizedStringResource("tags.create.name.placeholder", defaultValue: "例: エモい", table: "Tags", bundle: L10n.bundle)
        }
        /// 新規タグ作成 — 新規タグ作成シートの見出し
        static var createTitle: LocalizedStringResource {
            LocalizedStringResource("tags.create.title", defaultValue: "新規タグ作成", table: "Tags", bundle: L10n.bundle)
        }
        /// 説明を編集 — タグ詳細の説明の下のボタン (説明文・カテゴリ・色の編集シートを開く)
        static var detailActionEditDescription: LocalizedStringResource {
            LocalizedStringResource("tags.detail.action.edit_description", defaultValue: "説明を編集", table: "Tags", bundle: L10n.bundle)
        }
        /// 編集履歴 — タグ詳細の説明の下のボタン (説明文の編集履歴を開く)
        static var detailActionHistory: LocalizedStringResource {
            LocalizedStringResource("tags.detail.action.history", defaultValue: "編集履歴", table: "Tags", bundle: L10n.bundle)
        }
        /// 不適切なタグを通報 — タグ詳細の右上のメニューの項目
        static var detailActionReport: LocalizedStringResource {
            LocalizedStringResource("tags.detail.action.report", defaultValue: "不適切なタグを通報", table: "Tags", bundle: L10n.bundle)
        }
        /// カテゴリ: {category} — タグ詳細のカテゴリのバッジの読み上げ。category はコアの語彙の名前 (ムード・性格など) — 引数: category (core)
        static func detailCategoryA11y(category: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.category.a11y", defaultValue: "カテゴリ: \(category)", table: "Tags", bundle: L10n.bundle)
        }
        /// タグカラー: {hex} — タグ詳細の色の四角の読み上げ。hex は #RRGGBB の色の値 — 引数: hex (string)
        static func detailColorA11y(hex: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.color.a11y", defaultValue: "タグカラー: \(hex)", table: "Tags", bundle: L10n.bundle)
        }
        /// まだこのタグが付いたアイドルはいません — アイドルのタグ詳細で、付いたアイドルが 1 人もいないとき
        static var detailIdolsEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.detail.idols.empty", defaultValue: "まだこのタグが付いたアイドルはいません", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」なアイドルランキング（{count}人） — タグ詳細のランキングの見出し。name はタグ名、「◯◯な」は「そのタグらしい」の意味。このタグが付いたアイドルを票の多い順に並べる。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count)
        static func detailIdolsHeader(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.idols.header", defaultValue: "「\(name)」なアイドルランキング（\(count)人）", table: "Tags", bundle: L10n.bundle)
        }
        /// 説明なし — タグ詳細で、タグに説明文が無いとき
        static var detailNoDescription: LocalizedStringResource {
            LocalizedStringResource("tags.detail.no_description", defaultValue: "説明なし", table: "Tags", bundle: L10n.bundle)
        }
        /// 通報する — タグの通報の確認ダイアログの実行ボタン
        static var detailReportConfirmAction: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.confirm.action", defaultValue: "通報する", table: "Tags", bundle: L10n.bundle)
        }
        /// 不適切なコンテンツとして通報します — タグの通報の確認ダイアログの本文
        static var detailReportConfirmMessage: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.confirm.message", defaultValue: "不適切なコンテンツとして通報します", table: "Tags", bundle: L10n.bundle)
        }
        /// タグを通報 — タグの通報の確認ダイアログの見出し
        static var detailReportConfirmTitle: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.confirm.title", defaultValue: "タグを通報", table: "Tags", bundle: L10n.bundle)
        }
        /// ご報告ありがとうございます。内容を確認します。 — タグの通報を受け付けたときのダイアログの本文
        static var detailReportDoneMessage: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.done.message", defaultValue: "ご報告ありがとうございます。内容を確認します。", table: "Tags", bundle: L10n.bundle)
        }
        /// 通報しました — タグの通報を受け付けたときのダイアログの見出し
        static var detailReportDoneTitle: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.done.title", defaultValue: "通報しました", table: "Tags", bundle: L10n.bundle)
        }
        /// エラーが発生しました — タグの通報に失敗し、サーバから説明が来なかったとき
        static var detailReportErrorFallback: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.error.fallback", defaultValue: "エラーが発生しました", table: "Tags", bundle: L10n.bundle)
        }
        /// 本日通報上限です。明日また試してください。 — タグの通報が 1 日の上限に達したとき
        static var detailReportErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.error.rate_limited", defaultValue: "本日通報上限です。明日また試してください。", table: "Tags", bundle: L10n.bundle)
        }
        /// 通報エラー — タグの通報に失敗したときのダイアログの見出し
        static var detailReportErrorTitle: LocalizedStringResource {
            LocalizedStringResource("tags.detail.report.error.title", defaultValue: "通報エラー", table: "Tags", bundle: L10n.bundle)
        }
        /// まだこのタグが付いた曲はありません — 曲のタグ詳細で、付いた曲が 1 曲も無いとき
        static var detailSongsEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.detail.songs.empty", defaultValue: "まだこのタグが付いた曲はありません", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」な曲ランキング（{count}曲） — タグ詳細のランキングの見出し。name はタグ名、「◯◯な」は「そのタグらしい」の意味。このタグが付いた曲を票の多い順に並べる。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count)
        static func detailSongsHeader(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.songs.header", defaultValue: "「\(name)」な曲ランキング（\(count)曲）", table: "Tags", bundle: L10n.bundle)
        }
        /// まだこのタグが付いたユニットはいません — ユニットのタグ詳細で、付いたユニットが 1 つも無いとき
        static var detailUnitsEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.detail.units.empty", defaultValue: "まだこのタグが付いたユニットはいません", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」なユニットランキング（{count}組） — タグ詳細のランキングの見出し。name はタグ名、「◯◯な」は「そのタグらしい」の意味。このタグが付いたユニットを票の多い順に並べる。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: name (string), count (count)
        static func detailUnitsHeader(name: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.units.header", defaultValue: "「\(name)」なユニットランキング（\(count)組）", table: "Tags", bundle: L10n.bundle)
        }
        /// {count}票 — タグ詳細のランキングの行の右端、このタグへの票の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func detailVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.detail.votes", defaultValue: "\(count)票", table: "Tags", bundle: L10n.bundle)
        }
        /// 保存 — タグの編集シートの確定ボタン
        static var editActionSave: LocalizedStringResource {
            LocalizedStringResource("tags.edit.action.save", defaultValue: "保存", table: "Tags", bundle: L10n.bundle)
        }
        /// カテゴリ — タグの編集シートのカテゴリの見出し
        static var editCategoryHeader: LocalizedStringResource {
            LocalizedStringResource("tags.edit.category.header", defaultValue: "カテゴリ", table: "Tags", bundle: L10n.bundle)
        }
        /// 色 — タグの編集シートの色の見出し
        static var editColorHeader: LocalizedStringResource {
            LocalizedStringResource("tags.edit.color.header", defaultValue: "色", table: "Tags", bundle: L10n.bundle)
        }
        /// 説明文 — タグの編集シートの説明文の欄の見出し (Android は欄のラベル)
        static var editDescriptionHeader: LocalizedStringResource {
            LocalizedStringResource("tags.edit.description.header", defaultValue: "説明文", table: "Tags", bundle: L10n.bundle)
        }
        /// どんな時に使うタグか — タグの編集シートの説明文の欄のプレースホルダ
        static var editDescriptionPlaceholder: LocalizedStringResource {
            LocalizedStringResource("tags.edit.description.placeholder", defaultValue: "どんな時に使うタグか", table: "Tags", bundle: L10n.bundle)
        }
        /// 保存に失敗しました — タグの編集を保存できず、サーバから説明が来なかったとき
        static var editErrorFailed: LocalizedStringResource {
            LocalizedStringResource("tags.edit.error.failed", defaultValue: "保存に失敗しました", table: "Tags", bundle: L10n.bundle)
        }
        /// 保存に失敗しました: {detail} — タグの編集を保存できなかったとき (通信の失敗など)。detail は OS・通信層の説明 (訳さない) — 引数: detail (string)
        static func editErrorFailedDetail(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.edit.error.failed_detail", defaultValue: "保存に失敗しました: \(detail)", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{name}」を編集 — タグの編集シートの見出し。name はタグ名 — 引数: name (string)
        static func editTitle(name: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.edit.title", defaultValue: "「\(name)」を編集", table: "Tags", bundle: L10n.bundle)
        }
        /// 完了 — タグで絞り込むシートの確定ボタン
        static var filterActionDone: LocalizedStringResource {
            LocalizedStringResource("tags.filter.action.done", defaultValue: "完了", table: "Tags", bundle: L10n.bundle)
        }
        /// タグがありません — タグで絞り込むシートで候補が 1 つも無いとき
        static var filterEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.filter.empty", defaultValue: "タグがありません", table: "Tags", bundle: L10n.bundle)
        }
        /// {count}曲 — タグで絞り込むシートの行の右端、このタグが付いた曲の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func filterRowSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.filter.row.songs", defaultValue: "\(count)曲", table: "Tags", bundle: L10n.bundle)
        }
        /// タグ名で検索 — タグで絞り込むシートの検索欄のプレースホルダ
        static var filterSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("tags.filter.search.prompt", defaultValue: "タグ名で検索", table: "Tags", bundle: L10n.bundle)
        }
        /// 人気タグランキング — タグで絞り込むシートの候補の見出し (検索していないとき。人気順)
        static var filterSectionPopular: LocalizedStringResource {
            LocalizedStringResource("tags.filter.section.popular", defaultValue: "人気タグランキング", table: "Tags", bundle: L10n.bundle)
        }
        /// 検索結果 — タグで絞り込むシートの候補の見出し (検索中)
        static var filterSectionResults: LocalizedStringResource {
            LocalizedStringResource("tags.filter.section.results", defaultValue: "検索結果", table: "Tags", bundle: L10n.bundle)
        }
        /// 選択中 ({count}) — すべてを含む曲に絞り込み — タグで絞り込むシートの選んだタグの見出し。count は選んだタグの数。選んだタグを全部持つ曲だけに絞る (AND)。ko の「곡만 보기」は文中の動詞としての「絞り込み」なので、用語集の 필터 / 찾기 (機能名・ボタン名) は使わない。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func filterSelectedHeader(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.filter.selected.header", defaultValue: "選択中 (\(count)) — すべてを含む曲に絞り込み", table: "Tags", bundle: L10n.bundle)
        }
        /// タグで絞り込み — 曲一覧をタグで絞り込むシートの見出し
        static var filterTitle: LocalizedStringResource {
            LocalizedStringResource("tags.filter.title", defaultValue: "タグで絞り込み", table: "Tags", bundle: L10n.bundle)
        }
        /// 編集履歴はありません — タグの説明文の編集履歴が 1 件も無いとき
        static var historyEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.history.empty", defaultValue: "編集履歴はありません", table: "Tags", bundle: L10n.bundle)
        }
        /// （説明なし） — 編集履歴の行で、その版の説明文が空のとき
        static var historyNoDescription: LocalizedStringResource {
            LocalizedStringResource("tags.history.no_description", defaultValue: "（説明なし）", table: "Tags", bundle: L10n.bundle)
        }
        /// 編集履歴 — タグの説明文の編集履歴の画面の見出し
        static var historyTitle: LocalizedStringResource {
            LocalizedStringResource("tags.history.title", defaultValue: "編集履歴", table: "Tags", bundle: L10n.bundle)
        }
        /// 全て — タグ一覧の絞り込みシートのカテゴリの選択肢 (カテゴリで絞らない)
        static var listCategoryAll: LocalizedStringResource {
            LocalizedStringResource("tags.list.category.all", defaultValue: "全て", table: "Tags", bundle: L10n.bundle)
        }
        /// フリー — タグ一覧の絞り込みシートのカテゴリの選択肢 (分類の無い自由なタグ)
        static var listCategoryFree: LocalizedStringResource {
            LocalizedStringResource("tags.list.category.free", defaultValue: "フリー", table: "Tags", bundle: L10n.bundle)
        }
        /// ムード — タグ一覧の絞り込みシートのカテゴリの選択肢 (曲の雰囲気のタグ)
        static var listCategoryMood: LocalizedStringResource {
            LocalizedStringResource("tags.list.category.mood", defaultValue: "ムード", table: "Tags", bundle: L10n.bundle)
        }
        /// シーン — タグ一覧の絞り込みシートのカテゴリの選択肢 (聴く場面のタグ)
        static var listCategoryScene: LocalizedStringResource {
            LocalizedStringResource("tags.list.category.scene", defaultValue: "シーン", table: "Tags", bundle: L10n.bundle)
        }
        /// 特別 — タグ一覧の絞り込みシートのカテゴリの選択肢 (特別なタグ)
        static var listCategorySpecial: LocalizedStringResource {
            LocalizedStringResource("tags.list.category.special", defaultValue: "特別", table: "Tags", bundle: L10n.bundle)
        }
        /// タグはまだありません — タグ一覧にタグが 1 つも無いとき
        static var listEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("tags.list.empty.title", defaultValue: "タグはまだありません", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するタグがありません — 名前で絞り込んで 0 件のときの説明。query は入力した語 (Android はこれ 1 行だけを出す) — 引数: query (string)
        static func listFilterEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.list.filter_empty.message", defaultValue: "「\(query)」に一致するタグがありません", table: "Tags", bundle: L10n.bundle)
        }
        /// 絞り込み結果がありません — 名前で絞り込んで 0 件のときの空状態の見出し。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var listFilterEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("tags.list.filter_empty.title", defaultValue: "絞り込み結果がありません", table: "Tags", bundle: L10n.bundle)
        }
        /// タグ名で絞り込み — タグ一覧の上の名前の絞り込み欄のプレースホルダ
        static var listNameFilterPrompt: LocalizedStringResource {
            LocalizedStringResource("tags.list.name_filter.prompt", defaultValue: "タグ名で絞り込み", table: "Tags", bundle: L10n.bundle)
        }
        /// タグ: {name} — タグ一覧の行のタグ名の読み上げ。name はタグ名 (利用者が付けた名前) — 引数: name (string)
        static func listRowA11y(name: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.list.row.a11y", defaultValue: "タグ: \(name)", table: "Tags", bundle: L10n.bundle)
        }
        /// free — タグ一覧の行のカテゴリのバッジ。今は内部の値 (英字) をそのまま出しているので ja も英字のまま (ムード等の表記に揃えるかはオーナーが別 PR で)。分類の無い自由なタグ
        static var listRowCategoryFree: LocalizedStringResource {
            LocalizedStringResource("tags.list.row.category.free", defaultValue: "free", table: "Tags", bundle: L10n.bundle)
        }
        /// mood — タグ一覧の行のカテゴリのバッジ。今は内部の値 (英字) をそのまま出しているので ja も英字のまま (ムード等の表記に揃えるかはオーナーが別 PR で)。曲の雰囲気のタグ
        static var listRowCategoryMood: LocalizedStringResource {
            LocalizedStringResource("tags.list.row.category.mood", defaultValue: "mood", table: "Tags", bundle: L10n.bundle)
        }
        /// scene — タグ一覧の行のカテゴリのバッジ。今は内部の値 (英字) をそのまま出しているので ja も英字のまま (ムード等の表記に揃えるかはオーナーが別 PR で)。聴く場面のタグ
        static var listRowCategoryScene: LocalizedStringResource {
            LocalizedStringResource("tags.list.row.category.scene", defaultValue: "scene", table: "Tags", bundle: L10n.bundle)
        }
        /// special — タグ一覧の行のカテゴリのバッジ。今は内部の値 (英字) をそのまま出しているので ja も英字のまま (ムード等の表記に揃えるかはオーナーが別 PR で)。特別なタグ
        static var listRowCategorySpecial: LocalizedStringResource {
            LocalizedStringResource("tags.list.row.category.special", defaultValue: "special", table: "Tags", bundle: L10n.bundle)
        }
        /// {count}曲 — タグ一覧の行の右端、このタグが付いた曲の数。1000 以上は桁区切りが付く (Android は従来区切りなしの文字列だったので 1,000 のように変わる。iOS は Text の補間で従来も区切りが付いていた) — 引数: count (count)
        static func listRowSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.list.row.songs", defaultValue: "\(count)曲", table: "Tags", bundle: L10n.bundle)
        }
        /// 並び順 — タグ一覧の並び順メニュー (iOS は Picker のラベル、Android は並び替えアイコンの読み上げ)
        static var listSortLabel: LocalizedStringResource {
            LocalizedStringResource("tags.list.sort.label", defaultValue: "並び順", table: "Tags", bundle: L10n.bundle)
        }
        /// 名前 — タグ一覧の並び順の選択肢 (名前順)
        static var listSortName: LocalizedStringResource {
            LocalizedStringResource("tags.list.sort.name", defaultValue: "名前", table: "Tags", bundle: L10n.bundle)
        }
        /// 人気 — タグ一覧の並び順の選択肢 (人気順)
        static var listSortPopular: LocalizedStringResource {
            LocalizedStringResource("tags.list.sort.popular", defaultValue: "人気", table: "Tags", bundle: L10n.bundle)
        }
        /// 新着 — タグ一覧の並び順の選択肢 (新しく作られた順)
        static var listSortRecent: LocalizedStringResource {
            LocalizedStringResource("tags.list.sort.recent", defaultValue: "新着", table: "Tags", bundle: L10n.bundle)
        }
        /// タグ — タグ一覧の画面タイトル
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("tags.list.title", defaultValue: "タグ", table: "Tags", bundle: L10n.bundle)
        }
        /// 追加 — タグを付けるシートの確定ボタン (選んだタグをまとめて付ける)
        static var pickerActionAdd: LocalizedStringResource {
            LocalizedStringResource("tags.picker.action.add", defaultValue: "追加", table: "Tags", bundle: L10n.bundle)
        }
        /// 閉じる — 曲にタグを付けたあとの完了・シェアの画面の右上のボタン
        static var pickerActionClose: LocalizedStringResource {
            LocalizedStringResource("tags.picker.action.close", defaultValue: "閉じる", table: "Tags", bundle: L10n.bundle)
        }
        /// 「{query}」を作成 — 検索語と同じ名前のタグが無いときの、その名前で新しく作るボタン。query は入力した語 — 引数: query (string)
        static func pickerCreateFromSearch(query: String) -> LocalizedStringResource {
            LocalizedStringResource("tags.picker.create_from_search", defaultValue: "「\(query)」を作成", table: "Tags", bundle: L10n.bundle)
        }
        /// 色やカテゴリを付けて新規作成 — タグを付けるシートの下のボタン (新規タグ作成シートを開く)
        static var pickerCreateFull: LocalizedStringResource {
            LocalizedStringResource("tags.picker.create_full", defaultValue: "色やカテゴリを付けて新規作成", table: "Tags", bundle: L10n.bundle)
        }
        /// タグが見つかりません — タグを付けるシートで候補が 1 つも無いとき
        static var pickerEmpty: LocalizedStringResource {
            LocalizedStringResource("tags.picker.empty", defaultValue: "タグが見つかりません", table: "Tags", bundle: L10n.bundle)
        }
        /// タグの追加に失敗しました — 選んだタグを付けられなかったとき (iOS はアラートの見出し、Android はシートの中の文)
        static var pickerErrorApplyFailed: LocalizedStringResource {
            LocalizedStringResource("tags.picker.error.apply_failed", defaultValue: "タグの追加に失敗しました", table: "Tags", bundle: L10n.bundle)
        }
        /// タグを検索 / 新規作成 — タグを付けるシートの検索欄のプレースホルダ (無ければその語で新しく作れる)
        static var pickerSearchPrompt: LocalizedStringResource {
            LocalizedStringResource("tags.picker.search.prompt", defaultValue: "タグを検索 / 新規作成", table: "Tags", bundle: L10n.bundle)
        }
        /// 候補 — タグを付けるシートの候補の見出し (検索中)
        static var pickerSectionCandidates: LocalizedStringResource {
            LocalizedStringResource("tags.picker.section.candidates", defaultValue: "候補", table: "Tags", bundle: L10n.bundle)
        }
        /// よく使われるタグ — タグを付けるシートの候補の見出し (検索していないとき)
        static var pickerSectionPopular: LocalizedStringResource {
            LocalizedStringResource("tags.picker.section.popular", defaultValue: "よく使われるタグ", table: "Tags", bundle: L10n.bundle)
        }
        /// この曲 — タグ付けのシェアカードに出す曲名の代わり (曲の情報を読めなかったとき)
        static var pickerShareSongFallback: LocalizedStringResource {
            LocalizedStringResource("tags.picker.share.song_fallback", defaultValue: "この曲", table: "Tags", bundle: L10n.bundle)
        }
        /// タグを追加 — 曲・アイドル・ユニットにタグを付けるシートの見出し
        static var pickerTitle: LocalizedStringResource {
            LocalizedStringResource("tags.picker.title", defaultValue: "タグを追加", table: "Tags", bundle: L10n.bundle)
        }
        /// {rank}位 — 人気ランキングの順位バッジの読み上げ (タグ一覧・曲一覧のタグ絞り込み・タグ詳細)。rank は順位 (桁区切りなし) — 引数: rank (int)
        static func rankBadgeA11y(rank: Int) -> LocalizedStringResource {
            LocalizedStringResource("tags.rank_badge.a11y", defaultValue: "\(String(rank))位", table: "Tags", bundle: L10n.bundle)
        }
    }
}
