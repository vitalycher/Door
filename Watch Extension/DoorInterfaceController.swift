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
    
    @IBOutlet private var activityLoaderImage: WKInterfaceImage!
    private let userDefaults = UserDefaults.standard
    
    override func willActivate() {
        super.willActivate()
        
        activityLoaderInitialSetup()
    }
    
    @IBAction private func openGlassDoor() {
        showActivityLoader()
        guard let authToken = getUserToken() else {
            WKInterfaceDevice().play(.failure)
            showUnauthorizedAlert()
            return
        }
        
        SessionManager.openGlassDoor(preparedToken: authToken) { _ in
            WKInterfaceDevice().play(.success)
            self.hideActivityLoader()
            self.showWelcomeAlert()
        }
    }
    
    @IBAction private func openIronDoor() {
        showActivityLoader()
        guard let authToken = getUserToken() else {
            WKInterfaceDevice().play(.failure)
            showUnauthorizedAlert()
            return
        }
        
        SessionManager.openIronDoor(preparedToken: authToken) { _ in
            WKInterfaceDevice().play(.success)
            self.hideActivityLoader()
            self.showWelcomeAlert()
        }
    }
    
    private func showUnauthorizedAlert() {
        let action = WKAlertAction(title: NSLocalizedString("Horosho", comment: ""), style: .default) { }
        presentAlert(withTitle: NSLocalizedString("Unauthorized", comment: ""), message: NSLocalizedString("Please, login on your device.", comment: ""), preferredStyle: .alert, actions: [action])
    }
    
    private func showWelcomeAlert() {
        let action = WKAlertAction(title: NSLocalizedString("Spasibo", comment: ""), style: .default) { }
        presentAlert(withTitle: NSLocalizedString("Welcome!", comment: ""), message: nil, preferredStyle: .alert, actions: [action])
    }
    
    private func getUserToken() -> String? {
        return userDefaults.object(forKey: UserDefaultsKeys.userToken.rawValue) as? String
    }
    
    private func showActivityLoader() {
        activityLoaderImage.setHidden(false)
        activityLoaderImage.setImageNamed("Activity")
        activityLoaderImage.startAnimatingWithImages(in: NSMakeRange(1, 15), duration: 3.0, repeatCount: 0)
    }
    
    private func hideActivityLoader() {
        activityLoaderImage.stopAnimating()
        activityLoaderImage.setHidden(true)
    }
    
    private func activityLoaderInitialSetup() {
        activityLoaderImage.setHeight(25.0)
        activityLoaderImage.setWidth(25.0)
        activityLoaderImage.setHidden(true)
    }

}
