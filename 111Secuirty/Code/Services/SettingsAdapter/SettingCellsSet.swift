//
//  SettingsCellsSet.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/16/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

enum SettingType {
    case voiceRecognition
    case squaresWaterfall
    case gyroscope
    case siri
    
    var localized: String {
        switch self {
        case .voiceRecognition:
            return NSLocalizedString("Voice control", comment: "")
        case .squaresWaterfall:
            return NSLocalizedString("Squares waterfall", comment: "")
        case .gyroscope:
            return NSLocalizedString("Gyroscope", comment: "")
        case .siri:
            return NSLocalizedString("Siri", comment: "")
        }
    }
    
}

struct SettingCellsSet {
    private var cellsAlliance: [SettingType] = [.voiceRecognition, .squaresWaterfall, .gyroscope, .siri]
    
    public func settingsCells() -> [SettingType] {
        return cellsAlliance
    }
}
