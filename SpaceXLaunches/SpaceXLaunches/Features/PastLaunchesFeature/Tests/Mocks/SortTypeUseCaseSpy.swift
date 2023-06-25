@testable import PastLaunchesFeature
import Foundation

struct SortTypeUseCaseSpy: SortTypeUseCaseType {
    var onSelectSort: (SortType) -> Void

    var sortTypes: [SortType] {
        [.alphabetically, .dateAsc, .dateDesc]
    }

    var selectedSortType: SortType {
        .dateAsc
    }

    func selectSort(type: SortType) {
        onSelectSort(type)
    }
}
