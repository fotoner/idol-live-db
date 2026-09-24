// 生成物: i18n/catalog/produce.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/produce.json の文言 (表 Produce)
    enum Produce {
        /// 参加ライブ — 件数タイルのラベル (参加したライブの数)
        static var activityAttended: LocalizedStringResource {
            LocalizedStringResource("produce.activity.attended", defaultValue: "参加ライブ", table: "Produce", bundle: L10n.bundle)
        }
        /// 回収 — 件数タイルのラベル (ライブで生で聴いた曲の数)
        static var activityCollected: LocalizedStringResource {
            LocalizedStringResource("produce.activity.collected", defaultValue: "回収", table: "Produce", bundle: L10n.bundle)
        }
        /// 投稿 — 件数タイルのラベル (自分の投稿・編集の数)
        static var activityContributions: LocalizedStringResource {
            LocalizedStringResource("produce.activity.contributions", defaultValue: "投稿", table: "Produce", bundle: L10n.bundle)
        }
        /// お気に入り — 件数タイルのラベル (お気に入りの数)
        static var activityFavorites: LocalizedStringResource {
            LocalizedStringResource("produce.activity.favorites", defaultValue: "お気に入り", table: "Produce", bundle: L10n.bundle)
        }
        /// あなたの活動 — 件数タイルの節の見出し
        static var activityHeader: LocalizedStringResource {
            LocalizedStringResource("produce.activity.header", defaultValue: "あなたの活動", table: "Produce", bundle: L10n.bundle)
        }
        /// 収支 — 件数タイルのラベル (家計簿の合計金額)
        static var activityLedger: LocalizedStringResource {
            LocalizedStringResource("produce.activity.ledger", defaultValue: "収支", table: "Produce", bundle: L10n.bundle)
        }
        /// 習熟度 — 件数タイルのラベル (習熟度を付けた曲の数)
        static var activityMastery: LocalizedStringResource {
            LocalizedStringResource("produce.activity.mastery", defaultValue: "習熟度", table: "Produce", bundle: L10n.bundle)
        }
        /// 予想 — 件数タイルのラベル (セトリ予想の数)
        static var activityPredictions: LocalizedStringResource {
            LocalizedStringResource("produce.activity.predictions", defaultValue: "予想", table: "Produce", bundle: L10n.bundle)
        }
        /// 投票 — 件数タイルのラベル (投票したお題の数)
        static var activityVotes: LocalizedStringResource {
            LocalizedStringResource("produce.activity.votes", defaultValue: "投票", table: "Produce", bundle: L10n.bundle)
        }
        /// 参加したライブ — 参加したライブの節の見出し (右に件数)
        static var attendedHeader: LocalizedStringResource {
            LocalizedStringResource("produce.attended.header", defaultValue: "参加したライブ", table: "Produce", bundle: L10n.bundle)
        }
        /// 全て見る ({count}件) — 参加したライブの節の下の導線 (6 件以上のとき)。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func attendedSeeAll(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.attended.see_all", defaultValue: "全て見る (\(count)件)", table: "Produce", bundle: L10n.bundle)
        }
        /// 回収した楽曲 — 回収した楽曲 (参加したライブで聴いた曲) の一覧の画面タイトル
        static var collectedTitle: LocalizedStringResource {
            LocalizedStringResource("produce.collected.title", defaultValue: "回収した楽曲", table: "Produce", bundle: L10n.bundle)
        }
        /// 歌詞行ごとのコールガイド。書かれている曲・最近の編集・書き手募集中の曲 — コールガイドの入口カードの説明
        static var entryCallGuidePreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.call_guide.preview", defaultValue: "歌詞行ごとのコールガイド。書かれている曲・最近の編集・書き手募集中の曲", table: "Produce", bundle: L10n.bundle)
        }
        /// コールガイド — 入口カードのタイトル (コールガイドのまとめへ)
        static var entryCallGuideTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.call_guide.title", defaultValue: "コールガイド", table: "Produce", bundle: L10n.bundle)
        }
        /// イントロドン・アイドル当て・カラー合わせ — クイズ・ゲームの入口カードの説明 (ゲームの名前を並べる)
        static var entryGamesPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.games.preview", defaultValue: "イントロドン・アイドル当て・カラー合わせ", table: "Produce", bundle: L10n.bundle)
        }
        /// クイズ・ゲーム — 入口カードのタイトル (ゲームの一覧へ)
        static var entryGamesTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.games.title", defaultValue: "クイズ・ゲーム", table: "Produce", bundle: L10n.bundle)
        }
        /// お題に推しを投票・ランキング — みんなの投票の入口カードの説明
        static var entryPollsPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.polls.preview", defaultValue: "お題に推しを投票・ランキング", table: "Produce", bundle: L10n.bundle)
        }
        /// みんなの投票 — 入口カードのタイトル (お題の一覧へ)
        static var entryPollsTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.polls.title", defaultValue: "みんなの投票", table: "Produce", bundle: L10n.bundle)
        }
        /// セトリを予想して的中を狙おう — マイ予想の入口カードの説明 (予想がまだ無いとき)
        static var entryPredictionsPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.predictions.preview", defaultValue: "セトリを予想して的中を狙おう", table: "Produce", bundle: L10n.bundle)
        }
        /// 投票した予想 {count}件 — マイ予想の入口カードの説明 (予想が 1 件以上あるとき)。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: count (count)
        static func entryPredictionsPreviewCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.entry.predictions.preview_count", defaultValue: "投票した予想 \(count)件", table: "Produce", bundle: L10n.bundle)
        }
        /// マイ予想 — 入口カードのタイトル (自分のセトリ予想へ)
        static var entryPredictionsTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.predictions.title", defaultValue: "マイ予想", table: "Produce", bundle: L10n.bundle)
        }
        /// 参考動画・セトリ編集など最近のコミュニティ投稿 — みんなの動きの入口カードの説明
        static var entryRecentEditsPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.recent_edits.preview", defaultValue: "参考動画・セトリ編集など最近のコミュニティ投稿", table: "Produce", bundle: L10n.bundle)
        }
        /// みんなの動き — 入口カードのタイトル (最近のコミュニティの編集へ)
        static var entryRecentEditsTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.recent_edits.title", defaultValue: "みんなの動き", table: "Produce", bundle: L10n.bundle)
        }
        /// 披露回数・お気に入り・出演ランキング… — 統計の入口カードの説明 (公演がまだ無いとき)
        static var entryStatsPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.stats.preview", defaultValue: "披露回数・お気に入り・出演ランキング…", table: "Produce", bundle: L10n.bundle)
        }
        /// 最新公演 {show} ほか — 統計の入口カードの説明。show は一番新しい公演の名前 (データ) — 引数: show (string)
        static func entryStatsPreviewLatest(show: String) -> LocalizedStringResource {
            LocalizedStringResource("produce.entry.stats.preview_latest", defaultValue: "最新公演 \(show) ほか", table: "Produce", bundle: L10n.bundle)
        }
        /// 調べる — 入口カードのタイトル (統計の画面へ)
        static var entryStatsTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.stats.title", defaultValue: "調べる", table: "Produce", bundle: L10n.bundle)
        }
        /// 伸びてるタグ・急上昇の曲やアイドルをチェック — タグの動きの入口の説明。iOS は入口カード、Android はハブの行
        static var entryTagActivityPreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.tag_activity.preview", defaultValue: "伸びてるタグ・急上昇の曲やアイドルをチェック", table: "Produce", bundle: L10n.bundle)
        }
        /// タグの動き — タグの動き (伸びているタグ) の入口。iOS は入口カード、Android はハブの行
        static var entryTagActivityTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.tag_activity.title", defaultValue: "タグの動き", table: "Produce", bundle: L10n.bundle)
        }
        /// ライブ・楽曲シリーズ・節目を1枚で俯瞰する — 年表の入口の説明。iOS は入口カード、Android はハブの行
        static var entryTimelinePreview: LocalizedStringResource {
            LocalizedStringResource("produce.entry.timeline.preview", defaultValue: "ライブ・楽曲シリーズ・節目を1枚で俯瞰する", table: "Produce", bundle: L10n.bundle)
        }
        /// 年表 — 年表 (ブランドの歴史) の入口。iOS は入口カード、Android はハブの行
        static var entryTimelineTitle: LocalizedStringResource {
            LocalizedStringResource("produce.entry.timeline.title", defaultValue: "年表", table: "Produce", bundle: L10n.bundle)
        }
        /// お知らせ — 右上のベル (運営からのお知らせを開く) の読み上げ。未読が無いとき
        static var inboxA11y: LocalizedStringResource {
            LocalizedStringResource("produce.inbox.a11y", defaultValue: "お知らせ", table: "Produce", bundle: L10n.bundle)
        }
        /// お知らせ (未読{count}件) — 右上のベルの読み上げ。未読があるとき。1000 以上は桁区切りが付く (1,234)。 — 引数: count (count)
        static func inboxUnreadA11y(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.inbox.unread.a11y", defaultValue: "お知らせ (未読\(count)件)", table: "Produce", bundle: L10n.bundle)
        }
        /// {count}人 — 担当アイドルの節の見出しの人数 (小さい見出しでは出ない)。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: count (count)
        static func oshiCount(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.oshi.count", defaultValue: "\(count)人", table: "Produce", bundle: L10n.bundle)
        }
        /// アイドル詳細の「担当」マークを付けると、ここに大きく表示されます。 — 担当アイドルが 1 人もいないときの空状態の説明
        static var oshiEmptyMessage: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.empty.message", defaultValue: "アイドル詳細の「担当」マークを付けると、ここに大きく表示されます。", table: "Produce", bundle: L10n.bundle)
        }
        /// 担当アイドルがいません — 担当アイドルが 1 人もいないときの空状態の見出し
        static var oshiEmptyTitle: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.empty.title", defaultValue: "担当アイドルがいません", table: "Produce", bundle: L10n.bundle)
        }
        /// 担当アイドル — 担当アイドル (推し) のカードの節の見出し
        static var oshiHeader: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.header", defaultValue: "担当アイドル", table: "Produce", bundle: L10n.bundle)
        }
        /// 担当 — 担当アイドルのカードの名前の下のチップ
        static var oshiHeroChip: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.hero.chip", defaultValue: "担当", table: "Produce", bundle: L10n.bundle)
        }
        /// 詳細 — 担当アイドルのカードのボタン (アイドル詳細へ)
        static var oshiHeroDetail: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.hero.detail", defaultValue: "詳細", table: "Produce", bundle: L10n.bundle)
        }
        /// 出演ライブ — 担当アイドルのカードのボタン (出演したライブへ)
        static var oshiHeroLives: LocalizedStringResource {
            LocalizedStringResource("produce.oshi.hero.lives", defaultValue: "出演ライブ", table: "Produce", bundle: L10n.bundle)
        }
        /// {brand} ・ CV {cv} — 担当アイドルのカードの名前の下の行。brand はブランドの略称、cv は声優名 (どちらもデータ) — 引数: brand (string), cv (string)
        static func oshiHeroMeta(brand: String, cv: String) -> LocalizedStringResource {
            LocalizedStringResource("produce.oshi.hero.meta", defaultValue: "\(brand) ・ CV \(cv)", table: "Produce", bundle: L10n.bundle)
        }
        /// 投票する — 「開催中のお題」カードの右下の導線
        static var pollAction: LocalizedStringResource {
            LocalizedStringResource("produce.poll.action", defaultValue: "投票する", table: "Produce", bundle: L10n.bundle)
        }
        /// 投票受付中 — 先頭の「開催中のお題」カードの左上のラベル
        static var pollBadge: LocalizedStringResource {
            LocalizedStringResource("produce.poll.badge", defaultValue: "投票受付中", table: "Produce", bundle: L10n.bundle)
        }
        /// {count}候補 — 「開催中のお題」カードの候補の数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func pollEntries(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.poll.entries", defaultValue: "\(count)候補", table: "Produce", bundle: L10n.bundle)
        }
        /// あと{days}日 — 「開催中のお題」カードの残り時間 (1 日以上)。1000 以上は桁区切りが付く (1,234)。iOS も以前は付かなかった (String で組んでいた) — 引数: days (count)
        static func pollRemainingDays(days: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.poll.remaining.days", defaultValue: "あと\(days)日", table: "Produce", bundle: L10n.bundle)
        }
        /// あと{hours}時間 — 「開催中のお題」カードの残り時間 (1 日未満) — 引数: hours (count)
        static func pollRemainingHours(hours: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.poll.remaining.hours", defaultValue: "あと\(hours)時間", table: "Produce", bundle: L10n.bundle)
        }
        /// まもなく終了 — 「開催中のお題」カードの残り時間 (1 時間を切った・締切を過ぎた)
        static var pollRemainingSoon: LocalizedStringResource {
            LocalizedStringResource("produce.poll.remaining.soon", defaultValue: "まもなく終了", table: "Produce", bundle: L10n.bundle)
        }
        /// {count}票 — 「開催中のお題」カードの票数。1000 以上は桁区切りが付く (1,234)。Android は以前は付かなかった — 引数: count (count)
        static func pollVotes(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("produce.poll.votes", defaultValue: "\(count)票", table: "Produce", bundle: L10n.bundle)
        }
        /// 最近見た — 最近開いたライブ・曲・アイドルのチップ列の見出し
        static var recentsHeader: LocalizedStringResource {
            LocalizedStringResource("produce.recents.header", defaultValue: "最近見た", table: "Produce", bundle: L10n.bundle)
        }
        /// プロデュース — プロデュースタブ (担当・活動のまとめ) の画面タイトル。iOS はナビゲーションタイトル、Android は TopAppBar
        static var title: LocalizedStringResource {
            LocalizedStringResource("produce.title", defaultValue: "プロデュース", table: "Produce", bundle: L10n.bundle)
        }
    }
}
