//
//  DataRequest.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Alamofire
import Foundation
import QuantumLeap

extension DataRequest {
    @discardableResult
    func validateWith() -> Self {
        let decoder: JSONDecoder = .init()

        return validate { _, _, data in
            ValidationResult(catching: {
                if let data: Data = data {
                    #if DEBUG
//                    if let object: [String: Any] = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                       let data: Data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
//                        Logger.debug("Response Data: \(String(data: data, encoding: .utf8)!)")
//                    }
                    #endif
                    if let result = try? decoder.decode(DkResult.DkDenmoku.self, from: data) {
                        Logger.debug("Parse DkResult.DkDenmoku: \(result.result)")
                        if ![DkDamResult.damConnectOk, DkDamResult.damSeparateOk, DkDamResult.loginOk].contains(result.result) {
                            throw result
                        }
                    }
                    if let result = try? decoder.decode(DkResult.DkWebSys.self, from: data) {
                        Logger.debug("Parse DkResult.DkWebSys: \(result.result.statusCode)")
                        if result.result.statusCode != 0 {
                            throw result.result
                        }
                    }
                    if let result = try? decoder.decode(DkResult.DkMinsei.self, from: data) {
                        Logger.debug("Parse DkResult.DkMinsei: \(result.statusCode)")
                        if result.statusCode != 0 {
                            throw result
                        }
                    }
                }
            })
        }
    }
}
