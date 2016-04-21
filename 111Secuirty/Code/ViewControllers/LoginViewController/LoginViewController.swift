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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    func loginUser(login: String?, password: String?) {
        
        
        print(("\(login!) \(password!)"))
    }
    
    @IBAction func signIn(sender: UIButton) {
        let apiManager = APIManager()
        
        apiManager.loginUser(loginTextField.text, password: passwordTextField.text)
        
    }
}
