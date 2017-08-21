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
    func gyroscopeVectorDidUpdate(with vector: CGVector, gyroscope: GyroscopeManagerViewController)
}

extension Gyroscopable where Self: UIViewController {
    
    var gyroscope: GyroscopeManagerViewController {
        get {
            var gyroscope = objc_getAssociatedObject(self, &AssociatedKeys.GyroscopeAssociatedKey) as? GyroscopeManagerViewController
            
            if (gyroscope == nil) {
                gyroscope = GyroscopeManagerViewController()
                objc_setAssociatedObject(self, &AssociatedKeys.GyroscopeAssociatedKey, gyroscope, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addChildViewController(gyroscope!)
                view.addSubview(gyroscope!.view)
                gyroscope!.didMove(toParentViewController: self)
                gyroscope?.delegate = self
            }
            
            return gyroscope!
        }
    }
    
}
