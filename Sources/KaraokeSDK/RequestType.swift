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
    var loginRequired: Bool { get }
}

public extension RequestType {
    /// デフォルトのURL
    var baseURL: URL {
        URL(string: "https://denmokuapp.clubdam.com")!
    }
    
    /// デフォルトのエンコーディング方式
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
    
    /// デコーダー
    var decoder: DataDecoder {
        JSONDecoder()
    }
    
    /// パラメーター
    var parameters: Parameters? {
        nil
    }

    /// 共通のヘッダー
    /// UAはとりあえず本家に合わせておく
    var headers: HTTPHeaders? {
        [
            "User-Agent": "DenmokuMini/4.13.8 (jp.co.dkkaraoke.DENMOKULite01; build:59; iOS 17.5.1) Alamofire/5.9.1",
        ]
    }
    
    /// ログインが要求されるリクエストかどうか
    /// 普通は要求される
    var loginRequired: Bool {
        true
    }
    
    /// URLRequestへの変換
    /// HTTPMethodとHeadersを設定する
    /// Parametersがある場合はエンコードする
    /// - Returns: <#description#>
    func asURLRequest() throws -> URLRequest {
        let url: URL = baseURL.appendingPathComponent(path)
        let request: URLRequest = try .init(url: url, method: method, headers: headers)
        if let parameters {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
}
