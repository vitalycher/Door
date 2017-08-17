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
            }
        }
    }
    
    public func fill(with settingType: SettingType) {
        self.settingType = settingType
        settingLabel.text = settingType.localized
        
        settingSwitch.isOn = (settingType == .squaresWaterfall ? UserDefaults.standard.bool(forKey: UserDefaultsKeys.squaresWaterfallEnabled.rawValue) : UserDefaults.standard.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue))
    }
    
}
