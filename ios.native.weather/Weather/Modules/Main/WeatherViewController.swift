//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 06.12.2021.
//

import UIKit

class WeatherViewController: UIViewController
{
    // MARK: - Business Logic Related Properties
    
    
    
    // MARK: - View Controller Life Circle Methods
    
    init()
    {
        #if DEBUG
        print(">> \(type(of: self)) " + #function)
        #endif
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView()
    {
        #if DEBUG
        print(">> \(type(of: self)) " + #function)
        #endif
        
        view = WeatherLayoutView()
    }
    
    override func viewDidLoad()
    {
        #if DEBUG
        print(">> \(type(of: self)) " + #function)
        #endif
        
        super.viewDidLoad()
        
        #if DEBUG
        print("greetings".localized_value)
        #endif
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews()
    {
        let currentOrientation : NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical
        
        guard let view = view as? WeatherLayoutView else { return }
        
        view.updateLayoutOrientationIfNeeded(for: currentOrientation)
        
        print(">> \(type(of: self)) " + #function)
    }
    
    // MARK: - Business Logic Related Methods
    
    
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> \(type(of: self)).deinit")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
