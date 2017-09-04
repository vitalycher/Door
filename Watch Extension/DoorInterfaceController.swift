//
//  DoorInterfaceController.swift
//  Watch Extension
//
//  Created by Vitaly Chernysh on 8/31/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DoorInterfaceController: WKInterfaceController {
    
    private let userDefaults = UserDefaults.standard
    
    @IBAction private func openGlassDoor() {
        guard let authToken = getUserToken() else {
            showUnauthorizedAlert()
            return
        }
        
        SessionManager.openGlassDoor(hardcodedToken: authToken) { _ in
            self.showWelcomeAlert()
        }
    }
    
    @IBAction private func openIronDoor() {
        guard let authToken = getUserToken() else {
            showUnauthorizedAlert()
            return
        }
        
        SessionManager.openIronDoor(hardcodedToken: authToken) { _ in
            self.showWelcomeAlert()
        }
    }
    
    private func showUnauthorizedAlert() {
        presentAlert(withTitle: "Unauthorized", message: "Please, login on your device.", preferredStyle: .alert, actions: [])
    }
    
    private func showWelcomeAlert() {
        let action = WKAlertAction(title: "Spasibo", style: .default) { }
        presentAlert(withTitle: "Welcome!", message: nil, preferredStyle: .alert, actions: [action])
    }
    
    private func getUserToken() -> String? {
        return userDefaults.object(forKey: UserDefaultsKeys.userToken.rawValue) as? String
    }

}
