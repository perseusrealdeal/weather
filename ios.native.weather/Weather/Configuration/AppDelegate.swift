//
//  AppDelegate.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 14/02/2023.
//  Copyright © 2023 Perseusrealdeal. All rights reserved.
//

import UIKit
import PerseusDarkMode

// MARK: - The Application Delegate

class AppDelegate: UIResponder { var window: UIWindow? }

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        print(">> Launching with real app delegate")
        print(">> [\(type(of: self))]." + #function)
        #endif

        UserPreferences.setVersionAndBuildNumberUp()
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)

        window = UIWindow(frame: UIScreen.main.bounds)

        #if true
        window!.rootViewController = WeatherViewController()
        #else
        window!.rootViewController = MainViewController.storyboardInstance()
        #endif

        window!.makeKeyAndVisible()

        AppearanceService.makeUp()

        return true
    }
}
