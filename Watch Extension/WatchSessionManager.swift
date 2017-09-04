//
//  WatchConnectivityService.swift
//  Watch Extension
//
//  Created by Vitaly Chernysh on 9/4/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    private let session: WCSession = WCSession.default
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    static let sharedManager = WatchSessionManager()
    
    private override init() {
        super.init()
    }
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
}

extension WatchSessionManager {
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let token = applicationContext[UserDefaultsKeys.userToken.rawValue] as? String {
                UserDefaults.standard.set(token, forKey: UserDefaultsKeys.userToken.rawValue)
            }
        }
    }
}
