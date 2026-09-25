import SwiftUI

// DisplayText (Shared/L10n) を SwiftUI で描く口。
// Shared/L10n はウィジェットとも共有し、Foundation 以外に依存しない決まりなので、SwiftUI への橋渡しはここに置く。

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
}
