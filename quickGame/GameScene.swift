//
//  GameScene.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/20/26.
//

import SpriteKit
struct PhysicsCategory {
    static let ball: UInt32 = 0x1 << 0
    static let deathBlock: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2  // optional if you have ground
}
class GameScene: SKScene, SKPhysicsContactDelegate {

    var ball: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    let cam = SKCameraNode()
    var movingLeft = false
    var movingRight = false

    override func didMove(to view: SKView) {

        // Ball
        ball = childNode(withName: "ball") as? SKSpriteNode
        //ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 2
        //addChild(ball)

        // Ground
        let g = children.compactMap { $0 as? SKSpriteNode }
            .filter { $0.name == "ground" }
        for ground in g{
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
            //addChild(ground)
        }
        

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        
        let deaths = children.compactMap { $0 as? SKSpriteNode }.filter { $0.name == "death" }
        for block in deaths {
            block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.categoryBitMask = 2
            block.physicsBody?.contactTestBitMask = 1
            block.physicsBody?.collisionBitMask = 0
        }

        
        // Left button
        leftButton = SKSpriteNode(color: .blue, size: CGSize(width: 80, height: 80))
        leftButton.alpha = 0.5
        leftButton.position = CGPoint(x: -size.width/2 + 100, y: -size.height/2 + 100)
        leftButton.zPosition = 100
        addChild(leftButton)

        addChild(cam)
        self.camera = cam
        cam.setScale(2.0)
        
        
        // Right button
        rightButton = SKSpriteNode(color: .green, size: CGSize(width: 80, height: 80))
        rightButton.alpha = 0.5
        rightButton.position = CGPoint(x: -size.width/2 + 220, y: -size.height/2 + 100)
        rightButton.zPosition = 100
        addChild(rightButton)
    }
    func startLeft() { movingLeft = true }        // CHANGED
    func startRight() { movingRight = true }      // CHANGED
    func stopMoving() { movingLeft = false; movingRight = false }
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
        let speed: CGFloat = 500
        let acceleration: CGFloat = 50

        guard let ballBody = ball.physicsBody else { return }

            if movingRight {
                ballBody.velocity.dx = min(ballBody.velocity.dx + acceleration, speed)
            } else if movingLeft {
                ballBody.velocity.dx = max(ballBody.velocity.dx - acceleration, -speed)
            } else {
                // slow down
                ballBody.velocity.dx *= 0.999
            }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for touch in touches {
            let location = touch.location(in: self)

            if leftButton.contains(location) {
                movingLeft = true
            } else if rightButton.contains(location) {
                movingRight = true
            } else {
                jump()
            }
        }*/
        for touch in touches {
                let location = touch.location(in: self.camera!) // CHANGED: check in camera coords

                if leftButton.contains(location) {
                    startLeft()
                } else if rightButton.contains(location) {
                    startRight()
                } else {
                    jump()
                }
            }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for touch in touches {
            let location = touch.location(in: self)

            if leftButton.contains(location) {
                movingLeft = false
            } else if rightButton.contains(location) {
                movingRight = false
            }
        }*/
        for touch in touches {
                let location = touch.location(in: self.camera!) // CHANGED

                if leftButton.contains(location) || rightButton.contains(location) {
                    stopMoving()
                }
            }
    }
    func didBegin(_ contact: SKPhysicsContact) {
            let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

            if mask == PhysicsCategory.ball | PhysicsCategory.deathBlock {
                goToGameOver()
            }
        }

    func goToGameOver() {
        //Make a black overlay
           let blackScreen = SKSpriteNode(color: .black, size: self.size)
           blackScreen.position = CGPoint(x: size.width/2, y: size.height/2)
           blackScreen.zPosition = 1000
           addChild(blackScreen)

           // Optional: “Game Over” label
           let label = SKLabelNode(text: "Game Over")
           label.fontSize = 50
           label.fontColor = .white
           label.position = CGPoint(x: size.width/2, y: size.height/2)
           label.zPosition = 1001
           addChild(label)

           // After short delay, remove the black screen and reset
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
               blackScreen.removeFromParent()
               label.removeFromParent()
               self?.reset()   // ← your reset function moves the ball back
           }

    }
    func reset(){
        var respawn = SKAction.move(to: CGPoint(x: CGFloat.random(in: -320...320), y: 640), duration: 2)
        ball.run(respawn)
    }
    func jump() {
        if abs(ball.physicsBody!.velocity.dy) < 0.1 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        }
    }
}
