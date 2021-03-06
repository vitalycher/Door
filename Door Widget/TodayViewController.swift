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

    private let hSpace : CGFloat = 10
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var ironDoorButton: UIButton!
    @IBOutlet private weak var glassDoorButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let os = ProcessInfo().operatingSystemVersion
        if os.majorVersion < 10 {
            descriptionLabel.textColor = UIColor.white
        } else {
            descriptionLabel.textColor = UIColor.init(red: 180.0/255.0, green: 30.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        preferredContentSize = CGSize.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
// MARK: - Actions
    
    @IBAction private func openIronDoor(_ sender: AnyObject) {
        SessionManager.openIronDoor { (completionMessage) in
            self.show(completionMessage, {
                self.setupViews()
            })
        }
    }
    
    @IBAction private func openGlassDoor(_ sender: AnyObject) {
        SessionManager.openGlassDoor { (completionMessage) in
            self.show(completionMessage, {
                self.setupViews()
            })
        }
    }
    
    @IBAction private func loginAction(_ sender: AnyObject) {
        extensionContext?.open(URL(string: "door://")!, completionHandler: nil)
    }
    
//MARK: - Help functions
    private func show(_ message: String?, _ completion: @escaping () -> ()) {
        guard let message = message, message != "" else { return }
        
        descriptionLabel.text = message

        UIView.animate(withDuration: 0.3, animations: {
            self.ironDoorButton.alpha = 0
            self.glassDoorButton.alpha = 0
            self.descriptionLabel.alpha = 1
        }) { (done) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.ironDoorButton.alpha = 1
                    self.glassDoorButton.alpha = 1
                    self.descriptionLabel.alpha = 0
                })
            }
        }
    }
    
    private func setupViews() {
        SessionManager.getUserToken() != nil ? setupViewsAuthorized() : setupViewsUnauthorized()
    }
    
    private func setupViewsAuthorized() {
        DispatchQueue.main.async {
            self.ironDoorButton.alpha = 1
            self.glassDoorButton.alpha = 1
            self.loginButton.alpha = 0
            self.descriptionLabel.alpha = 0
            self.view.layoutSubviews()
            self.preferredContentSize = CGSize(width: 0, height: CGFloat(self.ironDoorButton.frame.height))
        }
    }
    
    private func setupViewsUnauthorized() {
        DispatchQueue.main.async {
            self.ironDoorButton.alpha = 0
            self.glassDoorButton.alpha = 0
            self.loginButton.alpha = 1
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.text = NSLocalizedString("Login to your account", comment: "")
            self.view.layoutSubviews()
            self.preferredContentSize = CGSize(width: 0, height: CGFloat(self.descriptionLabel.frame.size.height + self.hSpace))
        }
    }
    
}
