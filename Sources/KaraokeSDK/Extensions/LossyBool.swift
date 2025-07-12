//
//  LossyBool.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

@propertyWrapper
public struct LossyBoolValue: Decodable {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

public extension LossyBoolValue {
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
        throw DecodingError.typeMismatch(Bool.self, .init(codingPath: container.codingPath, debugDescription: "Expected to decode `Bool` but found a different type instead."))
    }
}
