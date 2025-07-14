//
//  DkDamRemoconSendServletQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class DkDamRemoconSendServletQuery: RequestType {
    public typealias ResponseType = DkDamRemoconSendServletResponse

    public let path: String = "dkdenmoku/DkDamRemoconSendServlet"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(params: DkDamRemoconSendServletRequest) {
        parameters = [
            "QRcode": params.QRcode,
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
            "remoconCode": params.remoconCode.rawValue,
        ]
    }
}

public struct DkDamRemoconSendServletRequest {
    let QRcode: String
    let deviceId: String
    let cdmNo: String
    let remoconCode: DkDamRemoconCode

    init(QRcode: String, remoconCode: DkDamRemoconCode) {
        self.init(QRcode: QRcode, deviceId: "", cdmNo: "", remoconCode: remoconCode)
    }

    init(QRcode: String, deviceId: String, cdmNo: String, remoconCode: DkDamRemoconCode) {
        self.QRcode = QRcode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
        self.remoconCode = remoconCode
    }
}

public struct DkDamRemoconSendServletResponse: Decodable, Sendable {
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
