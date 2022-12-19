//
//  PopUpViewController.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 10.12.2022.
//

import UIKit

protocol AlertViewControllerDelegate: AnyObject {
    func resetGame()
    var gameStartedTime: TimeInterval { get set }
    
}


class PopUpViewController: UIViewController {
    
    weak var delegate: AlertViewControllerDelegate?
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame.size = CGSize(width: 100, height: 20)
        titleLabel.text = "Game Over"
        titleLabel.font = .systemFont(ofSize: 30)

        return titleLabel
    }()
    
    var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.frame.size = CGSize(width: 300, height: 40)
        messageLabel.text = "Message"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 25)
        return messageLabel
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 80, height: 40)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var popUpView: UIView = {
        let popUpView = UIView()
        popUpView.backgroundColor = .white
        popUpView.layer.opacity = 0.95

        return popUpView
    }()

    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 30
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(popUpView)
        popUpView.addSubview(stackView)
        
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: popUpView.heightAnchor, constant: -20).isActive = true
        

    }
    @objc func buttonAction() {
        delegate?.resetGame()
        delegate?.gameStartedTime = Date().timeIntervalSinceReferenceDate
        self.dismiss(animated: false)
    }
 
    deinit {
        print("PopUP deinited")
    }
    
}
