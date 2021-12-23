//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 23.12.2021.
//

import UIKit

class CurrentWeatherView: UIView
{
    // MARK: - Instance Initialization
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        backgroundColor = .green
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
