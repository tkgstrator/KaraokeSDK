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
        self.parameters = [
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
        let pageCount: Int
        @LossyBoolValue
        private(set) var hasPreview: Bool
        @LossyBoolValue
        private(set) var overFlag: Bool
        let pageNo: Int
        @LossyBoolValue
        private(set) var hasNext: Bool
        let keyword: String
        let totalCount: Int
    }

    public struct ListItem: Decodable, Sendable {
        let artistCode: Int
        let artist: String
        let artistYomi: String
        let holdMusicCount: Int
    }
}
