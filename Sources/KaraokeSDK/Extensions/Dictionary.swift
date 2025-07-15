//
//  Dictionary.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation

// extension Dictionary where Key == String, Value == Any {
//    init(query: String) {
//        self.init(uniqueKeysWithValues: query.split(separator: "&").map { pair in
//            let parts = pair.split(separator: "=", maxSplits: 1)
//            let key = String(parts[0])
//            let value = parts.count > 1 ? String(parts[1]) : ""
//            return (key, value)
//        })
//    }
// }

extension Data {
    init?(query: String) {
        let dictionary: [String: Any] = Dictionary(uniqueKeysWithValues: query.split(separator: "&").map { pair in
            let parts = pair.split(separator: "=", maxSplits: 1)
            let key = String(parts[0])
            let value = parts.count > 1 ? String(parts[1]) : ""
            return (key, value)
        })
        guard let data: Data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        self.init(data)
    }
}
