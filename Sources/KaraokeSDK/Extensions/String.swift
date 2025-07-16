//
//  String.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/16.
//

import Foundation

extension String {
    var base64DecodedString: String? {
        let formatedString: String = self + Array(repeating: "=", count: count % 4).joined()
        guard let data: Data = .init(base64Encoded: formatedString),
              let stringValue: String = .init(data: data, encoding: .utf8)
        else {
            return nil
        }
        return stringValue
    }
}
