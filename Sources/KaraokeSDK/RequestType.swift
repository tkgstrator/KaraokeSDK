//
//  RequestType.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation

public protocol RequestType: URLRequestConvertible {
    associatedtype ResponseType: Decodable, Sendable

    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var decoder: DataDecoder { get }
}

public extension RequestType {
    var baseURL: URL {
        URL(string: "https://denmokuapp.clubdam.com")!
    }

    var encoding: ParameterEncoding {
        switch method {
            case .get:
                URLEncoding.default
            case .post:
                JSONEncoding.default
            default:
                URLEncoding.default
        }
    }

    var decoder: DataDecoder {
        JSONDecoder()
    }

    var parameters: Parameters? {
        nil
    }

    var headers: HTTPHeaders? {
        [
            "User-Agent": "DenmokuMini/4.12.0 (jp.co.DKClient.DENMOKULite01; build:49; iOS 17.6.0) Alamofire/5.9.1",
        ]
    }

    func asURLRequest() throws -> URLRequest {
        let url: URL = baseURL.appendingPathComponent(path)
        let request: URLRequest = try .init(url: url, method: method, headers: headers)
        if let parameters {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
}
