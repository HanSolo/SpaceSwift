//
//  GameScene.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 26.12.19.
//  Copyright © 2019 Gerrit Grunwald. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit


class GameScene: SKScene {
    private static let NO_OF_STARS                  : Int                  = 200
    private static let NO_OF_ASTEROIDS              : Int                  = 15
    private static let NO_OF_ENEMIES                : Int                  = 5
    private static let SCALE_FACTOR                 : Double               = Double(UIScreen.main.scale)
    private static let SCENE_BOUNDS                 : CGRect               = UIScreen.main.bounds
    public  static let WIDTH                        : Double               = Double(SCENE_BOUNDS.size.width) * 1.78
    public  static let HEIGHT                       : Double               = Double(SCENE_BOUNDS.size.height) * 1.35
    public  static let FIRST_QUARTER_WIDTH          : CGFloat              = CGFloat(WIDTH * 0.25)
    public  static let LAST_QUARTER_WIDTH           : CGFloat              = CGFloat(WIDTH * 0.75)
    public  static let MIN_X                        : Double               = -WIDTH * 0.5
    public  static let MAX_X                        : Double               = WIDTH * 0.5
    public  static let MIN_Y                        : Double               = HEIGHT * 0.5
    public  static let MAX_Y                        : Double               = -HEIGHT
    public  static let ENEMY_FIRE_SENSITIVITY       : CGFloat              = 50
    public  static let ENEMY_BOSS_FIRE_SENSITIVITY  : CGFloat              = 85
    public  static let ENEMY_TORPEDO_SPEED          : CGFloat              = 5
    public  static let ENEMY_BOSS_TORPEDO_SPEED     : CGFloat              = 6
    public  static let ENEMY_BOSS_ATTACK_INTERVAL   : Double               = 20
    public  static let CRYSTAL_SPAWN_INTERVAL       : Double               = 25
    public  static let TORPEDO_SPEED                : CGFloat              = 6
    private static let DEFLECTOR_SHIELD_TIME        : Double               = 5
    private static let LIFES                        : Int                  = 5
    private static let SHIELDS                      : Int                  = 10
    private static let SCORE_COLOR                  : UIColor              = UIColor.init(red: 51/255, green: 210/255, blue: 206/255, alpha: 1)
    private        let notificationCenter           : NotificationCenter   = .default
    private        var noOfLifes                    : Int                  = LIFES
    private        var noOfShields                  : Int                  = SHIELDS
    private        var score                        : Int                  = 0
    private        let topKey                       : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "topKey.png")!))
    private        let rightKey                     : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "rightKey.png")!))
    private        let bottomKey                    : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "bottomKey.png")!))
    private        let leftKey                      : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "leftKey.png")!))
    private        let sKey                         : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "sKey.png")!))
    private        let rKey                         : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "rKey.png")!))
    private        let spaceKey                     : SKSpriteNode         = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "spaceKey.png")!))
    private        let gameSoundTheme               : URL                  = URL(fileURLWithPath: Bundle.main.path(forResource: "RaceToMars.mp3", ofType:nil)!)
    private        let laserSoundAction             : SKAction             = SKAction.playSoundFileNamed("laserSound.wav", waitForCompletion: false)
    private        let torpedoHitSoundAction        : SKAction             = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false)
    private        let rocketLaunchSoundAction      : SKAction             = SKAction.playSoundFileNamed("rocketLaunch.wav", waitForCompletion: false)
    private        let rocketExplosionSoundAction   : SKAction             = SKAction.playSoundFileNamed("rocketExplosion.wav", waitForCompletion: false)
    private        let explosionSoundAction         : SKAction             = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    private        let enemyLaserSoundAction        : SKAction             = SKAction.playSoundFileNamed("enemyLaserSound.wav", waitForCompletion: false)
    private        let asteroidExplosionSoundAction : SKAction             = SKAction.playSoundFileNamed("asteroidExplosion.wav", waitForCompletion: false)
    private        let spaceShipExplosionSoundAction: SKAction             = SKAction.playSoundFileNamed("spaceShipExplosionSound.wav", waitForCompletion: false)
    private        let enemyBossExplosionSoundAction: SKAction             = SKAction.playSoundFileNamed("enemyBossExplosion.wav", waitForCompletion: false)    
    private        let shieldHitSoundAction         : SKAction             = SKAction.playSoundFileNamed("shieldhit.wav", waitForCompletion: false)
    private        let enemyBossShildHitSoundAction : SKAction             = SKAction.playSoundFileNamed("enemyBossShieldHit.wav", waitForCompletion: false)
    private        let deflectorShieldSoundAction   : SKAction             = SKAction.playSoundFileNamed("deflectorshieldSound.wav", waitForCompletion: false)
    private        let powerUpSoundAction           : SKAction             = SKAction.playSoundFileNamed("powerUp.wav", waitForCompletion: false)
    private        let miniSpaceShipImg             : UIImage              = (UIImage.init(named: "fighter.png")?.scale(with: CGSize.init(width: 16, height: 16)))!
    private        let miniShieldImg                : UIImage              = (UIImage.init(named: "deflectorshield.png")?.scale(with: CGSize.init(width: 16, height: 16)))!
    private        var audioPlayer                  : AVAudioPlayer?
    private        var scoreLabel                   : SKLabelNode?
    private        var spinnyNode                   : SKShapeNode?
    private        var background                   : SKSpriteNode?
    private        var stars                        : [Star]               = [Star]()
    private        var asteroids                    : [Asteroid]           = [Asteroid]()
    private        var asteroidsToRemove            : [Asteroid]           = [Asteroid]()
    private        var enemies                      : [Enemy]              = [Enemy]()
    private        var enemiesToRemove              : [Enemy]              = [Enemy]()
    private        var crystals                     : [Crystal]            = [Crystal]()
    private        var enemyBosses                  : [EnemyBoss]          = [EnemyBoss]()
    private        var enemyTorpedos                : [EnemyTorpedo]       = [EnemyTorpedo]()
    private        var enemyBossTorpedos            : [EnemyBossTorpedo]   = [EnemyBossTorpedo]()
    private        var explosions                   : [Explosion]          = [Explosion]()
    private        var asteroidExplosions           : [AsteroidExplosion]  = [AsteroidExplosion]()
    private        var rocketExplosions             : [RocketExplosion]    = [RocketExplosion]()
    private        var spaceShipExplosions          : [SpaceShipExplosion] = [SpaceShipExplosion]()
    private        var enemyBossExplosions          : [EnemyBossExplosion] = [EnemyBossExplosion]()
    private        var crystalExplosions            : [CrystalExplosion]   = [CrystalExplosion]()
    private        var spaceShip                    : SpaceShip            = SpaceShip()
    private        var shield                       : Shield               = Shield()
    private        var lastShieldActivated          : TimeInterval         = CACurrentMediaTime()
    private        var lastEnemyBossAttack          : TimeInterval         = CACurrentMediaTime()
    private        var lastCrystal                  : TimeInterval         = CACurrentMediaTime()
    private        var torpedos                     : [Torpedo]            = [Torpedo]()
    private        var rockets                      : [Rocket]             = [Rocket]()
    private        var hits                         : [Hit]                = [Hit]()
    private        var enemyBossHits                : [EnemyBossHit]       = [EnemyBossHit]()
    private        var lifes                        : [SKSpriteNode]       = [SKSpriteNode]()
    private        var shields                      : [SKSpriteNode]       = [SKSpriteNode]()
    private        var shieldIndicatorFrame         : SKShapeNode          = SKShapeNode()
    private        var shieldIndicator              : SKShapeNode          = SKShapeNode()
    
    
    // ******************** Initialization *******************************************
    override func didMove(to view: SKView) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: gameSoundTheme)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch let error {
            print("Can't play soundTheme. \(error.localizedDescription)")
        }
        
        // Background image
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        if let background = self.background {
            background.texture   = SKTexture(imageNamed: "background.jpg")
            background.blendMode = .replace
            background.zPosition = 1
        }
        
        // Stars
        for i in 0 ..< GameScene.NO_OF_STARS {
            let star = Star()
            star.position.y = CGFloat(GameScene.MAX_Y + Double.random(in: 0...1) * GameScene.HEIGHT)
            star.zPosition  = 2
            stars.insert(star, at: i)
            self.addChild(star)
        }
        
        // Asteroids
        for i in 0 ..< GameScene.NO_OF_ASTEROIDS {
            let asteroid       = Asteroid()
            asteroid.zPosition = 2
            asteroids.insert(asteroid, at: i)
            self.addChild(asteroid)
        }
                
        // Enemies
        for i in 0 ..< GameScene.NO_OF_ENEMIES {
            let enemy       = Enemy()
            enemy.zPosition = 2
            enemies.insert(enemy, at: i)
            self.addChild(enemy)
        }
        
        score = 0
    
        // Get label node from scene and store it for use later
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        if let label = self.scoreLabel {
            label.alpha     = 0.0
            label.zPosition = 2
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = String(score)
        }
        
        spaceShip.zPosition = 2
        self.addChild(spaceShip)
        
        shield.zPosition = 3
        
        // Controls
        spaceKey.anchorPoint = CGPoint(x: 0, y: 0.5)
        spaceKey.zPosition   = 3
        spaceKey.position.x  = CGFloat(GameScene.MIN_X + 60)
        spaceKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.525)
        self.addChild(spaceKey)
        
        sKey.anchorPoint = CGPoint(x: 0, y: 0.5)
        sKey.zPosition   = 3
        sKey.position.x  = CGFloat(GameScene.MIN_X + 60)
        sKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.435)
        self.addChild(sKey);
        
        rKey.anchorPoint = CGPoint(x: 0, y: 0.5)
        rKey.zPosition   = 3
        rKey.position.x  = CGFloat(GameScene.MIN_X + 200)
        rKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.435)
        self.addChild(rKey);
        
        topKey.anchorPoint = CGPoint(x: 1, y: 0.5)
        topKey.zPosition   = 3
        topKey.position.x  = CGFloat(GameScene.MAX_X - 156)
        topKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.435)
        self.addChild(topKey)
        
        bottomKey.anchorPoint = CGPoint(x: 1, y: 0.5)
        bottomKey.zPosition   = 3
        bottomKey.position.x  = CGFloat(GameScene.MAX_X - 156)
        bottomKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.525)
        self.addChild(bottomKey)
        
        leftKey.anchorPoint = CGPoint(x: 1, y: 0.5)
        leftKey.zPosition   = 3
        leftKey.position.x  = CGFloat(GameScene.MAX_X - 256)
        leftKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.48)
        self.addChild(leftKey)
        
        rightKey.anchorPoint = CGPoint(x: 1, y: 0.5)
        rightKey.zPosition   = 3
        rightKey.position.x  = CGFloat(GameScene.MAX_X - 60)
        rightKey.position.y  = CGFloat(-GameScene.HEIGHT * 0.48)
        self.addChild(rightKey)
        
        for i in 0 ..< noOfLifes {
            let life :SKSpriteNode = SKSpriteNode.init(texture: SKTexture.init(image: miniSpaceShipImg))
            life.anchorPoint = CGPoint.init(x: 0, y: 0.5)
            life.position.x = CGFloat(Double(i) * 16.0 + 40.0 + GameScene.MIN_X)
            life.position.y = CGFloat(GameScene.MIN_Y + 40.0)
            life.zPosition  = 3
            lifes.append(life)
        }
        
        for i in 0 ..< noOfShields {
            let shield :SKSpriteNode = SKSpriteNode.init(texture: SKTexture.init(image: miniShieldImg))
            shield.anchorPoint = CGPoint.init(x: 1, y: 0.5)
            shield.position.x = CGFloat(GameScene.MAX_X - Double(i) * 18.0 - 40.0)
            shield.position.y = CGFloat(GameScene.MIN_Y + 40.0)
            shield.zPosition  = 3
            shields.append(shield)
        }
        
        shieldIndicatorFrame.path        = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 174, height: 18)).cgPath
        shieldIndicatorFrame.position    = CGPoint(x: 116, y: CGFloat(GameScene.MIN_Y))
        shieldIndicatorFrame.fillColor   = UIColor.clear
        shieldIndicatorFrame.strokeColor = UIColor.clear
        shieldIndicatorFrame.lineWidth   = 1
        shieldIndicatorFrame.zPosition   = 3
        self.addChild(shieldIndicatorFrame)
        
        shieldIndicator.path        = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 174, height: 18)).cgPath
        shieldIndicator.position    = CGPoint(x: 116, y: CGFloat(GameScene.MIN_Y))
        shieldIndicator.fillColor   = UIColor.clear
        shieldIndicator.strokeColor = UIColor.clear
        shieldIndicator.lineWidth   = 1
        shieldIndicator.zPosition   = 3
        self.addChild(shieldIndicator)
    }
    
    
    // ******************** Touch handling *******************************************
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
    
    func touchDown(atPoint pos : CGPoint) {
        if (!spaceShip.hasBeenHit) {
            if leftKey.contains(pos) {
                spaceShip.vX -= 5
                shield.vX    -= 5
                spaceShip.isMoving(isMoving: true)
            }
            if rightKey.contains(pos) {
                spaceShip.vX += 5
                shield.vX    += 5
                spaceShip.isMoving(isMoving: true)
            }
            if (topKey.contains(pos)) {
                spaceShip.vY -= 5
                shield.vY    -= 5
                spaceShip.isMoving(isMoving: true)
            }
            if bottomKey.contains(pos) {
                spaceShip.vY += 5
                shield.vY    += 5
                spaceShip.isMoving(isMoving: true)
            }
            if spaceKey.contains(pos) {
                spawnTorpedo(x: spaceShip.position.x, y: spaceShip.position.y + spaceShip.height * 0.5)
            }
            if rKey.contains(pos) && rockets.count < 3 {
                spawnRocket(x: spaceShip.position.x, y: spaceShip.position.y + spaceShip.height * 0.5)
            }
            if noOfShields > 0 && sKey.contains(pos) && !spaceShip.shield {
                spaceShip.shield = true
                noOfShields -= 1
                self.addChild(shield)
                shield.position.x   = spaceShip.position.x
                shield.position.y   = spaceShip.position.y
                shield.run(deflectorShieldSoundAction)
                lastShieldActivated = CACurrentMediaTime()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if leftKey.contains(pos) {
            spaceShip.vX = 0
            shield.vX    = 0
            spaceShip.isMoving(isMoving: false)
        }
        if rightKey.contains(pos) {
            spaceShip.vX = 0
            shield.vX    = 0
            spaceShip.isMoving(isMoving: false)
        }
        if (topKey.contains(pos)) {
            spaceShip.vY = 0
            shield.vY    = 0
            spaceShip.isMoving(isMoving: false)
        }
        if bottomKey.contains(pos) {
            spaceShip.vY = 0
            shield.vY    = 0
            spaceShip.isMoving(isMoving: false)
        }
    }
    
        
    // ******************** Update objects *******************************************
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Update background
        if let background = self.background {
            background.position.y -= 0.5
            if (background.position.y < -2228) {
                background.position.y = 0
            }
        }
        
        // EnemyBoss
        if currentTime - lastEnemyBossAttack > GameScene.ENEMY_BOSS_ATTACK_INTERVAL {
            spawnEnemyBoss()
            lastEnemyBossAttack = currentTime
        }
        
        // Crystal
        if currentTime - lastCrystal > GameScene.CRYSTAL_SPAWN_INTERVAL {
            spawnCrystal()
            lastCrystal = currentTime
        }
        
        // Shield
        if (spaceShip.shield && (currentTime - lastShieldActivated > GameScene.DEFLECTOR_SHIELD_TIME)) {
            shield.run(SKAction.removeFromParent())
            spaceShip.shield = false
        }
        if (spaceShip.shield) {
            let delta                        = currentTime - lastShieldActivated
            shieldIndicator.path             = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 174 - (174 * delta / GameScene.DEFLECTOR_SHIELD_TIME), height: 18)).cgPath
            shieldIndicatorFrame.strokeColor = GameScene.SCORE_COLOR
            shieldIndicator.fillColor        = GameScene.SCORE_COLOR
        } else {
            shieldIndicator.path             = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: 174, height: 18)).cgPath
            shieldIndicatorFrame.strokeColor = UIColor.clear
            shieldIndicator.fillColor        = UIColor.clear
        }
        
        
        // Update stars
        for i in 0 ..< GameScene.NO_OF_STARS {
            stars[i].update()
        }
        
        // Update asteroids
        for i in 0 ..< GameScene.NO_OF_ASTEROIDS {
            asteroids[i].update()
        }
        
        // Update crystal
        for i in 0 ..< crystals.count {
            crystals[i].update()
        }
        
        // Update space ship
        spaceShip.update()
        
        // Update shield
        shield.update()
        shield.alpha = CGFloat.random(in: 0.1...0.5)

        // Update torpedos
        for i in 0 ..< torpedos.count {
            torpedos[i].update()
        }
        
        // Update rockets
        for i in 0 ..< rockets.count {
            rockets[i].update()
        }
        
        // Update enemies
        for i in 0 ..< GameScene.NO_OF_ENEMIES {
            enemies[i].update()
        }
        
        // Upate enemy torpedos
        for i in 0 ..< enemyTorpedos.count {
            enemyTorpedos[i].update()
        }
        
        // Update enemy boss
        for i in 0 ..< enemyBosses.count {
            enemyBosses[i].update()
        }
        
        // Upate enemy boss torpedos
        for i in 0 ..< enemyBossTorpedos.count {
            enemyBossTorpedos[i].update()
        }
        
        // Update asteroid explosions
        for i in 0 ..< asteroidExplosions.count {
            asteroidExplosions[i].update()
        }
        
        // Update space ship explosions
        for i in 0 ..< spaceShipExplosions.count {
            spaceShipExplosions[i].update()
        }

        // Update explosions
        for i in 0 ..< explosions.count {
            explosions[i].update()
        }
        
        // Update rocket explosions
        for i in 0 ..< rocketExplosions.count {
            rocketExplosions[i].update()
        }
        
        // Update enemy boss explosions
        for i in 0 ..< enemyBossExplosions.count {
            enemyBossExplosions[i].update()
        }
        
        // Update crystal explosions
        for i in 0 ..< crystalExplosions.count {
            crystalExplosions[i].update()
        }
        
        // Update asteroid hits
        for i in 0 ..< hits.count {
            hits[i].update()
        }
        
        // Update enemy boss hits
        for i in 0 ..< enemyBossHits.count {
            enemyBossHits[i].update()
        }
        
        // Perform hit check
        hitCheck()
        
        
        // Remove nodes from scene
        removeChildren(in: torpedos)
        removeChildren(in: rockets)
        removeChildren(in: enemyTorpedos)
        removeChildren(in: enemyBossTorpedos)
        removeChildren(in: hits)
        removeChildren(in: enemyBossHits)
        removeChildren(in: explosions)
        removeChildren(in: asteroidExplosions)
        removeChildren(in: rocketExplosions)
        removeChildren(in: enemyBossExplosions)
        removeChildren(in: spaceShipExplosions)
        removeChildren(in: crystalExplosions)
        removeChildren(in: enemyBosses)
        removeChildren(in: crystals)
        removeChildren(in: lifes)
        removeChildren(in: shields)
        
        if (spaceShip.hasBeenHit) {
            spaceShip.removeFromParent()
        }
        
        
        // Remove obsolete objects
        torpedos            = torpedos.filter { !$0.toBeRemoved }
        rockets             = rockets.filter { !$0.toBeRemoved }
        enemyTorpedos       = enemyTorpedos.filter { !$0.toBeRemoved }
        enemyBossTorpedos   = enemyBossTorpedos.filter { !$0.toBeRemoved }
        hits                = hits.filter { !$0.toBeRemoved }
        enemyBossHits       = enemyBossHits.filter { !$0.toBeRemoved }
        asteroidExplosions  = asteroidExplosions.filter { !$0.toBeRemoved }
        explosions          = explosions.filter { !$0.toBeRemoved }
        rocketExplosions    = rocketExplosions.filter { !$0.toBeRemoved }
        spaceShipExplosions = spaceShipExplosions.filter { !$0.toBeRemoved }
        enemyBossExplosions = enemyBossExplosions.filter { !$0.toBeRemoved }
        crystalExplosions   = crystalExplosions.filter { !$0.toBeRemoved }
        enemyBosses         = enemyBosses.filter { !$0.toBeRemoved }
        crystals            = crystals.filter { !$0.toBeRemoved }
        
        if (spaceShipExplosions.isEmpty && !self.children.contains(spaceShip)) {
            self.addChild(spaceShip)
        }
        
        // Add enemy boss
        for i in 0 ..< enemyBosses.count {
            self.addChild(enemyBosses[i])
        }
        
        // Add crystals
        for i in 0 ..< crystals.count {
            self.addChild(crystals[i])
        }
        
        // Add torpedos
        for i in 0 ..< torpedos.count {
            self.addChild(torpedos[i])
        }
        
        // Add rockets
        for i in 0 ..< rockets.count {
            self.addChild(rockets[i])
        }
        
        // Add enemy torpedos
        for i in 0 ..< enemyTorpedos.count {
            self.addChild(enemyTorpedos[i])
        }
        
        // Add enemy boss torpedos
        for i in 0 ..< enemyBossTorpedos.count {
            self.addChild(enemyBossTorpedos[i])
        }
        
        // Add hits
        for i in 0 ..< hits.count {
            self.addChild(hits[i])
        }
        
        // Add enemy boss hits
        for i in 0 ..< enemyBossHits.count {
            self.addChild(enemyBossHits[i])
        }
        
        // Add asteroid explosions
        for i in 0 ..< asteroidExplosions.count {
            self.addChild(asteroidExplosions[i])
        }
        
        // Add rocket explosions
        for i in 0 ..< rocketExplosions.count {
            self.addChild(rocketExplosions[i])
        }
        
        // Add spaceship explosions
        for i in 0 ..< spaceShipExplosions.count {
            self.addChild(spaceShipExplosions[i])
        }
        
        // Add explosions
        for i in 0 ..< explosions.count {
            self.addChild(explosions[i])
        }
                
        // Add enemy boss explosions
        for i in 0 ..< enemyBossExplosions.count {
            self.addChild(enemyBossExplosions[i])
        }
        
        // Add crystal explosions
        for i in 0 ..< crystalExplosions.count {
            self.addChild(crystalExplosions[i])
        }
        
        // No of lifes
        for i in 0 ..< noOfLifes {
            self.addChild(lifes[i])
        }
        
        // No of shields
        for i in 0 ..< noOfShields {
            self.addChild(shields[i])
        }
        
        // Update score
        scoreLabel?.text = String(score)
    }
    
    
    // ******************** Spawn objects ********************************************
    private func spawnTorpedo(x: CGFloat, y: CGFloat) -> Void {
        let torpedo = Torpedo.init(x: x, y: y)
        torpedo.zPosition = 2
        torpedos.append(torpedo)
        torpedo.run(laserSoundAction)
    }
    
    private func spawnRocket(x: CGFloat, y: CGFloat) -> Void {
        let rocket = Rocket.init(x: x, y: y)
        rocket.zPosition = 2
        rockets.append(rocket)
        rocket.run(rocketLaunchSoundAction)
    }
    
    private func spawnEnemyTorpedo(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        let vFactor      : CGFloat      = GameScene.ENEMY_TORPEDO_SPEED / vY
        let enemyTorpedo : EnemyTorpedo = EnemyTorpedo.init(x: x, y: y, vX: vFactor * vX, vY: vFactor * vY)
        enemyTorpedo.zPosition = 2
        enemyTorpedos.append(enemyTorpedo)
        enemyTorpedo.run(enemyLaserSoundAction)
    }
    
    private func spawnEnemyBossTorpedo(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        let vFactor          : CGFloat          = GameScene.ENEMY_BOSS_TORPEDO_SPEED / vY
        let enemyBossTorpedo : EnemyBossTorpedo = EnemyBossTorpedo.init(x: x, y: y, vX: vFactor * vX, vY: vFactor * vY)
        enemyBossTorpedo.zPosition = 2
        enemyBossTorpedos.append(enemyBossTorpedo)
        enemyBossTorpedo.run(enemyLaserSoundAction)
    }
    
    private func spawnEnemyBoss() {
        let enemyBoss = EnemyBoss()
        enemyBoss.zPosition = 2
        enemyBosses.append(enemyBoss)
    }
    
    private func spawnCrystal() {
        let crystal = Crystal()
        crystal.zPosition = 2
        crystals.append(crystal)
    }
    
    
    // ******************** Hit tests ************************************************
    private func isHitCircleCircle(c1X: CGFloat, c1Y: CGFloat, c1R: CGFloat, c2X: CGFloat, c2Y: CGFloat, c2R: CGFloat) -> Bool {
        let distX    = c1X - c2X
        let distY    = c1Y - c2Y
        let distance = sqrt((distX * distX) + (distY * distY))
        return distance <= (c1R + c2R)
    }
    
    private func hitCheck() -> Void {
        // ******************** Check hits with asteroid *****************************
        for i in 0 ..< GameScene.NO_OF_ASTEROIDS {
            let asteroid = asteroids[i]
            
            // Check hits with Torpedos
            for i in 0 ..< torpedos.count {
                let torpedo = torpedos[i]
                if isHitCircleCircle(c1X: torpedo.position.x, c1Y: torpedo.position.y, c1R: Torpedo.RADIUS,
                                     c2X: asteroid.position.x, c2Y: asteroid.position.y, c2R: asteroid.radius!) {
                    asteroid.hits -= 1
                    if asteroid.hits == 0 {
                        let asteroidExplosion = AsteroidExplosion.init(x: asteroid.position.x, y: asteroid.position.y, vX: asteroid.vX, vY: asteroid.vY, scale: asteroid.aScale!)
                        asteroidExplosion.zPosition = 2
                        asteroidExplosions.append(asteroidExplosion)
                        score += asteroid.value!
                        asteroid.respawn()
                        torpedo.toBeRemoved = true
                        asteroidExplosion.run(asteroidExplosionSoundAction)
                    } else {
                        let hit = Hit.init(x: torpedo.position.x, y: torpedo.position.y + 40, vX: asteroid.vX, vY: asteroid.vY)
                        hit.zPosition = 2
                        hits.append(hit)
                        torpedo.toBeRemoved = true
                        torpedo.run(torpedoHitSoundAction)
                    }
                }
            }
            
            // Check hits with rockets
            for i in 0 ..< rockets.count {
                let rocket = rockets[i]
                if isHitCircleCircle(c1X: rocket.position.x, c1Y: rocket.position.y, c1R: Rocket.RADIUS,
                                     c2X: asteroid.position.x, c2Y: asteroid.position.y, c2R: asteroid.radius!) {
                    let rocketExplosion = RocketExplosion.init(x: asteroid.position.x, y: asteroid.position.y, vX: asteroid.vX, vY: asteroid.vY, scale: asteroid.aScale!)
                    rocketExplosion.zPosition = 2
                    rocketExplosions.append(rocketExplosion)
                    score += asteroid.value!
                    asteroid.respawn()
                    rocket.toBeRemoved = true
                    rocketExplosion.run(rocketExplosionSoundAction)
                }
            }
            
            // Check hits with space ship
            if !spaceShip.hasBeenHit {
                let hit: Bool = isHitCircleCircle(c1X: spaceShip.position.x, c1Y: spaceShip.position.y, c1R: spaceShip.radius,
                                                  c2X: asteroid.position.x, c2Y: asteroid.position.y, c2R: asteroid.radius!)
                if hit {                    
                    if spaceShip.shield {
                        let asteroidExplosion = AsteroidExplosion.init(x: asteroid.position.x, y: asteroid.position.y, vX: asteroid.vX, vY: asteroid.vY, scale: asteroid.aScale!)
                        asteroidExplosion.zPosition = 2
                        asteroidExplosions.append(asteroidExplosion)
                        asteroidExplosion.run(explosionSoundAction)
                    } else {
                        let spaceShipExplosion = SpaceShipExplosion.init(x: spaceShip.position.x, y: spaceShip.position.y, vX: spaceShip.vX, vY: spaceShip.vY, scale: 1.0, spaceShip: spaceShip)
                        spaceShipExplosion.zPosition = 2
                        spaceShipExplosions.append(spaceShipExplosion)
                        spaceShip.run(spaceShipExplosionSoundAction)
                        spaceShip.hasBeenHit = true
                        noOfLifes -= 1
                        if 0 == noOfLifes {
                            gameOver()
                        }
                    }
                    asteroid.respawn()
                }
            }
        }
        
        
        // ******************** Check hits with enemies ******************************
        for i in 0 ..< GameScene.NO_OF_ENEMIES {
            let enemy = enemies[i]
            // Fire on space ship if within fire sensitivity
            if enemy.position.y > spaceShip.position.y {
                if (enemy.position.x > spaceShip.position.x - GameScene.ENEMY_FIRE_SENSITIVITY &&
                    enemy.position.x < spaceShip.position.x + GameScene.ENEMY_FIRE_SENSITIVITY) {
                    if (enemy.lastShotY - enemy.position.y > 15) {
                        spawnEnemyTorpedo(x: enemy.position.x, y: enemy.position.y, vX: enemy.vX, vY: enemy.vY)
                        enemy.lastShotY = enemy.position.y
                    }
                }
            }
            // Check hits with torpedos
            for i in 0 ..< torpedos.count {
                let torpedo = torpedos[i]
                if isHitCircleCircle(c1X: torpedo.position.x, c1Y: torpedo.position.y, c1R: Torpedo.RADIUS,
                                     c2X: enemy.position.x, c2Y: enemy.position.y, c2R: enemy.radius!) {
                    let explosion = Explosion.init(x: enemy.position.x, y: enemy.position.y, vX: enemy.vX, vY: enemy.vY, scale: 0.5)
                    explosion.zPosition = 2
                    explosions.append(explosion)
                    score += enemy.value!
                    enemy.respawn()
                    torpedo.toBeRemoved = true
                    explosion.run(explosionSoundAction)
                }
            }
            // Check hits with rockets
            for i in 0 ..< rockets.count {
                let rocket = rockets[i]
                if isHitCircleCircle(c1X: rocket.position.x, c1Y: rocket.position.y, c1R: Rocket.RADIUS,
                                     c2X: enemy.position.x, c2Y: enemy.position.y, c2R: enemy.radius!) {
                    let rocketExplosion = RocketExplosion.init(x: enemy.position.x, y: enemy.position.y, vX: enemy.vX, vY: enemy.vY, scale: 0.5)
                    rocketExplosion.zPosition = 2
                    rocketExplosions.append(rocketExplosion)
                    score += enemy.value!
                    enemy.respawn()
                    rocket.toBeRemoved = true
                    rocketExplosion.run(rocketExplosionSoundAction)
                }
            }
            // Check hits with space ship
            if !spaceShip.hasBeenHit {
                let hit: Bool = isHitCircleCircle(c1X: spaceShip.position.x, c1Y: spaceShip.position.y, c1R: spaceShip.radius,
                                                  c2X: enemy.position.x, c2Y: enemy.position.y, c2R: enemy.radius!)
                if hit {
                    if spaceShip.shield {
                        let explosion = Explosion.init(x: enemy.position.x, y: enemy.position.y, vX: enemy.vX, vY: enemy.vY, scale: 0.5)
                        explosion.zPosition = 2
                        explosions.append(explosion)
                        explosion.run(explosionSoundAction)
                    } else {
                        let spaceShipExplosion = SpaceShipExplosion.init(x: spaceShip.position.x, y: spaceShip.position.y, vX: spaceShip.vX, vY: spaceShip.vY, scale: 1.0, spaceShip: spaceShip)
                        spaceShipExplosion.zPosition = 2
                        spaceShipExplosions.append(spaceShipExplosion)
                        spaceShip.run(spaceShipExplosionSoundAction)
                        spaceShip.hasBeenHit = true
                        noOfLifes -= 1
                        if 0 == noOfLifes {
                            gameOver()
                        }
                    }
                    enemy.respawn()
                }
            }
        }
        
        
        // ******************** Check hits with enemy boss ***************************
        for i in 0 ..< enemyBosses.count {
            let enemyBoss = enemyBosses[i]
            // Fire on space ship if within enemy boss fire sensitivity
            if enemyBoss.position.y > spaceShip.position.y {
                if (enemyBoss.position.x > spaceShip.position.x - GameScene.ENEMY_BOSS_FIRE_SENSITIVITY &&
                    enemyBoss.position.x < spaceShip.position.x + GameScene.ENEMY_BOSS_FIRE_SENSITIVITY) {
                    if (enemyBoss.lastShotY - enemyBoss.position.y > 15) {
                        spawnEnemyBossTorpedo(x: enemyBoss.position.x, y: enemyBoss.position.y, vX: enemyBoss.vX, vY: enemyBoss.vY)
                        enemyBoss.lastShotY = enemyBoss.position.y
                    }
                }
            }
            // Check hits with torpedos
            for i in 0 ..< torpedos.count {
                let torpedo = torpedos[i]
                if isHitCircleCircle(c1X: torpedo.position.x, c1Y: torpedo.position.y, c1R: Torpedo.RADIUS,
                                     c2X: enemyBoss.position.x, c2Y: enemyBoss.position.y, c2R: EnemyBoss.RADIUS) {
                    enemyBoss.hits -= 1
                    if enemyBoss.hits == 0 {
                        score += enemyBoss.value
                        enemyBoss.toBeRemoved = true
                        torpedo.toBeRemoved   = true
                        let enemyBossExplosion = EnemyBossExplosion.init(x: enemyBoss.position.x, y: enemyBoss.position.y, vX: enemyBoss.vX, vY: enemyBoss.vY, scale: 0.5)
                        enemyBossExplosion.zPosition = 2
                        enemyBossExplosions.append(enemyBossExplosion)
                        enemyBossExplosion.run(enemyBossExplosionSoundAction)
                    } else {
                        let enemyBossHit = EnemyBossHit.init(x: enemyBoss.position.x, y: enemyBoss.position.y, vX: enemyBoss.vX, vY: enemyBoss.vY)
                        enemyBossHit.zPosition = 2
                        enemyBossHits.append(enemyBossHit)
                        torpedo.toBeRemoved = true
                        enemyBossHit.run(enemyBossShildHitSoundAction)
                    }
                }
            }
            // Check hits with rockets
            for i in 0 ..< rockets.count {
                let rocket = rockets[i]
                if isHitCircleCircle(c1X: rocket.position.x, c1Y: rocket.position.y, c1R: Rocket.RADIUS,
                                     c2X: enemyBoss.position.x, c2Y: enemyBoss.position.y, c2R: EnemyBoss.RADIUS) {
                    let rocketExplosion = RocketExplosion.init(x: enemyBoss.position.x, y: enemyBoss.position.y, vX: enemyBoss.vX, vY: enemyBoss.vY, scale: 0.5)
                    rocketExplosion.zPosition = 2
                    rocketExplosions.append(rocketExplosion)
                    score += enemyBoss.value
                    enemyBoss.toBeRemoved = true
                    rocket.toBeRemoved    = true
                    rocketExplosion.run(rocketExplosionSoundAction)
                }
            }
            // Check hits with space ship
            if !spaceShip.hasBeenHit {
                let hit: Bool = isHitCircleCircle(c1X: spaceShip.position.x, c1Y: spaceShip.position.y, c1R: spaceShip.radius,
                                                  c2X: enemyBoss.position.x, c2Y: enemyBoss.position.y, c2R: EnemyBoss.RADIUS)
                if hit {
                    if spaceShip.shield {
                        enemyBoss.toBeRemoved = true
                        let enemyBossExplosion = EnemyBossExplosion.init(x: enemyBoss.position.x, y: enemyBoss.position.y, vX: enemyBoss.vX, vY: enemyBoss.vY, scale: 0.5)
                        enemyBossExplosion.zPosition = 2
                        enemyBossExplosions.append(enemyBossExplosion)
                        enemyBossExplosion.run(enemyBossExplosionSoundAction)
                    } else {
                        let spaceShipExplosion = SpaceShipExplosion.init(x: spaceShip.position.x, y: spaceShip.position.y, vX: spaceShip.vX, vY: spaceShip.vY, scale: 1.0, spaceShip: spaceShip)
                        spaceShipExplosion.zPosition = 2
                        spaceShipExplosions.append(spaceShipExplosion)
                        spaceShip.run(spaceShipExplosionSoundAction)
                        spaceShip.hasBeenHit = true
                        noOfLifes -= 1
                        if 0 == noOfLifes {
                            gameOver()
                        }
                    }
                }
            }
        }
        
        
        // ******************** Check hits with enemy torpedos ***********************
        for i in 0 ..< enemyTorpedos.count {
            let enemyTorpedo = enemyTorpedos[i]
            if !spaceShip.hasBeenHit {
                let hit :Bool = isHitCircleCircle(c1X: enemyTorpedo.position.x, c1Y: enemyTorpedo.position.y, c1R: EnemyTorpedo.RADIUS,
                                                  c2X: spaceShip.position.x, c2Y: spaceShip.position.y, c2R: spaceShip.radius)
                if hit {
                    enemyTorpedo.toBeRemoved = true
                    if (spaceShip.shield) {
                        shield.run(shieldHitSoundAction)
                    } else {
                        let spaceShipExplosion = SpaceShipExplosion.init(x: spaceShip.position.x, y: spaceShip.position.y, vX: spaceShip.vX, vY: spaceShip.vY, scale: 1.0, spaceShip: spaceShip)
                        spaceShipExplosion.zPosition = 2
                        spaceShipExplosions.append(spaceShipExplosion)
                        spaceShip.run(spaceShipExplosionSoundAction)
                        spaceShip.hasBeenHit = true
                        noOfLifes -= 1
                        if 0 == noOfLifes {
                            gameOver()
                        }                        
                    }
                } else if (position.y - EnemyTorpedo.HEIGHT) < CGFloat(GameScene.MAX_Y) {
                    enemyTorpedo.toBeRemoved = true
                }
            }
        }
        
        
        // ******************** Check hits with enemy boss torpedos ******************
        for i in 0 ..< enemyBossTorpedos.count {
            let enemyBossTorpedo = enemyBossTorpedos[i]
            if !spaceShip.hasBeenHit {
                let hit :Bool = isHitCircleCircle(c1X: enemyBossTorpedo.position.x, c1Y: enemyBossTorpedo.position.y, c1R: EnemyBossTorpedo.RADIUS,
                                                  c2X: spaceShip.position.x, c2Y: spaceShip.position.y, c2R: spaceShip.radius)
                if hit {
                    enemyBossTorpedo.toBeRemoved = true
                    if (spaceShip.shield) {
                        shield.run(shieldHitSoundAction)
                    } else {
                        let spaceShipExplosion = SpaceShipExplosion.init(x: spaceShip.position.x, y: spaceShip.position.y, vX: spaceShip.vX, vY: spaceShip.vY, scale: 1.0, spaceShip: spaceShip)
                        spaceShipExplosion.zPosition = 2
                        spaceShipExplosions.append(spaceShipExplosion)
                        spaceShip.run(spaceShipExplosionSoundAction)
                        spaceShip.hasBeenHit = true
                        noOfLifes -= 1
                        if 0 == noOfLifes {
                            gameOver()
                        }
                    }
                } else if (position.y - EnemyBossTorpedo.HEIGHT) < CGFloat(GameScene.MAX_Y) {
                    enemyBossTorpedo.toBeRemoved = true
                }
            }
        }
        
        
        // ******************** Check hits with crystal ******************************
        for i in 0 ..< crystals.count {
            let crystal = crystals[i]
            let hit :Bool = isHitCircleCircle(c1X: crystal.position.x, c1Y: crystal.position.y, c1R: Crystal.RADIUS,
                                              c2X: spaceShip.position.x, c2Y: spaceShip.position.y, c2R: spaceShip.radius)
            if hit {
                if noOfShields < GameScene.SHIELDS {
                    noOfShields += 1
                }
                crystal.toBeRemoved = true
                let crystalExplosion :CrystalExplosion = CrystalExplosion.init(x: crystal.position.x, y: crystal.position.y, vX: crystal.vX, vY: crystal.vY, scale: 0.5)
                crystalExplosion.zPosition = 2
                crystalExplosions.append(crystalExplosion)
                crystalExplosion.run(powerUpSoundAction)
            }
        }
    }
        
    
    // ******************** Game Over ************************************************
    private func gameOver() -> Void {
        let map :[String: Int] = ["score" : score]
        notificationCenter.post(name: .moveToGameOverScene, object: nil, userInfo: map)
    }
}


// ******************** Space Object Classes *****************************************
class Star: SKShapeNode {
    private static let TWO_PI      : CGFloat = CGFloat(Double.pi * 2.0)
    private static let MIN_SPEED_Y : CGFloat = 4
    var                size        : Double  = 1
    var                vX          : CGFloat = 0
    var                vY          : CGFloat = 0
    var                vYVariation : CGFloat = 0.2
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init() {
        super.init()
        let radius                    = CGFloat.random(in: 0.5...1.5)
        self.size                     = Double(2.0 * radius);
        self.position.x               = CGFloat(GameScene.MIN_X + Double.random(in: 0...1) * GameScene.WIDTH)
        self.position.y               = CGFloat(GameScene.MIN_Y + size)
        self.path                     = UIBezierPath(arcCenter: CGPoint(x: position.x, y: position.y), radius: radius, startAngle: 0, endAngle: Star.TWO_PI, clockwise: true).cgPath
        self.fillColor                = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.9)
        self.vYVariation              = CGFloat.random(in: 0.2 ... 0.7)
        self.vX                       = 0
        self.vY                       = CGFloat.random(in: Star.MIN_SPEED_Y ... (Star.MIN_SPEED_Y + 1.5)) * vYVariation
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
    }
        
    
    func respawn() -> Void {
        position.x = CGFloat(GameScene.MIN_X + Double.random(in: 0...1) * GameScene.WIDTH)
        position.y = CGFloat(GameScene.MIN_Y + size)
    }
    
    func update() -> Void {
        position.x += vX
        position.y -= vY
    
        if position.y < CGFloat(GameScene.MAX_Y) {
            respawn()
        }
    }
}

class Asteroid: SKSpriteNode {
    private static let TWO_PI          : Double      = 2.0 * Double.pi
    private static let ASTEROID_IMAGES : [SKTexture] = [
        SKTexture.init(image: UIImage.init(named: "asteroid1.png")!.scale(with: CGSize(width: 140, height: 140))!),
        SKTexture.init(image: UIImage.init(named: "asteroid2.png")!.scale(with: CGSize(width: 140, height: 140))!),
        SKTexture.init(image: UIImage.init(named: "asteroid3.png")!.scale(with: CGSize(width: 140, height: 140))!),
        SKTexture.init(image: UIImage.init(named: "asteroid4.png")!.scale(with: CGSize(width: 110, height: 110))!),
        SKTexture.init(image: UIImage.init(named: "asteroid5.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "asteroid6.png")!.scale(with: CGSize(width: 120, height: 120))!),
        SKTexture.init(image: UIImage.init(named: "asteroid7.png")!.scale(with: CGSize(width: 110, height: 110))!),
        SKTexture.init(image: UIImage.init(named: "asteroid8.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "asteroid9.png")!.scale(with: CGSize(width: 130, height: 130))!),
        SKTexture.init(image: UIImage.init(named: "asteroid10.png")!.scale(with: CGSize(width: 120, height: 120))!),
        SKTexture.init(image: UIImage.init(named: "asteroid11.png")!.scale(with: CGSize(width: 140, height: 140))!)
    ]
    private static let MAX_VALUE       : Double = 10
    private static let X_VARIATION     : Double = 2
    private static let MIN_SPEED_Y     : Double = 2
    private static let MIN_ROTATION_R  : Double = 0.00174533
    private        var image           : SKTexture?
    private        var width           : Double?
    private        var height          : Double?
    private        var aSize           : Double?
    public         var radius          : CGFloat?
    public         var vX              : CGFloat = 0
    public         var vY              : CGFloat = 0
    private        var vR              : CGFloat = 0
    private        var rotateRight     : Bool?
    public         var aScale          : Double?
    private        var vYVariation     : Double?
    public         var value           : Int?
    public         var hits            : Int     = 5
    
    
    init() {
        let texture = Asteroid.ASTEROID_IMAGES[Int.random(in: 0 ..< 10)]
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.isUserInteractionEnabled = false
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Position
        position.x = CGFloat(Double.random(in: GameScene.MIN_X ..< GameScene.MAX_X))
        position.y = CGFloat(GameScene.MIN_Y + Double(texture!.size().height))
        zRotation  = 0
        
        // Scale
        aScale = Double.random(in: 0.2 ... 0.8)
        
        // No of hits
        hits = Int(aScale! * 5.0)
        
        // Value
        value = Int(1.0 / aScale! * Asteroid.MAX_VALUE)
        
        // Random Speed
        vYVariation = Double.random(in: 0.2 ... 0.7)
        
        width  = Double(texture!.size().width) * aScale!
        height = Double(texture!.size().height) * aScale!
        aSize  = width! > height! ? width! : height!
        radius = CGFloat(aSize! * 0.5)
        
        // Velocity
        vX          = CGFloat((Double.random(in: 0...1) * Asteroid.X_VARIATION) - Asteroid.X_VARIATION * 0.5)
        vY          = CGFloat(((Double.random(in: 0...1) * 1.5) + Asteroid.MIN_SPEED_Y) * (1 / aScale!) * vYVariation!)
        vR          = CGFloat((Double.random(in: 0...1) * 0.00872665) + Asteroid.MIN_ROTATION_R)
        rotateRight = Bool.random()
        
        scale(to: CGSize.init(width: width!, height: height!))
    }
    
    func respawn() -> Void {
        texture = Asteroid.ASTEROID_IMAGES[Int.random(in: 0 ..< 10)]
        initialize()
    }
    
    func update() -> Void {
        position.x += vX
        position.y -= vY
        
        if rotateRight! {
            zRotation += vR
            if Double(zRotation) > Asteroid.TWO_PI { zRotation = 0 }
        } else {
            zRotation -= vR
            if zRotation < 0 { zRotation = CGFloat(Asteroid.TWO_PI) }
        }

        // Respawn asteroid
        if(position.x < CGFloat(GameScene.MIN_X - aSize!) || position.x - CGFloat(radius!) > CGFloat(GameScene.MAX_X) || position.y - CGFloat(height!) < CGFloat(GameScene.MAX_Y)) {
            respawn();
        }
    }
}

class Crystal: SKSpriteNode {
    private static let TWO_PI         : Double    = 2.0 * Double.pi
    private static let X_VARIATION    : Double    = 2
    private static let MIN_SPEED_Y    : Double    = 2
    private static let MIN_ROTATION_R : Double    = 0.00174533
    private static let IMAGE          : SKTexture = SKTexture.init(image: UIImage.init(named: "crystal.png")!.scale(with: CGSize(width: 100, height: 100))!)
    private static let WIDTH          : CGFloat   = 100
    private static let HEIGHT         : CGFloat   = 100
    private static let SIZE           : CGFloat   = 100
    public  static let RADIUS         : CGFloat   = SIZE * 0.5
    public         var vX             : CGFloat   = 0
    public         var vY             : CGFloat   = 0
    private        var vR             : CGFloat   = 0
    private        var rotateRight    : Bool      = false
    private        var vYVariation    : Double    = 0.5
    public         var toBeRemoved    : Bool      = false
    
    
    init() {
        super.init(texture: Crystal.IMAGE, color: UIColor.clear, size: Crystal.IMAGE.size())
        self.isUserInteractionEnabled = false
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Position
        position.x = CGFloat(Double.random(in: GameScene.MIN_X ..< GameScene.MAX_X))
        position.y = CGFloat(GameScene.MIN_Y + Double(texture!.size().height))
        zRotation  = 0
        
        // Random Speed
        vYVariation = Double.random(in: 0.2 ... 0.7)
        
        // Velocity
        vX          = CGFloat((Double.random(in: 0...1) * Crystal.X_VARIATION) - Crystal.X_VARIATION * 0.5)
        vY          = CGFloat(((Double.random(in: 0...1) * 1.5) + Crystal.MIN_SPEED_Y) * vYVariation)
        vR          = CGFloat((Double.random(in: 0...1) * 0.00872665) + Crystal.MIN_ROTATION_R)
        rotateRight = Bool.random()
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y -= vY
            
            if rotateRight {
                zRotation += vR
                if Double(zRotation) > Crystal.TWO_PI { zRotation = 0 }
            } else {
                zRotation -= vR
                if zRotation < 0 { zRotation = CGFloat(Crystal.TWO_PI) }
            }

            // Respawn asteroid
            if(position.x < (CGFloat(GameScene.MIN_X) - Crystal.SIZE) || (position.x - Crystal.RADIUS) > CGFloat(GameScene.MAX_X) || (position.y - Crystal.HEIGHT) < CGFloat(GameScene.MAX_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class Enemy: SKSpriteNode {
    private static let HALF_PI      : CGFloat     = CGFloat(Double.pi / 2.0)
    private static let ENEMY_IMAGES : [SKTexture] = [
        SKTexture.init(image: UIImage.init(named: "enemy1.png")!.scale(with: CGSize(width: 56, height: 56))!),
        SKTexture.init(image: UIImage.init(named: "enemy2.png")!.scale(with: CGSize(width: 50, height: 50))!),
        SKTexture.init(image: UIImage.init(named: "enemy3.png")!.scale(with: CGSize(width: 68, height: 68))!)
    ]
    private static let MAX_VALUE    : Int         = 50
    private static let X_VARIATION  : CGFloat     = 1
    private static let MIN_SPEED_Y  : CGFloat     = 3
    private        var image        : SKTexture?
    private        var width        : CGFloat?
    private        var height       : CGFloat?
    private        var aSize        : CGFloat?
    public         var radius       : CGFloat?
    public         var vX           : CGFloat     = 0
    public         var vY           : CGFloat     = 0
    private        var vYVariation  : CGFloat     = 0
    public         var value        : Int?
    public         var lastShotY    : CGFloat     = 0
    
    
    init() {
        let texture = Enemy.ENEMY_IMAGES[Int.random(in: 0 ..< 3)]
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.isUserInteractionEnabled = false
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Position
        position.x = CGFloat(Double.random(in: GameScene.MIN_X ..< GameScene.MAX_X))
        position.y = CGFloat(GameScene.MIN_Y + Double(texture!.size().height))
        zRotation  = 0
        
        // Value
        value = Int.random(in: 1 ... Enemy.MAX_VALUE)
            
        // Random Speed
        vYVariation = CGFloat.random(in: 0.2 ... 0.7)
        
        width      = texture!.size().width
        height     = texture!.size().height
        aSize      = width! > height! ? width! : height!
        radius     = aSize! * 0.5
        
        // Velocity
        if position.x < GameScene.FIRST_QUARTER_WIDTH {
            vX = CGFloat.random(in: 0...0.5)
        } else if position.x > GameScene.LAST_QUARTER_WIDTH {
            vX = -CGFloat.random(in: 0...0.5)
        } else {
            vX = CGFloat.random(in: 0...1) * Enemy.X_VARIATION - Enemy.X_VARIATION * 0.5
        }
        vY        = CGFloat.random(in: Enemy.MIN_SPEED_Y...Enemy.MIN_SPEED_Y + 1.5) * vYVariation
        zRotation = Enemy.HALF_PI - atan2(vY, vX)
        
        lastShotY = 0
    }
    
    func respawn() -> Void {
        texture = Enemy.ENEMY_IMAGES[Int.random(in: 0 ..< 3)]
        initialize()
    }
    
    func update() -> Void {
        position.x += vX
        position.y -= vY
        
        // Respawn enemy
        if(position.x < (CGFloat(GameScene.MIN_X) - aSize!) || (position.x - radius!) > CGFloat(GameScene.MAX_X) || (position.y - height!) < CGFloat(GameScene.MAX_Y)) {
            respawn();
        }
    }
}

class EnemyBoss: SKSpriteNode {
    private static let HALF_PI           : Double      = Double.pi / 2.0
    private static let ENEMY_BOSS_IMAGES : [SKTexture] = [
        SKTexture.init(image: UIImage.init(named: "enemyBoss0.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "enemyBoss1.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "enemyBoss2.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "enemyBoss3.png")!.scale(with: CGSize(width: 100, height: 100))!),
        SKTexture.init(image: UIImage.init(named: "enemyBoss4.png")!.scale(with: CGSize(width: 100, height: 100))!)
    ]
    private static let MAX_VALUE         : Int         = 100
    private static let X_VARIATION       : Double      = 1
    private static let MIN_SPEED_Y       : CGFloat     = 3
    private        var image             : SKTexture   = EnemyBoss.ENEMY_BOSS_IMAGES[4]
    public  static let WIDTH             : CGFloat     = 100
    public  static let HEIGHT            : CGFloat     = 100
    public  static let SIZE              : CGFloat     = 100
    public  static let RADIUS            : CGFloat     = 50
    public         var vX                : CGFloat     = 0
    public         var vY                : CGFloat     = 0
    private        var vYVariation       : CGFloat     = 0.2
    public         var value             : Int         = 1
    public         var lastShotY         : CGFloat     = 0
    public         var hits              : Int         = 5 {
        didSet {
            switch hits {
                case 5 : texture = EnemyBoss.ENEMY_BOSS_IMAGES[4]
                case 4 : texture = EnemyBoss.ENEMY_BOSS_IMAGES[3]
                case 3 : texture = EnemyBoss.ENEMY_BOSS_IMAGES[2]
                case 2 : texture = EnemyBoss.ENEMY_BOSS_IMAGES[1]
                case 1 : texture = EnemyBoss.ENEMY_BOSS_IMAGES[0]
                default: texture = EnemyBoss.ENEMY_BOSS_IMAGES[4]
            }
        }
    }
    public         var toBeRemoved       : Bool        = false
    
    
    init() {
        super.init(texture: image, color: UIColor.clear, size: image.size())
        self.isUserInteractionEnabled = false
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Position
        position.x = CGFloat(Double.random(in: GameScene.MIN_X ..< GameScene.MAX_X))
        position.y = CGFloat(GameScene.MIN_Y + Double(texture!.size().height))
        zRotation  = 0
        
        // Value
        value = Int.random(in: 1 ... EnemyBoss.MAX_VALUE)
            
        // Random Speed
        vYVariation = CGFloat.random(in: 0.2 ... 0.7)
        
        // Velocity
        if position.x < GameScene.FIRST_QUARTER_WIDTH {
            vX = CGFloat.random(in: 0...0.5)
        } else if position.x > GameScene.LAST_QUARTER_WIDTH {
            vX = -CGFloat.random(in: 0...0.5)
        } else {
            vX = CGFloat((Double.random(in: 0...1) * EnemyBoss.X_VARIATION) - EnemyBoss.X_VARIATION * 0.5)
        }
        vY        = CGFloat.random(in: EnemyBoss.MIN_SPEED_Y...EnemyBoss.MIN_SPEED_Y + 1.5) * vYVariation
        zRotation = CGFloat(EnemyBoss.HALF_PI) - atan2(vY, vX)
        
        lastShotY = 0
        
        hits = 5
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y -= vY
            
            // Respawn enemy
            if(position.x < (CGFloat(GameScene.MIN_X) - EnemyBoss.SIZE) || position.x - EnemyBoss.RADIUS > CGFloat(GameScene.MAX_X) || (position.y - EnemyBoss.HEIGHT) < CGFloat(GameScene.MAX_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class EnemyTorpedo: SKSpriteNode {
    private static let HALF_PI     : Double    = Double.pi / 2.0
    private static let IMAGE       : SKTexture = SKTexture.init(image: UIImage.init(named: "enemyTorpedo.png")!)
    private static let WIDTH       : CGFloat    = IMAGE.size().width
    public  static let HEIGHT      : CGFloat    = IMAGE.size().height
    private static let SIZE        : CGFloat    = IMAGE.size().width > IMAGE.size().height ? IMAGE.size().width : IMAGE.size().height
    public  static let RADIUS      : CGFloat    = SIZE * 0.5
    private        var vX          : CGFloat   = 0
    private        var vY          : CGFloat   = 5
    public         var toBeRemoved : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        super.init(texture: EnemyTorpedo.IMAGE, color: UIColor.clear, size: EnemyTorpedo.IMAGE.size())
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y -= vY
            
            if((position.y - EnemyTorpedo.HEIGHT) < CGFloat(GameScene.MAX_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class EnemyBossTorpedo: SKSpriteNode {
    private static let HALF_PI     : Double    = Double.pi / 2.0
    private static let IMAGE       : SKTexture = SKTexture.init(image: UIImage.init(named: "enemyBossTorpedo.png")!)
    private static let WIDTH       : CGFloat   = IMAGE.size().width
    public  static let HEIGHT      : CGFloat   = IMAGE.size().height
    private static let SIZE        : CGFloat   = IMAGE.size().width > IMAGE.size().height ? IMAGE.size().width : IMAGE.size().height
    public  static let RADIUS      : CGFloat   = SIZE * 0.5
    private        var vX          : CGFloat   = 0
    private        var vY          : CGFloat   = 0
    public         var toBeRemoved : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        super.init(texture: EnemyBossTorpedo.IMAGE, color: UIColor.clear, size: EnemyBossTorpedo.IMAGE.size())
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y -= vY
            
            if((position.y - EnemyBossTorpedo.HEIGHT) < CGFloat(GameScene.MAX_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class SpaceShip: SKSpriteNode {
    public  static let SPACE_SHIP_SIZE       : CGFloat   = 48
    public  static let DEFLECTOR_SHIELD_SIZE : CGFloat   = 100
    private static let SPACE_SHIP_IMG        : SKTexture = SKTexture.init(image: UIImage.init(named: "fighter.png")!)
    private static let SPACE_SHIP_THRUST_IMG : SKTexture = SKTexture.init(image: UIImage.init(named: "fighterThrust.png")!)
    public         var width                 : CGFloat   = CGFloat(SPACE_SHIP_SIZE)
    public         var height                : CGFloat   = CGFloat(SPACE_SHIP_SIZE)
    private        var aSize                 : Double    = Double(SPACE_SHIP_SIZE)
    public         var radius                : CGFloat   = CGFloat(SPACE_SHIP_SIZE / 2.0)
    public         var vX                    : CGFloat   = 0
    public         var vY                    : CGFloat   = 0
    public         var hasBeenHit            : Bool      = false
    public         var shield                : Bool      = false {
        didSet {
            if shield {
                width  = SpaceShip.DEFLECTOR_SHIELD_SIZE
                height = SpaceShip.DEFLECTOR_SHIELD_SIZE
                aSize  = Double(SpaceShip.DEFLECTOR_SHIELD_SIZE)
                radius = SpaceShip.DEFLECTOR_SHIELD_SIZE / 2.0
            } else {
                width  = SpaceShip.SPACE_SHIP_SIZE
                height = SpaceShip.SPACE_SHIP_SIZE
                aSize  = Double(SpaceShip.SPACE_SHIP_SIZE)
                radius = SpaceShip.SPACE_SHIP_SIZE / 2.0
            }
        }
    }


    init() {
        super.init(texture: SpaceShip.SPACE_SHIP_IMG, color: UIColor.clear, size: SpaceShip.SPACE_SHIP_IMG.size())
        self.isUserInteractionEnabled = false
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initialize() -> Void {
        position.x = 0
        position.y = CGFloat(-GameScene.HEIGHT * 0.4)
        hasBeenHit = false
        vX         = 0
        vY         = 0
        shield     = false
    }
    
    public func respawn() -> Void {
        initialize()
    }
    
    public func isMoving(isMoving: Bool) -> Void {
        texture = isMoving ? SpaceShip.SPACE_SHIP_THRUST_IMG : SpaceShip.SPACE_SHIP_IMG
    }
    
    public func update() -> Void {
        position.x += vX
        position.y -= vY
        if (position.x + SpaceShip.SPACE_SHIP_SIZE > CGFloat(GameScene.MAX_X)) {
            position.x = CGFloat(GameScene.MAX_X) - SpaceShip.SPACE_SHIP_SIZE
        }
        if (position.x - SpaceShip.SPACE_SHIP_SIZE < CGFloat(GameScene.MIN_X)) {
            position.x = CGFloat(GameScene.MIN_X) + SpaceShip.SPACE_SHIP_SIZE
        }
        if (position.y < CGFloat(-GameScene.HEIGHT * 0.35)) {
            position.y = CGFloat(-GameScene.HEIGHT * 0.35)
        }
        if (position.y + SpaceShip.SPACE_SHIP_SIZE > CGFloat(GameScene.MIN_Y)) {
            position.y = CGFloat(GameScene.MIN_Y) - SpaceShip.SPACE_SHIP_SIZE
        }
    }
}

class Shield: SKSpriteNode {
    private static let SPACE_SHIP_SIZE       : CGFloat   = 48
    private static let DEFLECTOR_SHIELD_SIZE : CGFloat   = 100
    private static let DELTA_SIZE            : CGFloat   = (DEFLECTOR_SHIELD_SIZE / 2.0) - (SPACE_SHIP_SIZE / 2.0)
    private static let DEFLECTOR_SHIELD_IMG  : SKTexture = SKTexture.init(image: UIImage.init(named: "deflectorshield.png")!.scale(with: CGSize(width: DEFLECTOR_SHIELD_SIZE, height: DEFLECTOR_SHIELD_SIZE))!)
    public  static let WIDTH                 : CGFloat   = DEFLECTOR_SHIELD_SIZE
    public  static let HEIGHT                : CGFloat   = DEFLECTOR_SHIELD_SIZE
    private static let SIZE                  : CGFloat   = DEFLECTOR_SHIELD_SIZE
    public  static let RADIUS                : CGFloat   = SIZE / 2.0
    public         var vX                    : CGFloat   = 0
    public         var vY                    : CGFloat   = 0
    

    init() {
        super.init(texture: Shield.DEFLECTOR_SHIELD_IMG, color: UIColor.clear, size: Shield.DEFLECTOR_SHIELD_IMG.size())
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update() -> Void {
        position.x += vX
        position.y -= vY
        if (position.x + Shield.WIDTH - Shield.SPACE_SHIP_SIZE > CGFloat(GameScene.MAX_X)) {
            position.x = CGFloat(GameScene.MAX_X) - Shield.WIDTH + Shield.SPACE_SHIP_SIZE
        }
        if (position.x - Shield.WIDTH + Shield.SPACE_SHIP_SIZE < CGFloat(GameScene.MIN_X)) {
            position.x = CGFloat(GameScene.MIN_X) + Shield.WIDTH - Shield.SPACE_SHIP_SIZE
        }
        if (position.y < CGFloat(-GameScene.HEIGHT * 0.35)) {
            position.y = CGFloat(-GameScene.HEIGHT * 0.35)
        }
        if (position.y + Shield.HEIGHT - Shield.SPACE_SHIP_SIZE > CGFloat(GameScene.MIN_Y)) {
            position.y = CGFloat(GameScene.MIN_Y) - Shield.HEIGHT + Shield.SPACE_SHIP_SIZE
        }
    }
}

class Torpedo: SKSpriteNode {
    private static let HALF_PI     : Double    = Double.pi / 2.0
    private static let IMAGE       : SKTexture = SKTexture.init(image: UIImage.init(named: "torpedo.png")!.scale(with: CGSize(width: 17, height: 20))!)
    private static let WIDTH       : CGFloat   = IMAGE.size().width
    public  static let HEIGHT      : CGFloat   = IMAGE.size().height
    private static let SIZE        : CGFloat   = IMAGE.size().width > IMAGE.size().height ? IMAGE.size().width : IMAGE.size().height
    public  static let RADIUS      : CGFloat   = SIZE * 0.5
    private        var vX          : CGFloat   = 0
    private        var vY          : CGFloat   = 6
    public         var toBeRemoved : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat) {
        super.init(texture: Torpedo.IMAGE, color: UIColor.clear, size: Torpedo.IMAGE.size())
        self.position.x               = x
        self.position.y               = y
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y += vY
            
            if((position.y + Torpedo.HEIGHT) > CGFloat(GameScene.MIN_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class Rocket: SKSpriteNode {
    private static let HALF_PI     : Double    = Double.pi / 2.0
    private static let IMAGE       : SKTexture = SKTexture.init(image: UIImage.init(named: "rocket.png")!.scale(with: CGSize(width: 17, height: 50))!)
    private static let WIDTH       : CGFloat   = IMAGE.size().width
    public  static let HEIGHT      : CGFloat   = IMAGE.size().height
    private static let SIZE        : CGFloat   = IMAGE.size().width > IMAGE.size().height ? IMAGE.size().width : IMAGE.size().height
    public  static let RADIUS      : CGFloat   = SIZE * 0.5
    private        var vX          : CGFloat   = 0
    private        var vY          : CGFloat   = 4
    public         var toBeRemoved : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat) {
        super.init(texture: Rocket.IMAGE, color: UIColor.clear, size: Rocket.IMAGE.size())
        self.position.x               = x
        self.position.y               = y
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            position.x += vX
            position.y += vY
            
            if((position.y + Rocket.HEIGHT) > CGFloat(GameScene.MIN_Y)) {
                toBeRemoved = true
            }
        }
    }
}

class Explosion: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 5
    private static let MAX_FRAME_Y  : Int       = 4
    private static let FRAME_SIZE   : Double    = 192
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "explosion.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: Explosion.MAX_FRAME_Y, cols: Explosion.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double) {
        super.init(texture: Explosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: Explosion.FRAME_SIZE, height: Explosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.setScale(CGFloat(scale))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = Explosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == Explosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == Explosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
}

class Hit: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 5
    private static let MAX_FRAME_Y  : Int       = 2
    private static let FRAME_SIZE   : Double    = 80
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "torpedoHit2.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: Hit.MAX_FRAME_Y, cols: Hit.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        super.init(texture: Hit.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: Hit.FRAME_SIZE, height: Hit.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = Hit.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == Hit.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == Hit.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
}

class EnemyBossHit: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 5
    private static let MAX_FRAME_Y  : Int       = 2
    private static let FRAME_SIZE   : Double    = 80
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "torpedoHit.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: EnemyBossHit.MAX_FRAME_Y, cols: EnemyBossHit.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat) {
        super.init(texture: EnemyBossHit.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: EnemyBossHit.FRAME_SIZE, height: EnemyBossHit.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = EnemyBossHit.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == EnemyBossHit.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == EnemyBossHit.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
}

class AsteroidExplosion: SKSpriteNode {
    private static let MAX_FRAME_X : Int       = 8
    private static let MAX_FRAME_Y : Int       = 7
    private static let FRAME_SIZE  : Double    = 256
    private static let IMAGE       : SKTexture = SKTexture.init(image: UIImage.init(named: "asteroidExplosion.png")!)
    private static let SPRITE_MAP  : SpriteMap = SpriteMap.init(texture: IMAGE, rows: AsteroidExplosion.MAX_FRAME_Y, cols: AsteroidExplosion.MAX_FRAME_X)
    private        var countX      : Int       = 0
    private        var countY      : Int       = 0
    private        var vX          : CGFloat   = 0
    private        var vY          : CGFloat   = 0
    public         var toBeRemoved : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double) {
        super.init(texture: AsteroidExplosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: AsteroidExplosion.FRAME_SIZE, height: AsteroidExplosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
        self.setScale(CGFloat(scale))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            texture = AsteroidExplosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == AsteroidExplosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == AsteroidExplosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
    
}

class RocketExplosion: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 4
    private static let MAX_FRAME_Y  : Int       = 7
    private static let FRAME_SIZE   : Double    = 256
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "rocketExplosion.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: RocketExplosion.MAX_FRAME_Y, cols: RocketExplosion.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double) {
        super.init(texture: RocketExplosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: RocketExplosion.FRAME_SIZE, height: RocketExplosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
        self.setScale(CGFloat(scale))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = RocketExplosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == RocketExplosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == RocketExplosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
}

class CrystalExplosion: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 4
    private static let MAX_FRAME_Y  : Int       = 7
    private static let FRAME_SIZE   : Double    = 256
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "crystalExplosion.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: CrystalExplosion.MAX_FRAME_Y, cols: CrystalExplosion.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double) {
        super.init(texture: CrystalExplosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: CrystalExplosion.FRAME_SIZE, height: CrystalExplosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
        self.setScale(CGFloat(scale))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = CrystalExplosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == CrystalExplosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == CrystalExplosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
}

class SpaceShipExplosion: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 8
    private static let MAX_FRAME_Y  : Int       = 6
    private static let FRAME_SIZE   : Double    = 100
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "spaceshipexplosion.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: SpaceShipExplosion.MAX_FRAME_Y, cols: SpaceShipExplosion.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    private        var spaceShip    : SpaceShip?
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double, spaceShip: SpaceShip) {
        super.init(texture: SpaceShipExplosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: SpaceShipExplosion.FRAME_SIZE, height: SpaceShipExplosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
        self.spaceShip                = spaceShip
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() -> Void {
        if !toBeRemoved {
            texture = SpaceShipExplosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == SpaceShipExplosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == SpaceShipExplosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                    spaceShip?.respawn()                    
                }
            }
            position.x += vX
            position.y += vY
        }
    }
}

class EnemyBossExplosion: SKSpriteNode {
    private static let MAX_FRAME_X  : Int       = 4
    private static let MAX_FRAME_Y  : Int       = 7
    private static let FRAME_SIZE   : Double    = 256
    private static let IMAGE        : SKTexture = SKTexture.init(image: UIImage.init(named: "enemyBossExplosion.png")!)
    private static let SPRITE_MAP   : SpriteMap = SpriteMap.init(texture: IMAGE, rows: EnemyBossExplosion.MAX_FRAME_Y, cols: EnemyBossExplosion.MAX_FRAME_X)
    private        var countX       : Int       = 0
    private        var countY       : Int       = 0
    private        var vX           : CGFloat   = 0
    private        var vY           : CGFloat   = 0
    public         var toBeRemoved  : Bool      = false
    
    
    init(x: CGFloat, y: CGFloat, vX: CGFloat, vY: CGFloat, scale: Double) {
        super.init(texture: EnemyBossExplosion.SPRITE_MAP.textureForColumn(col: 0, row: 0), color: UIColor.clear, size: CGSize(width: EnemyBossExplosion.FRAME_SIZE, height: EnemyBossExplosion.FRAME_SIZE))
        self.position.x               = x
        self.position.y               = y
        self.vX                       = vX
        self.vY                       = vY
        self.isUserInteractionEnabled = false
        self.blendMode                = .screen
        self.setScale(CGFloat(scale))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        if !toBeRemoved {
            texture = EnemyBossExplosion.SPRITE_MAP.textureForColumn(col: countX, row: countY)
            countX += 1
            if countX == EnemyBossExplosion.MAX_FRAME_X {
                countX = 0
                countY += 1
                if countY == EnemyBossExplosion.MAX_FRAME_Y {
                    countY = 0
                }
                if countX == 0 && countY == 0 {
                    toBeRemoved = true
                }
            }
            position.x += vX
            position.y -= vY
        }
    }
    
}


class SpriteMap {
    let texture               : SKTexture
    let rows                  : Int
    let cols                  : Int
    let frameSizePX           : CGSize
    let frameWidthPercentage  : CGFloat
    let frameHeightPercentage : CGFloat

    
    init(texture: SKTexture, rows: Int, cols: Int) {
        self.texture               = texture
        self.rows                  = rows
        self.cols                  = cols
        self.frameSizePX           = CGSize.init(width: texture.size().width / CGFloat(cols), height: texture.size().height / CGFloat(rows))
        self.frameWidthPercentage  = frameSizePX.width / texture.size().width
        self.frameHeightPercentage = frameSizePX.height / texture.size().height
    }

    
    public func textureForColumn(col: Int, row: Int) -> SKTexture? {
        if !(0...rows ~= row && 0...cols ~= col) {
            return nil
        }

        let textureRect = CGRect(x: CGFloat(col) * frameWidthPercentage,
                                 y: CGFloat(row) * frameHeightPercentage,
                                 width: frameWidthPercentage,
                                 height: frameHeightPercentage)
        
        return SKTexture(rect: textureRect, in: texture)
    }
}
