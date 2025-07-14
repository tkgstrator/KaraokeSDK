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
            "QRcode": params.QRcode,
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
        ]
    }
}

public struct DkDamConnectServletRequest {
    let QRcode: String
    let deviceId: String
    let cdmNo: String

    init(QRcode: String) {
        self.init(QRcode: QRcode, deviceId: "", cdmNo: "")
    }

    init(QRcode: String, deviceId: String, cdmNo: String) {
        self.QRcode = QRcode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
    }
}

public struct DkDamConnectServletResponse: Decodable, Sendable {
    public let QRcode: String
    public let cdmNo: String
    public let deviceId: String
    public let deviceNm: String
//    @LosslessValue
//    public private(set) var lastSendTerm: Int
    public let osVer: String
//    @LosslessValue
//    public private(set) var remoconFlg: Int
    public let result: DkDamResult
}
