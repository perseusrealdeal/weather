//
//  LocalizationExtentions.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 09.12.2021.
//

import Foundation

extension String {
    var localized_value: String {
        return NSLocalizedString(self, comment: "")
    }
}
