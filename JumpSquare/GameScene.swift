//
//  GameScene.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 31.01.2016.
//  Copyright (c) 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK : Properties
    
    var pointAwarded = false
    var score = 0
    var highScore = HighScore(highScore: 0)
    var obsSpeed : CGFloat = -240
    var playerSpawnOffSet : CGFloat = 150
    var screen : CGRect = UIScreen.mainScreen().bounds
    var screenUnAltered : CGRect = UIScreen.mainScreen().bounds
    
    
    
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
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("highscore")
    
    // MARK : Other stuff
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let screenSize : SKSpriteNode = self.childNodeWithName("ScreenSize") as! SKSpriteNode
        screenSize.size.width = screen.size.width * 1.35 // seems to work OK to get size of actual screen
        screenSize.size.height = screen.size.height * 1.35
        screenSize.color = UIColor(red: 200, green: 0, blue: 0, alpha: 0.3)
        screenSize.removeFromParent()
        
        screen.origin = screenSize.frame.origin
        screen.size = screenSize.size
        
        labelLose = self.childNodeWithName("LoseScreen") as! SKLabelNode
        labelLoseScore = self.childNodeWithName("LoseScore") as! SKLabelNode
        labelLoseScoreInt = self.childNodeWithName("LoseScoreInt") as! SKLabelNode
        labelTryAgain = self.childNodeWithName("TryAgainLabel") as! SKLabelNode
        labelPointsFrom = self.childNodeWithName("PointsFrom") as! SKLabelNode
        
        labelLose.zPosition = -2
        labelLoseScore.zPosition = -2
        labelLoseScoreInt.zPosition = -2
        labelTryAgain.zPosition = -2
        labelPointsFrom.zPosition = -2
        
        labelStartStay = self.childNodeWithName("StartScreen") as! SKLabelNode
        labelStartTut = self.childNodeWithName("Tutorial") as! SKLabelNode
        labelStartTutTap = self.childNodeWithName("TutorialTap") as! SKLabelNode
        labelStartTap = self.childNodeWithName("TapToStart") as! SKLabelNode
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
        
        let checkHighScore = LoadHighScore()
        if(checkHighScore != nil) {
            highScore = checkHighScore
        }
        setScoreLabels()
        
        player = self.childNodeWithName("Player") as! SKSpriteNode
        //player.name = "Player"
        //player.color = UIColor(red: 255, green: 0, blue: 0, alpha: 255)
        //player.size = CGSize(width: 60, height: 100)
        //player.position = CGPoint(x:CGRectGetMidX(self.frame) - playerSpawnOffSet, y:CGRectGetMidY(self.frame))
        //player.physicsBody = SKPhysicsBody(rectangleOfSize:player.frame.size);
        player.physicsBody!.restitution = -1.0
        //player.shadowCastBitMask = 1
        //player.physicsBody?.allowsRotation = false
        
        //self.addChild(player)
        
        JumpArrow = player.childNodeWithName("JumpVector") as! SKSpriteNode
        
        obs.name = "Obstacle"
        obs.color = UIColor(red: 0, green: 0, blue: 0, alpha: 255)
        obs.size = CGSize(width: 30, height: 40)
        obs.position = CGPoint(x:CGRectGetMidX(self.frame) + 7000, y:CGRectGetMidY(self.frame))
        obs.physicsBody = SKPhysicsBody(rectangleOfSize:obs.frame.size);
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
        obs2.position = CGPoint(x:CGRectGetMidX(self.frame) + 7000, y:CGRectGetMidY(self.frame))
        obs2.physicsBody = SKPhysicsBody(rectangleOfSize:obs2.frame.size);
        obs2.physicsBody!.restitution = 0.0
        obs2.physicsBody?.velocity.dx = obsSpeed
        obs2.physicsBody?.friction = 0.0
        obs2.physicsBody!.mass = 200.0
        obs2.physicsBody?.linearDamping = 0.0
        obs2.shadowCastBitMask = 1
        obs2.physicsBody?.allowsRotation = false
        
        self.addChild(obs2)
        
        face = player.childNodeWithName("Face") as! SKSpriteNode
        
        ground = self.childNodeWithName("Ground") as! SKSpriteNode
        
        self.view!.multipleTouchEnabled = false;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let touchBegan = SKSpriteNode()
            touchBegan.name = "touchBegan"
            touchBegan.position = location
            touchBegan.color = UIColor(red: 255, green: 0, blue: 0, alpha: 0)
            touchBegan.size = CGSize(width: 20, height: 20)
            self.addChild(touchBegan)
            
            JumpArrow.zPosition = 1
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchBegan = self.childNodeWithName("touchBegan") as! SKSpriteNode
            
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
                    
                    
                    
                    let dragVector = CGVector(dx: -(touch.locationInNode(self).x - touchBegan.position.x)*0.5,
                        dy: -(touch.locationInNode(self).y - touchBegan.position.y)*1.0)
                    
                    JumpArrow.size.height = (sqrt(dragVector.dy*dragVector.dy + dragVector.dx*dragVector.dx))/4
                    
                    let JumpArrowNormalized = normalize(double2(Double(dragVector.dx), Double(dragVector.dy)))
                    
                    JumpArrow.zRotation = -atan2(CGFloat(JumpArrowNormalized.x), CGFloat(JumpArrowNormalized.y))
                    //JumpArrow.position.x = touchBegan.position.x
            }
        }
    }
    
    func setPlayerPhysicsBody() {
        player.physicsBody = SKPhysicsBody(rectangleOfSize:player.frame.size);
        player.physicsBody!.restitution = 0.0
        //player.physicsBody?.allowsRotation = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchBegan = self.childNodeWithName("touchBegan")
            
            if(!showLoseScreen  && !showStartScreen) {
                if(player.position.y - (player.frame.height/2) <= 4 + ground.position.y + (ground.size.height/2)) {
                    player.size.height = playerHeight
                    player.size.width = playerWidth
                    
                    let dragVector = CGVector(dx: -(touch.locationInNode(self).x - touchBegan!.position.x)*0.5,
                        dy: -(touch.locationInNode(self).y - touchBegan!.position.y)*1.0)
                    
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
                paused = false
                
                player.position = CGPoint(x:CGRectGetMidX(self.frame) - playerSpawnOffSet, y:CGRectGetMidY(self.frame))
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
   
    override func update(currentTime: CFTimeInterval) {
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

            obs.physicsBody = SKPhysicsBody(rectangleOfSize:obs.frame.size);
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
            
            obs2.physicsBody = SKPhysicsBody(rectangleOfSize:obs2.frame.size);
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
                let bg = self.childNodeWithName("Background") as! SKSpriteNode;
                
                var newColor = bg.color
                var newBgColorHex = bgColorHex
                
                while(bgColorHex == newBgColorHex) {
                    let rnd : Int = Int(arc4random_uniform(UInt32(bgColors.count-1)))
                    newBgColorHex = bgColors[rnd]
                }
                
                newColor = colorWithHexString(newBgColorHex)
                bgColorHex = newBgColorHex
                let changeColorAction = SKAction.colorizeWithColor(newColor, colorBlendFactor: 1.0, duration: 0.5)
                bg.runAction(changeColorAction)
                
                //bg.color = newColor;
                
                jumpedThrough = 0
            }
        }
        
        if(!screen.contains(player.position)) {
            player.position = CGPoint(x: 1000, y: CGRectGetMidY(self.frame))
            player.physicsBody?.velocity.dx = 0
            player.zRotation = 0.0
            player.physicsBody?.angularVelocity = 0.0
            player.physicsBody?.velocity.dy = 0
            player.physicsBody!.affectedByGravity = false
            
            obs.position.x = 10000
            obs2.position.x = 10000
            
            paused = true
            
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
            
            let touchBegan = self.childNodeWithName("TouchBegan")
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
            face.blendMode = .Alpha
        } else {
            face.texture = SKTexture(imageNamed: "Smile")
            face.blendMode = .Alpha
        }
        
        if(player.zRotation < CGFloat(M_PI/2) + 1.0 && player.zRotation > CGFloat(M_PI/2) - 1.0 ||
            (player.zRotation < CGFloat(M_PI/2 + 1.0 - M_PI) && player.zRotation > CGFloat(M_PI/2 - 1.0 - M_PI))) {
            face.texture = SKTexture(imageNamed: "SadFace")
            face.blendMode = .Alpha
        }
    }
    
    // MARK : Scores
    
    func setScoreLabels() {
        let scrLabel = self.childNodeWithName("Score") as! SKLabelNode
        //let player = self.childNodeWithName("Player")
        
        scrLabel.text = String(score)
        //scrLabel.text = String(player?.position)
        
        let highScrLabel = self.childNodeWithName("HighScore") as! SKLabelNode
        highScrLabel.text = String(highScore!.highScore)
        //highScrLabel.text = String(screen)
    }
    
    func SaveHighScore() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(highScore!, toFile: HighScore.ArchiveURL.path!)
        
        if(!isSuccessfulSave) {
            print("Failed to save")
        }
        
    }
    
    func LoadHighScore() -> HighScore? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(HighScore.ArchiveURL.path!) as? HighScore
    }
    
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
