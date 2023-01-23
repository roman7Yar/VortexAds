//
//  Enemies.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 17.01.2023.
//

import SpriteKit

var isRocketAble = false

struct Enemy {
    
    
    
    static func addSpikes(on ground: SKSpriteNode, node: SKNode) {
        let enemyTexture = SKTexture(imageNamed: "spikes")
        let enemy = SKSpriteNode(texture: enemyTexture)
        
        enemy.xScale = 0.3
        enemy.yScale = 0.3
        
        let minEnemyPositionX = ground.position.x - ground.size.width / 2 + enemy.size.width * 3
        let maxEnemyPositionX = ground.position.x + ground.size.width / 2 - enemy.size.width * 3
        
        enemy.position.y = ground.position.y + enemy.size.height
        enemy.position.x = .random(in: minEnemyPositionX...maxEnemyPositionX)
        enemy.zPosition = 1
        
        enemy.physicsBody = .init(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        
        enemy.physicsBody?.categoryBitMask = BitMasks.spikes
        
        node.addChild(enemy)
        
    }
    
    static func addRocket(on ground: SKSpriteNode, node: SKNode, speed: CGFloat) {
         
        if isRocketAble {
            
            let enemyTexture = SKTexture(imageNamed: "rocket")
            let enemy = SKSpriteNode(texture: enemyTexture)
            
            enemy.xScale = 0.05
            enemy.yScale = 0.05
            
            let minEnemyPositionY = ground.position.y + ground.size.height / 2 + enemy.size.height
            let maxEnemyPositionY = ground.position.y + ground.size.height / 2 + enemy.size.height * 6
            
            enemy.position.x = ground.position.x + ground.size.width
            enemy.position.y = .random(in: minEnemyPositionY...maxEnemyPositionY)
            enemy.zPosition = 1
            
            enemy.physicsBody = .init(rectangleOf: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            
            enemy.physicsBody?.categoryBitMask = BitMasks.enemy
            enemy.physicsBody?.collisionBitMask = 0
            let action = SKAction.moveBy(x: -360, y: .zero, duration: speed)
            enemy.run(.repeatForever(action))
            
            node.addChild(enemy)
        }
        
        isRocketAble.toggle()
    }
    
    static func addBomb(for hero: SKSpriteNode, node: SKNode, speed: CGFloat) {

        let enemyTexture = SKTexture(imageNamed: "bomb")
        let enemy = SKSpriteNode(texture: enemyTexture)
        
        enemy.xScale = 0.2
        enemy.yScale = 0.2
        
        let minEnemyPositionX = hero.position.x
        let maxEnemyPositionX = hero.position.x + 350
        enemy.position.y = hero.position.y + 500
        enemy.position.x = .random(in: minEnemyPositionX...maxEnemyPositionX)
        enemy.zPosition = 1
        
        enemy.physicsBody = .init(SKPhysicsBody(circleOfRadius: enemy.size.width / 3))
        enemy.physicsBody?.affectedByGravity = false
        
        enemy.physicsBody?.categoryBitMask = BitMasks.enemy
        enemy.physicsBody?.collisionBitMask = 0

        
        let action = SKAction.moveBy(x: .zero, y: -800, duration: speed)
        
        
        
        enemy.run(action)
        
        node.addChild(enemy)
        
        
        
    }
}

