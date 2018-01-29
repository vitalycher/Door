//
//  MainViewController.swift
//  111Secuirty
//
//  Created by Egor Bozko on 4/19/16.
//  Copyright © 2016 Egor Bozko. All rights reserved.
//

import UIKit
import PKHUD
import AudioToolbox
import Intents

class MainViewController: UIViewController, ApplicationActivityMonitored {
    
    @IBOutlet weak private var glassDoorButton: UIButton!
    @IBOutlet weak private var ironDoorButton: UIButton!
    @IBOutlet weak private var quoteTextLabel: UILabel!
    @IBOutlet weak private var quoteAuthorLabel: UILabel!
    
    private let animator = Animator()
    private let phraseAnalyzer = PhraseAnalyzer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.siriAuthorizationEnabled.rawValue) {
            requestSiriAuthorization()
        }
        
        activityService.initWith(cancelClosure: { self.speechRecognizer.stopRecording() }, activeClosure: { self.speechRecognizer.startRecordingIfAllowed() })
        
        animator.setupBehaviorsFor(view: view)
        setupQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gyroscopeManager.startOrStopGyroscopeDependingOnSettings(gyroscopeDeactivationBlock: { self.animator.setVerticalDownGravityDirection() })
        speechRecognizer.startRecordingIfAllowed()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        speechRecognizer.stopRecording()
        gyroscopeManager.stopUpdates()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animator.cleanAllKeyViews()
        }
    }

    //MARK: - Actions
    
    @IBAction private func openGlassDoor(_ sender: AnyObject) {
        openGlassDoor()
    }

    @IBAction private func openIronDoor(_ sender: AnyObject) {
        openIronDoor()
    }

    //MARK: Door management
    
    private func openGlassDoor() {
        animator.createFallingKeyIfAllowed()
        HUD.show(.progress)
        SessionManager.openGlassDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage
            HUD.flash(.label(message), delay: 2.0)
        }
    }

    private func openIronDoor() {
        animator.createFallingKeyIfAllowed()
        HUD.show(.progress)
        SessionManager.openIronDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage
            HUD.flash(.label(message), delay: 2.0)
        }
    }
    
    //MARK: Quotes
    
    private func setupQuote() {
        if successWithProbability(percentage: 70) {
            getQuote()
        } else {
            setQuote(TipsGenerator().generateTip(), author: NSLocalizedString("111 team", comment: ""))
        }
    }

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
    
    //MARK: - Siri vocabulary/authorization
    
    private func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.siriAuthorizationEnabled.rawValue)
                self.extendSiriVocabulary()
                print("Hi, Siri")
            } else {
                print("Bye, Siri!")
            }
        }
    }
    
    private func extendSiriVocabulary() {
        let vocabulary = [SiriVocabulary.glassDoor, SiriVocabulary.ironDoor]
        let vocabularySet = NSOrderedSet(array: vocabulary)
        INVocabulary.shared().setVocabularyStrings(vocabularySet, of: .workoutActivityName)
    }
    
    //MARK: - Help functions
    
    private func successWithProbability(percentage: Int) -> Bool {
        return arc4random_uniform(100) < percentage
    }
        
    private func goToSettings() {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

}

extension MainViewController: SpeechRecognizable {
    func didRecognizeWord(_ newPhrase: String) {
        animator.createFallingKeyIfAllowed()

        phraseAnalyzer.analyzePhrase(newPhrase) { analyzedType in
            switch analyzedType {
            case DoorKeyword.glass: self.openGlassDoor()
            case DoorKeyword.iron: self.openIronDoor()
            case NavigationalKeyword.settings: self.goToSettings()
            case SecondaryKeyword.clean: self.animator.cleanAllKeyViews()
            case SecondaryKeyword.quote: self.setupQuote()
            default: return
            }
            if !(analyzedType is NavigationalKeyword) {
                self.speechRecognizer.restart()
            }
        }
    }
}

extension MainViewController: Gyroscopable {
    func gyroscopeDidUpdateVector(vector: CGVector, gyroscope: GyroscopeManager) {
        animator.setupGravityDirection(with: vector)
    }
}
