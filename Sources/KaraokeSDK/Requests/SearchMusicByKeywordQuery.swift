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
    public let headers: HTTPHeaders? = nil
    public let parameters: Parameters? = nil
}

public enum SearchMusicByKeyword {
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
        let requestNo: String
        let title: String
        let titleYomi: String
        let artistCode: Int
        let artist: String
        let artistYomi: String
        @DateValue<YearMonthDayStrategy>
        private(set) var releaseDate: Date
        @LossyBoolValue
        private(set) var newReleaseFlag: Bool
        @LossyBoolValue
        private(set) var futureReleaseFlag: Bool
        @LossyBoolValue
        private(set) var newArrivalsFlag: Bool
        @LossyBoolValue
        private(set) var honninFlag: Bool
        @LossyBoolValue
        private(set) var animeFlag: Bool
        @LossyBoolValue
        private(set) var liveFlag: Bool
        @LossyBoolValue
        private(set) var kidsFlag: Bool
        @LossyBoolValue
        private(set) var duetFlag: Bool
        @LossyBoolValue
        private(set) var mamaotoFlag: Bool
        @LossyBoolValue
        private(set) var namaotoFlag: Bool
        @LossyBoolValue
        private(set) var guideVocalFlag: Bool
        @LossyBoolValue
        private(set) var prookeFlag: Bool
        @LossyBoolValue
        private(set) var damTomoMovieFlag: Bool
        @LossyBoolValue
        private(set) var damTomoRecordingFlag: Bool
        @LossyDefaultFalse
        private(set) var damTomoPublicVocalFlag: Bool
        @LossyDefaultFalse
        private(set) var damTomoPublicMovieFlag: Bool
        @LossyDefaultFalse
        private(set) var damTomoPublicRecordingFlag: Bool
        @LossyBoolValue
        private(set) var scoreFlag: Bool
        @LossyBoolValue
        private(set) var myListFlag: Bool
        @DefaultCodable<DefaultInt>
        private(set) var shift: Int
        @DefaultCodable<DefaultInt>
        private(set) var playbackTime: Int
    }
}
