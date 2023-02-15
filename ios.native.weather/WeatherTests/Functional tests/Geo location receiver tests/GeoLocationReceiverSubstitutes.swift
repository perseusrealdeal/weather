//
//  GeoLocationReceiverSubstitutes.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Weather

class MockLocationManager: LocationManagerProtocol {
    var locationDataAccessCallCount: Int = 0
    var locationUpdateCallCount: Int = 0
    var stopUpdatingLocationCallCount: Int = 0

    // MARK: - LocationManagerProtocol

    static var status: CLAuthorizationStatus = .notDetermined
    static var isLocationServiceEnabled: Bool = true

    static func authorizationStatus() -> CLAuthorizationStatus { return status }
    static func locationServicesEnabled() -> Bool { return isLocationServiceEnabled }

    weak var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers

    init() { }

    func requestWhenInUseAuthorization() {
        locationDataAccessCallCount += 1
    }

    func requestLocation() {
        locationUpdateCallCount += 1

    }

    func stopUpdatingLocation() {
        stopUpdatingLocationCallCount += 1
    }

    // MARK: Verification methods based on counting methods calls

    func verify_requestWhenInUseAuthorization_CalledOnce(file: StaticString = #file,
                                                         line: UInt = #line) {
        if locationDataAccessCallCount == 0 {
            XCTFail("Wanted but not invoked: requestWhenInUseAuthorization()",
                    file: file, line: line)
        }
        if locationDataAccessCallCount > 1 {
            XCTFail("Wanted 1 time but was called \(locationDataAccessCallCount) times. " +
                        "requestWhenInUseAuthorization()", file: file, line: line)
        }
    }

    func verify_requestLocation_CalledOnce(file: StaticString = #file, line: UInt = #line) {
        if locationUpdateCallCount == 0 {
            XCTFail("Wanted but not invoked: requestLocation()", file: file, line: line)

        }

        if locationUpdateCallCount > 1 {
            XCTFail("Wanted 1 time but was called \(locationUpdateCallCount) times. " +
                        "requestLocation()", file: file, line: line)
        }
    }

    func verify_requestLocation_not_called(file: StaticString = #file, line: UInt = #line) {
        if locationUpdateCallCount > 0 {
            XCTFail("Wanted not invoked but was called \(locationUpdateCallCount) times. " +
                        "requestLocation()", file: file, line: line)
        }
    }

    // MARK: Subscribing to be notified with receiving location data

    var givenLocationData: Сoordinate?
    var givenLocationDataError: LocationReceivedError?

    func subscribeAndBeNotifiedWithLocationDataUpdate() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(locationReceivedNotificationHandler(_:)),
            name: .locationReceivedNotification, object: nil)
    }

    @objc private func locationReceivedNotificationHandler(_ notification: Notification) {
        guard let result = notification.object as? Result<Сoordinate, LocationReceivedError>
        else { return }

        switch result {
        case .success(let location):

            givenLocationData = location
            print(">> location: lat = \(location.latitude), lon = \(location.longitude)")

        case .failure(let error):

            givenLocationDataError = error
            print(">> \(error)")
        }
    }
}
