//
//  SettingsViewController.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, ApplicationActivityMonitored {

    @IBOutlet weak private var tableView: UITableView!
    
    private let phraseAnalyzer = PhraseAnalyzer()
    private let animator = Animator()
    
    fileprivate var cellPrototypes: [SettingType] {
        return SettingCellsSet().settingsCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityService.initWith(cancelClosure: { self.speechRecognizer.stopRecording() }, activeClosure: { self.speechRecognizer.startRecordingIfAllowed() })
        
        tableView.dataSource = self
        tableView.delegate = self
        animator.setupBehaviorsFor(view: view)
        registerCells()
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

    @IBAction private func backToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func logout(_ sender: Any) {
        showAlert(withTitle: NSLocalizedString("Are you sure you want to log out?", comment: ""), andMessage: nil, actions: [UIAlertAction.init(title: "Yes", style: .default) { _ in self.logout() }, UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)])
    }
    
    private func logout() {
        SessionManager.logoutUser()
        performSegue(withIdentifier: "loginViewControllerSegue", sender: self)
        do {
            try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: [:])
        } catch {
            print(error)
        }
    }
    
    private func showAlert(withTitle title: String, andMessage message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
    
    private func registerCells() {
        let registerNibForCellClass: (UITableViewCell.Type) -> Void = {
            self.tableView.register(UINib(nibName: String(describing: $0), bundle: nil), forCellReuseIdentifier: String(describing: $0))
        }
        registerNibForCellClass(SwitchTableViewCell.self)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellPrototypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPrototype = cellPrototypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as! SwitchTableViewCell
        cell.delegate = self
        cell.fill(with: cellPrototype)
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension SettingsViewController: SpeechRecognizable {
    func didRecognizeWord(_ newPhrase: String) {
        animator.createFallingKeyIfAllowed()
        
        phraseAnalyzer.analyzePhrase(newPhrase) { analyzedType in
            switch analyzedType {
            case SecondaryKeyword.clean: self.animator.cleanAllKeyViews()
            case NavigationalKeyword.back: dismiss(animated: true, completion: nil)
            case NavigationalKeyword.logout: self.logout()
            default: return
            }
            self.speechRecognizer.restart()
        }
    }
}

extension SettingsViewController: Gyroscopable {
    func gyroscopeDidUpdateVector(vector: CGVector, gyroscope: GyroscopeManager) {
        animator.setupGravityDirection(with: vector)
    }
}

extension SettingsViewController: RealtimeSettingUpdatable {
    func settingDidChange(setting: SettingType, cell: SwitchTableViewCell) {
        switch setting {
        case .gyroscope: gyroscopeManager.startOrStopGyroscopeDependingOnSettings(gyroscopeDeactivationBlock: { self.animator.setVerticalDownGravityDirection() })
        case .voiceRecognition: speechRecognizer.startOrStopRecordingDependingOnSettings()
        default: break
        }
    }
}
