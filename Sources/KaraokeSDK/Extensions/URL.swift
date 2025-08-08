//
//  URL.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/08/09.
//

import Foundation

extension URL {
    init(unsafeString: String) {
        self.init(string: unsafeString)!
    }
}
