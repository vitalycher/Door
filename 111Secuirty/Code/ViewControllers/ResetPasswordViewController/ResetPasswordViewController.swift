//
//  ResetPasswordViewController.swift
//  111Secuirty
//
//  Created by Andrey Sokur on 29.04.16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import PKHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak private var emailTextField: UITextField!
    
// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
// MARK: - Actions
    
    @IBAction private func goBackAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func resetPasswordAction(_ sender: AnyObject) {
        if (emailTextField.text ?? "").isEmpty {
            HUD.flash(.label(NSLocalizedString("Please enter email", comment: "")), delay: 2.0)
            return
        }
        
        HUD.show(.progress)
        
        if emailTextField.text!.isEmail() {
            SessionManager.resetPassword(emailTextField.text!, completion: { (errorMessage) in
                if let errorMessage = errorMessage {
                    HUD.flash(.label(errorMessage), delay: 2.0)
                } else {
                    self.dismiss(animated: false, completion: nil)
                    HUD.flash(.label(NSLocalizedString("Password reset instructions have been sent to your email",
                                                       comment: "")), delay:2.0)
                }
            })
        } else {
            HUD.flash(.label(NSLocalizedString("It's something wrong with your email", comment: "")), delay: 2.0)
        }
    }
    
}
