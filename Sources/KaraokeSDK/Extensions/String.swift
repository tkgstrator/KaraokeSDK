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

    func capture(pattern: String, group: Int) -> String? {
        capture(pattern: pattern, group: [group]).first
    }

    func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        guard let matches = regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) else {
            return []
        }
        return group.map { group -> String in
            // swiftlint:disable:next legacy_objc_type
            (self as NSString).substring(with: matches.range(at: group))
        }
    }

    func capture(pattern: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let matches: [NSTextCheckingResult] = regex.matches(in: self, range: NSRange(location: 0, length: count))
        return matches.map { match in
            // swiftlint:disable:next legacy_objc_type
            (self as NSString).substring(with: match.range)
        }
    }
}
