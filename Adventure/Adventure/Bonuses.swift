//
//  Bonuses.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 18.01.2023.
//

import SpriteKit

struct Bonuses {
    static func createHeart(for hero: SKSpriteNode, node: SKNode, speed: CGFloat) {
        
        let bonusTexture = SKTexture(imageNamed: "heart")
        let bonus = SKSpriteNode(texture: bonusTexture)
        
        bonus.xScale = 0.05
        bonus.yScale = 0.05
        
        let minEnemyPositionX = hero.position.x
        let maxEnemyPositionX = hero.position.x + 350
       
        bonus.position.y = hero.position.y + 300
        bonus.position.x = .random(in: minEnemyPositionX...maxEnemyPositionX)
        bonus.zPosition = 1
        
        bonus.physicsBody = .init(SKPhysicsBody(circleOfRadius: bonus.size.width / 3))
        bonus.physicsBody?.affectedByGravity = false
        
        bonus.physicsBody?.categoryBitMask = BitMasks.heart
        
        let action = SKAction.moveBy(x: .zero, y: -500, duration: speed)
    
        bonus.run(action)
        
        node.addChild(bonus)
    }
    
    static func createCup(on ground: SKSpriteNode, node: SKNode, probability: Int) {
        
        let arrOfBool = Array(1...probability).map { i in
            if i == 1 { return true }
            return false
        }
        let isTrue = arrOfBool.randomElement()!
        
        let bonusTexture = SKTexture(imageNamed: "cup")
        let bonus = SKSpriteNode(texture: bonusTexture)
        
//        bonus.xScale = 0.05
//        bonus.yScale = 0.05
        
        let minBonusPositionX = ground.position.x - ground.size.width / 2 //+ bonus.size.width * 3
        let maxBonusPositionX = ground.position.x + ground.size.width / 2 //- bonus.size.width * 3
        
        bonus.position.y = ground.position.y + bonus.size.height
        bonus.position.x = .random(in: minBonusPositionX...maxBonusPositionX)
        bonus.zPosition = 1

        bonus.physicsBody = .init(SKPhysicsBody(rectangleOf: bonus.size))
        bonus.physicsBody?.affectedByGravity = false
        
        bonus.physicsBody?.categoryBitMask = BitMasks.bonus
        bonus.physicsBody?.collisionBitMask = 0
                
        let up = SKAction.moveBy(x: .zero, y: 30, duration: 1)
        let down = SKAction.moveBy(x: .zero, y: -30, duration: 1)
        let sqns = SKAction.sequence([up, down])
    
        bonus.run(.repeatForever(sqns))

        if isTrue {
            node.addChild(bonus)
        }
        
    }
    
}
