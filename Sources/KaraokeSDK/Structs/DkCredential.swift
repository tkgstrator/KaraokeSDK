//
//  DkCredential.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
import Foundation

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
    public var expiresIn: Date

    // 未設定の場合にはログイン状態ではないので有効期限を無視してリフレッシュが不要とする
    public var requiresRefresh: Bool {
        loginId.isEmpty && password.isEmpty && authToken.isEmpty ? false : expiresIn <= .init()
    }

    init() {
        qrCode = ""
        loginId = ""
        password = ""
        deviceId = DkCredential.deviceId
        compId = 1
        compAuthKey = "2/Qb9R@8s*"
        dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
        authToken = ""
        cdmNo = ""
        damtomoId = ""
        expiresIn = .init(timeIntervalSinceNow: 60 * 60 * 6)
    }

    @discardableResult
    func update(_ response: LoginByDamtomoMemberIdResponse) -> DkCredential {
        authToken = response.data.authToken
        damtomoId = response.data.damtomoId
        return self
    }

    @discardableResult
    func update(_ request: LoginByDamtomoMemberIdRequest) -> DkCredential {
        loginId = request.loginId
        password = request.password
        return self
    }

    @discardableResult
    func update(_ response: DkDamConnectServletResponse) -> DkCredential {
        qrCode = response.qrCode
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
