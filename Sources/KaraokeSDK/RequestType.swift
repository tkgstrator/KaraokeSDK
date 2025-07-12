//
//  RequestType.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation

public protocol RequestType: URLRequestConvertible {
    associatedtype ResponseType: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
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

    func asURLRequest() throws -> URLRequest {
        let url: URL = baseURL.appendingPathComponent(path)
        let request: URLRequest = try .init(url: url, method: method, headers: nil)

        if let parameters {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
}
