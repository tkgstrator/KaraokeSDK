//
//  GetMusicDetailInfoQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public typealias GetMusicInfoDetailResponse = ResultType<GetMusicInfoDetail.Data, GetMusicInfoDetail.ListItem>

public final class GetMusicInfoDetailQuery: RequestType {
    public typealias ResponseType = GetMusicInfoDetailResponse

    public let path: String = "dkwebsys/search-api/GetMusicDetailInfoApi"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(requestNo: String) {
        parameters = [
            "requestNo": requestNo,
        ]
    }
}

public enum GetMusicInfoDetail {
    public struct Data: Decodable, Sendable {
        public let artistCode: Int
        public let artist: String
        public let requestNo: String
        public let title: String
        public let titleYomiKana: String
        public let firstLine: String

        public enum CodingKeys: String, CodingKey {
            case artistCode
            case artist
            case requestNo
            case title
            case titleYomiKana = "titleYomi_Kana"
            case firstLine
        }
    }

    public struct ListItem: Decodable, Sendable {
        public let kModelMusicInfoList: [KModelMusicInfoListItem]
    }

    public struct KModelMusicInfoListItem: Decodable, Sendable {
        @LossyBoolValue
        public private(set) var kidsFlag: Bool
        @LossyDefaultFalse
        public private(set) var karaokeDamFlag: Bool
        public let playbackTime: Int
        public let eachModelMusicInfoList: [EachModelMusicInfoListItem]
    }

    public struct EachModelMusicInfoListItem: Decodable, Sendable {
        @LosslessValue
        public private(set) var karaokeModelNum: Int
        public let karaokeModelName: String
        @DateValue<YearMonthDayStrategy>
        public private(set) var releaseDate: Date
        @LosslessValue
        public private(set) var shift: Int
        @LosslessValue
        public private(set) var mainMovieId: Int
        public let mainMovieName: String
        @LosslessValue
        public private(set) var subMovieId: Int
        public let subMovieName: String
        @LossyBoolValue
        public private(set) var honninFlag: Bool
        @LossyBoolValue
        public private(set) var animeFlag: Bool
        @LossyBoolValue
        public private(set) var liveFlag: Bool
        @LossyBoolValue
        public private(set) var mamaotoFlag: Bool
        @LossyBoolValue
        public private(set) var namaotoFlag: Bool
        @LossyBoolValue
        public private(set) var duetFlag: Bool
        @LossyBoolValue
        public private(set) var guideVocalFlag: Bool
        @LossyBoolValue
        public private(set) var prookeFlag: Bool
        @LossyBoolValue
        public private(set) var scoreFlag: Bool
        @LossyBoolValue
        public private(set) var duetDxFlag: Bool
        @LossyBoolValue
        public private(set) var damTomoMovieFlag: Bool
        @LossyBoolValue
        public private(set) var damTomoRecordingFlag: Bool
        @LossyBoolValue
        public private(set) var myListFlag: Bool
    }
}
