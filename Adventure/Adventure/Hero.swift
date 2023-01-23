//
//  Hero.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 14.01.2023.
//

import SpriteKit

class Hero: SKSpriteNode {
    
    var isRight = true
    
    enum State {

        case left, right, stay
        
        var texturesBaseName: String {
            switch self {
            case .left:
                return "left"
            case .right:
                return "right"
            case .stay:
                return "stay"
            }
        }
        
        var textures: [SKTexture] {
            let name = self.texturesBaseName
            let textureArray = Array(1...8).map { int in
                SKTexture(imageNamed: "\(name)\(int)")
            }
            return textureArray
        }
        
    }
    
    private let movementKey = "movement"
    private let movementSpeed: CGFloat = 250
    
    init() {
        let texture = SKTexture(imageNamed: "right2")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.physicsBody = .init(circleOfRadius: self.size.width / 3)
        self.physicsBody?.mass = 1
        
        self.physicsBody?.categoryBitMask = BitMasks.hero
        self.physicsBody?.collisionBitMask = BitMasks.ground //(BitMasks.ground | BitMasks.bonus | BitMasks.enemy | BitMasks.heart | BitMasks.spikes)
        self.physicsBody?.contactTestBitMask = (BitMasks.bonus | BitMasks.enemy | BitMasks.heart | BitMasks.spikes)
       
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = .zero
        
        self.zPosition = 1
        
        self.stay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveLeft() {
        self.animateTextures(forState: .left)
        
        let moveAction = SKAction.moveBy(x: -movementSpeed, y: 0, duration: 1)
        let repeatForEver = SKAction.repeatForever(moveAction)
        let seq = SKAction.sequence([moveAction, repeatForEver])
        
        self.run(seq, withKey: movementKey)
        
    }
    
    func moveRight() {
        self.animateTextures(forState: .right)
        
        let moveAction = SKAction.moveBy(x: movementSpeed, y: 0, duration: 1)
        let repeatForEver = SKAction.repeatForever(moveAction)
        let seq = SKAction.sequence([moveAction, repeatForEver])
        
        self.run(seq, withKey: movementKey)

    }
    
    func stay() {
        self.animateTextures(forState: .stay)
        
        self.removeAction(forKey: movementKey)
    }
    
    private func animateTextures(forState state: State) {
        
        var textures = state.textures
        
        var duration = 0.1
        
        if state == .stay {
            duration = 0.4
            textures = self.isRight ?
            [SKTexture(imageNamed: "right6"), SKTexture(imageNamed: "right5")] :
            [SKTexture(imageNamed: "left6"), SKTexture(imageNamed: "left5")]
            
        } else {
            duration = 0.1
        }
        
        let animateAction = SKAction.animate(
            with: textures,
            timePerFrame: duration,
            resize: true,
            restore: false)
        
        self.run(.repeatForever(animateAction))
    }
    
    func jump() {
            self.physicsBody?.applyImpulse(.init(dx: 0, dy: 500))
    }
    
}
