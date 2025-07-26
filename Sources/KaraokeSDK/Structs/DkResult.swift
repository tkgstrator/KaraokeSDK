//
//  DkResult.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation
@preconcurrency
import BetterCodable

public enum DkResult {
    public struct DkDenmoku: Error, Decodable, Sendable {
        public let result: DkDamResult
    }

    public struct DkWebSys: Decodable, Sendable {
        public let result: Result

        public struct Result: Error, Decodable, Sendable {
            @LosslessValue
            public private(set) var statusCode: Int
            public let message: String?
            public let detailMessage: String?
        }
    }

    public struct DkMinsei: Error, Decodable, Sendable {
        public let message: String
        public let status: String
        @LosslessValue
        public private(set) var statusCode: Int
        public let type: String
    }
}

public enum DkErrorReason: String, CaseIterable {
    case TOKEN_EXPIRED_ERROR
    case MINSEI_FORBIDDEN_ERROR
}

public struct DkError: Error, LocalizedError, Sendable, Identifiable {
    public var id: String { localizedDescription }
    public let errorDescription: String?
    public let failureReason: String?
    public let recoverySuggestion: String?

    init(_ error: some LocalizedError) {
        errorDescription = error.errorDescription
        failureReason = error.failureReason
        recoverySuggestion = error.recoverySuggestion
    }
}

extension DkResult.DkDenmoku: LocalizedError {
    public var errorDescription: String? {
        nil
    }

    public var failureReason: String? {
        nil
    }

    public var recoverySuggestion: String? {
        nil
    }
}

extension DkResult.DkWebSys.Result: LocalizedError {
    public var errorDescription: String? {
        message
    }

    public var failureReason: String? {
        detailMessage
    }

    public var recoverySuggestion: String? {
        nil
    }
}

extension DkResult.DkMinsei: LocalizedError {
    public var errorDescription: String? {
        switch statusCode {
            case 1_004:
                DkErrorReason.MINSEI_FORBIDDEN_ERROR.rawValue
            case 1_006:
                DkErrorReason.TOKEN_EXPIRED_ERROR.rawValue
            default:
                message
        }
    }

    public var failureReason: String? {
        nil
    }

    public var recoverySuggestion: String? {
        nil
    }
}
