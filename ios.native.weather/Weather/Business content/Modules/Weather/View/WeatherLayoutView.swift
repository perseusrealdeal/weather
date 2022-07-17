//
//  WeatherView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 07.12.2021.
//

import UIKit

enum WeatherLayoutVariation {
    case allDetails
}

class WeatherLayoutView: UIView {
    // MARK: - View Layout Related Properties

    /// configuredForOrientation is initialized when updateLayoutOrientationIfNeeded method called
    private var configuredForOrientation: NSLayoutConstraint.Axis?
    private let stackView               : WeatherStackView

    // MARK: - Business Matter Data Container

    private let viewModel               : WeatherViewModel

    // MARK: - Business Matter Data View Containers

    private let alertsView              : WeatherNationalAlertsView
    private let forecastHourlyView      : ForecastHourlyView
    private let forecastDailyView       : ForecastDailyView
    private let currentWeatherView      : CurrentWeatherView

    // MARK: - Instance Initialization

    required init(coder aDecoder: NSCoder) { fatalError() }

    init(with layoutNumber  : WeatherLayoutVariation = .allDetails) {
        viewModel = WeatherViewModel()

        alertsView = WeatherNationalAlertsView()
        forecastHourlyView = ForecastHourlyView()
        forecastDailyView = ForecastDailyView()
        currentWeatherView = CurrentWeatherView()

        stackView = WeatherStackView(alerts : alertsView,
                                     hourly : forecastHourlyView,
                                     daily  : forecastDailyView,
                                     current: currentWeatherView)

        super.init(frame: CGRect.zero)

        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        viewModel.weatherView = self

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    // MARK: - Business Logic Related Methods

    func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    {
        if configuredForOrientation == currentOrientation { return }

        stackView.updateLayoutOrientationIfNeeded(for: currentOrientation)
        configuredForOrientation = currentOrientation
    }

    func startActivities() {
        viewModel.startAutoUpdatingWeatherData()
    }

    func stopActivities() {
        viewModel.stopAutoUpdatingWeatherData()
    }
}
