//
//  SearchArtistByKeywordQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
import BetterCodable
import Foundation

public typealias SearchArtistByKeywordResponse = ResultType<SearchArtistByKeyword.Data, SearchArtistByKeyword.ListItem>

public final class SearchArtistByKeywordQuery: RequestType {
    public typealias ResponseType = SearchArtistByKeywordResponse

    public let path: String = "dkwebsys/search-api/SearchArtistByKeywordApi"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(keyword: String) {
        parameters = [
            "keyword": keyword,
            "dispCount": 100,
            "modelPatternCode": 0,
            "modelTypeCode": 3,
            "sort": 2,
            "serialNo": "AT00001",
            "pageNo": 1,
        ]
    }
}

public enum SearchArtistByKeyword {
    public struct Data: Decodable, Sendable {
        public let pageCount: Int
        @LossyBoolValue
        public private(set) var hasPreview: Bool
        @LossyBoolValue
        public private(set) var overFlag: Bool
        public let pageNo: Int
        @LossyBoolValue
        public private(set) var hasNext: Bool
        public let keyword: String
        public let totalCount: Int
    }

    public struct ListItem: Decodable, Sendable {
        public let artistCode: Int
        public let artist: String
        public let artistYomi: String
        public let holdMusicCount: Int
    }
}
