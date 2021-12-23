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
    
    private var configuredForOrientation : NSLayoutConstraint.Axis!
    
    // MARK: - Business Matter Data View Containers
    
    private let stackView : WeatherStackView =
    {
        let view = WeatherStackView()
        
        return view
    }()
    
    // MARK: - Instance Initialization
    
    init(with layoutNumber: WeatherLayoutVariation = .allDetails)
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        initialize()
    }
    
    private func initialize()
    {
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
        
        configuredForOrientation = currentOrientation
        
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
