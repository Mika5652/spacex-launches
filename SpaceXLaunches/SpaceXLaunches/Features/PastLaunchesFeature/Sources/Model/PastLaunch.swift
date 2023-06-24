import Foundation

struct PastLaunch: Identifiable, Decodable {
    let id: String
    let dateUtc: Date
    let name: String
    let smallImageUrl: String

    private enum RootCodingKeys: String, CodingKey {
        case id
        case dateUtc = "date_utc"
        case name
        case links
    }

    private enum LinksCodingKeys: String, CodingKey {
        case patch
    }

    private enum PatchCodingKeys: String, CodingKey {
        case small
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let linksContainer = try rootContainer.nestedContainer(keyedBy: LinksCodingKeys.self, forKey: .links)
        let patchContainer = try linksContainer.nestedContainer(keyedBy: PatchCodingKeys.self, forKey: .patch)

        id = try rootContainer.decode(String.self, forKey: .id)
        dateUtc = try rootContainer.decode(String.self, forKey: .dateUtc).toDate
        name = try rootContainer.decode(String.self, forKey: .name)
        smallImageUrl = try patchContainer.decode(String.self, forKey: .small)
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
