//
//  DkDamConnectServletQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class DkDamConnectServletQuery: RequestType {
    public typealias ResponseType = DkDamConnectServletResponse

    public let path: String = "dkdenmoku/DkDamConnectServlet"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(params: DkDamConnectServletRequest) {
        parameters = [
            "QRcode": params.qrCode,
        ]
    }
}

public struct DkDamConnectServletRequest {
    public let qrCode: String

    public init(qrCode: String) {
        self.qrCode = qrCode
    }

    public init(qrCode: QRCode) {
        self.qrCode = qrCode.code
    }
}

public struct DkDamConnectServletResponse: Decodable, Sendable {
    public let qrCode: String
    public let cdmNo: String
    public let deviceId: String
    public let deviceNm: String
//    @LosslessValue
//    public private(set) var lastSendTerm: Int
    public let osVer: String
//    @LosslessValue
//    public private(set) var remoconFlg: Int
    public let result: DkDamResult

    public enum CodingKeys: String, CodingKey {
        case qrCode = "QRcode"
        case cdmNo
        case deviceId
        case deviceNm
        case osVer
        case result
    }
}
