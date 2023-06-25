import Foundation

public struct APIClientMock: APIClientType {
    private let dataToDecode: () async throws -> Data

    public init(dataToDecode: @escaping () async throws -> Data) {
        self.dataToDecode = dataToDecode
    }

    public func listData<T: Decodable>(from url: URL, using decoder: JSONDecoder) async throws -> [T] {
        try await decoder.decode([T].self, from: dataToDecode())
    }
}
