//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 24.12.2021.
//

import Foundation

class WeatherViewModel: WeatherDataAutoUpdaterDelegate
{
    // MARK: - Servants
    
    /// It's responsible for keeping weather data in actual state
    private let dataKeeper: WeatherDataAutoUpdater
    
    // MARK: - Operational Data
    
    /// The reference to the data
    private let dataModel : WeatherDataModel
    
    // MARK: - Host View
    
    /// The reference to the view representing the actual data
    var weatherView       : WeatherLayoutView?
    
    // MARK: - Init
    
    init()
    {
        #if DEBUG
        print(">> [\(type(of: self))].init")
        #endif
        
        dataModel = WeatherDataModel()
        dataKeeper = WeatherDataAutoUpdater(data: dataModel)
        
        dataKeeper.delegate = self
    }
    
    // MARK: - Business Logic Methods
    
    func startAutoUpdatingWeatherData()
    {
        if !dataKeeper.activated { dataKeeper.activateAutoUpdating() }
    }
    
    func stopAutoUpdatingWeatherData()
    {
        dataKeeper.disactivateAutoUpdating()
    }
    
    // MARK: - WeatherActualDataKeeperDelegate
    
    func weatherDataUpdated()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard let _ = weatherView else { return }
        
        // Do the weaather view reload from here
    }
    
    func weatherAlertsUpdated()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard let _ = weatherView else { return }
        
        // Do the weaather view reload from here
    }
    
    func locationServiceNotAllowed(_ reason: LocationServiceNotAllowed)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        print("reason  : \(reason)")
        #endif
        
        guard let _ = weatherView else { return }
        
        // Do inform user about location service not allowed
    }
    
    func failedToGetCurrentLocation(_ error: LocationReceivedError)
    {
        guard let _ = weatherView else { return }
        
        // Do inform user about something went wrong
        
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        print("error: \(error)")
        #endif
    }
    
    func failedToDeliverWeatherData(_ error : WeatherDataDeliveryError)
    {
        guard let _ = weatherView else { return }
        
        // Do inform user about something went wrong
        
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        print("error: \(error)")
        #endif
    }
}
