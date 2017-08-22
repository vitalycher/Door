//
//  SpeechRecognizable.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/22/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

import UIKit

protocol SpeechRecognizable: class, SpeechRecognizerDelegate {
    var speechRecognizer: SpeechRecognizer { get }
}

extension SpeechRecognizable where Self: UIViewController {
    
    var speechRecognizer: SpeechRecognizer {
        get {
            var speechRecognizer = objc_getAssociatedObject(self, &RuntimeAssociatedKeys.SpeechRecognizerAssociatedKey) as? SpeechRecognizer
            
            if (speechRecognizer == nil) {
                speechRecognizer = SpeechRecognizer()
                objc_setAssociatedObject(self, &RuntimeAssociatedKeys.SpeechRecognizerAssociatedKey, speechRecognizer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                speechRecognizer?.delegate = self
            }
            
            return speechRecognizer!
        }
    }
    
}
