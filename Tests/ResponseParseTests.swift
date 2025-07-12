//
//  ResponseParseTests.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Foundation
@testable import KaraokeSDK
import XCTest

final class ResponseParseTests: XCTestCase {
    private let decoder: JSONDecoder = .init()

    override func setUp() async throws {}

    override func tearDown() async throws {}

    func testMusicDetailInfo() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/MusicDetailInfo") ?? []
        for url in urls {
            try decoder.decode(MusicDetailInfoQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchMusicByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchMusicByKeyword") ?? []
        for url in urls {
            try decoder.decode(SearchMusicByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchArtistByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchArtistByKeyword") ?? []
        for url in urls {
            try decoder.decode(SearchArtistByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchVariousByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchVariousByKeyword") ?? []
        for url in urls {
            try decoder.decode(SearchVariousByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }
}
