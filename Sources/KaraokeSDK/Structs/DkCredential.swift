//
//  DkCredential.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation
import Alamofire

public class DkCredential: AuthenticationCredential, Codable, @unchecked Sendable {
    // 筐体と連携しようとしたら存在するプロパティ
    // 連携はログインされていなくても実行可能
    public var qrCode: String
    // ログインを試みたなら入力されているプロパティ
    public var loginId: String
    public var password: String
    // ある種固定値でも良いプロパティ
    public let deviceId: String
    public let compId: Int
    public let compAuthKey: String
    public let dmkAccessKey: String
    // ログイン成功したならあるプロパティ
    public var authToken: String
    public var cdmNo: String
    public var damtomoId: String
    // プロトコルに準拠するためのプロパティ
    public let expiresIn: Date
    
    public var requiresRefresh: Bool {
        expiresIn <= .init()
    }
    
    init() {
        self.qrCode = ""
        self.loginId = ""
        self.password = ""
        self.deviceId = DkCredential.deviceId
        self.compId = 1
        self.compAuthKey = "2/Qb9R@8s*"
        self.dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
        self.authToken = ""
        self.cdmNo = ""
        self.damtomoId = ""
        self.expiresIn = .init(timeIntervalSinceNow: 60 * 60 * 6)
    }
    
    @discardableResult
    func update(_ response: LoginByDamtomoMemberIdResponse) -> DkCredential {
        self.authToken = response.data.authToken
        self.damtomoId = response.data.damtomoId
        return self
    }
    
    @discardableResult
    func update(_ request: LoginByDamtomoMemberIdRequest) -> DkCredential {
        self.loginId = request.loginId
        self.password = request.password
        return self
    }
    
    @discardableResult
    func update(_ response: DkDamConnectServletResponse) -> DkCredential {
        self.qrCode = response.qrCode
        return self
    }

    public static var deviceId: String {
#if os(iOS)
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
#elseif os(macOS)
        let uuid = UUID().uuidString
#endif
        return uuid.data(using: .utf8)!.base64EncodedString()
    }
}
