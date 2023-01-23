//
//  GameViewController.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 07.01.2023.
//

import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {

    var level = ""
        
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
           
            scene.scaleMode = .aspectFill
           
            scene.level = level
            
            scene.showPopUpCallBack = { (isWin) -> Void in
        
                self.gameOver(isWin)
                
            }
        
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }
    
    func gameOver(_ isWin: Bool) {
        
        let vc = PopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        
        if isWin {
            vc.message = "You win"
        } else {
            vc.message = "You lose"
        }
        
        let restartAction = vc.createButton(withTitle: "Restart") {
            self.setScene()
            self.dismiss(animated: false)
        }

        let goToMenuAction = vc.createButton(withTitle: "To menu") {
            self.presentedViewController?.dismiss(animated: false)
            self.dismiss(animated: false)
        }
        
        vc.addAction(restartAction)
        vc.addAction(goToMenuAction)
        
        
        self.present(vc, animated: false)
        
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
