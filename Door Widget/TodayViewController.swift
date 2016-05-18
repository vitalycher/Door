//
//  TodayViewController.swift
//  Door Widget
//
//  Created by Andrey Sokur on 04.05.16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire


class TodayViewController: UIViewController, NCWidgetProviding {

    var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.111minutes.thedoor")!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var ironDoorButton: UIButton!
    @IBOutlet weak var glassDoorButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    let hSpace : CGFloat = 10
    var reachability: Reachability?

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupViewsOnlineAuthorized()
        self.setupReachability()
    }
    
    func setupReachability() {
        
        if (reachability == nil) {
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TodayViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
// MARK: - Actions
    
    @IBAction func openIronDoor(sender: AnyObject) {
        SessionManager.openIronDoor(nil)
    }
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        SessionManager.openGlassDoor(nil)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        extensionContext?.openURL(NSURL(string: "door://")!, completionHandler: nil)
    }
    
//MARK: - Help functions
    
    func getUserToken() -> String? {
        return defaults.objectForKey("kAuthToken") as? String
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        print("reachabilityChanged")
        
        if reachability.isReachable() {
            
            if getUserToken() == nil {
                setupViewsOfflineUnauthorized()
            } else {
                setupViewsOnlineAuthorized()
            }
        } else {
            setupViewsOffline()
            
        }
    }
    
    func setupViewsOffline() {
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.ironDoorButton.hidden = true
            self.glassDoorButton.hidden = true
            self.loginButton.hidden = true
            self.descriptionLabel.hidden = false
            self.descriptionLabel.text = NSLocalizedString("Please check your internet connection and try again", comment: "")
            self.view.layoutSubviews()
            self.preferredContentSize = CGSizeMake(0, CGFloat(self.descriptionLabel.frame.size.height + self.hSpace))
        }
    }
    
    func setupViewsOnlineAuthorized() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.hidden = false
            self.glassDoorButton.hidden = false
            self.loginButton.hidden = true
            self.descriptionLabel.hidden = true
            self.view.layoutSubviews()
            self.preferredContentSize = CGSizeMake(0, CGFloat(self.ironDoorButton.frame.height + self.hSpace))
        }
    }
    
    func setupViewsOfflineUnauthorized() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.ironDoorButton.hidden = true
            self.glassDoorButton.hidden = true
            self.loginButton.hidden = false
            self.descriptionLabel.hidden = false
            self.descriptionLabel.text = NSLocalizedString("Login to your account", comment: "")
            self.view.layoutSubviews()
            self.preferredContentSize = CGSizeMake(0, CGFloat(self.loginButton.frame.height + self.descriptionLabel.frame.size.height + self.hSpace * 2))
        }
    }
}
