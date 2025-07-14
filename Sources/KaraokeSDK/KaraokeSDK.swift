//
//  KaraokeSDK.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation
import KeychainAccess

@MainActor
public final class DKKaraoke {
    public static let `default`: DKKaraoke = .init()
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let keychain: Keychain = .init(server: "https://denmokuapp.clubdam.com", protocolType: .https)

    private init() {
        Logger.configure()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.httpMaximumConnectionsPerHost = 1
        //        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    @discardableResult
    public func request<T: RequestType>(_ convertible: T) async throws -> T.ResponseType where T.ResponseType: Decodable, T.ResponseType: Sendable {
        try await session.request(convertible)
            .cURLDescription(calling: { request in
                Logger.debug("cURL Request: \(request)")
            })
            .validate(statusCode: 200 ..< 300)
            .serializingDecodable(T.ResponseType.self, automaticallyCancelling: true, decoder: decoder)
            .value
    }
}
