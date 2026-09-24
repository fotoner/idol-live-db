import os
import SwiftUI

struct FilteredIdolsView: View {
    @Environment(AppDatabase.self) private var database
    let criterion: IdolFilterCriterion
    let navigate: (DetailDestination) -> Void

    @State private var idols: [Idol] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ImasLoadingState()
            } else if idols.isEmpty {
                ImasEmptyState(
                    systemImage: "person.2",
                    title: String(localized: L10n.Filtered.idolsEmpty)
                )
            } else {
                List {
                    Section {
                        ForEach(idols) { idol in
                            Button { navigate(.idol(idol)) } label: {
                                IdolNameRow(idol: idol)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text(L10n.Filtered.idolsCount(count: idols.count))
                            .font(.imasCaption)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadIdols() }
        .trackScreen("filtered_idols")
    }

    /// 画面タイトル。`criterion.navigationTitle` は遷移先の識別子 (DetailSheet の id) にも使うので、
    /// 表示だけここでカタログの文言に写す。星座・出身地・血液型の値はデータ (訳さない)。
    private var title: LocalizedStringResource {
        switch criterion {
        case .brand(_, let label): return L10n.Filtered.idolsTitleBrand(brand: label)
        case .birthMonth(let month): return L10n.Filtered.idolsTitleBirthMonth(month: month)
        case .constellation(let value): return L10n.Filtered.idolsTitleConstellation(constellation: value)
        case .birthPlace(let value): return L10n.Filtered.idolsTitleBirthPlace(place: value)
        case .bloodType(let value): return L10n.Filtered.idolsTitleBloodType(bloodType: value)
        }
    }

    private func loadIdols() async {
        isLoading = true
        do {
            idols = try await AppContainer.shared.idolReading.idols(criterion: criterion)
        } catch {
            Logger.database.error("load_failed filtered_idols: \(error.localizedDescription)")
            idols = []
        }
        isLoading = false
    }
}
