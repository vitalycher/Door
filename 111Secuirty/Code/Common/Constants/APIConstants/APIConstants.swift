//
//  APIConstants.swift
//  111Secuirty
//
//  Created by Andrey Sokur on 29.04.16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import Foundation

struct APIConstants {
    static let baseUrl = "https://door.111min.com/api/"
    
    static let logIn            = baseUrl + "sessions"
    static let glassDoor        = baseUrl + "glass_door"
    static let ironDoor         = baseUrl + "iron_door"
    static let resetPassword    = baseUrl + "reset_password"
}

