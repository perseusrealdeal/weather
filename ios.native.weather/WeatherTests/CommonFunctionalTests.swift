//
//  FunctionalTest.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7529.
//
//  Copyright © 7529 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import XCTest

// Preparing Error Messages

extension String {

    var notNil: String { return "\(self) is Nil." }

    func notEqual(actual: String, with expected: String?) -> String {
        return "\(self) is \(actual), but not equal to \(String(describing: expected))."
    }
}

// First things first...

class CommonFunctionalTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func test_the_first_success() { XCTAssertTrue(true, "It's done!") }
}
