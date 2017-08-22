//
//  SettingsTableViewCell.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/15/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
    case squaresWaterfallEnabled = "squaresWaterfall"
    case voiceRecognitionEnabled = "voiceRecognition"
    case gyroscopeEnabled = "gyroscopeEnabled"
}

class SwitchTableViewCell: UITableViewCell {

    private var settingType: SettingType!
    @IBOutlet weak private var settingLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    
    @IBAction private func switchTapped(_ sender: UISwitch) {
        if let settingType = settingType {
            switch settingType {
            case .squaresWaterfall: UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue)
            case .voiceRecognition: UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue)
            case .gyroscope: UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsKeys.gyroscopeEnabled.rawValue)
            }
        }
    }
    
    public func fill(with settingType: SettingType) {
        self.settingType = settingType
        settingLabel.text = settingType.localized
        
        switch settingType {
        case .squaresWaterfall: settingSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue)
        case .gyroscope: settingSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.gyroscopeEnabled.rawValue)
        case .voiceRecognition: settingSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue)
        }
    }
    
}
