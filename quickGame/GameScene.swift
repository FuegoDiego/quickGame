//
//  GameScene.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/20/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ball : SKSpriteNode!
    let cam = SKCameraNode()
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        self.camera = cam
    }
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
    }
    func reset(){
        var respawn = SKAction.move(to: CGPoint(x: CGFloat.random(in: -320...320), y: 640), duration: 2)
        ball.run(respawn)
    }
    func jump(){
        var burst = SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 1)
        ball.run(burst)
    }
    
    
}
