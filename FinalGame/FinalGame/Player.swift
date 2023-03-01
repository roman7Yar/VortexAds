//
//  Player.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 27.02.2023.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var destination = CGPoint.zero
    var previousPosition = CGPoint.zero
    
    var playerSpeed = CGFloat(800) // per second
    
    var shields = 0 {
        didSet {
            shieldsLabel.text = "\(shields)"
        }
    }
    
    var shieldsLabel: SKLabelNode = {
        var label = SKLabelNode()
        label.fontName = "Helvetica Neue"
        label.fontSize = 20
        label.fontColor = .white
        label.zPosition = 10
        return label
    }()
    
    init() {
        let texture = SKTexture(imageNamed: "rocket")
        let size = CGFloat(36)
        super.init(texture: texture, color: .clear, size: CGSize(width: size, height: size))
        
        self.name = "player"
        self.zPosition = 1
        self.addChild(shieldsLabel)
        
        shieldsLabel.position.y = self.position.y - self.size.height / 4

        self.physicsBody = .init(circleOfRadius: size / 2)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMask.player
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitMask.enemy | BitMask.bonus

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotatePlayer(destinationPoint: CGPoint) {
        let dx = destinationPoint.x - self.position.x
        let dy = destinationPoint.y - self.position.y
        let angle = atan2(dy, dx) - .pi / 2
        self.run(.rotate(toAngle: angle, duration: 0.2))
    }
    
    func moveToNextStation(at point: CGPoint) {
        let duration = calculateTime(player: self.position, destination: point)
        self.run(.move(to: point, duration: duration))
        destination = point
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: "jump")
    }
    
    func moveBack() {
        self.run(.move(to: previousPosition, duration: 0.2))
        StationsSetter.arrOfPoints.insert(destination, at: 0)
    }
    
    func damage() {
        let redSqns = SKAction.sequence([.colorize(with: .red, colorBlendFactor: 0.7, duration: 0),
                                         .wait(forDuration: 0.3),
                                         .colorize(withColorBlendFactor: 0, duration: 0)])
       
        self.run(redSqns)
        shields -= 1
        SoundManager.shared.playSoundEffect(filename: "damage")
    }
   
    func calculateTime(player: CGPoint, destination: CGPoint) -> TimeInterval {
        let x = abs(destination.x - player.x)
        let y = abs(destination.y - player.y)
        let distance = sqrt((x * x) + (y * y))
        
        return distance / playerSpeed
    }

}
