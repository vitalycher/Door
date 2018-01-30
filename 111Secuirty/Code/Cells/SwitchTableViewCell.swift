//
//  SettingsTableViewCell.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

protocol RealtimeSettingUpdatable: class {
    func cellDidRequestPermissionToChangeSetting(_ setting: SettingType, cell: SwitchTableViewCell, permission: @escaping (Bool) -> Void)
    func settingDidChange(setting: SettingType, isEnabled: Bool, cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    private var settingType: SettingType!
    private let defaults = UserDefaults.standard
    
    weak var delegate: RealtimeSettingUpdatable?

    @IBOutlet weak private var settingLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    
    @IBAction private func switchTapped(_ sender: UISwitch) {
        guard let settingType = settingType else { return }
        
        func updateUserDefaults() {
            //Dispatching the main queue because this code gets performed from block(not main thread) while working with UI elements.
            DispatchQueue.main.async {
                switch settingType {
                case .gyroscope:
                    self.defaults.set(sender.isOn, forKey: UserDefaultsKeys.gyroscopeEnabledBySettings.rawValue)
                case .squaresWaterfall:
                    self.defaults.set(sender.isOn, forKey: UserDefaultsKeys.squaresWaterfallEnabledBySettings.rawValue)
                case .voiceRecognition:
                    self.defaults.set(sender.isOn, forKey: UserDefaultsKeys.voiceRecognitionEnabledBySettings.rawValue)
                case .siri:
                    self.defaults.set(sender.isOn, forKey: UserDefaultsKeys.siriEnabledBySettings.rawValue)
                }
            }
        }
        
        //Checking permissions only when toggling switch to 'ON'. Then enabling the setting if permitted.
        if sender.isOn {
            delegate?.cellDidRequestPermissionToChangeSetting(settingType, cell: self, permission: { [weak self] (isAllowed) in
                if isAllowed {
                    updateUserDefaults()
                    self?.delegate?.settingDidChange(setting: settingType, isEnabled: true, cell: self!)
                } else {
                    //Dispatching the main queue because this code gets performed from block(not main thread) while working with UI elements.
                    DispatchQueue.main.async {
                        sender.setOn(!sender.isOn, animated: true)
                    }
                }
            })
        } else {
            //Not checking any permissions if toggling switch to 'OFF', just disabling the setting.
            updateUserDefaults()
            delegate?.settingDidChange(setting: settingType, isEnabled: false, cell: self)
        }
    }
    
    public func fill(with settingType: SettingType) {
        self.settingType = settingType
        settingLabel.text = settingType.localized
        
        switch settingType {
        case .squaresWaterfall: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.squaresWaterfallEnabledBySettings.rawValue)
        case .voiceRecognition: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabledBySettings.rawValue)
        case .gyroscope: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.gyroscopeEnabledBySettings.rawValue)
        case .siri: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.siriEnabledBySettings.rawValue)
        }
    }
    
}

