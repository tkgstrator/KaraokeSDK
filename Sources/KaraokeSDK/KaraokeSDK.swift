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

@MainActor
public final class DKClient: ObservableObject {
    public static let `default`: DKClient = .init()
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let keychain: Keychain = .init(server: "https://denmokuapp.clubdam.com", protocolType: .https)

    @Published
    public private(set) var credential: DkCredential = .init()

    public var isDisabled: Bool {
        false
//        credential.qrCode.isEmpty
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

    /// ログイン処理
    /// NOTE: - ログイン処理だけはややこしいので専用のメソッドを用意
    public func login(_ params: sending DkDamDAMTomoLoginServletRequest) async throws {
        do {
            let interceptor: AuthenticationInterceptor<DKClient> = .init(authenticator: self, credential: credential)
            let params = try await (
                session.request(DkDamDAMTomoLoginServletQuery(params: params), interceptor: interceptor)
                    .cURLDescription(calling: { request in
                        Logger.debug("cURL Request: \(request)")
                    })
                    .validateWith()
                    .serializingDecodable(DkDamDAMTomoLoginServletResponse.self, automaticallyCancelling: true, decoder: decoder)
                    .value,
                session.request(LoginByDamtomoMemberIdQuery(params: params), interceptor: interceptor)
                    .cURLDescription(calling: { request in
                        Logger.debug("cURL Request: \(request)")
                    })
                    .validateWith()
                    .serializingDecodable(LoginByDamtomoMemberIdResponse.self, automaticallyCancelling: true, decoder: decoder)
                    .value
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
            let interceptor: AuthenticationInterceptor<DKClient> = .init(authenticator: self, credential: credential)
            let response = try await session.request(convertible, interceptor: interceptor)
                .cURLDescription(calling: { request in
                    Logger.debug("cURL Request: \(request)")
                })
                .validateWith()
                .serializingDecodable(T.ResponseType.self, automaticallyCancelling: true, decoder: decoder)
                .value
            // 筐体との連携成功時にQRコードを更新
            if let result = response as? DkDamConnectServletResponse {
//                try? keychain.set(credential.update(result), forKey: "dmk-credential")
                Logger.debug("DkDamConnectServletResponse: \(result)")
            }
            return response
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
