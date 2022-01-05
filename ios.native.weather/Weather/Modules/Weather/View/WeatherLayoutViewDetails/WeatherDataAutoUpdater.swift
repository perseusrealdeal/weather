//
//  WeatherDataAutoUpdater.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 26.12.2021.
//

import Foundation

fileprivate let UPDATE_INTERVALS         : [Double] = [1, 5, 10, 20, 30] // Per 1 minute, per 5...

// Used for reloading alerts and conditional updating current, forecasts hourly, and daily
fileprivate let UPDATE_JOB_INTERVAL      : Double = UPDATE_INTERVALS[1] // Given in minutes

// Used for forcibly updating all weather data.
// It works in UPDATE_JOB_INTERVAL time circle and should be meant as not early then
fileprivate let FORCIBLY_UPDATE_INTERVAL : Double = UPDATE_INTERVALS[4] // Given in minutes

protocol WeatherDataAutoUpdaterDelegate
{
    func weatherDataUpdated()
    
    func locationServiceNotAllowed(_ reason: LocationServiceNotAllowed)
    func failedToGetCurrentLocation(_ error: LocationReceivedError)
}

class WeatherDataAutoUpdater
{
    var delegate                   : WeatherDataAutoUpdaterDelegate?
    
    private var timer              : Timer?
    
    private let data               : WeatherDataModel
    
    private let weatherDataService : OpenWeatherClient
    private let geoLocationService : GeoLocationReceiver
    
    private var _isUpdaterActivated : Bool = false
    var isUpdaterActivated          : Bool { _isUpdaterActivated }
    
    // MARK: - Init
    
    init(with model: WeatherDataModel)
    {
        self.data = model
        
        self.weatherDataService = OpenWeatherClient()
        self.geoLocationService = Settings.geoService
    }
    
    // MARK: - Business contruct
    
    func activateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard _isUpdaterActivated == false else
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
        
        _isUpdaterActivated = true
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
        
        _isUpdaterActivated = false
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
        
        print("time    : \(Date())")
        
        // DONE: Request current location and wait to be notified
        
        geoLocationService.requestLocationUpdateOnce()
        { reason in // Called in case if location service not allowed
            
            // DONE: Let user know what becouse when location service not allowed
            
            if let delegate = self.delegate { delegate.locationServiceNotAllowed(reason) }
            
            // DONE: Update with presetted options
            
            self.updateIfNeeded()
        }
    }
    
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
            if let delegate = self.delegate { delegate.failedToGetCurrentLocation(error) }
        }
        else if let locationChanged = isLocationChanged, locationChanged
        {
            updateForcibly(for: locationReceived!)
            return
        }
        
        updateIfNeeded()
    }
    
    /// Non-conditional update
    private func updateForcibly(for location: Сoordinate)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        makeUpdate(exclude: "minutely", location)
    }
    
    /// Conditional update
    private func updateIfNeeded()
    {
        // Is there no update done yet at all?
        
        guard let target = self.data.target else
        {
            // If there no data: forcibly update for the default location
            
            makeUpdate(exclude: "minutely", Settings.defaultLocation)
            
            return
        }
        
        // otherwise: the time of the last update should be taken into account
        
        // Is a whole update should be done?
        
        calculateForciblyUpdateCondition() ?
            
            // It's time to make a whole update
            
            makeUpdate(exclude: "minutely", target.location) :
            
            // Make a partial update
            
            makeUpdate(exclude: calculateExclude(), target.location)
    }
    
    // MARK: - Contruct business operations
    
    private func makeUpdate(exclude: String, _ location: Сoordinate)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // Do weather data update here, request and parse weather data
        
        print("exclude : \(exclude)")
        print("for     : \(location)")
        
        // Save the time of the last whole weather data update
        
        if exclude == "minutely"
        {
            data.timeFromLastFullUpdate = Date().timeIntervalSince1970
            data.target = CurrentLocationDescription(latitude        : location._latitude,
                                                    longitude       : location._longitude,
                                                    locationTitle   : "",
                                                    timezone_offset : 0.0)
        }
        
        delegate?.weatherDataUpdated()
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
        
        let minuts : Double = Double(Calendar.current.component(.minute, from: Date()))
        let seconds: Double = Double(Calendar.current.component(.second, from: Date()))
        
        let intervalsPassed : Double = (minuts / interval).rounded(.down)
        
        let delay : Double = (intervalsPassed + 1) * interval * 60 - (minuts * 60 + seconds)
        
        return delay
    }
    
    /// If forcibly is true then forecasts Daily and Current
    private func calculateExclude(notForciblyForecastHourly : Bool = true,
                                  notForciblyForecastDaily  : Bool = true,
                                  notForciblyCurrent        : Bool = true) -> String
    {
        var exlude : String = "minutely"
        
        if data.isForecastHourlyUpToDate, notForciblyForecastHourly
        { exlude.append(",hourly") }
        
        if data.isForecastDailyUpToDate, notForciblyForecastDaily
        { exlude.append(",daily") }
        
        if data.isForecastCurrentUpToDate, notForciblyCurrent
        { exlude.append(",current") }
        
        /// Alerts should be reloaded anyway, so alerts not in exlude
        return exlude
    }
    
    private func calculateForciblyUpdateCondition() -> Bool
    {
        guard let lastUpdate = data.timeFromLastFullUpdate else { return false }
        
        let now = Date().timeIntervalSince1970
        let timeToUpdate = lastUpdate + FORCIBLY_UPDATE_INTERVAL * 60
        
        return now >= timeToUpdate
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
}
