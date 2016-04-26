//
//  APIManager.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import Alamofire

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
       
        Alamofire.request(.POST, "https://door.111min.com/api/sessions", parameters: ["email": login, "password" : password])
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
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, "https://door.111min.com/api/glass_door", headers : headers)
        }
        
    }
    
    static func openIronDoor() {
        
        if let authToken = getUserToken() {
            
            let headers = ["AUTH-TOKEN" : authToken]
            Alamofire.request(.POST, "https://door.111min.com/api/iron_door", headers : headers)
        }
    }
}

