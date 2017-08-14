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
import Speech

class MainViewController: UIViewController {
    
    @IBOutlet weak private var glassDoorButton: UIButton!
    @IBOutlet weak private var ironDoorButton: UIButton!
    @IBOutlet weak private var logOutButton: UIButton!
    @IBOutlet weak private var quoteTextLabel: UILabel!
    @IBOutlet weak private var quoteAuthorLabel: UILabel!
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var itemBehaviour: UIDynamicItemBehavior!
    
    private let mrKeeRecognizer = MrKeeSpeechRecognizer()
    private let phraseAnalyzer = PhraseAnalyzer()

//MARK: - Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        behaviorsInitialSetup()
        mrKeeRecognizer.mrKeeDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mrKeeRecognizer.authorizeAndStartRecordingIfPossible()

        if successWithProbability(percentage: 65) {
            getQuote()
        } else {
            setQuote(TipsGenerator().generateTip(), author: "111 team")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mrKeeRecognizer.stopRecording()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            cleanAllKeyViews()
        }
    }

    @IBAction private func openGlassDoor(_ sender: AnyObject) {
        openGlassDoor()
    }

    @IBAction private func openIronDoor(_ sender: AnyObject) {
        openIronDoor()
    }
    
    @IBAction private func logOut(_ sender: AnyObject) {
        logOut()
    }

    private func openGlassDoor() {
        createNewFallingKey()
        HUD.show(.progress)
        SessionManager.openGlassDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage

            HUD.flash(.label(message), delay: 2.0)
        }
    }

    private func openIronDoor() {
        createNewFallingKey()
        HUD.show(.progress)
        SessionManager.openIronDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage

            HUD.flash(.label(message), delay: 2.0)
        }
    }
    
    private func logOut() {
        SessionManager.logoutUser()
        self.performSegue(withIdentifier: "loginViewControllerSegue", sender: self)
    }

//MARK: - Help functions

    private func getQuote() {
        SessionManager.getQuote() { (quoteText, quoteAuthor) in
            self.setQuote(quoteText, author: quoteAuthor)
        }
    }

    private func setQuote(_ text: String?, author: String?) -> () {
        if let text = text {
            quoteTextLabel.textAlignment = .left
            quoteTextLabel.text = text
            quoteAuthorLabel.text = (author == nil || author == "") ? nil : "— " + author!
        } else {
            setQuote(TipsGenerator().generateTip(), author: "111 team")
        }
        view.layoutSubviews()
    }

    private func behaviorsInitialSetup() {
        animator = UIDynamicAnimator(referenceView: view)

        gravity = UIGravityBehavior()
        gravity.magnitude = 1.5
        animator.addBehavior(gravity)

        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)


        itemBehaviour = UIDynamicItemBehavior()
        itemBehaviour.elasticity = 0.5
        animator.addBehavior(itemBehaviour)
    }

    private func createNewFallingKey() {
        let keyView = UIImageView(frame: CGRect(x: randomInt(min: Int(view.frame.width / 2 - view.frame.width / 4), max: Int(view.frame.width / 2 + view.frame.width / 4)), y: 80, width: 30, height: 30))
        keyView.image = UIImage.init(named: "AppIcon")
        view.addSubview(keyView)

        gravity.addItem(keyView)
        collision.addItem(keyView)
        itemBehaviour.addItem(keyView)
    }
    
    private func cleanAllKeyViews() {
        collision.translatesReferenceBoundsIntoBoundary = false
        restartCollision()
    }
    
    private func restartCollision() {
        collision = nil
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }

    private func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    private func successWithProbability(percentage: Int) -> Bool {
        return arc4random_uniform(100) < percentage
    }

}

extension MainViewController: MrKeeRecognizerDelegate {
    
    func didRecognizeWord(_ newPhrase: String) {
        createNewFallingKey()
        phraseAnalyzer.analyze(newPhrase) { (analyzableType) in
            mrKeeRecognizer.stopRecording()
            if let doorType = analyzableType as? DoorType {
                switch doorType {
                case .glass: self.openGlassDoor()
                case .iron: self.openIronDoor()
                }
            } else if let secondaryType = analyzableType as? SecondaryType {
                switch secondaryType {
                case .clean: self.cleanAllKeyViews()
                case .logout: self.logOut()
                }
            }
        }
    }

    func didFinishRecognition(recognizer: MrKeeSpeechRecognizer) {
        do {
            try recognizer.startRecording()
        } catch let error {
            print("There was a problem starting recording: \(error.localizedDescription)")
        }
    }

}
