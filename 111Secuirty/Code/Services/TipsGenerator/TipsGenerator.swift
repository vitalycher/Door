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
                NSLocalizedString("Just tell 'it is me' and let the magic happen.", comment: "")]
    
    public func generateTip() -> String {
        let randomPhraseNumber = arc4random_uniform(UInt32(tips.count))
        return tips[Int(randomPhraseNumber)]
    }
    
}
