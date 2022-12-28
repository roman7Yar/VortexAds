//
//  ViewController.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 06.12.2022.
//

import UIKit

class ViewController: UIViewController, ColorPickerDelegate {
    
    lazy var backgroundColor = hexStringToUIColor(hex: UserDefaultsManager.shared.getBackground()!)
    
    var volumeImageView = VolumeImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
       
        let volumeView = volumeImageView.volumeImage
        
        view.addSubview(volumeView)
        
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        volumeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
       
        
        let stackView = UIStackView()
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .fill
        stackView.spacing = 60
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let playButton = createButton(title: "Play", color: .red)
        let colorPickerButton = createButton(title: "Backgroung color", color: .orange)
        let infoButton = createButton(title: "Rules", color: .systemTeal)
                
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(colorPickerButton)
        stackView.addArrangedSubview(infoButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeVol), name: Notification.Name("changeVolume"), object: nil)
        
    }
    
    @objc func changeVol(_ notification: NSNotification) {
        guard let name = notification.object as? Bool else {
            print("not Bool")
            return
        }
        volumeImageView.volumeImage.image = name ? volumeImageView.volumeOn : volumeImageView.volumeOff
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
            MusicManager.shared.playSound(with: Sound.toStart.id)
            let vc = GameVC()
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
            vc.view.backgroundColor = backgroundColor
            present(vc, animated: true)
        }
        
        
    }
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func didSelect(color: UIColor?) {
        backgroundColor = color!
        view.backgroundColor = backgroundColor
    }
    
    
}


enum Sound {
    case toMoveView
    case toStart
    case toDissmiss
    case forGood
    case forNorm
    case forBad
    
    var id: Int {
        switch self {
        case .toMoveView: return 1004
        case .toStart: return 1030
        case .toDissmiss: return 1001
        case .forGood: return 1021
        case .forNorm: return 1027
        case .forBad: return 1024
        }
    }
}

