@testable import PastLaunchesFeature
import Foundation
import SharedModels

struct PastLaunchesUseCaseSpy: PastLaunchesUseCaseType {
    var onGetItems: () async throws -> [PastLaunch]

    func getItems() async throws -> [PastLaunch] {
        try await onGetItems()
    }
}
