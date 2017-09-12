//
//  ApplicationActivityMonitored.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 9/12/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationActivityMonitored: class {
    var activityService: ApplicationActivityViewController { get }
}

extension ApplicationActivityMonitored where Self: UIViewController {

    var activityService: ApplicationActivityViewController {
        get {
            var activityService = objc_getAssociatedObject(self, &RuntimeAssociatedKeys.ApplicationActivityAssociatedKey) as? ApplicationActivityViewController

            if (activityService == nil) {
                activityService = ApplicationActivityViewController()

                objc_setAssociatedObject(self, &RuntimeAssociatedKeys.ApplicationActivityAssociatedKey, activityService, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                attachServiceToParent()
            }
            return activityService!
        }
    }

    private func attachServiceToParent() {
        addChildViewController(activityService)
        view.addSubview(activityService.view)
        activityService.didMove(toParentViewController: self)
    }

}

