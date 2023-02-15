//
//  ViewController.swift
//  Weather
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import UIKit
import PerseusDarkMode
import PerseusUISystemKit

class MainViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    deinit {
        #if DEBUG
        print("\(type(of: self)).deinit")
        #endif
    }

    class func storyboardInstance() -> MainViewController
    {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let screen = storyboard.instantiateInitialViewController() as? MainViewController

        // Do default setup; don't set any parameter causing loadView up, breaks unit tests

        screen?.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        // screen?.view.backgroundColor = UIColor.yellow

        return screen ?? MainViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard value(forKey: "storyboardIdentifier") != nil else { return }

        // Dark Mode setup
        AppearanceService.register(stakeholder: self, selector: #selector(makeUp))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            AppearanceService.processTraitCollectionDidChange(previousTraitCollection)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(theAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                          name: UIApplication.didBecomeActiveNotification,
                                          object: nil)
    }

    @objc func theAppDidBecomeActive() {

        // Update Dark Mode from Settings
        if let choice = isDarkModeSettingsChanged() {
            changeDarkModeManually(choice)
        }

        label.text = "greetings".localized_value + " ^_^ it's " + DarkMode.style.description
    }

    @objc private func makeUp() {
        self.view.backgroundColor = .perseusYellow
    }
}
