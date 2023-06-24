import APIClient
import Foundation

protocol PastLaunchesUseCaseType {
    func getItems() async throws -> [PastLaunch]
}

struct PastLaunchesUseCaseLive: PastLaunchesUseCaseType {
    private let apiClient: APIClientType

    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    func getItems() async throws -> [PastLaunch] {
        let url = URL(string: "https://api.spacexdata.com/v4/launches/past")!
        return try await apiClient.listData(from: url)
    }
}

extension PastLaunchesUseCaseType where Self == PastLaunchesUseCaseLive {
    static var live: Self {
        Self(apiClient: APIClientLive())
    }
}
