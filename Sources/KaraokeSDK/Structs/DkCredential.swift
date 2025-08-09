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
    public var code: DkCode
    // MNSの有効期限
    var expiresIn: Date

    /// リフレッシュが必要かどうか
    /// ログインID,パスワード,認証トークが未設定の場合にはリフレッシュは不要とする
    public var requiresRefresh: Bool {
        mns.authToken.isEmpty && mns.damtomoId.isEmpty ? false : expiresIn <= Date()
    }

    @MainActor
    public struct MNS: Codable {
        let authToken: String
        public let damtomoId: String

        init(authToken: String = "", damtomoId: String = "") {
            self.authToken = authToken
            self.damtomoId = damtomoId
        }
    }

    ///
    @MainActor
    public struct SCR: Codable {
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
    public struct DTM: Codable {
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
        expiresIn = Date(timeIntervalSince1970: 0)
        code = .init()
    }

    /// ログイン処理で使う初期化
    /// - Parameters:
    ///   - credential: <#credential description#>
    ///   - params: <#params description#>
    @MainActor
    init(credential: DkCredential, params: LoginByDamtomoMemberIdResponse) {
        loginId = credential.loginId
        password = credential.password
        scr = credential.scr
        dtm = credential.dtm
        mns = .init(authToken: params.data.authToken, damtomoId: params.data.damtomoId)
        compId = credential.compId
        compAuthKey = credential.compAuthKey
        dmkAccessKey = credential.dmkAccessKey
        // 有効期限を延長
        expiresIn = Date(timeIntervalSinceNow: 60 * 60 * 1)
        code = credential.code
    }

    typealias DkCredentialUpdateParams = (DkDamDAMTomoLoginServletResponse, LoginByDamtomoMemberIdResponse, LoginXMLResponse)

    /// リフレッシュした場合に更新する処理
    /// - Parameter params: <#params description#>
    /// - Returns: <#description#>
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

    /// 連携してコードを登録
    /// - Parameter params: <#params description#>
    /// - Returns: <#description#>
    @MainActor
    mutating func update(params: DkDamConnectServletResponse) -> DkCredential {
        if let code: DkCode = .init(rawValue: params.qrCode) {
            self.code = code
        }
        return self
    }

    /// 連携解除して初期化
    /// - Parameter params: <#params description#>
    /// - Returns: <#description#>
    @MainActor
    mutating func update(params: DkDamSeparateServletResponse) -> DkCredential {
        code = .init()
        return self
    }
}
