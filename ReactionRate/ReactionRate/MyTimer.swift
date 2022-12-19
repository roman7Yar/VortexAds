//
//  MyTimer.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 18.12.2022.
//

import Foundation

class MyTimer {
    var timer: Timer?
    var count = 0.0
    
    func start() -> Void {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.count = self.count + 0.1
        }
    }
    
    func stop() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
}
