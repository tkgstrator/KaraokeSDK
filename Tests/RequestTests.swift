//
//  RequestTests.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import Foundation
@testable import KaraokeSDK
import XCTest

final class RequestTests: XCTestCase {
    private let decoder: JSONDecoder = .init()

    override func setUp() async throws {}

    override func tearDown() async throws {}

    func testMusicDetailInfo() async throws {
        let requestNoList: [String] = [
            "3408-80",
            "3408-81",
            "3408-82",
            "3408-83",
            "3408-84",
            "3408-85",
            "3408-86",
            "3408-87",
            "3408-88",
            "3408-89",
        ]
        for requestNo in requestNoList {
            try await DKKaraoke.default.request(MusicDetailInfoQuery(requestNo: requestNo))
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
