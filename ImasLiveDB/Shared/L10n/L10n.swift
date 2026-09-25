import Foundation

/// カタログ (i18n/catalog) の文言への入口。中身は Generated/L10n+<Ns>.generated.swift が足す。
/// Android の com.fugaif.imaslivedb.i18n.generated.L10n と同じ名前で引ける (`L10n.I18n.languageTag`)。
///
/// (このディレクトリはアプリ本体とウィジェット拡張の両方に含まれる。Foundation 以外に依存しないこと)
enum L10n {
    /// このファイルを含むターゲット (アプリ or ウィジェット) のバンドル。テストでもアプリ本体を指す。
    /// `.main` にしないのは、ウィジェット拡張でも拡張自身のバンドルの表を引くことを型の置き場で保証するため。
    /// (BundleDescription は Sendable なので static let でよい。文言そのものはロケールを抱えるので
    /// static let に置かないこと — 生成アクセサが computed なのはそのため)
    static let bundle = LocalizedStringResource.BundleDescription.forClass(BundleToken.self)

    private final class BundleToken {}
}
