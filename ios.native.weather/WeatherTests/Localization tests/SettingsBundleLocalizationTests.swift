//
//  LocalizationTests.swift
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

class SettingsBundleLocalizationTests: XCTestCase {

    private let defaults = Settings.userDefaults

    // MARK: - Weather Parameters: Temperature

    func test_temperature_should_be_localized() {
        let expected = "temperature".localizedFromSettings
        let requirement = "temperature".localizedFromRequirements

        let message = "temperature".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_celsius_should_be_localized() {
        let expected = "celsius".localizedFromSettings
        let requirement = "celsius".localizedFromRequirements

        let message = "celsius".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_fahrenheit_should_be_localized() {
        let expected = "fahrenheit".localizedFromSettings
        let requirement = "fahrenheit".localizedFromRequirements

        let message = "fahrenheit".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_metric_should_be_localized() {
        let expected = "metric".localizedFromSettings
        let requirement = "metric".localizedFromRequirements

        let message = "metric".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_imperial_should_be_localized() {
        let expected = "imperial".localizedFromSettings
        let requirement = "imperial".localizedFromRequirements

        let message = "imperial".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Weather Parameters: Wind speed

    func test_wind_speed_should_be_localized() {
        let expected = "wind speed".localizedFromSettings
        let requirement = "wind speed".localizedFromRequirements

        let message = "wind speed".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_wind_speed_m_s_should_be_localized() {
        let expected = "m/s".localizedFromSettings
        let requirement = "m/s".localizedFromRequirements

        let message = "m/s".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_wind_speed_km_h_should_be_localized() {
        let expected = "km/h".localizedFromSettings
        let requirement = "km/h".localizedFromRequirements

        let message = "km/h".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_wind_speed_mph_should_be_localized() {
        let expected = "mph".localizedFromSettings
        let requirement = "mph".localizedFromRequirements

        let message = "mph".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Weather Parameters: Pressure

    func test_pressure_should_be_localized() {
        let expected = "pressure".localizedFromSettings
        let requirement = "pressure".localizedFromRequirements

        let message = "pressure".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_pressure_hPa_should_be_localized() {
        let expected = "hPa".localizedFromSettings
        let requirement = "hPa".localizedFromRequirements

        let message = "hPa".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_pressure_mmHg_should_be_localized() {
        let expected = "mmHg".localizedFromSettings
        let requirement = "mmHg".localizedFromRequirements

        let message = "mmHg".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_pressure_inHg_should_be_localized() {
        let expected = "inHg".localizedFromSettings
        let requirement = "inHg".localizedFromRequirements

        let message = "inHg".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Weather Parameters: Perception

    func test_precipitation_should_be_localized() {
        let expected = "precipitation".localizedFromSettings
        let requirement = "precipitation".localizedFromRequirements

        let message = "precipitation".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_precipitation_mm_should_be_localized() {
        let expected = "mm".localizedFromSettings
        let requirement = "mm".localizedFromRequirements

        let message = "mm".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_precipitation_in_should_be_localized() {
        let expected = "in".localizedFromSettings
        let requirement = "in".localizedFromRequirements

        let message = "in".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Weather Parameters: Distance

    func test_distance_should_be_localized() {
        let expected = "distance".localizedFromSettings
        let requirement = "distance".localizedFromRequirements

        let message = "distance".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_distance_km_should_be_localized() {
        let expected = "km".localizedFromSettings
        let requirement = "km".localizedFromRequirements

        let message = "km".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_distance_mi_should_be_localized() {
        let expected = "mi".localizedFromSettings
        let requirement = "mi".localizedFromRequirements

        let message = "mi".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Weather Parameters: Time Format

    func test_time_format_should_be_localized() {
        let expected = "time format".localizedFromSettings
        let requirement = "time format".localizedFromRequirements

        let message = "time format".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_time_format_24_hour_should_be_localized() {
        let expected = "24-hour".localizedFromSettings
        let requirement = "24-hour".localizedFromRequirements

        let message = "24-hour".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_time_format_12_hour_should_be_localized() {
        let expected = "12-hour".localizedFromSettings
        let requirement = "12-hour".localizedFromRequirements

        let message = "12-hour".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Testing Default Values

    func test_temperature_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "temperature_preference") as? String
        let requirement = "celsius".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "celsius".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_wind_speed_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "wind_speed_preference") as? String
        let requirement = "m/s".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "m/s".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_pressure_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "pressure_preference") as? String
        let requirement = "mmHg".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "mmHg".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_precipitation_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "precipitation_preference") as? String
        let requirement = "mm".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "mm".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_distance_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "distance_preference") as? String
        let requirement = "km".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "km".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_time_format_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "time_format_preference") as? String
        let requirement = "24-hour".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "24-hour".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_focus_on_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "focus_on_preference") as? String
        let requirement = "night".localizedFromRequirements
        let expected = actual?.localizedFromSettings

        let message = "night".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Specials, Focus on Option

    func test_specials_group_title_should_be_localized() {
        let expected = "specials".localizedFromSettings
        let requirement = "specials".localizedFromRequirements

        let message = "specials".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_focus_on_should_be_localized() {
        let expected = "focus on".localizedFromSettings
        let requirement = "focus on".localizedFromRequirements

        let message = "focus on".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_focus_on_day_should_be_localized() {
        let expected = "day".localizedFromSettings
        let requirement = "day".localizedFromRequirements

        let message = "day".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_focus_on_night_should_be_localized() {
        let expected = "night".localizedFromSettings
        let requirement = "night".localizedFromRequirements

        let message = "night".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Specials, Dark Mode Option

    func test_dark_mode_should_be_localized() {
        let expected = "Dark Mode".localizedFromSettings
        let requirement = "Dark Mode".localizedFromRequirements

        let message = "Dark Mode".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_dark_mode_auto_should_be_localized() {
        let expected = "Dark Mode AUTO".localizedFromSettings
        let requirement = "Dark Mode AUTO".localizedFromRequirements

        let message = "Dark Mode AUTO".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_dark_mode_on_should_be_localized() {
        let expected = "Dark Mode ON".localizedFromSettings
        let requirement = "Dark Mode ON".localizedFromRequirements

        let message = "Dark Mode ON".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_dark_mode_off_should_be_localized() {
        let expected = "Dark Mode OFF".localizedFromSettings
        let requirement = "Dark Mode OFF".localizedFromRequirements

        let message = "Dark Mode OFF".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    // MARK: - Version and Build Titles

    func test_release_app_number_group_title_should_be_localized() {
        let expected = "release app number".localizedFromSettings
        let requirement = "release app number".localizedFromRequirements

        let message = "release app number".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_version_title_should_be_localized() {
        let expected = "version".localizedFromSettings
        let requirement = "version".localizedFromRequirements

        let message = "version".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }

    func test_build_title_should_be_localized() {
        let expected = "build".localizedFromSettings
        let requirement = "build".localizedFromRequirements

        let message = "build".notEqual(actual: requirement, with: expected)

        XCTAssertEqual(requirement, expected, message)
    }
}
