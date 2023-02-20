//
//  SettingsBundleFunctionalTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//
// swiftlint:disable file_length
//

import XCTest
@testable import Weather

class SettingsBundleFunctionalTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    private let defaults = Settings.userDefaults

    override func setUp() {
        super.setUp()

        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)
    }

    // MARK: - TEMPERATURE

    func test_temperature_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "temperature_preference")
        let expected_values = "temperature_preference".valuesFromSettings
        let expected_default_value = "temperature_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "TEMPERATURE".notNil)
        XCTAssertNotNil(expected_values, "TEMPERATURE values".notNil)
        XCTAssertNotNil(expected_default_value, "TEMPERATURE default value".notNil)
    }

    func test_temperature_should_be_configured() {

        // arrange

        let requirement_values = ["celsius", "fahrenheit"]
        let requirement_default_value = "celsius"

        guard
            let actual_default_value = defaults.string(forKey: "temperature_preference"),
            let expected_values = "temperature_preference".valuesFromSettings,
            let expected_default_value = "temperature_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "TEMPERATURE".notEqual(actual: actual_default_value,
                                              with: requirement_default_value))

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "TEMPERATURE values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "TEMPERATURE".notEqual(actual: expected_default_value,
                                              with: requirement_default_value))
    }

    // MARK: - WIND SPEED

    func test_wind_speed_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "wind_speed_preference")
        let expected_values = "wind_speed_preference".valuesFromSettings
        let expected_default_value = "wind_speed_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "WIND SPEED".notNil)
        XCTAssertNotNil(expected_values, "WIND SPEED values".notNil)
        XCTAssertNotNil(expected_default_value, "WIND SPEED default value".notNil)
    }

    func test_wind_speed_should_be_configured() {

        // arrange

        let requirement_values = ["m/s", "km/h", "mph"]
        let requirement_default_value = "m/s"

        guard
            let actual_default_value = defaults.string(forKey: "wind_speed_preference"),
            let expected_values = "wind_speed_preference".valuesFromSettings,
            let expected_default_value = "wind_speed_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "WIND SPEED default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "WIND SPEED values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "WIND SPEED expected default value doesn't meet requirement.")
    }

    // MARK: - PRESSURE

    func test_pressure_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "pressure_preference")
        let expected_values = "pressure_preference".valuesFromSettings
        let expected_default_value = "pressure_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "PRESSURE".notNil)
        XCTAssertNotNil(expected_values, "PRESSURE values".notNil)
        XCTAssertNotNil(expected_default_value, "PRESSURE default value".notNil)
    }

    func test_pressure_should_be_configured() {

        // arrange

        let requirement_values = ["hPa", "mmHg", "inHg"]
        let requirement_default_value = "mmHg"

        guard
            let actual_default_value = defaults.string(forKey: "pressure_preference"),
            let expected_values = "pressure_preference".valuesFromSettings,
            let expected_default_value = "pressure_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "PRESSURE actual default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "PRESSURE values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "PRESSURE expected default value doesn't meet requirement.")
    }

    // MARK: - PRECIPITATION

    func test_precipitation_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "precipitation_preference")
        let expected_values = "precipitation_preference".valuesFromSettings
        let expected_default_value = "precipitation_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "PRECIPITATION".notNil)
        XCTAssertNotNil(expected_values, "PRECIPITATION values".notNil)
        XCTAssertNotNil(expected_default_value, "PRECIPITATION default value".notNil)
    }

    func test_precipitation_should_be_configured() {

        // arrange

        let requirement_values = ["mm", "in"]
        let requirement_default_value = "mm"

        guard
            let actual_default_value = defaults.string(forKey: "precipitation_preference"),
            let expected_values = "precipitation_preference".valuesFromSettings,
            let expected_default_value = "precipitation_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "PRECIPITATION actual default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "PRECIPITATION values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "PRECIPITATION expected default value doesn't meet requirement.")
    }

    // MARK: - DISTANCE

    func test_distance_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "distance_preference")
        let expected_values = "distance_preference".valuesFromSettings
        let expected_default_value = "distance_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "DISTANCE".notNil)
        XCTAssertNotNil(expected_values, "DISTANCE values".notNil)
        XCTAssertNotNil(expected_default_value, "DISTANCE default".notNil)
    }

    func test_distance_should_be_configured() {

        // arrange

        let requirement_values = ["km", "mi"]
        let requirement_default_value = "km"

        guard
            let actual_default_value = defaults.string(forKey: "distance_preference"),
            let expected_values = "distance_preference".valuesFromSettings,
            let expected_default_value = "distance_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "DISTANCE actual default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "DISTANCE values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "DISTANCE expected default value doesn't meet requirement.")
    }

    // MARK: - TIME FORMAT

    func test_time_format_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "time_format_preference")
        let expected_values = "time_format_preference".valuesFromSettings
        let expected_default_value = "time_format_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "TIME FORMAT".notNil)
        XCTAssertNotNil(expected_values, "TIME FORMAT values".notNil)
        XCTAssertNotNil(expected_default_value, "TIME FORMAT default value".notNil)
    }

    func test_time_format_should_be_configured() {

        // arrange

        let requirement_values = ["24-hour", "12-hour"]
        let requirement_default_value = "24-hour"

        guard
            let actual_default_value = defaults.string(forKey: "time_format_preference"),
            let expected_values = "time_format_preference".valuesFromSettings,
            let expected_default_value = "time_format_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "TIME FORMAT actual default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "TIME FORMAT values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "TIME FORMAT expected default value doesn't meet requirement.")
    }

    // MARK: - FOCUS ON

    func test_focus_on_should_be_registered() {

        // arrange

        let actual = defaults.string(forKey: "focus_on_preference")
        let expected_values = "focus_on_preference".valuesFromSettings
        let expected_default_value = "focus_on_preference".defaultValueFromSettings

        // assert

        XCTAssertNotNil(actual, "FOCUS ON".notNil)
        XCTAssertNotNil(expected_values, "FOCUS ON values".notNil)
        XCTAssertNotNil(expected_default_value, "FOCUS ON default value".notNil)
    }

    func test_focus_on_should_be_configured() {

        // arrange

        let requirement_values = ["day", "night"]
        let requirement_default_value = "night"

        guard
            let actual_default_value = defaults.string(forKey: "focus_on_preference"),
            let expected_values = "focus_on_preference".valuesFromSettings,
            let expected_default_value = "focus_on_preference".defaultValueFromSettings
        else {
            XCTFail("There is a problem with extracting values from the source.")
            return
        }

        // assert

        XCTAssertEqual(requirement_default_value, actual_default_value,
                       "FOCUS ON actual default value doesn't meet requirement.")

        XCTAssertTrue(NSArray(array: requirement_values).isEqual(to: expected_values),
                      "FOCUS ON values do not meet requirement.")

        XCTAssertEqual(requirement_default_value, expected_default_value,
                       "FOCUS ON expected default value doesn't meet requirement.")
    }
}
