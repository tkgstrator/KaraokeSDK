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

public struct DkCredential: AuthenticationCredential, Codable, Sendable {
    // ユーザー情報
    public var loginId: String
    public var password: String
    public var scr: SCR
    public var dtm: DTM
    public var mns: MNS
    let compId: Int
    let compAuthKey: String
    let dmkAccessKey: String
    // 最終更新時間
    var expiresIn: Date

    /// リフレッシュが必要かどうか
    /// ログインID,パスワード,認証トークが未設定の場合にはリフレッシュは不要とする
    public var requiresRefresh: Bool {
        mns.authToken.isEmpty && mns.damtomoId.isEmpty ? false : expiresIn <= Date()
    }

    @MainActor
    public struct MNS: Codable, Sendable {
        let authToken: String
        public let damtomoId: String

        init(authToken: String = "", damtomoId: String = "") {
            self.authToken = authToken
            self.damtomoId = damtomoId
        }
    }

    ///
    @MainActor
    public struct SCR: Codable, Sendable {
        public let damtomoId: String
        public let cdmNo: String

        init(damtomoId: String = "", cdmNo: String = "") {
            self.damtomoId = damtomoId
            self.cdmNo = cdmNo
        }
    }

    ///
    /// <#Description#>
    @MainActor
    public struct DTM: Codable, Sendable {
        public let damtomoId: String
        public let cdmNo: String
        let deviceId: String
        let password: String

        /// 初期化
        /// - Parameters:
        ///   - damtomoId: <#damtomoId description#>
        ///   - cdmNo: <#cdmNo description#>
        ///   - deviceId: インストールごとに固有の値を利用する
        ///   - password: <#password description#>
       init(damtomoId: String = "", cdmNo: String = "", deviceId: String = UIDevice.current.identifierForVendor!.uuidString, password: String = "") {
            self.damtomoId = damtomoId
            self.cdmNo = cdmNo
            self.deviceId = deviceId
            self.password = password
        }
    }

    /// 初期化
    @MainActor
    init() {
        loginId = ""
        password = ""
        scr = .init()
        dtm = .init()
        mns = .init()
        compId = 1
        compAuthKey = "2/Qb9R@8s*"
        dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
        // 多分一時間くらい切れないので
        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
    }
    
    @MainActor
    init(credential: DkCredential, params: LoginByDamtomoMemberIdResponse) {
        self.loginId = credential.loginId
        self.password = credential.password
        self.scr = credential.scr
        self.dtm = credential.dtm
        self.mns = .init(authToken: params.data.authToken, damtomoId: params.data.damtomoId)
        self.compId = credential.compId
        self.compAuthKey = credential.compAuthKey
        self.dmkAccessKey = credential.dmkAccessKey
        // 有効期限を延長
        self.expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
    }

    typealias DkCredentialUpdateParams = (DkDamDAMTomoLoginServletResponse, LoginByDamtomoMemberIdResponse, LoginXMLResponse)

    @MainActor
    mutating func update(params: DkCredentialUpdateParams) -> DkCredential {
        loginId = params.0.damtomoId
        password = params.0.password
        scr = .init(damtomoId: params.2.damtomoId, cdmNo: params.2.cdmNo)
        mns = .init(authToken: params.1.data.authToken, damtomoId: params.0.damtomoId)
        dtm = .init(damtomoId: params.0.damtomoId, cdmNo: params.0.cdmNo, deviceId: params.0.deviceId, password: params.0.password)
        // 有効期限を延長
        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
        return self
    }
    
//    @MainActor
//    mutating func update(params: LoginByDamtomoMemberIdResponse) -> DkCredential {
//        mns = .init(authToken: params.data.authToken, damtomoId: params.data.damtomoId)
//        // 有効期限を延長
//        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
//        return self
//    }
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
