//
//  WeatherStackView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 23.12.2021.
//

import UIKit

class WeatherStackView: UIStackView {
    // MARK: - View Layout Related Properties

    private var constraintVerticalOrientation1: NSLayoutConstraint!
    private var constraintVerticalOrientation2: NSLayoutConstraint!

    private var constraintHorizontalOrientation1: NSLayoutConstraint!
    private var constraintHorizontalOrientation2: NSLayoutConstraint!

    private var configuredForOrientation: NSLayoutConstraint.Axis!
    private let stackView: CurrentWeatherWithForecastDailyStackView

    // MARK: - Business Matter Data View Containers

    private let weatherNationalAlertsView: WeatherNationalAlertsView

    // MARK: - Instance Initialization

    required init(coder aDecoder: NSCoder) { fatalError() }

    init(alerts: WeatherNationalAlertsView,
         hourly: ForecastHourlyView,
         daily: ForecastDailyView,
         current: CurrentWeatherView) {
        weatherNationalAlertsView = alerts
        stackView = CurrentWeatherWithForecastDailyStackView(hourly: hourly,
                                                             daily: daily,
                                                             current: current)

        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillProportionally

        initialize()
    }

    private func initialize() {
        constraintVerticalOrientation1 = weatherNationalAlertsView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.1)

        constraintVerticalOrientation2 = stackView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.9)

        constraintHorizontalOrientation1 = weatherNationalAlertsView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.1)

        constraintHorizontalOrientation2 = stackView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.9)

        addArrangedSubview(weatherNationalAlertsView)
        addArrangedSubview(stackView)

        let currentOrientation: NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical

        changeLayout(for: currentOrientation)
        configuredForOrientation = currentOrientation
    }

    private func changeLayout(for deviceOrientation: NSLayoutConstraint.Axis) {
        if deviceOrientation == .vertical {
            axis = .vertical

            NSLayoutConstraint.deactivate([constraintHorizontalOrientation1,
                                           constraintHorizontalOrientation2])

            NSLayoutConstraint.activate([constraintVerticalOrientation1,
                                         constraintVerticalOrientation2])
        }

        if deviceOrientation == .horizontal {
            axis = .vertical

            NSLayoutConstraint.deactivate([constraintVerticalOrientation1,
                                           constraintVerticalOrientation2])

            NSLayoutConstraint.activate([constraintHorizontalOrientation1,
                                         constraintHorizontalOrientation2])
        }
    }

    // MARK: - Business Logic Related Methods

    public func updateLayoutOrientationIfNeeded(
        for currentOrientation: NSLayoutConstraint.Axis) {

        if configuredForOrientation == currentOrientation { return }

        configuredForOrientation = currentOrientation

        changeLayout(for: currentOrientation)
        stackView.updateLayoutOrientationIfNeeded(for: currentOrientation)
    }
}
