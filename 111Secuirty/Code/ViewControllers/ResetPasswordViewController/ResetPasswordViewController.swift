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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
// MARK: - Actions
    
    @IBAction func goBackAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetPasswordAction(sender: AnyObject) {
        
        if (emailTextField.text ?? "").isEmpty {
            HUD.flash(.Label(NSLocalizedString("Please enter email", comment: "")), delay:1.0)
            return
        }
        
        HUD.show(.Progress)
        
        if emailTextField.text!.isEmail() {
            SessionManager.resetPassword(emailTextField.text!, completion: { (error) in
                if error != nil {
                    HUD.flash(.Label("\(error!.localizedDescription)"), delay:1.0)
                } else {
                    self.dismissViewControllerAnimated(false, completion: nil)
                    HUD.flash(.Label(NSLocalizedString("Password reset instructions have been sent to your email", comment: "")), delay:2.0)
                }
            })
        } else {
            HUD.flash(.Label(NSLocalizedString("It's something wrong with your email", comment: "")), delay:1.0)
        }
    }
}
