//
//  SettingsViewController.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    fileprivate var cellPrototypes: [SettingType] {
        return SettingCellsSet().settingsCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
    }

    @IBAction private func backToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func logout(_ sender: Any) {
        SessionManager.logoutUser()
        performSegue(withIdentifier: "loginViewControllerSegue", sender: self)
        do {
            try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: [ : ])
        } catch {
            print(error)
        }
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
        cell.fill(with: cellPrototype)
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
