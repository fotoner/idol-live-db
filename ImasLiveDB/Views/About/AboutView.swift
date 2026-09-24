import SwiftUI
import StoreKit

struct AboutView: View {

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: DS.sp3) {
                    Image(systemName: "music.mic.circle.fill")
                        .font(.imasScaled( 64))
                        .foregroundStyle(.tint)
                    Text("ImasLiveDB")
                        .font(.imasTitle2.bold())
                    Text(L10n.About.mainTagline)
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                    Text("ver. \(appVersion) (\(buildNumber))")
                        .font(.imasCaption2)
                        .foregroundStyle(DS.ink2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.sp4)
            }

            Section(L10n.About.mainDeveloperHeader) {
                // LabeledContent の LocalizedStringResource 版は iOS 26 から。String 版 (そのまま出す) に解決済みを渡す
                LabeledContent(String(localized: L10n.About.mainDeveloperLabel), value: "fuga-if")
                Link(destination: URL(string: "https://github.com/fuga-if")!) {
                    Label(L10n.About.mainDeveloperGithub, systemImage: "arrow.up.right.square")
                }
            }

            Section {
                Link(destination: URL(string: "https://ko-fi.com/fugaapp")!) {
                    Label(L10n.About.mainDonateAction, systemImage: "heart.fill")
                }
            } footer: {
                Text(L10n.About.mainDonateFooter)
            }

            Section {
                ossCredit(
                    // i18n-ignore(data): 参照元サイトの名前 (固有名詞)。訳さない
                    name: "アイマスDB",
                    license: .key(L10n.About.mainSourcesImasDb),
                    url: "https://imas-db.jp/"
                )
                ossCredit(
                    name: "music765plus",
                    license: .key(L10n.About.mainSourcesMusic765plus),
                    url: "https://music765plus.com/"
                )
                ossCredit(
                    name: "im@sparql",
                    license: .key(L10n.About.mainSourcesImasparql),
                    url: "https://sparql.crssnky.xyz/imas/"
                )
                ossCredit(
                    name: "imas-palette",
                    license: .key(L10n.About.mainSourcesImasPalette),
                    url: "https://github.com/arrow2nd/imas-palette"
                )
            } header: {
                Text(L10n.About.mainSourcesHeader)
            } footer: {
                Text(L10n.About.mainSourcesFooter)
            }

            Section(L10n.About.mainLicensesHeader) {
                // 許諾条件で掲示が要る。歌詞タブを畳んでも消さないこと
                // (許諾期間中は掲載し続けるのが条件)。
                JASRACLicenseNotice(placement: .about)
                ossCredit(name: "GRDB.swift", license: .verbatim("MIT License"), url: "https://github.com/groue/GRDB.swift")
                ossCredit(name: "Nuke", license: .verbatim("MIT License"), url: "https://github.com/kean/Nuke")
            }

            Section(L10n.About.mainAppInfoHeader) {
                NavigationLink(L10n.About.privacyTitle) {
                    PrivacyPolicyView()
                }
                NavigationLink(L10n.About.termsTitle) {
                    TermsOfServiceView()
                }
                NavigationLink(L10n.About.supportTitle) {
                    SupportView()
                }
                // ⚠️ ここで requestReview() を呼ばないこと。OS の都合 (年3回の上限等) で
                //    無視されることがあり、押しても何も起きないボタンになる。
                //    自分から評価しに来た人には App Store の投稿画面を直接開く。
                //    requestReview() は「こちらから声を掛ける」側 (ContentView) の担当。
                if let url = ReviewPrompt.writeReviewURL {
                    Link(destination: url) {
                        Label(L10n.About.mainAppInfoRate, systemImage: "star.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AppAnalytics.tap("about.rate_app")
                    })
                }
            }

            Section {
                Text(L10n.About.mainBackupNote)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
            }

            Section {
                Text(L10n.About.mainDisclaimer)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
            }
        }
        .navigationTitle(L10n.About.mainTitle)
        .navigationBarTitleDisplayMode(.inline)
        .trackScreen("about")
    }

    /// name は固有名詞 (サイト名・ライブラリ名) なのでそのまま出す。license は文言 (.key) か、訳さないライセンス名 (.verbatim)。
    private func ossCredit(name: String, license: DisplayText, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            VStack(alignment: .leading, spacing: DS.sp1) {
                Text(name)
                    .font(.imasSubhead)
                    .foregroundStyle(DS.ink)
                Text(display: license)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
            }
        }
    }
}
