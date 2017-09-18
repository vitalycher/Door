//
//  WatchSessionManager.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 9/4/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static let sharedManager = WatchSessionManager()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
}

extension WatchSessionManager {
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
}

extension WatchSessionManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
}
