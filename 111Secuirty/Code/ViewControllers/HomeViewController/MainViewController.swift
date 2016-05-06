//
//  MainViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class MainViewController: UIViewController {

    @IBOutlet weak var glassDoorButton: UIButton!
    @IBOutlet weak var ironDoorButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    var reachability: Reachability?

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
        if ((reachability?.isReachable()) != nil) {
            getQuote()
        }
    }
    
//MARK: - Actions
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        SessionManager.openGlassDoor()
    }

    @IBAction func openIronDoor(sender: AnyObject) {
        SessionManager.openIronDoor()
    }
    
    @IBAction func logOut(sender: AnyObject) {
        SessionManager.logoutUser()
        self.performSegueWithIdentifier("loginViewControllerSegue", sender: self)
    }
    
//MARK: - Help functions
    
    func getQuote() {
        SessionManager.getQuote() { (quoteText, quoteAuthor) in
            if quoteAuthor != nil && quoteText != nil {
                self.quoteTextLabel.text = quoteText
                self.quoteAuthorLabel.text = quoteAuthor
            }
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            setupViewsOnline()
        } else {
            setupViewsOffine()
        }
    }
    
    func setupViewsOnline() {
        ironDoorButton.enabled = true
        glassDoorButton.enabled = true
        ironDoorButton.layer.opacity = 1
        glassDoorButton.layer.opacity = 1
    }
    
    func setupViewsOffine() {
        quoteTextLabel.text = NSLocalizedString("Please check your internet connection and try again", comment: "")
        ironDoorButton.enabled = false
        glassDoorButton.enabled = false
        ironDoorButton.layer.opacity = 0.5
        glassDoorButton.layer.opacity = 0.5
    }
}
