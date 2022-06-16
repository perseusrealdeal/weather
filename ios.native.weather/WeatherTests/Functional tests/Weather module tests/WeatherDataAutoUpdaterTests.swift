//
//  WeatherDataAutoUpdaterTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 13.01.2022.
//

import XCTest
@testable import Weather

class WeatherDataAutoUpdaterTests: XCTestCase
{
    private var sut                   : WeatherDataAutoUpdater!
    private var dataModel             : WeatherDataModel!

    private var mockLocalDataSaver    : LocalDataSaverStubbed!
    private var mockGeoLocationService: MockGeoLocationService!
    private var mockUpdaterHelper     : MockUpdaterHelper!

    private var mockWeatherDataService: MockWeatherClientService!
    private var mockWeatherDelegate   : MockWeatherUpdaterDelegate!

    override func setUp()
    {
        super.setUp()

        mockLocalDataSaver = LocalDataSaverStubbed()
        dataModel = WeatherDataModel(saver: mockLocalDataSaver)

        mockGeoLocationService = MockGeoLocationService()
        mockUpdaterHelper = MockUpdaterHelper(helper: UpdaterHelper())

        mockWeatherDataService = MockWeatherClientService()

        sut = WeatherDataAutoUpdater(data              : dataModel,
                                     helper            : mockUpdaterHelper,
                                     weatherDataService: mockWeatherDataService,
                                     geoLocationService: mockGeoLocationService)

        sut.useCurrentLocation = true

        mockWeatherDelegate = MockWeatherUpdaterDelegate()
        sut.delegate = mockWeatherDelegate
    }

    override func tearDown()
    {
        sut = nil
        dataModel = nil
        mockGeoLocationService = nil
        mockUpdaterHelper.timerTargetStubbed = nil
        mockUpdaterHelper = nil
        mockWeatherDelegate = nil

        super.tearDown()
    }

    // MARK: - PART I: Testing Configuration Setup

    // MARK: - Testing Updater Start Configuration

    func test_updater_is_congigured_right()
    {
        // Arrange

        let dataModel = WeatherDataModel()
        let sut = WeatherDataAutoUpdater(data: dataModel)

        // Assert

        XCTAssertNil(sut.delegate)
        XCTAssertNil(sut.timer)

        XCTAssertTrue(sut.helper is UpdaterHelper)
        XCTAssertTrue(sut.geoLocationService is GeoLocationReceiver)
        XCTAssertTrue(sut.weatherDataService is OpenWeatherClient)
        XCTAssertTrue(sut.data.saver is LocalDataSaver)

        XCTAssertFalse(sut.activated)
        XCTAssertFalse(sut.useCurrentLocation)
    }

    // MARK: - Testing Updater Test Configuration

    func test_updater_is_congigured_right_for_testing()
    {
        // Assert

        XCTAssertNil(sut.timer)

        XCTAssertTrue(sut.helper is MockUpdaterHelper)
        XCTAssertTrue(sut.geoLocationService is MockGeoLocationService)
        XCTAssertTrue(sut.weatherDataService is MockWeatherClientService)
        XCTAssertTrue(sut.delegate is MockWeatherUpdaterDelegate)
        XCTAssertTrue(sut.useCurrentLocation)
        XCTAssertTrue(sut.data.saver is LocalDataSaverStubbed)

        XCTAssertFalse(sut.activated)
    }

    // MARK: - Testing Updater Activation

    func test_updater_should_be_activated_only_once()
    {
        // Act

        sut.activateAutoUpdating()
        sut.activateAutoUpdating()
        sut.activateAutoUpdating()

        // Assert

        mockUpdaterHelper.verifyRegisterCurrentLocationObserver(
            observer: sut.self,
            selector: #selector(sut.locationReceivedNotificationHandler(_:)))
    }

    func test_updater_should_call_registerCurrentLocationObserver_when_activated()
    {
        // Act

        sut.activateAutoUpdating()

        // Assert

        mockUpdaterHelper.verifyRegisterCurrentLocationObserver(
            observer: sut.self,
            selector: #selector(sut.locationReceivedNotificationHandler(_:)))
    }

    func test_updater_should_call_prepareTimer_when_activated()
    {
        // Act

        sut.activateAutoUpdating()

        // Assert

        if let delay = mockUpdaterHelper.prepareTimerArgs_delays.first
        {
            mockUpdaterHelper.verifyPrepareTimer(
                target  : sut.self,
                delay   : delay,
                selector: #selector(sut.locationReceivedNotificationHandler))
        }
        else
        {
            XCTFail("Delay should be calculated to set up timer.")
        }

    }

    func test_updater_should_mark_flag_in_true_when_activated()
    {
        // Act

        sut.activateAutoUpdating()

        // Assert

        XCTAssertTrue(sut.activated)
    }

    // MARK: - Testing Updater Disactivation

    func test_updater_should_call_removeCurrentLocationObserver_when_disactivated()
    {
        // Act

        sut.disactivateAutoUpdating()

        // Assert

        mockUpdaterHelper.verifyRemoveCurrentLocationObserver(observer: sut.self)
    }

    func test_updater_should_cancel_timer_when_disactivated()
    {
        // Act

        sut.disactivateAutoUpdating()

        // Assert

        XCTAssertNil(sut.timer)
    }

    func test_updater_should_mark_flag_in_false_when_disactivated()
    {
        // Act

        sut.disactivateAutoUpdating()

        // Assert

        XCTAssertFalse(sut.activated)
    }

    // MARK: - PART II: Testing Internal Timer's Behaviour (engine)

    func test_timer_should_tick_immediately_if_no_delay()
    {
        // arrange

        let onTickCallCountExpected = 1

        weak var promiseToCallBack = expectation(description: "Spinning a wheel manually [0]")

        let targetStubbed = TimerTargetStubbed
        {
            print(">> [\(type(of: self))].promiseCompleted")

            self.sut.disactivateAutoUpdating()

            promiseToCallBack?.fulfill()
            promiseToCallBack = nil
        }

        mockUpdaterHelper.timerTargetStubbed = targetStubbed
        mockUpdaterHelper.delay = 0.0
        mockUpdaterHelper.isTimerOnlyForCallCount = false

        // act

        sut.activateAutoUpdating()

        let timeOut = sut.timer.tolerance

        waitForExpectations(timeout: timeOut, handler: nil)

        // assert

        XCTAssertEqual(targetStubbed.onTickCallCount, onTickCallCountExpected)

        print("Assert: targetStubbed.onTickCallCount: " +
        "\(targetStubbed.onTickCallCount) == \(onTickCallCountExpected)")
    }

    func test_timer_should_tick_with_delay()
    {
        // arrange

        let onTickCallCountExpected = 1

        weak var promiseToCallBack = expectation(description: "Spinning a wheel manually [1]")

        let targetStubbed = TimerTargetStubbed
        {
            print(">> [\(type(of: self))].promiseCompleted")

            self.sut.disactivateAutoUpdating()

            promiseToCallBack?.fulfill()
            promiseToCallBack = nil
        }

        let delay = mockUpdaterHelper.calculateDelay() // In milliseconds

        mockUpdaterHelper.timerTargetStubbed = targetStubbed
        mockUpdaterHelper.isTimerOnlyForCallCount = false

        // act

        sut.activateAutoUpdating()

        let timeOut = delay + sut.timer.tolerance

        waitForExpectations(timeout: timeOut)

        // assert

        XCTAssertEqual(targetStubbed.onTickCallCount, onTickCallCountExpected)

        print("Assert: targetStubbed.onTickCallCount: " +
        "\(targetStubbed.onTickCallCount) == \(onTickCallCountExpected)")
    }

    func test_timer_should_tick_in_period_with_no_delay()
    {
        // arrange

        let onTickCallCountExpected = 2
        var onTickCallCountHere = 0

        weak var promiseToCallBack = expectation(description: "Spinning a wheel manually [2]")

        let targetStubbed = TimerTargetStubbed
        {
            onTickCallCountHere += 1

            if onTickCallCountHere == onTickCallCountExpected
            {
                print(">> [\(type(of: self))].promiseCompleted")

                self.sut.disactivateAutoUpdating()

                promiseToCallBack?.fulfill()
                promiseToCallBack = nil
            }
        }

        mockUpdaterHelper.timerTargetStubbed = targetStubbed
        mockUpdaterHelper.delay = 0.0
        mockUpdaterHelper.isTimerOnlyForCallCount = false

        // act

        sut.activateAutoUpdating()

        let interval: Double = (UPDATE_JOB_INTERVAL * 60) / 1000.0
        let timeOut = sut.timer.tolerance + interval

        waitForExpectations(timeout: timeOut)

        // assert

        XCTAssertEqual(targetStubbed.onTickCallCount, onTickCallCountExpected)

        print("Assert: targetStubbed.onTickCallCount: " +
        "\(targetStubbed.onTickCallCount) == \(onTickCallCountExpected)")
    }

    func test_timer_should_tick_in_period_with_delay()
    {
        // arrange

        let onTickCallCountExpected = 2
        var onTickCallCountHere = 0

        weak var promiseToCallBack = expectation(description: "Spinning a wheel manually [3]")

        let targetStubbed = TimerTargetStubbed
        {
            onTickCallCountHere += 1

            if onTickCallCountHere == onTickCallCountExpected
            {
                print(">> [\(type(of: self))].promiseCompleted")

                self.sut.disactivateAutoUpdating()

                promiseToCallBack?.fulfill()
                promiseToCallBack = nil
            }
        }

        let delay = mockUpdaterHelper.calculateDelay()

        mockUpdaterHelper.timerTargetStubbed = targetStubbed
        mockUpdaterHelper.isTimerOnlyForCallCount = false

        // act

        sut.activateAutoUpdating()

        let interval: Double = (UPDATE_JOB_INTERVAL * 60) / 1000.0
        let timeOut = delay + sut.timer.tolerance + interval

        waitForExpectations(timeout: timeOut)

        // assert

        XCTAssertEqual(targetStubbed.onTickCallCount, onTickCallCountExpected)

        print("Assert: targetStubbed.onTickCallCount: " +
        "\(targetStubbed.onTickCallCount) == \(onTickCallCountExpected)")
    }

    // MARK: - PART III: Testing Updater's Job (scenarios)

    /// 1
    /// 1.1
    func test_updateWeatherDataIfNeeded_should_succeeded_toRequest_if_DefaultLocation()
    {
        // arrange

        sut.useCurrentLocation = false

        let exclude_expected = "minutely"
        let lat_expected = String(Settings.defaultLocation.latitude)
        let lon_expected = String(Settings.defaultLocation.longitude)

        /// make sure before act
        XCTAssertNil(sut.data.target)

        // act

        sut.updateWeatherDataIfNeeded()

        // assert

        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)
    }

    /// 1.2
    func test_updateWeatherDataIfNeeded_should_succeeded_if_NotDefaultLocation()
    {
        // arrange

        sut.useCurrentLocation = false

        mockLocalDataSaver.isDataEmpty = false
        dataModel.loadFromLocal()

        let target = sut.data.target!

        let exclude_expected = ""
        let lat_expected = String(target.latitude)
        let lon_expected = String(target.longitude)

        // act

        sut.updateWeatherDataIfNeeded()

        // assert

        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)
    }

    /// 2
    func test_updateWeatherDataIfNeeded_should_call_requestLocationUpdateOnce()
    {
        // arrange

        sut.useCurrentLocation = true

        // act

        sut.updateWeatherDataIfNeeded()

        // assert

        mockGeoLocationService.verifyRequestLocationUpdateOnce()
    }

    /// 3
    func test_updateWeatherDataIfNeeded_should_succeeded_if_geoServiceNotAllowed()
    {
        // arrange

        sut.useCurrentLocation = true
        mockGeoLocationService.useCallBack = true

        let reason = mockGeoLocationService.reasonInCallBack

        let exclude_expected = "minutely"
        let lat_expected = String(Settings.defaultLocation.latitude)
        let lon_expected = String(Settings.defaultLocation.longitude)

        // act

        sut.updateWeatherDataIfNeeded()

        // assert

        mockGeoLocationService.verifyRequestLocationUpdateOnce()
        mockWeatherDelegate.verifyLocationServiceNotAllowed(reason: reason)
        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)

    }

    /// 4
    /// 4.1
    func test_locationReceivedNotificationHandler_should_succeeded_if_failedToGetCurrentLocation()
    {
        // arrange

        let result: Result<Сoordinate, LocationReceivedError> = .failure(.failedRequest("error"))

        let result_arranged = Notification(name    : .locationReceivedNotification,
                                           object  : result,
                                           userInfo: nil)

        sut.useCurrentLocation = true

        let exclude_expected = "minutely"
        let lat_expected = String(Settings.defaultLocation.latitude)
        let lon_expected = String(Settings.defaultLocation.longitude)

        // act

        sut.locationReceivedNotificationHandler(result_arranged)

        // assert

        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)

        mockWeatherDelegate.verifyFailedToGetCurrentLocation()
    }

    /// 4.2
    func test_locationReceivedNotificationHandler_should_succeeded_if_locationNotChanged()
    {
        // arrange

        let coordinate = Сoordinate(latitude: 55.659999999999997, longitude: 85.620000000000005)

        let result: Result<Сoordinate, LocationReceivedError> = .success(coordinate)

        let result_arranged = Notification(name    : .locationReceivedNotification,
                                           object  : result,
                                           userInfo: nil)

        mockLocalDataSaver.isDataEmpty = false
        dataModel.loadFromLocal()

        sut.useCurrentLocation = true

        let exclude_expected = ""
        let lat_expected = String(coordinate.latitude)
        let lon_expected = String(coordinate.longitude)

        // act

        let isLocationChanged = coordinate == dataModel.target?.location ? false : true

        sut.locationReceivedNotificationHandler(result_arranged)

        // assert

        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)

        XCTAssertFalse(isLocationChanged, "Location should not be different.")
    }

    /// 5
    func test_locationReceivedNotificationHandler_should_succeeded_if_locationChanged()
    {
        // arrange

        let coordinate = Сoordinate(latitude: 45.659999999999997, longitude: 85.620000000000005)

        let result: Result<Сoordinate, LocationReceivedError> = .success(coordinate)

        let result_arranged = Notification(name    : .locationReceivedNotification,
                                           object  : result,
                                           userInfo: nil)

        mockLocalDataSaver.isDataEmpty = false
        dataModel.loadFromLocal()

        sut.useCurrentLocation = true

        let exclude_expected = "minutely"
        let lat_expected = String(coordinate.latitude)
        let lon_expected = String(coordinate.longitude)

        // act

        let isLocationChanged = coordinate == dataModel.target?.location ? false : true

        sut.locationReceivedNotificationHandler(result_arranged)

        // assert

        mockWeatherDataService.verifyRequestWeatherData(exclude  : exclude_expected,
                                                        latitude : lat_expected,
                                                        longitude: lon_expected)

        XCTAssertTrue(isLocationChanged, "Location should be different.")
    }

    /// 6
    /// 6.1
    func test_weatherDataDeliveredHandler_should_call_delegateWeatherDataUpdated()
    {
        // arrange

        let data_arranged = loadDataFromFile("defaultLocationRU", "json")
        let result_arranged: Result<Data, WeatherDataDeliveryError> = .success(data_arranged)

        // act

        sut.weatherDataDeliveredHandler(result_arranged)

        // assert

        mockWeatherDelegate.verifyWeatherDataUpdated()
    }

    /// 6.2
    func test_weatherDataDeliveredHandler_should_call_delegateWeatherAlertsUpdated()
    {
        // arrange

        let data_arranged = loadDataFromFile("alertsOnly", "json")
        let result_arranged: Result<Data, WeatherDataDeliveryError> = .success(data_arranged)

        // act

        sut.weatherDataDeliveredHandler(result_arranged)

        // assert

        mockWeatherDelegate.verifyWeatherAlertsUpdated()
    }

    /// 7
    func test_weatherDataDeliveredHandler_should_call_delegateFailedToDeliverWeatherData()
    {
        // arrange

        let result_arranged: Result<Data, WeatherDataDeliveryError> =
            .failure(.failedRequest("error"))

        // act

        sut.weatherDataDeliveredHandler(result_arranged)

        // assert

        mockWeatherDelegate.verifyFailedToDeliverWeatherData()
    }
}

private func loadDataFromFile(_ fileName: String, _ fileExtension: String) -> Data
{
    guard let url = Bundle(for: LocalDataSaverStubbed.self).url(forResource  : fileName,
                                                                withExtension: fileExtension),
          let data = try? Data(contentsOf: url)
    else { return Data() }

    return data
}
