//
//  GameScene.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 21.02.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var restartCallBack: (() -> ())?
    var updateScoreCallBack: ((Int, Bool) -> ())?
    
    var contactAllowed = false
    var touchAllowed = true
    
    var arrivedOnStation = false {
     
        didSet {
            guard oldValue != arrivedOnStation else {
                return
            }
            if arrivedOnStation {
                updateLevel()
                stationsSetter.createStation(on: self, currentLevel: currentLevel)
                touchAllowed = true
            }
        }
    }
    
    let stationsSetter = StationsSetter()
    
    
    var player = Player()
  
    var levelLabel: SKLabelNode = {
        var label = SKLabelNode()
        label.fontSize = 50
        label.fontColor = .white
        label.text = "Level 1"
        return label
    }()
   
    let cam = SKCameraNode()
    
    var currentLevel = Level.level1
    var score = -1 {
        didSet {
            updateScoreCallBack!(score, false)
        }
    }

    override func didMove(to view: SKView) {
     
        backgroundColor = .black
        physicsWorld.contactDelegate = self

        self.camera = cam

        let firstStation = stationsSetter.createFirstStation()
        addChild(firstStation)
        
        levelLabel.position.x = firstStation.position.x
        levelLabel.position.y = firstStation.frame.maxY + 20
        
        addChild(cam)
        addChild(levelLabel)
        addChild(player)
       
        player.position = .zero
        
        StationsSetter.arrOfPoints = [.zero]

        for _ in 1...2 {
            stationsSetter.createStation(on: self, currentLevel: currentLevel)
        }
        
        StationsSetter.arrOfPoints.removeFirst()
       
        clearNodes()

        SoundManager.shared.playBackgroundMusic(filename: "spaceBG")
    }
    
    
    func updateLevel() {
        let level = {
            switch self.score {
            case -1...5:
                return Level.level1
            case 6...10:
                return Level.level2
            case 11...20:
                return Level.level3
            case 21...30:
                return Level.level4
            case 31...40:
                return Level.level5
            default:
                return Level.infinity
            }
        }()
       
        if currentLevel != level {
          
            currentLevel = level
            
            let levelLabelCopy = levelLabel.copy() as! SKLabelNode
            
            levelLabelCopy.text = currentLevel.rawValue
            
            levelLabelCopy.position.x = StationsSetter.arrOfPoints.last!.x
            levelLabelCopy.position.y = StationsSetter.arrOfPoints.last!.y - 120//station.frame.height
            
            addChild(levelLabelCopy)
            
            if currentLevel == .level5 {
                player.playerSpeed *= 1.5
                let copy = levelLabel.copy() as! SKLabelNode
                copy.position.x = StationsSetter.arrOfPoints.first!.x
                copy.position.y = StationsSetter.arrOfPoints.first!.y - 120//station.frame.height
                copy.text = "Speed 1.5x"
                addChild(copy)
            }
        }
    }
   
    func clearNodes() {
        let action = SKAction.run {
            for node in self.children {
                if node.position.y < self.player.position.y - 300 {
                    node.removeFromParent()
                }
            }
        }
        let sqns = SKAction.sequence([.wait(forDuration: 0.5), action])
        self.run(.repeatForever(sqns))
    }

    func checkIfLanded() {
        guard player.destination.y - player.position.y < 0.01 else { return }
        score += 1
        arrivedOnStation = true
        
        player.rotatePlayer(destinationPoint: StationsSetter.arrOfPoints.first!)
        removeAsteroids()
    }
    
    func removeAsteroids() {
        let nodes = scene!.nodes(at: player.position)
       
        nodes.forEach { node in
            guard node.name == "station" else { return }
            node.removeAllChildren()
        }

    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first!.location(in: view)
        guard touchPoint.y > 80 + view!.safeAreaInsets.top else { return }
        guard touchAllowed else { return }
        player.previousPosition = player.position
        player.moveToNextStation(at: StationsSetter.arrOfPoints.removeFirst())
        arrivedOnStation = false
        contactAllowed = true
        touchAllowed = false
    }
       
    override func update(_ currentTime: TimeInterval) {
        if !arrivedOnStation {
            checkIfLanded()
        }
        let xPoint = (player.position.x + StationsSetter.arrOfPoints.first!.x) / 2
        let yPoint = player.position.y + 200
        cam.run(.move(to: CGPoint(x: xPoint, y: yPoint), duration: 0.25))
    }
    
    func showGameOver() {
        let overNode = OverNode(size: self.frame.size, score: score) {
            self.restartCallBack!()
            VibrationManager.shared.vibrate(for: .tap)
        }
        cam.addChild(overNode)
        SoundManager.shared.playSoundEffect(filename: "damage")
        VibrationManager.shared.vibrate(for: .damage)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard contactAllowed else {
            return
        }
        
        var body = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask == BitMask.player {
            body = contact.bodyB
        } else {
            body = contact.bodyA
        }
        
        if body.categoryBitMask == BitMask.bonus {
            player.shields += 1
            SoundManager.shared.playSoundEffect(filename: "bonus")
        } else {
            VibrationManager.shared.vibrate(for: .damage)
            if player.shields > 0 {
                player.damage()
                player.moveBack()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.touchAllowed = true
                }
            } else {
                player.isPaused = true
                showGameOver()
                updateScoreCallBack!(score, true)
                UserDefaultsManager.shared.score = score
            }
        }
        
        contactAllowed = false
    }
    
}
