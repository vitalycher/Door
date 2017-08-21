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
    
    private var gyroscopeManager = GyroscopeManager()
    weak var delegate: Gyroscopable?
    
    override func loadView() {
       view = UIView(frame: CGRect.init())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gyroscopeManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gyroscopeManager.startUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        gyroscopeManager.stopUpdates()
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
        let updatedVector = CGVector.init(dx: point.x, dy: 0.0 - point.y)
        delegate?.gyroscopeVectorDidUpdate(with: updatedVector, gyroscope: self)
    }
    
    public func attach() {
        gyroscopeManager.startUpdates()
    }
    
    public func detach() {
        gyroscopeManager.stopUpdates()
    }
    
}

extension GyroscopeManagerViewController: GyroscopeDataTransmittable {
    func gyroscopeDidTransferMotion(motion: CMDeviceMotion, error: Error?, gyroscope: GyroscopeManager) {
        calculateNewVector(motion: motion, error: error)
    }
}
