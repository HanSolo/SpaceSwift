//
//  StartScreen.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 04.01.20.
//  Copyright © 2020 Gerrit Grunwald. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit


class StartScene: SKScene {
    private let notificationCenter : NotificationCenter = .default
    private var background         : SKSpriteNode?
    private var audioPlayer        : AVAudioPlayer?
    private let soundTheme         : URL                = URL(fileURLWithPath: Bundle.main.path(forResource: "CityStomper.mp3", ofType:nil)!)
    
    
    override func didMove(to view: SKView) {
        // Background image
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        if let background = self.background {
            background.texture     = SKTexture(imageNamed: "startscreen.jpg")
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position    = CGPoint(x: 0, y: 0)
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundTheme)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch let error {
            print("Can't play soundTheme. \(error.localizedDescription)")
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        notificationCenter.post(name: .moveToGameScene, object: nil)
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
