//
//  AppDelegate.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import IQKeyboardManager


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
        
        return true
    }


}

