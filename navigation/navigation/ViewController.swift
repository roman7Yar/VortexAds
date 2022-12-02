//
//  ViewController.swift
//  navigation
//
//  Created by Roman Yarmoliuk on 01.12.2022.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    override func sceneDidLoad() {
        backgroundColor = .darkGray
        
        if let particles = SKEmitterNode(fileNamed: "snow") {
            particles.position.y = 800
            particles.position.x = 200
            addChild(particles)
        }
    }
}

class SecondGameScene: SKScene {
    override func sceneDidLoad() {
        backgroundColor = .darkGray
        
        if let particles = SKEmitterNode(fileNamed: "spark") {
            particles.position.y = 600
            particles.position.x = 200
            addChild(particles)
        }
        
    }
}

class FireGameScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if let particles = SKEmitterNode(fileNamed: "fire") {
                particles.position.y = location.y
                particles.position.x = location.x
                addChild(particles)
            }
        }
    }
    
    override func sceneDidLoad() {
        backgroundColor = .darkGray

    }
}


class SecondParticlesViewController: UIViewController {
    
    @IBAction func startAnimation(_ sender: UIButton) {
        if let view = self.view as? SKView {
            let scene = SecondGameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            
            view.presentScene(scene)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class FirstParticlesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            
            view.presentScene(scene)
        }
    }
}

class FireParticlesViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let scene = FireGameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            
            view.presentScene(scene)
        }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

