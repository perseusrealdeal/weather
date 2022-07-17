//
//  GeoLocationLocalizationTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 14.12.2021.
//

import XCTest
import SwiftyJSON

@testable import Weather

class CommonLocalizationTests: XCTestCase {
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func test_CFBundleDisplayName_should_be_localized() {

        // arrange

        let actual = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        let expected = "CFBundleDisplayName".localizedFromInfoPlist
        let requirement = "CFBundleDisplayName".localizedFromRequirements

        // assert

        XCTAssertEqual(actual, expected, "Value isn't correct.")
        XCTAssertEqual(requirement, actual, "Value isn't correct with the actual value.")
        XCTAssertEqual(requirement, expected, "Value isn't correct with the expected value.")
    }

    func test_CFBundleName_should_be_localized() {

        // arrange

        let actual = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let expected = "CFBundleName".localizedFromInfoPlist
        let requirement = "CFBundleName".localizedFromRequirements

        // assert

        XCTAssertEqual(actual, expected, "Value isn't correct.")
        XCTAssertEqual(requirement, actual, "Value isn't correct with the actual value.")
        XCTAssertEqual(requirement, expected, "Value isn't correct with the expected value.")
    }

    func test_NSLocationWhenInUseUsageDescription_should_be_localized() {

        // arrange

        let actual = Bundle.main.object(forInfoDictionaryKey:
                                            "NSLocationWhenInUseUsageDescription") as! String
        let expected = "NSLocationWhenInUseUsageDescription".localizedFromInfoPlist
        let requirement = "NSLocationWhenInUseUsageDescription".localizedFromRequirements

        // assert

        XCTAssertEqual(actual, expected, "Value isn't correct.")
        XCTAssertEqual(requirement, actual, "Value isn't correct with the actual value.")
        XCTAssertEqual(requirement, expected, "Value isn't correct with the expected value.")
    }

    func test_DefaultLocation_should_be_localized() {

        // arrange

        let expected = JSON("defaultLocation".localized_value)
        let requirement = JSON("defaultLocation".localizedFromRequirements)

        // assert

        XCTAssertEqual(requirement["lat"], expected["lat"])
        XCTAssertEqual(requirement["lon"], expected["lon"])
    }
}
