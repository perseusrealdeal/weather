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

class WeatherLayoutView: UIStackView
{
    // MARK: - View Layout Related Properties
    
    private var constraintVerticalOrientation1   : NSLayoutConstraint!
    private var constraintVerticalOrientation2   : NSLayoutConstraint!
    
    private var constraintHorizontalOrientation1 : NSLayoutConstraint!
    private var constraintHorizontalOrientation2 : NSLayoutConstraint!
    
    private var configuredForOrientation         : NSLayoutConstraint.Axis!
    
    // MARK: - Business Matter Data View Containers
    
    private let weatherNationalAlertsView : WeatherNationalAlertsView =
    {
        let view = WeatherNationalAlertsView()
        
        return view
    }()
    
    private let stackView : CurrentWeatherWithForecastDailyStackView =
    {
        let view = CurrentWeatherWithForecastDailyStackView()
        
        return view
    }()
    
    // MARK: - Instance Initialization
    
    init(with layoutNumber: WeatherLayoutVariation = .allDetails)
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillProportionally
        
        initialize()
    }
    
    private func initialize()
    {
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
            
            NSLayoutConstraint.deactivate([constraintHorizontalOrientation1,
                                           constraintHorizontalOrientation2])
            
            NSLayoutConstraint.activate([constraintVerticalOrientation1,
                                         constraintVerticalOrientation2])
        }
        
        if deviceOrientation == .horizontal
        {
            axis = .vertical
            
            NSLayoutConstraint.deactivate([constraintVerticalOrientation1,
                                           constraintVerticalOrientation2])
            
            NSLayoutConstraint.activate([constraintHorizontalOrientation1,
                                         constraintHorizontalOrientation2])
        }
    }
    
    public func updateLayoutOrientationIfNeeded(for currentOrientation: NSLayoutConstraint.Axis)
    {
        if configuredForOrientation == currentOrientation { return }
        
        configuredForOrientation = currentOrientation
        
        changeLayout(for: currentOrientation)
        stackView.updateLayoutOrientationIfNeeded(for: currentOrientation)
    }
    
    // MARK: - Business Logic Related Methods
    
    
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> \(type(of: self)).deinit")
        #endif
    }
    
    required init(coder aDecoder: NSCoder) { fatalError() }
    
}
