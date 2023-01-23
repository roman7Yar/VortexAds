//
//  PopUpViewController.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 22.01.2023.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var message = ""
            
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame.size = CGSize(width: 100, height: 20)
        titleLabel.text = "Game Over"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 30)
        
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.frame.size = CGSize(width: 300, height: 40)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 25)
        return messageLabel
    }()
   
    var popUpView: UIView = {
        let popUpView = UIView()
       
        popUpView.backgroundColor = .cyan
        popUpView.layer.opacity = 0.95
        
        return popUpView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 30
        
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.messageLabel)
        return stackView
    }()
    
    var actions = [() -> Void]()
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        for button in buttons {
                button.addTarget(self, action: #selector(someFunc(sender:)), for: .touchUpInside)
        }
                
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        
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
    
    func createButton(withTitle title: String, closure: @escaping () -> Void) -> (() -> Void)  {
        
        let button = UIButton()

        button.frame.size = CGSize(width: 80, height: 40)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle(title, for: .normal)
        
        buttons.append(button)
        addButtonToStack(stack: stackView, button: button)
        return closure
    }
    
    func addAction(_ action: @escaping () -> Void) {
        actions.append(action)
    }
    
    
    private func addButtonToStack(stack: UIStackView, button: UIButton) {
        
        stack.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    @objc func someFunc(sender: UIButton) {
        if sender.currentTitle! == "Restart" {
            actions[0]()
        } else {
            actions[1]()
        }
    }
    
    deinit {
        print("PopUP deinited")
    }
    
}
