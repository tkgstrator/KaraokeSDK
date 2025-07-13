//
//  MusicDetailInfoQuery.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/13.
//

import Alamofire
@preconcurrency
import BetterCodable
import Foundation

public typealias MusicDetailInfoResponse = ResultType<MusicDetailInfo.Data, MusicDetailInfo.ListItem>

public final class MusicDetailInfoQuery: RequestType {
    public typealias ResponseType = MusicDetailInfoResponse

    public let path: String = "dkwebsys/search-api/GetMusicDetailInfoApi"
    public let method: HTTPMethod = .post
    public let parameters: Parameters?

    public init(requestNo: String) {
        parameters = [
            "requestNo": requestNo,
        ]
    }
}

public enum MusicDetailInfo {
    public struct Data: Decodable, Sendable {
        let artistCode: Int
        let artist: String
        let requestNo: String
        let title: String
        let titleYomiKana: String
        let firstLine: String

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
        let kModelMusicInfoList: [KModelMusicInfoListItem]
    }

    public struct KModelMusicInfoListItem: Decodable, Sendable {
        @LossyBoolValue
        private(set) var kidsFlag: Bool
        @LossyDefaultFalse
        private(set) var karaokeDamFlag: Bool
        let playbackTime: Int
        let eachModelMusicInfoList: [EachModelMusicInfoListItem]
    }

    public struct EachModelMusicInfoListItem: Decodable, Sendable {
        @LosslessValue
        private(set) var karaokeModelNum: Int
        let karaokeModelName: String
        @DateValue<YearMonthDayStrategy>
        private(set) var releaseDate: Date
        @LosslessValue
        private(set) var shift: Int
        @LosslessValue
        private(set) var mainMovieId: Int
        let mainMovieName: String
        @LosslessValue
        private(set) var subMovieId: Int
        let subMovieName: String
        @LossyBoolValue
        private(set) var honninFlag: Bool
        @LossyBoolValue
        private(set) var animeFlag: Bool
        @LossyBoolValue
        private(set) var liveFlag: Bool
        @LossyBoolValue
        private(set) var mamaotoFlag: Bool
        @LossyBoolValue
        private(set) var namaotoFlag: Bool
        @LossyBoolValue
        private(set) var duetFlag: Bool
        @LossyBoolValue
        private(set) var guideVocalFlag: Bool
        @LossyBoolValue
        private(set) var prookeFlag: Bool
        @LossyBoolValue
        private(set) var scoreFlag: Bool
        @LossyBoolValue
        private(set) var duetDxFlag: Bool
        @LossyBoolValue
        private(set) var damTomoMovieFlag: Bool
        @LossyBoolValue
        private(set) var damTomoRecordingFlag: Bool
        @LossyBoolValue
        private(set) var myListFlag: Bool
    }
}
