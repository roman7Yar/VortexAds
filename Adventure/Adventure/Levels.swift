//
//  Levels.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 22.01.2023.
//

import Foundation

enum Level {
    case easy, medium, hard
    var setup: SetupLevel {
        switch self {
        case .easy:
            return SetupLevel(groundSpasing: 0,
                              jumps: 1,
                              cupsGoal: 3,
                              cupProbability: 5,
                              itemSpeed: 2,
                              rocketSpeed: 2.2)
        case .medium:
            return SetupLevel(groundSpasing: 50,
                              jumps: 1,
                              cupsGoal: 4,
                              cupProbability: 6,
                              itemSpeed: 1.8,
                              rocketSpeed: 2)
        case .hard:
            return SetupLevel(groundSpasing: 150,
                              jumps: 2,
                              cupsGoal: 5,
                              cupProbability: 7,
                              itemSpeed: 1.7,
                              rocketSpeed: 1.5)
        }
    }
    
}

struct SetupLevel {
  
    lazy var groundSpasing: CGFloat = 0
    lazy var jumps: Int = 0
    lazy var cupsGoal: Int = 0
    lazy var cupProbability: Int = 0
    lazy var itemSpeed: TimeInterval = 0
    lazy var rocketSpeed: TimeInterval = 0
    
}
