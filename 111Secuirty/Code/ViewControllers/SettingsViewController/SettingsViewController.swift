//
//  SettingsViewController.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        SessionManager.logoutUser()
        self.performSegue(withIdentifier: "loginViewControllerSegue", sender: self)
    }
    
}
