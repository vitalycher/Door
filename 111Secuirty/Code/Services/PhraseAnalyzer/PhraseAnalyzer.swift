//
//  PhraseAnalyzer.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/8/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

protocol Analyzable { }

enum DoorKeyword: Analyzable {
    case iron
    case glass
}

enum SecondaryKeyword: Analyzable {
    case clean
    case logout
    case settings
    case back
}

class PhraseAnalyzer {
    
    let keywords: [String : Analyzable] = ["open glass door" : DoorKeyword.glass,
                                           "glass door" : DoorKeyword.glass,
                                           "bitch" : DoorKeyword.glass,
                                           "hello minutes" : DoorKeyword.glass,
                                           "open iron door" : DoorKeyword.iron,
                                           "iron door" : DoorKeyword.iron,
                                           "clean" : SecondaryKeyword.clean,
                                           "log out" : SecondaryKeyword.logout,
                                           "settings" : SecondaryKeyword.settings,
                                           "back" : SecondaryKeyword.back]
    
    func analyzePhrase(_ phrase: String, successfulAnalysis: (Analyzable) -> Void)  {
        for key in keywords.keys {
            if phrase.lowercased().contains(key) {
                if let analyzedType = keywords[key] {
                    successfulAnalysis(analyzedType)
                    return
                }
            }
        }
    }

}
    
//    func analyzePhrase(_ phrase: String, byCriteria criteria: [SecondaryKeyword], successfulAnalysis: (Analyzable) -> Void)  {
//        for key in doorKeywords.keys {
//            if phrase.lowercased().contains(key) {
//                if let doorType = doorKeywords[key] as? DoorKeyword {
//                    doorType == DoorKeyword.glass ? successfulAnalysis(DoorKeyword.glass) : successfulAnalysis(DoorKeyword.iron)
//                } else if let secondaryType = doorKeywords[key] as? SecondaryKeyword {
//                    switch secondaryType {
//                    case .clean: successfulAnalysis(SecondaryKeyword.clean)
//                    case .back: successfulAnalysis(SecondaryKeyword.back)
//                    case .logout: successfulAnalysis(SecondaryKeyword.logout)
//                    case .settings: successfulAnalysis(SecondaryKeyword.settings)
//                    }
//                }
//                break
//            }
//        }
//    }
