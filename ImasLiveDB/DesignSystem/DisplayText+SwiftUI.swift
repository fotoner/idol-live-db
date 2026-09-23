import SwiftUI

// DisplayText (Shared/L10n, Foundation のみ) を SwiftUI で描く口。
// Shared はウィジェットと共有するので SwiftUI を import できない — その橋渡しはここに置く。

extension Text {
    /// 文言はカタログを引き (`Text(LocalizedStringResource)`)、データ・コア由来はそのまま出す (verbatim)。
    ///
    /// ラベル無しの `init(_:)` にしない。アプリ中の `Text("…")` / `Text(x)` 全部の候補に
    /// DisplayText 版が 1 つ増え、大きな View の body が型検査の制限時間を超える
    /// (CalendarView.body で実際に「unable to type-check this expression in reasonable time」になった)。
    init(display text: DisplayText) {
        switch text {
        case .key(let resource): self.init(resource)
        case .verbatim(let s), .core(let s): self.init(verbatim: s)
        }
    }

    /// コア由来の文字列をそのまま出す。`.core` と同じく、コア段階で置き換える箇所の目印。
    init(core s: String) {
        self.init(verbatim: s)
    }
}
