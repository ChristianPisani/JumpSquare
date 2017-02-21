//
//  GameScene.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 31.01.2016.
//  Copyright (c) 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameScene: SKScene {
    
    // MARK : Properties
    
    var pointAwarded = false
    var score = 0
    var highScore = HighScore(highScore: 0)
    var obsSpeed : CGFloat = -240
    var playerSpawnOffSet : CGFloat = 150
    var screen : CGRect = UIScreen.main.bounds
    var screenUnAltered : CGRect = UIScreen.main.bounds
    
    
    
    var bronze = 6
    var silver = 15
    var gold = 20
    
    let bgColors: [String] = ["#FFBA08", "#3F88C5", "#1CC000", "#FFDDA1", "#B2DDF7", "#BD7E69", "#E99B9B", "#1098F7",
                              "#E8EBF7", "#F2D398"]
    
    var bgColorHex : String = ""
    
    var obs : SKSpriteNode = SKSpriteNode()
    var obs2 : SKSpriteNode = SKSpriteNode()
    var player : SKSpriteNode = SKSpriteNode()
    var ground : SKSpriteNode = SKSpriteNode()
    var face : SKSpriteNode = SKSpriteNode()
    var JumpArrow : SKSpriteNode = SKSpriteNode()
    
    var playerHeight : CGFloat = 100
    var playerWidth : CGFloat = 60
    
    var jumpedThrough = 0
    var numberOfJumpsBeforeColorChange = 3
    
    var labelLose : SKLabelNode = SKLabelNode()
    var labelLoseScore : SKLabelNode = SKLabelNode()
    var labelLoseScoreInt : SKLabelNode = SKLabelNode()
    var labelTryAgain : SKLabelNode = SKLabelNode()
    var labelPointsFrom : SKLabelNode = SKLabelNode()
    
    var labelStartStay : SKLabelNode = SKLabelNode()
    var labelStartTut : SKLabelNode = SKLabelNode()
    var labelStartTutTap : SKLabelNode = SKLabelNode()
    var labelStartTap : SKLabelNode = SKLabelNode()
    
    var showStartScreen = true
    var showLoseScreen = false
    
    let spaceBetweenObstacles : CGFloat = 200.0
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("highscore")
    
    // MARK : Other stuff
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        let screenSize : SKSpriteNode = self.childNode(withName: "ScreenSize") as! SKSpriteNode
        screenSize.size.width = screen.size.width * 1.35 // seems to work OK to get size of actual screen
        screenSize.size.height = screen.size.height * 1.35
        screenSize.color = UIColor(red: 200, green: 0, blue: 0, alpha: 0.3)
        screenSize.removeFromParent()
        
        screen.origin = screenSize.frame.origin
        screen.size = screenSize.size
        
        labelLose = self.childNode(withName: "LoseScreen") as! SKLabelNode
        labelLoseScore = self.childNode(withName: "LoseScore") as! SKLabelNode
        labelLoseScoreInt = self.childNode(withName: "LoseScoreInt") as! SKLabelNode
        labelTryAgain = self.childNode(withName: "TryAgainLabel") as! SKLabelNode
        labelPointsFrom = self.childNode(withName: "PointsFrom") as! SKLabelNode
        
        labelLose.zPosition = -2
        labelLoseScore.zPosition = -2
        labelLoseScoreInt.zPosition = -2
        labelTryAgain.zPosition = -2
        labelPointsFrom.zPosition = -2
        
        labelStartStay = self.childNode(withName: "StartScreen") as! SKLabelNode
        labelStartTut = self.childNode(withName: "Tutorial") as! SKLabelNode
        labelStartTutTap = self.childNode(withName: "TutorialTap") as! SKLabelNode
        labelStartTap = self.childNode(withName: "TapToStart") as! SKLabelNode
        labelStartStay.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        labelStartTut.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        labelStartTutTap.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        labelStartTap.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        
        
        let label = SKLabelNode()
        label.text = "Score:"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 300)
        label.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        label.fontSize = 20
        label.fontName = "Helvetica Neue Light"
        self.addChild(label)
        
        let scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.midX + 60, y: self.frame.midY + 300)
        scoreLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "Helvetica Neue Light"
        scoreLabel.text = String(score)
        scoreLabel.name = "Score"
        self.addChild(scoreLabel)
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.text = "Highscore: "
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 325)
        highScoreLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        highScoreLabel.fontSize = 20
        highScoreLabel.fontName = "Helvetica Neue Light"
        self.addChild(highScoreLabel)
        
        let highScoreLabelRef = SKLabelNode()
        highScoreLabelRef.text = "0"
        highScoreLabelRef.position = CGPoint(x: self.frame.midX + 60, y: self.frame.midY + 325)
        highScoreLabelRef.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        highScoreLabelRef.fontSize = 20
        highScoreLabelRef.fontName = "Helvetica Neue Light"
        highScoreLabelRef.name = "HighScore"
        self.addChild(highScoreLabelRef)
        
        NSLog("Loading highscore")
        
        let checkHighScore = LoadHighScore()
        if(checkHighScore != nil) {
            highScore = checkHighScore
        }
        setScoreLabels()
        
        player = self.childNode(withName: "Player") as! SKSpriteNode
        //player.name = "Player"
        //player.color = UIColor(red: 255, green: 0, blue: 0, alpha: 255)
        //player.size = CGSize(width: 60, height: 100)
        //player.position = CGPoint(x:CGRectGetMidX(self.frame) - playerSpawnOffSet, y:CGRectGetMidY(self.frame))
        //player.physicsBody = SKPhysicsBody(rectangleOfSize:player.frame.size);
        player.physicsBody!.restitution = -1.0
        //player.shadowCastBitMask = 1
        //player.physicsBody?.allowsRotation = false
        
        //self.addChild(player)
        
        JumpArrow = player.childNode(withName: "JumpVector") as! SKSpriteNode
        
        obs.name = "Obstacle"
        obs.color = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        obs.size = CGSize(width: 30, height: 40)
        obs.position = CGPoint(x:self.frame.midX + 7000, y:self.frame.midY)
        obs.physicsBody = SKPhysicsBody(rectangleOf:obs.frame.size);
        obs.physicsBody!.restitution = 0.0
        obs.physicsBody?.velocity.dx = obsSpeed
        obs.physicsBody?.friction = 0.0
        obs.physicsBody!.mass = 200.0
        obs.physicsBody?.linearDamping = 0.0
        obs.shadowCastBitMask = 1
        obs.physicsBody?.allowsRotation = false
        
        self.addChild(obs)
        
        obs2.name = "Obstacle2"
        obs2.color = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        obs2.size = CGSize(width: 30, height: 2000)
        obs2.position = CGPoint(x:self.frame.midX + 7000, y:self.frame.midY)
        obs2.physicsBody = SKPhysicsBody(rectangleOf:obs2.frame.size);
        obs2.physicsBody!.restitution = 0.0
        obs2.physicsBody?.velocity.dx = obsSpeed
        obs2.physicsBody?.friction = 0.0
        obs2.physicsBody!.mass = 200.0
        obs2.physicsBody?.linearDamping = 0.0
        obs2.shadowCastBitMask = 1
        obs2.physicsBody?.allowsRotation = false
        
        self.addChild(obs2)
        
        face = player.childNode(withName: "Face") as! SKSpriteNode
        
        ground = self.childNode(withName: "Ground") as! SKSpriteNode
        
        self.view!.isMultipleTouchEnabled = false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let touchBegan = SKSpriteNode()
            touchBegan.name = "touchBegan"
            touchBegan.position = location
            touchBegan.color = UIColor(red: 255, green: 0, blue: 0, alpha: 0)
            touchBegan.size = CGSize(width: 20, height: 20)
            self.addChild(touchBegan)
            
            JumpArrow.zPosition = 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchBegan = self.childNode(withName: "touchBegan") as! SKSpriteNode
            
            let playerIsOnGround = (player.position.y - (player.frame.height/2) <= 6 + ground.position.y + (ground.size.height/2))
            let playerIsNotRotated = (player.zRotation < 1 && player.zRotation > -1)
            let playerIsNotRotating = (player.physicsBody?.angularVelocity < 0.0001 && player.physicsBody?.angularVelocity > -0.0001)
           
            if(playerIsOnGround && playerIsNotRotated && playerIsNotRotating) {
                
                    player.zRotation = 0.0
                    
                    setPlayerPhysicsBody()
                    
                    player.size.height =  (playerHeight - ((touchBegan.position.y - location.y) / 15))
                    
                    if(player.size.height > playerHeight) {
                        player.size.height = playerHeight
                    }
                    
                    player.position.y -= playerHeight - player.size.height;
                    
                    setPlayerPhysicsBody()
                    
                    
                    
                    let dragVector = CGVector(dx: -(touch.location(in: self).x - touchBegan.position.x)*0.5,
                        dy: -(touch.location(in: self).y - touchBegan.position.y)*1.0)
                    
                    JumpArrow.size.height = (sqrt(dragVector.dy*dragVector.dy + dragVector.dx*dragVector.dx))/4
                    
                    let JumpArrowNormalized = normalize(double2(Double(dragVector.dx), Double(dragVector.dy)))
                    
                    JumpArrow.zRotation = -atan2(CGFloat(JumpArrowNormalized.x), CGFloat(JumpArrowNormalized.y))
                    //JumpArrow.position.x = touchBegan.position.x
            }
        }
    }
    
    func setPlayerPhysicsBody() {
        player.physicsBody = SKPhysicsBody(rectangleOf:player.frame.size);
        player.physicsBody!.restitution = 0.0
        //player.physicsBody?.allowsRotation = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchBegan = self.childNode(withName: "touchBegan")
            
            if(!showLoseScreen  && !showStartScreen) {
                if(player.position.y - (player.frame.height/2) <= 4 + ground.position.y + (ground.size.height/2)) {
                    player.size.height = playerHeight
                    player.size.width = playerWidth
                    
                    let dragVector = CGVector(dx: -(touch.location(in: self).x - touchBegan!.position.x)*0.5,
                        dy: -(touch.location(in: self).y - touchBegan!.position.y)*1.0)
                    
                    if(((player.zRotation < 0.01 && player.zRotation > -0.01) ||
                        (player.zRotation < CGFloat((M_PI) + 0.01) && player.zRotation > CGFloat((M_PI) - 0.01))) &&
                        (player.physicsBody?.angularVelocity < 0.0001 && player.physicsBody?.angularVelocity > -0.0001)) {
                            setPlayerPhysicsBody()
                    }
                    
                    if(dragVector.dy < 10 && dragVector.dx < 10 &&
                        player.physicsBody?.angularVelocity < 0.01 && player.physicsBody?.angularVelocity > -0.01 ) {
                        if((player.zRotation < CGFloat(M_PI/2+0.1) && player.zRotation > CGFloat(M_PI/2-0.1))) {
                            player.physicsBody?.applyAngularImpulse(-0.28)
                        }
                        
                        if((player.zRotation > -CGFloat(M_PI/2+0.1) && player.zRotation < -CGFloat(M_PI/2-0.1))) {
                            player.physicsBody?.applyAngularImpulse(0.28)
                        }
                    }
                    
                    if(!(player.zRotation < CGFloat(M_PI/2+0.1) && player.zRotation > CGFloat(M_PI/2-0.1))) &&
                       !((player.zRotation > -CGFloat(M_PI/2+0.1) && player.zRotation < -CGFloat(M_PI/2-0.1))) {
                        player.physicsBody?.angularVelocity = 0
                        player.physicsBody!.applyImpulse(dragVector)
                    } else {
                        let onlyXVector = CGVector(dx: dragVector.dx, dy: 0.0)
                        player.physicsBody!.applyImpulse(onlyXVector)
                    }
                }
            } else {
                showLoseScreen = false
                showStartScreen = false
                isPaused = false
                
                player.position = CGPoint(x:self.frame.midX - playerSpawnOffSet, y:self.frame.midY)
                setPlayerPhysicsBody()
                player.physicsBody?.velocity.dx = 0
                player.zRotation = CGFloat(0)
                player.physicsBody?.angularVelocity = 0.0
                player.physicsBody?.velocity.dy = 0
                player.physicsBody!.affectedByGravity = true
                player.size.height = playerHeight
                
                jumpedThrough = 0
                
                setScoreLabels()
            }
            
            JumpArrow.zPosition = -2
            JumpArrow.size.height = 0
            touchBegan?.removeFromParent()
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        //setScoreLabels()
        if(showLoseScreen || showStartScreen) {
            return
        }
        
        if(obs.position.x > self.frame.size.width || obs.position.x < 0) &&
          (obs2.position.x > self.frame.size.width || obs2.position.x < 0) {
            
            obs.position.x = self.frame.size.width

            obs.size.height = CGFloat(arc4random_uniform(UInt32(screen.size.height/CGFloat(3.5))) + 100)
            //obs.size.height = screen.height/2

            obs.physicsBody = SKPhysicsBody(rectangleOf:obs.frame.size);
            obs.physicsBody!.velocity.dx = obsSpeed
            obs.zRotation = 0
            obs.physicsBody!.angularVelocity = 0
            obs.position.y = ground.position.y + (ground.size.height/2) + (obs.size.height/2)
            
            obs.physicsBody!.allowsRotation = false;
            obs.physicsBody!.restitution = 0.0
            obs.physicsBody!.friction = 0.0
            obs.physicsBody!.mass = 100.0
            obs.physicsBody!.linearDamping = 0.0
            obs.physicsBody!.affectedByGravity = false
            obs.physicsBody!.collisionBitMask = ground.physicsBody!.collisionBitMask
  
            
            obs2.position.x = self.frame.size.width
            
            //obs2.size.height = screen.height - obs.size.height - 100
            
            obs2.physicsBody = SKPhysicsBody(rectangleOf:obs2.frame.size);
            obs2.physicsBody!.allowsRotation = false
            obs2.physicsBody!.restitution = 0.0
            obs2.physicsBody!.velocity.dx = obsSpeed
            obs2.physicsBody!.friction = 0.0
            obs2.physicsBody!.mass = 100.0
            obs2.physicsBody!.linearDamping = 0.0
            obs2.zRotation = 0
            obs2.physicsBody!.angularVelocity = 0
            obs2.physicsBody!.affectedByGravity = false
            obs2.physicsBody!.collisionBitMask = ground.physicsBody!.collisionBitMask
            
            obs2.position.y = obs.position.y + obs.size.height/2 + obs2.size.height/2 + spaceBetweenObstacles
            
            pointAwarded = false
        }
        
        // MARK : Award points
        if(obs.position.x < player.position.x && !pointAwarded) {
            score += 1
            
            if(score > highScore?.highScore) {
                highScore?.highScore = score
                SaveHighScore()
            }
            
            setScoreLabels()
            
            pointAwarded = true
            
            jumpedThrough += 1
            if(jumpedThrough >= numberOfJumpsBeforeColorChange) {
                let bg = self.childNode(withName: "Background") as! SKSpriteNode;
                
                var newColor = bg.color
                var newBgColorHex = bgColorHex
                
                while(bgColorHex == newBgColorHex) {
                    let rnd : Int = Int(arc4random_uniform(UInt32(bgColors.count-1)))
                    newBgColorHex = bgColors[rnd]
                }
                
                newColor = colorWithHexString(newBgColorHex)
                bgColorHex = newBgColorHex
                let changeColorAction = SKAction.colorize(with: newColor, colorBlendFactor: 1.0, duration: 0.5)
                bg.run(changeColorAction)
                
                //bg.color = newColor;
                
                jumpedThrough = 0
            }
        }
        
        if(!screen.contains(player.position)) {
            player.position = CGPoint(x: 1000, y: self.frame.midY)
            player.physicsBody?.velocity.dx = 0
            player.zRotation = 0.0
            player.physicsBody?.angularVelocity = 0.0
            player.physicsBody?.velocity.dy = 0
            player.physicsBody!.affectedByGravity = false
            
            obs.position.x = 10000
            obs2.position.x = 10000
            
            isPaused = true
            
            if(score < bronze) {
                labelLose.text = "You lost"
                labelPointsFrom.text = "Points from bronze: " + String(bronze - score)
            } else if(score < silver) {
                labelLose.text = "You got bronze!"
                labelPointsFrom.text = "Points from silver: " + String(silver - score)
            } else if(score < gold) {
                labelLose.text = "You got silver!"
                labelPointsFrom.text = "Points from gold: " + String(gold - score)
            } else {
                labelLose.text = "You got gold!"
                labelPointsFrom.text = "You're the best!";
            }
            
            
            score = 0
            
            let touchBegan = self.childNode(withName: "TouchBegan")
            touchBegan?.removeFromParent()
            
            showLoseScreen = true
        }
        
        if(showLoseScreen) {
            labelLose.zPosition = 2
            labelLoseScore.zPosition = 2
            labelLoseScoreInt.zPosition = 2
            labelTryAgain.zPosition = 2
            labelPointsFrom.zPosition = 2
            
        } else {
            labelLose.zPosition = -2
            labelLoseScore.zPosition = -2
            labelLoseScoreInt.zPosition = -2
            labelLoseScoreInt.text = String(score)
            labelTryAgain.zPosition = -2
            labelPointsFrom.zPosition = -2
        }
        
        if(showStartScreen) {
            labelStartStay.zPosition = 2
            labelStartTap.zPosition = 2
            labelStartTutTap.zPosition = 2
            labelStartTut.zPosition = 2
        } else {
            labelStartStay.zPosition = -2
            labelStartTap.zPosition = -2
            labelStartTutTap.zPosition = -2
            labelStartTut.zPosition = -2
        }
        
        //let scrLabel = self.childNodeWithName("Score") as! SKLabelNode
        //scrLabel.text = String(player!.position.x - screen.width)
        
        if(player.physicsBody?.velocity.dy > 10.0 &&
            !(player.position.y - (player.frame.height/2) <= 10 + ground.position.y + (ground.size.height/2))) {
            face.texture = SKTexture(imageNamed: "Smile2")
            face.blendMode = .alpha
        } else {
            face.texture = SKTexture(imageNamed: "Smile")
            face.blendMode = .alpha
        }
        
        if(player.zRotation < CGFloat(M_PI/2) + 1.0 && player.zRotation > CGFloat(M_PI/2) - 1.0 ||
            (player.zRotation < CGFloat(M_PI/2 + 1.0 - M_PI) && player.zRotation > CGFloat(M_PI/2 - 1.0 - M_PI))) {
            face.texture = SKTexture(imageNamed: "SadFace")
            face.blendMode = .alpha
        }
    }
    
    // MARK : Scores
    
    func setScoreLabels() {
        let scrLabel = self.childNode(withName: "Score") as! SKLabelNode
        //let player = self.childNodeWithName("Player")
        
        scrLabel.text = String(score)
        //scrLabel.text = String(player?.position)
        
        let highScrLabel = self.childNode(withName: "HighScore") as! SKLabelNode
        highScrLabel.text = String(highScore!.highScore)
        //highScrLabel.text = String(screen)
    }
    
    func SaveHighScore() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(highScore, toFile: HighScore.ArchiveURL.path)
        
        if(!isSuccessfulSave) {
            print("Failed to save")
        }
        
    }
    
    func LoadHighScore() -> HighScore? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: HighScore.ArchiveURL.path) as? HighScore
    }
    
    
    func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
