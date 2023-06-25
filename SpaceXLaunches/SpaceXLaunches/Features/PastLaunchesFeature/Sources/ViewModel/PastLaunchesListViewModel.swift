import Foundation
import SharedModels

public class PastLaunchesListViewModel {
    enum SortType: String, CaseIterable {
        case alphabetically = "Alphabetically"
        case dateDesc = "Most recent"
        case dateAsc = "Oldest"
    }

    private(set) var items: [PastLaunch]
    private let useCase: PastLaunchesUseCaseType

    var onInitialLoad: (() -> Void)?
    var onSortingChange: (() -> Void)?

    init(
        items: [PastLaunch] = [],
        useCase: PastLaunchesUseCaseType
    ) {
        self.items = items
        self.useCase = useCase
    }

    var navigationTitle: String {
        "Past Launches"
    }

    var sortTypes: [SortType] {
        SortType.allCases
    }

    func onViewDidLoad() {
        Task {
            items = try await useCase.getItems()
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
}

public extension PastLaunchesListViewModel {
    static let live = PastLaunchesListViewModel(
        useCase: PastLaunchesUseCaseLive.live
    )
}
