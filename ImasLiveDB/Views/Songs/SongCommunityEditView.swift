import os
import SwiftUI

// MARK: - Sheet 駆動ターゲット (新規 / 既存編集)

/// 参考動画の投稿・編集シートを `.sheet(item:)` で駆動するための識別子。
/// `.create` は新規投稿、`.edit(model)` は既存編集。`Identifiable` 準拠で sheet を出す。
enum SongCommunityEditTarget<Model: Identifiable>: Identifiable where Model.ID == String {
    case create
    case edit(Model)

    var id: String {
        switch self {
        case .create: return "create"
        case .edit(let m): return "edit_\(m.id)"
        }
    }

    var editing: Model? {
        if case .edit(let m) = self { return m }
        return nil
    }
}

// MARK: - SongVideo (参考動画) 編集 / 投稿フォーム
//
// 確定契約 §4: 参考動画 (SongVideo) をオープン編集に復活する。
// 旧 YouTubeReferenceFormView は削除済みなので、EditService 経由の
// 軽量フォームを新設する。ログイン済み全ユーザーが投稿/編集できる (DetailSheet から導線)。
//
// サーバ (master_validators.ts FIELD_RULES) と厳密一致させるフィールド (CKRecordMapper 既存名):
//   SongVideo : songId(required), youtubeUrl(required, YouTube URL), videoTitle(任意 max300),
//               note(任意 max1000)
// recordName 採番はサーバ (create で省略 → ytref_<uuid>)。createdAt はサーバ権威。

/// 参考動画 (YouTube) 投稿 / 編集フォーム。
struct VideoEditView: View {
    let songId: String
    let mode: EditMode<SongVideo>
    var onSaved: () -> Void = {}

    @Environment(AppDatabase.self) private var database
    @Environment(\.dismiss) private var dismiss

    @State private var youtubeUrl: String
    @State private var videoTitle: String
    @State private var note: String
    @State private var isSaving = false
    /// 解決済みの String ではなく文言の値で持ち、alert で文字列にする。
    @State private var errorMessage: LocalizedStringResource?

    /// 下書き保持: バックグラウンド/終了されても新規投稿の入力を失わない (songId 照合で復元)。
    @SceneStorage("draft.songVideo.create") private var draftStore: String = ""

    private static let maxTitle = 300
    private static let maxNote = 1000

    init(songId: String, onSaved: @escaping () -> Void = {}) {
        self.songId = songId
        self.mode = .create
        self.onSaved = onSaved
        _youtubeUrl = State(initialValue: "")
        _videoTitle = State(initialValue: "")
        _note = State(initialValue: "")
    }

    init(video: SongVideo, onSaved: @escaping () -> Void = {}) {
        self.songId = video.songId
        self.mode = .update(original: video)
        self.onSaved = onSaved
        _youtubeUrl = State(initialValue: video.youtubeUrl)
        _videoTitle = State(initialValue: video.videoTitle ?? "")
        _note = State(initialValue: video.note ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("YouTube URL", text: $youtubeUrl)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text(L10n.Edit.videoUrlHeader)
                } footer: {
                    Text(L10n.Edit.videoUrlFooter)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)

                Section {
                    TextField(L10n.Edit.videoFieldTitle, text: $videoTitle, prompt: nil)
                    TextField(L10n.Edit.videoFieldNote, text: $note, prompt: nil, axis: .vertical)
                        .lineLimit(2...6)
                } header: {
                    Text(L10n.Edit.videoNoteHeader)
                } footer: {
                    Text(L10n.Edit.videoNoteFooterIos(length: note.count.formatted(), max: Self.maxNote))
                        .foregroundStyle(note.count > Self.maxNote ? DS.danger : DS.ink2)
                }
                .listRowBackground(DS.surface)
                .listRowSeparatorTint(DS.sep)
            }
            .scrollContentBackground(.hidden)
            .background(DS.bg.ignoresSafeArea())
            .navigationTitle(mode.isCreate ? L10n.Edit.videoTitleCreate : L10n.Edit.videoTitleEdit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { clearDraft(); dismiss() } label: { Text(L10n.Edit.actionCancel) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { AppAnalytics.tap("video_edit.save"); Task { await save() } } label: { Text(L10n.Edit.actionSave) }
                        .disabled(isSaving || !isValid)
                }
            }
            .overlay { if isSaving { SavingOverlay() } }
            .alert(L10n.Edit.formErrorTitle, isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button(L10n.Common.actionOk) {}
            } message: { if let errorMessage { Text(errorMessage) } }
            .trackScreen("video_edit")
        }
        .onAppear { restoreDraft() }
        .onChange(of: youtubeUrl) { persistDraft() }
        .onChange(of: videoTitle) { persistDraft() }
        .onChange(of: note) { persistDraft() }
    }

    // MARK: - Draft 退避 (新規投稿のみ)

    private struct Draft: Codable {
        var songId: String; var youtubeUrl: String; var videoTitle: String; var note: String
    }

    private func persistDraft() {
        guard mode.isCreate else { return }
        let draft = Draft(songId: songId, youtubeUrl: youtubeUrl, videoTitle: videoTitle, note: note)
        if let data = try? JSONEncoder().encode(draft) {
            draftStore = String(decoding: data, as: UTF8.self)
        }
    }

    private func restoreDraft() {
        guard mode.isCreate, !draftStore.isEmpty,
              let data = draftStore.data(using: .utf8),
              let draft = try? JSONDecoder().decode(Draft.self, from: data),
              draft.songId == songId else { return }
        if youtubeUrl.isEmpty { youtubeUrl = draft.youtubeUrl }
        if videoTitle.isEmpty { videoTitle = draft.videoTitle }
        if note.isEmpty { note = draft.note }
    }

    private func clearDraft() { draftStore = "" }

    private var trimmedUrl: String { youtubeUrl.trimmingCharacters(in: .whitespaces) }
    private var trimmedTitle: String { videoTitle.trimmingCharacters(in: .whitespaces) }
    private var trimmedNote: String { note.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var isValid: Bool {
        Self.isYouTubeURL(trimmedUrl)
            && trimmedTitle.count <= Self.maxTitle
            && trimmedNote.count <= Self.maxNote
    }

    /// 投稿してよい YouTube の URL か (判定はコアの `youtube_is_upload_url`)。
    static func isYouTubeURL(_ s: String) -> Bool {
        youtubeIsUploadUrl(url: s)
    }

    private func save() async {
        guard Self.isYouTubeURL(trimmedUrl) else {
            errorMessage = L10n.Edit.videoErrorUrlRequired
            return
        }
        guard trimmedTitle.count <= Self.maxTitle else {
            errorMessage = L10n.Edit.videoErrorTitleTooLong(max: Self.maxTitle)
            return
        }
        guard trimmedNote.count <= Self.maxNote else {
            errorMessage = L10n.Edit.videoErrorNoteTooLong(max: Self.maxNote)
            return
        }

        isSaving = true
        defer { isSaving = false }

        var fields: [String: AnyEncodable] = [
            "songId": AnyEncodable(songId),
            "youtubeUrl": AnyEncodable(trimmedUrl),
        ]
        // update はサーバ側マージ (未送信 = 現状維持)。空にした場合は null 明示送信でクリア。
        fields["videoTitle"] = AnyEncodable.clearable(trimmedTitle, original: mode.original?.videoTitle)
        fields["note"] = AnyEncodable.clearable(trimmedNote, original: mode.original?.note)

        let op = EditService.EditOperation(
            op: mode.isCreate ? .create : .update,
            recordType: "SongVideo",
            recordName: mode.original?.id,
            fields: fields
        )

        do {
            let resp = try await EditService.shared.submit(
                ops: [op],
                // i18n-ignore(storage): 編集履歴に残るサマリ (サーバに送るデータ)。画面の言語で変えない
                summary: mode.isCreate ? "参考動画を追加" : "参考動画を編集"
            )
            let resolvedId = resp.primaryRecordName(fallback: mode.original?.id)
                ?? "ytref_\(UUID().uuidString.lowercased())"
            let saved = SongVideo(
                id: resolvedId,
                songId: songId,
                youtubeUrl: trimmedUrl,
                videoTitle: trimmedTitle.isEmpty ? nil : trimmedTitle,
                note: trimmedNote.isEmpty ? nil : trimmedNote,
                createdAt: mode.original?.createdAt ?? ISO8601DateFormatter.shared.string(from: Date()),
                authorDisplayName: mode.original?.authorDisplayName ?? AuthService.shared.userName
            )
            try await AppContainer.shared.songWriting.upsertSongVideos([saved])
            Logger.database.notice("song_video_\(mode.isCreate ? "created" : "edited", privacy: .public)")
            clearDraft()
            onSaved()
            dismiss()
        } catch {
            errorMessage = friendlyEditError(error)
        }
    }
}

// MARK: - Shared helpers

/// 保存中のフルスクリーンオーバーレイ (SongEditView 等と同じ見た目)。
private struct SavingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView(L10n.Edit.formSaving).padding(DS.sp7)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

/// EditService.submit の throw を利用者向けの短文 (カタログの文言) へ変換する。
private func friendlyEditError(_ error: Error) -> LocalizedStringResource {
    switch error {
    case APIClientError.notAuthorized:
        return L10n.Edit.errorAuthExpired
    case APIClientError.rateLimited:
        return L10n.Edit.errorRateLimited
    default:
        return L10n.Edit.videoErrorSaveFailed(detail: error.localizedDescription)
    }
}
