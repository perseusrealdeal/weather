//
//  WeatherDataAutoUpdater.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 26.12.2021.
//

import Foundation

fileprivate let UPDATE_INTERVALS         : [Double] = [1, 5, 10, 20, 30] // Per 1 minute, per 5...

// Used for reloading alerts and conditional updating current, forecasts hourly, and daily
fileprivate let UPDATE_JOB_INTERVAL      : Double = UPDATE_INTERVALS[0] // Given in minutes

// Used for forcibly updating all weather data parts.
// It works in the UPDATE_JOB_INTERVAL time circle and should be meant as <not early then>
fileprivate let FORCIBLY_UPDATE_INTERVAL : Double = UPDATE_INTERVALS[1] // Given in minutes

protocol WeatherDataAutoUpdaterDelegate
{
    /// Delegate view reloading activities
    func weatherDataUpdated(onlyAlerts: Bool)
    
    /// Let delegate know that location services not allowed
    func locationServiceNotAllowed(_ reason: LocationServiceNotAllowed)
    
    /// Inform delegate if something went wrong
    func failedToGetCurrentLocation(_ error: LocationReceivedError)
    func failedToDeliverWeatherData(_ error: WeatherDataDeliveryError)
}

class WeatherDataAutoUpdater
{
    var delegate                    : WeatherDataAutoUpdaterDelegate?
    
    private var timer               : Timer?
    
    private let data                : WeatherDataModel
    
    private let weatherDataService  : OpenWeatherClient
    private let geoLocationService  : GeoLocationReceiver
    
    private var _activated          : Bool = false
    var activated                   : Bool { _activated }
    
    // MARK: - Init
    
    init(with model: WeatherDataModel)
    {
        data = model
        
        weatherDataService = OpenWeatherClient()
        geoLocationService = Settings.geoService
        
        weatherDataService.onResultDelivered = weatherDataDeliveredHandler(_:)
    }
    
    // MARK: - Business contruct
    
    func activateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        if activated
        {
            #if DEBUG
            print("UPDATER : I'm already activated, there's no need to make it twice :)")
            #endif
            
            return
        }
        
        // DONE: Awareness of current location
        
        registerCurrentLocationObserver()
        
        // DONE: Weather data auto updating
        
        initiateAutoUpdate()
        
        // DONE: Note auto updating is already activated
        
        _activated = true
    }
    
    func disactivateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // There's no need to be aware of current location any more
        
        removeCurrentLocationObserver()
        
        // DONE: Stop weather data auto updating
        
        timer?.invalidate()
        timer = nil
        
        _activated = false
    }
    
    // MARK: - Сontract performance
    
    private func initiateAutoUpdate()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // DONE: Do calculations for making update repeatedly
        
        let delay             : Double = calculateDelay()
        let nextFireTime      : Date = Date().addingTimeInterval(delay)
        let intervalInSeconds : Double = UPDATE_JOB_INTERVAL * 60
        
        print("nextFireTime : \(nextFireTime)")
        print("delay        : \(delay)")
        
        // DONE: Start timer
        
        timer = Timer(fireAt   : nextFireTime,
                      interval : intervalInSeconds,
                      target   : self,
                      selector : #selector(updateWeatherDataIfNeeded),
                      userInfo : nil,
                      repeats  : true)
        
        timer!.tolerance = 0.2
        
        RunLoop.main.add(timer!, forMode: .common)
        
        // DONE: Update weather data right now if needed
        
        if delay > 0 { updateWeatherDataIfNeeded() }
        
    }
    
    @objc private func updateWeatherDataIfNeeded()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        print("time         : \(Date())")
        
        // DONE: Request current location and wait to be notified
        
        geoLocationService.requestLocationUpdateOnce()
        { reason in // Called in case if location service not allowed
            
            // DONE: Let user know what becouse when location service not allowed
            
            self.delegate?.locationServiceNotAllowed(reason)
            
            // DONE: Update with presetted options
            
            self.updateIfNeeded()
        }
    }
    
    /// Non-conditional update
    private func updateForcibly(for location: Сoordinate)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        updateWeatherData(exclude: "minutely", location)
    }
    
    /// Conditional update
    private func updateIfNeeded()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // Is there no update done yet at all?
        
        guard let target = self.data.target else
        {
            // If there no data: forcibly update for the default location
            
            updateWeatherData(exclude: "minutely", Settings.defaultLocation)
            
            return
        }
        
        // otherwise: the time of the last update should be taken into account
        
        // Is a whole update should be done?
        
        calculateForciblyUpdateCondition() ?
            
            // It's time to make a whole update
            
            updateWeatherData(exclude: "minutely", target.location) :
            
            // Make a partial update
            
            updateWeatherData(exclude: calculateExclude(), target.location)
    }
    
    // MARK: - Contruct data inputs
    
    @objc private func locationReceivedNotificationHandler(_ notification: Notification)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard let result = notification.object as? Result<Сoordinate, LocationReceivedError>
        else { return }
        
        // The current location should be taken into account,
        // so there's a few things to take care of
        
        var locationReceived  : Сoordinate?
        var isLocationChanged : Bool?
        
        var locationError     : LocationReceivedError?
        
        switch result
        {
        // Here we are, whatta happy case?
        case .success(let location):
            locationReceived = location
        
        // What if something really went wrong?
        case .failure(let error):
            locationError = error
        }
        
        if let locationReceived = locationReceived
        {
            if let target = data.target
            {
                isLocationChanged = locationReceived == target.location ? false : true
            }
            else
            {
                isLocationChanged = true
            }
        }
        
        if let error = locationError
        {
            delegate?.failedToGetCurrentLocation(error)
        }
        else if let locationChanged = isLocationChanged, locationChanged
        {
            updateForcibly(for: locationReceived!)
            return
        }
        
        updateIfNeeded()
    }
    
    private func weatherDataDeliveredHandler(_ result: Result<Data, WeatherDataDeliveryError>)
    {
        var dataDeliveried    : Data?
        var dataDeliveryError : WeatherDataDeliveryError?
        
        switch result
        {
        case .success(let data):
            dataDeliveried = data
            
        case .failure(let error):
            dataDeliveryError = error
        }
        
        if let error = dataDeliveryError
        {
            delegate?.failedToDeliverWeatherData(error)
        }
        else if let freshData = dataDeliveried
        {
            data.update(received: freshData)
            { onlyAlerts in
                weatherDataDeliverySucceeded(onlyAlerts: onlyAlerts)
            }
        }
    }
    
    // MARK: - Contruct data outputs
    
    private func weatherDataDeliverySucceeded(onlyAlerts: Bool = false)
    {
        // DONE: Inform delegate that data was updated successfully
        
        delegate?.weatherDataUpdated(onlyAlerts: onlyAlerts)
    }
    
    // MARK: - Contruct business operations
    
    private func updateWeatherData(exclude: String, _ location: Сoordinate)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        
        print("exclude      : \(exclude)")
        print("location     : \(location)")
        #endif
        
        // Request weather data
        
        weatherDataService.updateWeatherData(exclude  : exclude,
                                             latitude : location.latitude.description,
                                             longitude: location.longitude.description)
    }
    
    private func registerCurrentLocationObserver()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        let nCenter = Settings.notificationCenter
        
        nCenter.addObserver(
            self,
            selector: #selector(locationReceivedNotificationHandler(_:)),
            name: .locationReceivedNotification,
            object: nil)
    }
    
    private func removeCurrentLocationObserver()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        let nCenter = Settings.notificationCenter
        
        nCenter.removeObserver(
            self,
            name: .locationReceivedNotification,
            object: nil)
    }
    
    // MARK: - Contruct performance helpers
    
    private func calculateDelay() -> TimeInterval
    {
        let interval = UPDATE_JOB_INTERVAL
        
        // Calculate the closest interval
        
        let minuts          : Double = Double(Calendar.current.component(.minute, from: Date()))
        let seconds         : Double = Double(Calendar.current.component(.second, from: Date()))
        
        let intervalsPassed : Double = (minuts / interval).rounded(.down)
        let closestInterval : Double = intervalsPassed + 1
        
        // Calculate the delay
        
        let period          : Double = interval * 60
        let delay           : Double = closestInterval * period - (minuts * 60 + seconds)
        
        return delay
    }
    
    private func calculateExclude() -> String
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        var exclude : String = "minutely"
        
        if data.isForecastHourlyUpToDate { exclude.append(",hourly") }
        if data.isForecastDailyUpToDate { exclude.append(",daily") }
        if data.isForecastCurrentUpToDate{ exclude.append(",current") }
        
        #if DEBUG
        print("calculated   : \(exclude)")
        #endif
        
        /// Alerts should be reloaded anyway, so alerts not in exlude
        return exclude
    }
    
    private func calculateForciblyUpdateCondition() -> Bool
    {
        guard let lastUpdate = data.lastFullUpdateTime else { return false }
        
        let now          : Double = Date().timeIntervalSince1970
        let timeToUpdate : Double = lastUpdate.dt + FORCIBLY_UPDATE_INTERVAL * 60
        
        let result       : Bool = now >= timeToUpdate
        
        return result
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
}
