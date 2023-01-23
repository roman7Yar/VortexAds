//
//  GameScene.swift
//  Adventure
//
//  Created by Roman Yarmoliuk on 07.01.2023.
//
import UIKit
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var level = ""
    
    lazy var currentLevel: SetupLevel = {
        let enumLevel: Level = {
            var enumLevel = Level.self
            switch level {
            case "Easy":
                return enumLevel.easy
            case "Medium":
                return enumLevel.medium
            case "Hard":
                return enumLevel.hard
            default:
                return enumLevel.easy
            }
        }()
        let currentLevel = enumLevel.setup

        return currentLevel

    }()
    
    var showPopUpCallBack: ((_ isWin: Bool) -> ())?

    var isWin = true {
        didSet {
            heartsLabel.text = ""
            cupsLabel.text = ""
            showPopUpCallBack!(isWin)
        }
    }
    
    lazy var setter = Ground(ground: ground, positionY: bg.position.y - bg.size.height / 4)
   
    lazy var jumps = currentLevel.jumps
   
    var hearts = 3 {
        didSet {
            
            heartsLabel.text = ""
           
            if hearts == 0 {
                isWin = false
            }
            for _ in 0..<hearts {
                heartsLabel.text! += "♥️"
            }
        }
    }
    var cups = 0 {
        didSet {
            if cups < currentLevel.cupsGoal {
                cupsLabel.text = "🏆 \(cups)/\(currentLevel.cupsGoal)"
            } else {
                isWin = true
            }
        }
    }
    
    let cam = SKCameraNode()
    let topSpacing: CGFloat = 8
    
    lazy var heartsLabel: UILabel = {
        let heartsLabel = UILabel()

        heartsLabel.font = .systemFont(ofSize: 30)
        
        view?.addSubview(heartsLabel)
        
        heartsLabel.translatesAutoresizingMaskIntoConstraints = false
        heartsLabel.topAnchor.constraint(equalTo: view!.topAnchor, constant: topSpacing).isActive = true
        heartsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        heartsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        heartsLabel.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true

        
        return heartsLabel
    }()
    
    lazy var cupsLabel: UILabel = {
        let cupsLabel = UILabel()
        
        cupsLabel.font = .systemFont(ofSize: 30)
        
        view?.addSubview(cupsLabel)
        cupsLabel.translatesAutoresizingMaskIntoConstraints = false
        cupsLabel.topAnchor.constraint(equalTo: view!.topAnchor, constant: topSpacing).isActive = true
        cupsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        cupsLabel.trailingAnchor.constraint(equalTo: view!.trailingAnchor).isActive = true

        
        return cupsLabel
    }()
    
    //MARK: - Texture
    var bgTexture: SKTexture!
    
    
    //MARK: - Sprite Nodes
    lazy var moveLeft: SKSpriteNode = {
        let moveLeftTexture = SKTexture(imageNamed: "moveLeft")
        let moveLeft = SKSpriteNode(texture: moveLeftTexture)
        
        moveLeft.position.x = -(view?.frame.width)! * (5 / 12)
        moveLeft.position.y = -(view?.frame.height)! / 3
        moveLeft.zPosition = 2
        return moveLeft
    }()
    
    lazy var moveRight: SKSpriteNode = {
        var moveRightTexture = SKTexture(imageNamed: "moveRight")
        var moveRight = SKSpriteNode(texture: moveRightTexture)
        
        moveRight.position.x = -(view?.frame.width)! / 4
        moveRight.position.y = -(view?.frame.height)! / 3
        moveRight.zPosition = 2
        return moveRight
    }()
    
    lazy var lineNode: SKSpriteNode = {
        var lineTexture = SKTexture(imageNamed: "line")
        var lineNode = SKSpriteNode(texture: lineTexture)
        
        lineNode.xScale = 0.15
        lineNode.yScale = 0.15

        lineNode.position.x = -(view?.frame.width)! / 3
        lineNode.position.y = -(view?.frame.height)! / 3
        lineNode.zPosition = 2
        return lineNode
    }()
    
    var bg = SKSpriteNode()
    var ground = SKSpriteNode()
    var hero = Hero()
    
    
    //MARK: - Objects
    var buttonObject = SKNode()
    var bgObject = SKNode()
    var groundObject = SKNode()
    var heroObject = SKNode()
    var enemyObject = SKNode()
    var bonusObject = SKNode()

    //MARK: - didMove
    override func didMove(to view: SKView) {
        
        self.camera = cam
        
        createObjects()
        createGame()
        removeNodes()
        
        cupsLabel.text = "🏆 0/\(currentLevel.cupsGoal)"
        heartsLabel.text = "♥️♥️♥️"
        
        cam.setScale(1.3)

        addChild(cam)

        cam.addChild(moveLeft)
        cam.addChild(moveRight)
        cam.addChild(lineNode)
        
        physicsWorld.contactDelegate = self

    }
   
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(groundObject)
        self.addChild(heroObject)
        self.addChild(buttonObject)
        self.addChild(enemyObject)
        self.addChild(bonusObject)
    }
    
    func removeNodes() {

        let action = SKAction.run {
            
            let bgBorder = self.hero.position.x - self.bg.size.width
            let groundBorder = self.hero.position.x - self.ground.size.width * 2
            
            for node in self.bgObject.children {
                if node.position.x < bgBorder {
                    node.removeFromParent()
                }
            }
            
            for node in self.groundObject.children {
                if node.position.x < groundBorder {
                    node.removeFromParent()
                }
            }
            
            for node in self.enemyObject.children {
                if node.position.x < groundBorder {
                    node.removeFromParent()
                }
            }
        }
        
        let sqns = SKAction.sequence([.wait(forDuration: 5), action])
        self.run(.repeatForever(sqns))
        
    }
    
    func createGame() {
        createBg(at: size.width + 2000)
//        setter.createGround(point: CGPoint(x: bg.position.x - bg.size.width / 3, y: bg.position.y - bg.size.height / 3), node: groundObject)
        createGround(point: CGPoint(x: bg.position.x - bg.size.width / 3, y: bg.position.y - bg.size.height / 3))
        createHero()
        createItem()
    }
    
    func createBg(at positionX: Double) {
        bgTexture = SKTexture (imageNamed: "bg")
        bg = SKSpriteNode (texture: bgTexture)
        bg.position.x = positionX
        bg.position.y = size.height + 100
        bg.size.height = self.frame.height * 3
        bg.zPosition = -1

        bgObject.addChild(bg)
        
    }
    
    func createItem() {
        var isBomb = true
        
        let arrOfItems = Array(1...10).map { i in
            if i == 1 { return false }
            return true
        }
        let action = SKAction.run {
            isBomb ?
            Enemy.addBomb(for: self.hero,
                          node: self.enemyObject,
                          speed: self.currentLevel.itemSpeed)
            : Bonuses.createHeart(for: self.hero,
                                  node: self.bonusObject,
                                  speed: self.currentLevel.itemSpeed)
        }
        let random = SKAction.run {
            isBomb = arrOfItems.randomElement()!
        }
        let sqns = SKAction.sequence([.wait(forDuration: 3), random, action])
        enemyObject.run(.repeatForever(sqns))
    }
    
    func createGround(point: CGPoint) {
        let groundTexture = SKTexture(imageNamed: "ground")
        let hights = Array(-10...1).map { i in
            CGFloat(i * 10)
        }
        let randomHight = hights.randomElement()!

        ground = SKSpriteNode(texture: groundTexture)
        ground.scale(to: CGSize(width: frame.width, height: 50))
        ground.position.x = point.x + currentLevel.groundSpasing
        
        if bg.frame.contains(CGPoint(x: bg.position.x, y: point.y - frame.height / 2)) {
            ground.position.y = point.y + randomHight
        } else {
            ground.position.y = point.y - randomHight
        }
       
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.categoryBitMask = BitMasks.ground
        ground.physicsBody?.contactTestBitMask = (BitMasks.hero | BitMasks.enemy)
        
        groundObject.addChild(ground)
    }
    
    
    
    
    func addHero(atPosition position: CGPoint) {
        
        self.hero.position = position
        
        self.hero.xScale = 0.15
        self.hero.yScale = 0.15
                
        hero.stay()

        heroObject.addChild(self.hero)
    }
    
    func createHero() {
        addHero(atPosition: CGPoint(x: ground.position.x, y: bg.position.y))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first!.location(in: view)
        
        if touchPoint.x > frame.width / 2 {
            if jumps > 0 {
                hero.jump()
                jumps -= 1
            }
           
            physicsWorld.gravity.dy = -5
            
        } else {
            
            if touchPoint.x > frame.width / 6 {
                moveRight.alpha = 0.5
                hero.moveRight()
                hero.isRight = true
            } else if touchPoint.x < frame.width / 6 {
                moveLeft.alpha = 0.5
                hero.moveLeft()
                hero.isRight = false
            }
            
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first!.location(in: view)
                
        if touchPoint.x < frame.width / 2 {

            moveLeft.alpha = 1
            moveRight.alpha = 1
            hero.stay()

        }
        
        if touchPoint.x > frame.width / 2 {
            physicsWorld.gravity.dy = -10
        }
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        
        cam.run(.move(to: CGPoint(x: hero.position.x + 100,
                                  y: hero.position.y + 120), duration: 0.25))
        
        if bg.position.x <= cam.position.x {
            createBg(at: cam.position.x + bg.size.width - 5)
        }
        
        if hero.position.y < bg.frame.minY {
            isWin = false
        }
        
        if ground.position.x - ground.size.width / 2 <= hero.position.x {
            createGround(point: CGPoint(x: ground.position.x + ground.size.width, y: ground.position.y))
//            setter.createGround(point: CGPoint(x: ground.position.x + ground.size.width, y: ground.position.y), node: groundObject)
            
            Enemy.addSpikes(on: ground, node: enemyObject)
            Enemy.addRocket(on: ground, node: enemyObject, speed: currentLevel.rocketSpeed)
            Bonuses.createCup(on: ground, node: bonusObject, probability: currentLevel.cupProbability)
        }
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body: SKPhysicsBody
        var mainBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask == BitMasks.hero || contact.bodyA.categoryBitMask == BitMasks.ground {
            mainBody = contact.bodyA
            body = contact.bodyB
        } else {
            mainBody = contact.bodyB
            body = contact.bodyA
        }
        
        if mainBody.categoryBitMask == BitMasks.ground {
            switch body.categoryBitMask {
            case BitMasks.hero:
//                print("ground + hero")
                jumps = currentLevel.jumps
            case BitMasks.enemy:
//                print("ground + enemy")

                body.node?.removeFromParent()
            default: return
            }
        } else {
            switch body.categoryBitMask {
            case BitMasks.bonus:
                cups += 1
                body.node?.removeFromParent()
            case BitMasks.enemy:
                damageHero(body: body, remove: true)
            case BitMasks.spikes:
                damageHero(body: body, remove: false)
            case BitMasks.heart:
                if hearts < 3 {
                    hearts += 1
                }
                body.node?.removeFromParent()
            default: return
            }
        }
    }
    
    func damageHero(body: SKPhysicsBody, remove: Bool) {
        if hearts > 0 {
            hearts -= 1
        }
        
        let redSqns = SKAction.sequence([.colorize(with: .red, colorBlendFactor: 0.7, duration: 0),
                                         .wait(forDuration: 0.5),
                                         .colorize(withColorBlendFactor: 0, duration: 0)])
       
        hero.run(redSqns)

        let sqns = SKAction.sequence([.run { body.categoryBitMask = .zero },
                                      .wait(forDuration: 0.5),
                                      .run { body.categoryBitMask = BitMasks.spikes }])
      
        body.node?.run(sqns)
        
        if remove {
            body.node?.removeFromParent()
        }
    }
}

