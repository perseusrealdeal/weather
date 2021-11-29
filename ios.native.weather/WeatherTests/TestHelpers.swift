//
//  TestHelpers.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 29.11.2021.
//

import XCTest

// MARK: - The Testing Application Delegate

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        print("<< Launching with testing app delegate")
        
        return true
    }
}
