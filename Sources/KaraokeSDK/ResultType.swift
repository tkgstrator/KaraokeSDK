//
//  ResultType.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Foundation
@preconcurrency
import BetterCodable

public struct ResultType<T, U>: Decodable, Sendable where T: Decodable, T: Sendable, U: Decodable, U: Sendable {
    public let result: Result
    public let data: T
    public let list: [U]
}

public struct Result: Decodable, Sendable {
    @LosslessValue
    private(set) var statusCode: Int
    public let message: String
}
