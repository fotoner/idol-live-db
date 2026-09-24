import SwiftUI

struct NoteEditorSheet: View {
    let entity: UserMarkEntity
    let entityId: String
    @Binding var draft: String

    @Environment(\.dismiss) private var dismiss
    private let markService = UserMarkService.shared

    var body: some View {
        NavigationStack {
            TextEditor(text: $draft)
                .padding()
                .navigationTitle(L10n.Events.noteEditorTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            draft = markService.note(entity: entity, id: entityId) ?? ""
                            dismiss()
                        } label: {
                            Text(L10n.Events.actionCancel)
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            AppAnalytics.tap("note_editor.save")
                            let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                            do {
                                try markService.setNote(
                                    entity: entity,
                                    id: entityId,
                                    text: trimmed.isEmpty ? nil : trimmed
                                )
                                dismiss()
                            } catch {
                                // 書けなかったら閉じない (打ったメモを捨てずに、もう一度押せるように)。
                                LocalWriteFailure.report(error, action: String(localized: L10n.Events.localWriteSaveNote))
                            }
                        } label: {
                            Text(L10n.Events.actionSave)
                        }
                        .fontWeight(.semibold)
                    }
                }
        }
        .presentationDetents([.medium, .large])
        .onAppear {
            draft = markService.note(entity: entity, id: entityId) ?? ""
        }
        .trackScreen("note_editor")
    }
}
