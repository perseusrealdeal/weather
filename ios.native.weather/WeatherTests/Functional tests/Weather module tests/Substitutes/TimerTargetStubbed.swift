//
//  MockTimerTarget.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 18.01.2022.
//

import Foundation

class TimerTargetStubbed
{
    var onTickCallCount = 0
    var onTickCallClosure: () -> Void

    init(onTickCallClosure: @escaping () -> Void)
    {
        self.onTickCallClosure = onTickCallClosure
    }

    @objc func onTick()
    {
        onTickCallCount += 1

        #if DEBUG
        print(">> [\(type(of: self))]." + #function + ", onTickCallCount: \(onTickCallCount)")
        #endif

        onTickCallClosure()
    }
}
