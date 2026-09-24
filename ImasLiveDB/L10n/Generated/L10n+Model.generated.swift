// 生成物: i18n/catalog/model.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation

extension L10n {
    /// i18n/catalog/model.json の文言 (表 Model)
    enum Model {
        /// {count}曲 — CD (アルバム) のカードの下に出す曲数。1000 以上は桁区切りが付くが、1 枚の曲数なので実際には出ない — 引数: count (count)
        static func albumSubtitle(count: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.album.subtitle", defaultValue: "\(count)曲", table: "Model", bundle: L10n.bundle)
        }
        /// 重複しています — API が 409 (同じものが既にある) を返し、サーバが理由を付けなかったとき
        static var apiErrorConflict: LocalizedStringResource {
            LocalizedStringResource("model.api_error.conflict", defaultValue: "重複しています", table: "Model", bundle: L10n.bundle)
        }
        /// レスポンス形式エラー — API の応答を読めなかったとき
        static var apiErrorDecoding: LocalizedStringResource {
            LocalizedStringResource("model.api_error.decoding", defaultValue: "レスポンス形式エラー", table: "Model", bundle: L10n.bundle)
        }
        /// 認証エラー — サーバ (Worker) の API が 401 を返したとき (ログインの期限切れなど)
        static var apiErrorNotAuthorized: LocalizedStringResource {
            LocalizedStringResource("model.api_error.not_authorized", defaultValue: "認証エラー", table: "Model", bundle: L10n.bundle)
        }
        /// 見つかりませんでした — API が 404 を返したとき
        static var apiErrorNotFound: LocalizedStringResource {
            LocalizedStringResource("model.api_error.not_found", defaultValue: "見つかりませんでした", table: "Model", bundle: L10n.bundle)
        }
        /// 1日の上限に達しました。明日また試してください — API が 429 (1 日の回数の上限) を返したとき
        static var apiErrorRateLimited: LocalizedStringResource {
            LocalizedStringResource("model.api_error.rate_limited", defaultValue: "1日の上限に達しました。明日また試してください", table: "Model", bundle: L10n.bundle)
        }
        /// サーバーエラー ({status}) — API が 5xx などを返したとき。status は HTTP の状態コード — 引数: status (int)
        static func apiErrorServer(status: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.api_error.server", defaultValue: "サーバーエラー (\(String(status)))", table: "Model", bundle: L10n.bundle)
        }
        /// サーバーエラー ({status}): {detail} — api_error.server にサーバの説明が付いていたとき。detail はサーバ (Worker) の文言 (訳さない) — 引数: status (int), detail (string)
        static func apiErrorServerDetail(status: Int, detail: String) -> LocalizedStringResource {
            LocalizedStringResource("model.api_error.server_detail", defaultValue: "サーバーエラー (\(String(status))): \(detail)", table: "Model", bundle: L10n.bundle)
        }
        /// 通信エラー — 通信そのものが失敗したとき (圏外など)。ほかの理由が分からない失敗の既定の文言にも使う
        static var apiErrorTransport: LocalizedStringResource {
            LocalizedStringResource("model.api_error.transport", defaultValue: "通信エラー", table: "Model", bundle: L10n.bundle)
        }
        /// デレ — ブランドの丸いアイコンに載せる略称 (2〜4 文字。公式ロゴの代わり)。シンデレラガールズのファンの呼び方で、正式名ではない。ko の表記はオーナー確定待ち
        static var brandIconCg: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_cg", defaultValue: "デレ", table: "Model", bundle: L10n.bundle)
        }
        /// 学マス — ブランドの丸いアイコンに載せる略称 (2〜4 文字。公式ロゴの代わり)。学園アイドルマスターのファンの呼び方で、正式名ではない。ko の表記はオーナー確定待ち
        static var brandIconGakuen: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_gakuen", defaultValue: "学マス", table: "Model", bundle: L10n.bundle)
        }
        /// ミリ — ブランドの丸いアイコンに載せる略称 (2〜4 文字。公式ロゴの代わり)。ミリオンライブ!のファンの呼び方で、正式名ではない。ko の表記はオーナー確定待ち
        static var brandIconMl: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_ml", defaultValue: "ミリ", table: "Model", bundle: L10n.bundle)
        }
        /// 他 — ブランドの丸いアイコンに載せる短い文字 (「その他」のブランド)。1〜2 文字
        static var brandIconOther: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_other", defaultValue: "他", table: "Model", bundle: L10n.bundle)
        }
        /// シャニ — ブランドの丸いアイコンに載せる略称 (2〜4 文字。公式ロゴの代わり)。シャイニーカラーズのファンの呼び方で、正式名ではない。ko の表記はオーナー確定待ち
        static var brandIconSc: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_sc", defaultValue: "シャニ", table: "Model", bundle: L10n.bundle)
        }
        /// ヴィ — ブランドの丸いアイコンに載せる略称 (2〜4 文字。公式ロゴの代わり)。vα-livのファンの呼び方で、正式名ではない。ko の表記はオーナー確定待ち
        static var brandIconValv: LocalizedStringResource {
            LocalizedStringResource("model.brand.icon_valv", defaultValue: "ヴィ", table: "Model", bundle: L10n.bundle)
        }
        /// {label}のライブ — 絞り込んだライブ一覧の画面タイトル。label はブランド名 (データ) — 引数: label (string)
        static func eventFilterTitleBrand(label: String) -> LocalizedStringResource {
            LocalizedStringResource("model.event_filter.title.brand", defaultValue: "\(label)のライブ", table: "Model", bundle: L10n.bundle)
        }
        /// {year}年のライブ — 絞り込んだライブ一覧の画面タイトル。year は開催年 — 引数: year (int)
        static func eventFilterTitleYear(year: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.event_filter.title.year", defaultValue: "\(String(year))年のライブ", table: "Model", bundle: L10n.bundle)
        }
        /// {month}月生まれのアイドル — 絞り込んだアイドル一覧の画面タイトル。month は誕生月 (1〜12) — 引数: month (int)
        static func idolFilterTitleBirthMonth(month: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.idol_filter.title.birth_month", defaultValue: "\(String(month))月生まれのアイドル", table: "Model", bundle: L10n.bundle)
        }
        /// {place}出身のアイドル — 絞り込んだアイドル一覧の画面タイトル。place は出身地 (データ) — 引数: place (string)
        static func idolFilterTitleBirthPlace(place: String) -> LocalizedStringResource {
            LocalizedStringResource("model.idol_filter.title.birth_place", defaultValue: "\(place)出身のアイドル", table: "Model", bundle: L10n.bundle)
        }
        /// {type}型のアイドル — 絞り込んだアイドル一覧の画面タイトル。type は血液型 (A / B / O / AB) — 引数: type (string)
        static func idolFilterTitleBloodType(type: String) -> LocalizedStringResource {
            LocalizedStringResource("model.idol_filter.title.blood_type", defaultValue: "\(type)型のアイドル", table: "Model", bundle: L10n.bundle)
        }
        /// {label}のアイドル — 絞り込んだアイドル一覧の画面タイトル。label はブランド名 (データ) — 引数: label (string)
        static func idolFilterTitleBrand(label: String) -> LocalizedStringResource {
            LocalizedStringResource("model.idol_filter.title.brand", defaultValue: "\(label)のアイドル", table: "Model", bundle: L10n.bundle)
        }
        /// {name}のアイドル — 絞り込んだアイドル一覧の画面タイトル。name は星座の名前 (データ) — 引数: name (string)
        static func idolFilterTitleConstellation(name: String) -> LocalizedStringResource {
            LocalizedStringResource("model.idol_filter.title.constellation", defaultValue: "\(name)のアイドル", table: "Model", bundle: L10n.bundle)
        }
        /// 年齢 — アイドル一覧の並び順の名前。画面によっては「◯◯順」と組み合わせる
        static var idolSortAge: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.age", defaultValue: "年齢", table: "Model", bundle: L10n.bundle)
        }
        /// 誕生日 — アイドル一覧の並び順の名前
        static var idolSortBirthday: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.birthday", defaultValue: "誕生日", table: "Model", bundle: L10n.bundle)
        }
        /// デビュー日 — アイドル一覧の並び順の名前
        static var idolSortDebut: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.debut", defaultValue: "デビュー日", table: "Model", bundle: L10n.bundle)
        }
        /// 身長 — アイドル一覧の並び順の名前
        static var idolSortHeight: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.height", defaultValue: "身長", table: "Model", bundle: L10n.bundle)
        }
        /// 五十音順 — アイドル一覧の並び順の名前 (よみがなの五十音順)
        static var idolSortNameKana: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.name_kana", defaultValue: "五十音順", table: "Model", bundle: L10n.bundle)
        }
        /// 公式順 — アイドル一覧の並び順の名前 (公式の並び)
        static var idolSortOfficial: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.official", defaultValue: "公式順", table: "Model", bundle: L10n.bundle)
        }
        /// 体重 — アイドル一覧の並び順の名前
        static var idolSortWeight: LocalizedStringResource {
            LocalizedStringResource("model.idol_sort.weight", defaultValue: "体重", table: "Model", bundle: L10n.bundle)
        }
        /// {length} / {max}文字 — 入力欄の下の文字数の数え (例: 12 / 30文字)。length は今の文字数、max は上限 (どちらも 300 以下) — 引数: length (int), max (int)
        static func inputLimitsCounter(length: Int, max: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.input_limits.counter", defaultValue: "\(String(length)) / \(String(max))文字", table: "Model", bundle: L10n.bundle)
        }
        /// 第{rank}位 — 終了したお題での順位 (2 位・3 位)。rank は順位 — 引数: rank (int)
        static func pollAchievementRank(rank: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.poll_achievement.rank", defaultValue: "第\(String(rank))位", table: "Model", bundle: L10n.bundle)
        }
        /// 優勝 — 終了したお題で 1 位を取ったことを示す札
        static var pollAchievementWinner: LocalizedStringResource {
            LocalizedStringResource("model.poll_achievement.winner", defaultValue: "優勝", table: "Model", bundle: L10n.bundle)
        }
        /// アイドル — お題の対象の種類 (アイドルについて投票する)
        static var pollTargetIdol: LocalizedStringResource {
            LocalizedStringResource("model.poll_target.idol", defaultValue: "アイドル", table: "Model", bundle: L10n.bundle)
        }
        /// 曲 — お題の対象の種類 (曲について投票する)
        static var pollTargetSong: LocalizedStringResource {
            LocalizedStringResource("model.poll_target.song", defaultValue: "曲", table: "Model", bundle: L10n.bundle)
        }
        /// ユニット — お題の対象の種類 (ユニットについて投票する)
        static var pollTargetUnit: LocalizedStringResource {
            LocalizedStringResource("model.poll_target.unit", defaultValue: "ユニット", table: "Model", bundle: L10n.bundle)
        }
        /// {discs}枚 / {count}曲 — CD シリーズのカードの下に出す枚数と曲数。count は曲数 (1000 以上は桁区切りが付く。今は付かないが、1 シリーズでそこまでの曲数は無い見込み) — 引数: discs (int), count (count)
        static func seriesSubtitle(discs: Int, count: Int) -> LocalizedStringResource {
            LocalizedStringResource("model.series.subtitle", defaultValue: "\(String(discs))枚 / \(count)曲", table: "Model", bundle: L10n.bundle)
        }
        /// {date}の公演 — 絞り込んだ公演一覧の画面タイトル。date は日付の文字列 (YYYY-MM-DD) — 引数: date (string)
        static func showFilterTitleDate(date: String) -> LocalizedStringResource {
            LocalizedStringResource("model.show_filter.title.date", defaultValue: "\(date)の公演", table: "Model", bundle: L10n.bundle)
        }
        /// {venue}での公演 — 絞り込んだ公演一覧の画面タイトル。venue は会場名 (データ) — 引数: venue (string)
        static func showFilterTitleVenue(venue: String) -> LocalizedStringResource {
            LocalizedStringResource("model.show_filter.title.venue", defaultValue: "\(venue)での公演", table: "Model", bundle: L10n.bundle)
        }
        /// すべて — 楽曲一覧の「現地回収」の絞り込み (絞り込まない)
        static var songCollectFilterAll: LocalizedStringResource {
            LocalizedStringResource("model.song_collect_filter.all", defaultValue: "すべて", table: "Model", bundle: L10n.bundle)
        }
        /// 回収済のみ — 楽曲一覧の「現地回収」の絞り込み (ライブで聴いた曲だけ)
        static var songCollectFilterCollected: LocalizedStringResource {
            LocalizedStringResource("model.song_collect_filter.collected", defaultValue: "回収済のみ", table: "Model", bundle: L10n.bundle)
        }
        /// 未回収のみ — 楽曲一覧の「現地回収」の絞り込み (まだライブで聴いていない曲だけ)
        static var songCollectFilterUncollected: LocalizedStringResource {
            LocalizedStringResource("model.song_collect_filter.uncollected", defaultValue: "未回収のみ", table: "Model", bundle: L10n.bundle)
        }
        /// {label}の楽曲 — 絞り込んだ楽曲一覧の画面タイトル。label はブランド名 (データ) — 引数: label (string)
        static func songFilterTitleBrand(label: String) -> LocalizedStringResource {
            LocalizedStringResource("model.song_filter.title.brand", defaultValue: "\(label)の楽曲", table: "Model", bundle: L10n.bundle)
        }
        /// {name}が関わった楽曲 — 絞り込んだ楽曲一覧の画面タイトル。name は作詞・作曲・編曲した人の名前 — 引数: name (string)
        static func songFilterTitleCreator(name: String) -> LocalizedStringResource {
            LocalizedStringResource("model.song_filter.title.creator", defaultValue: "\(name)が関わった楽曲", table: "Model", bundle: L10n.bundle)
        }
        /// {year}年リリースの楽曲 — 絞り込んだ楽曲一覧の画面タイトル。year は発売年 (西暦 4 桁の文字列) — 引数: year (string)
        static func songFilterTitleReleaseYear(year: String) -> LocalizedStringResource {
            LocalizedStringResource("model.song_filter.title.release_year", defaultValue: "\(year)年リリースの楽曲", table: "Model", bundle: L10n.bundle)
        }
        /// {type}の楽曲 — 絞り込んだ楽曲一覧の画面タイトル。type は曲の種類の名前 (データ) — 引数: type (string)
        static func songFilterTitleSongType(type: String) -> LocalizedStringResource {
            LocalizedStringResource("model.song_filter.title.song_type", defaultValue: "\(type)の楽曲", table: "Model", bundle: L10n.bundle)
        }
        /// 現地回収回数順 — 楽曲一覧の並び順の名前 (自分が現地で聴いた回数)
        static var songSortCollectedCount: LocalizedStringResource {
            LocalizedStringResource("model.song_sort.collected_count", defaultValue: "現地回収回数順", table: "Model", bundle: L10n.bundle)
        }
        /// 回収率順 — 楽曲一覧の並び順の名前 (披露回数のうち自分が現地で聴いた割合)
        static var songSortCollectedRate: LocalizedStringResource {
            LocalizedStringResource("model.song_sort.collected_rate", defaultValue: "回収率順", table: "Model", bundle: L10n.bundle)
        }
        /// 披露回数順 — 楽曲一覧の並び順の名前 (ライブで歌われた回数)
        static var songSortPerformanceCount: LocalizedStringResource {
            LocalizedStringResource("model.song_sort.performance_count", defaultValue: "披露回数順", table: "Model", bundle: L10n.bundle)
        }
        /// リリース日順 — 楽曲一覧の並び順の名前
        static var songSortReleaseDate: LocalizedStringResource {
            LocalizedStringResource("model.song_sort.release_date", defaultValue: "リリース日順", table: "Model", bundle: L10n.bundle)
        }
        /// 五十音順 — 楽曲一覧の並び順の名前 (曲名のよみがなの五十音順)
        static var songSortTitleKana: LocalizedStringResource {
            LocalizedStringResource("model.song_sort.title_kana", defaultValue: "五十音順", table: "Model", bundle: L10n.bundle)
        }
        /// 全件再同期が必要です — 差分では追いつけず、全データの同期をやり直す必要があるとき
        static var syncErrorFullResyncRequired: LocalizedStringResource {
            LocalizedStringResource("model.sync.error.full_resync_required", defaultValue: "全件再同期が必要です", table: "Model", bundle: L10n.bundle)
        }
        /// iCloud状態の確認に失敗: {detail} — iCloud の状態を問い合わせられなかったとき。detail は OS のエラーの本文 — 引数: detail (string)
        static func syncErrorIcloudStatusFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.error.icloud_status_failed", defaultValue: "iCloud状態の確認に失敗: \(detail)", table: "Model", bundle: L10n.bundle)
        }
        /// iCloudアカウントが利用できません — 端末で iCloud にサインインしていない・制限されているとき
        static var syncErrorIcloudUnavailable: LocalizedStringResource {
            LocalizedStringResource("model.sync.error.icloud_unavailable", defaultValue: "iCloudアカウントが利用できません", table: "Model", bundle: L10n.bundle)
        }
        /// 同期日時の保存に失敗: {detail} — 同期の最後に日時を書けなかったとき。detail はエラーの本文 — 引数: detail (string)
        static func syncErrorSaveDateFailed(detail: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.error.save_date_failed", defaultValue: "同期日時の保存に失敗: \(detail)", table: "Model", bundle: L10n.bundle)
        }
        /// スキーマ設定が必要です: CloudKit Dashboard で {record_type} の modifiedAt を QUERYABLE + SORTABLE に設定してください — CloudKit 側の設定漏れ (開発者向け)。record_type はレコード型の名前。CloudKit Dashboard / modifiedAt / QUERYABLE / SORTABLE は訳さない — 引数: record_type (string)
        static func syncErrorSchemaRequired(recordType: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.error.schema_required", defaultValue: "スキーマ設定が必要です: CloudKit Dashboard で \(recordType) の modifiedAt を QUERYABLE + SORTABLE に設定してください", table: "Model", bundle: L10n.bundle)
        }
        /// {step}の同期に失敗: {detail} — ある段の同期が失敗したとき。step は段の名前 (コア由来)、detail はエラーの本文 — 引数: step (core), detail (string)
        static func syncErrorStepFailed(step: String, detail: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.error.step_failed", defaultValue: "\(step)の同期に失敗: \(detail)", table: "Model", bundle: L10n.bundle)
        }
        /// 最終同期: {date} — CloudKit 同期の状態 (完了)。date は書式済みの日時 — 引数: date (string)
        static func syncStateCompleted(date: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.state.completed", defaultValue: "最終同期: \(date)", table: "Model", bundle: L10n.bundle)
        }
        /// エラー: {message} — CloudKit 同期の状態 (失敗)。message は model.sync.error.* のどれか (解決済み) — 引数: message (string)
        static func syncStateError(message: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.state.error", defaultValue: "エラー: \(message)", table: "Model", bundle: L10n.bundle)
        }
        /// 待機中 — CloudKit 同期の状態 (何もしていない)。同期の帯とマイページに出る
        static var syncStateIdle: LocalizedStringResource {
            LocalizedStringResource("model.sync.state.idle", defaultValue: "待機中", table: "Model", bundle: L10n.bundle)
        }
        /// {step}を同期中… — CloudKit 同期の状態 (同期中)。step は同期している段の名前 (コア由来) — 引数: step (core)
        static func syncStateSyncing(step: String) -> LocalizedStringResource {
            LocalizedStringResource("model.sync.state.syncing", defaultValue: "\(step)を同期中…", table: "Model", bundle: L10n.bundle)
        }
        /// ライブ — 年表の横帯の名前 (ライブ・フェス)
        static var timelineLaneLive: LocalizedStringResource {
            LocalizedStringResource("model.timeline_lane.live", defaultValue: "ライブ", table: "Model", bundle: L10n.bundle)
        }
        /// 節目 — 年表の横帯の名前 (サービス開始・アニメ放映などの節目)。細い列に出るので短く
        static var timelineLaneMilestone: LocalizedStringResource {
            LocalizedStringResource("model.timeline_lane.milestone", defaultValue: "節目", table: "Model", bundle: L10n.bundle)
        }
        /// 楽曲 — 年表の横帯の名前 (CD シリーズ)
        static var timelineLaneMusic: LocalizedStringResource {
            LocalizedStringResource("model.timeline_lane.music", defaultValue: "楽曲", table: "Model", bundle: L10n.bundle)
        }
        /// その他 — 年表の横帯の名前 (リリイベ・ラジオ・配信番組など)
        static var timelineLaneOther: LocalizedStringResource {
            LocalizedStringResource("model.timeline_lane.other", defaultValue: "その他", table: "Model", bundle: L10n.bundle)
        }
    }
}
