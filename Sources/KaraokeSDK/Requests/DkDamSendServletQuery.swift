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
            "QRcode": params.QRcode,
            "deviceId": params.deviceId,
            "cdmNo": params.cdmNo,
            "reqNo": params.requestNo,
            "myKey": params.myKey,
            "interrupt": params.interrupt,
        ]
    }
}

public struct DkDamSendServletRequest {
    let QRcode: String
    let deviceId: String
    let cdmNo: String
    let requestNo: String
    let interrupt: Bool
    let myKey: Int

    init(QRcode: String, requestNo: String, deviceId: String = "", cdmNo: String = "", interrupt: Bool = false, myKey: Int = 0) {
        self.QRcode = QRcode
        self.deviceId = deviceId
        self.cdmNo = cdmNo
        self.requestNo = requestNo
        self.interrupt = interrupt
        self.myKey = myKey
    }
}

public struct DkDamSendServletResponse: Decodable, Sendable {
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
    // 追加項目
    public let sendDate: String
    public let reqNo: String
    public let entryNo: String
}
