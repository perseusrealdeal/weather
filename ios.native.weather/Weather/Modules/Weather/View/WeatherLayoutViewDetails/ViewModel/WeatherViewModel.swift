//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 24.12.2021.
//

import UIKit

class WeatherViewModel : WeatherDataAutoUpdaterDelegate
{
    // MARK: - Servants
    
    /// It's responsible for keeping weather data in actual state
    private let dataKeeper : WeatherDataAutoUpdater
    
    // MARK: - Operational Data
    
    /// The reference to the data
    private let dataModel  : WeatherDataModel
    
    // MARK: - Host View
    
    /// The reference to the view representing the actual data
    var weatherView        : WeatherLayoutView?
    
    // MARK: - Init
    
    init()
    {
        dataModel = WeatherDataModel()
        dataKeeper = WeatherDataAutoUpdater(with: dataModel)
        
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
    
    func weatherDataUpdated(onlyAlerts: Bool)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        print("Only Alerts Received: \(onlyAlerts)")
        print("-----------------------------------")
        #endif
        
        guard let _ = weatherView else { return }
        
        // Do reload of the weaather view
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
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
}
