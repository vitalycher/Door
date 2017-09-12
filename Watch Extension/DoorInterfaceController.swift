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
        openDoor(madeOf: .glass)
    }
    
    @IBAction private func openIronDoor() {
       openDoor(madeOf: .iron)
    }
    
    private func openDoor(madeOf doorType: SessionManager.Door) {
        guard let authToken = userToken() else {
            WKInterfaceDevice().play(.failure)
            showAlert(with: NSLocalizedString("Unauthorized", comment: ""), message: NSLocalizedString("Please, login on your device.", comment: ""))
            return
        }
        showActivityLoader()
        
        SessionManager.openDoor(madeOf: doorType, preparedToken: authToken) { errorMessage in
            if let errorMessage = errorMessage {
                self.showAlert(with: NSLocalizedString("Error!", comment: ""), message: errorMessage)
                self.hideActivityLoader()
                WKInterfaceDevice().play(.failure)
                return
            }
            WKInterfaceDevice().play(.success)
            self.hideActivityLoader()
            self.showAlert(with: NSLocalizedString("Welcome!", comment: ""), message: nil)
        }
    }
    
    private func userToken() -> String? {
        return userDefaults.object(forKey: UserDefaultsKeys.userToken.rawValue) as? String
    }
    
    private func activityLoaderInitialSetup() {
        activityLoaderImage.setHeight(25.0)
        activityLoaderImage.setWidth(25.0)
        activityLoaderImage.setHidden(true)
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
    
    private func showAlert(with title: String, message: String?, actions: [WKAlertAction] = []) {
        let spasiboAction = WKAlertAction(title: NSLocalizedString("Spasibo", comment: ""), style: .default) { }
        presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: actions.isEmpty ? [spasiboAction] : actions)
    }

}
