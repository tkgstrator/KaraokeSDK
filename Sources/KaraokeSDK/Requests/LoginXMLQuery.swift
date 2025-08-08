//
//  LoginXMLQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/16.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation
import XMLCoder

public typealias LoginXMLRequest = DkDamDAMTomoLoginServletRequest

public final class LoginXMLQuery: RequestType {
    public typealias ResponseType = LoginXMLResponse

    public let baseURL = URL(unsafeString: "https://www.clubdam.com") // Use the correct base URL for your API
//        .init(unsafeString: "https://www.clubdam.com")
    public let path: String = "app/damtomo/auth/LoginXML.do"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?
    public let decoder: DataDecoder = XMLDecoder()
    public let loginRequired: Bool = false

    public init(params: LoginXMLRequest) {
        parameters = [
            "procKbn": 1,
            "loginId": params.damtomoId,
            "password": params.password,
        ]
    }
}

public struct LoginXMLResponse: Decodable, Sendable {
    public let cdmNo: String
    public let damtomoId: String
}
