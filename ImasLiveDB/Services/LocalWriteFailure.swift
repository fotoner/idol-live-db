import Foundation
import os

/// 端末にしか無いデータ (担当・参加・メモ・座席・習熟度・家計簿・マイタグ) の書き込み失敗を 1 か所で受ける。
///
/// これらはクラウドにもサーバにも無いので、書けなかったことを黙っていると、保存したつもりの
/// 記録が次に開いたときに消えている。画面は `try?` で握りつぶさず、失敗をここへ渡す。
///
/// ログに残し、利用者にはアラートで知らせる。出し方 (`presenter`) はアプリの起動時に差し込む
/// (`LocalWriteFailureAlert`)。ここは UIKit を知らない。
@MainActor
enum LocalWriteFailure {
    /// 利用者に見せる知らせ。何をしようとして失敗したか (`action`) だけを値で持ち、
    /// 文面は出す口 (`LocalWriteFailureAlert`) が読んだ時点の言語で作る。
    struct Notice: Equatable {
        /// 失敗した操作の名前 (例: メモの保存)。
        let action: DisplayText

        var title: String { String(localized: L10n.EditFeed.localWriteFailedTitle) }

        /// 書き込みは 1 トランザクションなので、失敗したら何も変わっていない。それをそのまま伝える。
        /// 操作名は同じ言語で文字列にしてから文に差し込む。
        var message: String {
            String(localized: L10n.EditFeed.localWriteFailedMessage(action: action.resolved))
        }
    }

    /// 知らせを出す口。nil ならログだけ残す。
    static var presenter: (@MainActor (Notice) -> Void)?

    /// - Parameter action: 何をしようとして失敗したか。文言は `.key(L10n.<Ns>.<key>)` で渡す。
    static func report(_ error: Error, action: DisplayText) {
        Logger.database.error(
            "local_write_failed action=\(action.resolved, privacy: .public) error=\(error.localizedDescription, privacy: .public)"
        )
        presenter?(notice(action: action))
    }

    /// 操作名を文字列で受ける入口 (例: "メモの保存")。まだ日本語の文字列のまま渡す画面があるので残す。
    /// 文字列はそのまま (verbatim) 文に差し込む。
    static func report(_ error: Error, action: String) {
        report(error, action: .verbatim(action))
    }

    /// 失敗した操作の名前から、知らせを作る。
    static func notice(action: DisplayText) -> Notice {
        Notice(action: action)
    }
}
