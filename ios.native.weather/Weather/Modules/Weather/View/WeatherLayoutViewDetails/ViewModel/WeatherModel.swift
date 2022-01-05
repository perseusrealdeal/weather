//
//  WeatherModel.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 24.12.2021.
//

import Foundation

class WeatherDataModel
{
    // MARK: - Business Matter Data
    
    var alerts             : [NationalAlert]?
    var forecastHourly     : [ForecastHour]?
    var forecastDaily      : [ForecastDay]?
    var currentWeather     : CurrentWeather?
    
    // MARK: - Service Matter Data
    
    var target                     : CurrentLocationDescription?
    
    var timeFromLastFullUpdate     : Double? // UTC
    
    var isForecastHourlyUpToDate   : Bool
    {
        guard let timeOfFirstForecastHour = forecastHourly?.first?.dt
        else { return false }
        
        let timeNow = Date().timeIntervalSince1970
        
        return timeNow < timeOfFirstForecastHour
    }
    
    var isForecastDailyUpToDate    : Bool
    {
        if let today = forecastDaily?.first?.dt
        {
            return isDayUpToDate(from: today)
        }
        
        return false
    }
    
    var isForecastCurrentUpToDate  : Bool
    {
        if let today = currentWeather?.dt
        {
            return isDayUpToDate(from: today)
        }
        
        return false
    }
    
    // MARK: - Init
    
    init() { }
    
    // MARK: Other calculations
    
    private func isDayUpToDate(from: Double) -> Bool
    {
        guard let offset = target?.timezone_offset else { return false }
        
        let timeOfDay = Date(timeIntervalSince1970: from).addingTimeInterval(offset)
        
        let startOfDay =  Calendar.current.startOfDay(for: timeOfDay).addingTimeInterval(offset)
        
        let components = DateComponents(hour: 23, minute: 59, second: 59)
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
        
        let timeNow = Date().addingTimeInterval(offset)
        
        return timeNow < endOfDay
    }
}

/// National weather alerts data from major national weather warning systems
struct NationalAlert
{
    /// Date and time of the start of the alert, Unix, UTC
    let start      : Double
    
    /// Date and time of the end of the alert, Unix, UTC
    let end        : Double
    
    /// Other Fields
}

/// Hourly forecast weather data API response
struct ForecastHour
{
    /// Time of the forecasted data, Unix, UTC
    let dt        : Double
    
    /// Other Fields
}

///  Daily forecast weather data API response
struct ForecastDay
{
    /// Time of the forecasted data, Unix, UTC
    let dt        : Double
    
    /// Other Fields
}

struct CurrentWeather
{
    /// Time of the forecasted data, Unix, UTC
    let dt        : Double
    
    /// Other Fields
}

struct CurrentLocationDescription
{
    /// Current Location
    let latitude        : Double
    let longitude       : Double
    
    let locationTitle   : String
    
    /// Shift in seconds from UTC
    let timezone_offset : Double
    
    var location : Сoordinate
    {
        Сoordinate(latitude: latitude, longitude: longitude)
    }
}
