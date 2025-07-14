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
            "remoconCode": params.remoconCode.rawValue,
        ]
    }
}

public struct DkDamRemoconSendServletRequest {
    let remoconCode: DkDamRemoconCode
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
