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
    
    /// It's responsible for keeping weather data always actual
    private let dataKeeper : WeatherDataAutoUpdater
    
    // MARK: - Operational Data
    
    /// Actual data for passing to views to be shown on screen
    private let dataModel  : WeatherDataModel
    
    // MARK: - Host View
    
    var weatherView        : WeatherLayoutView?
    
    // MARK: - Init
    
    init()
    {
        dataModel = WeatherDataModel()
        dataKeeper = WeatherDataAutoUpdater(with: dataModel)
        
        dataKeeper.delegate = self
    }
    
    // MARK: - Business Logic Related Methods
    
    func startAutoUpdatingWeatherData()
    {
        dataKeeper.activateAutoUpdating()
    }
    
    func stopAutoUpdatingWeatherData()
    {
        dataKeeper.disactivateAutoUpdating()
    }
    
    // MARK: - WeatherActualDataKeeperDelegate
    
    func weatherDataChanged(_ event: WeatherUpdated)
    {
        guard let _ = weatherView else { return }
        
        /// TODO: Handle weather data changed event
        
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> \(type(of: self)).deinit")
        #endif
    }
}
