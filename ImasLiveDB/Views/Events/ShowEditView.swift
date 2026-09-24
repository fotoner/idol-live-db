import os
import SwiftUI

/// Show (公演) の基本情報を編集 / 新規作成する。ログイン済みユーザーが利用可能。
/// - `.update`: 既存公演の修正。
/// - `.create`: 新規公演作成。eventId は必須 (必ず既存 Event の詳細画面から作る)。
/// - 保存 → サーバ /edits 経由で CloudKit forceUpdate + ローカル shows テーブル upsert
struct ShowEditView: View {
    let mode: EditMode<Show>
    /// 新規作成時に必須となる親イベント ID。既存編集時は original.eventId を使う。
    private let eventId: String

    @Environment(AppDatabase.self) private var database
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var date: String
    @State private var venue: String
    @State private var venueCity: String
    @State private var startTime: String
    @State private var sortOrder: Int
    @State private var performerType: String
    @State private var isSaving = false
    /// 解決済みの String ではなく文言の値で持ち、alert で文字列にする。
    @State private var errorMessage: LocalizedStringResource?
    @State private var requestSent = false

    /// 既存編集用。
    init(show: Show) {
        self.mode = .update(original: show)
        self.eventId = show.eventId
        _name = State(initialValue: show.name)
        _date = State(initialValue: show.date)
        _venue = State(initialValue: show.venue ?? "")
        _venueCity = State(initialValue: show.venueCity ?? "")
        _startTime = State(initialValue: show.startTime ?? "")
        _sortOrder = State(initialValue: show.sortOrder)
        _performerType = State(initialValue: show.performerType ?? "")
    }

    /// 新規作成用。親イベントと、既存公演数に応じた sortOrder 初期値を受け取る。
    init(newShowEventId: String, suggestedSortOrder: Int = 0) {
        self.mode = .create
        self.eventId = newShowEventId
        _name = State(initialValue: "")
        _date = State(initialValue: "")
        _venue = State(initialValue: "")
        _venueCity = State(initialValue: "")
        _startTime = State(initialValue: "")
        _sortOrder = State(initialValue: suggestedSortOrder)
        _performerType = State(initialValue: "")
    }

    private let performerTypes = ["", "character", "cast", "mixed"]

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.Edit.formSectionBasic) {
                    if let original = mode.original {
                        LabeledContent("ID") { Text(original.id).foregroundStyle(DS.ink2) }
                    }
                    TextField(L10n.Edit.showFieldName, text: $name, prompt: nil)
                    TextField(L10n.Edit.showFieldDate, text: $date, prompt: nil)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    TextField(L10n.Edit.showFieldVenue, text: $venue, prompt: nil)
                    TextField(L10n.Edit.showFieldVenueCity, text: $venueCity, prompt: nil)
                    TextField(L10n.Edit.showFieldStartTime, text: $startTime, prompt: nil)
                    Stepper(L10n.Edit.formSortOrderIos(value: sortOrder), value: $sortOrder, in: 0...999)
                    Picker(L10n.Edit.showFieldPerformerType, selection: $performerType) {
                        ForEach(performerTypes, id: \.self) {
                            // 空 = 未指定。それ以外は保存する値 (character / cast / mixed) をそのまま出す
                            Text(display: $0.isEmpty ? .key(L10n.Edit.formOptionUnspecified) : .verbatim($0)).tag($0)
                        }
                    }
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)
            }
            .scrollContentBackground(.hidden)
            .background(DS.bg.ignoresSafeArea())
            .navigationTitle(mode.isCreate ? L10n.Edit.showTitleCreateIos : L10n.Edit.showTitleEdit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Text(L10n.Edit.actionCancel) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { AppAnalytics.tap("show_edit.save"); Task { await save() } } label: { Text(L10n.Edit.actionSave) }
                        .disabled(isSaving || !canSave)
                }
            }
            .overlay { if isSaving { savingOverlay } }
            .alert(L10n.Edit.formErrorTitle, isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk) {}
            } message: { if let errorMessage { Text(errorMessage) } }
            .editRequestSentAlert(isPresented: $requestSent, onDismiss: { dismiss() })
            .trackScreen("show_edit")
        }
    }

    /// 公演名・日付が揃って初めて保存可能 (新規/編集とも必須)。
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !date.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var savingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView(L10n.Edit.formSaving).padding(DS.sp7)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDate = date.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty, !trimmedDate.isEmpty else {
            errorMessage = L10n.Edit.showErrorRequired
            return
        }
        // 日付フォーマットの軽い前段チェック (サーバ側でも検証されるが UX のため)。
        guard isValidDate(trimmedDate) else {
            errorMessage = L10n.Edit.showErrorDateFormat
            return
        }

        var fields: [String: AnyEncodable] = [
            "eventId": AnyEncodable(eventId),
            "name": AnyEncodable(trimmedName),
            "date": AnyEncodable(trimmedDate),
            "sortOrder": AnyEncodable(sortOrder),
        ]
        // update はサーバ側マージ (未送信 = 現状維持)。空にした場合は null 明示送信でクリア。
        let original = mode.original
        fields["venue"] = AnyEncodable.clearable(venue, original: original?.venue)
        fields["venueCity"] = AnyEncodable.clearable(venueCity, original: original?.venueCity)
        fields["startTime"] = AnyEncodable.clearable(startTime, original: original?.startTime)
        fields["performerType"] = AnyEncodable.clearable(performerType, original: original?.performerType)

        let op = EditService.EditOperation(
            op: mode.isCreate ? .create : .update,
            recordType: "Show",
            recordName: mode.original?.id,
            fields: fields
        )

        do {
            // i18n-ignore(storage): 編集履歴に残るサマリ (サーバに送るデータ)。画面の言語で変えない
            let outcome = try await EditService.shared.submitMaster(ops: [op], summary: mode.isCreate ? "公演追加" : "公演編集")
            guard case .applied(let resp) = outcome else {
                requestSent = true
                return
            }
            // ローカル upsert はサーバ確定 recordName を使う (create はサーバ採番 ID)。
            let resolvedId = resp.primaryRecordName(fallback: mode.original?.id)
            guard let id = resolvedId else {
                errorMessage = L10n.Edit.formErrorIdUnresolved
                return
            }
            let saved = Show(
                id: id,
                eventId: eventId,
                name: trimmedName,
                date: trimmedDate,
                venue: venue.isEmpty ? nil : venue,
                venueCity: venueCity.isEmpty ? nil : venueCity,
                startTime: startTime.isEmpty ? nil : startTime,
                sortOrder: sortOrder,
                performerType: performerType.isEmpty ? nil : performerType
            )
            try await AppContainer.shared.showWriting.upsertShows([saved])
            Logger.database.notice("show_\(mode.isCreate ? "created" : "edited", privacy: .public) id=\(id, privacy: .public)")
            dismiss()
        } catch {
            errorMessage = L10n.Edit.formErrorSaveFailed(detail: error.localizedDescription)
        }
    }

    /// YYYY-MM-DD の最小限の妥当性チェック。
    private func isValidDate(_ s: String) -> Bool {
        let parts = s.split(separator: "-")
        guard parts.count == 3,
              parts[0].count == 4, Int(parts[0]) != nil,
              let m = Int(parts[1]), (1...12).contains(m),
              let d = Int(parts[2]), (1...31).contains(d) else {
            return false
        }
        return true
    }
}
