//
//  GameLogic.swift
//  CollegeNinja
//
//  Created by Tomozi Peter on 2019. 05. 22..
//  Copyright © 2019. Tomozi Peter. All rights reserved.
//

import UIKit

struct BitMask {
    static let Ball: UInt32 = 0x1 << 0
    static let Racket: UInt32 = 0x1 << 1
    //static let Wall: UInt32 = 0x1 << 2
}

enum GameState {
    case processGame
    case waitToStart
}

class GameLogic {
    
    static public func randomCGFloat(_ lowerLimit: CGFloat, _ upperLimit: CGFloat) -> CGFloat {
        //return CGFloat.random(in: Double(lowerLimit) ... Double(upperLimit))
        return lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
    }
    
    static public func getVector(withSpeed speed:CGFloat,withAngle angle:CGFloat) -> CGVector {
        let dx = speed * cos(angle)
        let dy = speed * sin(angle)
        return CGVector(dx: dx, dy: dy)
    }
    
}
