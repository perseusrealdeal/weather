//
//  LocalizationExtentions.swift
//  Weather
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation

extension String {
    var localized_value: String {
        return NSLocalizedString(self, comment: "")
    }
}
