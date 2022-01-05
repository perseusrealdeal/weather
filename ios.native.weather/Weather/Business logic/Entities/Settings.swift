//
//  Settings.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 08.12.2021.
//

import Foundation
import SwiftyJSON

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
    
    static var defaultLocation : Сoordinate
    {
        let json = JSON(parseJSON: "defaultLocation".localized_value)
        
        let lat = json["lat"].doubleValue
        let lon = json["lon"].doubleValue
        
        return Сoordinate(latitude: lat, longitude: lon)
    }
    
    static let userDefaults = UserDefaults.standard
    
    static let notificationCenter = NotificationCenter.default
    
    static let geoService = GeoLocationReceiver.shared
}
