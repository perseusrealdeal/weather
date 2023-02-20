//
//  Settings.swift
//  Weather
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

public struct Settings {
    static let bundleParams: [String: String] =
        [
            "Name": "Settings",
            "Extension": "bundle",
            "RootPlist": "Root.plist",
            "PreferencesItems": "PreferenceSpecifiers",
            "PreferenceKey": "Key",
            "PreferenceValues": "Values",
            "PreferenceDefaultValue": "DefaultValue"
        ]

    static var defaultLocation: Сoordinate {
        let json = JSON(parseJSON: "defaultLocation".localized_value)

        let lat = json["lat"].doubleValue
        let lon = json["lon"].doubleValue

        return Сoordinate(latitude: lat, longitude: lon)
    }

    static let userDefaults = UserDefaults.standard

    static let notificationCenter = NotificationCenter.default

    static let geoService = GeoLocationReceiver.shared
}
