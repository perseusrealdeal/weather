//
//  MockWeatherClientService.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 30.01.2022.
//

import Foundation
import XCTest

@testable import Weather

class MockWeatherClientService: WeatherClientProtocol {
    var onResultDelivered: (Result<Data, WeatherDataDeliveryError>) -> Void = { print($0) }

    // MARK: - Verifing requestWeatherData method

    var requestWeatherDataCallCount = 0

    var requestWeatherDataArgs_exclude  : [String] = []
    var requestWeatherDataArgs_latitude : [String] = []
    var requestWeatherDataArgs_longitude: [String] = []

    func requestWeatherData(exclude: String, latitude: String, longitude: String) {
        requestWeatherDataCallCount += 1

        requestWeatherDataArgs_exclude.append(exclude)
        requestWeatherDataArgs_latitude.append(latitude)
        requestWeatherDataArgs_longitude.append(longitude)

        print(#function)
    }

    func verifyRequestWeatherData(exclude  : String,
                                  latitude : String,
                                  longitude: String,
                                  file     : StaticString = #file,
                                  line     : UInt = #line) {
        guard requestWeatherDataWasCalledOnce(file: file, line: line) else { return }

        XCTAssertEqual(requestWeatherDataArgs_exclude.first, exclude,
                      "exclude", file: file, line: line)

        XCTAssertEqual(requestWeatherDataArgs_latitude.first, latitude,
                       "latitude", file: file, line: line)

        XCTAssertEqual(requestWeatherDataArgs_longitude.first, longitude,
                       "longitude", file: file, line: line)
    }

    private func requestWeatherDataWasCalledOnce(file: StaticString = #file,
                                                 line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName       : "requestWeatherData(exclude:, latitude:, longitude:)",
            callCount        : requestWeatherDataCallCount,
            describeArguments: "latitude: \(requestWeatherDataArgs_latitude)",
            file             : file,
            line             : line)
    }
}

private func verifyMethodCalledOnce(methodName       : String, callCount: Int,
                                    describeArguments: @autoclosure () -> String,
                                    file             : StaticString = #file,
                                    line             : UInt = #line) -> Bool {
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
