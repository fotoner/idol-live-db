import SwiftUI

/// 参加した公演の座席を記録する 1 行入力シート。
/// 会場ごとに表記がバラバラ (アリーナ / スタンド / 整理番号 等) なので自由テキスト。
struct SeatEditorSheet: View {
    let entity: UserMarkEntity
    let entityId: String
    @Binding var draft: String

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool
    private let markService = UserMarkService.shared

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: L10n.Events.seatEditorPlaceholderIos), text: $draft, axis: .vertical)
                        .lineLimit(1...3)
                        .focused($focused)
                        .scrollContentBackground(.hidden)
                } footer: {
                    Text(L10n.Events.seatEditorFooter)
                        .foregroundStyle(DS.ink2)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)
            }
            .scrollContentBackground(.hidden)
            .background(DS.bg.ignoresSafeArea())
            .navigationTitle(L10n.Events.seatEditorTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        draft = markService.seat(entity: entity, id: entityId) ?? ""
                        dismiss()
                    } label: {
                        Text(L10n.Events.actionCancel)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        AppAnalytics.tap("seat_editor.save")
                        do {
                            try markService.setSeat(entity: entity, id: entityId, text: draft)
                            dismiss()
                        } catch {
                            // 書けなかったら閉じない (入れた座席を捨てずに、もう一度押せるように)。
                            LocalWriteFailure.report(error, action: String(localized: L10n.Events.localWriteSaveSeat))
                        }
                    } label: {
                        Text(L10n.Events.actionSave)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.height(220), .medium])
        .onAppear {
            draft = markService.seat(entity: entity, id: entityId) ?? ""
            focused = true
        }
        .trackScreen("seat_editor")
    }
}
