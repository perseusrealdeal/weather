//
//  OpenWeatherCommunication.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 01.12.2021.
//

import XCTest
import SwiftyJSON

@testable import Weather

class OpenWeatherCommunicationTests: XCTestCase {
    // MARK: - Testing Network Requests (offline mode)

    func test_OpenWeatherClient_should_makeDataTaskAskForWeatherData() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        let happy =
            "https://api.openweathermap.org/data/2.5/onecall?" +
            "lat=55.662546456740564" +
            "&lon=85.62138369331707" +
            "&units=metric" +
            "&exclude=hourly,minutely,daily,alerts" +
            "&appid=79eefe16f6e4714470502074369fc77b"

        // act

        sut.requestWeatherData()

        // assert

        mock.verifyDataTask(with: URLRequest(url: URL(string: happy)!))
    }

    // MARK: - Testing Network Responses (offline mode)

    func test_updateWeatherNetworkCall_withSuccessResponse_shouldSaveDataAndInformByClient() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        let happiness = loadDataFromFile("currentWeatherData", "json")
        let expected_data: Result<Data, WeatherDataDeliveryError> = .success(happiness)
        var actual_data: Result<Data, WeatherDataDeliveryError> = .success(Data())

        let onResultUpdateCalled = expectation(description: "onResultUpdate called")
        sut.onResultDelivered = { result in

                actual_data = result
                onResultUpdateCalled.fulfill()
            }

        // act

        /// simulate request
        sut.requestWeatherData()

        /// simulate response
        mock.dataTaskArgsCompletionHandler.first?(happiness, response(statusCode: 200), nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.weather, happiness)
        XCTAssertEqual(String(describing: actual_data), String(describing: expected_data))
    }

    func test_updateWeatherNetworkCall_withError_shouldReportFailure() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        let expected_failure: Result<Data, WeatherDataDeliveryError> =
            .failure(.failedRequest("No data!"))

        var actual_failure: Result<Data, WeatherDataDeliveryError> =
            .success(Data())

        let onResultUpdateCalled = expectation(description: "onResultUpdate called")
        sut.onResultDelivered = { result in

                actual_failure = result
                onResultUpdateCalled.fulfill()
            }

        // act

        /// simulate request
        sut.requestWeatherData()

        /// simulate response
        mock.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "No data!"))

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(String(describing: actual_failure), String(describing: expected_failure))
    }

    func test_updateWeatherNetworkCall_withResponse_withStatusCodeNot200_shouldReportFailure() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        let status_code = 404
        let message = HTTPURLResponse.localizedString(forStatusCode: status_code)

        let expected_failure: Result<Data, WeatherDataDeliveryError> =
            .failure(.failedRequest(message))

        var actual_failure: Result<Data, WeatherDataDeliveryError> =
            .success(Data())

        let happiness = loadDataFromFile("currentWeatherData", "json")

        let onResultUpdateCalled = expectation(description: "onResultUpdate called")
        sut.onResultDelivered = { result in

                actual_failure = result
                onResultUpdateCalled.fulfill()
            }

        // act

        /// simulate request
        sut.requestWeatherData()

        /// simulate response
        mock.dataTaskArgsCompletionHandler.first?(happiness, response(statusCode: status_code), nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.weather, Data(), "Causing data update with failure status code!")
        XCTAssertEqual(String(describing: actual_failure), String(describing: expected_failure))
    }

    func test_updateWeatherNetworkCall_withSuccessBeforeAsync_shouldNotSaveDataByClient() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        let happy = loadDataFromFile("currentWeatherData", "json")

        // act

        /// simulate request
        sut.requestWeatherData()

        /// simulate response
        mock.dataTaskArgsCompletionHandler.first?(happy, response(statusCode: 200), nil)

        // assert

        XCTAssertEqual(sut.weather, Data())
    }

    func test_updateWeatherNetworkCall_withErrorPreAsync_shouldNotSaveDataByClient() {
        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherClient(session: mock)

        // act

        /// simulate request
        sut.requestWeatherData()

        /// simulate response
        mock.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "DUMMY"))

        // assert

        XCTAssertEqual(sut.weather, Data())
    }

}

// MARK: - Online test to make sure OpenWeather provides data

extension OpenWeatherCommunicationTests {
    func test_OpenWeather_should_provideNotEmptyData_withHavingNetworkConnection() {
        // arrange

        let sut = OpenWeatherClient()
        let onResultUpdateCalled = expectation(description: "onResultUpdate called")

        sut.onResultDelivered = { result in

                switch result {
                case .success(let weatherData):

                    if let answer_json = try? JSON(data: weatherData) {
                        print("""

                        OpenWeather responses...

                        \(answer_json)

                        """)
                    }

                case .failure(let error):
                    switch error {
                    case .invalidExclude:

                        print("error: bad exclude")

                    case .invalidUrl:

                        print("error: bad url")

                    case .failedRequest(let message):

                        print(message)
                    }
                }

                onResultUpdateCalled.fulfill()
            }

        /// "current,hourly,minutely,daily,alerts"
        let exclude: String = "current,hourly,minutely,daily"
        let latitude: String = "55.662546456740564"
        let longitude: String = "85.62138369331707"

        // act

        sut.requestWeatherData(exclude: exclude, latitude: latitude, longitude: longitude)
        waitForExpectations(timeout: 3)

        // assert

        XCTAssertTrue(sut.givenData != Data(), "There is no data has been given by OpenWeather!")
    }
}

// MARK: - Helper classes and methods

/// Used only for compiler satisfing.
/// dataTask(with:completionHandler:) can't return just URLSessionDataTask instance.
private class DummyURLSessionDataTask: URLSessionDataTask { override func resume() { } }

/// Used instead of URLSession.shared to make it isolated via constructor injection in OpenWeatherClient.
private class MockURLSession: URLSessionProtocol {
    /// for network request testing
    var dataTaskCallCount: Int = 0
    var dataTaskArgsRequest: [URLRequest] = []

    /// for network response testing
    var dataTaskArgsCompletionHandler: [(Data?, URLResponse?, Error?) -> Void] = []

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)

        /// only for network response testing
        dataTaskArgsCompletionHandler.append(completionHandler)

        return DummyURLSessionDataTask()
    }

    fileprivate func verifyDataTask(with request: URLRequest,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
        guard dataTaskWasCalledOnce(file: file, line: line) else { return }

        XCTAssertEqual(dataTaskArgsRequest.first, request, "request", file: file, line: line)
    }

    private func dataTaskWasCalledOnce(file: StaticString = #file, line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(methodName: "dataTask(with:completionHandler:)",
                               callCount: dataTaskCallCount,
                               describeArguments: "request: \(dataTaskArgsRequest)",
                               file: file,
                               line: line)
    }
}

private func verifyMethodCalledOnce(methodName: String,
                                    callCount: Int,
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

struct TestError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

// MARK: - Generating test data for network response testing

private func loadDataFromFile(_ fileName: String, _ fileExtension: String) -> Data {
    guard let url = Bundle(for: OpenWeatherCommunicationTests.self).url(forResource: fileName,
                                                                withExtension: fileExtension),
          let data = try? Data(contentsOf: url)
    else { return Data() }

    return data
}

private func response(statusCode: Int) -> HTTPURLResponse? {
    HTTPURLResponse(url: URL(string: "http://DUMMY")!,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: nil)
}
