//
//  DkDamSeparateServletQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class DkDamSeparateServletQuery: RequestType {
    public typealias ResponseType = DkDamSeparateServletResponse

    public let path: String = "dkdenmoku/DkDamSeparateServlet"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(params: DkDamSeparateServletRequest) {
        parameters = [
            "cdmNo": params.cdmNo,
        ]
    }
}

public struct DkDamSeparateServletRequest {
    let cdmNo: String

    init(cdmNo: String = "") {
        self.cdmNo = cdmNo
    }
}

public struct DkDamSeparateServletResponse: Decodable, Sendable {
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
    //    public let ipAdr: String
    //    public let damtomoId: String
    //    public let nickname: String
    //    public let password: String
    //    public let serialNo: String

    public enum CodingKeys: String, CodingKey {
        case qrCode = "QRcode"
        case cdmNo
        case deviceId
        case deviceNm
        case osVer
        case result
    }
}
