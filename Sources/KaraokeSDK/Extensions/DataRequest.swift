//
//  DataRequest.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/15.
//

import Alamofire
import Foundation

extension DataRequest {
    @discardableResult
    func validateWith() -> Self {
        let decoder: JSONDecoder = .init()

        return validate { _, _, data in
            ValidationResult(catching: {
                if let data: Data = data {
                    if let result = try? decoder.decode(DkResult.DkDenmoku.self, from: data) {
                        if ![DkDamResult.damConnectOk, DkDamResult.damSeparateOk, DkDamResult.loginOk].contains(result.result) {
                            throw AFError.responseValidationFailed(reason: .customValidationFailed(error: DkError(result: result.result)))
                        }
                    }
                    if let result = try? decoder.decode(DkResult.DkWebSys.self, from: data) {
                        if result.result.statusCode != 0 {
                            throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: result.result.statusCode))
                        }
                    }
                }
            })
        }
    }
}
