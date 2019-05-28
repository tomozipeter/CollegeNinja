//
//  GameScene.swift
//  CollegeNinja
//
//  Created by Tomozi Peter on 2019. 05. 20..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    lazy var promptLabel: SKLabelNode = {
        return childNode(withName: "gamenamelabel") as! SKLabelNode
    }()
    lazy var gameStartLabel: SKLabelNode = {
       return childNode(withName: "gameStart") as! SKLabelNode
    }()
    lazy var scoreLabel: SKLabelNode = {
        return childNode(withName: "scorelabel") as! SKLabelNode
    }()
    lazy var bestscoreLabel: SKLabelNode = {
       return childNode(withName: "bestlabel") as! SKLabelNode
    }()
    lazy var explodeOverlay: SKShapeNode = {
       let shapenode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
       shapenode.fillColor = UIColor.white
       shapenode.alpha = 0
       return shapenode
    }()
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
            if score > bestScore {
                bestScore = score
            }
            if score.isMultiple(of: 5) {
                gameLevel += 1
            }
        }
    }
    var bestScore: Int = 0 {
        didSet {
            bestscoreLabel.text = "best: \(bestScore)"
        }
    }
    let maxMissedCollege: Int = 10
    var missedCollege: Int = 0
    var gameLevel:Int = 1
    
    var gameState: GameState = .waitToStart {
        didSet {
            switch gameState {
            case .processGame: startGame()
            case .waitToStart: waitForGame()
            case .endingGame:  endGame()
            }
        }
    }
    var gameTimer = Timer()

    func startGame() {
        promptLabel.isHidden = true
        gameStartLabel.isHidden = true
        score = 0
        missedCollege = 0
        gameLevel = 1
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in self.nextGameStep() })
    }
    func waitForGame() {
        promptLabel.isHidden = false
        promptLabel.setScale(1.0)
        gameStartLabel.isHidden = false
    }
    func endGame() {
        gameTimer.invalidate()
        promptLabel.setScale(0.0)
        promptLabel.isHidden = false
        let showLabel = SKAction.scaleX(to: 1.0, duration: 1.5)
        let endGame = SKAction.run {
            self.gameState = .waitToStart
            for node in self.children {
                if (node.name == Bomb.nodeName()) ||
                    (node.name == College.nodeName()) {
                    node.removeFromParent()
                }
            }
        }
        promptLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                           showLabel,
                                           SKAction.wait(forDuration: 2.0),
                                           endGame]))
    }
    func bombExplode(_ bomb:Bomb) {
        for case let college as College in children {
            college.removeFromParent()
        }
        for case let abomb as Bomb in children {
            abomb.isPaused = true
            abomb.removeAllActions()
            abomb.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            abomb.physicsBody?.angularVelocity = 0
            abomb.physicsBody?.isDynamic = false
            abomb.physicsBody?.affectedByGravity = false
        }

        
        explode(bomb.position)
        explodeOverlay.run(
            SKAction.repeat(
                SKAction.sequence([
                    SKAction.fadeAlpha(to: 1, duration: 0.1),
                    SKAction.wait(forDuration: 0.2),
                    SKAction.fadeAlpha(to: 0, duration: 0.1)
                    ]), count:2))
        
    }
    func explode(_ position:CGPoint) {
        if let emitter = SKEmitterNode(fileNamed: "Bombexplode.sks") {
            emitter.position = position
            addChild(emitter)
        }
    }
    func nextGameStep() {
        if gameState == .waitToStart { return }
        
        //0.one,1.more,else none
        let heads = Int.random(in: 0...3)
        print(heads)
        switch heads {
        case 0: createHeads(1)
        case 1:
            
            let multipleHead = Int.random(in: 1...gameLevel)
            createHeads(multipleHead)
        case 2: createBomb()
        default: return
        }
    }
    let underScreen: CGFloat = -100.0
    func getStartPoint() -> CGPoint {
        let emptyZone:CGFloat = 50.0
        //let underScreen: CGFloat = -100.0
        return CGPoint(x: GameLogic.randomCGFloat(emptyZone, size.width-emptyZone), y: underScreen)
    }

    func createBomb() {
        let bomb = Bomb()
        bomb.position = getStartPoint()
        addChild(bomb)
        
        let moving = GameLogic.getVelocity()
        bomb.physicsBody?.velocity.dy = moving.dy
        bomb.physicsBody?.angularVelocity = moving.dx
        let maxAngle = size.width/4.0
        if bomb.position.x <= size.width/2.0 {
            //left to right
            bomb.physicsBody?.velocity.dx = GameLogic.randomCGFloat(0, maxAngle)
        } else {
            //right to left
            bomb.physicsBody?.velocity.dx = GameLogic.randomCGFloat(-maxAngle, 0)
        }
    }
    func createHeads(_ heads:Int) {
        for _ in 1...heads {
            let college = College()
            college.position = getStartPoint()
            addChild(college)
            
            let moving = GameLogic.getVelocity()
            college.physicsBody?.velocity.dy = moving.dy
            college.physicsBody?.angularVelocity = moving.dx
            let maxAngle = size.width/4.0
            if college.position.x <= size.width/2.0 {
                //left to right
                college.physicsBody?.velocity.dx = GameLogic.randomCGFloat(0, maxAngle)
            } else {
                //right to left
                college.physicsBody?.velocity.dx = GameLogic.randomCGFloat(-maxAngle, 0)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        addChild(explodeOverlay)
    }
    
    override func didSimulatePhysics() {
        //Tells your app to peform any necessary logic after physics simulations are performed.
        for case let college as College in children {
            if college.position.y < underScreen {
               missedCollege += 1
                if missedCollege == maxMissedCollege {
                    gameState = .endingGame
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState != .processGame {
            return
        }
        for touche in touches {
            let location = touche.location(in: self)
            let previous = touche.previousLocation(in: self)
            
            for node in nodes(at: location) {
                if node is College {
                    explode(node.position)
                    node.removeFromParent()
                    score += 1
                } else if node is Bomb {
                    bombExplode(node as! Bomb)
                    gameState = .endingGame
                }
            }
            let line = TrailLine(startPosition: previous , lastPosition: location, width: 10.0 , color: UIColor.black)
            addChild(line)
            //line.run(SKAction.sequence([
            //    SKAction.fadeAlpha(to: 0, duration: 0.3),
            //    SKAction.removeFromParent()
            //    ]))

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .waitToStart {
            gameState = .processGame
            return
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


