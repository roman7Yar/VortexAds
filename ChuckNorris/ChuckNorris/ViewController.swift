//
//  ViewController.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 01.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    let stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stack.axis = .vertical
        stack.distribution  = .fillEqually
        stack.alignment = .center
        stack.spacing = 0
        
        view.addSubview(stack)
        
        getRequest()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 48).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = true
        
    }
    
    func getRequest() {
        let categoryURL = "https://api.chucknorris.io/jokes/categories"
        guard let url = URL (string: categoryURL) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
                self.didUpdateMenu(with: json as! [String])
            } catch {
                print (error)
            }
        }.resume()
        
    }
    
    func createButton(title: String) -> UIButton {
        
        let button = UIButton()
        
        button.frame.size = CGSize(width: 100, height: 25)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        var url = ""
        
        if sender.currentTitle! == "random" {
            url = "https://api.chucknorris.io/jokes/random"
        } else {
            url = "https://api.chucknorris.io/jokes/random?category=\(sender.currentTitle!)"
        }
        
        let vc = ChuckNorrisVC()
        
        vc.url = url
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        
    }
    
    
    
    
    func didUpdateMenu(with categories: [String]) {
        DispatchQueue.main.async {
                        
            var buttons = [UIButton]()
            
            buttons.append(self.createButton(title: "random"))
            
            categories.forEach { title in
                buttons.append(self.createButton(title: title))
            }
            
            buttons.forEach { button in
                self.stack.addArrangedSubview(button)
            }
            
        }
    }
    
}

