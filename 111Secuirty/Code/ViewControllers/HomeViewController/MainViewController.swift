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
import PKHUD


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
    }
    
//MARK: - Actions
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        HUD.show(.Progress)
        SessionManager.openGlassDoor()
        HUD.flash(.Label("Welcome!"), delay:1.0)
        getQuote()
    }

    @IBAction func openIronDoor(sender: AnyObject) {
        HUD.show(.Progress)
        SessionManager.openIronDoor()
        HUD.flash(.Label("Welcome!"), delay:1.0)
        getQuote()
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
                self.view.layoutSubviews()
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
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.enabled = true
            self.glassDoorButton.enabled = true
            self.ironDoorButton.layer.opacity = 1
            self.glassDoorButton.layer.opacity = 1
            self.getQuote()
        }
    }
    
    func setupViewsOffine() {
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.enabled = false
            self.glassDoorButton.enabled = false
            self.ironDoorButton.layer.opacity = 0.5
            self.glassDoorButton.layer.opacity = 0.5
            self.getQuote()
        }
    }
}
