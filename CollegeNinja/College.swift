//
//  College.swift
//  CollegeNinja
//
//  Created by Tomozi Peter on 2019. 05. 23..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class College: SKNode {
    
    public static func nodeName() -> String {
        return "college"
    }
    
    override init() {
        super.init()
        
        name = College.nodeName()
        let chooseCollege = Int.random(in: 1...3)
        let collegeImage = "head\(chooseCollege)"
        let image = SKSpriteNode(imageNamed: collegeImage)
        let sizeScale = GameLogic.randomCGFloat(1.1, 1.8)
        image.xScale = sizeScale
        image.yScale = sizeScale
        addChild(image)
        
        physicsBody = SKPhysicsBody()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
