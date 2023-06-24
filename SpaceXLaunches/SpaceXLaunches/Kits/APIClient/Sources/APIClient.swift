import Foundation

public protocol APIClientType {

    /// Retrieves the contents of a URL and delivers the data asynchronously in a value of the type you specify, decoded from a JSON object.
    /// - Parameters:
    ///   - url: The URL to retrieve.
    ///   - decoder: An instance of `JSONDecoder`
    /// - Returns: A value of the specified type
    func data<T: Decodable>(from url: URL, using decoder: JSONDecoder) async throws -> T

    /// Retrieves the contents of a URL and delivers the data asynchronously in a value of the type you specify, decoded from an array of JSON objects.
    /// - Parameters:
    ///   - url: The URL to retrieve.
    ///   - decoder: An instance of `JSONDecoder`
    /// - Returns: An array of values of the specified type
    func listData<T: Decodable>(from url: URL, using decoder: JSONDecoder) async throws -> [T]
}

public extension APIClientType {
    func data<T: Decodable>(from url: URL, using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        try await self.data(from: url, using: decoder)
    }

    func listData<T: Decodable>(from url: URL, using decoder: JSONDecoder = JSONDecoder()) async throws -> [T] {
        try await self.listData(from: url, using: decoder)
    }
}

public struct APIClientLive: APIClientType {
    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func data<T>(from url: URL, using decoder: JSONDecoder) async throws -> T where T : Decodable {
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(T.self, from: data)
    }

    public func listData<T: Decodable>(from url: URL, using decoder: JSONDecoder) async throws -> [T] {
        let (data, _) = try await session.data(from: url)
        return try decoder.decode([T].self, from: data)
    }
}
