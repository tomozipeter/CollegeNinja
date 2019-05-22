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
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
            if score > bestScore {
                bestScore = score
            }
        }
    }
    var bestScore: Int = 0 {
        didSet {
            bestscoreLabel.text = "best: \(bestScore)"
        }
    }
    var gameState: GameState = .waitToStart {
        didSet {
            switch gameState {
            case .processGame: startGame()
            case .waitToStart: endGame()
            }
        }
    }

    func startGame() {
        promptLabel.isHidden = true
        gameStartLabel.isHidden = true
        score = 0
    }
    func endGame() {
        promptLabel.isHidden = false
        gameStartLabel.isHidden = false
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
    }
    
    override func didSimulatePhysics() {
        //Tells your app to peform any necessary logic after physics simulations are performed.
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


