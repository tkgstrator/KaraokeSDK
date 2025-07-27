//
//  URLRequest.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Alamofire
import Foundation

extension URLRequest {
    mutating func merging(_ credential: DkCredential) {
        guard let targetUrl: URL = url else {
            Logger.error("URL is nil, cannot merge credential.")
            return
        }

        // Access Key Header
        headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)

        guard let body: Data = httpBody,
              let type = value(forHTTPHeaderField: "Content-Type")
        else {
            Logger.debug("No HTTP body to merge with credential.")
            return
        }

        if targetUrl.path.hasPrefix("/cwa") {
            Logger.debug("URL path starts with 'cwa', merging credential into parameters.")
            if type.contains("application/json"),
               let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
                fatalError("URL-encoded parameters are not supported in this context.")
            }

            if type.contains("application/x-www-form-urlencoded") {
                Logger.debug("Merging credential with existing URL-encoded parameters.")
                let parameters: Parameters = URLEncoding.httpBody.decode(self)
                httpBody = URLEncoding.httpBody.encode(parameters.merging([
                    "authToken": credential.mns.authToken,
                    "compAuthKey": credential.compAuthKey,
                    "userCode": credential.mns.damtomoId,
                    "compId": credential.compId,
                ]))
            }
        }

        if targetUrl.path.hasPrefix("/minsei") {
            Logger.debug("URL path starts with 'minsei', merging credential into parameters.")
            if type.contains("application/json"),
               let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any] {
                fatalError("URL-encoded parameters are not supported in this context.")
            }

            if type.contains("application/x-www-form-urlencoded") {
                Logger.debug("Merging credential with existing URL-encoded parameters.")
                let parameters: Parameters = URLEncoding.httpBody.decode(self)
                httpBody = URLEncoding.httpBody.encode(parameters.merging([
                    "authToken": "22d1e1712a41a25f2df83fc4d5facd0e",
                    "compAuthKey": credential.compAuthKey,
                    "userCode": credential.dtm.damtomoId,
                    "compId": credential.compId,
                ]))
            }
        }

        if targetUrl.path.hasPrefix("/dkwebsys") {
            Logger.debug("URL path starts with 'dkwebsys', merging credential into parameters.")
            if type.contains("application/json"),
               let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any & Sendable] {
                Logger.debug("Merging credential with existing JSON parameters.")
                httpBody = JSONEncoding.default.encode(parameters.merging([
                    "authKey": credential.compAuthKey,
                    "compId": credential.compId,
                ]))
            }

            if type.contains("application/x-www-form-urlencoded") {
                fatalError("URL-encoded parameters are not supported in this context.")
//                Logger.debug("Merging credential with existing URL-encoded parameters.")
            }
        }

        if targetUrl.path.hasPrefix("/dkdenmoku") {
            Logger.debug("URL path starts with 'dkdenmoku', merging credential into parameters.")
            if type.contains("application/json"),
               let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any & Sendable] {
                if targetUrl.path.hasSuffix("DkDamDAMTomoLoginServlet") {
                    httpBody = JSONEncoding.default.encode(parameters.merging([
                        "deviceId": credential.dtm.deviceId,
                        "cdmNo": credential.dtm.cdmNo,
                    ]))
                    return
                }
                Logger.debug("Merging credential with existing JSON parameters.")
                httpBody = JSONEncoding.default.encode(parameters.merging([
                    "QRcode": credential.code.rawValue,
                    "deviceId": credential.dtm.deviceId,
                    "cdmNo": credential.dtm.cdmNo,
                ]))
            }

            if type.contains("application/x-www-form-urlencoded") {
                fatalError("URL-encoded parameters are not supported in this context.")
//                Logger.debug("Merging credential with existing URL-encoded parameters.")
            }
        }

        // Parameters

        // Assuming DkCredential has properties that can be added to the URLRequest
//        if let body = httpBody,
//           let parameters = try? JSONSerialization.jsonObject(with: body) as? [String: Any]
//        {
//            Logger.debug("Merging credential with existing parameters: \(parameters)")
//            if targetUrl.path.hasPrefix("/minsei") {
//                headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
//                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
//                    "authToken": "22d1e1712a41a25f2df83fc4d5facd0e",
//                    "compAuthKey": credential.compAuthKey,
//                    "userCode": credential.dtm.damtomoId,
//                    "compId": credential.compId,
//                ], uniquingKeysWith: { $1 }))
//            }
//            // 楽曲検索など
//            if targetUrl.path.hasPrefix("/dkwebsys") {
//                Logger.debug("URL path starts with 'dkwebsys', merging credential into parameters.")
//                headers.add(name: "dmk-access-key", value: credential.dmkAccessKey)
//                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
//                    "authKey": credential.compAuthKey,
//                    "compId": credential.compId,
//                ], uniquingKeysWith: { $1 }))
//            }
//            // 筐体との連携など
//            if targetUrl.path.hasPrefix("/dkdenmoku") {
//                Logger.debug("URL path starts with 'dkdenmoku', merging credential into parameters.")
//                httpBody = try? JSONSerialization.data(withJSONObject: parameters.merging([
//                    "deviceId": credential.dtm.deviceId,
//                    "cdmNo": credential.dtm.cdmNo,
//                ], uniquingKeysWith: { $1 }))
//            }
//            return
//        }
    }
}
