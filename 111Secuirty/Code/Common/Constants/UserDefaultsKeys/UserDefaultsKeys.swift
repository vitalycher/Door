//
//  UserDefaultsKeys.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/30/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case userToken = "userToken"

    case squaresWaterfallEnabledBySettings = "squaresWaterfallEnabled"
    case voiceRecognitionEnabledBySettings = "voiceRecognitionEnabled"
    case gyroscopeEnabledBySettings = "gyroscopeEnabled"
    case siriEnabledBySettings = "siriEnabled"
    case siriVocabularyExtended = "siriVocabularyExtended"
}
