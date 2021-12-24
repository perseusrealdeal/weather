//
//  WeatherView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 07.12.2021.
//

import UIKit

enum WeatherLayoutVariation
{
    case allDetails
}

class WeatherLayoutView: UIView
{
    // MARK: - View Layout Related Properties
    
    private var configuredForOrientation : NSLayoutConstraint.Axis?
    private let stackView                : WeatherStackView
    
    // MARK: - Business Matter Data View Containers
    
    private let viewModel                : WeatherViewModel
    
    let alertsView               : WeatherNationalAlertsView
    let forecastHourlyView       : ForecastHourlyView
    let forecastDailyView        : ForecastDailyView
    let currentWeatherView       : CurrentWeatherView
    
    // MARK: - Instance Initialization
    
    init(with layoutNumber: WeatherLayoutVariation = .allDetails)
    {
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
        
        viewModel.host = self
        
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
    
    public func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    {
        if configuredForOrientation == currentOrientation { return }
        
        stackView.updateLayoutOrientationIfNeeded(for: currentOrientation)
        configuredForOrientation = currentOrientation
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> \(type(of: self)).deinit")
        #endif
    }
    
    required init(coder aDecoder: NSCoder) { fatalError() }
}
