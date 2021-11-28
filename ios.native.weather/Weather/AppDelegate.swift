//
//  AppDelegate.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 28.11.2021.
//

import UIKit

// MARK: - The Application Delegate

@main
class AppDelegate: UIResponder { var window: UIWindow? }

extension AppDelegate: UIApplicationDelegate
{
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        #if DEBUG
        print(">> Launching with real app delegate")
        print(#function)
        #endif
        
        return true
    }
    
}
