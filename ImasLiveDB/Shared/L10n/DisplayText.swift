import Foundation

/// 表示文言。カタログの文言か、訳さないデータか、コア由来か。
///
/// 文字列リテラルからは作れない (ExpressibleByStringLiteral にしない)。
/// 画面の文言をカタログに移すときは、DS コンポーネントがこれを受けるようにする — リテラルが
/// LocalizedStringResource に化けて翻訳引き・ロケール書式 (桁区切り) の経路へ黙って入るのを型で塞ぐため。
///
/// - 文言: `.key(L10n.X.y)`
/// - データ: `.verbatim(name)` (曲名・アイドル名・サーバの文言・ユーザー入力・書式済みの数値)
/// - コア由来: `.core(label)` (imas-core が作った完成文字列。今は verbatim と同じに出す)
enum DisplayText: Sendable, Equatable {
    case key(LocalizedStringResource)
    case verbatim(String)
    /// 今は verbatim と同じに出す。コアの文言の扱いを決めたときに、置き換える箇所をこれで探せるよう分けておく。
    case core(String)

    /// 画面の外 (errorDescription・共有テキスト・通知) で文字列にする。
    /// View の中では `Text(display:)` に渡す (こちらを経由して String にしない)。
    var resolved: String {
        switch self {
        case .key(let resource): String(localized: resource)
        case .verbatim(let s), .core(let s): s
        }
    }
}
