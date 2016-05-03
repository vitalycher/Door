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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
