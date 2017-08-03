//
//  MainViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var glassDoorButton: UIButton!
    @IBOutlet weak var ironDoorButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!

//MARK: - Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuote()
    }
    
    @IBAction func openGlassDoor(_ sender: AnyObject) {
        HUD.show(.progress)
        SessionManager.openGlassDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage
            
            HUD.flash(.label(message), delay: 2.0)
        }
    }

    @IBAction func openIronDoor(_ sender: AnyObject) {
        HUD.show(.progress)
        SessionManager.openIronDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage
            
            HUD.flash(.label(message), delay: 2.0)
        }
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        SessionManager.logoutUser()
        self.performSegue(withIdentifier: "loginViewControllerSegue", sender: self)
    }
    
//MARK: - Help functions
    
    func getQuote() {
        SessionManager.getQuote() { (quoteText, quoteAuthor) in
            self.setQuote(quoteText, author: quoteAuthor)
        }
    }
    
    func setQuote(_ text: String?, author: String?) -> () {
        if let text = text {
            quoteTextLabel.textAlignment = .left
            quoteTextLabel.text = text
            quoteAuthorLabel.text = (author == nil || author == "") ? nil : "— " + author!
        } else {
            quoteTextLabel.textAlignment = .center
            quoteTextLabel.text = "¯\\_(ツ)_/¯"
        }

        view.layoutSubviews()
    }
}
