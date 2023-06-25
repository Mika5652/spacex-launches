import Foundation
import UserDefaultsClient

enum SortType: String, CaseIterable {
    case alphabetically = "Alphabetically"
    case dateDesc = "Most recent"
    case dateAsc = "Oldest"
}

protocol SortTypeUseCaseType {
    var sortTypes: [SortType] { get }
    var selectedSortType: SortType { get }
    func selectSort(type: SortType)
}

struct SortTypeUseCase: SortTypeUseCaseType {
    private let sortTypeKey = "sortTypeKey"
    private let userDefaultsClient: UserDefaultsClientType

    init(userDefaultsClient: UserDefaultsClientType) {
        self.userDefaultsClient = userDefaultsClient
    }

    var sortTypes: [SortType] {
        SortType.allCases
    }

    func selectSort(type: SortType) {
        userDefaultsClient.set(type.rawValue, forKey: sortTypeKey)
    }

    var selectedSortType: SortType {
        guard let object = userDefaultsClient.object(forKey: sortTypeKey) as? String else {
            return .alphabetically
        }

        return SortType(rawValue: object) ?? .alphabetically
    }
}

extension SortTypeUseCase {
    static let live = Self(userDefaultsClient: UserDefaultsClientLive())
}
