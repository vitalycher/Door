//
//  LoginViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import PKHUD


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField .isEqual(loginTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
 
// MARK: - Actions
    
    @IBAction func signIn(sender: UIButton) {
        
        if (loginTextField.text ?? "").isEmpty {
            HUD.flash(.Label(NSLocalizedString("Please enter email", comment: "")), delay:1.0)
            return
        }
        
        if !loginTextField.text!.isEmail() {
            HUD.flash(.Label(NSLocalizedString("Please enter email", comment: "")), delay:1.0)
            return
        }
        
        if (passwordTextField.text ?? "").isEmpty {
            HUD.flash(.Label(NSLocalizedString("Please enter password", comment: "")), delay:1.0)
            return
        }
        
        HUD.show(.Progress)

        SessionManager.loginUser(loginTextField.text!.lowercaseString, password: passwordTextField.text!) { (token, error) in
            if token != nil {
                HUD.hide()
                SessionManager.setUserToken(token!)
                self.performSegueWithIdentifier("mainControllerSegue", sender: self)
            } else if (error != nil) {
                HUD.flash(.Label("\(error!.localizedDescription)"), delay:1.0)
            } else {
                HUD.hide()
            }
        }
    }
}
