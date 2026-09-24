// 生成物: i18n/catalog/timeline.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/timeline.json の文言 (表 Timeline)
    enum Timeline {
        /// {from}〜{to} — 帯の読み上げの期間 (VoiceOver)。from / to は書式済みの年月 (2026年9月) — 引数: from (string), to (string)
        static func barA11yRange(from: String, to: String) -> LocalizedStringResource {
            LocalizedStringResource("timeline.bar.a11y_range", defaultValue: "\(from)〜\(to)", table: "Timeline", bundle: L10n.bundle)
        }
        /// 全ブランド — ブランドを切り替えるチップの先頭 (全ブランドを重ねて出す)
        static var brandAll: LocalizedStringResource {
            LocalizedStringResource("timeline.brand.all", defaultValue: "全ブランド", table: "Timeline", bundle: L10n.bundle)
        }
        /// このブランドにはまだライブ・楽曲の日付が登録されていません。 — 帯が 1 本も無いときの空状態の説明
        static var emptyMessage: LocalizedStringResource {
            LocalizedStringResource("timeline.empty.message", defaultValue: "このブランドにはまだライブ・楽曲の日付が登録されていません。", table: "Timeline", bundle: L10n.bundle)
        }
        /// 年表を描けるデータがありません — 帯が 1 本も無いときの空状態の見出し
        static var emptyTitle: LocalizedStringResource {
            LocalizedStringResource("timeline.empty.title", defaultValue: "年表を描けるデータがありません", table: "Timeline", bundle: L10n.bundle)
        }
        /// ライブ — 左に貼り付くレーン名 (ライブ・フェス)。幅が狭い (54pt) ので短く
        static var laneLive: LocalizedStringResource {
            LocalizedStringResource("timeline.lane.live", defaultValue: "ライブ", table: "Timeline", bundle: L10n.bundle)
        }
        /// 節目 — 左に貼り付くレーン名 (サービス開始・アニメ放映などの節目)。幅が狭い (54pt) ので短く
        static var laneMilestone: LocalizedStringResource {
            LocalizedStringResource("timeline.lane.milestone", defaultValue: "節目", table: "Timeline", bundle: L10n.bundle)
        }
        /// 楽曲 — 左に貼り付くレーン名 (CD シリーズ)。幅が狭い (54pt) ので短く
        static var laneMusic: LocalizedStringResource {
            LocalizedStringResource("timeline.lane.music", defaultValue: "楽曲", table: "Timeline", bundle: L10n.bundle)
        }
        /// その他 — 左に貼り付くレーン名 (リリイベ・ラジオ・配信など)。幅が狭い (54pt) ので短く
        static var laneOther: LocalizedStringResource {
            LocalizedStringResource("timeline.lane.other", defaultValue: "その他", table: "Timeline", bundle: L10n.bundle)
        }
        /// {from}年 〜 {to}年 — 表示中の帯の年の範囲 (BrandTimelineViewModel.periodLabel。今は画面に出していない) — 引数: from (int), to (int)
        static func period(from: Int, to: Int) -> LocalizedStringResource {
            LocalizedStringResource("timeline.period", defaultValue: "\(String(from))年 〜 \(String(to))年", table: "Timeline", bundle: L10n.bundle)
        }
        /// 年表 — 年表 (ブランドの歴史) の画面タイトル。全ブランドを出しているとき
        static var title: LocalizedStringResource {
            LocalizedStringResource("timeline.title", defaultValue: "年表", table: "Timeline", bundle: L10n.bundle)
        }
        /// {brand}の年表 — 年表の画面タイトル。brand はブランドの略称 (データ) — 引数: brand (string)
        static func titleBrand(brand: String) -> LocalizedStringResource {
            LocalizedStringResource("timeline.title_brand", defaultValue: "\(brand)の年表", table: "Timeline", bundle: L10n.bundle)
        }
        /// 表示倍率 — 右上の表示倍率メニューのボタンの読み上げ
        static var zoomA11y: LocalizedStringResource {
            LocalizedStringResource("timeline.zoom.a11y", defaultValue: "表示倍率", table: "Timeline", bundle: L10n.bundle)
        }
        /// 標準 — 表示倍率メニューの項目 (既定の倍率に戻す)
        static var zoomDefault: LocalizedStringResource {
            LocalizedStringResource("timeline.zoom.default", defaultValue: "標準", table: "Timeline", bundle: L10n.bundle)
        }
        /// 全体を表示 — 表示倍率メニューの項目 (全期間が画面に収まる倍率にする)
        static var zoomFit: LocalizedStringResource {
            LocalizedStringResource("timeline.zoom.fit", defaultValue: "全体を表示", table: "Timeline", bundle: L10n.bundle)
        }
        /// 拡大 — 表示倍率メニューの項目 (大きく拡大する)
        static var zoomIn: LocalizedStringResource {
            LocalizedStringResource("timeline.zoom.in", defaultValue: "拡大", table: "Timeline", bundle: L10n.bundle)
        }
        /// 今へ — 表示倍率メニューの項目 (今日の位置へ移る)
        static var zoomNow: LocalizedStringResource {
            LocalizedStringResource("timeline.zoom.now", defaultValue: "今へ", table: "Timeline", bundle: L10n.bundle)
        }
    }
}
