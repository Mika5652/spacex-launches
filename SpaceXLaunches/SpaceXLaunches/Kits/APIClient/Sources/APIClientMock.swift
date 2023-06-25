import Foundation

public struct APIClientMock: APIClientType {
    private let dataToDecode: () throws -> Data

    public init(dataToDecode: @escaping () throws -> Data) {
        self.dataToDecode = dataToDecode
    }

    public func listData<T: Decodable>(from url: URL, using decoder: JSONDecoder) async throws -> [T] {
        try decoder.decode([T].self, from: dataToDecode())
    }
}
