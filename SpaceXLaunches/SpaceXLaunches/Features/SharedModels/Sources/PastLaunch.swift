import Foundation

public struct PastLaunch: Identifiable, Codable, Hashable {
    public let id: String
    public let dateUtc: Date
    public let name: String
    public let launchSuccessStatus: String?
    public let details: String?
    public let links: Links?

    private enum CodingKeys: String, CodingKey {
        case id
        case dateUtc = "date_utc"
        case name
        case launchSuccessStatus = "success"
        case details
        case links
    }

    public init(
        id: String,
        dateUtc: Date,
        name: String,
        launchSuccessStatus: String?,
        details: String?,
        links: Links?
    ) {
        self.id = id
        self.dateUtc = dateUtc
        self.name = name
        self.launchSuccessStatus = launchSuccessStatus
        self.details = details
        self.links = links
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        dateUtc = try container.decode(String.self, forKey: .dateUtc).toDate
        name = try container.decode(String.self, forKey: .name)

        let launchSuccess = try container.decodeIfPresent(Bool.self, forKey: .launchSuccessStatus)
        launchSuccessStatus = launchSuccess.map { $0 ? "Successful" : "Failed" }

        details = try container.decodeIfPresent(String.self, forKey: .details)

        let links = try container.decode(Links.self, forKey: .links)
        let nolinksAvailable = [links.presskit, links.webcast, links.article, links.wikipedia].allSatisfy { $0 == nil }
        self.links = nolinksAvailable ? nil : links
    }

    public struct Links: Codable, Hashable {
        public let presskit: URL?
        public let webcast: URL?
        public let article: URL?
        public let wikipedia: URL?
    }
}

private extension DateFormatter {
    static var withFullFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
}

private extension String {
    var toDate: Date {
        let formatter = DateFormatter.withFullFormat
        return formatter.date(from: self) ?? .now
    }
}

public extension PastLaunch {
    static let mock = Self(
        id: "1",
        dateUtc: .now,
        name: "Starlink",
        launchSuccessStatus: "Successful",
        details: "Description about launch",
        links: .mock
    )

    static let jsonMock =
    """
    [
        {
            "links": {
                "presskit": "https://www.nasa.gov/pdf/694166main_SpaceXCRS-1PressKit.pdf",
                "webcast": "https://www.youtube.com/watch?v=-Vk3hiV_zXU",
                "article": "https://www.nasa.gov/mission_pages/station/main/spacex-crs1-target.html",
                "wikipedia": "https://en.wikipedia.org/wiki/SpaceX_CRS-1"
            },
            "success": true,
            "details": "CRS-1 successful, but the secondary payload was inserted into abnormally low orbit and lost due to Falcon 9 boost stage engine failure, ISS visiting vehicle safety rules, and the primary payload owner's contractual right to decline a second ignition of the second stage under some conditions.",
            "name": "CRS-1",
            "date_utc": "2012-10-08T00:35:00.000Z",
            "id": "5eb87ce0ffd86e000604b332"
        }
    ]
    """
}

public extension PastLaunch.Links {
    static let mock = Self(
        presskit: URL(string: "http://www.spacex.com"),
        webcast: URL(string: "https://youtu.be"),
        article: URL(string: "http://www.spacex.com"),
        wikipedia: URL(string: "https://en.wikipedia.org")
    )
}
