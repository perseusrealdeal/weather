//
//  Settings.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 08.12.2021.
//

import Foundation

public struct Settings
{
    static let bundleParams          : [String: String] =
        [
            "Name"                   : "Settings",
            "Extension"              : "bundle",
            "RootPlist"              : "Root.plist",
            "PreferencesItems"       : "PreferenceSpecifiers",
            "PreferenceKey"          : "Key",
            "PreferenceValues"       : "Values",
            "PreferenceDefaultValue" : "DefaultValue"
        ]
    
    static let userDefaults = UserDefaults.standard
}
