//
//  UserDefaultsManager.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 10.02.2023.
//

import Foundation

class UserDefaultsManager {
    
    private let dataKey = "data"
    
    lazy var someData: Data = {
        
        var someData = Data()
        
        do {
            let resultData = Result(categories: [""], created_at: "", id: "", value: "")
            
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(resultData)
            someData = data
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
        
        return someData
    }()
    
        private init() {
            UserDefaults.standard.register(defaults: [
                dataKey : someData
            ])
        }
    
    
    static var shared = UserDefaultsManager()
    
    
    func getData() -> [Result]? {
        var result = [Result(categories: [""], created_at: "", id: "", value: "")]
        if let data = UserDefaults.standard.data(forKey: dataKey) {
            do {
                let decoder = JSONDecoder()

                let decodeData = try decoder.decode([Result].self, from: data)
                
                result = decodeData
            } catch {
                print("Unable to Decode Data (\(error))")
            }
        }
        return result
    }
    
    func setData(dataToSave: Result) {
        var arrayDataToSave = [dataToSave]

        if let data = UserDefaults.standard.data(forKey: dataKey) {
            
            do {
                let decoder = JSONDecoder()

                let decodeData = try decoder.decode([Result].self, from: data)
               
                arrayDataToSave += decodeData

                decodeData.forEach { element in
                    if element.id == dataToSave.id {
                        arrayDataToSave.removeFirst()
                    }
                 }
                
            } catch {
                print("Unable to Decode Data (\(error))")
            }
            
        }

        do {
            let encoder = JSONEncoder()

            let data = try encoder.encode(arrayDataToSave)

            UserDefaults.standard.set(data, forKey: dataKey)

        } catch {
            print("Unable to Encode Array of Data (\(error))")
        }

    }
    
    func removeFromData(data: Result) {
        var count = 0
        var savedData = UserDefaultsManager.shared.getData()
        savedData?.forEach({ item in
           
            if item.id == data.id {
                savedData?.remove(at: count)
            }
            
            count += 1
            
        })
        
        do {
            let encoder = JSONEncoder()

            let data = try encoder.encode(savedData)

            UserDefaults.standard.set(data, forKey: "notes")
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
}
