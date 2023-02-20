//
//  WeatherDataAutoUpdater.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 26.12.2021.
//
// swiftlint:disable file_length
//

import Foundation

protocol WeatherDataAutoUpdaterDelegate: AnyObject {
    /// Delegate view reloading activities
    func weatherDataUpdated()
    func weatherAlertsUpdated()

    /// Let delegate know that location services not allowed
    func locationServiceNotAllowed(_ reason: LocationServiceNotAllowed)

    /// Inform delegate if something went wrong
    func failedToGetCurrentLocation(_ error: LocationReceivedError)
    func failedToDeliverWeatherData(_ error: WeatherDataDeliveryError)
}

class WeatherDataAutoUpdater {
    // MARK: - Business properties

    // emgine

    private(set) var timer: Timer!
    private(set) var data: WeatherDataModel

    // flags

    private var _activated: Bool = false
    var activated: Bool { return _activated }

    /// True — CoreLocation for updating, otherwise what's given explicitly
    var useCurrentLocation: Bool = false

    // services

    private(set) var weatherDataService: WeatherClientProtocol
    private(set) var geoLocationService: GeoLocationServiceProtocol

    // helpers

    private(set) var helper: UpdaterHelperProtocol

    // notifiers

    weak var delegate: WeatherDataAutoUpdaterDelegate?

    // MARK: - Initializer

    init(data: WeatherDataModel,
         helper: UpdaterHelperProtocol = UpdaterHelper(),
         weatherDataService: WeatherClientProtocol = OpenWeatherClient(),
         geoLocationService: GeoLocationServiceProtocol = GeoLocationReceiver.shared) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        self.data = data
        self.helper = helper

        self.weatherDataService = weatherDataService
        self.geoLocationService = geoLocationService
    }

    // MARK: - Business contruct

    func activateAutoUpdating()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        // DONE: Turn around if job is alredy done

        if activated
        {
            #if DEBUG
            print("UPDATER: I'm already activated, there's no need to make it twice, thanks!")
            #endif

            return
        }

        // DONE: Awareness of current location

        helper.registerCurrentLocationObserver(
            observer: self,
            selector: #selector(locationReceivedNotificationHandler(_:)))

        // DONE: Weather data auto updating engine setup

        let delay = helper.calculateDelay()

        timer = helper.prepareTimer(target: self,
                                    delay: delay,
                                    selector: #selector(onTick))

        // Update weather data right now if needed

        if delay > 0 { updateWeatherDataIfNeeded() }

        // DONE: Auto updating has been activated, marked

        _activated = true
    }

    func disactivateAutoUpdating() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        // There's no need to be aware of current location any more

        helper.removeCurrentLocationObserver(observer: self)

        // DONE: Weather data auto updating has been stopped, marked

        timer?.invalidate()
        timer = nil

        _activated = false
    }

    func updateWeatherDataIfNeeded()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard useCurrentLocation == true else { updateIfNeeded(); return }

        geoLocationService.requestLocationUpdateOnce { reason in
            // Called in case if location service not allowed

            // DONE: Let user know what becouse when location service not allowed

            self.delegate?.locationServiceNotAllowed(reason)

            // DONE: Update with presetted options

            self.updateIfNeeded()
        }
    }

    // MARK: - Timer's onTick method

    @objc private func onTick() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        updateWeatherDataIfNeeded()
    }

    // MARK: - Business contract performance

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

        helper.calculateForciblyUpdateCondition(data: data) ?

            // It's time to make a whole update

            updateWeatherData(exclude: "minutely", target.location) :

            // Make a partial update

            updateWeatherData(exclude: helper.calculateExclude(data: data), target.location)
    }

    /// Non-conditional update
    private func updateForcibly(for location: Сoordinate) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        updateWeatherData(exclude: "minutely", location)
    }

    // MARK: - Business contruct data inputs

    @objc func locationReceivedNotificationHandler(_ notification: Notification)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard let result = notification.object
            as? Result<Сoordinate, LocationReceivedError>
        else { return }

        // The current location should be taken into account,
        // so there's a few things to take care of

        var locationReceived: Сoordinate?
        var isLocationChanged: Bool?

        var locationError: LocationReceivedError?

        switch result {
        // Here we are, whatta happy case?
        case .success(let location):
            locationReceived = location

        // What if something really went wrong?
        case .failure(let error):
            locationError = error
        }

        if let locationReceived = locationReceived {
            if let target = data.target {
                isLocationChanged = locationReceived == target.location ? false : true
            } else {
                isLocationChanged = true
            }
        }

        if let error = locationError {
            delegate?.failedToGetCurrentLocation(error)
        } else if let locationChanged = isLocationChanged, locationChanged {
            updateForcibly(for: locationReceived!)
            return
        }

        updateIfNeeded()
    }

    func weatherDataDeliveredHandler(_ result: Result<Data, WeatherDataDeliveryError>) {
        var dataDeliveried: Data?
        var dataDeliveryError: WeatherDataDeliveryError?

        switch result {
        case .success(let data): dataDeliveried = data
        case .failure(let error): dataDeliveryError = error
        }

        if let error = dataDeliveryError {
            delegate?.failedToDeliverWeatherData(error)
        } else if let freshData = dataDeliveried {
            data.update(received: freshData) { isAlertsOnly in
                isAlertsOnly ? delegate?.weatherAlertsUpdated() :
                    delegate?.weatherDataUpdated()
            }
        }
    }

    // MARK: - Business contruct business operations

    private func updateWeatherData(exclude: String, _ location: Сoordinate) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)

        print("exclude      : \(exclude)")
        print("location     : \(location)")
        #endif

        // Request weather data

        weatherDataService.requestWeatherData(exclude: exclude,
                                              latitude: String(location.latitude),
                                              longitude: String(location.longitude))
    }
}
