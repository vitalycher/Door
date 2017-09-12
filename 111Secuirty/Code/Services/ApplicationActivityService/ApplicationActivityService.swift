//
//  ApplicationActivityService.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 9/12/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class ApplicationActivityService: NSObject {
    
    private var cancelClosure: (() -> Void)?
    private var activeClosure: (() -> Void)?
    var isActive = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func initWith(cancelClosure: @escaping () -> Void, activeClosure: @escaping () -> Void) {
        self.cancelClosure = cancelClosure
        self.activeClosure = activeClosure
    }
    
    @objc private func applicationWillResignActive() {
        if let cancelClosure = cancelClosure, isActive {
            cancelClosure()
        }
    }
    
    @objc private func applicationDidBecomeActive() {
        if let activeClosure = activeClosure, isActive {
            activeClosure()
        }
    }
    
}
