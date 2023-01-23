//
//  GroundSetter.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 18.01.2023.
//

import SpriteKit

struct Ground {
    var ground: SKSpriteNode
    let positionY: CGFloat
    
    mutating func createGround(point: CGPoint, node: SKNode) {
        let groundTexture = SKTexture(imageNamed: "ground")
        let hights = Array(-10...1).map { i in
            CGFloat(i * 10)
        }
        let randomHight = hights.randomElement()!

        ground = SKSpriteNode(texture: groundTexture)
        ground.scale(to: CGSize(width: node.frame.width, height: 50))
        ground.position.x = point.x
        if positionY - point.y + randomHight > 200 {
            ground.position.y = point.y + randomHight
        } else {
            ground.position.y = point.y - randomHight
        }
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = BitMasks.ground
        

        node.addChild(ground)
    }
}
