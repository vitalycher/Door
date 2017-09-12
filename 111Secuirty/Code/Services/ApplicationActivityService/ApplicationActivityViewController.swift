//
//  ApplicationActivityViewController.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 9/12/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class ApplicationActivityViewController: UIViewController {
    
    private var activityService = ApplicationActivityService()

    override func loadView() {
        view = UIView(frame: CGRect.init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityService.isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        activityService.isActive = false
    }

    public func initWith(cancelClosure: @escaping () -> Void, activeClosure: @escaping () -> Void) {
        activityService.initWith(cancelClosure: cancelClosure, activeClosure: activeClosure)
    }

}
