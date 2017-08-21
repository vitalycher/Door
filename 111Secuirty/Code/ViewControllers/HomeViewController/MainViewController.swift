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
import AudioToolbox

class MainViewController: UIViewController, Gyroscopable {
    
    @IBOutlet weak private var glassDoorButton: UIButton!
    @IBOutlet weak private var ironDoorButton: UIButton!
    @IBOutlet weak private var quoteTextLabel: UILabel!
    @IBOutlet weak private var quoteAuthorLabel: UILabel!
    
    private var mrKeeRecognizer = MrKeeSpeechRecognizer()
    private var animator = Animator()
    private let phraseAnalyzer = PhraseAnalyzer()
    
    private var isSquareWaterfallEnabled: Bool!
    private var isSpeechRecognitionEnabled: Bool!
    
//MARK: - Actions
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gyroscope.attach()

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        mrKeeRecognizer.mrKeeDelegate = self
        mrKeeRecognizer.authorize()
        animator.setupBehaviorsFor(view: view)
        
        if successWithProbability(percentage: 70) {
            getQuote()
        } else {
            setQuote(TipsGenerator().generateTip(), author: "111 team")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSettings()
        startRecordingIfAllowedBySettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mrKeeRecognizer.stopRecording()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animator.cleanAllKeyViews()
        }
    }

    @IBAction private func openGlassDoor(_ sender: AnyObject) {
//        openGlassDoor()
        createFallingKeyIfAllowed()
    }

    @IBAction private func openIronDoor(_ sender: AnyObject) {
        openIronDoor()
    }

    private func openGlassDoor() {
        createFallingKeyIfAllowed()
        HUD.show(.progress)
        SessionManager.openGlassDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage

            HUD.flash(.label(message), delay: 2.0)
        }
    }

    private func openIronDoor() {
        createFallingKeyIfAllowed()
        HUD.show(.progress)
        SessionManager.openIronDoor { (completionMessage) in
            let message = completionMessage == nil ? "Welcome!" : completionMessage

            HUD.flash(.label(message), delay: 2.0)
        }
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

    private func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    private func successWithProbability(percentage: Int) -> Bool {
        return arc4random_uniform(100) < percentage
    }
    
    private func newFallingKey() -> UIImageView {
        let keyView = UIImageView(frame: CGRect(x: randomInt(min: Int(view.frame.width / 2 - view.frame.width / 4), max: Int(view.frame.width / 2 + view.frame.width / 4)), y: 80, width: 30, height: 30))
        keyView.image = UIImage.init(named: "AppIcon")
        return keyView
    }
    
    private func setupSettings() {
        isSquareWaterfallEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue)
        isSpeechRecognitionEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue)
    }
    
    private func createFallingKeyIfAllowed() {
        guard isSquareWaterfallEnabled else { return }
        animator.animateObject(newFallingKey())
    }
    
    private func startRecordingIfAllowedBySettings() {
        guard isSpeechRecognitionEnabled else { return }
        mrKeeRecognizer.startRecordingIfAuthorized()
    }
    
    @objc private func applicationWillResignActive() {
        mrKeeRecognizer.stopRecording()
    }
    
    @objc private func applicationDidBecomeActive() {
        startRecordingIfAllowedBySettings()
    }
    
    func gyroscopeVectorDidUpdate(with vector: CGVector, gyroscope: GyroscopeManagerViewController) {
        animator.setupGravityDirection(with: vector)
    }
    
}

extension MainViewController: MrKeeRecognizerDelegate {
    
    func didRecognizeWord(_ newPhrase: String) {
        createFallingKeyIfAllowed()
        phraseAnalyzer.analyze(newPhrase) { (analyzableType) in
            mrKeeRecognizer.stopRecording() {
                self.mrKeeRecognizer.startRecordingIfAuthorized()
            }
            if let doorType = analyzableType as? DoorType {
                switch doorType {
                case .glass: self.openGlassDoor()
                case .iron: self.openIronDoor()
                }
            } else if let secondaryType = analyzableType as? SecondaryType {
                switch secondaryType {
                case .clean: animator.cleanAllKeyViews()
                default: break
                }
            }
        }
    }

    func didFinishRecognition(recognizer: MrKeeSpeechRecognizer) { }
    
}

