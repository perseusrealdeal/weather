//
//  MockLocalDataSaver.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//
//  See LICENSE for details. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Weather

class LocalDataSaverStubbed: LocalDataSaverProtocol {
    var isDataEmpty = true

    func loadData() -> JSON {
        isDataEmpty ? JSON() : JSON(loadDataFromFile("defaultLocationRU", "json"))
    }

    func save(_ jsonData: JSON?) {
    }
}

private func loadDataFromFile(_ fileName: String, _ fileExtension: String) -> Data {
    guard let url = Bundle(for: LocalDataSaverStubbed.self).url(forResource: fileName,
                                                                withExtension: fileExtension),
          let data = try? Data(contentsOf: url)
    else { return Data() }

    return data
}
