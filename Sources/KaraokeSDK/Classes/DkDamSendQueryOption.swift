//
//  DkDamSendQueryOption.swift
//  KaraokeSDK
//
//  Created by devonly on 2025/08/09.
//

import Foundation
import SwiftUI

public final class DkDamSendQueryOption: ObservableObject {
    @Published
    public var guideMelody: GuideMelody = .OFF

    @Published
    public var guideVocal: GuideVocal = .OFF

    @Published
    public var telopSize: TelopSize = .DEFAULT

    @Published
    public var fadeOut: FadeOut = .NO_FADEOUT

    @Published
    public var showTitle: Bool = true

    @Published
    public var showMelodyLine: Bool = false

    public enum GuideMelody: Int, ToggleTypeEnum {
        case OFF
        case DEFAULT
        case LARGE
    }

    public enum GuideVocal: Int, ToggleTypeEnum {
        case OFF
        case DEFAULT
        case SMALL
        case LARGE
        case ASSIST
    }

    public enum TelopSize: Int, ToggleTypeEnum {
        case OFF
        case DEFAULT
        case SMALL
        case LARGE
    }

    public enum FadeOut: Int, ToggleTypeEnum {
        case OFF
        case ONE_CHORUS
        case TWO_CHORUS
        case CODA
        case NO_FADEOUT
    }

    public init() {}
}

public protocol ToggleTypeEnum: RawRepresentable, Equatable, CaseIterable where RawValue == Int {
    mutating func toggle()
}

extension ToggleTypeEnum {
    public mutating func toggle() {
        if let index = Self.allCases.firstIndex(of: self) {
            let nextIndex = Self.allCases.index(after: index)
            self = Self.allCases[nextIndex == Self.allCases.endIndex ? Self.allCases.startIndex : nextIndex]
        }
    }

    var description: String {
        NSLocalizedString("\(Self.self)_\(String(describing: self))".uppercased(), bundle: .module, comment: "")
    }
}

public extension Text {
    init(_ value: some ToggleTypeEnum) {
        self.init(value.description)
    }
}
