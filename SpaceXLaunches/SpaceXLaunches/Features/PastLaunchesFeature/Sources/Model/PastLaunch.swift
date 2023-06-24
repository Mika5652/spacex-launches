import Foundation

struct PastLaunch: Identifiable, Decodable, Hashable {
    let id: String
    let dateUtc: Date
    let name: String

    private enum RootCodingKeys: String, CodingKey {
        case id
        case dateUtc = "date_utc"
        case name
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)

        id = try rootContainer.decode(String.self, forKey: .id)
        dateUtc = try rootContainer.decode(String.self, forKey: .dateUtc).toDate
        name = try rootContainer.decode(String.self, forKey: .name)
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
