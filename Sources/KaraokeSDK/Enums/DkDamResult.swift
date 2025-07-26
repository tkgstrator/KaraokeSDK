//
//  DkDamResult.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/07/14.
//

import Foundation
import SwiftUICore

public enum DkDamResult: String, Decodable, Sendable, CaseIterable {
    case paramInjusticeError = "PARAM_INJUSTICE_ERROR"
    case loginOk = "LOGIN_OK"
    case authenticateError = "AUTHENTICATE_ERROR"
    case damConnectOk = "DAM_CONNECT_OK"
    case damConnectError = "DAM_CONNECT_ERROR"
    case damQrValidTimeout = "DAM_QR_VALID_TIMEOUT"
    case damPairingTimeout = "DAM_PAIRING_TIMEOUT"
    case damSeparateOk = "DAM_SEPARATE_OK"
    case remoconSendOk = "REMOCONSEND_OK"
    case remoconSendTimeout = "REMOCONSEND_TIMEOUT"
    case damSendError = "DAM_SEND_ERROR"
    case pictureSendOk = "PICTURESEND_OK"
    case pictureSendError = "PICTURESEND_ERROR"
    case damConnectErrorR = "DAM_CONNECT_ERROR_R"
}
