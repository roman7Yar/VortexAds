//
//  MenuManager.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 01.02.2023.
//

import Foundation

protocol JokeManagerDelegate {
    func didUpdateJoke(with joke: String)
    func didFailWithError(error: Error)
}

struct JokeManager {
    
    var delegate: JokeManagerDelegate?
    
    let urlStr: String

    
    func fetchJoke() {
        let urlString = urlStr
        performRequest(with : urlString)
    }

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

    func parseJSON(_ jokeData: Data) -> String{
        let decoder = JSONDecoder()

        do {
            let decodeData = try decoder.decode(JokeData.self, from: jokeData)
            let joke = decodeData.value
            return joke

        } catch {
            delegate?.didFailWithError(error: error)
            return "nil"
        }
    }

}
