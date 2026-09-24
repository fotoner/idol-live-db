import SwiftUI

/// 本文は i18n/catalog/legal.json (Android と ja が同じ節はキーも同じ。違う節は `*_ios` のキー)。
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.sp6) {
                Group {
                    policySection(
                        title: L10n.Legal.privacyOverviewHeader,
                        content: L10n.Legal.privacyOverviewBody
                    )

                    policySection(
                        title: L10n.Legal.privacyCollectedHeader,
                        content: L10n.Legal.privacyCollectedBodyIos
                    )

                    policySection(
                        title: L10n.Legal.privacyFrameworksHeader,
                        content: L10n.Legal.privacyFrameworksBody
                    )

                    policySection(
                        title: L10n.Legal.privacyThirdPartyHeader,
                        content: L10n.Legal.privacyThirdPartyBodyIos
                    )

                    policySection(
                        title: L10n.Legal.privacySharingHeader,
                        content: L10n.Legal.privacySharingBodyIos
                    )

                    policySection(
                        title: L10n.Legal.privacyRightsHeader,
                        content: L10n.Legal.privacyRightsBodyIos
                    )

                    policySection(
                        title: L10n.Legal.privacyContactHeader,
                        content: L10n.Legal.privacyContactBody
                    )
                }

                Text(L10n.Legal.privacyLastUpdated)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
                    .padding(.top, DS.sp3)
            }
            .padding(DS.sp6)
        }
        .navigationTitle(L10n.About.privacyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .trackScreen("privacy_policy")
    }

    private func policySection(title: LocalizedStringResource, content: LocalizedStringResource) -> some View {
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
