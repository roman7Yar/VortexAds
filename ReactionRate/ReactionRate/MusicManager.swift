//
//  MusicManager.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 28.12.2022.
//

import AVFoundation

class MusicManager {
    
    private init() {}
    static let shared = MusicManager()
    
   
    var isOn = true {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("changeVolume"), object: isOn)
        }
    }
    
    func playSound(with id: Int) {
        if isOn {
            AudioServicesPlaySystemSound(SystemSoundID(id))
        }
    }
    
    
}
