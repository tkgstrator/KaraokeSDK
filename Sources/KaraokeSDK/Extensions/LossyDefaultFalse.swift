//
//  LossyDefaultFalse.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

@propertyWrapper
public struct LossyDefaultFalse: Decodable {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

public extension LossyDefaultFalse {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Bool.self) {
            wrappedValue = value
            return
        }
        if let value = try? container.decode(String.self) {
            wrappedValue = !(value == "0" || value == "false")
            return
        }
        wrappedValue = false
    }
}

public extension KeyedDecodingContainer {
    func decode(_ type: LossyDefaultFalse.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> LossyDefaultFalse {
        try decodeIfPresent(LossyDefaultFalse.self, forKey: key) ?? LossyDefaultFalse(wrappedValue: false)
    }
}
