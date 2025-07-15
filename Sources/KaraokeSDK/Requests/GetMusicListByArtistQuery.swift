//
//  GetMusicListByArtistQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public typealias GetMusicListByArtistResponse = ResultType<GetMusicListByArtist.Data, GetMusicListByArtist.ListItem>

public final class GetMusicListByArtistQuery: RequestType {
    public typealias ResponseType = GetMusicListByArtistResponse

    public let path: String = "dkwebsys/search-api/GetMusicListByArtistApi"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(artistCode: Int) {
        parameters = [
            "artistCode": artistCode,
            "dispCount": 100,
            "modelPatternCode": 0,
            "modelTypeCode": 3,
            "sort": 2,
            "serialNo": "AT00001",
            "pageNo": 1,
        ]
    }
}

public enum GetMusicListByArtist {
    public typealias ListItem = SearchMusicByKeyword.ListItem
    public struct Data: Decodable, Sendable {
        public let pageCount: Int
        @LossyBoolValue
        public private(set) var hasPreview: Bool
        @LossyBoolValue
        public private(set) var overFlag: Bool
        public let pageNo: Int
        @LossyBoolValue
        public private(set) var hasNext: Bool
        @LosslessValue
        public private(set) var artistCode: Int
        public let totalCount: Int
    }
}
