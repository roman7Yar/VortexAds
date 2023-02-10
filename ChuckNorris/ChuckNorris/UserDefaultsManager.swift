//
//  UserDefaultsManager.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 10.02.2023.
//

import Foundation

class UserDefaultsManager {
    
    
    static let shared = UserDefaultsManager()
    
    func getData() -> Data {
        UserDefaults.standard.data(forKey: "data")!
    }
    
    func setData(data: Data) {
        UserDefaults.standard.set(data, forKey: "data")
    }
    

}
