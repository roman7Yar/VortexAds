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
    
    let volumeImageView = VolumeImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let volumeView = volumeImageView.volumeImage
        
        view.addSubview(volumeView)
        
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        volumeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true

        let stack = UIStackView()
        
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        
        let colors: [UIColor] = [
            .black,
            .systemMint,
            .systemIndigo,
            UIColor(red: 0.17, green: 0.63, blue: 0.57, alpha: 1),
            .purple
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeVol), name: Notification.Name("changeVolume"), object: nil)
    }
    
    @objc func changeVol(_ notification: NSNotification) {
        guard let name = notification.object as? Bool else {
            print("not Bool")
            return
        }
        volumeImageView.volumeImage.image = name ? volumeImageView.volumeOn : volumeImageView.volumeOff
    }
    
    @objc func btnTapped(sender: UIButton) {
        
        let color = hexStringFromColor(color: sender.backgroundColor!)
        
        UserDefaultsManager.shared.setBackground(value: color)
        
        delegate?.didSelect(color: sender.backgroundColor)
        self.dismiss(animated: true)
        
    }
    
    func hexStringFromColor(color: UIColor) -> String {
       
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
       
        if color == UIColor.black {
            
            r = 0
            g = 0
            b = 0
            
        } else if color == UIColor.darkGray {
           
            r = 0.3
            g = 0.3
            b = 0.3
            
        } else {
            
            let components = color.cgColor.components
            
            r = components?[0] ?? 0.0
            g = components?[1] ?? 0.0
            b = components?[2] ?? 0.0
            
        }
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }

    
    deinit {
        print("Color picker deinited")
    }
}
