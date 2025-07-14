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

public final class DKKaraoke: Authenticator {
    public typealias Credential = DKCredential
    
    public func apply(_ credential: DKCredential, to urlRequest: inout URLRequest) {
        if let httpBody = urlRequest.httpBody {
            if let parameters = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
                Logger.debug("HTTP Body Parameters: \(parameters)")
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
                    "authKey": credential.compAuthKey,
                    "compId": credential.compId,
                    "QRcode": credential.qrCode,
                    "cdmNo": credential.cdmNo,
                    "deviceId": credential.deviceId,
                ], uniquingKeysWith: { $1 }))
            }
            
            Logger.debug("HTTP Body: \(String(data: httpBody, encoding: .utf8) ?? "nil")")
        }
        urlRequest.headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
    }
    
    public func refresh(_ credential: DKCredential, for session: Alamofire.Session, completion: @escaping @Sendable (Swift.Result<DKCredential, any Error>) -> Void) {
        Task(priority: .high, operation: {
            do {
                let result = try await request(LoginByDamtomoMemberIdQuery(credential: credential))
                let newValue = credential.update(result)
                try keychain.set(newValue, forKey: "dmk-credential")
                completion(.success(newValue))
            } catch (let error) {
                completion(.failure(error))
            }
        })
    }
    
    public func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: DKCredential) -> Bool {
        return urlRequest.value(forHTTPHeaderField: "dmk-access-key") == credential.dmkAccessKey && urlRequest.value(forHTTPHeaderField: "compAuthKey") == credential.compAuthKey
    }
    
    public func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        return response.statusCode == 401
    }
    
    public static let `default`: DKKaraoke = .init()
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let keychain: Keychain = .init(server: "https://denmokuapp.clubdam.com", protocolType: .https)
    private var interceptor: AuthenticationInterceptor<DKKaraoke>? {
        guard let credential = try? keychain.get(DKCredential.self, forKey: "dmk-credential") else {
            Logger.debug("No credential found in keychain, returning unauthenticated interceptor.")
            let credential: DKCredential = .init()
            try? keychain.set(credential, forKey: "dmk-credential")
            return .init(authenticator: self, credential: credential)
        }
        return AuthenticationInterceptor(authenticator: DKKaraoke.default, credential: credential)
    }
    
    
    private init() {
        Logger.configure()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.httpMaximumConnectionsPerHost = 1
        //        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    @discardableResult
    public func request<T: RequestType>(_ convertible: T) async throws -> T.ResponseType where T.ResponseType: Decodable, T.ResponseType: Sendable {
        return try await session.request(convertible, interceptor: interceptor)
            .cURLDescription(calling: { request in
                Logger.debug("cURL Request: \(request)")
            })
            .validate(statusCode: 200 ..< 300)
            .serializingDecodable(T.ResponseType.self, automaticallyCancelling: true, decoder: decoder)
            .value
    }
}
