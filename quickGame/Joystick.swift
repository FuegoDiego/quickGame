//
//  Joystick.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/28/26.
//

import Foundation
import SpriteKit

class Joystick: SKNode{
    var base: SKShapeNode!
    var knob: SKShapeNode!
    var radius: CGFloat = 60
    
    
    override init() {
        
        super.init()
        
        base = SKShapeNode(circleOfRadius: radius)
        base.fillColor = .gray
        base.alpha = 0.4
        base.zPosition = 1
        knob = SKShapeNode(circleOfRadius: radius / 2)
        knob.fillColor = .white
        knob.zPosition = 2
        addChild(base)
        addChild(knob)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveJoystick(to position: CGPoint) {
        let distance = sqrt(position.x * position.x + position.y * position.y)
        if distance <= radius{
            knob.position = position
        } else {
            let angle = atan2(position.y, position.x)
            knob.position = CGPoint(
                x: cos(angle) * radius,
                y: sin(angle) * radius
            )
        }
        
    }
}
