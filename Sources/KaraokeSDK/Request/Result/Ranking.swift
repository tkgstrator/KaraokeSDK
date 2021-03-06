//
//  Ranking.swift
//  
//
//  Created by devonly on 2021/12/25.
//

import Foundation
import Alamofire
import Kanna

public final class Ranking: RequestType {
    
    public typealias ResponseType = Response
    
    public var method: HTTPMethod = .get
    public var baseURL: URL = URL(string: "https://www.clubdam.com/")!
    public var path: String = "app/damStation/clubdamRanking.do"
    public var parameters: Parameters
    public var encoding: ParameterEncoding = URLEncoding.queryString
    
    init(requestNo: Int) {
        self.parameters = [
            "requestNo": String(format: "%04d-%02d", requestNo / 100, requestNo % 100)
        ]
    }
    
    public class Response: Codable, Identifiable {
        public let id: String
        public let rank: Int
        public let score: UInt32
        public let nickname: String
        
        internal init?(document: XMLElement) {
            guard let rankText = document.xpath("td[1]").first?.text,
                  let scoreText = document.xpath("td[2]").first?.text,
                  let nicknameText = document.xpath("td[3]").first?.text,
                  let rank = Int(rankText.components(separatedBy: .decimalDigits.inverted).joined()),
                  let score = UInt32(scoreText.components(separatedBy: .decimalDigits.inverted).joined()),
                  let nickname = nicknameText.split(separator: "\n").first
            else {
                return nil
            }
            
            self.rank = rank
            self.score = score
            self.nickname = String(nickname)
            self.id = UUID().uuidString
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method, headers: nil)
        request.timeoutInterval = TimeInterval(10)
        return try encoding.encode(request, with: parameters)
    }
}
