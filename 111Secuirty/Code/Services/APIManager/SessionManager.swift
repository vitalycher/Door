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
import NotificationCenter

class SessionManager {
    static var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.111minutes.thedoor")!

    
    static func getUserToken() -> String? {
        return defaults.objectForKey("kAuthToken") as? String
    }
    
    static func setUserToken(token : String) {
        defaults.setObject(token, forKey: "kAuthToken")
        defaults.synchronize()
    }
    
    static func logoutUser() {
        defaults.setObject(nil, forKey: "kAuthToken")
        defaults.synchronize()
    }
    
    static func loginUser(login: String, password: String, succes : (token : String?) -> Void) {
       
        Alamofire.request(.POST, APIConstants.DoorAPI.logIn, parameters: ["email": login, "password" : password])
        .responseJSON { response in
                
            if let JSON = response.result.value {
              
                let response = JSON as! NSDictionary
                let authToken = response["auth_token"] as? String
                
                succes(token: authToken)
                
            }
        }
        .response { request, response, data, error in
            if (error != nil) {
                HUD.flash(.Label("\(error!.localizedDescription)"), delay:1.0)
            }
        }
    }
    
    static func openGlassDoor() {
        
        if let authToken = getUserToken() {
            
            HUD.show(.Progress)
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, APIConstants.DoorAPI.glassDoor , headers : headers)
                .responseJSON { response in
                    
                    HUD.flash(.Label("Welcome!"), delay:1.0)
            }
        }
        
    }
    
    static func openIronDoor() {
        
        if let authToken = getUserToken() {
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, APIConstants.DoorAPI.ironDoor, headers : headers)
                .responseJSON { response in
                    
                    HUD.flash(.Label("Welcome!"), delay:1.0)
            }
        }
    }
    
    static func resetPassword(email: String) {
        
        Alamofire.request(.POST, APIConstants.DoorAPI.resetPassword, parameters: ["email": email])
        .responseJSON { response in
            HUD.flash(.Label(NSLocalizedString("Password reset instructions have been sent to your email", comment: "")), delay:1.0)
        }
        .response { request, response, data, error in
            if (error != nil) {
                HUD.flash(.Label("\(error!.localizedDescription)"), delay:1.0)
            }
        }
    }
    
    
    static func getQuote(succes: (quoteText: String?, quoteAuthor: String?) -> Void)  {
        var quoteText: String?
        var quoteAuthor: String?
        
        Alamofire.request(.POST, APIConstants.ForismaticAPI.getQuote,
            parameters: ["method": "getQuote", "format" : "json", "key" : "door", "lang" : "en"])
            
        .responseJSON { response in
                
            if let JSON = response.result.value {
                
                let response = JSON as! NSDictionary
                quoteText = response["quoteText"] as? String
                quoteAuthor = response["quoteAuthor"] as? String
                
                succes(quoteText: quoteText, quoteAuthor: quoteAuthor)
            }
            
        }
    }
}

