//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 06.12.2021.
//

import UIKit

class WeatherViewController: UIViewController
{
    deinit
    {
        #if DEBUG
        print("\(type(of: self)).deinit")
        #endif
    }
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        self.view = WeatherLayoutView.xibInstance()
        
        // Do default setup
        
        #if DEBUG
        print(">> " + "greetings".localized_value)
        print(#function)
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
}
