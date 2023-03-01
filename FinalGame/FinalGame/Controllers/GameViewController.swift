//
//  GameViewController.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 21.02.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = true
        view = skView

        setScene()
    }
    
    
    func setScene() {
        
        if let view = self.view as! SKView? {
            
            let scene = GameScene(size: self.view.bounds.size)
                        
            scene.restartCallBack = {
                self.setScene()
            }
            
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            
            setupSettingsView()

            let scoreLabel = setupScoreLabel()
           
            scene.updateScoreCallBack = { score, removeLabel in
                scoreLabel.text = "Score: \(score)"
                if removeLabel {
                    scoreLabel.removeFromSuperview()
                }
            }
            
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }
    func setupScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = .init(name: "HelveticaNeue-UltraLight", size: 30)
        label.textColor = .white
        label.text = "Score: 0"
        label.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return label
    }
    
    func setupSettingsView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))

        let image = UIImage(named: "settings")
        let settingsImgView = UIImageView(image: image)
        settingsImgView.isUserInteractionEnabled = true
        settingsImgView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(settingsImgView)
        
        settingsImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

    }
    
    @objc func imageTapped() {
        SoundManager.shared.playSoundEffect(filename: "click")
        let vc = SettingsVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
