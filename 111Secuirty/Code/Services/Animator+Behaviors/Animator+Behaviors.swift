//
//  Animator+Behaviors.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/14/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import UIKit

class Animator {
    
    private var viewsOnTheScreen: [UIView] = [] {
        didSet {
            if viewsOnTheScreen.count > 20 {
                cleanAllKeyViews()
                viewsOnTheScreen.removeAll()
            }
        }
    }
    
    private var parentView: UIView!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var itemBehaviour: UIDynamicItemBehavior!
    
    public func setupBehaviorsFor(view: UIView, magnitude: CGFloat = 3.5, elasticity: CGFloat = 0.5) {
        parentView = view
        animator = UIDynamicAnimator(referenceView: parentView)
        
        gravity = UIGravityBehavior()
        gravity.magnitude = magnitude
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        itemBehaviour = UIDynamicItemBehavior()
        itemBehaviour.elasticity = elasticity
        animator.addBehavior(itemBehaviour)
    }
    
    public func animateObject(_ object: UIView) {
        parentView.addSubview(object)
        viewsOnTheScreen.append(object)
        gravity.addItem(object)
        collision.addItem(object)
        itemBehaviour.addItem(object)
    }
    
    public func cleanAllKeyViews() {
        collision.translatesReferenceBoundsIntoBoundary = false
        restartCollision()
    }
    
    private func restartCollision() {
        collision = nil
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    func setupGravityDirection(with vector: CGVector) {
        gravity.gravityDirection = vector
    }
    
}
