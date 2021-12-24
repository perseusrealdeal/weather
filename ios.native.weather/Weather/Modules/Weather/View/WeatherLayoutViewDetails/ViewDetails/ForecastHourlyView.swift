//
//  ForecastHourlyView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 23.12.2021.
//

import UIKit

class ForecastHourlyView: UIView
{
    // MARK: - Business Matter Data to View
    
    var data : [ForecastHour]?
    {
        didSet
        {
            reloadData()
        }
    }
    
    // MARK: - Instance Initialization
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        backgroundColor = .yellow
    }
    
    // MARK: - Business Logic Related Methods
    
    private func reloadData()
    {
        
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
