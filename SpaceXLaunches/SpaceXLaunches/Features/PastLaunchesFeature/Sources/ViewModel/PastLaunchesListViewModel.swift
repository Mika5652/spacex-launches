import Foundation
import SharedModels

public class PastLaunchesListViewModel {
    private(set) var items: [PastLaunch]
    private let useCase: PastLaunchesUseCaseType

    var onInitialLoad: (() -> Void)?

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

    func onViewDidLoad() {
        Task {
            items = try await useCase.getItems()
            onInitialLoad?()
        }
    }
}

public extension PastLaunchesListViewModel {
    static let live = PastLaunchesListViewModel(
        useCase: PastLaunchesUseCaseLive.live
    )
}
