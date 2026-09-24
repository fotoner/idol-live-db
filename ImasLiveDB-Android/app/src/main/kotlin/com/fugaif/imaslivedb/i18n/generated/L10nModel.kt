// 生成物: i18n/catalog/model.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/model.json の文言。L10n.Model から引く (iOS の L10n.Model と同じ名前)。 */
object L10nModel {
    /** 第{rank}位 — 終了したお題での順位 (2 位・3 位)。rank は順位 — 引数: rank (int) */
    fun pollAchievementRank(rank: Int): DisplayText = DisplayText.Res(R.string.model_poll_achievement_rank, listOf(rank))
    /** 優勝 — 終了したお題で 1 位を取ったことを示す札 */
    val pollAchievementWinner: DisplayText get() = DisplayText.Res(R.string.model_poll_achievement_winner)
    /** この操作は制限されています。 — お題を作ろうとしてサーバが 403 を返したとき (利用制限中) (Android) */
    val pollCreateErrorRestricted: DisplayText get() = DisplayText.Res(R.string.model_poll_create_error_restricted)
    /** お題の作成にはサインインが必要です — お題を作ろうとしてサーバが 401 を返したとき (Android) */
    val pollCreateErrorSigninRequired: DisplayText get() = DisplayText.Res(R.string.model_poll_create_error_signin_required)
    /** 項目 — 検索結果が無いときの文に入れる名詞 (全種類) (Android) */
    val searchScopeEmptyNounAll: DisplayText get() = DisplayText.Res(R.string.model_search_scope_empty_noun_all)
    /** ライブ — 検索結果が無いときの文に入れる名詞 (ライブ) (Android) */
    val searchScopeEmptyNounEvents: DisplayText get() = DisplayText.Res(R.string.model_search_scope_empty_noun_events)
    /** アイドル — 検索結果が無いときの文に入れる名詞 (アイドル) (Android) */
    val searchScopeEmptyNounIdols: DisplayText get() = DisplayText.Res(R.string.model_search_scope_empty_noun_idols)
    /** 楽曲 — 検索結果が無いときの文に入れる名詞 (楽曲) (Android) */
    val searchScopeEmptyNounSongs: DisplayText get() = DisplayText.Res(R.string.model_search_scope_empty_noun_songs)
    /** すべて — 検索の範囲の名前 (全種類) (Android) */
    val searchScopeLabelAll: DisplayText get() = DisplayText.Res(R.string.model_search_scope_label_all)
    /** ライブ — 検索の範囲の名前 (ライブ) (Android) */
    val searchScopeLabelEvents: DisplayText get() = DisplayText.Res(R.string.model_search_scope_label_events)
    /** アイドル — 検索の範囲の名前 (アイドル) (Android) */
    val searchScopeLabelIdols: DisplayText get() = DisplayText.Res(R.string.model_search_scope_label_idols)
    /** 楽曲 — 検索の範囲の名前 (楽曲) (Android) */
    val searchScopeLabelSongs: DisplayText get() = DisplayText.Res(R.string.model_search_scope_label_songs)
    /** ライブ・楽曲・アイドルを検索 — 検索欄のプレースホルダ (全種類) (Android) */
    val searchScopePromptAll: DisplayText get() = DisplayText.Res(R.string.model_search_scope_prompt_all)
    /** ライブ名 / 会場で検索 — 検索欄のプレースホルダ (ライブ) (Android) */
    val searchScopePromptEvents: DisplayText get() = DisplayText.Res(R.string.model_search_scope_prompt_events)
    /** アイドル名 / CV名で検索 — 検索欄のプレースホルダ (アイドル)。CV は声優 (Android) */
    val searchScopePromptIdols: DisplayText get() = DisplayText.Res(R.string.model_search_scope_prompt_idols)
    /** 曲名で検索 — 検索欄のプレースホルダ (楽曲) (Android) */
    val searchScopePromptSongs: DisplayText get() = DisplayText.Res(R.string.model_search_scope_prompt_songs)
    /** 初期データの読み込みに失敗しました。アプリを再起動しても直らない場合は再インストールをお試しください。\n(詳細: {detail}) — 初回起動で同梱のデータを入れられなかったとき (Android。まだ端末にデータが無いので再インストールを勧めてよい)。detail はエラーの本文 — 引数: detail (string) */
    fun seedImportFailed(detail: String): DisplayText = DisplayText.Res(R.string.model_seed_import_failed, listOf(detail))
    /** DB がまだ無い — snapshot.unavailable の原因 (詳細欄)。端末に DB ファイルがまだ作られていない (Android) */
    val snapshotDbMissing: DisplayText get() = DisplayText.Res(R.string.model_snapshot_db_missing)
    /** マスタデータを読み込めませんでした — マスタ (曲・アイドル・ライブ) のデータを読み込めなかったとき (Android)。起動画面のエラーに出る */
    val snapshotUnavailable: DisplayText get() = DisplayText.Res(R.string.model_snapshot_unavailable)
    /** 同期に失敗しました — 同期が失敗し、理由の本文が無いとき (Android)。起動画面と設定の同期の状態に出る */
    val syncErrorFailed: DisplayText get() = DisplayText.Res(R.string.model_sync_error_failed)
}
