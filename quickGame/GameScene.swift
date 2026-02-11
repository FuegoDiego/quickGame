//
//  GameScene.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/20/26.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let ball: UInt32 = 0x1 << 0
    static let ground: UInt32 = 0x1 << 1
    static let deathBlock: UInt32 = 0x1 << 2
    static let winBox: UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ball : SKSpriteNode!
    let cam = SKCameraNode()
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var movingLeft = false
    var movingRight = false
    var ground: SKSpriteNode!
    var deathBlock: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask =
    PhysicsCategory.deathBlock | PhysicsCategory.winBox
        ball.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        addChild(cam)
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
        ground.position = CGPoint(x: 0, y: -self.size.height/2 + 20)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)

// Add physics so ball can collide
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        ground.position = CGPoint(x: 0, y: -self.size.height/2 + ground.size.height/2)
        ground.size = CGSize(width: self.size.width, height: 40)

        self.physicsWorld.contactDelegate = self
        addDeathBlocks()

        let winBox = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
        winBox.position = CGPoint(x: 500, y: 300) // adjust to your desired location
        winBox.physicsBody = SKPhysicsBody(rectangleOf: winBox.size)
        winBox.physicsBody?.isDynamic = false
        winBox.physicsBody?.categoryBitMask = PhysicsCategory.winBox
        winBox.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        winBox.physicsBody?.collisionBitMask = 0
        addChild(winBox)
    }
    override func update(_ currentTime: TimeInterval) {
        cam.position = ball.position
        let horizontalSpeed: CGFloat = 200
            if movingLeft {
                ball.physicsBody?.velocity.dx = -horizontalSpeed
            } else if movingRight {
                ball.physicsBody?.velocity.dx = horizontalSpeed
            } else {
                // Stop horizontal movement when no button is pressed
                ball.physicsBody?.velocity.dx = 0
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
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if contactMask == PhysicsCategory.ball | PhysicsCategory.deathBlock {
            gameOver()
        }

        if contactMask == PhysicsCategory.ball | PhysicsCategory.winBox {
            gameWin()
        }
    }
    func gameOver() {
        // Show a game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y)
        gameOverLabel.zPosition = 200
        addChild(gameOverLabel)
    
        // Wait 2 seconds, then reset the scene
        let wait = SKAction.wait(forDuration: 2)
        let reset = SKAction.run {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
        self.run(SKAction.sequence([wait, reset]))
    }
    func addDeathBlocks() {
    // The grid has 3 visible rows above ground and 32 columns
    let rows: CGFloat = 3
    let cols: CGFloat = 32
    let blockSize = CGSize(width: 30, height: 30) // size of each death block
    let startX = -self.size.width/2 + blockSize.width/2
    let startY = -self.size.height/2 + 60 + blockSize.height/2 // above ground (ground is at y = -size.height/2 + 20, height 40)
    
    // Row 0 = bottom row above ground
    // Row 1 = middle row
    // Row 2 = top row
    let grid: [[String]] = [
        [" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "X"],
        [" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "X", " ", "X", " ", " ", " ", " ", " "],
        [" ", " ", "B", " ", " ", " ", "X", " ", " ", "X", " ", " ", "X", " ", "X", " ", "X", " ", "X", " ", " ", "X", " ", " ", " ", " ", "X", " ", "X", " ", " ", " "]
    ]
    
    for (rowIndex, row) in grid.enumerated() {
        for (colIndex, cell) in row.enumerated() {
            if cell == "X" {
                let block = SKSpriteNode(color: .red, size: blockSize)
                let x = startX + CGFloat(colIndex) * (blockSize.width + 5) // spacing 5
                let y = startY + CGFloat(rowIndex) * (blockSize.height + 10) // spacing 10
                block.position = CGPoint(x: x, y: y)
                block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
                block.physicsBody?.isDynamic = false
                block.physicsBody?.categoryBitMask = PhysicsCategory.deathBlock
                block.physicsBody?.contactTestBitMask = PhysicsCategory.ball
                block.physicsBody?.collisionBitMask = 0
                addChild(block)
            }
        }
    }
}
func gameWin() {
    // Show a win label
    let winLabel = SKLabelNode(text: "You Win!")
    winLabel.fontSize = 50
    winLabel.fontColor = .green
    winLabel.position = CGPoint(x: self.camera!.position.x, y: self.camera!.position.y)
    winLabel.zPosition = 200
    addChild(winLabel)
    
    // Wait 2 seconds, then reset the scene
    let wait = SKAction.wait(forDuration: 2)
    let reset = SKAction.run {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene)
        }
    }
    self.run(SKAction.sequence([wait, reset]))
}
    func reset(){
        var respawn = SKAction.move(to: CGPoint(x: CGFloat.random(in: -320...320), y: 640), duration: 2)
        ball.run(respawn)
    }
    func jump(){
        if abs(ball.physicsBody!.velocity.dy) < 0.1 { 
            ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        }
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jump()
    }*/
    
}
