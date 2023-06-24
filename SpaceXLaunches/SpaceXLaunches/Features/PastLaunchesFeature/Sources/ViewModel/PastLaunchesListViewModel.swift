import Foundation

public class PastLaunchesListViewModel {
    private var items: [PastLaunch]
    private let useCase: PastLaunchesUseCaseType

    init(
        items: [PastLaunch] = [],
        useCase: PastLaunchesUseCaseType
    ) {
        self.items = items
        self.useCase = useCase
    }

    func onViewDidLoad() async throws {
        items = try await useCase.getItems()
    }
}

public extension PastLaunchesListViewModel {
    static let live = PastLaunchesListViewModel(
        useCase: PastLaunchesUseCaseLive.live
    )
}
