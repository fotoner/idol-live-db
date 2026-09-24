import SwiftUI

/// 未ログインユーザーが編集 / 新規作成導線を押した時に出すログイン誘導 sheet。
///
/// 確定モデルでは「ログイン済み全ユーザーがオープン編集可能」。未ログインでも導線は見えるが、
/// 押下時にここへ誘導する。ログイン完了 (`AuthService.shared.isSignedIn` が true) を監視して
/// 自動で dismiss し、呼び出し側が保持していた編集対象を再 present できるようにする。
struct LoginToEditSheet: View {
    /// ログイン完了時に呼ばれる。呼び出し側はここで元の編集対象を再 present する。
    var onSignedIn: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: DS.sp6) {
                Image(systemName: "square.and.pencil")
                    .font(.imasScaled( 44))
                    .foregroundStyle(.tint)
                    .padding(.top, DS.sp8)

                Text(L10n.EditFeed.loginSheetTitle)
                    .font(.imasTitle3.bold())

                Text(L10n.EditFeed.loginSheetMessage)
                    .font(.imasSubhead)
                    .foregroundStyle(DS.ink2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.sp3)

                VStack(alignment: .leading, spacing: 10) {
                    pointRow("bolt.fill", L10n.EditFeed.loginSheetPointInstant)
                    pointRow("clock.arrow.circlepath", L10n.EditFeed.loginSheetPointHistory)
                    pointRow("eye", L10n.EditFeed.loginSheetPointBrowse)
                }
                .font(.imasFootnote)
                .padding(.horizontal)

                AppleSignInButton()
                    .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen("login_sheet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.EditFeed.loginSheetClose) { dismiss() }
                }
            }
            // ログイン完了を監視。サインインすると即 dismiss → 呼び出し側が編集対象を再 present。
            .onChange(of: AuthService.shared.isSignedIn) { _, signedIn in
                if signedIn {
                    onSignedIn()
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func pointRow(_ icon: String, _ text: LocalizedStringResource) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.tint)
                .frame(width: 20)
            Text(text)
                .foregroundStyle(DS.ink2)
            Spacer(minLength: 0)
        }
    }
}

/// ログインが必要なコンポーネント内に表示するインライン導線。
/// 未ログイン (セッション失効を含む) のときだけ表示し、タップで LoginToEditSheet を開く。
/// セッションが自動リフレッシュ不能になると AuthService.isSignedIn=false になり、ここが現れる。
struct InlineLoginPrompt: View {
    /// 呼び出し側の文言 (`String(localized: L10n.<Ns>.<key>)`)。省略時は投稿・投票の案内。
    var message: String = String(localized: L10n.EditFeed.inlineLoginDefaultMessage)
    var seed: String? = nil
    @Environment(\.colorScheme) private var scheme
    @State private var showLogin = false

    var body: some View {
        if !AuthService.shared.isSignedIn {
            let t = ImasTheme.derive(seed: seed, scheme: scheme)
            Button {
                AppAnalytics.tap("inline_login.open")
                showLogin = true
            } label: {
                HStack(spacing: DS.sp2) {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .font(.imasScaled( 15, weight: .semibold))
                    Text(message).font(.imasFootnote.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    Text(L10n.Common.actionLogin)
                        .font(.imasFootnote.weight(.bold))
                        .padding(.horizontal, DS.sp4).padding(.vertical, 6)
                        .foregroundStyle(t.onAccent)
                        .background(t.accent, in: Capsule())
                }
                .foregroundStyle(DS.ink2)
                .padding(.horizontal, DS.sp4).padding(.vertical, DS.sp3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DS.surface, in: RoundedRectangle(cornerRadius: DS.rMD, style: .continuous))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showLogin) { LoginToEditSheet() }
        }
    }
}
