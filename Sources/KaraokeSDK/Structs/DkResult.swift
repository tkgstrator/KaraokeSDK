//
//  DkFailure.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation
@preconcurrency
import BetterCodable

public enum DkResult {
    public struct DkDenmoku: Decodable, Sendable {
        public let result: DkDamResult
    }
    
    public struct DkWebSys: Decodable, Sendable {
        public let result: DkResult.Result
    }
    
    public struct Result: Decodable, Sendable {
        @LosslessValue
        public private(set) var statusCode: Int
    }
}
