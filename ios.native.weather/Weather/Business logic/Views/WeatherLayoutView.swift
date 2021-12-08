//
//  WeatherView.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 07.12.2021.
//

import UIKit

class WeatherLayoutView: UIView
{
    deinit
    {
        #if DEBUG
        print("\(type(of: self)).deinit")
        #endif
    }
    
    class func xibInstance(with layoutNumber: Int = 1) -> WeatherLayoutView
    {
        let view = UINib(nibName: "Layout_\(layoutNumber)",
                         bundle : nil).instantiate(withOwner: self,
                                                    options : nil)[0] as! WeatherLayoutView
        
        /// Do default setup; don't set any parameter causing loadView up, breaks unit tests
        
        return view
    }
    
}
