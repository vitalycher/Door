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
    case quote
}

enum NavigationalKeyword: Analyzable {
    case logout
    case back
    case settings
}

class PhraseAnalyzer {
    
    private let keywords: [String : Analyzable] = ["open glass door" : DoorKeyword.glass,
                                           "glass door" : DoorKeyword.glass,
                                           "bitch" : DoorKeyword.glass,
                                           "hello minutes" : DoorKeyword.glass,
                                           "open iron door" : DoorKeyword.iron,
                                           "iron door" : DoorKeyword.iron,
                                           "clean" : SecondaryKeyword.clean,
                                           "log out" : NavigationalKeyword.logout,
                                           "settings" : NavigationalKeyword.settings,
                                           "back" : NavigationalKeyword.back,
                                           "first door" : DoorKeyword.iron,
                                           "update" : SecondaryKeyword.quote]
    
    public func analyzePhrase(_ phrase: String, successfulAnalysis: (Analyzable) -> Void)  {
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
