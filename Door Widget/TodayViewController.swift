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
import ReachabilitySwift


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

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TodayViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
// MARK: - Actions
    @IBAction func openIronDoor(sender: AnyObject) {
        SessionManager.openIronDoor()
    }
    
    @IBAction func openGlassDoor(sender: AnyObject) {
        SessionManager.openGlassDoor()
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
        ironDoorButton.hidden = true
        glassDoorButton.hidden = true
        loginButton.hidden = true
        descriptionLabel.hidden = false
        descriptionLabel.text = NSLocalizedString("Please check your internet connection and try again", comment: "")
        
        self.preferredContentSize = CGSizeMake(0, CGFloat(descriptionLabel.frame.size.height + hSpace))
    }
    
    func setupViewsOnlineAuthorized() {
        ironDoorButton.hidden = false
        glassDoorButton.hidden = false
        loginButton.hidden = true
        descriptionLabel.hidden = true
        self.preferredContentSize = CGSizeMake(0, CGFloat(ironDoorButton.frame.height + hSpace))

    }
    
    func setupViewsOfflineUnauthorized() {
        ironDoorButton.hidden = true
        glassDoorButton.hidden = true
        loginButton.hidden = false
        descriptionLabel.hidden = false
        descriptionLabel.text = NSLocalizedString("Login to your account", comment: "")
        self.preferredContentSize = CGSizeMake(0, CGFloat(loginButton.frame.height + descriptionLabel.frame.size.height + hSpace * 2))
    }
}
