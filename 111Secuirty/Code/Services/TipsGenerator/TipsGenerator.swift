//
//  TipsGenerator.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/11/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

class TipsGenerator {
    
    private let tips = [NSLocalizedString("You can open the glass door by saying 'Hello, Minutes!'", comment: ""),
                NSLocalizedString("Have a nice day!", comment: ""),
                NSLocalizedString("You are late again!", comment: ""),
                NSLocalizedString("You look great today!", comment: ""),
                NSLocalizedString("Tell Siri: 'Start workout using Key' and see what happens.", comment: ""),
                NSLocalizedString("Iron door could be opened by 'First Door' keyphrase.", comment: ""),
                NSLocalizedString("Enable voice recognition in Settings to open doors by your voice.", comment: ""),
                NSLocalizedString("Update the quote with 'Update Quote' keyphrase c:", comment: ""),
                NSLocalizedString("New quote could be set by saying 'Update Quote'", comment: ""),
                NSLocalizedString("Don't tell Siri that this isn't Fitness app.", comment: ""),
                NSLocalizedString("Shake your phone to clean all falling keys.", comment: ""),
                NSLocalizedString("You can set a new quote by saying 'Update'.", comment: "")]

    public func generateTip() -> String {
        let randomPhraseNumber = arc4random_uniform(UInt32(tips.count))
        return tips[Int(randomPhraseNumber)]
    }
    
}
