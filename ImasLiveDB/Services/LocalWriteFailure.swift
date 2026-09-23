import Foundation
import os

/// 端末にしか無いデータ (担当・参加・メモ・習熟度・家計簿) の書き込み失敗を 1 か所で受ける。
///
/// これらはクラウドにもサーバにも無いので、書けなかったことを黙っていると、保存したつもりの
/// 記録が次に開いたときに消えている。画面は `try?` で握りつぶさず、失敗をここへ渡す。
enum LocalWriteFailure {
    /// - Parameter action: 何をしようとして失敗したか (例: "メモの保存")。
    static func report(_ error: Error, action: String) {
        Logger.database.error(
            "local_write_failed action=\(action, privacy: .public) error=\(error.localizedDescription, privacy: .public)"
        )
    }
}
