//
//  SearchMusicByKeywordQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public typealias SearchMusicByKeywordResponse = ResultType<SearchMusicByKeyword.Data, SearchMusicByKeyword.ListItem>

public final class SearchMusicByKeywordQuery: RequestType {
    public typealias ResponseType = SearchMusicByKeywordResponse

    public let path: String = "dkwebsys/search-api/SearchMusicByKeywordApi"
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

public enum SearchMusicByKeyword {
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

    public struct ListItem: Decodable, Sendable, Identifiable {
        public var id: String { requestNo }
        public let requestNo: String
        public let title: String
        public let titleYomi: String
        public let artistCode: Int?
        public let artist: String
        public let artistYomi: String
        public let highlightTieUp: String?
        @DateValue<YearMonthDayStrategy>
        public private(set) var releaseDate: Date
        @LossyBoolValue
        public private(set) var newReleaseFlag: Bool
        @LossyBoolValue
        public private(set) var futureReleaseFlag: Bool
        @LossyBoolValue
        public private(set) var newArrivalsFlag: Bool
        @LossyBoolValue
        public private(set) var honninFlag: Bool
        @LossyBoolValue
        public private(set) var animeFlag: Bool
        @LossyBoolValue
        public private(set) var liveFlag: Bool
        @LossyBoolValue
        public private(set) var kidsFlag: Bool
        @LossyBoolValue
        public private(set) var duetFlag: Bool
        @LossyBoolValue
        public private(set) var mamaotoFlag: Bool
        @LossyBoolValue
        public private(set) var namaotoFlag: Bool
        @LossyBoolValue
        public private(set) var guideVocalFlag: Bool
        @LossyBoolValue
        public private(set) var prookeFlag: Bool
        @LossyBoolValue
        public private(set) var damTomoMovieFlag: Bool
        @LossyBoolValue
        public private(set) var damTomoRecordingFlag: Bool
        @LossyDefaultFalse
        public private(set) var damTomoPublicVocalFlag: Bool
        @LossyDefaultFalse
        public private(set) var damTomoPublicMovieFlag: Bool
        @LossyDefaultFalse
        public private(set) var damTomoPublicRecordingFlag: Bool
        @LossyBoolValue
        public private(set) var scoreFlag: Bool
        @LossyBoolValue
        public private(set) var myListFlag: Bool
        @DefaultCodable<DefaultInt>
        public private(set) var shift: Int
        @DefaultCodable<DefaultInt>
        public private(set) var playbackTime: Int
    }
}
