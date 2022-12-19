//
//  ColorPikerVC.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 14.12.2022.
//

import UIKit

protocol ColorPickerDelegate: AnyObject {
    func didSelect(color: UIColor?)
}


class ColorPickerVC: UIViewController {
    
    weak var delegate: ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = UIStackView()
        
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        
        let colors: [UIColor] = [
            .black,
            .darkGray,
            .red,
            .green,
            .blue
        ]
        
        for color in colors {
            let btn = UIButton()
            btn.backgroundColor = color
            stack.addArrangedSubview(btn)
            btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        }
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    @objc func btnTapped(sender: UIButton) {
        print(sender.backgroundColor!)
        delegate?.didSelect(color: sender.backgroundColor)
        self.dismiss(animated: true)
    }
    
    deinit {
        print("Color picker deinited")
    }
}
