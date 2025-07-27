//
//  QRCode.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Foundation

public struct DkCode: Codable, RawRepresentable, Sendable {
    public let host: String
    public let serialNo: String
    public let timestamp: Date

    #if targetEnvironment(simulator)
    public init() {
        host = "010.092.172.007"
        serialNo = "AT002983"
        timestamp = .init(timeIntervalSince1970: Double(Int32.max))
    }
    #else
    public init() {
        host = ""
        serialNo = ""
        timestamp = .init(timeIntervalSince1970: 0)
    }
    #endif

    // 読み取ったときはエラーなどを発生させて無効なQRコードであることを示す
    public init?(rawValue: String) {
        let expiresIn: TimeInterval = .init(Int32.max)
        let formatter: DateFormatter = .init()
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        let bytes: [String] = rawValue.chunked(by: 2)
        if rawValue.rangeOfCharacter(from: .alphanumerics.inverted) != nil || bytes.count != 16 {
            Logger.debug("Invalid QR code format: \(rawValue)")
            return nil
        }
        host = [bytes[0], bytes[4], bytes[8], bytes[12]]
            .compactMap { UInt8($0, radix: 16) }.map { String(format: "%03d", $0) }.joined(separator: ".")
        let buffer: [UInt8] = [bytes[9], bytes[11], bytes[13], bytes[15], bytes[1], bytes[3], bytes[5], bytes[7]].compactMap { UInt8($0, radix: 16) }
        guard let serialNo: String = .init(data: .init(bytes: buffer, count: buffer.count), encoding: .ascii) else {
            Logger.debug("Invalid Serial No: \(rawValue)")
            return nil
        }
        self.serialNo = serialNo
        timestamp = .init(timeIntervalSince1970: expiresIn)
    }

    /// リフレッシュが必要かどうか
    /// タイムスタンプが現在時刻よりも前ならリフレッシュが必要
    /// どこで使うかはまだわからない
    /// 六時間もあれば再連携してくれって感じもする
    public var requiresRefresh: Bool {
        timestamp <= .init()
    }

    /// 有効期限を日付で表示する
    /// タイムスタンプが初期値の場合には空文字を返す
    public var expiresIn: String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "YYYY/MM/DD HH:mm:ss"
        return timestamp.timeIntervalSince1970 == 0 ? "" : formatter.string(from: timestamp)
    }

    // 有効期限がめちゃくちゃ長いQRコードを生成する
    // NOTE: 通常は一時間だが、六時間くらい確保すれば実用上不都合がないと思われる
    // - 未連携時は空っぽのコードを発行する
    // - APIが空っぽでも受け付けるのでこれでいいと思う
    public var rawValue: String {
        if host.isEmpty || serialNo.isEmpty {
            return ""
        }
        let host: [String] = host.split(separator: ".").compactMap { UInt8($0) }.compactMap { String(format: "%02X", $0) }
        let serialNo: [String] = serialNo.utf8.map { String(format: "%02X", $0) }.joined().chunked(by: 2)
        let timestamp: [String] = String(format: "%08X", Int(timestamp.timeIntervalSince1970)).chunked(by: 2)
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
