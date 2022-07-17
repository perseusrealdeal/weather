//
//  GeoLocationReceiverTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 13.12.2021.
//

import XCTest
import CoreLocation

@testable import Weather

class GeoLocationReceiverTests: XCTestCase {
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    private var sut : GeoLocationReceiver!
    private var mock: MockLocationManager!

    override func setUp() {
        super.setUp()

        sut = GeoLocationReceiver.shared
        mock = MockLocationManager()

        mock.delegate = sut
        sut.locationManager = mock
    }

    // MARK: Testing doubles CLLocationManager methods

    /// Test method: requestLocationDataAccess()
    func test_requestWhenInUseAuthorization_should_be_called_once() {
        // arrange

        MockLocationManager.status = .notDetermined
        MockLocationManager.isLocationServiceEnabled = true

        // act

        sut.requestLocationDataAccess()

        // assert

        mock.verify_requestWhenInUseAuthorization_CalledOnce()
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withNoCallbackAndStatusNotDeniedOrNotRestricted_shouldBeCalled() {
        // arrange

        MockLocationManager.status = .authorizedWhenInUse
        MockLocationManager.isLocationServiceEnabled = true

        // act

        sut.requestLocationUpdateOnce()

        // assert

        /// requestLocation() should be invoked
        mock.verify_requestLocation_CalledOnce()
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withCallbackAndStatusNotDeniedOrNotRestricted_shouldBeCalled() {
        // arrange

        var isCallbackInvoked = false

        MockLocationManager.status = .authorizedWhenInUse
        MockLocationManager.isLocationServiceEnabled = true

        // act

        sut.requestLocationUpdateOnce { _ in isCallbackInvoked = true }

        // assert

        /// requestLocation() should be invoked but callback not
        mock.verify_requestLocation_CalledOnce()
        XCTAssertFalse(isCallbackInvoked, "Callback shouldn't be invoked.")
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withStatusDeniedAndLocationServiceEnabled_shouldCallbackCalled() {
        // arrange

        var callback: LocationServiceNotAllowed?

        MockLocationManager.status = .denied
        MockLocationManager.isLocationServiceEnabled = true

        // act

        sut.requestLocationUpdateOnce { explanation in callback = explanation }

        // assert

        /// requestLocation() shouldn't be invoked but callback is
        mock.verify_requestLocation_not_called()

        XCTAssertNotNil(callback, "Callback should be invoked.")
        XCTAssertEqual(callback, .deniedForTheApp)
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withStatusDeniedAndLocationServiceNotEnabled_shouldCallbackCalled() {
        // arrange

        var callback: LocationServiceNotAllowed?

        MockLocationManager.status = .denied
        MockLocationManager.isLocationServiceEnabled = false

        // act

        sut.requestLocationUpdateOnce { explanation in callback = explanation }

        // assert

        /// requestLocation() shouldn't be invoked but callback is
        mock.verify_requestLocation_not_called()

        XCTAssertNotNil(callback, "Callback should be invoked.")
        XCTAssertEqual(callback, .deniedForAll)
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withStatusRestrictedAndLocationServiceEnabled_shouldCallbackCalled() {
        // arrange

        var callback: LocationServiceNotAllowed?

        MockLocationManager.status = .restricted
        MockLocationManager.isLocationServiceEnabled = true

        // act

        sut.requestLocationUpdateOnce { explanation in callback = explanation }

        // assert

        /// requestLocation() shouldn't be invoked but callback is
        mock.verify_requestLocation_not_called()

        XCTAssertNotNil(callback, "Callback should be invoked.")
        XCTAssertEqual(callback, .restricted)
    }

    /// Test method: requestLocationUpdateOnce(_ actionIfNotAllowed:)
    func test_requestLocation_withStatusRestrictedAndLocationServiceNotEnabled_shouldCallbackCalled() {
        // arrange

        var callback: LocationServiceNotAllowed?

        MockLocationManager.status = .restricted
        MockLocationManager.isLocationServiceEnabled = false

        // act

        sut.requestLocationUpdateOnce { explanation in callback = explanation }

        // assert

        /// requestLocation() shouldn't be invoked but callback is
        mock.verify_requestLocation_not_called()

        XCTAssertNotNil(callback, "Callback should be invoked.")
        XCTAssertEqual(callback, .deniedForAllAndRestricted)
    }

    // MARK: Testing CLLocationManagerDelegate methods

    /// Test method: locationManager(_ manager: , didUpdateLocations locations: )
    func test_didUpdateLocations_should_send_notification_with_locationData() {
        // arrange

        let expected = Сoordinate(latitude: 87.90, longitude: 34.83)
        let locations =
            [
                CLLocation(latitude: expected.latitude, longitude: expected.longitude),
                CLLocation(latitude: 34.78, longitude: 34.83)
            ]

        mock.subscribeAndBeNotifiedWithLocationDataUpdate()

        // act

        mock.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: locations)
        let actual = mock.givenLocationData

        // assert

        XCTAssertEqual(actual, expected)
        XCTAssertEqual(mock.stopUpdatingLocationCallCount, 1,
                    "Method stopUpdatingLocation() should be invoked.")
    }

    /// Test method: locationManager(_ manager: , didUpdateLocations locations: )
    func test_didUpdateLocations_should_send_notification_with_locationDataError() {
        // arrange

        let expected = LocationReceivedError.receivedEmptyLocationData
        let locations = [CLLocation]()

        mock.subscribeAndBeNotifiedWithLocationDataUpdate()

        // act

        mock.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: locations)
        let actual = mock.givenLocationDataError

        // assert

        XCTAssertEqual(actual, expected)
        XCTAssertEqual(mock.stopUpdatingLocationCallCount, 0,
                    "Method stopUpdatingLocation() shouldn't be invoked.")
    }

    /// Test method: locationManager(_ manager: , didFailWithError error: )
    func test_didFailWithError_should_report_locationDataError() {
        // arrange

        let defaultMessage = LocationReceivedError.failedRequest("")
        let expected = LocationReceivedError.failedRequest(defaultMessage.localizedDescription)

        mock.subscribeAndBeNotifiedWithLocationDataUpdate()

        // act

        mock.delegate?.locationManager?(CLLocationManager(),
                    didFailWithError: LocationReceivedError.failedRequest(""))

        let actual = mock.givenLocationDataError

        // assert

        XCTAssertEqual(actual, expected)
    }

    /// Test method: locationManager(_ manager: , didChangeAuthorization status: )
    func test_didChangeAuthorization_with_status_authorizedWhenInUse_should_call_requestLocation() {
        // act

        mock.delegate?.locationManager?(CLLocationManager(),
                                        didChangeAuthorization: .authorizedWhenInUse)

        // assert

        XCTAssertEqual(mock.locationUpdateCallCount, 1,
                    "Method requestLocation() should be invoked with status authorizedWhenInUse.")
    }

    /// Test method: locationManager(_ manager: , didChangeAuthorization status: )
    func test_didChangeAuthorization_with_status_denied_should_not_call_requestLocation() {
        // act

        mock.delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: .denied)

        // assert

        XCTAssertEqual(mock.locationUpdateCallCount, 0,
                    "Method requestLocation() shouldn't be invoked with status Denied.")
    }
}
