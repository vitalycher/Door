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
    
    enum Door {
        case glass
        case iron
    }
    
    static var defaults: UserDefaults = UserDefaults(suiteName: "group.com.111minutes.thedoor")!

    static func getUserToken() -> String? {
        return defaults.object(forKey: "kAuthToken") as? String
    }
    
    static func setUserToken(_ token : String) {
        defaults.set(token, forKey: "kAuthToken")
    }
    
    static func logoutUser() {
        defaults.set(nil, forKey: "kAuthToken")
    }
    
    static func loginUser(_ login: String, password: String, completion: @escaping (_ token: String?, _ errorMessage: String?) -> Void) {
        
        Alamofire.request(APIConstants.DoorAPI.logIn, method: .post, parameters: ["email": login, "password" : password], encoding: JSONEncoding.default).responseJSON { response in

            if let jsonDictionary = response.result.value as? Dictionary<String, AnyObject> {
                
                completion(jsonDictionary["auth_token"] as? String,
                           jsonDictionary["errors"] as? String)
                
            } else if let error = response.error {
                completion(nil, error.localizedDescription)
            } else {
                completion(nil, "Unknown error")
            }
        }
    }
    
    static func resetPassword(_ email: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        
        Alamofire.request(APIConstants.DoorAPI.resetPassword, method: .post, parameters: ["email": email], encoding: JSONEncoding.default).responseJSON { response in
            
            if let error = response.error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
        
    static func openGlassDoor(_ completion: @escaping (_ errorMessage: String?) -> ()) {
        
        self.openDoor(madeOf: .glass, completion: completion)
    }
    
    static func openIronDoor(_ completion: @escaping (_ errorMessage: String?) -> ()) {
        
        self.openDoor(madeOf: .iron, completion: completion)
    }

    static func openDoor(madeOf: Door, completion: @escaping (_ errorMessage: String?) -> ()) {
        
        guard let authToken = getUserToken() else {
            completion("Unauthorized")
            return
        }
        
        let path = madeOf == .glass ? APIConstants.DoorAPI.glassDoor : APIConstants.DoorAPI.ironDoor
        
        Alamofire.request(path, method: .post, encoding: JSONEncoding.default, headers: ["AUTH-TOKEN": authToken]).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                completion(nil)
            } else if let jsonDictionary = response.result.value as? Dictionary<String, AnyObject>,
                let errorMessage = jsonDictionary["errors"] as? String {
                completion(errorMessage)
            } else if let error = response.error {
                completion(error.localizedDescription)
            }
        }
    }

    static func getQuote(_ completion: @escaping (_ quoteText: String?, _ quoteAuthor: String?) -> Void)  {
        
        Alamofire.request(APIConstants.ForismaticAPI.getQuote, encoding: JSONEncoding.default).responseJSON { response in
            
            if let jsonDictionary = response.result.value as? Dictionary<String, AnyObject> {
                completion(jsonDictionary["quoteText"] as? String,
                           jsonDictionary["quoteAuthor"] as? String)
            } else {
                completion(nil, nil)
            }
        }
    }
}

