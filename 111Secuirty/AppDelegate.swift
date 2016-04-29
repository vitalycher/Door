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
    
   static func fillteredArray(array : [Int], f : (number : Int) -> Bool) {
        f(number: 1)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            
            window.backgroundColor = UIColor.whiteColor()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if SessionManager.getUserToken() != nil {
                window.rootViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
            } else {
                window.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            }
            
            IQKeyboardManager.sharedManager().enable = true
            
            window.makeKeyAndVisible()
        }
        
        return true
    }

}

