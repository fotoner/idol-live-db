// 生成物: i18n/catalog/mastery.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/mastery.json の文言 (表 Mastery)
    enum Mastery {
        /// この {count} 曲すべて — 一括更新のメニューの節: 群の曲すべての段階を変える — 引数: count (count)
        static func bulkAllSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.bulk.all_songs", defaultValue: "この \(count) 曲すべて", table: "Mastery", bundle: L10n.bundle)
        }
        /// 未設定に戻す — 一括更新のメニュー: 群の曲すべてを未設定に戻す
        static var bulkReset: LocalizedStringResource {
            LocalizedStringResource("mastery.bulk.reset", defaultValue: "未設定に戻す", table: "Mastery", bundle: L10n.bundle)
        }
        /// 未設定の {count} 曲だけ — 一括更新のメニューの節: 未設定の曲だけに段階を付ける — 引数: count (count)
        static func bulkUnsetOnly(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.bulk.unset_only", defaultValue: "未設定の \(count) 曲だけ", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度 {level} — 行の段階チップの読み上げ。level は段の名前 (利用者が付けたラベルのこともある) — 引数: level (string)
        static func chipA11y(level: String) -> LocalizedStringResource {
            LocalizedStringResource("mastery.chip.a11y", defaultValue: "習熟度 \(level)", table: "Mastery", bundle: L10n.bundle)
        }
        /// すべて — 進み具合の絞り込み: 絞らない
        static var filterProgressAll: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.progress.all", defaultValue: "すべて", table: "Mastery", bundle: L10n.bundle)
        }
        /// 完了 — 進み具合の絞り込み: 全曲が最上段の群
        static var filterProgressComplete: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.progress.complete", defaultValue: "完了", table: "Mastery", bundle: L10n.bundle)
        }
        /// 未設定あり — 進み具合の絞り込み: 未設定の曲がある群
        static var filterProgressHasUnset: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.progress.has_unset", defaultValue: "未設定あり", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聴いたのに未設定 — 進み具合の絞り込み: 現地で聴いたのに段階を付けていない曲がある群
        static var filterProgressHeardButUnset: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.progress.heard_but_unset", defaultValue: "聴いたのに未設定", table: "Mastery", bundle: L10n.bundle)
        }
        /// 手つかず — 進み具合の絞り込み: まだ 1 曲も段階を付けていない群
        static var filterProgressUntouched: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.progress.untouched", defaultValue: "手つかず", table: "Mastery", bundle: L10n.bundle)
        }
        /// 進み具合 — 絞り込みシートの節: 進み具合
        static var filterSectionProgress: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.section.progress", defaultValue: "進み具合", table: "Mastery", bundle: L10n.bundle)
        }
        /// 並び — 絞り込みシートの節: 並び順
        static var filterSectionSort: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.section.sort", defaultValue: "並び", table: "Mastery", bundle: L10n.bundle)
        }
        /// 名前順 — 群の並び
        static var filterSortName: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.sort.name", defaultValue: "名前順", table: "Mastery", bundle: L10n.bundle)
        }
        /// 進み具合が低い順 — 群の並び
        static var filterSortProgressAsc: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.sort.progress_asc", defaultValue: "進み具合が低い順", table: "Mastery", bundle: L10n.bundle)
        }
        /// 進み具合が高い順 — 群の並び
        static var filterSortProgressDesc: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.sort.progress_desc", defaultValue: "進み具合が高い順", table: "Mastery", bundle: L10n.bundle)
        }
        /// 曲数順 — 群の並び: 曲の多い順
        static var filterSortSongCount: LocalizedStringResource {
            LocalizedStringResource("mastery.filter.sort.song_count", defaultValue: "曲数順", table: "Mastery", bundle: L10n.bundle)
        }
        /// まとめて変える — 群の詳細の右上の ⋯ ボタン (一括更新のメニュー) の読み上げ
        static var groupBulkA11y: LocalizedStringResource {
            LocalizedStringResource("mastery.group.bulk.a11y", defaultValue: "まとめて変える", table: "Mastery", bundle: L10n.bundle)
        }
        /// 段階の絞り込みを外してください。 — 段階で絞った結果、曲が無いときの説明
        static var groupEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("mastery.group.empty.message", defaultValue: "段階の絞り込みを外してください。", table: "Mastery", bundle: L10n.bundle)
        }
        /// 該当する曲がありません — 段階で絞った結果、曲が無いときの見出し
        static var groupEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("mastery.group.empty.title", defaultValue: "該当する曲がありません", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聴いたのに未設定 {songs} — 段階の絞り込みチップ: 現地で聴いたのに段階を付けていない曲だけ — 引数: songs (int)
        static func groupFilterHeardButUnset(songs: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.group.filter.heard_but_unset", defaultValue: "聴いたのに未設定 \(String(songs))", table: "Mastery", bundle: L10n.bundle)
        }
        /// 現地で聴いた — 曲の行の ✓ (現地で聴いた曲) の読み上げ
        static var groupRowHeardA11y: LocalizedStringResource {
            LocalizedStringResource("mastery.group.row.heard.a11y", defaultValue: "現地で聴いた", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count}曲 — 曲一覧の見出しの右の曲数 (絞っていないとき) — 引数: count (count)
        static func groupSongsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.group.songs.count", defaultValue: "\(count)曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// {shown} / {count}曲 — 曲一覧の見出しの右: 絞り込んで見えている曲数 / 群の曲数。群は最大でも数百曲 — 引数: shown (int), count (count)
        static func groupSongsCountFiltered(shown: Int, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.group.songs.count_filtered", defaultValue: "\(String(shown)) / \(count)曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// 収録曲 — 群の詳細の曲一覧の見出し
        static var groupSongsHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.group.songs.header", defaultValue: "収録曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// 押すと 1 段上がります。行を左スワイプすると段を選べます — 行末の段階チップの操作の説明 (VoiceOver のヒント)
        static var groupStageChipA11yHint: LocalizedStringResource {
            LocalizedStringResource("mastery.group.stage_chip.a11y_hint", defaultValue: "押すと 1 段上がります。行を左スワイプすると段を選べます", table: "Mastery", bundle: L10n.bundle)
        }
        /// このグループの習熟度 — 群の詳細の先頭の進み具合の節の見出し
        static var groupSummaryHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.group.summary.header", defaultValue: "このグループの習熟度", table: "Mastery", bundle: L10n.bundle)
        }
        /// 元に戻す — 一括更新の帯の取り消しボタン
        static var groupUndoAction: LocalizedStringResource {
            LocalizedStringResource("mastery.group.undo.action", defaultValue: "元に戻す", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count}曲を「{level}」に — 一括更新の直後に下に出る帯の文。level は付けた段の名前 — 引数: count (count), level (string)
        static func groupUndoLabel(count: Int, level: String) -> LocalizedStringResource {
            LocalizedStringResource("mastery.group.undo.label", defaultValue: "\(count)曲を「\(level)」に", table: "Mastery", bundle: L10n.bundle)
        }
        /// 未設定 — 習熟度の段階が付いていない状態 (0 段) の名前。行のチップ・段階の絞り込み・a11y に出る
        static var levelUnset: LocalizedStringResource {
            LocalizedStringResource("mastery.level.unset", defaultValue: "未設定", table: "Mastery", bundle: L10n.bundle)
        }
        /// CDシリーズ — 群の分け方のセグメント: CD シリーズごと
        static var listAxisSeries: LocalizedStringResource {
            LocalizedStringResource("mastery.list.axis.series", defaultValue: "CDシリーズ", table: "Mastery", bundle: L10n.bundle)
        }
        /// ユニット — 群の分け方のセグメント: ユニット (歌唱名義) ごと
        static var listAxisUnit: LocalizedStringResource {
            LocalizedStringResource("mastery.list.axis.unit", defaultValue: "ユニット", table: "Mastery", bundle: L10n.bundle)
        }
        /// 年代 — 群の分け方のセグメント: 発売年ごと
        static var listAxisYear: LocalizedStringResource {
            LocalizedStringResource("mastery.list.axis.year", defaultValue: "年代", table: "Mastery", bundle: L10n.bundle)
        }
        /// 全て — ブランドの絞り込みチップの先頭 (絞らない)
        static var listBrandAll: LocalizedStringResource {
            LocalizedStringResource("mastery.list.brand.all", defaultValue: "全て", table: "Mastery", bundle: L10n.bundle)
        }
        /// 絞り込みを緩めてください。 — 絞り込みの結果、群が 1 つも無いときの説明
        static var listEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("mastery.list.empty.message", defaultValue: "絞り込みを緩めてください。", table: "Mastery", bundle: L10n.bundle)
        }
        /// 該当するグループがありません — 絞り込みの結果、群が 1 つも無いときの見出し
        static var listEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("mastery.list.empty.title", defaultValue: "該当するグループがありません", table: "Mastery", bundle: L10n.bundle)
        }
        /// フィルタ — 右上の絞り込みボタンの読み上げ
        static var listFilterA11y: LocalizedStringResource {
            LocalizedStringResource("mastery.list.filter.a11y", defaultValue: "フィルタ", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count}枚 — 群の行の副題: その群の CD の枚数。副題は「 ・ 」で並ぶ — 引数: count (count)
        static func listGroupDiscs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.list.group.discs", defaultValue: "\(count)枚", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聴いた {songs} — 群の行の副題: 現地で聴いた (回収した) 曲の数 — 引数: songs (int)
        static func listGroupHeard(songs: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.list.group.heard", defaultValue: "聴いた \(String(songs))", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聴いたのに未設定 {songs} — 群の行の副題: 現地で聴いた (回収した) のに段階を付けていない曲の数 — 引数: songs (int)
        static func listGroupHeardButUnset(songs: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.list.group.heard_but_unset", defaultValue: "聴いたのに未設定 \(String(songs))", table: "Mastery", bundle: L10n.bundle)
        }
        ///  ・  — 群の行の副題の区切り (前後に空白)
        static var listGroupSeparator: LocalizedStringResource {
            LocalizedStringResource("mastery.list.group.separator", defaultValue: " ・ ", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count}曲 — 群の行の副題: その群の曲数。1000 以上は桁区切りが付く — 引数: count (count)
        static func listGroupSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.list.group.songs", defaultValue: "\(count)曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count} 件 — 群の一覧の件数。1000 以上は桁区切りが付く (1,047 件) — 引数: count (count)
        static func listGroupsCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.list.groups.count", defaultValue: "\(count) 件", table: "Mastery", bundle: L10n.bundle)
        }
        /// グループ別 — 群 (CD シリーズ / ユニット / 年代) の一覧の見出し
        static var listGroupsHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.list.groups.header", defaultValue: "グループ別", table: "Mastery", bundle: L10n.bundle)
        }
        /// CDシリーズ名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (CD シリーズで分けているとき)
        static var listNameFilterSeries: LocalizedStringResource {
            LocalizedStringResource("mastery.list.name_filter.series", defaultValue: "CDシリーズ名で絞り込み", table: "Mastery", bundle: L10n.bundle)
        }
        /// ユニット名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (ユニットで分けているとき)
        static var listNameFilterUnit: LocalizedStringResource {
            LocalizedStringResource("mastery.list.name_filter.unit", defaultValue: "ユニット名で絞り込み", table: "Mastery", bundle: L10n.bundle)
        }
        /// 年代名で絞り込み — 群の名前の絞り込み欄のプレースホルダ (年代で分けているとき。群の名前は 2023年 など)
        static var listNameFilterYear: LocalizedStringResource {
            LocalizedStringResource("mastery.list.name_filter.year", defaultValue: "年代名で絞り込み", table: "Mastery", bundle: L10n.bundle)
        }
        /// あなたの習熟度 — 一覧の先頭の全体の進み具合の節の見出し
        static var listSummaryHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.list.summary.header", defaultValue: "あなたの習熟度", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度 — 習熟度ダッシュボードの画面の題
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("mastery.list.title", defaultValue: "習熟度", table: "Mastery", bundle: L10n.bundle)
        }
        /// {steps}段 — 段階の設定のプリセットのチップ (2段 / 3段 / 4段)。steps は段の数 — 引数: steps (int)
        static func presetName(steps: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.preset.name", defaultValue: "\(String(steps))段", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聞いた — 2 段のプリセットの 1 段目 (いちばん下)。保存値は ja のままで、表示だけ訳す。スワイプのボタンに収まるよう 4 文字以内
        static var presetSteps2Level1: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps2.level1", defaultValue: "聞いた", table: "Mastery", bundle: L10n.bundle)
        }
        /// 覚えた — 2 段のプリセットの 2 段目 (最上段)。4 文字以内
        static var presetSteps2Level2: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps2.level2", defaultValue: "覚えた", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聞いた — 3 段のプリセット (既定) の 1 段目。4 文字以内
        static var presetSteps3Level1: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps3.level1", defaultValue: "聞いた", table: "Mastery", bundle: L10n.bundle)
        }
        /// 覚えた — 3 段のプリセット (既定) の 2 段目。4 文字以内
        static var presetSteps3Level2: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps3.level2", defaultValue: "覚えた", table: "Mastery", bundle: L10n.bundle)
        }
        /// 完璧 — 3 段のプリセット (既定) の 3 段目 (最上段)。4 文字以内
        static var presetSteps3Level3: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps3.level3", defaultValue: "完璧", table: "Mastery", bundle: L10n.bundle)
        }
        /// 聞いた — 4 段のプリセットの 1 段目。4 文字以内
        static var presetSteps4Level1: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps4.level1", defaultValue: "聞いた", table: "Mastery", bundle: L10n.bundle)
        }
        /// だいたい — 4 段のプリセットの 2 段目 (だいたい覚えた、の意)。4 文字以内
        static var presetSteps4Level2: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps4.level2", defaultValue: "だいたい", table: "Mastery", bundle: L10n.bundle)
        }
        /// 覚えた — 4 段のプリセットの 3 段目。4 文字以内
        static var presetSteps4Level3: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps4.level3", defaultValue: "覚えた", table: "Mastery", bundle: L10n.bundle)
        }
        /// 完璧 — 4 段のプリセットの 4 段目 (最上段)。4 文字以内
        static var presetSteps4Level4: LocalizedStringResource {
            LocalizedStringResource("mastery.preset.steps4.level4", defaultValue: "完璧", table: "Mastery", bundle: L10n.bundle)
        }
        /// この段階にする — 段階の設定を反映するボタン
        static var settingsActionApply: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.action.apply", defaultValue: "この段階にする", table: "Mastery", bundle: L10n.bundle)
        }
        /// 元に戻す — 編集中の段階を保存済みの状態に戻すボタン
        static var settingsActionRevert: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.action.revert", defaultValue: "元に戻す", table: "Mastery", bundle: L10n.bundle)
        }
        /// 空の段と同じ名前の段は置けません。 — 段の名前が空か重複しているときの注意
        static var settingsInvalid: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.invalid", defaultValue: "空の段と同じ名前の段は置けません。", table: "Mastery", bundle: L10n.bundle)
        }
        /// どのラベルも 4 文字以内にしておくと、一覧のスワイプで切れずに出ます。 — プリセットの節の下の説明
        static var settingsPresetFooter: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.preset.footer", defaultValue: "どのラベルも 4 文字以内にしておくと、一覧のスワイプで切れずに出ます。", table: "Mastery", bundle: L10n.bundle)
        }
        /// プリセット — プリセットの節の見出し
        static var settingsPresetHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.preset.header", defaultValue: "プリセット", table: "Mastery", bundle: L10n.bundle)
        }
        /// 最上段 — 段を減らすときの注意の移り先の名前が引けなかったときの代わり。settings.shrink.warning の stage に入る (ko は後ろに「단계로」が続くので「단계」を付けない)
        static var settingsShrinkTopStage: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.shrink.top_stage", defaultValue: "最上段", table: "Mastery", bundle: L10n.bundle)
        }
        /// {count} 曲が「{stage}」に移ります。記録は消えません。 — 段を減らすときの注意。stage は移り先の段の名前 (利用者が付けたラベル。引けないときは settings.shrink.top_stage)。1000 以上は桁区切りが付く (1,234 曲が…) — 引数: count (count), stage (string)
        static func settingsShrinkWarning(count: Int, stage: String) -> LocalizedStringResource {
            LocalizedStringResource("mastery.settings.shrink.warning", defaultValue: "\(count) 曲が「\(stage)」に移ります。記録は消えません。", table: "Mastery", bundle: L10n.bundle)
        }
        /// 段を追加 — 段を 1 つ足すボタン
        static var settingsStageAdd: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.stage.add", defaultValue: "段を追加", table: "Mastery", bundle: L10n.bundle)
        }
        /// 右の数字はいまその段にある曲数。削除できるのは最上段だけです。 — 段の一覧の節の下の説明
        static var settingsStageFooter: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.stage.footer", defaultValue: "右の数字はいまその段にある曲数。削除できるのは最上段だけです。", table: "Mastery", bundle: L10n.bundle)
        }
        /// 下から順に積み上がる — 段の一覧の節の見出し (上の段ほど進んでいる)
        static var settingsStageHeader: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.stage.header", defaultValue: "下から順に積み上がる", table: "Mastery", bundle: L10n.bundle)
        }
        /// 段の名前 — 段の名前の入力欄のプレースホルダ
        static var settingsStagePlaceholder: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.stage.placeholder", defaultValue: "段の名前", table: "Mastery", bundle: L10n.bundle)
        }
        /// 最上段を削除 — 最上段の右の − ボタンの読み上げ
        static var settingsStageRemoveA11y: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.stage.remove.a11y", defaultValue: "最上段を削除", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度の段階 — 段階の設定の画面の題
        static var settingsTitle: LocalizedStringResource {
            LocalizedStringResource("mastery.settings.title", defaultValue: "習熟度の段階", table: "Mastery", bundle: L10n.bundle)
        }
        /// {level} {count} 曲 — 最上段 (例: 完璧) にある曲数。level は最上段の名前 (利用者が付けたラベルのこともある)。1000 以上は桁区切りが付く (完璧 1,234 曲) — 引数: level (string), count (count)
        static func summaryDoneSongs(level: String, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.summary.done_songs", defaultValue: "\(level) \(count) 曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// 段階を付けた曲 — 進み具合の大きな数字の説明
        static var summarySetSongs: LocalizedStringResource {
            LocalizedStringResource("mastery.summary.set_songs", defaultValue: "段階を付けた曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// / {count}曲 — 進み具合の大きな数字 (段階を付けた曲数) の右に出る分母。1000 以上は桁区切りが付く (/ 3,012曲) — 引数: count (count)
        static func summaryTotalSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("mastery.summary.total_songs", defaultValue: "/ \(count)曲", table: "Mastery", bundle: L10n.bundle)
        }
        /// 未設定 — 曲の行を右へスワイプすると出る、段階を未設定に戻すボタン
        static var swipeActionUnset: LocalizedStringResource {
            LocalizedStringResource("mastery.swipe.action.unset", defaultValue: "未設定", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度の記録 — 書き込みに失敗したときの知らせに入る操作の名前 (「〜に失敗しました」の〜の部分)
        static var writeActionRecord: LocalizedStringResource {
            LocalizedStringResource("mastery.write_action.record", defaultValue: "習熟度の記録", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度のまとめての記録 — まとめて段階を付けるのに失敗したときの知らせに入る操作の名前
        static var writeActionRecordBulk: LocalizedStringResource {
            LocalizedStringResource("mastery.write_action.record_bulk", defaultValue: "習熟度のまとめての記録", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度の段階の保存 — 段階の設定の保存に失敗したときの知らせに入る操作の名前
        static var writeActionScaleSave: LocalizedStringResource {
            LocalizedStringResource("mastery.write_action.scale_save", defaultValue: "習熟度の段階の保存", table: "Mastery", bundle: L10n.bundle)
        }
        /// 習熟度の取り消し — 一括更新の取り消しに失敗したときの知らせに入る操作の名前
        static var writeActionUndo: LocalizedStringResource {
            LocalizedStringResource("mastery.write_action.undo", defaultValue: "習熟度の取り消し", table: "Mastery", bundle: L10n.bundle)
        }
    }
}
