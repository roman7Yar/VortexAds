//
//  ChuckNorrisVC.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 02.02.2023.
//

import UIKit

class ChuckNorrisVC: UIViewController {
    
    var url = ""
    
    
    let jokeLabel = UILabel()
    
    let chuckImage: UIImageView = {
        let image = UIImage(named: "chuck")
        let chuckImageView = UIImageView(image: image!)
        return chuckImageView
    }()
    
    lazy var jokeManager = JokeManager(urlStr: url)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = .white
        
        jokeManager.delegate = self
        jokeManager.fetchJoke()
        
        
        view.addSubview(chuckImage)
        view.addSubview(jokeLabel)

        jokeLabel.text = "wait for download"
        
        jokeLabel.numberOfLines = 0
        jokeLabel.textAlignment = .center
        jokeLabel.font = .systemFont(ofSize: 28)
        jokeLabel.textColor = .black
        chuckImage.scalesLargeContentImage = true
        
        chuckImage.translatesAutoresizingMaskIntoConstraints = false
        
        chuckImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        chuckImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        chuckImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        jokeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jokeLabel.topAnchor.constraint(equalTo: chuckImage.bottomAnchor, constant: 16).isActive = true
        jokeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        
        createBackButton()
    }
    
    func createBackButton() {
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 60, height: 35))
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true

    }
    
    @objc func backButtonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        jokeLabel.text = "wait for download"

        jokeManager.fetchJoke()
    }
    
}

extension ChuckNorrisVC: JokeManagerDelegate {
    
    func didUpdateJoke(with joke: String) {
    
        DispatchQueue.main.async {
            self.jokeLabel.text = joke
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}
