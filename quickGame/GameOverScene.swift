//
//  Joystick.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/28/26.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black   // Black screen

        // Optional: Add a label
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 50
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 100
        addChild(label)
    }
}
