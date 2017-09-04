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
        WatchSessionManager.sharedManager.startSession()
        
        if SessionManager.getUserToken() != nil {
            let message = ["userToken" : SessionManager.getUserToken()]
            
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        } else {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        IQKeyboardManager.shared().isEnabled = true
        window?.makeKeyAndVisible()
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.siriAuthorizationEnabled.rawValue) {
            requestSiriAuthorization()
        }
        
        return true
    }
    
    private func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.siriAuthorizationEnabled.rawValue)
                self.extendSiriVocabulary()
                print("Hi, Siri")
            } else {
                print("Bye, Siri!")
            }
        }
    }
    
    private func extendSiriVocabulary() {
        let vocabulary = [SiriVocabulary.glassDoor, SiriVocabulary.ironDoor]
        let vocabularySet = NSOrderedSet(array: vocabulary)
        INVocabulary.shared().setVocabularyStrings(vocabularySet, of: .workoutActivityName)
    }
 
}
