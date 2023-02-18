//
//  UpdaterHelperSubstitutes.swift
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

class MockUpdaterHelper: UpdaterHelperProtocol {
    private let helperNotMock: UpdaterHelper

    init(helper: UpdaterHelper) {
        helperNotMock = helper
    }

    // MARK: - Verifing registerCurrentLocationObserver method

    var registerCurrentLocationObserverCallCount = 0
    var registerCurrentLocationObsevers: [WeatherDataAutoUpdater] = []
    var registerCurrentLocationSelectors: [Selector] = []

    func registerCurrentLocationObserver(observer: Any, selector: Selector) {
        guard let observer = observer as? WeatherDataAutoUpdater else { return }
        registerCurrentLocationObserverCallCount += 1

        registerCurrentLocationObsevers.append(observer)
        registerCurrentLocationSelectors.append(selector)
    }

    func verifyRegisterCurrentLocationObserver(observer: WeatherDataAutoUpdater,
                                               selector: Selector,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
        guard registerCurrentLocationObserverWasCalledOnce(file: file, line: line)
        else { return }

        XCTAssertTrue(registerCurrentLocationObsevers.first! === observer,
                      "observer", file: file, line: line)

        XCTAssertEqual(registerCurrentLocationSelectors.first, selector,
                       "selector", file: file, line: line)
    }

    private func registerCurrentLocationObserverWasCalledOnce(file: StaticString = #file,
                                                              line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "registerCurrentLocationObserver(observer:, selector:)",
            callCount: registerCurrentLocationObserverCallCount,
            describeArguments: "name: \(registerCurrentLocationSelectors)",
            file: file,
            line: line)
    }

    // MARK: - Verifing removeCurrentLocationObserver method

    var removeCurrentLocationObserverCallCount = 0
    var removeCurrentLocationObsevers: [WeatherDataAutoUpdater] = []

    func removeCurrentLocationObserver(observer: Any) {
        guard let observer = observer as? WeatherDataAutoUpdater else { return }
        removeCurrentLocationObserverCallCount += 1

        removeCurrentLocationObserverArgs_obsevers.append(observer)
    }

    func verifyRemoveCurrentLocationObserver(observer: WeatherDataAutoUpdater,
                                             file: StaticString = #file,
                                             line: UInt = #line) {
        guard removeCurrentLocationObserverWasCalledOnce(file: file, line: line)
        else { return }

        XCTAssertTrue(removeCurrentLocationObsevers.first! === observer,
                      "observer", file: file, line: line)
    }

    private func removeCurrentLocationObserverWasCalledOnce(file: StaticString = #file,
                                                            line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "removeCurrentLocationObserver(observer:)",
            callCount: removeCurrentLocationObserverCallCount,
            describeArguments: "name: \(removeCurrentLocationObsevers)",
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
        guard let target = target as? WeatherDataAutoUpdater else { return Timer() }
        if isTimerOnlyForCallCount {
            prepareTimerCallCount += 1

            prepareTimerArgs_targets.append(target)
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

        XCTAssertTrue(registerCurrentLocationObsevers.first! === target,
                      "target", file: file, line: line)

        XCTAssertEqual(prepareTimerArgs_delays.first, delay,
                       "delay", file: file, line: line)

        XCTAssertEqual(registerCurrentLocationSelectors.first, selector,
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
