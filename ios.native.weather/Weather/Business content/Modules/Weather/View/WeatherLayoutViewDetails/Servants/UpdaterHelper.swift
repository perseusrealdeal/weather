//
//  ServantsHelpers.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 17.01.2022.
//

import Foundation

let UPDATE_INTERVALS        : [Double] = [1, 5, 10, 20, 30] // Per 1 minute, per 5...

// Used for reloading alerts and conditional updating current, forecasts hourly, and daily
let UPDATE_JOB_INTERVAL     : Double = UPDATE_INTERVALS[0] // Given in minutes

// Used for forcibly updating all weather data parts.
// It works in the UPDATE_JOB_INTERVAL time circle and should be meant as <not early then>
let FORCIBLY_UPDATE_INTERVAL: Double = UPDATE_INTERVALS[1] // Given in minutes

protocol UpdaterHelperProtocol
{
    func registerCurrentLocationObserver(observer: Any, selector: Selector)
    func removeCurrentLocationObserver(observer: Any)

    func calculateDelay() -> TimeInterval
    func calculateExclude(data: WeatherDataModel) -> String
    func calculateForciblyUpdateCondition(data: WeatherDataModel) -> Bool
    func prepareTimer(target: Any, delay: TimeInterval, selector: Selector) -> Timer
}

class UpdaterHelper: UpdaterHelperProtocol
{
    func registerCurrentLocationObserver(observer: Any, selector: Selector)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        let nCenter = Settings.notificationCenter

        nCenter.addObserver(observer,
                            selector: selector,
                            name    : .locationReceivedNotification,
                            object  : nil)
    }

    func removeCurrentLocationObserver(observer: Any)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        let nCenter = Settings.notificationCenter

        nCenter.removeObserver(observer, name: .locationReceivedNotification, object: nil)
    }

    // MARK: - Contruct performance helpers

    func calculateDelay() -> TimeInterval
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        let interval = UPDATE_JOB_INTERVAL

        // Calculate the closest interval

        let minuts         : Double = Double(Calendar.current.component(.minute, from: Date()))
        let seconds        : Double = Double(Calendar.current.component(.second, from: Date()))

        let intervalsPassed: Double = (minuts / interval).rounded(.down)
        let closestInterval: Double = intervalsPassed + 1

        // Calculate the delay

        let period         : Double = interval * 60 // now in seconds
        let delay          : Double = closestInterval * period - (minuts * 60 + seconds)

        return delay // in seconds
    }

    func calculateExclude(data: WeatherDataModel) -> String
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

        /// Alerts should be reloaded anyway, so alerts not in exclude
        return exclude
    }

    func calculateForciblyUpdateCondition(data: WeatherDataModel) -> Bool
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard let lastUpdate = data.lastFullUpdateTime else { return false }

        let now         : Double = Date().timeIntervalSince1970
        let timeToUpdate: Double = lastUpdate.dt + FORCIBLY_UPDATE_INTERVAL * 60

        let result      : Bool = now >= timeToUpdate

        return result
    }

    #if DEBUG
    var useTimeIntervalForUnitTest = false
    #endif

    func prepareTimer(target: Any, delay: TimeInterval, selector: Selector) -> Timer
    {
        let nextFireTime     : Date = Date().addingTimeInterval(delay)
        let intervalInSeconds: Double = UPDATE_JOB_INTERVAL * 60

        print("nextFireTime : \(nextFireTime)")
        print("delay        : \(delay)")

        // DONE: Start timer

        #if DEBUG
        let interval = useTimeIntervalForUnitTest ? intervalInSeconds / 1000.0 : intervalInSeconds
        #else
        let interval = intervalInSeconds
        #endif

        let timer = Timer(fireAt  : nextFireTime,
                          interval: interval,
                          target  : target,
                          selector: selector,
                          userInfo: nil,
                          repeats : true)

        timer.tolerance = 0.2

        RunLoop.main.add(timer, forMode: .common)

        return timer
    }

}
