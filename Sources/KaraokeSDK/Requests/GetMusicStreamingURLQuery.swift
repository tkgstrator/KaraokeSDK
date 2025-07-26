//
//  GetMusicStreamingURLQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public final class GetMusicStreamingURLQuery: RequestType {
    public typealias ResponseType = GetMusicStreamingURLResponse

    public let path: String = "cwa/win/minsei/music/playLog/GetMusicStreamingURL.api"
    public let method: HTTPMethod = .post
    public let encoding: ParameterEncoding = URLEncoding.httpBody
    public let parameters: Parameters?

    public init(params: GetMusicStreamingURLRequest) {
        parameters = [
            "compId": 1,
            "contractId": 1,
            "deviceId": 1,
            "format": "json",
            "registHistoryFlg": 0,
            "requestNo": params.requestNo,
            "serviceId": 1
        ]
    }
}

public struct GetMusicStreamingURLRequest {
    let requestNo: String

    public init(requestNo: String) {
        self.requestNo = requestNo
    }
}

public struct GetMusicStreamingURLResponse: Decodable, Sendable {
    public let data: GetMusicStreamingURLData
    public let list: [GetMusicStreamingURL]
    public let message: String
    public let status: String
    @LosslessValue
    public private(set) var statusCode: Int
    public let type: String
}

public struct GetMusicStreamingURL: Decodable, Sendable, Identifiable {
    public var id: Int { contentsId }
    @LosslessValue
    public private(set) var contentsId: Int
    public let duet: String
    public let lowBitrateUrl: URL
    public let highBitrateUrl: URL
}

public struct GetMusicStreamingURLData: Decodable, Sendable {
    @LosslessValue
    public private(set) var karaokeContentsId: Int
}
