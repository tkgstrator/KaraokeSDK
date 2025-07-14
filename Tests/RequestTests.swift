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
            let result = try await DKKaraoke.default.request(MusicDetailInfoQuery(requestNo: requestNo))
            XCTAssertEqual(result.result.statusCode, 0)
        }
    }

    func testSearchMusicByKeyword() async throws {
        let keywords: [String] = [
            "月",
            "空",
            "天",
            "雨",
            "星",
        ]
        for keyword in keywords {
            let result = try await DKKaraoke.default.request(SearchMusicByKeywordQuery(keyword: keyword))
            XCTAssertEqual(result.result.statusCode, 0)
        }
    }

    func testSearchArtistByKeyword() async throws {
        let keywords: [String] = [
            "月",
            "空",
            "天",
            "雨",
            "星",
        ]
        for keyword in keywords {
            let result = try await DKKaraoke.default.request(SearchArtistByKeywordQuery(keyword: keyword))
            XCTAssertEqual(result.result.statusCode, 0)
        }
    }

    func testSearchVariousByKeyword() async throws {
        let keywords: [String] = [
            "月",
            "空",
            "天",
            "雨",
            "星",
        ]
        for keyword in keywords {
            let result = try await DKKaraoke.default.request(SearchVariousByKeywordQuery(keyword: keyword))
            XCTAssertEqual(result.result.statusCode, 0)
        }
    }

    func testDkDamConnectServlet() async throws {
        let qrCode = "0a3203395c38db33ac41015407306b30"
        let result = try await DKKaraoke.default.request(DkDamConnectServletQuery(params: .init(qrCode: qrCode)))
        XCTAssertEqual(result.qrCode, qrCode)
    }

    func testDkDamConnectServletWithDeviceId() async throws {
        let qrCode = "0a3203395c38db33ac41015407306b30"
        let result = try await DKKaraoke.default.request(DkDamConnectServletQuery(params: .init(qrCode: qrCode)))
        XCTAssertEqual(result.qrCode, qrCode)
    }

    func testDkDamSeparateServlet() async throws {
        let qrCode = "0a3203395c38db33ac41015407306b30"
        let result = try await DKKaraoke.default.request(DkDamSeparateServletQuery(params: .init()))
        XCTAssertEqual(result.qrCode, qrCode)
    }

    func testDkDamRemoconSendServlet() async throws {
        let qrCode = "0a3203395c38db33ac41015407306b30"
        for remoconCode in DkDamRemoconCode.allCases {
            let result = try await DKKaraoke.default.request(DkDamRemoconSendServletQuery(params: .init(remoconCode: remoconCode)))
            XCTAssertEqual(result.qrCode, qrCode)
        }
    }

    func testDkDamSendServlet() async throws {
        let qrCode = "0a3203395c38db33ac41015407306b30"
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
            let result = try await DKKaraoke.default.request(DkDamSendServletQuery(params: .init(requestNo: requestNo)))
            XCTAssertEqual(result.requestNo, requestNo)
            XCTAssertEqual(result.qrCode, qrCode)
        }
    }

//    func testLoginByDamtomoMemberId() async throws {
//        let loginId: String = ""
//        let password: String = ""
//        let result = try await DKKaraoke.default.request(LoginByDamtomoMemberIdQuery(params: .init(loginId: loginId, password: password)))
//    }
}
