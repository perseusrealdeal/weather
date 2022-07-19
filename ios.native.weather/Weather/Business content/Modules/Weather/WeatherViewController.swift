//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 06.12.2021.
//

import UIKit
import PerseusDarkMode

// MARK: - WeatherViewController Class

class WeatherViewController: UIViewController {
    // MARK: - Difficult Dependencies

    private let notificationCenter: NotificationCenterProtocol
    private let geoService: GeoLocationServiceProtocol

    #if DEBUG
    var stubbedView: WeatherLayoutViewProtocol
    #endif

    // MARK: - View Controller Life Circle Methods

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ notificationCenter: NotificationCenterProtocol = Settings.notificationCenter,
         _ geoService: GeoLocationServiceProtocol = GeoLocationReceiver.shared) {
        #if DEBUG
        print(">> [\(type(of: self))].init")
        #endif

        self.notificationCenter = notificationCenter
        self.geoService = geoService

        #if DEBUG
        self.stubbedView = WeatherLayoutView()
        #endif

        super.init(nibName: nil, bundle: nil)

        self.notificationCenter.addObserver(self,
                                            selector: #selector(theAppDidFinishLaunching),
                                            name: UIApplication.didFinishLaunchingNotification,
                                            object: nil)
    }

    override func loadView() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        #if DEBUG
        view = stubbedView as? UIView
        #else
        view = WeatherLayoutView()
        #endif
    }

    override func viewDidLoad() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        // Do any additional setup after loading the view.

        // Dark Mode setup
        AppearanceService.register(stakeholder: self, selector: #selector(makeUp))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            AppearanceService.processTraitCollectionDidChange(previousTraitCollection)
        }
    }

    override func viewDidLayoutSubviews() {
        let currentOrientation: NSLayoutConstraint.Axis =
            UIDevice.current.orientation.isLandscape ? .horizontal : .vertical

        guard let view = view as? WeatherLayoutViewProtocol else { return }

        view.updateLayoutOrientationIfNeeded(for: currentOrientation)

        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        super.viewWillAppear(animated)

        notificationCenter.addObserver(self,
                                       selector: #selector(theAppDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(theAppDidEnterBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        super.viewWillDisappear(animated)

        notificationCenter.removeObserver(self,
                                          name: UIApplication.didBecomeActiveNotification,
                                          object: nil)

        notificationCenter.removeObserver(self,
                                          name: UIApplication.didEnterBackgroundNotification,
                                          object: nil)
    }

    // MARK: - The App's Major Life Time Events

    @objc func theAppDidBecomeActive() {
        #if DEBUG
        print("-----------------------------------")
        print(">> [\(type(of: self))]." + #function)
        #endif

        // Update Dark Mode from Settings
        if let choice = isDarkModeSettingsChanged() {
            changeDarkModeManually(choice)
        }
        print("greetings".localized_value + " ^_^ it's " + DarkMode.Style.description)

        // Start activites
        guard let view = view as? WeatherLayoutViewProtocol else { return }

        view.startActivities()
    }

    @objc func theAppDidEnterBackground() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        guard let view = view as? WeatherLayoutViewProtocol else { return }

        view.stopActivities()
    }

    @objc func theAppDidFinishLaunching() {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif

        geoService.requestLocationDataAccess()
    }

    @objc private func makeUp() {
        self.view.backgroundColor = .systemYellow_Adapted
    }

    // MARK: - Other Methods (Not Business Logic Related)

    deinit {
        #if DEBUG
        print(">> [\(type(of: self))].deinit")
        #endif
    }
}
