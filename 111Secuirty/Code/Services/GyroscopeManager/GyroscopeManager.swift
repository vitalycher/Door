//
//  GyroscopeManager.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/21/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import CoreMotion

protocol GyroscopeDataTransmittable: class {
    func gyroscopeDidTransferMotion(motion: CMDeviceMotion, error: Error?, gyroscope: GyroscopeManager)
}

class GyroscopeManager {
    
    weak var delegate: GyroscopeDataTransmittable?
    private var motionManager = CMMotionManager()
    
    public func startUpdates(timeInterval: TimeInterval = 0.2) {
        motionManager.gyroUpdateInterval = timeInterval
        guard !motionManager.isGyroActive else { return }
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                if data.rotationRate.x > 0.1 || data.rotationRate.y > 0.1 || data.rotationRate.z > 0.1 {
                    self.delegate?.gyroscopeDidTransferMotion(motion: data, error: error, gyroscope: self)
                }
            }
        }
    }
    
    public func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
}
