//
//  main.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 28.11.2021.
//

import UIKit

// MARK: - The Application Object Initiation

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))

// MARK: - The Application Delegate

class AppDelegate: UIResponder { var window: UIWindow? }

extension AppDelegate: UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        #if DEBUG
        print(">> Launching with real app delegate")
        print(">> " + #function)
        #endif
        
        UserPreferences.setVersionAndBuildNumberUp()
        UserPreferences.registerSettingsBundle(with: Settings.bundleParams)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window!.rootViewController = WeatherViewController()
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
}
