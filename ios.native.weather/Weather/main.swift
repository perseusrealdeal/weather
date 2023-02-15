//
//  main.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 28.11.2021.
//

import UIKit
import PerseusDarkMode

// MARK: - The Application Object Initiation

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self
let delegateClassName = NSStringFromClass(appDelegateClass)

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName)
