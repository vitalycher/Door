//
//  APIManager.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class SessionManager {
    
    static func getUserToken() -> String? {
       
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults.objectForKey("kAuthToken") as? String
    }
    
    static func setUserToken(token : String) {
       
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(token, forKey: "kAuthToken")
    }
    
    static func logoutUser() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(nil, forKey: "kAuthToken")
    }
    
    static func loginUser(login: String, password: String, succes : (token : String?) -> Void) {
       
        Alamofire.request(.POST, APIConstants.logIn, parameters: ["email": login, "password" : password])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                  
                    let response = JSON as! NSDictionary
                    let authToken = response["auth_token"] as? String
                    
                    succes(token: authToken)
                    
                }
        }
    }
    
    static func openGlassDoor() {
        
        if let authToken = getUserToken() {
            
            HUD.show(.Progress)
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, APIConstants.glassDoor , headers : headers)
                .responseJSON { response in
                    
                    HUD.flash(.Label("Welcome!"), delay:1.0)
            }
        }
        
    }
    
    static func openIronDoor() {
        
        if let authToken = getUserToken() {
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, APIConstants.ironDoor, headers : headers)
                .responseJSON { response in
                    
                    HUD.flash(.Label("Welcome!"), delay:1.0)
            }
        }
    }
    
    static func resetPassword(email: String) {
        
        Alamofire.request(.POST, APIConstants.resetPassword, parameters: ["email": email])
            .responseJSON { response in
                HUD.flash(.Label(NSLocalizedString("Password reset instructions have been sent to your email", comment: "")), delay:1.0)
        }
    }
}

