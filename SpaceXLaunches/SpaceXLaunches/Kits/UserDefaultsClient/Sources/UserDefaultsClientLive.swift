import Foundation

public protocol UserDefaultsClientType {

    /// Sets the value of the specified default key.
    /// - Parameters:
    ///   - value: The object to store in the defaults database.
    ///   - key: The key with which to associate the value.
    func set(_ value: Any?, forKey key: String)

    /// Returns the object associated with the specified key.
    /// - Parameter key: A key in the current user‘s defaults database.
    /// - Returns: The object associated with the specified key, or nil if the key was not found.
    func object(forKey key: String) -> Any?
}

public struct UserDefaultsClientLive: UserDefaultsClientType {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func set(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    public func object(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}
