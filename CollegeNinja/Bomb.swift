//
//  Bomb.swift
//  CollegeNinja
//
//  Created by Tomozi Peter on 2019. 05. 23..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class Bomb: SKNode {
    
    public static func nodeName() -> String {
        return "bomb"
    }
    
    override init() {
        super.init()
        name = Bomb.nodeName()

        let image = SKSpriteNode(imageNamed: "bomb")
        let sizeScale = GameLogic.randomCGFloat(1.2, 1.8)
        image.xScale = sizeScale
        image.yScale = sizeScale
        addChild(image)
        
        physicsBody = SKPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
