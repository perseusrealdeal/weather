//
//  WeatherDetailsStackView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 22.12.2021.
//

import UIKit

class CurrentWeatherWithForecastDailyStackView: UIStackView
{
    // MARK: - View Layout Related Properties
    
    private var constraintVerticalAxis1   : NSLayoutConstraint!
    private var constraintVerticalAxis2   : NSLayoutConstraint!
    
    private var constraintHorizontalAxis1 : NSLayoutConstraint!
    private var constraintHorizontalAxis2 : NSLayoutConstraint!
    
    private var configuredForOrientation  : NSLayoutConstraint.Axis!
    private let stackView                 : CurrentWeatherWithForecastHourlyStackView
    
    // MARK: - Business Matter Data View Containers
    
    private let forecastDailyView         : ForecastDailyView
    
    // MARK: - Instance Initialization
    
    init(hourly : ForecastHourlyView,
         daily  : ForecastDailyView,
         current: CurrentWeatherView)
    {
        forecastDailyView = daily
        stackView = CurrentWeatherWithForecastHourlyStackView(hourly : hourly,
                                                              current: current)
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillProportionally
        axis = .vertical
        
        initialize()
    }
    
    private func initialize()
    {
        constraintVerticalAxis1 = stackView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.6)
        
        constraintVerticalAxis2 = forecastDailyView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.4)
        
        constraintHorizontalAxis1 = stackView.widthAnchor.constraint(
            equalTo: self.widthAnchor, multiplier: 0.6)
        
        constraintHorizontalAxis2 = forecastDailyView.widthAnchor.constraint(
            equalTo: self.widthAnchor, multiplier: 0.4)
        
        addArrangedSubview(stackView)
        addArrangedSubview(forecastDailyView)
        
        let currentOrientation : NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical
        
        changeLayout(for: currentOrientation)
        configuredForOrientation = currentOrientation
    }
    
    private func changeLayout(for deviceOrientation: NSLayoutConstraint.Axis)
    {
        if deviceOrientation == .vertical
        {
            axis = .vertical
            
            NSLayoutConstraint.deactivate([constraintHorizontalAxis1, constraintHorizontalAxis2])
            NSLayoutConstraint.activate([constraintVerticalAxis1, constraintVerticalAxis2])
        }
        
        if deviceOrientation == .horizontal
        {
            axis = .horizontal
            
            NSLayoutConstraint.deactivate([constraintVerticalAxis1, constraintVerticalAxis2])
            NSLayoutConstraint.activate([constraintHorizontalAxis1, constraintHorizontalAxis2])
        }
    }
    
    // MARK: - Business Logic Related Methods
    
    public func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    {
        if configuredForOrientation == currentOrientation { return }
        
        configuredForOrientation = currentOrientation
        changeLayout(for: currentOrientation)
        
        stackView.updateLayoutOrientationIfNeeded(for: currentOrientation)
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
