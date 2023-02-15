//
//  WeatherViewControllerSpies.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import UIKit
import XCTest

@testable import Weather

class MockWeatherLayoutView: UIView, WeatherLayoutViewProtocol {
    var startActivitiesCallCount = 0
    var stopActivitiesCallCount = 0

    // MARK: - Verifing updateLayoutOrientationIfNeeded method

    var updateLayoutOrientationIfNeededCallCount = 0
    var updateLayoutOrientationIfNeededArgs: [NSLayoutConstraint.Axis] = []

    func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis) {
        updateLayoutOrientationIfNeededCallCount += 1
        updateLayoutOrientationIfNeededArgs.append(currentOrientation)
    }

    func verifyUpdateLayoutOrientationIfNeeded(with orientation: NSLayoutConstraint.Axis,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
        guard updateLayoutOrientationIfNeededWasCalledOnce(file: file, line: line) else { return }
        XCTAssertEqual(updateLayoutOrientationIfNeededArgs.first,
                       orientation, "orientation", file: file, line: line)
    }

    private func updateLayoutOrientationIfNeededWasCalledOnce(file: StaticString = #file,
                                                              line: UInt = #line) -> Bool {
        return verifyMethodCalledOnce(
            methodName: "updateLayoutOrientationIfNeeded(for:)",
            callCount: updateLayoutOrientationIfNeededCallCount,
            describeArguments: "orientation: \(updateLayoutOrientationIfNeededArgs)",
            file: file,
            line: line)
    }

    // MARK: - Verifing startActivities method

    func startActivities() {
        startActivitiesCallCount += 1
    }

    func verifyStartActivities(file: StaticString = #file,
                               line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "startActivities()",
                                              callCount: startActivitiesCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Something went wrong with starting view activities.",
                      file: file, line: line)
    }

    // MARK: - Verifing stopActivities method

    func stopActivities() {
        stopActivitiesCallCount += 1

    }

    func verifyStopActivities(file: StaticString = #file,
                              line: UInt = #line) {
        let verified = verifyMethodCalledOnce(methodName: "stopActivities()",
                                              callCount: stopActivitiesCallCount,
                                              describeArguments: "[]",
                                              file: file,
                                              line: line)

        XCTAssertTrue(verified, "Something went wrong with stopping view activities.",
                      file: file, line: line)
    }
}

class MockGeoLocationReceiver: GeoLocationServiceProtocol {
    // MARK: - Verifing requestLocationDataAccess method

    var requestLocationDataAccessCallCount = 0

    func requestLocationDataAccess() {
        requestLocationDataAccessCallCount += 1
    }

    func requestLocationUpdateOnce(_ actionIfNotAllowed:
                                    ((_ case: LocationServiceNotAllowed) -> Void)?) {

    }

    func verifyRequestLocationDataAccess(file: StaticString = #file,
                                         line: UInt = #line) {
        let verified = verifyMethodCalledOnce(
            methodName: "requestLocationDataAccess()",
            callCount: requestLocationDataAccessCallCount,
            describeArguments: "[]",
            file: file,
            line: line)

        XCTAssertTrue(verified, "Something went wrong with requesting location access.",
                      file: file, line: line)
    }
}

class MockNotificationCenter: NotificationCenterProtocol {
    // MARK: - Verifing addObserver method

    var addObserverCallCount = 0

    var addObserverArgs_observer: [WeatherViewController?] = []
    var addObserverArgs_selector: [Selector] = []
    var addObserverArgs_name: [NSNotification.Name?] = []

    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?) {
        addObserverCallCount += 1

        addObserverArgs_observer.append(observer as? WeatherViewController)
        addObserverArgs_selector.append(aSelector)
        addObserverArgs_name.append(aName)
    }

    func verifyAddObserver(_ observer: WeatherViewController,
                           selector aSelector: Selector,
                           name aName: NSNotification.Name?,
                           object anObject: Any?,
                           file: StaticString = #file,
                           line: UInt = #line) {
        guard addObserverWasCalledOnce(file: file, line: line) else { return }

        XCTAssertEqual(addObserverArgs_observer.first,
                       observer, "observer", file: file, line: line)

        XCTAssertEqual(addObserverArgs_selector.first,
                       aSelector, "selector", file: file, line: line)

        XCTAssertEqual(addObserverArgs_name.first,
                       aName, "name", file: file, line: line)

        XCTAssertNil(anObject, file: file, line: line)
    }

    func verifyAddObserversShouldCalledThreeTimes(_ observer: [WeatherViewController?],
                                                  selector aSelector: [Selector],
                                                  name aName: [NSNotification.Name?],
                                                  object anObject: [Any?],
                                                  file: StaticString = #file,
                                                  line: UInt = #line) {
        guard addObserverWasCalledThreeTimes(file: file, line: line) else { return }

        XCTAssertEqual(addObserverArgs_observer,
                       observer, "observer", file: file, line: line)

        XCTAssertEqual(addObserverArgs_selector,
                       aSelector, "selector", file: file, line: line)

        XCTAssertEqual(addObserverArgs_name,
                       aName, "name", file: file, line: line)

        anObject.forEach { XCTAssertNil($0, file: file, line: line) }
    }
    private func addObserverWasCalledThreeTimes(file: StaticString = #file,
                                                line: UInt = #line) -> Bool {
        verifyMethodCalledThreeTimes(
            methodName: "addObserver(_:,selector:,name:,object:)",
            callCount: addObserverCallCount,
            describeArguments: "name: \(addObserverArgs_name)",
            file: file,
            line: line)
    }

    private func addObserverWasCalledOnce(file: StaticString = #file,
                                          line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "addObserver(_:,selector:,name:,object:)",
            callCount: addObserverCallCount,
            describeArguments: "name: \(addObserverArgs_name)",
            file: file,
            line: line)
    }

    // MARK: - Verifing removeObserver method

    var removeObserverCallCount = 0

    var removeObserverArgs_observer: [WeatherViewController?] = []
    var removeObserverArgs_name: [NSNotification.Name?] = []

    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?) {
        removeObserverCallCount += 1

        removeObserverArgs_observer.append(observer as? WeatherViewController)
        removeObserverArgs_name.append(aName)
    }

    func verifyRemoveObserverCalledTwice(_ observer: [WeatherViewController?],
                                         name aName: [NSNotification.Name?],
                                         object anObject: [Any?],
                                         file: StaticString = #file,
                                         line: UInt = #line) {
        guard removeObserverWasCalledTwice(file: file, line: line) else { return }

        XCTAssertEqual(removeObserverArgs_observer,
                       observer, "observer", file: file, line: line)

        XCTAssertEqual(removeObserverArgs_name,
                       aName, "name", file: file, line: line)

        anObject.forEach { XCTAssertNil($0, file: file, line: line) }
    }

    private func removeObserverWasCalledTwice(file: StaticString = #file,
                                              line: UInt = #line) -> Bool {
        verifyMethodCalledTwice(
            methodName: "removeObserver(_:,name:,object:)",
            callCount: removeObserverCallCount,
            describeArguments: "name: \(removeObserverArgs_name)",
            file: file,
            line: line)
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

private func verifyMethodCalledTwice(methodName: String, callCount: Int,
                                     describeArguments: @autoclosure () -> String,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }

    if callCount == 1 {
        XCTFail("Wanted 2 times but was called one time. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    if callCount > 2 {
        XCTFail("Wanted 2 times but was called \(callCount) times. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    return true
}

private func verifyMethodCalledThreeTimes(methodName: String, callCount: Int,
                                          describeArguments: @autoclosure () -> String,
                                          file: StaticString = #file,
                                          line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }

    if callCount == 1 {
        XCTFail("Wanted 3 times but was called one time. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    if callCount == 2 {
        XCTFail("Wanted 3 times but was called only two times. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    if callCount > 3 {
        XCTFail("Wanted 3 times but was called \(callCount) times. " +
                    "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    return true
}
