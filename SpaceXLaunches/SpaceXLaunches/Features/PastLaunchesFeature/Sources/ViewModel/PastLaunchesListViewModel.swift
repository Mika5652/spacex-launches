import Foundation
import SharedModels

public class PastLaunchesListViewModel {
    enum SortType: String, CaseIterable {
        case alphabetically = "Alphabetically"
        case dateDesc = "Most recent"
        case dateAsc = "Oldest"
    }

    private var allItems: [PastLaunch]
    private(set) var items: [PastLaunch]
    private let useCase: PastLaunchesUseCaseType

    var onInitialLoad: (() -> Void)?
    var onSortingChange: (() -> Void)?
    var onSearchChange: (() -> Void)?

    init(
        items: [PastLaunch] = [],
        useCase: PastLaunchesUseCaseType
    ) {
        self.items = items
        self.allItems = items
        self.useCase = useCase
    }

    var navigationTitle: String {
        "Past Launches"
    }

    var searchPlaceholder: String {
        "Search in names..."
    }

    var searchButtonImageName: String {
        "arrow.up.arrow.down"
    }

    var sortMenuTitle: String {
        "Sort list by"
    }

    var sortTypes: [SortType] {
        SortType.allCases
    }

    func onViewDidLoad() {
        Task {
            items = try await useCase.getItems()
            allItems = items
            onInitialLoad?()
        }
    }

    func handleSortAction(_ type: SortType) {
        switch type {
        case .alphabetically:
            items.sort { $0.name < $1.name }
        case .dateDesc:
            items.sort { $0.dateUtc > $1.dateUtc }
        case .dateAsc:
            items.sort { $0.dateUtc < $1.dateUtc }
        }
        onSortingChange?()
    }

    func searchTextDidChange(_ searchText: String) {
        if searchText.isEmpty {
            items = allItems
        } else {
            items = allItems.filter { item in
                item.name.lowercased().contains(searchText.lowercased())
            }
        }
        onSearchChange?()
    }

    func searchBarCancelButtonTapped() {
        items = allItems
        onSearchChange?()
    }
}

public extension PastLaunchesListViewModel {
    static let live = PastLaunchesListViewModel(
        useCase: PastLaunchesUseCaseLive.live
    )
}
