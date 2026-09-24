import os
import SwiftUI

struct FilteredEventsView: View {
    @Environment(AppDatabase.self) private var database
    let criterion: EventFilterCriterion
    /// 共有 NavigationStack の path へ push するクロージャ (兄弟 Filtered*View と同様)。
    let navigate: (DetailDestination) -> Void

    @State private var eventsWithDate: [EventWithDate] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ImasLoadingState()
            } else if eventsWithDate.isEmpty {
                ImasEmptyState(
                    systemImage: "music.mic",
                    title: String(localized: L10n.Filtered.eventsEmpty)
                )
            } else {
                List {
                    Section {
                        ForEach(eventsWithDate) { ew in
                            Button { navigate(.event(ew.event)) } label: {
                                EventNameRow(
                                    event: ew.event,
                                    // 種別は生の内部値ではなくラベルで出す。未分類なら日付だけ。
                                    subtitle: [
                                        EventType(rawValue: ew.event.eventType)?.displayLabel,
                                        ew.firstDate,
                                    ].compactMap { $0 }.joined(separator: "  ")
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(DS.surface)
                            .listRowSeparatorTint(DS.sep)
                        }
                    } header: {
                        Text(L10n.Filtered.eventsCount(count: eventsWithDate.count))
                            .font(.imasCaption)
                            .foregroundStyle(DS.ink2)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(DS.bg)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadEvents() }
        .trackScreen("filtered_events")
    }

    /// 画面タイトル。`criterion.navigationTitle` は遷移先の識別子 (DetailSheet の id) にも使うので、
    /// 表示だけここでカタログの文言に写す。
    private var title: LocalizedStringResource {
        switch criterion {
        case .brand(_, let label): return L10n.Filtered.eventsTitleBrand(brand: label)
        case .year(let year): return L10n.Filtered.eventsTitleYear(year: year)
        }
    }

    private func loadEvents() async {
        isLoading = true
        do {
            eventsWithDate = try await AppContainer.shared.eventReading.eventsWithDate(criterion: criterion, includeEmpty: true)
        } catch {
            Logger.database.error("load_failed filtered_events: \(error.localizedDescription)")
            eventsWithDate = []
        }
        isLoading = false
    }
}
