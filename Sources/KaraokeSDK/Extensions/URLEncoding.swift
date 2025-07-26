//
//  URLEncoding.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/26.
//

import Alamofire
import Foundation

extension URLEncoding {
    func decode(_ urlRequest: URLRequest) -> [String: Any & Sendable] {
        guard let httpBody: Data = urlRequest.httpBody,
              let bodyString: String = .init(data: httpBody, encoding: .utf8)
        else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: bodyString
            .split(separator: "&")
            .compactMap { pair -> (String, String)? in
                let parts = pair.split(separator: "=", maxSplits: 1)
                guard parts.count == 2,
                      let key = parts[0].removingPercentEncoding,
                      let value = parts[1].removingPercentEncoding else { return nil }
                return (key, value)
            })
    }

    func encode(_ parameters: [String: Any & Sendable]) -> Data {
        parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)!
    }
}

extension JSONEncoding {
    func decode(_ urlRequest: URLRequest) -> [String: Any & Sendable] {
        guard let httpBody: Data = urlRequest.httpBody,
              let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any & Sendable]
        else {
            return [:]
        }
        return jsonObject
    }

    func encode(_ parameters: [String: Any & Sendable]) -> Data {
        // swiftlint:disable:next force_try
        try! JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

extension Dictionary {
    /// TypeScriptのように辞書をマージするメソッド
    /// - Parameter other: 辞書
    /// - Returns: 辞書
    func merging(_ other: [Key: Value]) -> [Key: Value] {
        merging(other, uniquingKeysWith: { $1 })
    }
}
