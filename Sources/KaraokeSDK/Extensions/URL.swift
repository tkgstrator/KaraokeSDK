//
//  URL.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/08/09.
//

import Foundation

extension URL {
    init(unsafeString: String) {
        // swiftlint:disable:next force_unwrapping
        self.init(string: unsafeString)!
    }
}
