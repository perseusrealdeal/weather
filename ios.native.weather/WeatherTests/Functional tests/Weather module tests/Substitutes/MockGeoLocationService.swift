//
//  MockGeoLocationService.swift
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

class MockGeoLocationService: GeoLocationServiceProtocol {
    func requestLocationDataAccess() {
        print(#function)
    }

    // MARK: - Verifing requestLocationUpdateOnce method

    var useCallBack: Bool = false
    var reasonInCallBack: LocationServiceNotAllowed = .deniedForTheApp

    var requestLocationUpdateOnceCallCount = 0

    func requestLocationUpdateOnce(_ actionIfNotAllowed: ((LocationServiceNotAllowed) -> Void)?) {
        requestLocationUpdateOnceCallCount += 1

        if useCallBack { actionIfNotAllowed?(reasonInCallBack) }
    }

    func verifyRequestLocationUpdateOnce(file: StaticString = #file,
                                         line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "verifyRequestLocationUpdateOnce()",
                                              callCount: requestLocationUpdateOnceCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Location request must be done only once.",
                      file: file, line: line)
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
