import APIClient
@testable import PastLaunchesFeature
import SharedModels
import XCTest

final class PastLaunchesUseCaseTests: XCTestCase {
    func test_successFlow() async throws {
        let sut = PastLaunchesUseCase(
            apiClient: APIClientMock {
                PastLaunch.jsonMock.data(using: .utf8)!
            }
        )

        let result = try await sut.getItems()
        XCTAssertEqual(result.count, 1)

        let first = try XCTUnwrap(result.first)
        XCTAssertEqual(first.id, "5eb87ce0ffd86e000604b332")
        XCTAssertEqual(first.dateUtc, Date(timeIntervalSince1970: 1349656500))
        XCTAssertEqual(first.name, "CRS-1")
        XCTAssertEqual(
            first.details,
            "CRS-1 successful, but the secondary payload was inserted into abnormally low orbit and lost due to Falcon 9 boost stage engine failure, ISS visiting vehicle safety rules, and the primary payload owner\'s contractual right to decline a second ignition of the second stage under some conditions."
        )
        XCTAssertEqual(first.links?.article, URL(string: "https://www.nasa.gov/mission_pages/station/main/spacex-crs1-target.html")!)
        XCTAssertEqual(first.links?.webcast, URL(string: "https://www.youtube.com/watch?v=-Vk3hiV_zXU")!)
        XCTAssertEqual(first.links?.presskit, URL(string: "https://www.nasa.gov/pdf/694166main_SpaceXCRS-1PressKit.pdf")!)
        XCTAssertEqual(first.links?.wikipedia, URL(string: "https://en.wikipedia.org/wiki/SpaceX_CRS-1")!)
    }

    func test_failureFlow() async throws {
        struct PastLaunchesError: Error { }

        let sut = PastLaunchesUseCase(
            apiClient: APIClientMock {
                throw PastLaunchesError()
            }
        )

        do {
            _ = try await sut.getItems()
            XCTFail("Getting items should fails")
        } catch {
            XCTAssertTrue(error is PastLaunchesError)
        }
    }
}
