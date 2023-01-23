//
//  MenuViewController.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 19.01.2023.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    
    let vc = UIAlertController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(view.frame)

        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .fill
        stackView.spacing = 60
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let playButton = createButton(title: "Easy", color: .red)
        let colorPickerButton = createButton(title: "Medium", color: .orange)
        let infoButton = createButton(title: "Hard", color: .systemTeal)
                
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
       
        let vc = GameViewController()
        vc.level = sender.currentTitle!
        vc.view.frame = view.frame
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        
    }

}
