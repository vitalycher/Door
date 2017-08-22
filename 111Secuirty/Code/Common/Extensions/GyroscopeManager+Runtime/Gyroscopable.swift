//
//  Gyroscopable.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/20/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

protocol Gyroscopable: class, GyroscopeDataTransmittable {
    var gyroscopeManager: GyroscopeManager { get }
}

extension Gyroscopable where Self: UIViewController {
    
    var gyroscopeManager: GyroscopeManager {
        get {
            var gyroscopeManager = objc_getAssociatedObject(self, &RuntimeAssociatedKeys.GyroscopeAssociatedKey) as? GyroscopeManager
            
            if (gyroscopeManager == nil) {
                gyroscopeManager = GyroscopeManager()
                objc_setAssociatedObject(self, &RuntimeAssociatedKeys.GyroscopeAssociatedKey, gyroscopeManager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                gyroscopeManager?.delegate = self
            }
            
            return gyroscopeManager!
        }
    }
    
}
