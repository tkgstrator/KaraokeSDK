//
//  KaraokeSDK.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation
@preconcurrency
import KeychainAccess
import SwiftUI
@preconcurrency
import XMLCoder

@MainActor
public final class DKClient: ObservableObject {
    public static let `default`: DKClient = .init()
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let keychain: Keychain = .init(server: "https://denmokuapp.clubdam.com", protocolType: .https)

    @Published
    public private(set) var credential: DkCredential = .init()

    @Published
    public private(set) var code: DkCode = .init()

    public var isLogin: Bool {
        !credential.loginId.isEmpty || !credential.password.isEmpty
    }

    public var isDisabled: Bool {
        credential.loginId.isEmpty && credential.password.isEmpty
    }

    private init() {
        Logger.configure()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.httpMaximumConnectionsPerHost = 1
        if let credential: DkCredential = try? keychain.get(DkCredential.self, forKey: "dmk-credential") {
            self.credential = credential
            Logger.debug("Loaded credential from keychain: \(credential)")
        }
        if let code: DkCode = try? keychain.get(DkCode.self, forKey: "dmk-code") {
            self.code = code
            Logger.debug("Loaded code from keychain: \(code)")
        }
    }

    /// ログアウト処理
    /// クレデンシャルを削除し、初期化する
    public func logout() {
        try? keychain.set(DkCredential(), forKey: "dmk-credential")
        credential = .init()
    }

    /// DAMと連携するメソッド
    /// クレデンシャルは不要
    /// - Parameter code: QRコード
    /// - Returns: 連携結果
    @discardableResult
    public func connect(code: DkCode) async throws -> DkDamConnectServletResponse {
        let response = try await request(DkDamConnectServletQuery(params: .init(code: code)))
        try keychain.set(DkCode(rawValue: response.qrCode), forKey: "dmk-code")
        return response
    }

    /// ログイン処理
    /// クレデンシャルは不要
    /// 未ログイン状態ではクレデンシャルは常に切れていない、判定なのでリフレッシュが走ることがない
    /// - Parameter params: IDとパスワード
    /// - Returns: ログイン結果
    func loginXML(params: DkDamDAMTomoLoginServletRequest) async throws -> LoginXMLResponse {
        let url: URL = .init(string: "https://www.clubdam.com/app/damtomo/auth/LoginXML.do")!
        let parameters: [String: String] = [
            "procKbn": "1",
            "loginId": params.damtomoId,
            "password": params.password,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        let request: URLRequest = try URLEncoding.default.encode(URLRequest(url: url, method: HTTPMethod.post, headers: headers), with: parameters)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response: HTTPURLResponse = response as? HTTPURLResponse,
              let headers: [String: String] = response.allHeaderFields as? [String: String]
        else {
            throw AFError.responseValidationFailed(reason: .dataFileNil)
        }
        if response.statusCode != 200 {
            throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.statusCode))
        }
        let cookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url).filter { ["scr_cdm", "scr_dt"].contains($0.name) }
        guard let cdmNo: String = cookies.first(where: { $0.name == "scr_cdm" })?.value.base64DecodedString,
              let damtomoId: String = cookies.first(where: { $0.name == "scr_dt" })?.value.base64DecodedString
        else {
            throw AFError.responseValidationFailed(reason: .dataFileNil)
        }
        return .init(cdmNo: cdmNo, damtomoId: damtomoId)
    }

    /// ログイン処理
    /// クレデンシャルは不要
    /// 未ログイン状態ではクレデンシャルは常に切れていない、判定なのでリフレッシュが走ることがない
    /// - Parameter params: IDとパスワード
    /// - Returns: ログイン結果
    @discardableResult
    public func login(_ params: DkDamDAMTomoLoginServletRequest) async throws {
        do {
            let params = try await (
                request(DkDamDAMTomoLoginServletQuery(params: params)),
                request(LoginByDamtomoMemberIdQuery(params: params)),
                loginXML(params: params)
            )
            // 認証情報を設定
            try keychain.set(credential.update(params: params), forKey: "dmk-credential")
        } catch {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .DKRequestFailedWithError, object: error)
            }
            Logger.error("Request failed with error: \(error)")
            throw error
        }
    }

    @discardableResult
    public func request<T: RequestType>(_ convertible: sending T) async throws -> T.ResponseType where T.ResponseType: Decodable, T.ResponseType: Sendable {
        do {
            let interceptor: AuthenticationInterceptor<DKClient> = .init(authenticator: self, credential: convertible.loginRequired ? credential : .init())
            let data: Data = try await session.request(convertible, interceptor: interceptor)
                .cURLDescription(calling: { request in
                    Logger.debug("cURL Request: \(request)")
                })
                .validateWith()
                .serializingData(automaticallyCancelling: true)
                .value
            do {
                return try decoder.decode(T.ResponseType.self, from: data)
            } catch {
                if let parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    Logger.error("Decoding error occurred with parameters: \(parameters) with \(error)")
                }
                throw error
            }
        } catch {
            Logger.error("Request failed with error: \(error)")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .DKRequestFailedWithError, object: error)
            }
            throw error
        }
    }
}

extension DKClient: Authenticator {
    public typealias Credential = DkCredential

    /// 認証情報（DkCredential）をURLRequestに適用します。主にリクエストヘッダーにアクセストークンなどを追加します
    /// - Parameters:
    ///   - credential: <#credential description#>
    ///   - urlRequest: <#urlRequest description#>
    public nonisolated func apply(_ credential: DkCredential, to urlRequest: inout URLRequest) {
        urlRequest.merging(credential)
    }

    /// 認証情報が期限切れなどで無効になった場合に、新しい認証情報を取得して更新します。非同期で新しいクレデンシャルを取得し、コールバックで返します
    /// - Parameters:
    ///   - credential: <#credential description#>
    ///   - session: <#session description#>
    ///   - completion: <#completion description#>
    public nonisolated func refresh(_ credential: DkCredential, for session: Alamofire.Session, completion: @escaping @Sendable (Swift.Result<DkCredential, any Error>) -> Void) {
        Task(priority: .high, operation: {
            do {
                try await login(.init(damtomoId: credential.loginId, password: credential.password))
                if let newValue = try? await keychain.get(DkCredential.self, forKey: "dmk-credential") {
                    Logger.debug("Refreshed credential: \(newValue)")
                    completion(.success(newValue))
                }
            } catch {
                Logger.error("Failed to refresh credential: \(error)")
                completion(.failure(error))
            }
        })
    }

    /// 指定したリクエストが、与えられた認証情報で認証済みかどうかを判定します。ヘッダーの値が一致しているかを確認します
    /// - Parameters:
    ///   - urlRequest: <#urlRequest description#>
    ///   - credential: <#credential description#>
    /// - Returns: <#description#>
    public nonisolated func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: DkCredential) -> Bool {
        urlRequest.value(forHTTPHeaderField: "dmk-access-key") == credential.dmkAccessKey && urlRequest.value(forHTTPHeaderField: "compAuthKey") == credential.compAuthKey
    }

    /// リクエストが認証エラー（例: 401 Unauthorized）で失敗したかどうかを判定します。主にリフレッシュ処理のトリガーとして使います
    /// - Parameters:
    ///   - urlRequest: <#urlRequest description#>
    ///   - response: <#response description#>
    ///   - error: <#error description#>
    /// - Returns: <#description#>
    public nonisolated func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        response.statusCode == 401
    }
}
