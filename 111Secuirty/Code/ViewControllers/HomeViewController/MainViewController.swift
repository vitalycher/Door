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


typealias DoorOpeningCompletion = (error: NSError?, errorString: String?) -> ()


class MainViewController: UIViewController {
    

    @IBOutlet weak var glassDoorButton: UIButton!
    @IBOutlet weak var ironDoorButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    var reachability: Reachability?
    
    
    let doorOpeningCompletion: DoorOpeningCompletion = {  (error, errorString) in
        
        var message: String
        
        if error?.localizedDescription != nil {
            message = (error?.localizedDescription)!
        } else if errorString != nil {
            message = errorString!
        } else {
            message = "Welcome!"
        }
        
        HUD.flash(.Label(message), delay:1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
//MARK: - Actions
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        HUD.show(.Progress)
        SessionManager.openGlassDoor(doorOpeningCompletion)
    }

    @IBAction func openIronDoor(sender: AnyObject) {
        HUD.show(.Progress)
        SessionManager.openIronDoor(doorOpeningCompletion)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        SessionManager.logoutUser()
        self.performSegueWithIdentifier("loginViewControllerSegue", sender: self)
    }
    
//MARK: - Help functions
    
    func getQuote() {
        SessionManager.getQuote() { (quoteText, quoteAuthor, quoteError) in
            if quoteAuthor != nil && quoteText != nil {
                self.setQuote(quoteText, author: quoteAuthor)
            }
            
            if quoteError != nil {
                HUD.flash(.Label("\(quoteError!.localizedDescription)"), delay:1.0)
            }
        }
    }
    
    func setQuote(text: String?, author: String?) -> () {
        
        self.quoteTextLabel.text = text
        if author != nil {
            self.quoteAuthorLabel.text = "— " + author!
        } else {
            self.quoteAuthorLabel.text = nil
        }
        self.view.layoutSubviews()
    }
    
    
//MARK: - Reachability
    
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            setupViewsOnline()
        } else {
            setupViewsOffine()
        }
    }
    
    func setupViewsOnline() {
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.enabled = true
            self.glassDoorButton.enabled = true
            self.ironDoorButton.layer.opacity = 1
            self.glassDoorButton.layer.opacity = 1
            self.setQuote("Loading...", author: nil)
            self.getQuote()
        }
    }
    
    func setupViewsOffine() {
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.enabled = false
            self.glassDoorButton.enabled = false
            self.ironDoorButton.layer.opacity = 0.5
            self.glassDoorButton.layer.opacity = 0.5
            
            self.setQuote(NSLocalizedString("Please check your internet connection and try again", comment: ""),
                          author: NSLocalizedString("Offline", comment: ""))
        }
    }
}
