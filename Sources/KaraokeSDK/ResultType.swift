//
//  ResultType.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Foundation

public struct ResultType<T: Decodable, U: Decodable>: Decodable {
    public let result: Result
    public let data: T
    public let list: [U]
}

public struct Result: Decodable {
    public let statusCode: String
    public let message: String
}
