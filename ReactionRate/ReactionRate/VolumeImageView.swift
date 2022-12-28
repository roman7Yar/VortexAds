//
//  VolumeImageView.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 27.12.2022.
//

import UIKit

class VolumeImageView: UIImageView {
    
    let volumeOff = UIImage(systemName: "volume.slash.fill")
    let volumeOn = UIImage(systemName: "volume.3.fill")
    
    var isOn = MusicManager.shared.isOn 
    
    lazy var volumeImage: UIImageView = {
        let volumeImage = UIImageView()
        volumeImage.image = isOn ? volumeOn : volumeOff
        volumeImage.frame.size = CGSize(width: 100, height: 100)
        volumeImage.tintColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        
        volumeImage.addGestureRecognizer(tapGesture)
        volumeImage.isUserInteractionEnabled = true
        return volumeImage
    }()
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if ((gesture.view as? UIImageView) != nil) {
            
            let animations = {
                self.volumeImage.frame.size.height /= 1.3
                self.volumeImage.frame.size.width /= 1.3
            }
            
            UIView.animate(withDuration: 0.2, animations: animations)
            
            MusicManager.shared.isOn.toggle()
                        
        }
    }
    
}

