//
//  MainViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var glassDoorButton: UIButton!
    @IBOutlet weak var ironDoorButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    func setupAppearance() {
        
        glassDoorButton.layer.cornerRadius = CGRectGetHeight(glassDoorButton.frame) / 2
        ironDoorButton.layer.cornerRadius = CGRectGetHeight(ironDoorButton.frame) / 2
        logOutButton.layer.cornerRadius = CGRectGetHeight(logOutButton.frame) / 2
        
        glassDoorButton.layer.masksToBounds = true
        ironDoorButton.layer.masksToBounds = true
        logOutButton.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        SessionManager.openGlassDoor()
    }

    @IBAction func openIronDoor(sender: AnyObject) {
        SessionManager.openIronDoor()
    }
    
    @IBAction func logOut(sender: AnyObject) {
        SessionManager.logoutUser()
    }
}
