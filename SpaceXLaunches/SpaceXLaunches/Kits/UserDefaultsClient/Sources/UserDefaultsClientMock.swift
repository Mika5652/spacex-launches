import Foundation

public final class UserDefaultsClientMock: UserDefaultsClientType {
    public private(set) var objects: [String: Any]

    public init(objects: [String : Any] = [:]) {
        self.objects = objects
    }

    public func set(_ value: Any?, forKey key: String) {
        objects[key] = value
    }

    public func object(forKey key: String) -> Any? {
        objects[key]
    }
}
