//
//  DKCredential.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation
import Alamofire

public struct DKCredential: AuthenticationCredential, Codable, Sendable {
    public let authToken: String
    public let damtomoId: String
    public let cdmNo: String
    public let qrCode: String
    public let loginId: String
    public let password: String
    public let authKey: String
    public let dmkAccessKey: String
    public let expiresIn: Date
    
    public var requiresRefresh: Bool {
        expiresIn <= .init()
    }

    init(response: LoginByDamtomoMemberIdResponse) {
        self.authToken = response.data.authToken
        self.damtomoId = response.data.damtomoId
    }
}
