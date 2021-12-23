//
//  WeatherNationalAlertsView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 22.12.2021.
//

import UIKit

class WeatherNationalAlertsView: UIView
{
    // MARK: - Instance Initialization
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        backgroundColor = .red
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
