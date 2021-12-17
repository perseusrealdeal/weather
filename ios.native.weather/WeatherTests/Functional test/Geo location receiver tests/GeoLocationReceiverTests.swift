//
//  GeoLocationReceiverTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 13.12.2021.
//

import XCTest
import CoreLocation
@testable import Weather

class GeoLocationReceiverTests: XCTestCase
{
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    
    private var sut : GeoLocationReceiver!
    private var mock: MockLocationManager!
    
    override func setUp()
    {
        super.setUp()
        
        sut = GeoLocationReceiver.shared
        mock = MockLocationManager()
        
        mock.delegate = sut
        sut.locationManager = mock
    }
    
    // MARK: Testing doubles CLLocationManager methods
    
    /// Test method: requestLocationDataAccess()
    func test_requestWhenInUseAuthorization_should_be_called_once()
    {
        // act
        
        sut.requestLocationDataAccess()
        
        // assert
        
        mock.verify_requestWhenInUseAuthorization_CalledOnce()
    }
    
    /// Test method: requestLocationUpdateOnce(_ actionIfDenied:)
    func test_requestLocation_with_status_notDenied_should_be_called()
    {
        // act
        
        MockLocationManager.status = .authorizedWhenInUse
        sut.requestLocationUpdateOnce()
        
        // assert
        
        mock.verify_requestLocation_CalledOnce()
    }
    
    /// Test method: requestLocationUpdateOnce(_ actionIfDenied:)
    func test_requestLocation_with_callback_and_status_denied_should_not_be_called()
    {
        // arrange
        
        let callback = { print("bla bla bla") }
        
        // act
        
        MockLocationManager.status = .denied
        sut.requestLocationUpdateOnce(callback)
        
        // assert
        
        mock.verify_requestLocation_not_called()
    }
    
    // MARK: Testing CLLocationManagerDelegate methods
    
    /// Test method: locationManager(_ manager: , didUpdateLocations locations: )
    func test_didUpdateLocations_should_send_notification_with_locationData()
    {
        // arrange
        
        let expected = LocationReceived(latitude: 87.90, longitude: 34.83)
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
    func test_didUpdateLocations_should_send_notification_with_locationDataError()
    {
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
    func test_didFailWithError_should_report_locationDataError()
    {
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
    func test_didChangeAuthorization_with_status_authorizedWhenInUse_should_call_requestLocation()
    {
        // act
        
        mock.delegate?.locationManager?(CLLocationManager(),
                                        didChangeAuthorization: .authorizedWhenInUse)
        
        // assert
        
        XCTAssertEqual(mock.locationUpdateCallCount, 1,
                    "Method requestLocation() should be invoked with status authorizedWhenInUse.")
    }
    
    /// Test method: locationManager(_ manager: , didChangeAuthorization status: )
    func test_didChangeAuthorization_with_status_authorizedAlways_should_call_requestLocation()
    {
        // act
        
        mock.delegate?.locationManager?(CLLocationManager(),
                                        didChangeAuthorization: .authorizedAlways)
        
        // assert
        
        XCTAssertEqual(mock.locationUpdateCallCount, 1,
                    "Method requestLocation() should be invoked with status authorizedAlways.")
    }
    
    /// Test method: locationManager(_ manager: , didChangeAuthorization status: )
    func test_didChangeAuthorization_with_status_denied_should_not_call_requestLocation()
    {
        // act
        
        mock.delegate?.locationManager?(CLLocationManager(), didChangeAuthorization: .denied)
        
        // assert
        
        XCTAssertEqual(mock.locationUpdateCallCount, 0,
                    "Method requestLocation() shouldn't be invoked with status Denied.")
    }
}

fileprivate class MockLocationManager : LocationManagerProtocol
{
    var locationDataAccessCallCount   : Int = 0
    var locationUpdateCallCount       : Int = 0
    var stopUpdatingLocationCallCount : Int = 0
    
    // MARK: - LocationManagerProtocol
    
    static var status : CLAuthorizationStatus = .notDetermined
    
    static func authorizationStatus() -> CLAuthorizationStatus { status }
    
    var delegate       : CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers
    
    init() { }
    
    func requestWhenInUseAuthorization()
    {
        locationDataAccessCallCount += 1
    }
    
    func requestLocation()
    {
        locationUpdateCallCount += 1
        
    }
    
    func stopUpdatingLocation()
    {
        stopUpdatingLocationCallCount += 1
    }
    
    // MARK: Verification methods based on counting methods calls
    
    fileprivate func verify_requestWhenInUseAuthorization_CalledOnce(file: StaticString = #file,
                                                                     line: UInt = #line)
    {
        if locationDataAccessCallCount == 0
        {
            XCTFail("Wanted but not invoked: requestWhenInUseAuthorization()",
                    file: file, line: line)
        }
        if locationDataAccessCallCount > 1
        {
            XCTFail("Wanted 1 time but was called \(locationDataAccessCallCount) times. " +
                        "requestWhenInUseAuthorization()", file: file, line: line)
        }
    }
    
    fileprivate func verify_requestLocation_CalledOnce(file: StaticString = #file,
                                                       line: UInt = #line)
    {
        if locationUpdateCallCount == 0
        {
            XCTFail("Wanted but not invoked: requestLocation()", file: file, line: line)
            
        }
        if locationUpdateCallCount > 1
        {
            XCTFail("Wanted 1 time but was called \(locationUpdateCallCount) times. " +
                        "requestLocation()", file: file, line: line)
        }
    }
    
    fileprivate func verify_requestLocation_not_called(file: StaticString = #file,
                                                       line: UInt = #line)
    {
        if locationUpdateCallCount > 0
        {
            XCTFail("Wanted not invoked but was called \(locationUpdateCallCount) times. " +
                        "requestLocation()", file: file, line: line)
        }
    }
    
    // MARK: Subscribing to be notified with receiving location data
    
    var givenLocationData     : LocationReceived?
    var givenLocationDataError: LocationReceivedError?
    
    fileprivate func subscribeAndBeNotifiedWithLocationDataUpdate()
    {
        NotificationCenter.default.addObserver(
            self,selector: #selector(locationReceivedNotificationHandler(_:)),
            name: .locationReceivedNotification, object: nil)
    }
    
    @objc private func locationReceivedNotificationHandler(_ notification: Notification)
    {
        guard let result = notification.object as? Result<LocationReceived, LocationReceivedError>
        else { return }
        
        switch result
        {
        case .success(let location):
            
            givenLocationData = location
            print(">> location: latitude = \(location.latitude), longitude = \(location.longitude)")
            
        case .failure(let error):
            
            givenLocationDataError = error
            print(">> \(error)")
        }
    }
    
}
