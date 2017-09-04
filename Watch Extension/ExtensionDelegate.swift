//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by Vitaly Chernysh on 8/31/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        WatchSessionManager.sharedManager.startSession()
    }
    
}
