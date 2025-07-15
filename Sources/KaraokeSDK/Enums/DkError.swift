//
//  DkError.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation

public struct DkError: Error, Sendable, Identifiable {
    public var id: String { result.rawValue }
    public let result: DkDamResult
}

extension DkError: LocalizedError {
    public var errorDescription: String? {
        switch result {
            case .damConnectOk, .damSeparateOk, .loginOk:
                nil
            default:
                result.rawValue
        }
    }
}
