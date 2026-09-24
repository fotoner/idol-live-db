import SwiftUI
import MusicKit

struct IntroDonHomeView: View {
    @State private var showSetup = false
    @State private var authStatus: MusicAuthorization.Status = MusicKitService.shared.authorizationStatus

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                    .padding(.horizontal, DS.sp6)
                    .padding(.top, DS.sp7)

                Spacer().frame(height: 28)

                VStack(spacing: DS.sp4) {
                    IDActionButton(
                        title: String(localized: L10n.Introdon.homeActionStart),
                        icon: "play.fill",
                        style: .primary
                    ) {
                        AppAnalytics.tap("intro_don_home.start_game")
                        showSetup = true
                    }
                    .padding(.horizontal, DS.sp6)

                    if authStatus != .authorized {
                        authWarningCard
                            .padding(.horizontal, DS.sp6)
                    }
                }

                Spacer().frame(height: 28)

                IDSectionLabel(text: String(localized: L10n.Introdon.homeBattleHeader))
                    .padding(.horizontal, DS.sp6)

                Spacer().frame(height: 12)

                battleModeCard
                    .padding(.horizontal, DS.sp6)

                Spacer().frame(height: 32)
            }
        }
        .background(ID.menuBg.ignoresSafeArea())
        .navigationTitle(L10n.Introdon.homeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSetup) {
            IntroGameSetupView()
        }
        .task {
            if MusicKitService.shared.authorizationStatus == .notDetermined {
                await MusicKitService.shared.requestAuthorization(includingMediaLibrary: true)
            }
            authStatus = MusicKitService.shared.authorizationStatus
        }
        .trackScreen("intro_don_home")
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: DS.sp5) {
            HStack(spacing: 14) {
                ZStack {
                    IDCorner(radius: 16)
                        .fill(ID.menuCardDark)
                        .frame(width: 64, height: 64)
                    Image(systemName: "music.note.list")
                        .font(.imasScaled( 28, weight: .semibold))
                        .foregroundColor(ID.menuCardDarkText)
                }

                VStack(alignment: .leading, spacing: DS.sp2) {
                    Text("INTRO DON")
                        .font(ID.font(11, weight: .bold))
                        .tracking(2)
                        .foregroundColor(ID.menuTextSecondary)
                    Text(L10n.Introdon.homeHeroTitle)
                        .font(ID.font(28, weight: .black))
                        .tracking(-0.5)
                        .foregroundColor(ID.menuText)
                }
            }

            Text(L10n.Introdon.homeHeroCaptionIos)
                .font(.imasScaled( 14))
                .foregroundColor(ID.menuTextSecondary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.sp7)
        .background(ID.menuCardSubtle)
        .clipShape(IDCorner())
    }

    private var authWarningCard: some View {
        VStack(spacing: DS.sp4) {
            HStack(spacing: DS.sp3) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(ID.accentGold)
                Text(L10n.Introdon.authWarning)
                    .font(ID.font(14, weight: .semibold))
                    .foregroundColor(ID.menuText)
                Spacer()
            }

            IDActionButton(title: String(localized: L10n.Introdon.authActionAllow), icon: "music.note", style: .secondary) {
                AppAnalytics.tap("intro_don_home.music_auth")
                Task {
                    await MusicKitService.shared.requestAuthorization(includingMediaLibrary: true)
                    authStatus = MusicKitService.shared.authorizationStatus
                }
            }
        }
        .padding(DS.sp5)
        .background(ID.accentGold.opacity(0.08))
        .clipShape(IDCorner(radius: 16))
        .overlay(
            IDCorner(radius: 16)
                .stroke(ID.accentGold.opacity(0.25), lineWidth: 1)
        )
    }

    private var battleModeCard: some View {
        let searchUrl = URL(string: "https://apps.apple.com/jp/app/intro-%E3%82%A4%E3%83%B3%E3%83%88%E3%83%AD%E3%82%AF%E3%82%A4%E3%82%BA/id6760829877")!

        return VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: DS.sp2) {
                    Text("BATTLE MODE")
                        .font(ID.font(11, weight: .bold))
                        .tracking(2)
                        .foregroundColor(ID.menuTextSecondary)
                    Text(L10n.Introdon.homeBattleTitle)
                        .font(ID.font(18, weight: .black))
                        .tracking(-0.3)
                        .foregroundColor(ID.menuText)
                    Text(L10n.Introdon.homeBattleMessage)
                        .font(.imasCaption)
                        .foregroundColor(ID.menuTextSecondary)
                        .lineSpacing(2)
                        .padding(.top, DS.sp1)
                }
                Spacer()
                Image(systemName: "person.2.fill")
                    .font(.imasScaled( 28))
                    .foregroundColor(ID.menuTextMuted)
            }
            .padding(.horizontal, DS.sp7)
            .padding(.top, DS.sp7)
            .padding(.bottom, DS.sp5)

            Divider()
                .background(ID.menuDivider)
                .padding(.horizontal, DS.sp5)

            Link(destination: searchUrl) {
                HStack(spacing: DS.sp3) {
                    Text(L10n.Introdon.homeBattleOpenStore)
                        .font(ID.font(14, weight: .semibold))
                        .foregroundColor(ID.menuTextSecondary)
                    Image(systemName: "arrow.up.right")
                        .font(.imasScaled( 12, weight: .semibold))
                        .foregroundColor(ID.menuTextMuted)
                    Spacer()
                }
                .padding(.horizontal, DS.sp7)
                .padding(.vertical, DS.sp5)
            }
        }
        .background(ID.menuCardSubtle)
        .clipShape(IDCorner())
    }
}
