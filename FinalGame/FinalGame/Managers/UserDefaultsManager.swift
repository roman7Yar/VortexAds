//
//  UserDefaultsManager.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 25.02.2023.
//

import Foundation
class UserDefaultsManager {
    
    private let vibrationKey = "vibration"
    private let soundKey = "sound"
    private let musicKey = "music"
    private let scoreKey = "score"
    private let volumeKey = "volume"
    private let musikVolumeKey = "musikVolume"
    
    private init() {
        UserDefaults.standard.register(defaults: [
            vibrationKey : true,
            soundKey : true,
            scoreKey : 0,
            volumeKey : Float(0.5)
        ])
    }
    
    static let shared = UserDefaultsManager()
    
    var score: Int {
        get { UserDefaults.standard.integer(forKey: scoreKey) }
        set {
            if score < newValue {
                UserDefaults.standard.set(newValue, forKey: scoreKey)
            }
        }
    }
   
    var vibration: Bool {
        get { return UserDefaults.standard.bool(forKey: vibrationKey) }
        set { UserDefaults.standard.set(newValue, forKey: vibrationKey) }
    }
    
    var sound: Bool {
        get { return UserDefaults.standard.bool(forKey: soundKey) }
        set { UserDefaults.standard.set(newValue, forKey: soundKey) }
    }
   
    var music: Bool {
        get { return UserDefaults.standard.bool(forKey: musicKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: musicKey)
            if newValue {
                SoundManager.shared.playBackgroundMusic(filename: "spaceBG")
            } else {
                SoundManager.shared.stopBackgroundMusic()
            }
        }
    }

    
    var soundsVolume: Float {
        get { return UserDefaults.standard.float(forKey: volumeKey) }
        set { UserDefaults.standard.set(newValue, forKey: volumeKey) }
    }
    
    var musicVolume: Float {
        get { return UserDefaults.standard.float(forKey: musikVolumeKey) }
        set { UserDefaults.standard.set(newValue, forKey: musikVolumeKey) }
    }

    


}
