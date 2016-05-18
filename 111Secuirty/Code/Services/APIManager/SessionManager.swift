//
//  APIManager.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import Alamofire
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
    
    static func loginUser(login: String, password: String, completion: (token: String?, error: NSError?) -> Void) {
       
        Alamofire.request(.POST, APIConstants.DoorAPI.logIn, parameters: ["email": login, "password" : password])
        .responseJSON { response in
                
            if let JSON = response.result.value {
              
                let response = JSON as! NSDictionary
                let authToken = response["auth_token"] as? String
                
                completion(token: authToken, error: nil)
            }
        }
        .response { request, response, data, error in
            completion(token: nil, error: error)
        }
    }
    
    static func resetPassword(email: String, completion: (error: NSError?) -> Void) {
        
        Alamofire.request(.POST, APIConstants.DoorAPI.resetPassword, parameters: ["email": email])
        .response { request, response, data, error in
            completion(error: error)
        }
    }    
        
    static func openGlassDoor(completion: ((error: NSError?, errorString: String?) -> ())?) {
        
        self.openDoorWithMethod(APIConstants.DoorAPI.glassDoor, completion: completion)
    }
    
    static func openIronDoor(completion: ((error: NSError?, errorString: String?) -> ())?) {
        
        self.openDoorWithMethod(APIConstants.DoorAPI.ironDoor, completion: completion)
    }

    static func openDoorWithMethod(method: URLStringConvertible, completion: ((error: NSError?, errorString: String?) -> ())?) {
        if let authToken = getUserToken() {
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, method, headers : headers)
                .response { request, response, data, error in
                    completion?(error: error, errorString: nil)
            }
        } else {
            completion?(error: nil, errorString: NSLocalizedString("Something wrong. Please log out and log in again", comment: ""))
        }
    }

    static func getQuote(completion: (quoteText: String?, quoteAuthor: String?, quoteError: NSError?) -> Void)  {
        
        Alamofire.request(.POST, APIConstants.ForismaticAPI.getQuote,
            parameters: ["method": "getQuote", "format" : "json", "key" : "door", "lang" : "en"])
            
        .responseJSON { response in
                
            if let JSON = response.result.value {
                
                let response = JSON as! NSDictionary
                
                completion(quoteText: response["quoteText"] as? String,
                         quoteAuthor: response["quoteAuthor"] as? String,
                          quoteError: nil)
            }
        }
            
        .response { request, response, data, error in
            completion(quoteText: nil,
                     quoteAuthor: nil,
                      quoteError: error)
        }
    }
}

