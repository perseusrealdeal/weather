//
//  CurrentWeatherWithForecastHourlyStackView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 23.12.2021.
//

import UIKit

class CurrentWeatherWithForecastHourlyStackView: UIStackView
{
    // MARK: - View Layout Related Properties
    
    private var constraintVerticalAxis1   : NSLayoutConstraint!
    private var constraintVerticalAxis2   : NSLayoutConstraint!
    
    private var constraintHorizontalAxis1 : NSLayoutConstraint!
    private var constraintHorizontalAxis2 : NSLayoutConstraint!
    
    private var configuredForOrientation  : NSLayoutConstraint.Axis!
    
    // MARK: - Business Matter Data View Containers
    
    private let forecastHourlyView        : ForecastHourlyView
    private let currentWeatherView        : CurrentWeatherView
    
    // MARK: - Instance Initialization
    
    init(hourly : ForecastHourlyView,
         current: CurrentWeatherView)
    {
        forecastHourlyView = hourly
        currentWeatherView = current
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillProportionally
        axis = .horizontal
        
        initialize()
    }
    
    private func initialize()
    {
        constraintVerticalAxis1 = forecastHourlyView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.3)
        
        constraintVerticalAxis2 = currentWeatherView.heightAnchor.constraint(
            equalTo: self.heightAnchor, multiplier: 0.7)
        
        constraintHorizontalAxis1 = forecastHourlyView.widthAnchor.constraint(
            equalTo: self.widthAnchor, multiplier: 0.3)
        
        constraintHorizontalAxis2 = currentWeatherView.widthAnchor.constraint(
            equalTo: self.widthAnchor, multiplier: 0.7)
        
        addArrangedSubview(forecastHourlyView)
        addArrangedSubview(currentWeatherView)
        
        let currentOrientation : NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical
        
        changeLayout(for: currentOrientation)
        configuredForOrientation = currentOrientation
    }
    
    private func changeLayout(for deviceOrientation: NSLayoutConstraint.Axis)
    {
        if deviceOrientation == .vertical
        {
            axis = .horizontal
            
            removeArrangedSubview(forecastHourlyView)
            removeArrangedSubview(currentWeatherView)
            
            addArrangedSubview(forecastHourlyView)
            addArrangedSubview(currentWeatherView)
            
            NSLayoutConstraint.activate([constraintHorizontalAxis1, constraintHorizontalAxis2])
            NSLayoutConstraint.deactivate([constraintVerticalAxis1, constraintVerticalAxis2])
        }
        
        if deviceOrientation == .horizontal
        {
            axis = .vertical
            
            removeArrangedSubview(forecastHourlyView)
            removeArrangedSubview(currentWeatherView)
            
            addArrangedSubview(currentWeatherView)
            addArrangedSubview(forecastHourlyView)
            
            NSLayoutConstraint.activate([constraintVerticalAxis1, constraintVerticalAxis2])
            NSLayoutConstraint.deactivate([constraintHorizontalAxis1, constraintHorizontalAxis2])
        }
    }
    
    // MARK: - Business Logic Related Methods
    
    public func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    {
        if configuredForOrientation == currentOrientation { return }
        
        configuredForOrientation = currentOrientation
        changeLayout(for: currentOrientation)
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
