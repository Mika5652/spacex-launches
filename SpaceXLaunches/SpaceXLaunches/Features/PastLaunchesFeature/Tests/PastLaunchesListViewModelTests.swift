@testable import PastLaunchesFeature
import SharedModels
import XCTest

final class PastLaunchesListViewModelTests: XCTestCase {
    func test_onViewDidLoad_shouldLoadItems() async throws {
        let exp = expectation(description: "onSortingChange and onSelectSort are called")
        exp.expectedFulfillmentCount = 2

        let expectedItem = PastLaunch.mock()
        let sut = PastLaunchesListViewModel(
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: { [expectedItem] }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy(
                onSelectSort: { type in
                    XCTAssertEqual(type, .dateAsc)
                    exp.fulfill()
                }
            )
        )
        sut.onSortingChange = {
            exp.fulfill()
        }

        XCTAssertEqual(sut.items, [])

        sut.onViewDidLoad()

        await fulfillment(of: [exp])
        XCTAssertEqual(sut.items, [expectedItem])
    }

    func test_onViewDidLoad_shouldReturnError() async throws {
        let exp = expectation(description: "onLoadingError is called")

        let sut = PastLaunchesListViewModel(
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: {
                    struct PastLaunchesError: Error { }
                    throw PastLaunchesError()
                }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy(
                onSelectSort: { _ in XCTFail("Should not be called.") }
            )
        )
        sut.onLoadingError = {
            exp.fulfill()
        }

        sut.onViewDidLoad()

        await fulfillment(of: [exp])
    }

    func test_sortTypes() {
        let sut = PastLaunchesListViewModel(
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: { [.mock()] }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy()
        )

        XCTAssertEqual(sut.sortTypes, [.alphabetically, .dateAsc, .dateDesc])
    }

    func test_handleSortAction() {
        let exp = expectation(description: "onSelectSort and onSortingChange are called")
        exp.expectedFulfillmentCount = 6

        let sut = PastLaunchesListViewModel(
            items: .mock,
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: {
                    XCTFail("Should not be called")
                    return []
                }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy(
                onSelectSort: { _ in
                    exp.fulfill()
                }
            )
        )
        sut.onSortingChange = {
            exp.fulfill()
        }

        XCTAssertEqual(sut.items, .mock)

        sut.handleSortAction(.dateAsc)
        XCTAssertEqual(sut.items, [.ses8, .jason3, .cassiope, .og2Mission1, .dscovr, .asiaSat8])

        sut.handleSortAction(.dateDesc)
        XCTAssertEqual(sut.items, [.ses8, .jason3, .cassiope, .og2Mission1, .dscovr, .asiaSat8].reversed())

        sut.handleSortAction(.alphabetically)
        XCTAssertEqual(sut.items, [.asiaSat8, .cassiope, .dscovr, .jason3, .og2Mission1, .ses8])

        waitForExpectations(timeout: 0.1)
    }

    func test_isTypeSelected() {
        let sortTypeUseCaseSpy = SortTypeUseCaseSpy()
        let sut = PastLaunchesListViewModel(
            items: .mock,
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: {
                    XCTFail("Should not be called")
                    return []
                }
            ),
            sortTypeUseCase: sortTypeUseCaseSpy
        )

        XCTAssertEqual(sortTypeUseCaseSpy.selectedSortType, .dateAsc)
        XCTAssertTrue(sut.isTypeSelected(.dateAsc))
    }

    func test_searchTextDidChange_andThenCancelSearching() {
        let exp = expectation(description: "onSearchChange is called")
        exp.expectedFulfillmentCount = 5

        let sut = PastLaunchesListViewModel(
            items: .mock,
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: {
                    XCTFail("Should not be called")
                    return []
                }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy()
        )
        sut.onSearchChange = {
            exp.fulfill()
        }

        XCTAssertEqual(sut.items, .mock)

        sut.searchTextDidChange("asia")
        XCTAssertEqual(sut.items, [.asiaSat8])

        sut.searchTextDidChange("8")
        XCTAssertEqual(sut.items, [.asiaSat8, .ses8])

        sut.searchTextDidChange("")
        XCTAssertEqual(sut.items, .mock)

        sut.searchTextDidChange("AS")
        XCTAssertEqual(sut.items, [.asiaSat8, .cassiope, .jason3])

        sut.searchBarCancelButtonTapped()
        XCTAssertEqual(sut.items, .mock)

        waitForExpectations(timeout: 0.1)
    }

    func test_tryAgainAlertButtonTapped() async {
        let exp = expectation(description: "onSortingChange and onSelectSort are called")
        exp.expectedFulfillmentCount = 2

        let expectedItem = PastLaunch.mock()
        let sut = PastLaunchesListViewModel(
            pastLaunchesUseCase: PastLaunchesUseCaseSpy(
                onGetItems: { [expectedItem] }
            ),
            sortTypeUseCase: SortTypeUseCaseSpy(
                onSelectSort: { type in
                    XCTAssertEqual(type, .dateAsc)
                    exp.fulfill()
                }
            )
        )
        sut.onSortingChange = {
            exp.fulfill()
        }

        XCTAssertEqual(sut.items, [])

        sut.tryAgainAlertButtonTapped()

        await fulfillment(of: [exp])
        XCTAssertEqual(sut.items, [expectedItem])
    }
}
