//
//  WeatherDataAutoUpdater.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 26.12.2021.
//

import Foundation

enum WeatherUpdated
{
    case fullUpdate
    case forecastHourly
}

protocol WeatherDataAutoUpdaterDelegate
{
    func weatherDataChanged(_ event: WeatherUpdated)
}

class WeatherDataAutoUpdater
{
    var delegate                   : WeatherDataAutoUpdaterDelegate?
    
    private var timer              : Timer?
    
    private let data               : WeatherDataModel
    
    private let weatherDataService : OpenWeatherClient
    private let geoLocationService : GeoLocationReceiver
    
    // MARK: - Init
    
    init(with model: WeatherDataModel)
    {
        self.data = model
        
        self.weatherDataService = OpenWeatherClient()
        self.geoLocationService = Settings.geoService
    }
    
    // MARK: - Business Logic Related Methods
    
    func activateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // TODO: Forcibly update weather data if needed
        
        // TODO: Start weather data auto updating
        //       to keep weather data up-to-date from time to time
    }
    
    func disactivateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // TODO: Stop weather data auto updating
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
}
