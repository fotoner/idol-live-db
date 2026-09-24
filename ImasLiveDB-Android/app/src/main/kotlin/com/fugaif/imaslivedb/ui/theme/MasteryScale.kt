package com.fugaif.imaslivedb.ui.theme

import android.content.res.Resources
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve

/**
 * 習熟度の段階の定義 (ラベルと数)。iOS `Models/MasteryScale.swift` の移植。
 *
 * **保存されるのは序数だけ** (`user_marks.kind = "mastery"` の `text_value`)。
 * ラベルはここが持ち、設定で差し替えても既存の記録には触らない。段数から導ける規則
 * (次の段 / 重み / 段数を変えたときの寄せ先) と群化・集計は共有コア
 * (`imas-core` の `domain/mastery.rs`) にある。ここは**文言と色だけ**。
 */
data class MasteryScale(val labels: List<String>) {

    /** 段数。コアに渡す `steps`。 */
    val steps: UByte get() = labels.size.coerceIn(1, 8).toUByte()

    /** 表示名を画面の言語で文字列にしたもの ([labelText] を解決する)。`0` は未設定。 */
    @Composable
    fun label(level: UByte): String = labelText(level).resolve()

    /** 一覧のチップに出す短い名前 (長いラベルは頭から詰める)。 */
    @Composable
    fun shortLabel(level: UByte): String = shorten(label(level))

    /**
     * 表示するラベル (下から順)。編集していないプリセットは画面の言語の訳、それ以外は保存値のまま。
     * ja では常に [labels] と同じ。設定画面の入力欄に出す (iOS `MasteryScale.displayLabels`)。
     */
    fun displayLabels(res: Resources): List<String> =
        presetLabelTexts(labels)?.map { it.resolve(res) } ?: labels

    /**
     * 表示名 (文言の値)。`0` は未設定。
     *
     * 保存しているのは利用者が選んだラベルの文字列そのもの ([AppPreferences.masteryScale])。
     * それが ja のプリセットのまま (書き換えていない) なら今の言語の文言で出し、書き換えていれば
     * 利用者の入力なのでそのまま出す (設計 §9.3。保存の形は変えない)。
     */
    fun labelText(level: UByte): DisplayText {
        if (level.toInt() == 0) return L10n.Mastery.levelUnset
        val i = level.toInt() - 1
        val stored = labels.getOrNull(i) ?: return DisplayText.Verbatim("LV.$level")
        return presetLabelTexts(labels)?.getOrNull(i) ?: DisplayText.Verbatim(stored)
    }

    companion object {
        /**
         * 既定は 3 段。
         *
         * 依頼元は 4 段 (1回聞いた / 耳に馴染んだ / だいたい覚えた / 覚えた) だったが、
         * 「耳に馴染んだ」が読んだときの言い方として微妙で、さらに**行の操作面に
         * 収まらず途中で切れる**。短く言い切れる 3 段にした。語彙の好みは人によるので
         * 設定で変えられる。
         */
        // i18n-ignore(storage): 保存するラベルの既定値 (mastery_scale_labels_v1)。表示は labelText が引く
        val defaultLabels = listOf("聞いた", "覚えた", "完璧")
        val standard = MasteryScale(defaultLabels)

        // i18n-ignore(storage): 選ぶと保存されるラベル (ja のまま保存し、表示は labelText が引く)
        private val twoStepLabels = listOf("聞いた", "覚えた")
        // i18n-ignore(storage): 選ぶと保存されるラベル (ja のまま保存し、表示は labelText が引く)
        private val fourStepLabels = listOf("聞いた", "だいたい", "覚えた", "完璧")

        /**
         * 段数を変えるときの出発点。どれも 4 文字以内にして操作面で切れないようにする
         * (訳もカタログの max_len で 4 文字以内)。チップの名前は [presetNameText]。
         */
        val presets: List<MasteryScale> = listOf(
            MasteryScale(twoStepLabels),
            MasteryScale(defaultLabels),
            MasteryScale(fourStepLabels),
        )

        /** プリセットの名前 (2段 / 3段 / 4段) の文言。steps は段数。 */
        fun presetNameText(steps: Int): DisplayText = L10n.Mastery.presetName(steps = steps)

        /**
         * 表示中のラベル (設定画面の入力) から保存する段階を作る。訳したプリセットのままなら、
         * そのプリセットの語彙 (ja) で保存する (保存値を言語で変えない。iOS `MasteryScale.storing`)。
         */
        fun storing(displayLabels: List<String>, res: Resources): MasteryScale =
            presets.firstOrNull { it.displayLabels(res) == displayLabels } ?: MasteryScale(displayLabels)

        /** 一覧のチップに出す短い名前 (長いラベルは頭から詰める)。 */
        fun shorten(full: String): String = if (full.length <= 6) full else full.take(5) + "…"

        /** 保存しているラベルが ja のプリセットと一致するとき、その段ごとの文言。一致しなければ null。 */
        private fun presetLabelTexts(stored: List<String>): List<DisplayText>? = when (stored) {
            twoStepLabels -> listOf(L10n.Mastery.presetSteps2Level1, L10n.Mastery.presetSteps2Level2)
            defaultLabels -> listOf(
                L10n.Mastery.presetSteps3Level1, L10n.Mastery.presetSteps3Level2,
                L10n.Mastery.presetSteps3Level3,
            )
            fourStepLabels -> listOf(
                L10n.Mastery.presetSteps4Level1, L10n.Mastery.presetSteps4Level2,
                L10n.Mastery.presetSteps4Level3, L10n.Mastery.presetSteps4Level4,
            )
            else -> null
        }
    }
}

/**
 * 段の色。ヒートマップ的に並べる以上、**段ごとに色相を変えない**。
 * 色相を変えると「濃い＝進んでいる」が列で読めなくなる。
 * システムの accent は塗らない (DS 原則: 色はエンティティ側から来る) ので、
 * 習熟度専用の 1 色を濃度で割る。
 */
object MasteryPalette {
    // アプリはダーク基調なので、上の段ほど明るい側へ伸ばす (iOS のダーク用ランプと同値)。
    private val ramp = listOf(
        Color(0xFF17304A), Color(0xFF27547F), Color(0xFF4287C6), Color(0xFF7FBAF0),
    )

    fun fill(level: UByte, steps: UByte): Color =
        if (level.toInt() == 0) Color.Transparent else ramp[rampIndex(level, steps)]

    /** その面の上に乗せる文字色。上位 2 段は明るいので黒文字に倒す。 */
    fun ink(level: UByte, steps: UByte): Color =
        if (level.toInt() == 0) DS.ink3
        else if (rampIndex(level, steps) >= 2) Color(0xFF06121F) else Color.White

    /** 段数が 4 でないときは 4 段のランプ上へ等間隔に写す (最上段は必ず一番濃い)。 */
    private fun rampIndex(level: UByte, steps: UByte): Int {
        val s = steps.toInt().coerceAtLeast(1)
        val l = level.toInt().coerceIn(1, s)
        val idx = ((l - 1).toDouble() / (s - 1).coerceAtLeast(1) * 3.0 + 0.5).toInt()
        return idx.coerceIn(0, 3)
    }
}
