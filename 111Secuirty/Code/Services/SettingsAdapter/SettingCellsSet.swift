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
    
    var localized: String {
        switch self {
        case .voiceRecognition:
            return NSLocalizedString("Voice recognition", comment: "")
        case .squaresWaterfall:
            return NSLocalizedString("Squares waterfall", comment: "")
        case .gyroscope:
            return NSLocalizedString("Gyroscope", comment: "")
        }
    }
    
}

struct SettingCellsSet {
    
    private var cellsAlliance: [SettingType] = [.voiceRecognition, .squaresWaterfall, .gyroscope]
    
    public func settingsCells() -> [SettingType] {
        return cellsAlliance
    }
    
}
