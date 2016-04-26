//
//  LoginViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    func setupAppearance() {
        
        loginTextField.layer.cornerRadius = CGRectGetHeight(loginTextField.frame) / 2
        passwordTextField.layer.cornerRadius = CGRectGetHeight(passwordTextField.frame) / 2
        signInButton.layer.cornerRadius = CGRectGetHeight(signInButton.frame) / 2
        
        loginTextField.layer.masksToBounds = true
        passwordTextField.layer.masksToBounds = true
        signInButton.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    @IBAction func signIn(sender: UIButton) {
        
        if loginTextField.text != nil && passwordTextField.text != nil {
            
            SessionManager.loginUser(loginTextField.text!, password: passwordTextField.text!) { (token) in
                if token != nil {
                    SessionManager.setUserToken(token!)
                    
                    self.performSegueWithIdentifier("mainControllerSegue", sender: self)
                }
            }
        }
    }
}
