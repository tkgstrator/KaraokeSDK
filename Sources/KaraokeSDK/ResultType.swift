//
//  ResultType.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Foundation

public struct ResultType<T, U>: Decodable, Sendable where T: Decodable, T: Sendable, U: Decodable, U: Sendable {
    public let result: Result
    public let data: T
    public let list: [U]
}

public struct Result: Decodable, Sendable {
    public let statusCode: String
    public let message: String
}
