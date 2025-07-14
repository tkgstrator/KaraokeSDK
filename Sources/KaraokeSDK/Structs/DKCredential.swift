//
//  DKCredential.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation
import Alamofire

public class DKCredential: AuthenticationCredential, Codable {
    // 筐体と連携しようとしたら存在するプロパティ
    // 連携はログインされていなくても実行可能
    public var qrCode: String
    // ログインを試みたなら入力されているプロパティ
    public var loginId: String
    public var password: String
    // ある種固定値でも良いプロパティ
    public let authKey: String
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
        self.authKey = "2/Qb9R@8s*"
        self.dmkAccessKey = "3ZpXW3K8anQvonUX7IMj"
        self.authToken = ""
        self.cdmNo = ""
        self.damtomoId = ""
        self.expiresIn = .init()
    }
    
    func update(_ response: LoginByDamtomoMemberIdResponse) {
        self.authToken = response.data.authToken
        self.damtomoId = response.data.damtomoId
    }
    
    func update(_ request: LoginByDamtomoMemberIdRequest) {
        self.loginId = request.loginId
        self.password = request.password
    }
    
    func update(_ request: DkDamConnectServletRequest) {
        self.qrCode = request.qrCode
    }
}
