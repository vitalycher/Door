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
import WatchConnectivity


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let session = WCSession.default
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.backgroundColor = UIColor.white
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        initWatchConnectivitySession()

        if SessionManager.getUserToken() != nil {
            
            
            let message = ["auth" : SessionManager.getUserToken() != nil]
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            
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
    
    private func initWatchConnectivitySession() {
        session.delegate = self
        session.activate()
    }
    
    private func extendSiriVocabulary() {
        let vocabulary = [SiriVocabulary.glassDoor, SiriVocabulary.ironDoor]
        let vocabularySet = NSOrderedSet(array: vocabulary)
        INVocabulary.shared().setVocabularyStrings(vocabularySet, of: .workoutActivityName)
    }
 
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
}
