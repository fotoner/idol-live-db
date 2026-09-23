package com.fugaif.imaslivedb.i18n

/**
 * 利用者に見せる文言を持つもの (主に例外。iOS `UserFacingError` と対)。
 *
 * 例外は理由 (enum など) を持ち、表示文言への対応はここの [userMessage] 1 か所にだけ書く。
 * 画面は `e.message` を出さず、`(e as? UserFacing)?.userMessage` を UiState に入れて出口で解決する。
 */
interface UserFacing {
    val userMessage: DisplayText
}
