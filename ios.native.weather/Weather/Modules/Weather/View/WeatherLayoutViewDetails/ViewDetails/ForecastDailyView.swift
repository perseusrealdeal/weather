//
//  ForecastDailyView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 23.12.2021.
//

import UIKit

class ForecastDailyView: UIView
{
    // MARK: - Business Matter Data to View
    
    var data: [ForecastDay]?
    {
        didSet
        {
            reloadData()
        }
    }
    
    // MARK: - Instance Initialization
    
    required init(coder aDecoder: NSCoder) { fatalError() }
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        backgroundColor = .orange
    }
    
    // MARK: - Business Logic Related Methods
    
    private func reloadData()
    {
        print(">> \(type(of: self)) " + #function)
        
        if let data = data
        {
            print(data)
        }
    }
}
