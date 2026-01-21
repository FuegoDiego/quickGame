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
