//
//  ViewController.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 28.11.2021.
//

import UIKit

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
        screen?.view.backgroundColor = UIColor.yellow

        return screen ?? MainViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard value(forKey: "storyboardIdentifier") != nil else { return }
        // Do any additional setup after loading the view.

        label.text = "greetings".localized_value
    }
}
