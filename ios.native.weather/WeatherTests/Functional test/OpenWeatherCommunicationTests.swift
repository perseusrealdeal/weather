//
//  OpenWeatherCommunication.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 01.12.2021.
//
//  

import XCTest
import SwiftyJSON

@testable import Weather

class OpenWeatherCommunicationTests: XCTestCase
{
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    
    func test_openweather_should_provide_not_empty_data()
    {
        // arrange
        
        let sut = OpenWeatherClient()
        let onWeatherDataUpdateCalled = expectation(description: "onWeatherDataUpdate called")
        
        sut.onWeatherDataUpdate =
            { weatherData in
                
                if let answer_json = try? JSON(data: weatherData)
                {
                    print("""
                    
                    OpenWeather responses...
                    
                    \(answer_json)
                    
                    """)
                }
                
                onWeatherDataUpdateCalled.fulfill()
            }
        
        // act
        
        sut.updateWeatherData()
        waitForExpectations(timeout: 3)
        
        // assert
        
        XCTAssertTrue(sut.givenData != Data(), "There is no data has been given by OpenWeather!")
    }
}
