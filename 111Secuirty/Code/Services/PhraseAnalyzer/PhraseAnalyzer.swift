//
//  PhraseAnalyzer.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/8/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

protocol Analyzable { }

enum DoorType: Analyzable {
    case iron
    case glass
}

enum SecondaryType: Analyzable {
    case clean
    case logout
}

class PhraseAnalyzer {
    
    private let doorKeywords: [String : Analyzable] = ["open glass door" : DoorType.glass,
                                                       "glass door" : DoorType.glass,
                                                       "bitch" : DoorType.glass,
                                                       "hello minutes" : DoorType.glass,
                                                       "open iron door" : DoorType.iron,
                                                       "iron door" : DoorType.iron,
                                                       "clean" : SecondaryType.clean,
                                                       "log out": SecondaryType.logout]
    
    func analyze(_ phrase: String, successfulAnalysis: (Analyzable) -> Void)  {
        for key in doorKeywords.keys {
            if phrase.lowercased().contains(key) {
                if let doorType = doorKeywords[key] as? DoorType {
                    doorType == DoorType.glass ? successfulAnalysis(DoorType.glass) : successfulAnalysis(DoorType.iron)
                } else if let secondaryType = doorKeywords[key] as? SecondaryType {
                    if secondaryType == .clean { successfulAnalysis(SecondaryType.clean) }
                }
                break
            }
        }
    }
    
}
