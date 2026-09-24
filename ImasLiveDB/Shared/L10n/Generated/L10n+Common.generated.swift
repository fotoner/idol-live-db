// 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/common.json の文言 (表 Common)
    enum Common {
        /// 閉じる — シートや完了画面を閉じるボタン (シェアカードのシート・タグ付与の完了画面)
        static var actionClose: LocalizedStringResource {
            LocalizedStringResource("common.action.close", defaultValue: "閉じる", table: "Common", bundle: L10n.bundle)
        }
        /// ログイン — 未ログインの人に出すインライン導線 (InlineLoginPrompt) のボタン。Android は同じ部品を持たずダイアログで案内する
        static var actionLogin: LocalizedStringResource {
            LocalizedStringResource("common.action.login", defaultValue: "ログイン", table: "Common", bundle: L10n.bundle)
        }
        /// OK — アラートの了解ボタン (シェア画像の生成に失敗したとき)
        static var actionOk: LocalizedStringResource {
            LocalizedStringResource("common.action.ok", defaultValue: "OK", table: "Common", bundle: L10n.bundle)
        }
        /// 再試行 — 読み込み失敗などの空状態に出す再試行ボタン
        static var actionRetry: LocalizedStringResource {
            LocalizedStringResource("common.action.retry", defaultValue: "再試行", table: "Common", bundle: L10n.bundle)
        }
        /// すべて見る — セクション見出し右の導線
        static var actionSeeAll: LocalizedStringResource {
            LocalizedStringResource("common.action.see_all", defaultValue: "すべて見る", table: "Common", bundle: L10n.bundle)
        }
        /// 取消 — 公演の行のスワイプに出る、参加の記録を取り消すボタン (幅が狭いので短い形)
        static var attendanceSwipeCancel: LocalizedStringResource {
            LocalizedStringResource("common.attendance_swipe.cancel", defaultValue: "取消", table: "Common", bundle: L10n.bundle)
        }
        /// 参加を登録 — 公演・ライブの行をスワイプすると出る参加登録のボタン
        static var attendanceSwipeRegister: LocalizedStringResource {
            LocalizedStringResource("common.attendance_swipe.register", defaultValue: "参加を登録", table: "Common", bundle: L10n.bundle)
        }
        /// 第{rank}位 — みんなの投票の終了お題での順位バッジ (2〜3 位)。お題名の後ろに付く。rank は順位 — 引数: rank (int)
        static func awardChipRank(rank: Int) -> LocalizedStringResource {
            LocalizedStringResource("common.award_chip.rank", defaultValue: "第\(String(rank))位", table: "Common", bundle: L10n.bundle)
        }
        /// {title} で第{rank}位 — 順位バッジの読み上げ (2〜3 位)。title はお題名、rank は順位 — 引数: title (string), rank (int)
        static func awardChipRankA11y(title: String, rank: Int) -> LocalizedStringResource {
            LocalizedStringResource("common.award_chip.rank.a11y", defaultValue: "\(title) で第\(String(rank))位", table: "Common", bundle: L10n.bundle)
        }
        /// 優勝 — みんなの投票の終了お題で 1 位になったことを示すバッジ (お題名の後ろに付く)
        static var awardChipWinner: LocalizedStringResource {
            LocalizedStringResource("common.award_chip.winner", defaultValue: "優勝", table: "Common", bundle: L10n.bundle)
        }
        /// {title} で優勝 — 順位バッジの読み上げ (1 位)。title はお題名 — 引数: title (string)
        static func awardChipWinnerA11y(title: String) -> LocalizedStringResource {
            LocalizedStringResource("common.award_chip.winner.a11y", defaultValue: "\(title) で優勝", table: "Common", bundle: L10n.bundle)
        }
        /// 全て — ブランドの絞り込みの「全ブランド」の選択肢 (選ぶとブランドの絞り込みを外す)
        static var brandFilterAll: LocalizedStringResource {
            LocalizedStringResource("common.brand_filter.all", defaultValue: "全て", table: "Common", bundle: L10n.bundle)
        }
        /// 全 — ブランドの絞り込みの「全て」の丸アイコンの中の字。短いほど大きい字で出る (2 文字までが最大)
        static var brandFilterAllIcon: LocalizedStringResource {
            LocalizedStringResource("common.brand_filter.all_icon", defaultValue: "全", table: "Common", bundle: L10n.bundle)
        }
        /// {count}人 — ブランドの区切り見出しの右の人数 (アイドル一覧・ピッカー)。1000 以上は桁区切りが付く (従来どおり) — 引数: count (count)
        static func brandSectionCountPeople(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("common.brand_section.count_people", defaultValue: "\(count)人", table: "Common", bundle: L10n.bundle)
        }
        /// カラー: {color} — イメージカラーの点の読み上げ。color は色の名前 (コアが hex から作る) — 引数: color (core)
        static func colorDotA11y(color: String) -> LocalizedStringResource {
            LocalizedStringResource("common.color_dot.a11y", defaultValue: "カラー: \(color)", table: "Common", bundle: L10n.bundle)
        }
        /// コピー — 長押しメニューのコピー項目の既定の文言 (何をコピーするかを渡さないとき)
        static var copyDefault: LocalizedStringResource {
            LocalizedStringResource("common.copy.default", defaultValue: "コピー", table: "Common", bundle: L10n.bundle)
        }
        /// ライブ名をコピー — ライブの行の長押しメニュー
        static var copyEventName: LocalizedStringResource {
            LocalizedStringResource("common.copy.event_name", defaultValue: "ライブ名をコピー", table: "Common", bundle: L10n.bundle)
        }
        /// アイドル名をコピー — アイドルの行の長押しメニュー
        static var copyIdolName: LocalizedStringResource {
            LocalizedStringResource("common.copy.idol_name", defaultValue: "アイドル名をコピー", table: "Common", bundle: L10n.bundle)
        }
        /// よみをコピー — アイドル・楽曲の行の長押しメニュー。よみ = 名前・曲名のかな読み
        static var copyKana: LocalizedStringResource {
            LocalizedStringResource("common.copy.kana", defaultValue: "よみをコピー", table: "Common", bundle: L10n.bundle)
        }
        /// {label}をコピー — 「よみ」「CV」などの行の長押しメニュー。label は行の見出し (よみ・CV・会場…) — 引数: label (string)
        static func copyLabeled(label: String) -> LocalizedStringResource {
            LocalizedStringResource("common.copy.labeled", defaultValue: "\(label)をコピー", table: "Common", bundle: L10n.bundle)
        }
        /// 歌唱者をコピー — 楽曲の行の長押しメニュー (歌っている人の並び)
        static var copySingers: LocalizedStringResource {
            LocalizedStringResource("common.copy.singers", defaultValue: "歌唱者をコピー", table: "Common", bundle: L10n.bundle)
        }
        /// 曲名をコピー — 楽曲の行の長押しメニュー
        static var copySongTitle: LocalizedStringResource {
            LocalizedStringResource("common.copy.song_title", defaultValue: "曲名をコピー", table: "Common", bundle: L10n.bundle)
        }
        /// 適用 — 絞り込みシート右上の、条件を一覧に反映して閉じるボタン
        static var filterSheetActionApply: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.action.apply", defaultValue: "適用", table: "Common", bundle: L10n.bundle)
        }
        /// リセット — 絞り込みシート左上の、条件をすべて外すボタン
        static var filterSheetActionReset: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.action.reset", defaultValue: "リセット", table: "Common", bundle: L10n.bundle)
        }
        /// すべて — 参加状態の選択肢 (絞り込まない)
        static var filterSheetAttendanceAll: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attendance.all", defaultValue: "すべて", table: "Common", bundle: L10n.bundle)
        }
        /// 参加済み — 参加状態の選択肢 (参加を記録したライブだけ)
        static var filterSheetAttendanceAttended: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attendance.attended", defaultValue: "参加済み", table: "Common", bundle: L10n.bundle)
        }
        /// 参加状態 — ライブの絞り込みシートの参加状態の節の見出し
        static var filterSheetAttendanceHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attendance.header", defaultValue: "参加状態", table: "Common", bundle: L10n.bundle)
        }
        /// 未参加 — 参加状態の選択肢 (参加を記録していないライブだけ)
        static var filterSheetAttendanceNotAttended: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attendance.not_attended", defaultValue: "未参加", table: "Common", bundle: L10n.bundle)
        }
        /// 全て — 属性の選択肢 (属性で絞り込まない)
        static var filterSheetAttributeAll: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.all", defaultValue: "全て", table: "Common", bundle: L10n.bundle)
        }
        /// エンジェル — ミリオンライブ・765AS の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeAngel: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.angel", defaultValue: "エンジェル", table: "Common", bundle: L10n.bundle)
        }
        /// クール — シンデレラガールズの属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeCool: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.cool", defaultValue: "クール", table: "Common", bundle: L10n.bundle)
        }
        /// キュート — シンデレラガールズの属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeCute: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.cute", defaultValue: "キュート", table: "Common", bundle: L10n.bundle)
        }
        /// フェアリー — ミリオンライブ・765AS の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeFairy: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.fairy", defaultValue: "フェアリー", table: "Common", bundle: L10n.bundle)
        }
        /// 属性 — アイドルの絞り込みシートの属性の節の見出し (ブランドを 1 つだけ選んだときに出る)
        static var filterSheetAttributeHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.header", defaultValue: "属性", table: "Common", bundle: L10n.bundle)
        }
        /// インテリ — SideM の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeIntelli: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.intelli", defaultValue: "インテリ", table: "Common", bundle: L10n.bundle)
        }
        /// メンタル — SideM の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributeMental: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.mental", defaultValue: "メンタル", table: "Common", bundle: L10n.bundle)
        }
        /// パッション — シンデレラガールズの属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributePassion: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.passion", defaultValue: "パッション", table: "Common", bundle: L10n.bundle)
        }
        /// フィジカル — SideM の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributePhysical: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.physical", defaultValue: "フィジカル", table: "Common", bundle: L10n.bundle)
        }
        /// プリンセス — ミリオンライブ・765AS の属性名 (公式の名前)。ko は音訳。表記はオーナー確定待ち
        static var filterSheetAttributePrincess: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.attribute.princess", defaultValue: "プリンセス", table: "Common", bundle: L10n.bundle)
        }
        /// 複数選択可能 — ブランドの節の下の補足 (いくつでも選べる)
        static var filterSheetBrandFooter: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.brand.footer", defaultValue: "複数選択可能", table: "Common", bundle: L10n.bundle)
        }
        /// ブランド — 絞り込みシートのブランドの節の見出し
        static var filterSheetBrandHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.brand.header", defaultValue: "ブランド", table: "Common", bundle: L10n.bundle)
        }
        /// カテゴリ — タグの絞り込みシートのカテゴリの節の見出し
        static var filterSheetCategoryHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.category.header", defaultValue: "カテゴリ", table: "Common", bundle: L10n.bundle)
        }
        /// 表示設定 — ライブの絞り込みシートの表示設定の節の見出し
        static var filterSheetDisplayHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.display.header", defaultValue: "表示設定", table: "Common", bundle: L10n.bundle)
        }
        /// セトリ情報がないイベントも表示 — 表示設定の節のスイッチ
        static var filterSheetDisplayShowEmptyEvents: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.display.show_empty_events", defaultValue: "セトリ情報がないイベントも表示", table: "Common", bundle: L10n.bundle)
        }
        /// 表示形式 — アイドルの絞り込みシートの表示形式の節の見出し
        static var filterSheetDisplayModeHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.display_mode.header", defaultValue: "表示形式", table: "Common", bundle: L10n.bundle)
        }
        /// 全て表示中 — 種別の節の下。除外している種別が無いとき
        static var filterSheetKindAllShown: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.kind.all_shown", defaultValue: "全て表示中", table: "Common", bundle: L10n.bundle)
        }
        /// 除外: {kinds} — 種別の節の下。除外している種別の並び。kinds は種別名 (コアの語彙) を「 / 」でつないだもの — 引数: kinds (core)
        static func filterSheetKindExcluded(kinds: String) -> LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.kind.excluded", defaultValue: "除外: \(kinds)", table: "Common", bundle: L10n.bundle)
        }
        /// 種別 — ライブの絞り込みシートの種別 (ライブ・フェス・リリイベ…) の節の見出し
        static var filterSheetKindHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.kind.header", defaultValue: "種別", table: "Common", bundle: L10n.bundle)
        }
        /// {kind} 除外 — 種別チップの読み上げ (その種別を外している状態)。kind は種別名 (コアの語彙) — 引数: kind (core)
        static func filterSheetKindChipExcludedA11y(kind: String) -> LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.kind_chip.excluded.a11y", defaultValue: "\(kind) 除外", table: "Common", bundle: L10n.bundle)
        }
        /// {kind} 表示 — 種別チップの読み上げ (その種別を出している状態)。kind は種別名 (コアの語彙) — 引数: kind (core)
        static func filterSheetKindChipShownA11y(kind: String) -> LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.kind_chip.shown.a11y", defaultValue: "\(kind) 表示", table: "Common", bundle: L10n.bundle)
        }
        /// メモがあるイベントのみ — ライブの絞り込みのマイマークの節のスイッチ
        static var filterSheetMyMarkEventNoteOnly: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.my_mark.event_note_only", defaultValue: "メモがあるイベントのみ", table: "Common", bundle: L10n.bundle)
        }
        /// お気に入りのみ — マイマークの節のスイッチ
        static var filterSheetMyMarkFavoriteOnly: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.my_mark.favorite_only", defaultValue: "お気に入りのみ", table: "Common", bundle: L10n.bundle)
        }
        /// マイマーク — 絞り込みシートのマイマーク (お気に入り・メモ・担当) の節の見出し
        static var filterSheetMyMarkHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.my_mark.header", defaultValue: "マイマーク", table: "Common", bundle: L10n.bundle)
        }
        /// メモがあるアイドルのみ — アイドルの絞り込みのマイマークの節のスイッチ
        static var filterSheetMyMarkIdolNoteOnly: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.my_mark.idol_note_only", defaultValue: "メモがあるアイドルのみ", table: "Common", bundle: L10n.bundle)
        }
        /// 担当のみ — アイドルの絞り込みのマイマークの節のスイッチ
        static var filterSheetMyMarkMyPickOnly: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.my_mark.my_pick_only", defaultValue: "担当のみ", table: "Common", bundle: L10n.bundle)
        }
        /// CV名を併記 — 表示形式の節のスイッチ (アイドル名の下に声優名も出す)
        static var filterSheetShowCv: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.show_cv", defaultValue: "CV名を併記", table: "Common", bundle: L10n.bundle)
        }
        /// 方向 — 並び順の向き (昇順・降順) を選ぶ切り替えの名前
        static var filterSheetSortDirection: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.sort.direction", defaultValue: "方向", table: "Common", bundle: L10n.bundle)
        }
        /// 並び順 — 絞り込みシートの並び順の節の見出しと、並び順のメニューの名前
        static var filterSheetSortHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.sort.header", defaultValue: "並び順", table: "Common", bundle: L10n.bundle)
        }
        /// ブランドの区切りを外して通しで並べます — 並び順の節の下の説明 (ブランドごとに分けない並び順を選んだとき)
        static var filterSheetSortUngroupedFooter: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.sort.ungrouped_footer", defaultValue: "ブランドの区切りを外して通しで並べます", table: "Common", bundle: L10n.bundle)
        }
        /// フィルタ — 絞り込みシートのナビゲーションタイトル
        static var filterSheetTitle: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.title", defaultValue: "フィルタ", table: "Common", bundle: L10n.bundle)
        }
        /// その会場で公演があったライブに絞ります — 会場の節の下の説明
        static var filterSheetVenueFooter: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.venue.footer", defaultValue: "その会場で公演があったライブに絞ります", table: "Common", bundle: L10n.bundle)
        }
        /// 会場 — ライブの絞り込みシートの会場の節の見出し
        static var filterSheetVenueHeader: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.venue.header", defaultValue: "会場", table: "Common", bundle: L10n.bundle)
        }
        /// 選択なし — 会場がまだ選ばれていないときの行の表示
        static var filterSheetVenueNone: LocalizedStringResource {
            LocalizedStringResource("common.filter_sheet.venue.none", defaultValue: "選択なし", table: "Common", bundle: L10n.bundle)
        }
        /// アイテムが見つかりません — ジャケットの格子一覧 (シリーズ・アルバム) が空のときの既定の見出し
        static var gridEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("common.grid.empty.title", defaultValue: "アイテムが見つかりません", table: "Common", bundle: L10n.bundle)
        }
        /// 「{query}」に一致する項目がありません — 候補ピッカーで検索語に合う候補が無いときの説明。query は利用者が打った語 — 引数: query (string)
        static func listPickerEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("common.list_picker.empty.message", defaultValue: "「\(query)」に一致する項目がありません", table: "Common", bundle: L10n.bundle)
        }
        /// 見つかりません — 候補ピッカーで検索語に合う候補が無いときの見出し
        static var listPickerEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("common.list_picker.empty.title", defaultValue: "見つかりません", table: "Common", bundle: L10n.bundle)
        }
        /// 選択なし — 候補から 1 つ選ぶピッカー (シリーズ・ライブ名など) の先頭の行。選ぶと絞り込みを外す
        static var listPickerNone: LocalizedStringResource {
            LocalizedStringResource("common.list_picker.none", defaultValue: "選択なし", table: "Common", bundle: L10n.bundle)
        }
        /// {title}を検索 — 候補ピッカーの検索欄のプレースホルダ。title はピッカーの名前 (シリーズ・ライブ名など。呼び出し側の文言) — 引数: title (string)
        static func listPickerSearchPrompt(title: String) -> LocalizedStringResource {
            LocalizedStringResource("common.list_picker.search_prompt", defaultValue: "\(title)を検索", table: "Common", bundle: L10n.bundle)
        }
        /// その他の操作 — 一覧のツールバー右の「…」メニューの読み上げ (追加・表示切替などをまとめたもの)
        static var listToolbarMoreA11y: LocalizedStringResource {
            LocalizedStringResource("common.list_toolbar.more.a11y", defaultValue: "その他の操作", table: "Common", bundle: L10n.bundle)
        }
        /// 参加の記録 — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 (公演の行のスワイプで参加を登録・取り消す)
        static var localWriteRecordAttendance: LocalizedStringResource {
            LocalizedStringResource("common.local_write.record_attendance", defaultValue: "参加の記録", table: "Common", bundle: L10n.bundle)
        }
        /// 担当の切り替え — 端末への書き込みに失敗したときの知らせ「{操作}に失敗しました…」に入る操作名 (一覧の行のハートで担当を付け外しする)
        static var localWriteToggleMyPick: LocalizedStringResource {
            LocalizedStringResource("common.local_write.toggle_my_pick", defaultValue: "担当の切り替え", table: "Common", bundle: L10n.bundle)
        }
        /// 担当に追加 — 一覧の行のハートボタンの読み上げ (まだ担当でないとき。押すと担当になる)
        static var myPickToggleAddA11y: LocalizedStringResource {
            LocalizedStringResource("common.my_pick_toggle.add.a11y", defaultValue: "担当に追加", table: "Common", bundle: L10n.bundle)
        }
        /// 担当解除 — 一覧の行のハートボタンの読み上げ (担当のとき。押すと担当を外す)
        static var myPickToggleRemoveA11y: LocalizedStringResource {
            LocalizedStringResource("common.my_pick_toggle.remove.a11y", defaultValue: "担当解除", table: "Common", bundle: L10n.bundle)
        }
        /// 絞り込みを解除 — 名前の絞り込み欄の右の × ボタンの読み上げ (入力を消す)。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var nameFilterClearA11y: LocalizedStringResource {
            LocalizedStringResource("common.name_filter.clear.a11y", defaultValue: "絞り込みを解除", table: "Common", bundle: L10n.bundle)
        }
        /// 回 — ランキング行 (ImasRankingRow) の数値の後ろに付く単位の既定 (回数)。呼び出し側が単位を渡さないときに出る
        static var rankingRowUnitDefault: LocalizedStringResource {
            LocalizedStringResource("common.ranking_row.unit_default", defaultValue: "回", table: "Common", bundle: L10n.bundle)
        }
        /// {label} を解除 — 適用中の絞り込みを表すチップ (ImasRemovableChip) の読み上げ。label はチップの文言 — 引数: label (string)
        static func removableChipRemoveA11y(label: String) -> LocalizedStringResource {
            LocalizedStringResource("common.removable_chip.remove.a11y", defaultValue: "\(label) を解除", table: "Common", bundle: L10n.bundle)
        }
    }
}
