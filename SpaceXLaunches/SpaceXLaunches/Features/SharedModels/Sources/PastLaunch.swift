import Foundation

public struct PastLaunch: Identifiable, Decodable, Hashable {
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

    public struct Links: Decodable, Hashable {
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
}

public extension PastLaunch.Links {
    static let mock = Self(
        presskit: URL(string: "http://www.spacex.com"),
        webcast: URL(string: "https://youtu.be"),
        article: URL(string: "http://www.spacex.com"),
        wikipedia: URL(string: "https://en.wikipedia.org")
    )
}
