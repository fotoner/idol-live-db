package com.fugaif.imaslivedb.i18n

import android.content.Context
import android.content.res.Resources
import androidx.annotation.PluralsRes
import androidx.annotation.StringRes
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext

/**
 * まだ文字列にしていない表示文言 (iOS `DisplayText` と対)。
 *
 * 文言は生成アクセサ `L10n.<Ns>.<key>` が [Res] / [Plural] で返す (R.string を手で書かない)。
 * UiState・data 層はこの値を持ち、画面と OS の出口 (Composable・通知チャンネル・Glance・Toast) でだけ
 * [resolve] で文字列にする。ViewModel は構成変更を越えて生き残るので、解決済みの String を持つと
 * 言語を切り替えたあとも旧言語の文言が残る。
 *
 * 画面の文言をカタログに移すときは、DS コンポーネントがこの型を受けるようにする。文字列リテラルからは
 * 作れないので、データが訳語として引かれる事故と、文言が翻訳から黙って漏れる事故の両方を型で止める。
 */
@Immutable
sealed interface DisplayText {
    /** カタログの文言 (引数なし・int/string/core/text 引数)。生成アクセサだけが作る。 */
    data class Res(@StringRes val id: Int, val args: List<Any> = emptyList()) : DisplayText

    /** count 引数を持つ文言。[count] が複数形の選択子で、[args] には count 自身も位置どおりに入る。 */
    data class Plural(@PluralsRes val id: Int, val count: Int, val args: List<Any>) : DisplayText

    /** データ (曲名・アイドル名・サーバの文言・ユーザー入力・書式済みの数値)。訳さない。 */
    data class Verbatim(val value: String) : DisplayText

    /**
     * imas-core が作った完成文字列。今は [Verbatim] と同じにそのまま出す。
     * コアの文言の扱いを決めたときに、置き換える箇所をこれで探せるよう分けておく。
     */
    data class Core(val value: String) : DisplayText
}

/** [context] の言語で文字列にする (Composable の外: 通知・Glance・Toast など)。 */
fun DisplayText.resolve(context: Context): String = resolve(context.resources)

/** [res] の言語で文字列にする。 */
fun DisplayText.resolve(res: Resources): String = when (this) {
    is DisplayText.Res -> if (args.isEmpty()) res.getString(id) else res.getString(id, *args.resolved(res))
    is DisplayText.Plural -> res.getQuantityString(id, count, *args.resolved(res))
    is DisplayText.Verbatim -> value
    is DisplayText.Core -> value
}

/** text 型の引数 (入れ子の DisplayText) は外側と同じ言語で先に文字列にする。 */
private fun List<Any>.resolved(res: Resources): Array<Any> =
    map { if (it is DisplayText) it.resolve(res) else it }.toTypedArray()

/**
 * 画面の言語で文字列にする。Compose の stringResource と同じく構成を読むので、
 * 言語 (構成) が変わったら読み直される。複数形も getQuantityString を直接使う
 * (pluralStringResource は公式に experimental 表記のため使わない)。
 */
@Composable
@ReadOnlyComposable
fun DisplayText.resolve(): String {
    LocalConfiguration.current
    return resolve(LocalContext.current.resources)
}
