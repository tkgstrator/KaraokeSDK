//
//  DkDamTomoLoginServletQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/16.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class DkDamDAMTomoLoginServletQuery: RequestType {
    public typealias ResponseType = DkDamDAMTomoLoginServletResponse

    public let path: String = "dkdenmoku/DkDamDAMTomoLoginServlet"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(params: DkDamDAMTomoLoginServletRequest) {
        parameters = [
            "damtomoId": params.damtomoId,
            "password": params.password,
        ]
    }
}

public struct DkDamDAMTomoLoginServletRequest {
    let damtomoId: String
    let password: String

    public init(damtomoId: String, password: String) {
        self.damtomoId = damtomoId
        self.password = password
    }
}

public struct DkDamDAMTomoLoginServletResponse: Decodable, Sendable {
    public let damtomoId: String
    public let deviceId: String
    public let cdmNo: String
    public let password: String
}
