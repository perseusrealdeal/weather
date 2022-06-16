//
//  DataStructures.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 07.01.2022.
//

import Foundation

/// National weather alerts data from major national weather warning systems
struct NationalAlert
{
    /// Date and time of the start of the alert, Unix, UTC
    let start           : Double

    /// Date and time of the end of the alert, Unix, UTC
    let end             : Double

    /// Other Fields
}

/// Hourly forecast weather data API response
struct ForecastHour
{
    /// Time of the forecasted data, Unix, UTC
    let dt              : Double

    /// Other Fields
}

///  Daily forecast weather data API response
struct ForecastDay
{
    /// Time of the forecasted data, Unix, UTC
    let dt              : Double

    /// Other Fields
}

struct CurrentWeather
{
    /// Time of the forecasted data, Unix, UTC
    let dt              : Double

    /// Other Fields
}

struct CurrentLocationDescription
{
    /// Current Location
    let latitude        : Double
    let longitude       : Double

    /// Shift in seconds from UTC
    let timezone_offset : Double
}

struct LastFullUpdateTime
{
    /// Time of the last full data update, Unix, UTC
    let dt              : Double
}

extension CurrentLocationDescription
{
    var location: Сoordinate
    {
        Сoordinate(latitude: latitude, longitude: longitude)
    }
}
