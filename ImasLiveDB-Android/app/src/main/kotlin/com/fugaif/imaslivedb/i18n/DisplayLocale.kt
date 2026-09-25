package com.fugaif.imaslivedb.i18n

import android.content.Context
import com.fugaif.imaslivedb.i18n.generated.L10n
import java.util.IllformedLocaleException
import java.util.Locale

/**
 * 画面に実際に出ている言語 (iOS `DisplayLocale` と対)。
 *
 * 呼び出し時点の [Context] でカタログの予約キー `i18n.language_tag` を解決して得る。アプリが対応しない
 * 言語の端末では UI がフォールバック先 (今は ja) の言語で出るので、端末の言語 (Locale.getDefault()) ではなく
 * 実際に引けた表の値を使う。こうすると日付の書式の言語が UI とずれない。アプリ全体でキャッシュした
 * Resources も使わない (アプリ別の言語を切り替えると古いまま残る)。
 *
 * @property languageTag 表示言語のコード ("ja", "ko")。
 * @property formattingLocale 日付・数値の書式に使うロケール。言語と文字体系は [languageTag]、地域などは端末のもの。
 */
data class DisplayLocale(val languageTag: String, val formattingLocale: Locale) {
    companion object {
        fun of(context: Context): DisplayLocale {
            val tag = L10n.I18n.languageTag.resolve(context)
            val language = Locale.forLanguageTag(tag)
            val device = context.resources.configuration.locales[0]
            val formatting = try {
                // 言語と文字体系を差し替える (端末の文字体系は残さない。"sr-Latn" の端末で ja にしたとき
                // "ja-Latn" にならないように。iOS の DisplayLocale と同じ結果)。setLanguage は "zh-Hans" を受けない
                Locale.Builder().setLocale(device).setLanguage(language.language).setScript(language.script).build()
            } catch (e: IllformedLocaleException) {
                // 端末のロケールが BCP 47 として組めない (古い variant など) ときは言語だけで書式を決める。
                language
            }
            return DisplayLocale(tag, formatting)
        }
    }
}
