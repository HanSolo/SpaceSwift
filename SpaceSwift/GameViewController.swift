//
//  GameViewController.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 26.12.19.
//  Copyright © 2019 Gerrit Grunwald. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private let notificationCenter : NotificationCenter = .default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        notificationCenter.addObserver(self,
                                       selector: #selector(moveToStart(_:)),
                                       name    : .moveToStartScene,
                                       object  : nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(moveToGameOver(_:)),
                                       name    : .moveToGameOverScene,
                                       object  : nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(moveToGame(_:)),
                                       name    : .moveToGameScene,
                                       object  : nil)
                
        if let view = self.view as! SKView? {
            if let startScene = SKScene(fileNamed: "StartScene") {
                startScene.scaleMode = .aspectFill //.resizeFill
                view.presentScene(startScene)
            }
            
            //view.ignoresSiblingOrder = true
            //view.showsFPS            = true
            //view.showsNodeCount      = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func moveToStart(_ notification: NSNotification) -> Void {
        if let view = self.view as! SKView? {
            if let startScene = SKScene(fileNamed: "StartScene") {
                startScene.scaleMode = .aspectFill //.resizeFill
                view.presentScene(startScene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    @objc func moveToGameOver(_ notification: NSNotification) -> Void {
        if let view = self.view as! SKView? {
            if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
                gameOverScene.scaleMode = .aspectFill //.resizeFill
                
                // Get score from notification
                if let map = notification.userInfo as NSDictionary? {
                    if let score = map["score"] as? Int {
                        gameOverScene.userData = NSMutableDictionary()
                        gameOverScene.userData = ["score" : score]                        
                    }
                }
                
                view.presentScene(gameOverScene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    @objc func moveToGame(_ notification: NSNotification) -> Void {
        if let view = self.view as! SKView? {
            if let gameScene = SKScene(fileNamed: "GameScene") {
                gameScene.scaleMode = .aspectFill //.resizeFill
                view.presentScene(gameScene)
            }
            view.ignoresSiblingOrder = true
        }
    }
}
