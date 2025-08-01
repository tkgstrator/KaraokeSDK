//
//  LoginByDamtomoMemberIdQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public typealias LoginByDamtomoMemberIdRequest = DkDamDAMTomoLoginServletRequest

public final class LoginByDamtomoMemberIdQuery: RequestType {
    public typealias ResponseType = LoginByDamtomoMemberIdResponse

    public let path: String = "minsei/auth/LoginByDamtomoMemberId.api"
    public let method: HTTPMethod = .post
    public let encoding: ParameterEncoding = URLEncoding.httpBody
    public let parameters: Parameters?
    public let loginRequired: Bool = false

    public init(params: LoginByDamtomoMemberIdRequest) {
        parameters = [
            "format": "json",
            "loginId": params.damtomoId,
            "password": params.password,
        ]
    }

    public init(credential: DkCredential) {
        parameters = [
            "format": "json",
            "loginId": credential.loginId,
            "password": credential.password,
        ]
    }
}

public struct LoginByDamtomoMemberIdResponse: Decodable, Sendable {
    public let data: LoginByDamtomoMemberIdData
    public let message: String
    public let status: String
    @LosslessValue
    public private(set) var statusCode: Int
    public let type: String
}

public struct LoginByDamtomoMemberIdData: Decodable, Sendable {
    public let damtomoId: String
    public let authToken: String
}
