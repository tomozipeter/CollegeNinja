//
//  TrailLine.swift
//  CollegeNinja
//
//  Created by Tomozi Peter on 2019. 05. 28..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import SpriteKit

class TrailLine: SKShapeNode {
    
    var shrinkTimer = Timer()
    
    init(startPosition:CGPoint, lastPosition:CGPoint, width:CGFloat, color:UIColor) {
        super.init()
        
        let path = CGMutablePath()
        path.move(to: startPosition)
        path.addLine(to: lastPosition)
        self.path = path
        
        lineWidth = width
        strokeColor = color
        
        shrinkTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: {_ in
            self.lineWidth -= 1
            if self.lineWidth == 0 {
                self.shrinkTimer.invalidate()
                self.removeFromParent()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
