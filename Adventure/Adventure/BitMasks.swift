//
//  BitMasks.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 14.01.2023.
//

import Foundation

struct BitMasks {
    static let hero: UInt32 = 1
    static let enemy: UInt32 = 2
    static let spikes: UInt32 = 4
    static let bonus: UInt32 = 8
    static let heart: UInt32 = 16
    static let ground: UInt32 = .max
}
