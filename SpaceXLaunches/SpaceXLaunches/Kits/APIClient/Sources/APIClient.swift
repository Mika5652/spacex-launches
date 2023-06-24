import Foundation

protocol APIClientType {
    func data<T: Decodable>(from url: URL) async throws -> T
}

public struct APIClient: APIClientType {
    func data<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

public struct APIClientMock: APIClientType {
    private struct MockDecodable: Decodable { }

    func data<T: Decodable>(from url: URL) async throws -> T {
        MockDecodable() as! T
    }
}
