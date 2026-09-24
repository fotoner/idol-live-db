import SwiftUI

struct SupportView: View {
    @Environment(\.openURL) private var openURL

    private let githubIssueURL = URL(string: "https://github.com/fuga-if/imas-live-privacy/issues/new")!

    var body: some View {
        List {
            Section(L10n.About.supportFeedbackHeader) {
                Button {
                    AppAnalytics.tap("support.github_issue")
                    openURL(githubIssueURL)
                } label: {
                    Label(L10n.About.supportFeedbackGithub, systemImage: "arrow.up.right.square")
                }
            }

            Section(L10n.About.supportFaqHeader) {
                faqItem(
                    question: L10n.About.supportFaqStaleDataQuestion,
                    answer: L10n.About.supportFaqStaleDataAnswer
                )

                faqItem(
                    question: L10n.About.supportFaqArtworkQuestion,
                    answer: L10n.About.supportFaqArtworkAnswerIos
                )

                faqItem(
                    question: L10n.About.supportFaqSyncQuestionIos,
                    answer: L10n.About.supportFaqSyncAnswerIos
                )

                faqItem(
                    question: L10n.About.supportFaqScannerQuestion,
                    answer: L10n.About.supportFaqScannerAnswer
                )

                faqItem(
                    question: L10n.About.supportFaqUnofficialQuestion,
                    answer: L10n.About.supportFaqUnofficialAnswer
                )
            }
        }
        .navigationTitle(L10n.About.supportTitle)
        .navigationBarTitleDisplayMode(.inline)
        .trackScreen("support")
    }

    /// 「Q. 」「A. 」はどの言語でも同じ記号なのでカタログに入れず、訳した問いと答えの前に付ける。
    private func faqItem(question: LocalizedStringResource, answer: LocalizedStringResource) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: "Q. \(String(localized: question))")
                .font(.imasSubhead)
                .fontWeight(.semibold)
            Text(verbatim: "A. \(String(localized: answer))")
                .font(.imasSubhead)
                .foregroundStyle(DS.ink2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, DS.sp2)
    }
}
