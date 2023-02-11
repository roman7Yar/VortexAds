//
//  ChuckNorrisVC.swift
//  ChuckNorris
//
//  Created by Roman Yarmoliuk on 02.02.2023.
//

import UIKit

class ChuckNorrisVC: UIViewController {
    
    var url = ""
    
    let edgeSpacing: CGFloat = 12
    
    var isSaved = false {
        didSet {
            let imageName = isSaved ? "bookmark.fill" : "bookmark"
            image = UIImage(systemName: imageName)!
            navigationItem.rightBarButtonItem?.image = image
        }
    }
    
    var image = UIImage(systemName: "bookmark")!
    
    lazy var jokeManager = JokeManager(urlStr: url)
    
    var data = Result(categories: [""], created_at: "", id: "", value: "")

    
    let jokeLabel: UILabel = {
        let label = UILabel()
       
        label.text = "wait for download"
        
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 28)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.frame.size = CGSize(width: 100, height: 20)

        label.text = "date: "
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.frame.size = CGSize(width: 100, height: 20)
       
        label.text = "category: none"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    
    let chuckImage: UIImageView = {
        let image = UIImage(named: "chuck")
        let chuckImageView = UIImageView(image: image!)
        return chuckImageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveTapped))
        view?.backgroundColor = .systemBackground
        
        jokeManager.standartCallBack = { (model) -> Void in
            self.didUpdateJoke(with: model)
        }

        jokeManager.fetch(type: .standart)
        
        view.addSubview(chuckImage)
        view.addSubview(jokeLabel)
        view.addSubview(dateLabel)
        view.addSubview(categoryLabel)

                
        chuckImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chuckImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edgeSpacing),
            chuckImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            jokeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jokeLabel.topAnchor.constraint(equalTo: chuckImage.bottomAnchor, constant: 16),
            jokeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeSpacing),
            jokeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeSpacing),
            jokeLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeSpacing),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgeSpacing)
        ])
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeSpacing),
            categoryLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgeSpacing)
        ])

    }
    
   @objc func saveTapped() {
       
       if isSaved {
           UserDefaultsManager.shared.removeFromData(data: data)
       } else {
           UserDefaultsManager.shared.setData(dataToSave: data)
       }
      
       isSaved.toggle()
       navigationItem.rightBarButtonItem?.image = image

   }
    
    func didUpdateJoke(with model: Result) {
        DispatchQueue.main.async {
            self.jokeLabel.text = model.value
            self.dateLabel.text = String(model.created_at.prefix(10))
            self.categoryLabel.text = {
                if model.categories.isEmpty {
                    return "category: none"
                } else {
                    return "category: \(model.categories[0])"
                }
            }()
            self.data = model
            
            let dataToCheck = UserDefaultsManager.shared.getData()!
            
            self.isSaved = false

            dataToCheck.forEach { item in
                if item.id == self.data.id {
                    self.isSaved = true
                }
            }
            self.navigationItem.rightBarButtonItem?.image = self.image
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        jokeLabel.text = ""
        jokeManager.fetch(type: .standart)
    }
    
}

