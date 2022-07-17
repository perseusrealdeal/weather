//
//  LocalizationTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 29.11.2021.
//

import XCTest
@testable import Weather

class SettingsBundleLocalizationTests: XCTestCase {
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    private let defaults = Settings.userDefaults

    // MARK: - Weather Parameters: Temperature

    func test_temperature_should_be_localized() {
        let expected = "temperature".localizedFromSettings
        let requirement = "temperature".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"temperature\" is not correct with the expected value.")
    }

    func test_celsius_should_be_localized() {
        let expected = "celsius".localizedFromSettings
        let requirement = "celsius".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"celsius\" is not correct with the expected value.")
    }

    func test_fahrenheit_should_be_localized() {
        let expected = "fahrenheit".localizedFromSettings
        let requirement = "fahrenheit".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"fahrenheit\" is not correct with the expected value.")
    }

    func test_metric_should_be_localized() {
        let expected = "metric".localizedFromSettings
        let requirement = "metric".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"metric\" is not correct with the expected value.")
    }

    func test_imperial_should_be_localized() {
        let expected = "imperial".localizedFromSettings
        let requirement = "imperial".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"imperial\" is not correct with the expected value.")
    }

    // MARK: - Weather Parameters: Wind speed

    func test_wind_speed_should_be_localized() {
        let expected = "wind speed".localizedFromSettings
        let requirement = "wind speed".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"wind speed\" is not correct with the expected value.")
    }

    func test_wind_speed_m_s_should_be_localized() {
        let expected = "m/s".localizedFromSettings
        let requirement = "m/s".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"m/s\" is not correct with the expected value.")
    }

    func test_wind_speed_km_h_should_be_localized() {
        let expected = "km/h".localizedFromSettings
        let requirement = "km/h".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"km/h\" is not correct with the expected value.")
    }

    func test_wind_speed_mph_should_be_localized() {
        let expected = "mph".localizedFromSettings
        let requirement = "mph".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"mph\" is not correct with the expected value.")
    }

    // MARK: - Weather Parameters: Pressure

    func test_pressure_should_be_localized() {
        let expected = "pressure".localizedFromSettings
        let requirement = "pressure".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"pressure\" is not correct with the expected value.")
    }

    func test_pressure_hPa_should_be_localized() {
        let expected = "hPa".localizedFromSettings
        let requirement = "hPa".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"hPa\" is not correct with the expected value.")
    }

    func test_pressure_mmHg_should_be_localized() {
        let expected = "mmHg".localizedFromSettings
        let requirement = "mmHg".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"mmHg\" is not correct with the expected value.")
    }

    func test_pressure_inHg_should_be_localized() {
        let expected = "inHg".localizedFromSettings
        let requirement = "inHg".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"inHg\" is not correct with the expected value.")
    }

    // MARK: - Weather Parameters: Perception

    func test_precipitation_should_be_localized() {
        let expected = "precipitation".localizedFromSettings
        let requirement = "precipitation".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"precipitation\" is not correct with the expected value.")
    }

    func test_precipitation_mm_should_be_localized() {
        let expected = "mm".localizedFromSettings
        let requirement = "mm".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"mm\" is not correct with the expected value.")
    }

    func test_precipitation_in_should_be_localized() {
        let expected = "in".localizedFromSettings
        let requirement = "in".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"in\" is not correct with the expected value.")
    }

    // MARK: - Weather Parameters: Distance

    func test_distance_should_be_localized() {
        let expected = "distance".localizedFromSettings
        let requirement = "distance".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"distance\" is not correct with the expected value.")
    }

    func test_distance_km_should_be_localized() {
        let expected = "km".localizedFromSettings
        let requirement = "km".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"km\" is not correct with the expected value.")
    }

    func test_distance_mi_should_be_localized() {
        let expected = "mi".localizedFromSettings
        let requirement = "mi".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"mi\" is not correct with the expected value.")
    }

    // MARK: - Weather Parameters: Time Format

    func test_time_format_should_be_localized() {
        let expected = "time format".localizedFromSettings
        let requirement = "time format".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"time format\" is not correct with the expected value.")
    }

    func test_time_format_24_hour_should_be_localized() {
        let expected = "24-hour".localizedFromSettings
        let requirement = "24-hour".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"24-hour\" is not correct with the expected value.")
    }

    func test_time_format_12_hour_should_be_localized() {
        let expected = "12-hour".localizedFromSettings
        let requirement = "12-hour".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"12-hour\" is not correct with the expected value.")
    }

    // MARK: - Testing Default Values

    func test_temperature_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "temperature_preference") as! String
        let requirement = "celsius".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default temperature\" is not correct with the actual value.")
    }

    func test_wind_speed_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "wind_speed_preference") as! String
        let requirement = "m/s".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default wind speed\" is not correct with the actual value.")
    }

    func test_pressure_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "pressure_preference") as! String
        let requirement = "mmHg".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default pressure\" is not correct with the actual value.")
    }

    func test_precipitation_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "precipitation_preference") as! String
        let requirement = "mm".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default precipitation\" is not correct with the actual value.")
    }

    func test_distance_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "distance_preference") as! String
        let requirement = "km".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default distance\" is not correct with the actual value.")
    }

    func test_time_format_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "time_format_preference") as! String
        let requirement = "24-hour".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default time format\" is not correct with the actual value.")
    }

    func test_focus_on_default_value_should_be_localized() {
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        let actual = defaults.value(forKey: "focus_on_preference") as! String
        let requirement = "night".localizedFromRequirements

        XCTAssertEqual(requirement, actual.localizedFromSettings,
        "\"default focus on\" is not correct with the actual value.")
    }

    // MARK: - Specials, Focus on Option

    func test_specials_group_title_should_be_localized() {
        let expected = "specials".localizedFromSettings
        let requirement = "specials".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"specials\" group title is not correct with the expected value.")
    }

    func test_focus_on_should_be_localized() {
        let expected = "focus on".localizedFromSettings
        let requirement = "focus on".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"focus on\" is not correct with the expected value.")
    }

    func test_focus_on_day_should_be_localized() {
        let expected = "day".localizedFromSettings
        let requirement = "day".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"day\" is not correct with the expected value.")
    }

    func test_focus_on_night_should_be_localized() {
        let expected = "night".localizedFromSettings
        let requirement = "night".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"night\" is not correct with the expected value.")
    }

    // MARK: - Specials, Dark Mode Option

    func test_dark_mode_should_be_localized() {
        let expected = "dark mode".localizedFromSettings
        let requirement = "dark mode".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"dark mode\" is not correct with the expected value.")
    }

    func test_dark_mode_auto_should_be_localized() {
        let expected = "dark mode auto".localizedFromSettings
        let requirement = "dark mode auto".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"dark mode auto\" is not correct with the expected value.")
    }

    func test_dark_mode_on_should_be_localized() {
        let expected = "dark mode on".localizedFromSettings
        let requirement = "dark mode on".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"dark mode on\" is not correct with the expected value.")
    }

    func test_dark_mode_off_should_be_localized() {
        let expected = "dark mode off".localizedFromSettings
        let requirement = "dark mode off".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"dark mode off\" is not correct with the expected value.")
    }

    // MARK: - Version and Build Titles

    func test_release_app_number_group_title_should_be_localized() {
        let expected = "release app number".localizedFromSettings
        let requirement = "release app number".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"release app number\" group title is not correct with the expected value.")
    }

    func test_version_title_should_be_localized() {
        let expected = "version".localizedFromSettings
        let requirement = "version".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"version\" title is not correct with the expected value.")
    }

    func test_build_title_should_be_localized() {
        let expected = "build".localizedFromSettings
        let requirement = "build".localizedFromRequirements

        XCTAssertEqual(requirement, expected,
        "\"build\" title hasn't is not correct with the expected value.")
    }
}
