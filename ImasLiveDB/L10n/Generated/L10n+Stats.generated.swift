// 生成物: i18n/catalog/stats.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/stats.json の文言 (表 Stats)
    enum Stats {
        /// ブランド別の回収率 — ブランド別の回収率の節の見出し
        static var brandProgressHeader: LocalizedStringResource {
            LocalizedStringResource("stats.brand_progress.header", defaultValue: "ブランド別の回収率", table: "Stats", bundle: L10n.bundle)
        }
        /// マスタ規模 ・ ブランド別楽曲数 — ブランドごとの登録曲数の見出し。マスタはアプリのマスタデータ (データベース) のこと (ko の「마스터」は作品名 (아이돌마스터) や称号に読めるので DB と訳す)
        static var brandSongsHeader: LocalizedStringResource {
            LocalizedStringResource("stats.brand_songs.header", defaultValue: "マスタ規模 ・ ブランド別楽曲数", table: "Stats", bundle: L10n.bundle)
        }
        /// 活動量 ・ 出演回数 — 出演回数の多い人のランキングの見出し
        static var castShowHeader: LocalizedStringResource {
            LocalizedStringResource("stats.cast_show.header", defaultValue: "活動量 ・ 出演回数", table: "Stats", bundle: L10n.bundle)
        }
        /// 人 — 出演回数のランキングの数字の単位。数字は各アイドルの出演公演数なので ko は「회」(37회)。ja の「人」は移行前の表示をそのまま残したもので、回 (または 公演) に直すのはオーナーの承認を得て別の PR で行う
        static var castShowUnit: LocalizedStringResource {
            LocalizedStringResource("stats.cast_show.unit", defaultValue: "人", table: "Stats", bundle: L10n.bundle)
        }
        /// 過去に披露 — 公演カードの右の数字の説明 (その曲が過去の公演で歌われた)
        static var catchChanceCaption: LocalizedStringResource {
            LocalizedStringResource("stats.catch_chance.caption", defaultValue: "過去に披露", table: "Stats", bundle: L10n.bundle)
        }
        /// {date} ・ {event} — 公演カードの上の行。date は 6/4 のような月日、event はイベント名 — 引数: date (string), event (string)
        static func catchChanceDateEvent(date: String, event: String) -> LocalizedStringResource {
            LocalizedStringResource("stats.catch_chance.date_event", defaultValue: "\(date) ・ \(event)", table: "Stats", bundle: L10n.bundle)
        }
        /// この公演で聴けるかも — これからの公演で未回収の曲が聴けそうなものの節の見出し
        static var catchChanceHeader: LocalizedStringResource {
            LocalizedStringResource("stats.catch_chance.header", defaultValue: "この公演で聴けるかも", table: "Stats", bundle: L10n.bundle)
        }
        /// 曲 — 公演カードの右の数字の単位 (聴けそうな未回収の曲数)
        static var catchChanceUnit: LocalizedStringResource {
            LocalizedStringResource("stats.catch_chance.unit", defaultValue: "曲", table: "Stats", bundle: L10n.bundle)
        }
        /// 回収ダッシュボード — 統計タブ (回収ダッシュボード) の画面の題。回収 = ライブで曲を生で聴くこと
        static var dashboardTitle: LocalizedStringResource {
            LocalizedStringResource("stats.dashboard.title", defaultValue: "回収ダッシュボード", table: "Stats", bundle: L10n.bundle)
        }
        /// すべて — ランキングのブランドの絞り込みチップの先頭 (絞らない)
        static var heatBrandAll: LocalizedStringResource {
            LocalizedStringResource("stats.heat.brand.all", defaultValue: "すべて", table: "Stats", bundle: L10n.bundle)
        }
        /// お気に入り登録が増えるとここにランキングが表示されます。 — ランキングが空のときの説明
        static var heatEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("stats.heat.empty.message", defaultValue: "お気に入り登録が増えるとここにランキングが表示されます。", table: "Stats", bundle: L10n.bundle)
        }
        /// まだデータがありません — ランキングが空のときの見出し
        static var heatEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("stats.heat.empty.title", defaultValue: "まだデータがありません", table: "Stats", bundle: L10n.bundle)
        }
        /// コミュニティの熱量 — みんなのお気に入り登録の多い曲のランキングの節の見出し
        static var heatHeader: LocalizedStringResource {
            LocalizedStringResource("stats.heat.header", defaultValue: "コミュニティの熱量", table: "Stats", bundle: L10n.bundle)
        }
        /// 最新公演 ・ {date} — 最新の公演カードの上の行。date は 6/4 のような月日 — 引数: date (string)
        static func latestDate(date: String) -> LocalizedStringResource {
            LocalizedStringResource("stats.latest.date", defaultValue: "最新公演 ・ \(date)", table: "Stats", bundle: L10n.bundle)
        }
        /// 最新の動き — いちばん新しい公演の節の見出し
        static var latestHeader: LocalizedStringResource {
            LocalizedStringResource("stats.latest.header", defaultValue: "最新の動き", table: "Stats", bundle: L10n.bundle)
        }
        /// セトリを見る — 最新の公演カードのセトリを開く導線
        static var latestOpenSetlist: LocalizedStringResource {
            LocalizedStringResource("stats.latest.open_setlist", defaultValue: "セトリを見る", table: "Stats", bundle: L10n.bundle)
        }
        ///  ・  — 最新の公演カードの会場とセトリの曲数の区切り (前後に空白)
        static var latestSeparator: LocalizedStringResource {
            LocalizedStringResource("stats.latest.separator", defaultValue: " ・ ", table: "Stats", bundle: L10n.bundle)
        }
        /// セトリ {count}曲 — 最新の公演カードの会場の行に続く、セトリの曲数 — 引数: count (count)
        static func latestSetlistSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("stats.latest.setlist_songs", defaultValue: "セトリ \(count)曲", table: "Stats", bundle: L10n.bundle)
        }
        /// 活動量 ・ 披露回数 — ライブで歌われた回数の多い曲のランキングの見出し
        static var songPlayHeader: LocalizedStringResource {
            LocalizedStringResource("stats.song_play.header", defaultValue: "活動量 ・ 披露回数", table: "Stats", bundle: L10n.bundle)
        }
        /// 回 — 披露回数のランキングの数字の単位
        static var songPlayUnit: LocalizedStringResource {
            LocalizedStringResource("stats.song_play.unit", defaultValue: "回", table: "Stats", bundle: L10n.bundle)
        }
        /// 現地ライブで聴けた曲 — 回収した曲数の説明
        static var summaryCaption: LocalizedStringResource {
            LocalizedStringResource("stats.summary.caption", defaultValue: "現地ライブで聴けた曲", table: "Stats", bundle: L10n.bundle)
        }
        /// あなたの回収率 — 全体の回収率の節の見出し
        static var summaryHeader: LocalizedStringResource {
            LocalizedStringResource("stats.summary.header", defaultValue: "あなたの回収率", table: "Stats", bundle: L10n.bundle)
        }
        /// カードでシェア — 回収率のシェアカードを開くボタン
        static var summaryShare: LocalizedStringResource {
            LocalizedStringResource("stats.summary.share", defaultValue: "カードでシェア", table: "Stats", bundle: L10n.bundle)
        }
        /// / {count}曲 — 回収した曲数の右の分母 (全曲数)。1000 以上は桁区切りが付く (/ 3,012曲) — 引数: count (count)
        static func summaryTotalSongs(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("stats.summary.total_songs", defaultValue: "/ \(count)曲", table: "Stats", bundle: L10n.bundle)
        }
        /// 参加ライブを記録すると、未回収曲がここに並びます。 — 未回収の曲が無いときの説明 (全体)
        static var uncollectedEmptyAllMessage: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.empty_all.message", defaultValue: "参加ライブを記録すると、未回収曲がここに並びます。", table: "Stats", bundle: L10n.bundle)
        }
        /// 未回収曲はありません — 未回収の曲が無いときの見出し (全体)
        static var uncollectedEmptyAllTitle: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.empty_all.title", defaultValue: "未回収曲はありません", table: "Stats", bundle: L10n.bundle)
        }
        /// 参加ライブを記録すると、担当のオリ曲の回収状況がここに出ます。 — 担当のオリ曲に未回収が無いときの説明
        static var uncollectedEmptyPickMessage: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.empty_pick.message", defaultValue: "参加ライブを記録すると、担当のオリ曲の回収状況がここに出ます。", table: "Stats", bundle: L10n.bundle)
        }
        /// 担当曲はコンプリート！ — 担当のオリ曲に未回収が無いときの見出し
        static var uncollectedEmptyPickTitle: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.empty_pick.title", defaultValue: "担当曲はコンプリート！", table: "Stats", bundle: L10n.bundle)
        }
        /// まだ生で聴けていない曲 — 未回収の曲の一覧の見出し
        static var uncollectedHeader: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.header", defaultValue: "まだ生で聴けていない曲", table: "Stats", bundle: L10n.bundle)
        }
        /// 担当 {collected}/{total} — 担当のオリ曲の回収数 / 曲数 (見出しの右) — 引数: collected (int), total (int)
        static func uncollectedMyPickProgress(collected: Int, total: Int) -> LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.my_pick_progress", defaultValue: "担当 \(String(collected))/\(String(total))", table: "Stats", bundle: L10n.bundle)
        }
        /// {count}回披露 — 未回収の曲の行の右: これまでにライブで歌われた回数 — 引数: count (count)
        static func uncollectedPlayCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.play_count", defaultValue: "\(count)回披露", table: "Stats", bundle: L10n.bundle)
        }
        /// 全体 — 未回収の曲の範囲のセグメント: すべての曲
        static var uncollectedScopeAll: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.scope.all", defaultValue: "全体", table: "Stats", bundle: L10n.bundle)
        }
        /// 担当のオリ曲 — 未回収の曲の範囲のセグメント: 担当アイドルのオリジナル曲
        static var uncollectedScopeMyPick: LocalizedStringResource {
            LocalizedStringResource("stats.uncollected.scope.my_pick", defaultValue: "担当のオリ曲", table: "Stats", bundle: L10n.bundle)
        }
    }
}
