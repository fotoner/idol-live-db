// 生成物: i18n/catalog/timeline.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/timeline.json の文言。L10n.Timeline から引く (iOS の L10n.Timeline と同じ名前)。 */
object L10nTimeline {
    /** 全ブランド — ブランドを切り替えるチップの先頭 (全ブランドを重ねて出す) */
    val brandAll: DisplayText get() = DisplayText.Res(R.string.timeline_brand_all)
    /** このブランドにはまだライブ・楽曲の日付が登録されていません。 — 帯が 1 本も無いときの空状態の説明 */
    val emptyMessage: DisplayText get() = DisplayText.Res(R.string.timeline_empty_message)
    /** 年表を描けるデータがありません — 帯が 1 本も無いときの空状態の見出し */
    val emptyTitle: DisplayText get() = DisplayText.Res(R.string.timeline_empty_title)
    /** ライブ — 左に貼り付くレーン名 (ライブ・フェス)。幅が狭い (54pt) ので短く */
    val laneLive: DisplayText get() = DisplayText.Res(R.string.timeline_lane_live)
    /** 節目 — 左に貼り付くレーン名 (サービス開始・アニメ放映などの節目)。幅が狭い (54pt) ので短く */
    val laneMilestone: DisplayText get() = DisplayText.Res(R.string.timeline_lane_milestone)
    /** 楽曲 — 左に貼り付くレーン名 (CD シリーズ)。幅が狭い (54pt) ので短く */
    val laneMusic: DisplayText get() = DisplayText.Res(R.string.timeline_lane_music)
    /** その他 — 左に貼り付くレーン名 (リリイベ・ラジオ・配信など)。幅が狭い (54pt) ので短く */
    val laneOther: DisplayText get() = DisplayText.Res(R.string.timeline_lane_other)
    /** 年表 — 年表 (ブランドの歴史) の画面タイトル。全ブランドを出しているとき */
    val title: DisplayText get() = DisplayText.Res(R.string.timeline_title)
    /** {brand}の年表 — 年表の画面タイトル。brand はブランドの略称 (データ) — 引数: brand (string) */
    fun titleBrand(brand: String): DisplayText = DisplayText.Res(R.string.timeline_title_brand, listOf(brand))
    /** 表示倍率 — 右上の表示倍率メニューのボタンの読み上げ */
    val zoomA11y: DisplayText get() = DisplayText.Res(R.string.timeline_zoom_a11y)
    /** 標準 — 表示倍率メニューの項目 (既定の倍率に戻す) */
    val zoomDefault: DisplayText get() = DisplayText.Res(R.string.timeline_zoom_default)
    /** 全体を表示 — 表示倍率メニューの項目 (全期間が画面に収まる倍率にする) */
    val zoomFit: DisplayText get() = DisplayText.Res(R.string.timeline_zoom_fit)
    /** 拡大 — 表示倍率メニューの項目 (大きく拡大する) */
    val zoomIn: DisplayText get() = DisplayText.Res(R.string.timeline_zoom_in)
    /** 今へ — 表示倍率メニューの項目 (今日の位置へ移る) */
    val zoomNow: DisplayText get() = DisplayText.Res(R.string.timeline_zoom_now)
}
