//
//  JokeManager.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 01.02.2023.
//

import Foundation


protocol JokeManagerDelegate {
    func didUpdateJoke(with joke: String)
    func didUpdateJokeWithSearch(with joke: JokeModel)
    func didFailWithError(error: Error)
} // TODO:  remove delegates | remove all old network logic

struct JokeModel {
        let total: Int
        let result: [Result]
}

struct JokeData: Codable {
    let total: Int
    let result: [Result]
}

struct Result: Codable {
    let categories: [String]
    let created_at: String
    let id: String
    let value: String
}

struct StandartJokeModel {
    let categories: [String]
    let created_at: String
    let id: String
    let value: String

}


struct JokeManager {
    
    var delegate: JokeManagerDelegate?
    
    var urlStr: String
    
    var searchCallBack: ((_ model: JokeModel) -> ())?
    var standartCallBack: ((_ model: StandartJokeModel) -> ())?


    enum FetchingType {
        case search, standart
    }
    
    func fetch(type: FetchingType) {
        guard let url = URL(string: urlStr) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do { // TODO: enum , switch, and models as much as needed | callbacks against delegates
                switch type {
                case .search:
                    let jsonResult = try JSONDecoder().decode(JokeData.self, from: data)
                    let model = JokeModel(total: jsonResult.total, result: jsonResult.result)
                    searchCallBack?(model)
                case .standart:
                    let jsonResult = try JSONDecoder().decode(Result.self, from: data)
                    let model = StandartJokeModel(categories: jsonResult.categories,
                                                  created_at: jsonResult.created_at,
                                                  id: jsonResult.id,
                                                  value: jsonResult.value)
                    standartCallBack?(model)
                }
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

    
    func fetchJoke() {
        let urlString = urlStr
        performRequest(with : urlString)
    } // TODO: remake Network completely
    

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                   
                    let joke = self.parseJSON(safeData)
                    self.delegate?.didUpdateJoke(with: joke)
                
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ jokeData: Data) -> String {
        let decoder = JSONDecoder()

        do {
            let decodeData = try decoder.decode(Result.self, from: jokeData)
            let joke = decodeData.value
            return joke

        } catch {
            delegate?.didFailWithError(error: error)
            return "nil"
        }
    }
    
    //MARK: - Search 
    
    func fetchJokeWithSearch() {
        let urlString = urlStr
        performRequestWithSearch(with: urlString)
    }

    func performRequestWithSearch(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                   
                    let joke = self.parseJSONWithSearch(safeData)
                    self.delegate?.didUpdateJokeWithSearch(with: joke!)
                
                }
            }
            task.resume()
        }
    }

    func parseJSONWithSearch(_ jokeData: Data) -> JokeModel? {
        let decoder = JSONDecoder()

        do {
            let decodeData = try decoder.decode(JokeData.self, from: jokeData)
            let joke = JokeModel(total: decodeData.total, result: decodeData.result)
            return joke

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}

