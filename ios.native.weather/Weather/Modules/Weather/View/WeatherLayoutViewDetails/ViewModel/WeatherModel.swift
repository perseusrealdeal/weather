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
    var forecastDayly      : [ForecastDay]?
    var currentWeather     : CurrentWeather?
    
}

struct NationalAlert
{
    
}

struct ForecastHour
{
    
}

struct ForecastDay
{
    
}

struct CurrentWeather
{
    /// Current Location
    
    let latitude      : String
    let longitude     : String
    
    let locationTitle : String
    
    /// Other Fields
}
