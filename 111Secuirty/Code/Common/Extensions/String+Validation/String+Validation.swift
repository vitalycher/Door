//
//  String+Validation.swift
//  111Secuirty
//
//  Created by Andrey Sokur on 04.05.16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        do {
            let emailRegex = try NSRegularExpression(pattern:"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}",
                                                     options: .CaseInsensitive)
            
            return emailRegex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0),
                                                 range: NSMakeRange(0, self.characters.count)) != nil

        } catch {
            return false
        }
    }
}