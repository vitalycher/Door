//
//  APIConstants.swift
//  111Secuirty
//
//  Created by Andrey Sokur on 29.04.16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import Foundation


struct APIConstants {
    
    struct DoorAPI {
        static let baseUrl = "http://door.111minutes.com/api"

        static let logIn            = baseUrl + "/sessions"
        static let glassDoor        = baseUrl + "/glass_door"
        static let ironDoor         = baseUrl + "/iron_door"
        static let resetPassword    = baseUrl + "/reset_password"
    }
    
    struct ForismaticAPI {
        static let getQuote         = "http://api.forismatic.com/api/1.0/?method=getQuote&format=json&key=door&lang=en"
    }
}
