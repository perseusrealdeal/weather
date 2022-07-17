//
//  UpdaterHelperSubstitutes.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 17.01.2022.
//

import Foundation
import XCTest

@testable import Weather

class MockUpdaterHelper: UpdaterHelperProtocol {
    private let helperNotMock: UpdaterHelper

    init(helper: UpdaterHelper) {
        helperNotMock = helper
    }

    // MARK: - Verifing registerCurrentLocationObserver method

    var registerCurrentLocationObserverCallCount = 0
    var registerCurrentLocationObserverArgs_obsevers: [WeatherDataAutoUpdater] = []
    var registerCurrentLocationObserverArgs_selectors: [Selector] = []

    func registerCurrentLocationObserver(observer: Any, selector: Selector) {
        registerCurrentLocationObserverCallCount += 1

        registerCurrentLocationObserverArgs_obsevers.append(observer as! WeatherDataAutoUpdater)
        registerCurrentLocationObserverArgs_selectors.append(selector)
    }

    func verifyRegisterCurrentLocationObserver(observer: WeatherDataAutoUpdater,
                                               selector: Selector,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
        guard registerCurrentLocationObserverWasCalledOnce(file: file, line: line) else { return }

        XCTAssertTrue(registerCurrentLocationObserverArgs_obsevers.first! === observer,
                      "observer", file: file, line: line)

        XCTAssertEqual(registerCurrentLocationObserverArgs_selectors.first, selector,
                       "selector", file: file, line: line)
    }

    private func registerCurrentLocationObserverWasCalledOnce(file: StaticString = #file,
                                                              line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "registerCurrentLocationObserver(observer:, selector:)",
            callCount: registerCurrentLocationObserverCallCount,
            describeArguments: "name: \(registerCurrentLocationObserverArgs_selectors)",
            file: file,
            line: line)
    }

    // MARK: - Verifing removeCurrentLocationObserver method

    var removeCurrentLocationObserverCallCount = 0
    var removeCurrentLocationObserverArgs_obsevers: [WeatherDataAutoUpdater] = []

    func removeCurrentLocationObserver(observer: Any) {
        removeCurrentLocationObserverCallCount += 1

        removeCurrentLocationObserverArgs_obsevers.append(observer as! WeatherDataAutoUpdater)
    }

    func verifyRemoveCurrentLocationObserver(observer: WeatherDataAutoUpdater,
                                             file: StaticString = #file,
                                             line: UInt = #line) {
        guard removeCurrentLocationObserverWasCalledOnce(file: file, line: line) else { return }

        XCTAssertTrue(removeCurrentLocationObserverArgs_obsevers.first! === observer,
                      "observer", file: file, line: line)
    }

    private func removeCurrentLocationObserverWasCalledOnce(file: StaticString = #file,
                                                            line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "removeCurrentLocationObserver(observer:)",
            callCount: removeCurrentLocationObserverCallCount,
            describeArguments: "name: \(removeCurrentLocationObserverArgs_obsevers)",
            file: file,
            line: line)
    }

    var delay: TimeInterval?
    func calculateDelay() -> TimeInterval {
        guard let delay = delay
        else {
            return helperNotMock.calculateDelay() / 1000.0 // In milliseconds
        }
        return delay
    }

    func calculateExclude(data: WeatherDataModel) -> String {
        ""
    }

    func calculateForciblyUpdateCondition(data: WeatherDataModel) -> Bool {
        false
    }

    // MARK: - Verifing prepareTimer method

    var isTimerOnlyForCallCount = true
    var timerTargetStubbed: TimerTargetStubbed?

    var prepareTimerCallCount = 0

    var prepareTimerArgs_targets: [WeatherDataAutoUpdater] = []
    var prepareTimerArgs_delays: [TimeInterval] = []
    var prepareTimerArgs_selectors: [Selector] = []

    func prepareTimer(target: Any, delay: TimeInterval, selector: Selector) -> Timer {
        if isTimerOnlyForCallCount {
            prepareTimerCallCount += 1

            prepareTimerArgs_targets.append(target as! WeatherDataAutoUpdater)
            prepareTimerArgs_delays.append(delay)
            prepareTimerArgs_selectors.append(selector)

            return Timer()
        } else {
            // produce a real one timer, configured timer stubbed one but in milliseconds
            guard let targetStubbed = timerTargetStubbed else { return Timer() }

            helperNotMock.useTimeIntervalForUnitTest = true

            let timer = helperNotMock.prepareTimer(target: targetStubbed,
                                                   delay: delay,
                                                   selector: #selector(targetStubbed.onTick))

            return timer
        }
    }

    func verifyPrepareTimer(target: WeatherDataAutoUpdater,
                            delay: TimeInterval,
                            selector: Selector,
                            file: StaticString = #file,
                            line: UInt = #line) {
        guard prepareTimerWasCalledOnce(file: file, line: line) else { return }

        XCTAssertTrue(registerCurrentLocationObserverArgs_obsevers.first! === target,
                      "target", file: file, line: line)

        XCTAssertEqual(prepareTimerArgs_delays.first, delay,
                       "delay", file: file, line: line)

        XCTAssertEqual(registerCurrentLocationObserverArgs_selectors.first, selector,
                       "selector", file: file, line: line)
    }

    private func prepareTimerWasCalledOnce(file: StaticString = #file,
                                           line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "prepareTimer(target:, delay:, selector:)",
            callCount: prepareTimerCallCount,
            describeArguments: "delay: \(prepareTimerArgs_delays)",
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
