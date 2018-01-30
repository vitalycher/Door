//
//  GyroscopeManager.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/21/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

protocol GyroscopeDataTransmittable: class {
    func gyroscopeDidUpdateVector(vector: CGVector, gyroscope: GyroscopeManager)
}

class GyroscopeManager {
    
    weak var delegate: GyroscopeDataTransmittable?
    private var motionManager = CMMotionManager()
    private let defaults = UserDefaults.standard
    
    private func startUpdates(timeInterval: TimeInterval = 0.2) {
        motionManager.gyroUpdateInterval = timeInterval
        guard !motionManager.isGyroActive else { return }
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                if data.rotationRate.x > 0.1 || data.rotationRate.y > 0.1 || data.rotationRate.z > 0.1 {
                    self.calculateNewVector(motion: data, error: error)
                }
            }
        }
    }
    
    public func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func calculateNewVector(motion: CMDeviceMotion, error: Error?) {
        if let error = error { print(error) }
        
        let gravity: CMAcceleration = motion.gravity;
        let x = CGFloat(gravity.x);
        let y = CGFloat(gravity.y);
        var point = CGPoint.init(x: x, y: y)
        
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            let temp = point.x
            point.x = 0 - point.y
            point.y = temp
        case .landscapeRight:
            let temp = point.x
            point.x = point.y
            point.y = 0 - temp
        case .portraitUpsideDown:
            point.x *= -1
            point.y *= -1
        default: break
        }
        let updatedVector = CGVector.init(dx:  point.x, dy: 0.0 - point.y)
        delegate?.gyroscopeDidUpdateVector(vector: updatedVector, gyroscope: self)
    }
    
    public func startOrStopGyroscopeDependingOnSettings(gyroscopeDeactivationBlock: () -> Void) {
        guard defaults.bool(forKey: UserDefaultsKeys.gyroscopeEnabledBySettings.rawValue) else {
            stopUpdates()
            gyroscopeDeactivationBlock()
            return
        }
        startUpdates()
    }
    
}
