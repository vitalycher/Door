//
//  Gyroscopable.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/20/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

private struct AssociatedKeys {
    static var GyroscopeAssociatedKey = "GyroscopeAssociatedKey"
}

protocol Gyroscopable: class {
    var gyroscope: GyroscopeManagerViewController { get }
    func vectorDidUpdate(with vector: CGVector)
}

extension Gyroscopable where Self: UIViewController {
    
    var gyroscope: GyroscopeManagerViewController {
        get {
            var gyroscope = objc_getAssociatedObject(self, &AssociatedKeys.GyroscopeAssociatedKey) as? GyroscopeManagerViewController
            
            if (gyroscope == nil) {
                gyroscope = GyroscopeManagerViewController()
                
                objc_setAssociatedObject(self, &AssociatedKeys.GyroscopeAssociatedKey, gyroscope, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                attachMenuToParent()
            }
            return gyroscope!
        }
    }
    
    private func attachMenuToParent() {
        let gyroscopeManagerViewController = GyroscopeManagerViewController()
        addChildViewController(gyroscopeManagerViewController)
        view.addSubview(gyroscopeManagerViewController.view)
        gyroscopeManagerViewController.didMove(toParentViewController: self)
    }
    
}
