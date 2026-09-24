import SwiftUI

/// 本文は i18n/catalog/legal.json (Android と ja が同じ節はキーも同じ。違う節は `*_ios` のキー)。
struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sp6) {
                Group {
                    termsSection(
                        title: L10n.Legal.termsDisclaimerHeader,
                        content: L10n.Legal.termsDisclaimerBody
                    )

                    termsSection(
                        title: L10n.Legal.termsIpHeader,
                        content: L10n.Legal.termsIpBody
                    )

                    termsSection(
                        title: L10n.Legal.termsMaterialsHeader,
                        content: L10n.Legal.termsMaterialsBodyIos
                    )

                    termsSection(
                        title: L10n.Legal.termsUserContentHeader,
                        content: L10n.Legal.termsUserContentBody
                    )

                    termsSection(
                        title: L10n.Legal.termsContentLicenseHeader,
                        content: L10n.Legal.termsContentLicenseBodyIos
                    )

                    termsSection(
                        title: L10n.Legal.termsProhibitedHeader,
                        content: L10n.Legal.termsProhibitedBodyIos
                    )

                    termsSection(
                        title: L10n.Legal.termsServiceChangesHeader,
                        content: L10n.Legal.termsServiceChangesBody
                    )

                    termsSection(
                        title: L10n.Legal.termsContactHeader,
                        content: L10n.Legal.termsContactBody
                    )
                }

                Text(L10n.Legal.termsLastUpdated)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
                    .padding(.top, DS.sp3)
            }
            .padding(DS.sp6)
        }
        .navigationTitle(L10n.About.termsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .trackScreen("terms_of_service")
    }

    private func termsSection(title: LocalizedStringResource, content: LocalizedStringResource) -> some View {
        VStack(alignment: .leading, spacing: DS.sp3) {
            Text(title)
                .font(.imasHeadline)
            Text(content)
                .font(.imasSubhead)
                .foregroundStyle(DS.ink2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
