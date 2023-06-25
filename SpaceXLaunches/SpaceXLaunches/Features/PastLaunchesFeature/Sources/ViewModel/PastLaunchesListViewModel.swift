import Foundation
import SharedModels

public class PastLaunchesListViewModel {
    private var allItems: [PastLaunch]
    private(set) var items: [PastLaunch]
    private let pastLaunchesUseCase: PastLaunchesUseCaseType
    private let sortTypeUseCase: SortTypeUseCaseType

    var onLoadingError: (() -> Void)?
    var onSortingChange: (() -> Void)?
    var onSearchChange: (() -> Void)?

    init(
        items: [PastLaunch] = [],
        pastLaunchesUseCase: PastLaunchesUseCaseType,
        sortTypeUseCase: SortTypeUseCaseType
    ) {
        self.items = items
        self.allItems = items
        self.pastLaunchesUseCase = pastLaunchesUseCase
        self.sortTypeUseCase = sortTypeUseCase
    }

    var sortTypes: [SortType] {
        sortTypeUseCase.sortTypes
    }

    func onViewDidLoad() {
        loadData()
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

        sortTypeUseCase.selectSort(type: type)
        onSortingChange?()
    }

    func isTypeSelected(_ type: SortType) -> Bool {
        type == sortTypeUseCase.selectedSortType
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

    func tryAgainAlertButtonTapped() {
        loadData()
    }
}

private extension PastLaunchesListViewModel {
    func loadData() {
        Task {
            do {
                items = try await pastLaunchesUseCase.getItems()
                handleSortAction(sortTypeUseCase.selectedSortType)
                allItems = items
            } catch {
                onLoadingError?()
            }
        }
    }
}

public extension PastLaunchesListViewModel {
    static let live = PastLaunchesListViewModel(
        pastLaunchesUseCase: PastLaunchesUseCase.live,
        sortTypeUseCase: SortTypeUseCase.live
    )

    static let preview = PastLaunchesListViewModel(
        pastLaunchesUseCase: PastLaunchesUseCase.preview,
        sortTypeUseCase: SortTypeUseCase.live
    )

    static let failable = PastLaunchesListViewModel(
        pastLaunchesUseCase: PastLaunchesUseCase.failable,
        sortTypeUseCase: SortTypeUseCase.live
    )
}
