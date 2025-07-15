//
//  DkCredential.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct DkCredential: AuthenticationCredential, Codable {
    // ユーザー情報
    public var loginId: String
    public var password: String
    // 現在取ってこれる値ではないが、一応保存
    public var cdmNo: String
    public var damtomoId: String
    // 変動する値だが、ユーザーに見せる情報ではない
    var authToken: String
    // 固定値
    var deviceId: String
    let compId: Int
    let compAuthKey: String
    let dmkAccessKey: String
    // 最終更新時間
    var expiresIn: Date

    /// リフレッシュが必要かどうか
    /// ログインID,パスワード,認証トークなが未設定の場合にはリフレッシュは不要とする
    public var requiresRefresh: Bool {
        loginId.isEmpty && password.isEmpty && authToken.isEmpty ? false : expiresIn <= Date()
    }

    /// 初期化
    @MainActor
    init() {
        loginId = ""
        password = ""
        deviceId = UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!.base64EncodedString()
        cdmNo = ""
        damtomoId = ""
        authToken = ""
        compId = 1
        compAuthKey = "2/Qb9R@8s*"
        dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
        // 多分一時間くらい切れないので
        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
    }

    typealias DkCredentialUpdateParams = (DkDamDAMTomoLoginServletResponse, LoginByDamtomoMemberIdResponse)

    @MainActor
    mutating func update(params: DkCredentialUpdateParams) -> DkCredential {
        loginId = params.0.damtomoId
        password = params.0.password
        deviceId = params.0.deviceId
        authToken = params.1.data.authToken
        damtomoId = params.1.data.damtomoId
        cdmNo = params.0.cdmNo
        // 有効期限を延長
        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
        return self
    }
}

// public struct DkCredential: AuthenticationCredential, Codable, @unchecked Sendable {
//    // 筐体と連携しようとしたら存在するプロパティ
//    // 連携はログインされていなくても実行可能
//    public var qrCode: QRCode?
//    // ログインを試みたなら入力されているプロパティ
//    public var loginId: String
//    public var password: String
//    // ある種固定値でも良いプロパティ
//    public let deviceId: String
//    public let compId: Int
//    public let compAuthKey: String
//    public let dmkAccessKey: String
//    // ログイン成功したならあるプロパティ
//    public var authToken: String
//    public var cdmNo: String
//    public var damtomoId: String
//    // プロトコルに準拠するためのプロパティ
//    public var expiresIn: Date
//
//    // 未設定の場合にはログイン状態ではないので有効期限を無視してリフレッシュが不要とする
//    // NOTE: QRCodeの有効期限も必要だった......
//    public var requiresRefresh: Bool {
//        loginId.isEmpty && password.isEmpty && authToken.isEmpty ? false : expiresIn <= .init()
//    }
//
//    init() {
//        qrCode = nil
//        loginId = ""
//        password = ""
//        deviceId = DkCredential.deviceId
//        compId = 1
//        compAuthKey = "2/Qb9R@8s*"
//        dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
//        authToken = ""
//        cdmNo = ""
//        damtomoId = ""
//        expiresIn = .init(timeIntervalSinceNow: 60 * 60 * 6)
//    }
//
//    @discardableResult
//    mutating func update(_ response: LoginByDamtomoMemberIdResponse) -> DkCredential {
//        authToken = response.data.authToken
//        damtomoId = response.data.damtomoId
//        return self
//    }
//
//    @discardableResult
//    mutating func update(_ request: LoginByDamtomoMemberIdRequest) -> DkCredential {
//        loginId = request.loginId
//        password = request.password
//        return self
//    }
//
//    @discardableResult
//    mutating func update(_ response: DkDamConnectServletResponse) -> DkCredential {
//        qrCode = .init(code: response.qrCode)
//        return self
//    }
//
//    public static var deviceId: String {
////        #if os(iOS)
////        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
////        #elseif os(macOS)
////        let uuid = UUID().uuidString
////        #endif
//        UUID().uuidString.data(using: .utf8)!.base64EncodedString()
//    }
// }
