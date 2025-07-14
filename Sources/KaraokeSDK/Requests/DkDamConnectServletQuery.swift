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
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
        ]
    }
}

public struct DkDamConnectServletRequest {
    let qrCode: String
    let deviceId: String
    let cdmNo: String

    init(qrCode: String) {
        self.init(qrCode: qrCode, deviceId: "", cdmNo: "")
    }

    init(qrCode: String, deviceId: String, cdmNo: String) {
        self.qrCode = qrCode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
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
