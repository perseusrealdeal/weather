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
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        super.init(nibName: nil, bundle: nil)
        
        let nCenter = Settings.notificationCenter
        
        nCenter.addObserver(self,
                            selector: #selector(theAppDidFinishLaunching),
                            name: UIApplication.didFinishLaunchingNotification,
                            object: nil)
    }
    
    override func loadView()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        view = WeatherLayoutView()
    }
    
    override func viewDidLoad()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
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
        
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        let nCenter = Settings.notificationCenter
        
        nCenter.addObserver(self,
                            selector: #selector(theAppDidBecomeActive),
                            name: UIApplication.didBecomeActiveNotification,
                            object: nil)
        
        nCenter.addObserver(self,
                            selector: #selector(theAppDidEnterBackground),
                            name: UIApplication.didEnterBackgroundNotification,
                            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let notificationCenter = Settings.notificationCenter
        
        notificationCenter.removeObserver(self,
                                          name: UIApplication.didBecomeActiveNotification,
                                          object: nil)
        
        notificationCenter.removeObserver(self,
                                          name: UIApplication.didEnterBackgroundNotification,
                                          object: nil)
    }
    
    // MARK: - Business Logic Related Methods
    
    @objc func theAppDidBecomeActive()
    {
        #if DEBUG
        print("-----------------------------------")
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard let view = view as? WeatherLayoutView else { return }
        
        view.startActivities()
    }
    
    @objc func theAppDidEnterBackground()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        guard let view = view as? WeatherLayoutView else { return }
        
        view.stopActivities()
    }
    
    @objc func theAppDidFinishLaunching()
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        GeoLocationReceiver.shared.requestLocationDataAccess()
    }
    
    // MARK: - Other Methods (Not Business Logic Related)
    
    deinit
    {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
