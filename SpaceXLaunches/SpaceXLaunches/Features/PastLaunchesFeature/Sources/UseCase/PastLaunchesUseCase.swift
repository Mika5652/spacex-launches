import APIClient
import Foundation
import SharedModels

protocol PastLaunchesUseCaseType {
    func getItems() async throws -> [PastLaunch]
}

struct PastLaunchesUseCase: PastLaunchesUseCaseType {
    private let apiClient: APIClientType

    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    func getItems() async throws -> [PastLaunch] {
        let url = URL(string: "https://api.spacexdata.com/v4/launches/past")!
        return try await apiClient.listData(from: url)
    }
}

extension PastLaunchesUseCase {
    static var live: Self {
        Self(apiClient: APIClientLive())
    }

    static var preview: Self {
        return Self(
            apiClient: APIClientMock(
                dataToDecode: {
                    PastLaunch.jsonMock.data(using: .utf8)!
                }
            )
        )
    }

    static var failable: Self {
        Self(
            apiClient: APIClientMock(
                dataToDecode: {
                    try await Task.sleep(for: .seconds(.random(in: 0...2)))
                    struct PastLaunchesError: Error { }
                    throw PastLaunchesError()
                }
            )
        )
    }
}
