//
//  GyroscopeManagerViewController.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/20/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit
import CoreMotion

class GyroscopeManagerViewController: UIViewController {
    
    private var motionManager = CMMotionManager()
    weak var delegate: Gyroscopable?

    override func loadView() {
       view = UIView(frame: CGRect.init())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let data = data {
                if data.rotationRate.x > 0.1 || data.rotationRate.y > 0.1 || data.rotationRate.z > 0.1 {
                    self.gyroscopeVectorDidUpdate(motion: data, error: error)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopDeviceMotionUpdates()
    }
    
    public func gyroscopeVectorDidUpdate(motion: CMDeviceMotion, error: Error?) {
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
        print(CGVector.init(dx: point.x, dy: 0.0 - point.y))
        delegate?.vectorDidUpdate(with: CGVector.init(dx: point.x, dy: 0.0 - point.y))
    }
    
//    public func disable() {
//        motionManager = nil
//    }

}
