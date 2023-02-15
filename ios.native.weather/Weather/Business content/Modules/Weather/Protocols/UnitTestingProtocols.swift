//
//  ProtocolsForUnitTesting.swift
//  Weather
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: - Abstracts used to make code testable

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?)

    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?)
}

protocol GeoLocationServiceProtocol {
    func requestLocationDataAccess()
    func requestLocationUpdateOnce(_ actionIfNotAllowed: ((_ case: LocationServiceNotAllowed)
                                                          -> Void)?)
}

protocol WeatherLayoutViewProtocol {
    func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    func startActivities()
    func stopActivities()
}

protocol WeatherDataModelProtocol {
    var target: CurrentLocationDescription? { get }
    var lastFullUpdateTime: LastFullUpdateTime? { get }

    var isForecastHourlyUpToDate: Bool { get }
    var isForecastDailyUpToDate: Bool { get }
    var isForecastCurrentUpToDate: Bool { get }

    func update(received data: Data, _ completed:((_ onlyAlerts: Bool) -> Void))
}

protocol WeatherClientProtocol {
    var onResultDelivered: (Result<Data, WeatherDataDeliveryError>) -> Void { get set }

    func requestWeatherData(exclude: String, latitude: String, longitude: String)
}

protocol LocalDataSaverProtocol {
    func loadData() -> JSON
    func save(_ jsonData: JSON?)
}

extension LocalDataSaver: LocalDataSaverProtocol { }
extension NotificationCenter: NotificationCenterProtocol { }
extension GeoLocationReceiver: GeoLocationServiceProtocol { }
extension WeatherLayoutView: WeatherLayoutViewProtocol { }
extension OpenWeatherClient: WeatherClientProtocol { }
extension WeatherDataModel: WeatherDataModelProtocol { }
