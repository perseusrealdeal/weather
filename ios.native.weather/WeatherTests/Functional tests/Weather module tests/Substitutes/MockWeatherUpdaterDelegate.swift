//
//  MockWeatherUpdaterDelegate.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation
import XCTest

@testable import Weather

class MockWeatherUpdaterDelegate: WeatherDataAutoUpdaterDelegate {
    // MARK: - Verifing weatherDataUpdated method

    var weatherDataUpdatedCallCount = 0

    func weatherDataUpdated() {
        weatherDataUpdatedCallCount += 1
    }

    func verifyWeatherDataUpdated(file: StaticString = #file, line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "weatherDataUpdated()",
                                              callCount: weatherDataUpdatedCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Method should be called once only.", file: file, line: line)
    }

    // MARK: - Verifing weatherAlertsUpdated method

    var weatherAlertsUpdatedCallCount = 0

    func weatherAlertsUpdated() {
        weatherAlertsUpdatedCallCount += 1
    }

    func verifyWeatherAlertsUpdated(file: StaticString = #file, line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "weatherAlertsUpdated()",
                                              callCount: weatherAlertsUpdatedCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Method should be called once only.", file: file, line: line)
    }

    // MARK: - Verifing locationServiceNotAllowed method

    var locationServiceNotAllowedCallCount = 0
    var locationServiceNotAllowedArgs: [LocationServiceNotAllowed] = []

    func locationServiceNotAllowed(_ reason: LocationServiceNotAllowed) {
        locationServiceNotAllowedCallCount += 1
        locationServiceNotAllowedArgs.append(reason)
    }

    func verifyLocationServiceNotAllowed(reason: LocationServiceNotAllowed,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
        guard locationServiceNotAllowedWasCalledOnce(file: file, line: line) else { return }

        XCTAssertEqual(locationServiceNotAllowedArgs.first, reason, "reason",
                       file: file, line: line)
    }

    private func locationServiceNotAllowedWasCalledOnce(file: StaticString = #file,
                                                        line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "requestWeatherData(exclude:, latitude:, longitude:)",
            callCount: locationServiceNotAllowedCallCount,
            describeArguments: "reason: \(locationServiceNotAllowedArgs)",
            file: file,
            line: line)
    }

    // MARK: - Verifing failedToGetCurrentLocation method

    var failedToGetCurrentLocationCallCount = 0

    func failedToGetCurrentLocation(_ error: LocationReceivedError) {
        failedToGetCurrentLocationCallCount += 1
    }

    func verifyFailedToGetCurrentLocation(file: StaticString = #file, line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "verifyFailedToGetCurrentLocation()",
                                              callCount: failedToGetCurrentLocationCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Method should be called once only.", file: file, line: line)
    }

    // MARK: - Verifing failedToDeliverWeatherData method

    var failedToDeliverWeatherDataCallCount = 0

    func failedToDeliverWeatherData(_ error: WeatherDataDeliveryError) {
        failedToDeliverWeatherDataCallCount += 1
    }

    func verifyFailedToDeliverWeatherData(file: StaticString = #file, line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "verifyFailedToDeliverWeatherData()",
                                              callCount: failedToDeliverWeatherDataCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Method should be called once only.", file: file, line: line)
    }
}

private func verifyMethodCalledOnce(methodName: String, callCount: Int,
                                    describeArguments: @autoclosure () -> String,
                                    file: StaticString = #file,
                                    line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }

    if callCount > 1 {
        XCTFail("Wanted 1 time but was called \(callCount) times. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    return true
}
