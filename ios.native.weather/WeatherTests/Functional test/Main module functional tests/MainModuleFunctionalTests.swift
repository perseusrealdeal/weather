//
//  MainModuleFunctionalTests.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 20.12.2021.
//

import XCTest
@testable import Weather

class MainModuleFunctionalTests: XCTestCase
{
    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }
    
    func test_viewController_loadView_called()
    {
        let sut = WeatherViewController()
        
        sut.loadViewIfNeeded()
    }
}
