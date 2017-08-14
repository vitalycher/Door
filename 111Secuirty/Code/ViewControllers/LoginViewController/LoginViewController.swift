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
    
    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var signInButton: UIButton!
    @IBOutlet weak private var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField .isEqual(loginTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
 
// MARK: - Actions
    
    @IBAction private func signIn(_ sender: UIButton) {
        if (loginTextField.text ?? "").isEmpty {
            HUD.flash(.label(NSLocalizedString("Please enter email", comment: "")), delay: 2.0)
            return
        }
        
        if !loginTextField.text!.isEmail() {
            HUD.flash(.label(NSLocalizedString("Please enter email", comment: "")), delay: 2.0)
            return
        }
        
        if (passwordTextField.text ?? "").isEmpty {
            HUD.flash(.label(NSLocalizedString("Please enter password", comment: "")), delay: 2.0)
            return
        }
        
        HUD.show(.progress)

        SessionManager.loginUser(loginTextField.text!.lowercased(), password: passwordTextField.text!) { (token, errorMessage) in
            
            if let token = token {
                HUD.hide()
                SessionManager.setUserToken(token)
                self.performSegue(withIdentifier: "mainControllerSegue", sender: self)
            } else if let errorMessage = errorMessage {
                HUD.flash(.label(errorMessage), delay: 2.0)
            } else {
                HUD.hide()
            }
        }
    }
    
}
