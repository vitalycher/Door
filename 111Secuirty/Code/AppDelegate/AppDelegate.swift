//
//  AppDelegate.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Intents


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.backgroundColor = UIColor.white
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if SessionManager.getUserToken() != nil {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        } else {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        IQKeyboardManager.shared().isEnabled = true
        window?.makeKeyAndVisible()
        requestSiriAuthorization()
        
        let vocabulary = [SiriVocabulary.glassDoor, SiriVocabulary.ironDoor]
        let vocabularySet = NSOrderedSet(array: vocabulary)
        INVocabulary.shared().setVocabularyStrings(vocabularySet, of: .workoutActivityName)
        
        return true
    }
    
    private func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Hi, Siri!")
            } else {
                print("Bye, Siri!")
            }
        }
    }

}
