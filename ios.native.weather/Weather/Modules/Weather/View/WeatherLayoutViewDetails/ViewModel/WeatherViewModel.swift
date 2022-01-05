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
        guard dataKeeper.isUpdaterActivated else { return }
         
        dataKeeper.activateAutoUpdating()
    }
    
    func stopAutoUpdatingWeatherData() { dataKeeper.disactivateAutoUpdating() }
    
    // MARK: - WeatherActualDataKeeperDelegate
    
    func weatherDataUpdated()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
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
        
        // Do inform user that location service not allowed
    }
    
    func failedToGetCurrentLocation(_ error: LocationReceivedError)
    {
        guard let _ = weatherView else { return }
        
        // Do inform user that something went wrong
        
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
