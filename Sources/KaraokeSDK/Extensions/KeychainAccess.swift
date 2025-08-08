//
//  KeychainAccess.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation
import KeychainAccess
import QuantumLeap

extension Keychain {
    func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = try? getData(key) else {
            return nil
        }
        let decoder: JSONDecoder = .init()
        return try decoder.decode(T.self, from: data)
    }

    func set(_ value: some Codable, forKey key: String) throws {
        Logger.debug("Update Credential: \(value)")
        let encoder: JSONEncoder = .init()
        let data = try encoder.encode(value)
        try set(data, key: key)
    }
}
