//
//  DataLocalSaver.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 29.01.2022.
//

import SwiftyJSON

private let WEATHER_CURRENT_LOCATION_KEY = "weather_forecast_for_current_location"

class LocalDataSaver {
    func loadData() -> JSON {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard
            Settings.userDefaults.valueExists(forKey: WEATHER_CURRENT_LOCATION_KEY),
            let object = Settings.userDefaults.object(forKey: WEATHER_CURRENT_LOCATION_KEY),
            let result = JSON(rawValue: object)
        else { return JSON() }

        return result
    }

    func save(_ jsonData: JSON?) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard let json = jsonData, !json.isEmpty, json["current"].exists() else { return }

        Settings.userDefaults.setValue(json.rawValue, forKey: WEATHER_CURRENT_LOCATION_KEY)
    }
}
