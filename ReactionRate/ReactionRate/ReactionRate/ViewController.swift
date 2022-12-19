//
//  ViewController.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 06.12.2022.
//

import UIKit




class ViewController: UIViewController, ColorPickerDelegate {
    func didSelect(color: UIColor?) {
        backgroundColor = color!
    }
    var backgroundColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .fill
        stackView.spacing = 60
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let playButton = createButton(title: "Play", color: .red)
        let infoButton = createButton(title: "Rules", color: .black)
        let colorPickerButton = createButton(title: "Backgroung color", color: .darkGray)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(colorPickerButton)
        stackView.addArrangedSubview(infoButton)
        
    }
    
    func createButton(title: String, color: UIColor) -> UIButton {
        
        let button = UIButton()
        
        button.frame.size = CGSize(width: 100, height: 40)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonAction(sender: UIButton!) {
        switch sender.currentTitle {
        case "Play":
            let vc = DownTimerVC()
            vc.backgroundColor = backgroundColor
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        case "Rules":
            let vc = PopUpViewController()
            vc.titleLabel.text = "How to play"
            vc.messageLabel.text = "click on the circle as fast as possible and see your reaction rate"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)            
        default:
            let vc = ColorPickerVC()
            vc.delegate = self
            present(vc, animated: true)
        }
        
        
    }
    
    
}




