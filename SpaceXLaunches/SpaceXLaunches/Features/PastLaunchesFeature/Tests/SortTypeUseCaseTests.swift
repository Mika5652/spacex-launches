@testable import PastLaunchesFeature
import UserDefaultsClient
import XCTest

final class SortTypeUseCaseTests: XCTestCase {
    func test_initialSortType_shouldReturnDefault() {
        let sut = SortTypeUseCase(
            userDefaultsClient: UserDefaultsClientMock()
        )

        XCTAssertEqual(sut.sortTypes, [.alphabetically, .dateDesc, .dateAsc])
        XCTAssertEqual(sut.selectedSortType, .alphabetically)
    }

    func test_selectSortType_shouldUpdateUserDefaults() {
        let userDefaultsClient = UserDefaultsClientMock()
        let sut = SortTypeUseCase(userDefaultsClient: userDefaultsClient)

        XCTAssertEqual(sut.selectedSortType, .alphabetically)
        XCTAssertTrue(userDefaultsClient.objects.isEmpty)

        sut.selectSort(type: .dateAsc)
        XCTAssertEqual(sut.selectedSortType, .dateAsc)
        XCTAssertEqual(userDefaultsClient.objects["sortTypeKey"] as? String, "Oldest")

        sut.selectSort(type: .dateDesc)
        XCTAssertEqual(sut.selectedSortType, .dateDesc)
        XCTAssertEqual(userDefaultsClient.objects["sortTypeKey"] as? String, "Most recent")
    }

    func test_selectedSortType_shouldReturnDefault_whenWrongValueIsSaved() {
        let userDefaultsClient = UserDefaultsClientMock(
            objects: ["sortTypeKey": "Wrong sort type"]
        )
        let sut = SortTypeUseCase(userDefaultsClient: userDefaultsClient)
        
        XCTAssertEqual(sut.selectedSortType, .alphabetically)
    }
}
