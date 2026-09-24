import os
import SwiftUI
import UniformTypeIdentifiers
import UserNotifications

struct MyPageView: View {
    @Environment(AppDatabase.self) private var database
    @Environment(CloudKitSyncEngine.self) private var syncEngine
    @Environment(\.dismiss) private var dismiss
    @AppStorage("defaultBrandId") private var defaultBrandId: String = ""
    /// 文字サイズ (極小 0.7 / 小 0.85 / 中 1.0 / 大 1.15 / 特大 1.3)。OS の Dynamic Type に
    /// 乗算で併用するアプリ内倍率。中(1.0) を境に縮小・拡大の両方向へ調整できる。
    @AppStorage("text_scale") private var textScale: Double = 1.0
    private static let textScaleOptions: [Double] = [0.7, 0.85, 1.0, 1.15, 1.3]
    /// 歌唱者の表示サンプル (実データの 1 人)。設定を切り替えた見え方をその場で見せる。
    private static let performerNameSample = PerformerRow(
        id: "sample",
        // i18n-ignore(sample): 声優名の見本 (固有名詞。訳さない)
        name: "下田麻美",
        idolColor: nil,
        // i18n-ignore(sample): アイドル名の見本 (固有名詞。訳さない)
        idolName: "双海亜美"
    )
    /// 文字サイズの選択肢の名前 (textScaleOptions と同じ順)。表示言語で引き直すので static let にしない。
    private var textScaleLabels: [String] {
        [
            String(localized: L10n.Settings.textScaleXsmall),
            String(localized: L10n.Settings.textScaleSmall),
            String(localized: L10n.Settings.textScaleMedium),
            String(localized: L10n.Settings.textScaleLarge),
            String(localized: L10n.Settings.textScaleXlarge),
        ]
    }
    private var textScaleIndex: Binding<Int> {
        Binding(
            // 既存ユーザーの保存値 (0.7/0.85/1.0) はそのまま該当インデックスに載る。
            // 未知値のフォールバックは「中」(1.0)。
            get: { Self.textScaleOptions.firstIndex(of: textScale) ?? Self.textScaleOptions.firstIndex(of: 1.0) ?? 2 },
            set: { textScale = Self.textScaleOptions[$0] }
        )
    }
    /// イベント名の作品名プレフィックスを省略表示するか (既定 ON)。OFF でフル表示。
    @AppStorage("event_name_abbreviate") private var abbreviateEventNames: Bool = true
    /// セトリの歌唱者をどの名前で出すか (既定=アイドル名)。
    /// 保存するのはコアが決めた `raw` の文字列 (序数で保存しない)。
    @AppStorage(PerformerNamePref.storageKey) private var performerNameRaw = PerformerNamePref.defaultRaw
    /// 曲一覧の「この絞り込みでイントロドン」導線を隠すか (曲一覧側の×と同じキー)。
    @AppStorage("songlist_introdon_bar_hidden") private var introDonBarHidden: Bool = false
    /// 回収に配信参加も含めるか (既定=現地のみ)。地方勢など配信中心の人向け。
    @AppStorage("collection_include_stream") private var includeStreamInCollection: Bool = false
    /// 担当(推し)カラーをアプリ全体テーマに使うか。
    @AppStorage("theme_use_oshi_color") private var useOshiColor: Bool = false
    /// テーマに使う担当アイドル ID (複数担当から1人選択)。
    @AppStorage("theme_oshi_idol_id") private var themeOshiIdolId: String = ""
    /// ContentView が参照する解決済みテーマ色 hex。無効時は空。
    @AppStorage("theme_oshi_color") private var themeOshiColorHex: String = ""

    // MARK: - 通知設定
    @AppStorage("notif_oshi_birthday") private var notifOshiBirthday: Bool = true
    @AppStorage("notif_live_week") private var notifLiveWeek: Bool = true
    @AppStorage("notif_ticket") private var notifTicket: Bool = true
    @AppStorage("notif_monday") private var notifMonday: Bool = true
    /// 現在の通知認可状態。View の onAppear で更新する。
    /// データ取得はすべて VM 側 (ポート注入)。View は UI 状態だけ持つ。
    @State private var vm = MyPageViewModel()
    @State private var notifAuthStatus: UNAuthorizationStatus = .notDetermined
    /// 担当(推し)に設定済みのアイドル一覧 (テーマ選択用)。
    @State private var imageURL: String = ""
    @State private var importer = BulkImageImporter()
    @State private var showImageImport = false
    @State private var brandImageURL: String = ""
    @State private var showBrandImageImport = false
    @State private var unitImageURL: String = ""
    @State private var showUnitImageImport = false
    @State private var showDeleteAccountConfirm = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountErrorMessage: String?
    @State private var showHelp = false
    @State private var showEditName = false
    @State private var editingName = ""
    @State private var isSavingName = false
    /// 表示名の保存に失敗したときの本文 (アプリの文言か、サーバ・OS のエラー文)。
    @State private var nameErrorMessage: DisplayText?

    // MARK: - バックアップ/引き継ぎコード
    /// 復元時に端末IDも引き継ぐか (上級者向け・既定OFF)。同一端末からの復元でない限りOFFのままにすべき。
    @AppStorage("backup_restore_device_id") private var restoreDeviceIdOnImport: Bool = false
    @State private var isCreatingTransferCode = false
    @State private var transferCode: String?
    @State private var transferCodeExpiresAt: Date?
    @State private var transferCodeErrorMessage: String?
    @State private var importCodeInput = ""
    @State private var isImportingByCode = false
    @State private var backupFileURL: URL?
    @State private var exportErrorMessage: String?
    @State private var showBackupFileImporter = false
    @State private var importResultMessage: String?
    @State private var importErrorMessage: String?

    // admin モデレーション導線。確定契約 §1 で公開フィードは editorId を返さない
    // (編集者匿名性) ため、admin は対象ユーザー ID を直接指定してモデレーション画面を開く。
    @State private var showModerationPrompt = false
    @State private var moderationUserIdInput = ""
    /// 入力された userId でモデレーション画面を開く (sheet 駆動)。
    @State private var moderationTarget: String?

    private var isSyncing: Bool {
        if case .syncing = syncEngine.state { return true }
        return false
    }

    // 型チェック負荷を下げるため List の中身を上下2つに分割。
    @ViewBuilder
    private var upperSections: some View {
        // この画面は「設定」。参加ライブ/貢献バッジ/編集履歴 等の個人アクティビティは
        // プロデュースタブ「あなたの活動」と重複するため、ここには置かない。
        accountSection
        if AuthService.shared.adminCapabilities.canModerateUsers {
            adminSection
        }
    }

    @ViewBuilder
    private var lowerSections: some View {
        settingsSection
        dataSyncSection
        dataBackupSection
        if let stats = vm.dbStats {
            dataStatsSection(stats)
        }
        creditsSection
        appInfoSection
    }

    // 型チェック負荷分散: List + chrome を decoratedList に切り出し、alert/sheet 群は body 側に。
    private var decoratedList: some View {
        List {
            upperSections
            lowerSections
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(DS.bg)
        .navigationTitle(L10n.Settings.screenTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { dismiss() } label: { Text(L10n.Settings.actionClose) }
            }
        }
        .task { await loadAll() }
        .onChange(of: syncEngine.state) {
            if case .completed = syncEngine.state {
                Task { await loadAll() }
            }
        }
    }

    var body: some View {
        NavigationStack {
            decoratedList
            .alert(Text(L10n.Settings.imageImportIdolDialogTitle), isPresented: $showImageImport) {
                TextField("JSON URL", text: $imageURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button {
                    Task {
                        await importer.importFromURL(imageURL, database: database)
                    }
                } label: { Text(L10n.Settings.actionImport) }
                Button(role: .cancel) {} label: { Text(L10n.Settings.actionCancel) }
            } message: {
                Text(L10n.Settings.imageImportIdolDialogMessage)
            }
            .alert(Text(L10n.Settings.imageImportBrandDialogTitle), isPresented: $showBrandImageImport) {
                TextField("JSON URL", text: $brandImageURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button {
                    Task {
                        await importer.importBrandImagesFromURL(brandImageURL, database: database)
                    }
                } label: { Text(L10n.Settings.actionImport) }
                Button(role: .cancel) {} label: { Text(L10n.Settings.actionCancel) }
            } message: {
                Text(L10n.Settings.imageImportBrandDialogMessage)
            }
            .alert(Text(L10n.Settings.imageImportUnitDialogTitle), isPresented: $showUnitImageImport) {
                TextField("JSON URL", text: $unitImageURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button {
                    Task {
                        await importer.importUnitImagesFromURL(unitImageURL, database: database)
                    }
                } label: { Text(L10n.Settings.actionImport) }
                Button(role: .cancel) {} label: { Text(L10n.Settings.actionCancel) }
            } message: {
                Text(L10n.Settings.imageImportUnitDialogMessage)
            }
            .sheet(isPresented: $showHelp) {
                HelpView()
            }
            .alert(Text(L10n.Settings.accountEditNameTitle), isPresented: $showEditName) {
                // LocalizedStringResource を受ける TextField(_:text:) は iOS 26 からなので、prompt: 付きの版 (iOS 16) を使う
                TextField(L10n.Settings.accountEditNamePlaceholder, text: $editingName, prompt: nil)
                    .textInputAutocapitalization(.never)
                    .onChange(of: editingName) { _, new in
                        // 上限と数え方 (コードポイント) はコア。無制限に打てるとサーバ側で弾かれる。
                        let clamped = InputLimits.clamp(.displayName, new)
                        if clamped != new { editingName = clamped }
                    }
                Button {
                    Task { await saveDisplayName() }
                } label: { Text(L10n.Settings.actionSave) }
                .disabled(!InputLimits.isAcceptable(.displayName, editingName) || isSavingName)
                Button(role: .cancel) {} label: { Text(L10n.Settings.actionCancel) }
            } message: {
                Text(L10n.Settings.accountEditNameMessage(max: InputLimits.max(.displayName)))
            }
            .alert(Text(L10n.Settings.accountEditNameErrorTitle), isPresented: Binding(
                get: { nameErrorMessage != nil },
                set: { if !$0 { nameErrorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk, role: .cancel) { nameErrorMessage = nil }
            } message: {
                Text(display: nameErrorMessage ?? .verbatim(""))
            }
            .alert("ユーザーをモデレーション", isPresented: $showModerationPrompt) {
                TextField("ユーザー ID", text: $moderationUserIdInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("開く") {
                    let trimmed = moderationUserIdInput.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty { moderationTarget = trimmed }
                }
                .disabled(moderationUserIdInput.trimmingCharacters(in: .whitespaces).isEmpty)
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("対象ユーザーの ID を入力すると編集履歴の確認・BAN・一括取り消しができます。")
            }
            .sheet(item: Binding(
                get: { moderationTarget.map { ModerationUserID(id: $0) } },
                set: { moderationTarget = $0?.id }
            )) { target in
                NavigationStack {
                    UserModerationView(userId: target.id)
                }
            }
            .alert(Text(L10n.Settings.accountDeleteConfirmTitle), isPresented: $showDeleteAccountConfirm) {
                Button(role: .destructive) {
                    Task { await performAccountDeletion() }
                } label: { Text(L10n.Settings.accountDeleteConfirm) }
                Button(role: .cancel) {} label: { Text(L10n.Settings.actionCancel) }
            } message: {
                Text(L10n.Settings.accountDeleteConfirmMessage)
            }
            .alert(Text(L10n.Settings.accountDeleteErrorTitle), isPresented: Binding(
                get: { deleteAccountErrorMessage != nil },
                set: { if !$0 { deleteAccountErrorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk, role: .cancel) { deleteAccountErrorMessage = nil }
            } message: {
                Text(deleteAccountErrorMessage ?? "")
            }
            .alert(Text(L10n.Settings.backupCodeErrorTitle), isPresented: Binding(
                get: { transferCodeErrorMessage != nil },
                set: { if !$0 { transferCodeErrorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk, role: .cancel) { transferCodeErrorMessage = nil }
            } message: {
                Text(transferCodeErrorMessage ?? "")
            }
            .alert(Text(L10n.Settings.backupExportErrorTitle), isPresented: Binding(
                get: { exportErrorMessage != nil },
                set: { if !$0 { exportErrorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk, role: .cancel) { exportErrorMessage = nil }
            } message: {
                Text(exportErrorMessage ?? "")
            }
            .fileImporter(isPresented: $showBackupFileImporter, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    Task { await importBackupFromFile(url) }
                case .failure(let error):
                    importErrorMessage = error.localizedDescription
                }
            }
            .alert(
                Text(importErrorMessage != nil ? L10n.Settings.backupRestoreFailedTitle : L10n.Settings.backupRestoreDoneTitle),
                isPresented: Binding(
                    get: { importResultMessage != nil || importErrorMessage != nil },
                    set: { if !$0 { importResultMessage = nil; importErrorMessage = nil } }
                )
            ) {
                Button(L10n.Common.actionOk, role: .cancel) {
                    importResultMessage = nil
                    importErrorMessage = nil
                }
            } message: {
                Text(importErrorMessage ?? importResultMessage ?? "")
            }
            .overlay {
                if importer.isImporting {
                    VStack(spacing: DS.sp5) {
                        ProgressView(value: importer.progress)
                            .frame(width: 200)
                        Text(display: importer.statusMessage)
                            .font(.imasCaption)
                    }
                    .padding(DS.sp7)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .trackScreen("my_page")
    }

    // MARK: - Account Section

    @ViewBuilder
    private var accountSection: some View {
        Section {
            if AuthService.shared.isSignedIn {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.imasTitle2)
                        .foregroundStyle(DS.ink2)
                    VStack(alignment: .leading, spacing: DS.sp1) {
                        HStack(spacing: 6) {
                            Text(display: AuthService.shared.userName.map(DisplayText.verbatim)
                                ?? .key(L10n.Settings.accountUserFallback))
                                .font(.imasHeadline)
                            Button {
                                AppAnalytics.tap("my_page.edit_name")
                                editingName = AuthService.shared.userName ?? ""
                                showEditName = true
                            } label: {
                                Image(systemName: "pencil.circle")
                                    .font(.imasCallout)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel(L10n.Settings.accountEditNameA11y)
                        }
                        if let email = AuthService.shared.userEmail {
                            Text(email)
                                .font(.imasCaption)
                                .foregroundStyle(DS.ink2)
                        }
                        #if DEBUG
                        if let uid = AuthService.shared.userId {
                            Text("ID: \(uid)")
                                .font(.imasCaption2.monospaced())
                                .foregroundStyle(DS.ink3)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .textSelection(.enabled)
                        }
                        #endif
                    }
                }
                Button(role: .destructive) {
                    AppAnalytics.tap("my_page.logout")
                    AuthService.shared.signOut()
                } label: { Text(L10n.Settings.accountSignOut) }
                Button(role: .destructive) {
                    AppAnalytics.tap("my_page.delete_account")
                    showDeleteAccountConfirm = true
                } label: { Text(L10n.Settings.accountDeleteButton) }
                .disabled(isDeletingAccount)
            } else {
                VStack(spacing: DS.sp3) {
                    Text(L10n.Settings.accountSignInPrompt)
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                    AppleSignInButton()
                }
                .padding(.vertical, DS.sp2)
            }
        } header: {
            Text(L10n.Settings.accountHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Admin Section (モデレーション)

    /// admin 専用。確定契約 §1 で公開フィードは編集者匿名性のため editorId を返さないため、
    /// admin は対象ユーザー ID を直接指定してモデレーション画面 (履歴確認 / BAN / 一括取り消し) を開く。
    @ViewBuilder
    private var adminSection: some View {
        Section {
            Button {
                AppAnalytics.tap("my_page.admin_moderation")
                moderationUserIdInput = ""
                showModerationPrompt = true
            } label: {
                Label("ユーザーをモデレーション", systemImage: "person.badge.shield.checkmark")
            }
            NavigationLink {
                PlayabilityCheckView()
            } label: {
                Label("再生可否チェック (Apple Music)", systemImage: "music.note.list")
            }
        } header: {
            Text("管理者")
        } footer: {
            Text("対象ユーザー ID を指定して編集履歴の確認・BAN・一括取り消し、 全曲のサブスク再生可否チェック等を行います。")
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Settings Section

    @ViewBuilder
    private var settingsSection: some View {
        helpSection
        generalSettingsSection
        collectionSettingsSection
        masterySection
        notificationSection
        themeSection
        imageImportSection
    }

    @ViewBuilder
    private var helpSection: some View {
        Section {
            Button {
                AppAnalytics.tap("my_page.open_help")
                showHelp = true
            } label: {
                Label(L10n.Settings.helpOpen, systemImage: "questionmark.circle.fill")
            }
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    @ViewBuilder
    private var generalSettingsSection: some View {
        Section {
            Picker(selection: $defaultBrandId) {
                Text(L10n.Settings.defaultBrandAll).tag("")
                ForEach(vm.brands) { brand in
                    Text(brand.shortName).tag(brand.id)
                }
            } label: {
                Text(L10n.Settings.defaultBrandLabel)
            }
            VStack(alignment: .leading, spacing: DS.sp2) {
                Text(L10n.Settings.textScaleLabel)
                ImasSegmented(labels: textScaleLabels, selection: textScaleIndex)
            }
            // プレビュー: 選んだサイズで実際の見え方を即確認できる (設定画面のラベル自体は
            // システム既定フォントなので変化しないため、ここで反映後の文字を見せる)。
            VStack(alignment: .leading, spacing: 3) {
                Text(L10n.Settings.textScalePreview)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
                Text("Timeless Shooting Star")
                    .font(.imasScaled(16, weight: .semibold))
                    .foregroundStyle(DS.ink)
                // i18n-ignore(sample): 文字サイズの見本 (ユニット名と、コアが出す歌唱者の語を模したセトリの行)
                Text("ストレイライト ・ 全員")
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
            }
            .padding(.vertical, DS.sp1)

            // 選択肢はコアが出す (順も文言もアプリ 1 本)。
            Picker(selection: $performerNameRaw) {
                ForEach(PerformerNamePref.options, id: \.raw) { option in
                    Text(option.label).tag(option.raw)
                }
            } label: {
                Text(L10n.Settings.performerNameLabel)
            }
            // 設定値で見え方が変わるサンプル。声優ライブの 1 人分をそのまま出す。
            Text(
                Self.performerNameSample
                    .displayName(PerformerNamePref.mode(performerNameRaw), isCharacterLive: false)
                    .joined
            )
                .font(.imasCaption)
                .foregroundStyle(DS.ink2)

            Toggle(isOn: $abbreviateEventNames) { Text(L10n.Settings.eventNameAbbreviateLabel) }
            // 設定値で見え方が変わるサンプル。ON なら作品名プレフィックスを省く。
            Text(eventDisplayName("THE IDOLM@STER SHINY COLORS 3rdLIVE TOUR"))
                .font(.imasCaption)
                .foregroundStyle(DS.ink2)

            // 曲一覧の「この絞り込みでイントロドン」導線の表示/非表示 (×で隠した後ここで戻せる)。
            Toggle(isOn: Binding(
                get: { !introDonBarHidden },
                set: { introDonBarHidden = !$0 }
            )) {
                Text(L10n.Settings.introdonBarLabel)
            }
        } header: {
            Text(L10n.Settings.generalHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    @ViewBuilder
    private var collectionSettingsSection: some View {
        Section {
            Toggle(isOn: $includeStreamInCollection) { Text(L10n.Settings.collectionIncludeStream) }
                .onChange(of: includeStreamInCollection) {
                    UserMarkService.shared.refreshAutoCollected()
                }
        } header: {
            Text(L10n.Settings.collectionHeader)
        } footer: {
            Text(L10n.Settings.collectionFooter)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    /// 習熟度の段階。ラベルの好みは人によるので、既定 (聞いた / 覚えた / 完璧) を
    /// 触れるようにしてある。保存は序数なのでラベルを直しても記録は壊れない。
    @ViewBuilder
    private var masterySection: some View {
        Section {
            NavigationLink {
                MasteryScaleSettingsView()
            } label: {
                HStack {
                    Label(L10n.Settings.masteryLink, systemImage: "chart.bar")
                    Spacer()
                    Text(UserMarkService.shared.scale.labels.joined(separator: " / "))
                        .font(.imasCaption).foregroundStyle(DS.ink3).lineLimit(1)
                }
            }
        } header: {
            Text(L10n.Settings.masteryHeader)
        } footer: {
            Text(L10n.Settings.masteryFooter)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    @ViewBuilder
    private var themeSection: some View {
        Section {
            Toggle(isOn: $useOshiColor) { Text(L10n.Settings.themeUseOshiColor) }
            if useOshiColor {
                if vm.pickIdols.isEmpty {
                    Text(L10n.Settings.themeNoPicks)
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                } else {
                    Picker(selection: $themeOshiIdolId) {
                        ForEach(vm.pickIdols) { idol in
                            HStack(spacing: DS.sp3) {
                                Circle()
                                    .fill(Color(hexString: idol.color))
                                    .frame(width: 14, height: 14)
                                Text(idol.name)
                            }
                            .tag(idol.id)
                        }
                    } label: {
                        Text(L10n.Settings.themePickerLabel)
                    }
                }
            }
        } header: {
            Text(L10n.Settings.themeHeader)
        } footer: {
            Text(L10n.Settings.themeFooter)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
        .onChange(of: useOshiColor) { syncThemeColor() }
        .onChange(of: themeOshiIdolId) { syncThemeColor() }
    }

    @ViewBuilder
    private var imageImportSection: some View {
        Section {
            Button {
                AppAnalytics.tap("my_page.image_import")
                showImageImport = true
            } label: {
                Label(L10n.Settings.imageImportIdolButton, systemImage: "photo.on.rectangle.angled")
            }
            if let url = vm.idolTemplateURL {
                ShareLink(item: url) {
                    Label(L10n.Settings.imageImportIdolTemplate, systemImage: "square.and.arrow.down")
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                }
            }

            Button {
                AppAnalytics.tap("my_page.brand_image_import")
                showBrandImageImport = true
            } label: {
                Label(L10n.Settings.imageImportBrandButton, systemImage: "tag")
            }
            if let url = vm.brandTemplateURL {
                ShareLink(item: url) {
                    Label(L10n.Settings.imageImportBrandTemplate, systemImage: "square.and.arrow.down")
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                }
            }

            Button {
                AppAnalytics.tap("my_page.unit_image_import")
                showUnitImageImport = true
            } label: {
                Label(L10n.Settings.imageImportUnitButton, systemImage: "person.3")
            }
            if let url = vm.unitTemplateURL {
                ShareLink(item: url) {
                    Label(L10n.Settings.imageImportUnitTemplate, systemImage: "square.and.arrow.down")
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                }
            }

            if importer.importedCount > 0 || importer.failedCount > 0 {
                Text(display: importer.statusMessage)
                    .font(.imasCaption)
                    .foregroundStyle(DS.ink2)
            }
            if !importer.failures.isEmpty {
                DisclosureGroup {
                    ForEach(importer.failures) { f in
                        VStack(alignment: .leading, spacing: 1) {
                            Text(f.key).font(.imasCaption).bold()
                            Text(display: f.reason).font(.imasCaption2).foregroundStyle(DS.ink2)
                        }
                    }
                } label: {
                    Label(L10n.Settings.imageImportFailures(count: importer.failures.count), systemImage: "exclamationmark.triangle")
                        .font(.imasCaption)
                        .foregroundStyle(DS.warning)
                }
            }

            Button(role: .destructive) {
                AppAnalytics.tap("my_page.clear_images")
                Task { await importer.clearAllImages() }
            } label: {
                Label(L10n.Settings.imageImportClear, systemImage: "trash")
            }
        } header: {
            Text(L10n.Settings.imageImportHeader)
        } footer: {
            Text(L10n.Settings.imageImportFooter)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Notification Section

    private func rescheduleNotifications(turnedOn: Bool) {
        Task {
            await NotificationService.shared.rescheduleAll(
                database: database, reason: turnedOn ? .refresh : .settingTurnedOff)
        }
    }

    @ViewBuilder
    private var notificationSection: some View {
        Section {
            switch notifAuthStatus {
            case .notDetermined, .denied:
                Button {
                    AppAnalytics.tap("my_page.request_notification")
                    Task {
                        let granted = await NotificationService.shared.requestAuthorization()
                        if granted {
                            notifAuthStatus = .authorized
                            Task { await NotificationService.shared.rescheduleAll(database: database) }
                        } else {
                            notifAuthStatus = .denied
                        }
                    }
                } label: {
                    Label(L10n.Settings.notificationsRequest, systemImage: "bell.badge")
                }
                if notifAuthStatus == .denied {
                    Text(L10n.Settings.notificationsDenied)
                        .font(.imasCaption)
                        .foregroundStyle(DS.warning)
                }
            default:
                Toggle(isOn: $notifOshiBirthday) { Text(L10n.Settings.notificationsOshiBirthday) }
                    .onChange(of: notifOshiBirthday) { _, isOn in rescheduleNotifications(turnedOn: isOn) }
                Toggle(isOn: $notifLiveWeek) { Text(L10n.Settings.notificationsLiveWeek) }
                    .onChange(of: notifLiveWeek) { _, isOn in rescheduleNotifications(turnedOn: isOn) }
                Toggle(isOn: $notifTicket) { Text(L10n.Settings.notificationsTicket) }
                    .onChange(of: notifTicket) { _, isOn in rescheduleNotifications(turnedOn: isOn) }
                Toggle(isOn: $notifMonday) { Text(L10n.Settings.notificationsMonday) }
                    .onChange(of: notifMonday) { _, isOn in rescheduleNotifications(turnedOn: isOn) }
            }
        } header: {
            Text(L10n.Settings.notificationsHeader)
        } footer: {
            if notifAuthStatus == .authorized || notifAuthStatus == .provisional {
                Text(L10n.Settings.notificationsFooter)
            }
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
        .task {
            notifAuthStatus = await NotificationService.shared.authorizationStatus()
        }
    }

    // MARK: - Data Sync Section

    @ViewBuilder
    private var dataSyncSection: some View {
        Section {
            HStack {
                Image(systemName: syncStateIcon)
                    .foregroundStyle(syncStateColor)
                Text(syncEngine.state.description)
                    .font(.imasSubhead)
                if isSyncing {
                    Spacer()
                    ProgressView()
                }
            }

            Button {
                AppAnalytics.tap("my_page.sync_incremental")
                Task { await syncEngine.performIncrementalSync(database: database) }
            } label: {
                Label(L10n.Settings.syncIncremental, systemImage: "arrow.triangle.2.circlepath")
            }
            .disabled(isSyncing)

            Button {
                AppAnalytics.tap("my_page.sync_full")
                Task { await syncEngine.performFullSync(database: database) }
            } label: {
                Label(L10n.Settings.syncFull, systemImage: "arrow.clockwise.icloud")
            }
            .disabled(isSyncing)

            #if DEBUG
            LabeledContent("スキーマバージョン", value: vm.schemaVersion)
            LabeledContent("データバージョン", value: vm.dataVersion)

            if let summary = syncEngine.lastSyncSummary {
                DisclosureGroup {
                    LabeledContent("modifiedSince", value: summary.modifiedSinceLabel)
                        .font(.imasCaption2)
                    LabeledContent("総取得件数", value: "\(summary.totalFetched)")
                        .font(.imasCaption2)
                    if summary.fetchedByType.isEmpty {
                        Text("(各 RecordType 0 件)")
                            .font(.imasCaption2)
                            .foregroundStyle(DS.ink2)
                    } else {
                        ForEach(summary.fetchedByType.sorted { $0.key < $1.key }, id: \.key) { (k, v) in
                            LabeledContent(k, value: "\(v)")
                                .font(.imasCaption2)
                        }
                    }
                } label: {
                    Label("直近同期サマリ", systemImage: "list.bullet.rectangle")
                        .font(.imasCaption)
                }
            }
            #endif

            #if DEBUG
            DisclosureGroup {
                LabeledContent("reseed 結果", value: AppDatabase.lastReseedStatus)
                    .font(.imasCaption2)
                    .textSelection(.enabled)
                    .contextMenu {
                        Button {
                            UIPasteboard.general.string = AppDatabase.lastReseedStatus
                        } label: {
                            Label("コピー", systemImage: "doc.on.doc")
                        }
                    }
            } label: {
                Label("診断", systemImage: "stethoscope")
                    .font(.imasCaption)
            }
            #endif
        } header: {
            Text(L10n.Settings.syncHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Data Backup Section

    @ViewBuilder
    private var dataBackupSection: some View {
        Section {
            if let code = transferCode {
                VStack(alignment: .leading, spacing: DS.sp2) {
                    Text(code)
                        .font(.imasScaled(28, weight: .bold, design: .monospaced))
                        .textSelection(.enabled)
                    if let expiresAt = transferCodeExpiresAt {
                        // 期限の日時は表示言語で書式を作り、文言には書式済みの文字列を渡す
                        let expires = expiresAt.formatted(
                            Date.FormatStyle(date: .abbreviated, time: .shortened,
                                             locale: DisplayLocale.current.formattingLocale))
                        Text(L10n.Settings.backupCodeExpiry(expires: expires))
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink2)
                    }
                    Button {
                        UIPasteboard.general.string = code
                    } label: {
                        Label(L10n.Settings.actionCopy, systemImage: "doc.on.doc")
                    }
                    .font(.imasCaption)
                }
                .padding(.vertical, DS.sp2)
            }
            Button {
                AppAnalytics.tap("my_page.backup_create_transfer_code")
                Task { await createTransferCode() }
            } label: {
                if isCreatingTransferCode {
                    HStack {
                        ProgressView()
                        Text(L10n.Settings.backupCodeIssuing)
                    }
                } else {
                    Label(L10n.Settings.backupCodeIssue, systemImage: "arrow.up.doc")
                }
            }
            .disabled(isCreatingTransferCode)

            HStack {
                // LocalizedStringResource を受ける TextField(_:text:) は iOS 26 からなので、prompt: 付きの版 (iOS 16) を使う
                TextField(L10n.Settings.backupCodeField, text: $importCodeInput, prompt: nil)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                Button {
                    AppAnalytics.tap("my_page.backup_import_by_code")
                    Task { await importByCode() }
                } label: {
                    if isImportingByCode {
                        ProgressView()
                    } else {
                        Text(L10n.Settings.backupCodeRestore)
                    }
                }
                .disabled(isImportingByCode || importCodeInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            Button {
                AppAnalytics.tap("my_page.backup_export_file")
                exportBackupFile()
            } label: {
                Label(L10n.Settings.backupFileSave, systemImage: "square.and.arrow.up")
            }
            if let url = backupFileURL {
                ShareLink(item: url) {
                    Label(L10n.Settings.backupFileShare, systemImage: "square.and.arrow.up.on.square")
                        .font(.imasCaption)
                        .foregroundStyle(DS.ink2)
                }
            }

            Button {
                AppAnalytics.tap("my_page.backup_import_file")
                showBackupFileImporter = true
            } label: {
                Label(L10n.Settings.backupFileRestore, systemImage: "square.and.arrow.down")
            }

            Toggle(isOn: $restoreDeviceIdOnImport) { Text(L10n.Settings.backupRestoreDeviceId) }
        } header: {
            Text(L10n.Settings.backupHeader)
        } footer: {
            Text(L10n.Settings.backupFooter)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Data Stats Section

    @ViewBuilder
    private func dataStatsSection(_ stats: DatabaseStats) -> some View {
        // LabeledContent には LocalizedStringResource の入口が無いので、文字列にしてから渡す
        Section {
            LabeledContent(String(localized: L10n.Settings.statsSongsLabel),
                           value: String(localized: L10n.Settings.statsSongsValue(count: stats.songCount)))
            LabeledContent(String(localized: L10n.Settings.statsIdolsLabel),
                           value: String(localized: L10n.Settings.statsIdolsValue(count: stats.idolCount)))
            LabeledContent(String(localized: L10n.Settings.statsEventsLabel),
                           value: String(localized: L10n.Settings.statsEventsValue(count: stats.eventCount)))
            LabeledContent(String(localized: L10n.Settings.statsShowsLabel),
                           value: String(localized: L10n.Settings.statsShowsValue(count: stats.showCount)))
        } header: {
            Text(L10n.Settings.statsHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - App Info Section

    @ViewBuilder
    private var appInfoSection: some View {
        Section {
            NavigationLink {
                AboutView()
            } label: {
                Text(L10n.Settings.appInfoAbout)
            }
            NavigationLink {
                PrivacyPolicyView()
            } label: {
                Text(L10n.Settings.appInfoPrivacy)
            }
            NavigationLink {
                TermsOfServiceView()
            } label: {
                Text(L10n.Settings.appInfoTerms)
            }
            NavigationLink {
                SupportView()
            } label: {
                Text(L10n.Settings.appInfoSupport)
            }
        } header: {
            Text(L10n.Settings.appInfoHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Credits Section

    @ViewBuilder
    private var creditsSection: some View {
        Section {
            Text(L10n.Settings.creditsUnofficial)
                .font(.imasCaption)
                .foregroundStyle(DS.ink2)
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                LabeledContent(String(localized: L10n.Settings.creditsAppVersion), value: version)
            }
        } header: {
            Text(L10n.Settings.creditsHeader)
        }
        .listRowBackground(DS.surface)
        .listRowSeparatorTint(DS.sep)
    }

    // MARK: - Sync State UI Helpers

    private var syncStateIcon: String {
        switch syncEngine.state {
        case .idle: return "icloud"
        case .syncing: return "icloud.and.arrow.down"
        case .completed: return "checkmark.icloud"
        case .error:
            return syncEngine.state == .requiresFullResync
                ? "arrow.triangle.2.circlepath.icloud"
                : "exclamationmark.icloud"
        }
    }

    private var syncStateColor: Color {
        switch syncEngine.state {
        case .idle: return DS.ink2
        case .syncing: return DS.sys
        case .completed: return DS.success
        case .error:
            return syncEngine.state == .requiresFullResync ? .orange : .red
        }
    }

    @MainActor
    private func saveDisplayName() async {
        // サーバ側は JS String.trim() (改行や各種 Unicode 空白も除去) で正規化するため、
        // クライアントも .whitespacesAndNewlines に揃える。.whitespaces だと末尾改行が残り、
        // ローカルキャッシュ userName とサーバ保存値が乖離する。
        let trimmed = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isSavingName = true
        defer { isSavingName = false }
        do {
            try await AuthService.shared.updateDisplayName(trimmed)
        } catch {
            // レート制限 (429) は「失敗」というより日次上限なので、表示名専用の文言に差し替える。
            // グローバルな APIClientError.rateLimited 文言は他エンドポイントと共有なので触らない。
            if case APIClientError.rateLimited = error {
                nameErrorMessage = .key(L10n.Settings.accountEditNameErrorRateLimited)
            } else {
                nameErrorMessage = .verbatim(error.localizedDescription)
            }
        }
    }

    @MainActor
    private func performAccountDeletion() async {
        isDeletingAccount = true
        defer { isDeletingAccount = false }
        do {
            try await AuthService.shared.deleteAccount()
        } catch {
            deleteAccountErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Backup / Transfer Code

    private func createTransferCode() async {
        isCreatingTransferCode = true
        defer { isCreatingTransferCode = false }
        do {
            let json = try BackupExportImportService.buildEnvelopeJSON(database: database)
            let (code, expiresAt) = try await BackupTransferClient.createTransferCode(payloadJSON: json)
            transferCode = code
            transferCodeExpiresAt = expiresAt
        } catch {
            transferCodeErrorMessage = error.localizedDescription
        }
    }

    private func importByCode() async {
        let code = importCodeInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !code.isEmpty else { return }
        isImportingByCode = true
        defer { isImportingByCode = false }
        do {
            let json = try await BackupTransferClient.fetchTransferCode(code)
            applyBackupImport(json: json)
            importCodeInput = ""
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }

    private func exportBackupFile() {
        do {
            backupFileURL = try BackupExportImportService.exportToFile(database: database)
        } catch {
            exportErrorMessage = error.localizedDescription
        }
    }

    private func importBackupFromFile(_ url: URL) async {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        do {
            let json = try String(contentsOf: url, encoding: .utf8)
            applyBackupImport(json: json)
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }

    /// 引き継ぎコード復元・ファイル復元の共通処理。結果/エラーをアラート用の State に反映する。
    private func applyBackupImport(json: String) {
        do {
            let result = try BackupExportImportService.importEnvelopeJSON(
                json, database: database, restoreDeviceId: restoreDeviceIdOnImport
            )
            importResultMessage = backupImportSummary(
                addedMarks: result.addedMarks,
                addedVotes: result.addedVotes,
                addedPersonalTags: result.addedPersonalTags,
                addedExpenses: result.addedExpenses,
                skippedMarks: result.skippedMarks,
                deviceIdRestored: result.deviceIdRestored
            )
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }

    // MARK: - Data Loading

    private func loadAll() async {
        await vm.load()
        syncThemeColor()
    }

    /// 担当テーマ色を現在の選択から再計算し、ContentView 参照用 hex を更新する。
    /// 解決規則は `resolveOshiTheme` (Domain/UseCases) 側でテスト済み。
    private func syncThemeColor() {
        let resolved = resolveOshiTheme(
            isEnabled: useOshiColor,
            currentIdolId: themeOshiIdolId,
            picks: vm.pickIdols
        )
        if let idolId = resolved.idolId {
            themeOshiIdolId = idolId
        }
        themeOshiColorHex = resolved.colorHex
    }
}

// MARK: - ModerationUserID

/// `.sheet(item:)` 駆動用の userId ラッパ (admin モデレーション画面を開く)。
private struct ModerationUserID: Identifiable {
    let id: String
}
