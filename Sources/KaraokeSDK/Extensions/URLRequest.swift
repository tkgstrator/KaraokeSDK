//
//  URLRequest.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation

extension URLRequest {
    mutating func merging(_ credential: DkCredential) {
        guard let targetUrl: URL = url else {
            Logger.error("URL is nil, cannot merge credential.")
            return
        }
        // Assuming DkCredential has properties that can be added to the URLRequest
        if let body = httpBody,
           let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
            Logger.debug("Merging credential with existing parameters: \(parameters)")
            if targetUrl.path.hasPrefix("/dkdenmoku") {
                Logger.debug("URL path starts with 'dkdenmoku', merging credential into parameters.")
            }
            if credential.qrCode.isEmpty {
                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
                    "compAuthKey": credential.compAuthKey,
                    "compId": credential.compId,
                    "deviceId": credential.deviceId,
                    "cdmNo": credential.cdmNo,
                ], uniquingKeysWith: { $1 }))
            } else {
                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
                    "QRcode": credential.qrCode,
                    "compAuthKey": credential.compAuthKey,
                    "compId": credential.compId,
                    "deviceId": credential.deviceId,
                    "cdmNo": credential.cdmNo,
                ], uniquingKeysWith: { $1 }))
            }
            return
        }
        return
    }
}
