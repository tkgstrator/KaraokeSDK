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
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(MusicDetailInfoQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchMusicByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchMusicByKeyword") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(SearchMusicByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchArtistByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchArtistByKeyword") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(SearchArtistByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testSearchVariousByKeyword() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/SearchVariousByKeyword") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(SearchVariousByKeywordQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testDkDamConnectServlet() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/DkDamConnectServlet") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(DkDamConnectServletQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testDkDamSeparateServlet() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/DkDamSeparateServlet") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(DkDamSeparateServletQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testDkDamRemoconSendServlet() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/DkDamRemoconSendServlet") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(DkDamRemoconSendServletQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testDkDamSendServlet() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/DkDamSendServlet") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(DkDamSendServletQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testLoginByDamtomoMemberId() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/LoginByDamtomoMemberId") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(LoginByDamtomoMemberIdQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }

    func testGetMusicStreamingURL() async throws {
        let urls: [URL] = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Resources/GetMusicStreamingURL") ?? []
        XCTAssertNotEqual(urls.count, 0)
        for url in urls {
            try decoder.decode(GetMusicStreamingURLQuery.ResponseType.self, from: .init(contentsOf: url))
        }
    }
}
