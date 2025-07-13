//
//  DKKaraoke.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation

public final class DKKaraoke: Sendable {
    public static let `default`: DKKaraoke = .init()
    private let session: Session = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    
    private init() {
        Logger.configure()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.httpMaximumConnectionsPerHost = 1
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    public func request<T: RequestType>(_ convertible: T) async throws -> T.ResponseType where T.ResponseType: Decodable, T.ResponseType: Sendable {
        let result = await session.request(convertible)
            .cURLDescription(calling: { request in
                Logger.debug("cURL Request: \(request)")
            })
            .serializingData()
            .result
        switch result {
        case .success(let response):
            return try decoder.decode(T.ResponseType.self, from: response)
        case .failure(let error):
            Logger.error(error)
            throw error
        }
    }
}
