// 生成物: i18n/catalog/units.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/units.json の文言 (表 Units)
    enum Units {
        /// タグ付け・投票にはログインが必要です — コミュニティの節の先頭に出す、未ログインの人への案内
        static var detailCommunityLoginPrompt: LocalizedStringResource {
            LocalizedStringResource("units.detail.community.login_prompt", defaultValue: "タグ付け・投票にはログインが必要です", table: "Units", bundle: L10n.bundle)
        }
        /// ユニット名をコピー — ユニット名の長押しメニュー
        static var detailCopyName: LocalizedStringResource {
            LocalizedStringResource("units.detail.copy.name", defaultValue: "ユニット名をコピー", table: "Units", bundle: L10n.bundle)
        }
        /// 別名をコピー — ユニット名の長押しメニュー (別名 = 英字表記など)
        static var detailCopyNameAlt: LocalizedStringResource {
            LocalizedStringResource("units.detail.copy.name_alt", defaultValue: "別名をコピー", table: "Units", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました。通信状況を確認してもう一度お試しください。 — 詳細の読み込みに失敗したときの説明
        static var detailLoadErrorMessage: LocalizedStringResource {
            LocalizedStringResource("units.detail.load_error.message", defaultValue: "読み込みに失敗しました。通信状況を確認してもう一度お試しください。", table: "Units", bundle: L10n.bundle)
        }
        /// 読み込みに失敗しました — 詳細の読み込みに失敗したときの空状態の見出し
        static var detailLoadErrorTitle: LocalizedStringResource {
            LocalizedStringResource("units.detail.load_error.title", defaultValue: "読み込みに失敗しました", table: "Units", bundle: L10n.bundle)
        }
        /// メンバー情報はまだ登録されていません。 — メンバーが 1 人も無いときの空状態の説明
        static var detailMembersEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("units.detail.members.empty.message", defaultValue: "メンバー情報はまだ登録されていません。", table: "Units", bundle: L10n.bundle)
        }
        /// メンバーがいません — メンバーが 1 人も無いときの空状態の見出し
        static var detailMembersEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("units.detail.members.empty.title", defaultValue: "メンバーがいません", table: "Units", bundle: L10n.bundle)
        }
        /// メンバー — メンバーの節の見出し (右に人数)
        static var detailMembersHeader: LocalizedStringResource {
            LocalizedStringResource("units.detail.members.header", defaultValue: "メンバー", table: "Units", bundle: L10n.bundle)
        }
        /// マイタグを削除 — マイタグの長押しメニュー
        static var detailPersonalTagsActionRemove: LocalizedStringResource {
            LocalizedStringResource("units.detail.personal_tags.action.remove", defaultValue: "マイタグを削除", table: "Units", bundle: L10n.bundle)
        }
        /// マイタグを追加 — マイタグの入力欄の右の ＋ ボタンの読み上げ
        static var detailPersonalTagsAddA11y: LocalizedStringResource {
            LocalizedStringResource("units.detail.personal_tags.add.a11y", defaultValue: "マイタグを追加", table: "Units", bundle: L10n.bundle)
        }
        /// 自分だけに表示されます (コミュニティには公開されません) — マイタグの節の見出しの下の説明
        static var detailPersonalTagsCaption: LocalizedStringResource {
            LocalizedStringResource("units.detail.personal_tags.caption", defaultValue: "自分だけに表示されます (コミュニティには公開されません)", table: "Units", bundle: L10n.bundle)
        }
        /// マイタグ — マイタグ (自分だけのタグ) の節の見出し。Android は共通部品 PersonalTagsSection にある
        static var detailPersonalTagsHeader: LocalizedStringResource {
            LocalizedStringResource("units.detail.personal_tags.header", defaultValue: "マイタグ", table: "Units", bundle: L10n.bundle)
        }
        /// マイタグを追加 (例: 聞いた) — マイタグの入力欄のプレースホルダ。例の語も訳す
        static var detailPersonalTagsPlaceholder: LocalizedStringResource {
            LocalizedStringResource("units.detail.personal_tags.placeholder", defaultValue: "マイタグを追加 (例: 聞いた)", table: "Units", bundle: L10n.bundle)
        }
        /// つけられたタグが似ているユニット — タグが似ているユニットの節の見出しの下の説明
        static var detailSimilarCaption: LocalizedStringResource {
            LocalizedStringResource("units.detail.similar.caption", defaultValue: "つけられたタグが似ているユニット", table: "Units", bundle: L10n.bundle)
        }
        /// タグが似ているユニット — タグが似ているユニット (サーバ算出のおすすめ) の節の見出し
        static var detailSimilarHeader: LocalizedStringResource {
            LocalizedStringResource("units.detail.similar.header", defaultValue: "タグが似ているユニット", table: "Units", bundle: L10n.bundle)
        }
        /// タグ{count}個一致 — おすすめのユニットの下に出す、共通するタグの数 — 引数: count (count)
        static func detailSimilarSharedTags(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("units.detail.similar.shared_tags", defaultValue: "タグ\(count)個一致", table: "Units", bundle: L10n.bundle)
        }
        /// 回収済 — 楽曲の行のバッジ。ライブでその曲を聴いた (現地回収した)
        static var detailSongsCollected: LocalizedStringResource {
            LocalizedStringResource("units.detail.songs.collected", defaultValue: "回収済", table: "Units", bundle: L10n.bundle)
        }
        /// このユニットの楽曲情報はまだ登録されていません。 — 楽曲が 1 曲も無いときの空状態の説明
        static var detailSongsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("units.detail.songs.empty.message", defaultValue: "このユニットの楽曲情報はまだ登録されていません。", table: "Units", bundle: L10n.bundle)
        }
        /// 楽曲がありません — 楽曲が 1 曲も無いときの空状態の見出し
        static var detailSongsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("units.detail.songs.empty.title", defaultValue: "楽曲がありません", table: "Units", bundle: L10n.bundle)
        }
        /// 楽曲 — 楽曲の節の見出し (右に件数)
        static var detailSongsHeader: LocalizedStringResource {
            LocalizedStringResource("units.detail.songs.header", defaultValue: "楽曲", table: "Units", bundle: L10n.bundle)
        }
        /// コミュニティ — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ)
        static var detailTabCommunity: LocalizedStringResource {
            LocalizedStringResource("units.detail.tab.community", defaultValue: "コミュニティ", table: "Units", bundle: L10n.bundle)
        }
        /// メンバー — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ)
        static var detailTabMembers: LocalizedStringResource {
            LocalizedStringResource("units.detail.tab.members", defaultValue: "メンバー", table: "Units", bundle: L10n.bundle)
        }
        /// 楽曲 — 詳細の中のセグメント (楽曲 / メンバー / コミュニティ)
        static var detailTabSongs: LocalizedStringResource {
            LocalizedStringResource("units.detail.tab.songs", defaultValue: "楽曲", table: "Units", bundle: L10n.bundle)
        }
        /// タグを追加 — タグを付ける操作。iOS はタグが無いときの空状態のボタン、Android は ＋ ボタンの読み上げ
        static var detailTagsActionAdd: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.action.add", defaultValue: "タグを追加", table: "Units", bundle: L10n.bundle)
        }
        /// タグを外す — 自分が付けたタグの長押しメニュー
        static var detailTagsActionRemove: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.action.remove", defaultValue: "タグを外す", table: "Units", bundle: L10n.bundle)
        }
        /// タグ詳細を見る — タグの長押しメニュー
        static var detailTagsActionShowDetail: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.action.show_detail", defaultValue: "タグ詳細を見る", table: "Units", bundle: L10n.bundle)
        }
        /// タグ — タグの節の見出し右の ＋ 付きボタン (短い形)
        static var detailTagsAddButton: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.add_button", defaultValue: "タグ", table: "Units", bundle: L10n.bundle)
        }
        /// このユニットを一言で表すタグを付けてみませんか？ — タグが 1 つも無いときの誘い文句
        static var detailTagsEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.empty.message", defaultValue: "このユニットを一言で表すタグを付けてみませんか？", table: "Units", bundle: L10n.bundle)
        }
        /// タグはまだありません — タグが 1 つも無いとき
        static var detailTagsEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.empty.title", defaultValue: "タグはまだありません", table: "Units", bundle: L10n.bundle)
        }
        /// タグ — コミュニティタグの節の見出し
        static var detailTagsHeader: LocalizedStringResource {
            LocalizedStringResource("units.detail.tags.header", defaultValue: "タグ", table: "Units", bundle: L10n.bundle)
        }
        /// {count}組 — ユニット一覧のブランドの区切り見出しの右のユニット数。1000 以上は桁区切りが付く (従来どおり) — 引数: count (count)
        static func listBrandCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("units.list.brand_count", defaultValue: "\(count)組", table: "Units", bundle: L10n.bundle)
        }
        /// 登録されているユニットがまだありません。 — ユニットが 1 件も無いときの空状態の説明
        static var listEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("units.list.empty.message", defaultValue: "登録されているユニットがまだありません。", table: "Units", bundle: L10n.bundle)
        }
        /// ユニットがありません — ユニットが 1 件も無いときの空状態の見出し
        static var listEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("units.list.empty.title", defaultValue: "ユニットがありません", table: "Units", bundle: L10n.bundle)
        }
        /// 絞り込みを解除 — 絞り込みの語を消すボタン。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var listFilterEmptyActionClear: LocalizedStringResource {
            LocalizedStringResource("units.list.filter_empty.action.clear", defaultValue: "絞り込みを解除", table: "Units", bundle: L10n.bundle)
        }
        /// 「{query}」に一致するユニットがありません — 絞り込みで 1 件も残らなかったときの説明。query は利用者が打った語 — 引数: query (string)
        static func listFilterEmptyMessage(query: String) -> LocalizedStringResource {
            LocalizedStringResource("units.list.filter_empty.message", defaultValue: "「\(query)」に一致するユニットがありません", table: "Units", bundle: L10n.bundle)
        }
        /// 絞り込み結果がありません — 絞り込みで 1 件も残らなかったときの空状態の見出し。ko は名前の絞り込みを「찾기」、フィルタ (条件) を「필터」と分ける (idols.list.filter_empty.* と同じ)
        static var listFilterEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("units.list.filter_empty.title", defaultValue: "絞り込み結果がありません", table: "Units", bundle: L10n.bundle)
        }
        /// ユニット名 — ナビバーの中の絞り込み欄のプレースホルダ
        static var listSearchFieldPrompt: LocalizedStringResource {
            LocalizedStringResource("units.list.search_field.prompt", defaultValue: "ユニット名", table: "Units", bundle: L10n.bundle)
        }
        /// ユニット — ユニット一覧のナビゲーションタイトル。Android の同じ見出しは IdolListScreen (idols スライス) の TopAppBar にある
        static var listTitle: LocalizedStringResource {
            LocalizedStringResource("units.list.title", defaultValue: "ユニット", table: "Units", bundle: L10n.bundle)
        }
        /// グリッド表示 — 一覧/グリッド切替ボタンの読み上げ (今はリスト表示で、押すとグリッド表示になる)
        static var listViewModeGridA11y: LocalizedStringResource {
            LocalizedStringResource("units.list.view_mode.grid.a11y", defaultValue: "グリッド表示", table: "Units", bundle: L10n.bundle)
        }
        /// リスト表示 — 一覧/グリッド切替ボタンの読み上げ (今はグリッド表示で、押すとリスト表示になる)。Android の同じボタンは IdolListScreen (idols スライス) にある
        static var listViewModeListA11y: LocalizedStringResource {
            LocalizedStringResource("units.list.view_mode.list.a11y", defaultValue: "リスト表示", table: "Units", bundle: L10n.bundle)
        }
    }
}
