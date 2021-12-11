//
//  SettingsBundleFunctionalTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 11.12.2021.
//

import XCTest
@testable import Weather

class SettingsBundleFunctionalTests: XCTestCase
{
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    
    private let defaults = Settings.userDefaults
    
    override func setUp()
    {
        super.setUp()
        
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)
    }
    
    // MARK: - Functional testing temperature parameter setup
    
    func test_temperature_should_be_registered()
    {
        let actual = defaults.string(forKey: "temperature_preference")
        let expected_values = "temperature_preference".valuesFromSettings
        let expected_default_value = "temperature_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Temperature preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Temperature values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Temperature default value hasn't been registered.")
    }
    
    func test_temperature_should_be_configured()
    {
        let requirement_values = ["celsius", "fahrenheit"]
        let requirement_default_value = "celsius"
        
        guard
            let actual_default_value = defaults.string(forKey: "temperature_preference"),
            let expected_values = "temperature_preference".valuesFromSettings,
            let expected_default_value = "temperature_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing wind speed parameter setup
    
    func test_wind_speed_should_be_registered()
    {
        let actual = defaults.string(forKey: "wind_speed_preference")
        let expected_values = "wind_speed_preference".valuesFromSettings
        let expected_default_value = "wind_speed_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Wind preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Wind values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Wind default value hasn't been registered.")
    }
    
    func test_wind_speed_should_be_configured()
    {
        let requirement_values = ["m/s", "km/h", "mph"]
        let requirement_default_value = "m/s"
        
        guard
            let actual_default_value = defaults.string(forKey: "wind_speed_preference"),
            let expected_values = "wind_speed_preference".valuesFromSettings,
            let expected_default_value = "wind_speed_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing pressure parameter setup
    
    func test_pressure_should_be_registered()
    {
        let actual = defaults.string(forKey: "pressure_preference")
        let expected_values = "pressure_preference".valuesFromSettings
        let expected_default_value = "pressure_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Pressure preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Pressure values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Pressure default value hasn't been registered.")
    }
    
    func test_pressure_should_be_configured()
    {
        let requirement_values = ["hPa", "mmHg", "inHg"]
        let requirement_default_value = "mmHg"
        
        guard
            let actual_default_value = defaults.string(forKey: "pressure_preference"),
            let expected_values = "pressure_preference".valuesFromSettings,
            let expected_default_value = "pressure_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing precipitation parameter setup
    
    func test_precipitation_should_be_registered()
    {
        let actual = defaults.string(forKey: "precipitation_preference")
        let expected_values = "precipitation_preference".valuesFromSettings
        let expected_default_value = "precipitation_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Precipitation preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Precipitation values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Precipitation default value hasn't been registered.")
    }
    
    func test_precipitation_should_be_configured()
    {
        let requirement_values = ["mm", "in"]
        let requirement_default_value = "mm"
        
        guard
            let actual_default_value = defaults.string(forKey: "precipitation_preference"),
            let expected_values = "precipitation_preference".valuesFromSettings,
            let expected_default_value = "precipitation_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing distance parameter setup
    
    func test_distance_should_be_registered()
    {
        let actual = defaults.string(forKey: "distance_preference")
        let expected_values = "distance_preference".valuesFromSettings
        let expected_default_value = "distance_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Distance preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Distance values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Distance default value hasn't been registered.")
    }
    
    func test_distance_should_be_configured()
    {
        let requirement_values = ["km", "mi"]
        let requirement_default_value = "km"
        
        guard
            let actual_default_value = defaults.string(forKey: "distance_preference"),
            let expected_values = "distance_preference".valuesFromSettings,
            let expected_default_value = "distance_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing time format parameter setup
    
    func test_time_format_should_be_registered()
    {
        let actual = defaults.string(forKey: "time_format_preference")
        let expected_values = "time_format_preference".valuesFromSettings
        let expected_default_value = "time_format_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Distance preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Distance values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Distance default value hasn't been registered.")
    }
    
    func test_time_format_should_be_configured()
    {
        let requirement_values = ["24-hour", "12-hour"]
        let requirement_default_value = "24-hour"
        
        guard
            let actual_default_value = defaults.string(forKey: "time_format_preference"),
            let expected_values = "time_format_preference".valuesFromSettings,
            let expected_default_value = "time_format_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
    
    // MARK: - Functional testing focus on parameter setup
    
    func test_focus_on_should_be_registered()
    {
        let actual = defaults.string(forKey: "focus_on_preference")
        let expected_values = "focus_on_preference".valuesFromSettings
        let expected_default_value = "focus_on_preference".defaultValueFromSettings
        
        XCTAssertNotNil(actual, "Distance preference hasn't been registered.")
        XCTAssertNotNil(expected_values, "Distance values haven't been registered.")
        XCTAssertNotNil(expected_default_value, "Distance default value hasn't been registered.")
    }
    
    func test_focus_on_should_be_configured()
    {
        let requirement_values = ["day", "night"]
        let requirement_default_value = "night"
        
        guard
            let actual_default_value = defaults.string(forKey: "focus_on_preference"),
            let expected_values = "focus_on_preference".valuesFromSettings,
            let expected_default_value = "focus_on_preference".defaultValueFromSettings
        else { XCTFail("There is a problem with extracting values from Settings.bundle."); return }
        
        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "Actual default value doesn't meet requirements.")
        
        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "Temperature option values do not meet requirements.")
        
        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "Expected default value doesn't meet requirement.")
    }
}
