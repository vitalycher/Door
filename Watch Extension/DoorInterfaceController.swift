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
    
    let session = WCSession.default
    
    override func willActivate() {
        super.willActivate()
        
        initSession()
    }
    
    @IBAction private func openGlassDoor() {
//        SessionManager.openGlassDoor { _ in
//            print("glass")
//        }
    }
    
    @IBAction private func openIronDoor() {
//        SessionManager.openIronDoor { _ in
//            print("iron")
//        }
    }
    
    private func initSession() {
        session.delegate = self
        session.activate()
    }
    
}

extension DoorInterfaceController: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
}
