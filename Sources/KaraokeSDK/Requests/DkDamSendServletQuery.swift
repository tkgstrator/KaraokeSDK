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
            "reqNo": params.requestNo,
            "myKey": params.myKey,
            "interrupt": params.interrupt ? 1 : 0,
        ]
    }
}

public struct DkDamSendServletRequest {
    let requestNo: String
    let interrupt: Bool
    let myKey: Int
    let option: DkDamSendQueryOption

    public init(requestNo: String, interrupt: Bool = false, myKey: Int = 0, option: DkDamSendQueryOption = .init()) {
        self.requestNo = requestNo.replacingOccurrences(of: "-", with: "")
        self.interrupt = interrupt
        self.myKey = myKey
        self.option = option
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
