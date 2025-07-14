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
            "QRcode": params.qrCode,
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
            "remoconCode": params.remoconCode.rawValue,
        ]
    }
}

public struct DkDamRemoconSendServletRequest {
    let qrCode: String
    let deviceId: String
    let cdmNo: String
    let remoconCode: DkDamRemoconCode

    init(qrCode: String, remoconCode: DkDamRemoconCode) {
        self.init(qrCode: qrCode, deviceId: "", cdmNo: "", remoconCode: remoconCode)
    }

    init(qrCode: String, deviceId: String, cdmNo: String, remoconCode: DkDamRemoconCode) {
        self.qrCode = qrCode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
        self.remoconCode = remoconCode
    }
}

public struct DkDamRemoconSendServletResponse: Decodable, Sendable {
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
