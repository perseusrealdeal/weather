//
//  WeatherModuleFunctionalTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 09.01.2022.
//

import XCTest
@testable import Weather

class WeatherViewControllerTests: XCTestCase
{
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    private var sut                   : WeatherViewController!

    private var mockView              : MockWeatherLayoutView!
    private var mockLocationReceiver  : MockGeoLocationReceiver!
    private var mockNotificationCenter: MockNotificationCenter!

    override func setUp()
    {
        super.setUp()

        mockLocationReceiver = MockGeoLocationReceiver()
        mockNotificationCenter = MockNotificationCenter()
        mockView = MockWeatherLayoutView()

        sut = WeatherViewController(mockNotificationCenter, mockLocationReceiver)
    }

    override func tearDown()
    {
        mockLocationReceiver = nil
        mockNotificationCenter = nil
        mockView = nil

        sut = nil

        super.tearDown()
    }

    // MARK: - Testing With Focusing On WeatherLayoutView Dependency

    func test_VC_should_load_WeatherLayoutView()
    {
        // act

        sut.loadViewIfNeeded()

        // assert

        XCTAssertTrue(sut.view is WeatherLayoutView,
                      "The View Controller gets an unexpected type of View")
    }

    func test_VC_should_call_updateLayoutOrientationIfNeeded_when_viewDidLayoutSubviews()
    {
        // arrange

        let orientation: NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical

        sut.stubbedView = mockView

        // act

        sut.loadViewIfNeeded()
        sut.viewDidLayoutSubviews()

        // assert

        XCTAssertTrue(sut.view is MockWeatherLayoutView,
                      "The View Controller gets an unexpected type of View")
        mockView.verifyUpdateLayoutOrientationIfNeeded(with: orientation)
    }

    func test_VC_should_call_startActivities_when_theAppDidBecomeActive()
    {
        // arrange

        sut.stubbedView = mockView

        // act

        sut.loadViewIfNeeded()
        sut.theAppDidBecomeActive()

        // assert

        XCTAssertTrue(sut.view is MockWeatherLayoutView,
                      "The View Controller gets an unexpected type of View")
        mockView.verifyStartActivities()
    }

    func test_VC_should_call_stopActivities_when_theAppDidEnterBackground()
    {
        // arrange

        sut.stubbedView = mockView

        // act

        sut.loadViewIfNeeded()
        sut.theAppDidEnterBackground()

        // assert

        XCTAssertTrue(sut.view is MockWeatherLayoutView,
                      "The View Controller gets an unexpected type of View")
        mockView.verifyStopActivities()
    }

    // MARK: - Testing With Focusing On GeoLocationReceiver Dependency

    func test_VC_should_call_requestLocationDataAccess_when_theAppDidFinishLaunching()
    {
        // arange

        sut.stubbedView = mockView

        // act

        sut.loadViewIfNeeded()
        sut.theAppDidFinishLaunching()

        // assert

        XCTAssertTrue(sut.view is MockWeatherLayoutView,
                      "The View Controller gets an unexpected type of View")
        mockLocationReceiver.verifyRequestLocationDataAccess()
    }

    // MARK: - Testing With Focusing On NotificationCenter Dependency

    func test_VC_should_call_addObserver_theAppDidFinishLaunching_when_init()
    {
        // assert

        mockNotificationCenter.verifyAddObserver(
            sut,
            selector: #selector(sut.theAppDidFinishLaunching),
            name    : UIApplication.didFinishLaunchingNotification,
            object  : nil)
    }

    func test_VC_should_call_addObserver_three_times_when_viewWillAppear()
    {
        // arrange

        let observers = [sut, sut, sut]
        let selectors =
            [
                // The first one called when .init
                #selector(sut.theAppDidFinishLaunching),
                // The next one called when viewWillAppear()
                #selector(sut.theAppDidBecomeActive),
                // The last one called also when viewWillAppear()
                #selector(sut.theAppDidEnterBackground)
            ]
        let names =
            [
                UIApplication.didFinishLaunchingNotification,
                UIApplication.didBecomeActiveNotification,
                UIApplication.didEnterBackgroundNotification
            ]
        let objects = [nil, nil, nil] as [Any?]

        // act

        sut.loadViewIfNeeded()
        sut.viewWillAppear(true)

        // assert

        mockNotificationCenter.verifyAddObserversShouldCalledThreeTimes(observers,
                                                                        selector: selectors,
                                                                        name    : names,
                                                                        object  : objects)
    }

    func test_VC_should_call_removeObserver_twice_when_viewWillDisappear()
    {
        // arrange

        let observers = [sut, sut]
        let names =
            [
                UIApplication.didBecomeActiveNotification,
                UIApplication.didEnterBackgroundNotification
            ]
        let objects = [nil, nil] as [Any?]

        // act

        sut.loadViewIfNeeded()
        sut.viewWillDisappear(false)

        // assert

        mockNotificationCenter.verifyRemoveObserverCalledTwice(observers,
                                                               name  : names,
                                                               object: objects)
    }
}
