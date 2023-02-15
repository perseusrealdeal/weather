//
//  Result.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 15/02/2023.
//  Copyright © 2023 Perseusrealdeal. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}
