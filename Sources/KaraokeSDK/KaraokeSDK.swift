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
    
    @AppStorage("DK_CONNECTION_QR_CODE")
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
    }

    public func logout() {
        try? keychain.set(DkCredential(), forKey: "dmk-credential")
        credential = .init()
    }
    
    func connect(query: DkDamConnectServletQuery) async throws -> DkDamConnectServletResponse {
        let response = try await request(query)
        return response
    }

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
    /// NOTE: - ログイン処理だけはややこしいので専用のメソッドを用意
    public func login(_ params: DkDamDAMTomoLoginServletRequest) async throws {
        do {
            let interceptor: AuthenticationInterceptor<DKClient> = .init(authenticator: self, credential: credential)
            let params = try await (
                request(DkDamDAMTomoLoginServletQuery(params: params)),
                request(LoginByDamtomoMemberIdQuery(params: params)),
                loginXML(params: params)
            )
            try? keychain.set(credential.update(params: params), forKey: "dmk-credential")
            // 認証情報を設定
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
            let interceptor: AuthenticationInterceptor<DKClient> = .init(authenticator: self, credential: credential)
            return try await session.request(convertible, interceptor: interceptor)
                .cURLDescription(calling: { request in
                    Logger.debug("cURL Request: \(request)")
                })
                .validateWith()
                .serializingDecodable(T.ResponseType.self, automaticallyCancelling: true, decoder: convertible.decoder)
                .value
        } catch {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .DKRequestFailedWithError, object: error)
            }
            Logger.error("Request failed with error: \(error)")
            throw error
        }
    }
}

extension DKClient: Authenticator {
    public typealias Credential = DkCredential

    public nonisolated func apply(_ credential: DkCredential, to urlRequest: inout URLRequest) {
        if let httpBody = urlRequest.httpBody {
            if let parameters = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
                Logger.debug("HTTP Body Parameters: \(parameters)")
                urlRequest.merging(credential)
            }
            Logger.debug("HTTP Body: \(String(data: httpBody, encoding: .utf8) ?? "nil")")
        }
        Logger.debug("Applying credential to URLRequest: \(urlRequest)")
        urlRequest.headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
    }

    public nonisolated func refresh(_ credential: DkCredential, for session: Alamofire.Session, completion: @escaping @Sendable (Swift.Result<DkCredential, any Error>) -> Void) {
        Task(priority: .high, operation: {
            do {
                let result = try await request(LoginByDamtomoMemberIdQuery(credential: credential))
//                await MainActor.run {
//                    let newValue = self.credential.update(result)
//                    try? await keychain.set(newValue, forKey: "dmk-credential")
//                    Logger.debug("Refreshing credential success: \(credential)")
//                    completion(.success(newValue))
//                }
            } catch {
                Logger.error("Failed to refresh credential: \(error)")
                completion(.failure(error))
            }
        })
    }

    public nonisolated func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: DkCredential) -> Bool {
        urlRequest.value(forHTTPHeaderField: "dmk-access-key") == credential.dmkAccessKey && urlRequest.value(forHTTPHeaderField: "compAuthKey") == credential.compAuthKey
    }

    public nonisolated func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        response.statusCode == 401
    }
}
