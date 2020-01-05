//
//  GameOverScene.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 04.01.20.
//  Copyright © 2020 Gerrit Grunwald. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit


class GameOverScene: SKScene {
    private let notificationCenter  : NotificationCenter = .default
    private var background          : SKSpriteNode?
    private var scoreLabel          : SKLabelNode?
    private let gameOverSoundAction : SKAction           = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)
    
    
    override func didMove(to view: SKView) {
        // Background image
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        if let background = self.background {
            background.texture     = SKTexture(imageNamed: "gameover.jpg")
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position    = CGPoint(x: 0, y: 0)
        }
        
        // Get label node from scene and store it for use later
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        if let scoreLabel = self.scoreLabel {
            scoreLabel.alpha     = 0.0
            scoreLabel.zPosition = 5
            
            if let map = userData as NSMutableDictionary? {
                if let score = map["score"] as? Int {
                    scoreLabel.text = String(score)
                }
            }
            scoreLabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        run(gameOverSoundAction)
        
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 8), SKAction.run({ () -> Void in
            self.notificationCenter.post(name: .moveToStartScene, object: nil)
        })]);
        run(sequence)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
