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
           let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any]
        {
            Logger.debug("Merging credential with existing parameters: \(parameters)")
            if targetUrl.path.hasPrefix("/minsei") {
                headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
            }
            if targetUrl.path.hasPrefix("/dkwebsys") {
                Logger.debug("URL path starts with 'dkwebsys', merging credential into parameters.")
                headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
                    "authKey": credential.compAuthKey,
                    "compId": credential.compId,
                ], uniquingKeysWith: { $1 }))
            }
            if targetUrl.path.hasPrefix("/dkdenmoku") {
                Logger.debug("URL path starts with 'dkdenmoku', merging credential into parameters.")
                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
                    "deviceId": credential.deviceId,
                    "cdmNo": credential.cdmNo,
                ], uniquingKeysWith: { $1 }))
            }
            return
        }
    }
}
