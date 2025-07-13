//
//  KaraokeSDK.swift
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

    @discardableResult
    public func request<T: RequestType>(_ convertible: T) async throws -> T.ResponseType where T.ResponseType: Decodable, T.ResponseType: Sendable {
        let result = await session.request(convertible)
            .cURLDescription(calling: { request in
                Logger.debug("cURL Request: \(request)")
            })
            .serializingData()
            .result
        switch result {
        case let .success(response):
            do {
                return try decoder.decode(T.ResponseType.self, from: response)
            } catch {
                Logger.error(String(data: response, encoding: .utf8))
                Logger.error(error)
                throw error
            }
        case let .failure(error):
            Logger.error(error)
            throw error
        }
    }
}
