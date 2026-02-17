//
//  GameViewController.swift
//  quickGame
//
//  Created by DIEGO CHAVEZ on 1/20/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var play : GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                play = scene as? GameScene
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        createButtons()
    }
    func createButtons() {

            // LEFT BUTTON
            let left = UIButton(type: .system)
            left.frame = CGRect(x: 40, y: view.frame.height - 120, width: 80, height: 80)
            left.backgroundColor = .blue
            left.alpha = 0.6
            left.layer.cornerRadius = 40
            left.addTarget(self, action: #selector(leftDown), for: .touchDown)
            left.addTarget(self, action: #selector(stopMove), for: [.touchUpInside,.touchUpOutside])
            view.addSubview(left)

            // RIGHT BUTTON
            let right = UIButton(type: .system)
            right.frame = CGRect(x: 140, y: view.frame.height - 120, width: 80, height: 80)
            right.backgroundColor = .green
            right.alpha = 0.6
            right.layer.cornerRadius = 40
            right.addTarget(self, action: #selector(rightDown), for: .touchDown)
            right.addTarget(self, action: #selector(stopMove), for: [.touchUpInside,.touchUpOutside])
            view.addSubview(right)
        }

        @objc func leftDown() {
            play.movingLeft = true
        }

        @objc func rightDown() {
            play.movingRight = true
        }

        @objc func stopMove() {
            play.movingLeft = false
            play.movingRight = false
        }
    @IBAction func buttonAction(_ sender: Any) {
        play.reset()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return.landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
