//
//  SettingsTableViewCell.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

protocol RealtimeSettingUpdatable: class {
    func cellDidRequestPermissionToChangeSetting(_ setting: SettingType, willEnableSetting: Bool?, cell: SwitchTableViewCell, permission: @escaping (Bool) -> Void)
    func settingDidChange(setting: SettingType, isEnabled: Bool, cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    private var settingType: SettingType!
    private let defaults = UserDefaults.standard
    @IBOutlet weak private var settingLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    weak var delegate: RealtimeSettingUpdatable?
    
    @IBAction private func switchTapped(_ sender: UISwitch) {
        guard let settingType = settingType else { return }
        
        delegate?.cellDidRequestPermissionToChangeSetting(settingType, willEnableSetting: sender.isOn, cell: self, permission: { [weak self] (isAllowed) in
            if isAllowed {
                switch settingType {
                case .gyroscope:
                    self?.defaults.set(sender.isOn, forKey: UserDefaultsKeys.gyroscopeEnabled.rawValue)
                case .squaresWaterfall:
                    self?.defaults.set(sender.isOn, forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue)
                case .voiceRecognition:
                    self?.defaults.set(sender.isOn, forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue)
                }
                self?.delegate?.settingDidChange(setting: settingType, isEnabled: sender.isOn, cell: self!)
            } else {
                DispatchQueue.main.async {
                    sender.setOn(!sender.isOn, animated: true)
                }
            }
        })
    }
    
    public func fill(with settingType: SettingType) {
        self.settingType = settingType
        settingLabel.text = settingType.localized
        
        switch settingType {
        case .squaresWaterfall: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue)
        case .voiceRecognition: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue)
        case .gyroscope: settingSwitch.isOn = defaults.bool(forKey: UserDefaultsKeys.gyroscopeEnabled.rawValue)
        }
    }
}

