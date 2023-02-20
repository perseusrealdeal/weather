//
//  MockTimerTarget.swift
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

class TimerTargetStubbed {

    var onTickCallCount = 0
    var onTickCallClosure: () -> Void

    init(onTickCallClosure: @escaping () -> Void) {
        self.onTickCallClosure = onTickCallClosure
    }

    @objc func onTick() {
        onTickCallCount += 1

        #if DEBUG
        print(">> [\(type(of: self))]." + #function + ", onTickCallCount: \(onTickCallCount)")
        #endif

        onTickCallClosure()
    }
}
