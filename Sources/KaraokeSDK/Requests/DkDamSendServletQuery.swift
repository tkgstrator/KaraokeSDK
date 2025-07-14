//
//  DkDamSendServletQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class DkDamSendServletQuery: RequestType {
    public typealias ResponseType = DkDamSendServletResponse

    public let path: String = "dkdenmoku/DkDamSendServlet"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(params: DkDamSendServletRequest) {
        parameters = [
            "QRcode": params.qrCode,
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
            "reqNo": params.requestNo,
            "myKey": params.myKey,
            "interrupt": params.interrupt,
        ]
    }
}

public struct DkDamSendServletRequest {
    let qrCode: String
    let deviceId: String
    let cdmNo: String
    let requestNo: String
    let interrupt: Bool
    let myKey: Int

    init(qrCode: String, requestNo: String, deviceId: String = "", cdmNo: String = "", interrupt: Bool = false, myKey: Int = 0) {
        self.qrCode = qrCode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
        self.requestNo = requestNo
        self.interrupt = interrupt
        self.myKey = myKey
    }
}

public struct DkDamSendServletResponse: Decodable, Sendable {
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
    // 追加項目
    public let sendDate: String
    public let requestNo: String
    public let entryNo: String
    
    public enum CodingKeys: String, CodingKey {
        case qrCode = "QRcode"
        case cdmNo
        case deviceId
        case deviceNm
        case osVer
        case result
        case sendDate
        case requestNo = "reqNo"
        case entryNo
    }
}
