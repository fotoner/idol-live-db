// 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/common.json の文言。L10n.Common から引く (iOS の L10n.Common と同じ名前)。 */
object L10nCommon {
    /** 戻る — 画面左上の戻るボタンの読み上げ (contentDescription)。iOS は OS が出すので Android だけ */
    val actionBack: DisplayText get() = DisplayText.Res(R.string.common_action_back)
    /** 折りたたむ — 開いている節を閉じるボタンの読み上げ */
    val actionCollapse: DisplayText get() = DisplayText.Res(R.string.common_action_collapse)
    /** 展開 — 閉じている節を開くボタンの読み上げ */
    val actionExpand: DisplayText get() = DisplayText.Res(R.string.common_action_expand)
    /** 再試行 — 読み込み失敗などの空状態に出す再試行ボタン */
    val actionRetry: DisplayText get() = DisplayText.Res(R.string.common_action_retry)
    /** すべて見る — セクション見出し右の導線 */
    val actionSeeAll: DisplayText get() = DisplayText.Res(R.string.common_action_see_all)
    /** マイタグを追加 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。入力欄の右の ＋ ボタンの読み上げ */
    val personalTagsAddA11y: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_add_a11y)
    /** マイタグはまだありません — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。1 つも無いときの案内 */
    val personalTagsEmpty: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_empty)
    /** マイタグ(自分だけに表示) — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。節の見出し。自分だけのタグで、コミュニティには送らない */
    val personalTagsHeader: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_header)
    /** 例: 聞いた — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。入力欄のプレースホルダ。例の語も訳す */
    val personalTagsPlaceholder: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_placeholder)
    /** 削除 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。チップの × の読み上げ (削除は長押し) */
    val personalTagsRemoveA11y: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_remove_a11y)
    /** 長押しで削除 — 共通部品 PersonalTagsSection (アイドル・ユニット詳細のコミュニティ)。チップの下の操作の案内 */
    val personalTagsRemoveHint: DisplayText get() = DisplayText.Res(R.string.common_personal_tags_remove_hint)
}
