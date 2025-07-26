//
//  DkError.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation
@preconcurrency
import BetterCodable

public enum DkErrorReason {
    case PARAM_INJUSTICE
    case AUTHENTICATE_ERROR
    case DAM_CONNECT_ERROR
    case DAM_QR_VALID_TIMEOUT
    case DAM_PARING_TIMEOUT
    case REMOCONSEND_TIMEOUT
    case DAM_SEND_ERROR
    case PICTURESEND_ERROR
    case DAM_CONNECT_ERROR_R
}

/// /dkwebsysで発生しがちなエラー
public struct DkErrorResponse: Error, Decodable {
    public let result: DkErrorResult

    public struct DkErrorResult: Decodable, Sendable {
        @LosslessValue
        public private(set) var statusCode: Int
        public let message: String?
        public let detailMessage: String?
    }
}

extension DkErrorResponse: LocalizedError {
    public var reason: String? {
        result.message
    }

    public var failureReason: String? {
        result.detailMessage
    }
}

public struct DkError: Error {
    public let statusCode: Int
}

extension DkError: LocalizedError {
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
