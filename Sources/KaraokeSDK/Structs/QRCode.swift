//
//  QRCode.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation

public struct QRCode: Codable {
    public let host: String
    public let serialNo: String
    public let timestamp: Date

    public init?(code: String) {
        let formatter: DateFormatter = .init()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        let bytes: [String] = code.chunked(by: 2)
        if code.rangeOfCharacter(from: .alphanumerics.inverted) != nil || bytes.count != 16 {
            Logger.debug("Invalid QR code format: \(code)")
            return nil
        }
        host = [bytes[0], bytes[4], bytes[8], bytes[12]]
            .compactMap { UInt8($0, radix: 16) }.map { String(format: "%03d", $0) }.joined(separator: ".")
        serialNo = [bytes[9], bytes[11], bytes[13], bytes[15], bytes[1], bytes[3], bytes[5], bytes[7]]
            .joined()
        timestamp = .init(timeIntervalSince1970: TimeInterval(Int([bytes[14], bytes[10], bytes[6], bytes[2]].joined(), radix: 16)!) + 60 * 60)
    }

    public var requiresRefresh: Bool {
        timestamp <= .init()
    }

    // 有効期限がめちゃくちゃ長いQRコードを生成する
    // NOTE: 通常は一時間だが、六時間くらい確保すれば実用上不都合がないと思われる
    public var code: String {
        let host: [String] = host.split(separator: ".").compactMap { UInt8($0) }.compactMap { String(format: "%02X", $0) }
        let serialNo: [String] = serialNo.chunked(by: 2)
        let timestamp: [String] = String(format: "%08X", Int(Date(timeIntervalSinceNow: 60 * 60).timeIntervalSinceNow)).chunked(by: 2)
        return [
            host[0],
            serialNo[4],
            timestamp[3],
            serialNo[5],
            host[1],
            serialNo[6],
            timestamp[2],
            serialNo[7],
            host[2],
            serialNo[0],
            timestamp[1],
            serialNo[1],
            host[3],
            serialNo[2],
            timestamp[0],
            serialNo[3],
        ]
        .joined()
    }
}

extension String {
    func chunked(by chunkSize: Int) -> [String] {
        let array: [String] = map { String($0) }
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0 ..< Swift.min($0 + chunkSize, array.count)]).joined().uppercased()
        }
    }
}
