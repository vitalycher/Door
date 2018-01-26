//
//  ApplicationActivityService.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 9/12/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class ApplicationActivityService: NSObject {
    
    var isActive = true
    
    private var cancelClosure: (() -> Void)?
    private var activeClosure: (() -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    func initWith(cancelClosure: @escaping () -> Void, activeClosure: @escaping () -> Void) {
        self.cancelClosure = cancelClosure
        self.activeClosure = activeClosure
    }
    
    @objc private func applicationDidEnterBackground() {
        if let cancelClosure = cancelClosure, isActive {
            cancelClosure()
        }
    }
    
    @objc private func applicationWillEnterForeground() {
        if let activeClosure = activeClosure, isActive {
            activeClosure()
        }
    }
    
}
