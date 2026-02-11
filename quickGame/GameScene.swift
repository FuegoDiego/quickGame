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
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var movingLeft = false
    var movingRight = false
    var ground: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        self.camera = cam
        // Left button
            leftButton = SKSpriteNode(color: .blue, size: CGSize(width: 80, height: 80))
            leftButton.alpha = 0.5
            leftButton.position = CGPoint(x: -self.size.width/2 + 100, y: -self.size.height/2 + 100)
            leftButton.zPosition = 100
            addChild(leftButton)

            // Right button
            rightButton = SKSpriteNode(color: .green, size: CGSize(width: 80, height: 80))
            rightButton.alpha = 0.5
            rightButton.position = CGPoint(x: -self.size.width/2 + 220, y: -self.size.height/2 + 100)
            rightButton.zPosition = 100
            addChild(rightButton)
        
        ground = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width * 2, height: 40))
        ground.position = CGPoint(x: 0, y: -self.size.height/2 + 20) // 20 = half of ground height
        ground.zPosition = 1
        addChild(ground)

// Add physics so ball can collide
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false 
        ground.physicsBody?.restitution = 0
    }
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
        let speed: CGFloat = 200
            if movingLeft {
                ball.position.x -= speed * CGFloat(1.0/60.0)
            }
            if movingRight {
                ball.position.x += speed * CGFloat(1.0/60.0)
            }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if leftButton.contains(location) {
                movingLeft = true
            } else if rightButton.contains(location) {
                movingRight = true
            } else {
                jump() // tap anywhere else = jump
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if leftButton.contains(location) {
                movingLeft = false
            } else if rightButton.contains(location) {
                movingRight = false
            }
        }
    }
    func reset(){
        var respawn = SKAction.move(to: CGPoint(x: CGFloat.random(in: -320...320), y: 640), duration: 2)
        ball.run(respawn)
    }
    func jump(){
        var burst = SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 1)
        ball.run(burst)
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jump()
    }*/
    
}
