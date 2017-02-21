//
//  TutorialDragViewController.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 11.07.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit

class TutorialDragViewController: UIViewController {
    
    var scene = SKScene(size: CGSize.zero)
    
    let pointer = SKSpriteNode(imageNamed: "pointer")
    let arrow = SKSpriteNode(imageNamed: "Arrow")
    let playerIcon = SKSpriteNode(color: UIColor.red, size: CGSize(width: 60, height: 100))
    var obs1 = SKSpriteNode()
    var obs2 = SKSpriteNode()
    
    var playerPos = CGPoint.zero
    var pointerSize = CGSize.zero
    
    
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var obs1Pos: UIImageView!
    @IBOutlet weak var obs2Pos: UIImageView!
    @IBOutlet weak var tutView: UIView!
    
    let spaceBetweenObstacles : CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerPos = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
        pointerSize = CGSize(width: 50, height: 50)
        
        obs1 = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20,
            height: obs2Pos.frame.height))
        obs2 = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20, height: obs2Pos.frame.height))
        
        pointer.size = pointerSize
        arrow.size = CGSize(width: 50, height: 0)
        arrow.position = CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 100)
        arrow.anchorPoint = CGPoint(x: 1, y: 1)
        arrow.zRotation = -0.85
        playerIcon.position = playerPos
        playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
    
        scene = SKScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
                skView.scene!.backgroundColor = self.view.backgroundColor!
     
        scene.addChild(arrow)
        scene.addChild(pointer)
        scene.addChild(playerIcon)
        
        movePointer(1, from: CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 80),
                    to: CGPoint(x: self.view.frame.midX - 40, y: self.view.frame.midY + 40), completion:  { return } )
    }
    
    @IBAction func onStepperChanged(_ sender: AnyObject) {
        pageLabel.text = "Page " + String(Int(stepper.value))
        arrow.removeAllActions()
        playerIcon.removeAllActions()
        pointer.removeAllActions()
        obs1.removeAllActions()
        obs2.removeAllActions()
        scene.removeAllChildren()
        
        playerIcon.size = CGSize(width: 60, height: 100)
        playerIcon.zRotation = 0
        
        switch Int(stepper.value) {
        case 1:
            textView.text = "Drag to change the direction and strength of your jump"
            
            pointer.size = pointerSize
            arrow.size = CGSize(width: 50, height: 0)
            arrow.position = CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 100)
            arrow.anchorPoint = CGPoint(x: 1, y: 1)
            arrow.zRotation = -0.85
            playerIcon.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
            playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            scene.addChild(arrow)
            scene.addChild(pointer)
            scene.addChild(playerIcon)
            
            movePointer(1, from: CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 80),
                        to: CGPoint(x: self.view.frame.midX - 40, y: self.view.frame.midY + 40), completion:  { return } )
        case 2:
            textView.text = "Let go after dragging to make the player jump"
            
            pointer.size = pointerSize
            arrow.size = CGSize(width: 50, height: 0)
            arrow.position = CGPoint(x: self.view.frame.midX - 5, y: self.view.frame.midY + 110)
            arrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            arrow.zRotation = 0.0
            playerIcon.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
            playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            scene.addChild(arrow)
            scene.addChild(pointer)
            scene.addChild(playerIcon)
            
            movePointer(1, from: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 80),
                        to: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 40),
                        completion: { self.PlayerJumpWithPointer(0.5) } )
        case 3:
            textView.text = "If you fall, you can tap anywhere on the screen to get back up again"
            
            playerIcon.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
            playerIcon.anchorPoint = CGPoint(x: 0, y: 0)
            playerIcon.zRotation = CGFloat(GLKMathDegreesToRadians(90.0))
            
            scene.addChild(pointer)
            scene.addChild(playerIcon)
            
            clickPointer(0.5, from: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 80),
                        to: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 80),
                        completion: { self.PlayerRotate(0.5) } )
        case 4:
            textView.text = "The goal of the game is to jump through the hoops"
            //textView.text = String(textView.frame.height)
            
            playerIcon.position = CGPoint(x: self.view.frame.midX - 20, y: obs2Pos.frame.minY + (playerIcon.size.height/2.0) + 1)
            playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
            playerIcon.zRotation = 0
            playerIcon.size = CGSize(width: 40, height: 60)
            
            scene.addChild(playerIcon)
            scene.addChild(obs1)
            scene.addChild(obs2)
            
            playerHoop(2)
        case 5:
            textView.text = "Remember that you can always move to the sides to get more space"
            
            pointer.size = pointerSize
            arrow.size = CGSize(width: 50, height: 0)
            arrow.position = CGPoint(x: self.view.frame.midX - 50, y: self.view.frame.midY + 110)
            arrow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            arrow.zRotation = 1.0
            playerIcon.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
            playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            scene.addChild(arrow)
            scene.addChild(pointer)
            scene.addChild(playerIcon)
            
            self.PlayerSlide(0.5)
        default:
            return
        }
    }
    
    func PlayerSlide(_ duration : CGFloat) {
        textView.text = "Remember that you can always move to the sides to get more space"
        
        pointer.alpha = 1
        pointer.size = pointerSize
        playerIcon.position = CGPoint(x: self.view.frame.midX + 25, y: self.view.frame.midY - 140)
        
        playerIcon.run(SKAction.rotate(toAngle: 0,
            duration: TimeInterval(0)))
        
        pointer.position = CGPoint(x: self.view.frame.midX - 25, y: self.view.frame.midY + 110)
        pointer.run(SKAction.move(by: CGVector(dx: 50, dy: 0), duration: TimeInterval(duration)))
        
        pointer.run(SKAction.wait(forDuration: TimeInterval(duration)), completion:
            { self.pointer.run(SKAction.fadeOut(withDuration: TimeInterval(duration))) } )
        
        pointer.run(SKAction.wait(forDuration: TimeInterval(duration)), completion:
            { self.pointer.run(SKAction.resize(byWidth: self.pointerSize.width + 20, height: self.pointerSize.height + 20, duration: TimeInterval(duration))) } )
        
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration)),
                             completion: { self.playerIcon.run(SKAction.move(by: CGVector(dx: -50, dy: 0), duration: TimeInterval(duration)),
                             completion: { self.playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration + 1)),
                                completion: { self.PlayerSlideDown(duration) } ) } ) } )
    }
    
    func PlayerSlideDown(_ duration : CGFloat) {
        textView.text = "Even if you're downed"
        
        pointer.alpha = 1
        pointer.size = pointerSize
        
        playerIcon.run(SKAction.rotate(toAngle: CGFloat(GLKMathDegreesToRadians(90)),
            duration: TimeInterval(0)))
        
        playerIcon.position = CGPoint(x: self.view.frame.midX + 25 + playerIcon.size.height/2, y: self.view.frame.midY - 140 + playerIcon.size.width / 2)
        
        pointer.position = CGPoint(x: self.view.frame.midX - 25, y: self.view.frame.midY + 110)
        pointer.run(SKAction.move(by: CGVector(dx: 50, dy: 0), duration: TimeInterval(duration)))
        
        pointer.run(SKAction.wait(forDuration: TimeInterval(duration)), completion:
            { self.pointer.run(SKAction.fadeOut(withDuration: TimeInterval(duration))) } )
        
        pointer.run(SKAction.wait(forDuration: TimeInterval(duration)), completion:
            { self.pointer.run(SKAction.resize(byWidth: self.pointerSize.width + 20, height: self.pointerSize.height + 20, duration: TimeInterval(duration))) } )
        
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration)),
                             completion: { self.playerIcon.run(SKAction.move(by: CGVector(dx: -50, dy: 0), duration: TimeInterval(duration)),
                                completion: { self.playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration + 0.5)),
                                    completion: { self.PlayerSlide(duration) } ) } ) } )
    }
    
    func playerHoop(_ duration : CGFloat) {
        moveObstacles(duration)
    }
    
    func AwardPoint() {
        let popup = Popup()
        popup.position = CGPoint(x: 10, y: obs2.frame.height/2 + (obs1.frame.minY - obs2.frame.maxY)/2)
        popup.size = CGSize(width: 20, height: 20)
        popup.Pop(20, duration: 0.3, text: "+1")
        obs2.addChild(popup)
    }
    
    func moveObstacles(_ duration : CGFloat) {
        //playerIcon.position = CGPoint(x: self.view.frame.midX - 20,
        //                              y: obs2Pos.frame.origin.y + (obs2Pos.frame.height/2))
        
        //tutView.bounds.size.height = self.view.frame.height - textView.frame.height - 64
            
        obs1.size = CGSize(width: obs1Pos.frame.width, height: tutView.frame.height/2 - spaceBetweenObstacles/2)
        obs2.size = CGSize(width: obs2Pos.frame.width, height: tutView.frame.height/2 - spaceBetweenObstacles/2)
        
        obs1.run(SKAction.wait(forDuration: TimeInterval(1.3)), completion: { self.AwardPoint() })
        
        obs1.run(SKAction.move(to: CGPoint(x: tutView.frame.maxX, y: tutView.frame.maxY + spaceBetweenObstacles/4), duration: TimeInterval(0)))
        obs2.run(SKAction.move(to: CGPoint(x: tutView.frame.maxX, y: tutView.frame.minY + obs2.frame.height), duration: TimeInterval(0)), completion: {
            self.playerIcon.run(SKAction.move(to: CGPoint(x: self.playerIcon.frame.midX, y: self.obs2.frame.minY), duration: TimeInterval(0))) } )
        
        obs1.color = UIColor.black
        obs2.color = UIColor.black
        
        obs1.run(SKAction.move(to: CGPoint(x: tutView.frame.minX - 10, y: tutView.frame.maxY + spaceBetweenObstacles/4), duration: TimeInterval(3)))
        obs2.run(SKAction.move(to: CGPoint(x: tutView.frame.minX - 10, y: tutView.frame.minY + obs2.frame.height), duration: TimeInterval(3)))
        
        obs1.run(SKAction.wait(forDuration: TimeInterval(4)), completion: { self.moveObstacles(duration) })
        
        let duration = 0.8
        playerIcon.run(SKAction.resize(toHeight: playerIcon.frame.height - 20, duration: duration))
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration)), completion: {
            self.PlayerJump(0, playerHeight: 60) })
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration + 1.2)),
                             completion: { self.playerIcon.run(SKAction.move(to: CGPoint(x: self.playerIcon.frame.midX, y: self.obs2.frame.minY),
                                duration: TimeInterval(0.3))) })
    }
    
    func clickPointer(_ duration : CGFloat, from : CGPoint, to : CGPoint, completion: @escaping () -> Void) {
        playerIcon.size.height = 100
        playerIcon.position = CGPoint(x: playerPos.x - playerIcon.size.width/2, y: playerPos.y)
        pointer.alpha = 1
        pointer.size = CGSize(width: pointerSize.width + 20, height: pointerSize.width + 20)
        
        playerIcon.run(SKAction.rotate(toAngle: CGFloat(GLKMathDegreesToRadians(90)),
            duration: TimeInterval(0)))
        
        pointer.position = CGPoint(x: from.x, y: from.y)
        pointer.run(SKAction.move(to: CGPoint(x: to.x, y: to.y),
            duration: TimeInterval(duration)), completion: { completion() } )
        pointer.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { self.clickPointer(duration, from: from, to: to, completion: completion) } )
        pointer.run(SKAction.resize(toWidth: pointerSize.width, height: pointerSize.height, duration: TimeInterval(duration)))
    }
    
    func movePointer(_ duration : CGFloat, from : CGPoint, to : CGPoint, completion: @escaping () -> Void) {
        arrow.size.height = 0
        arrow.size.width = 0
        playerIcon.size.height = 100
        playerIcon.position = playerPos
        pointer.alpha = 1
        arrow.alpha = 1
        pointer.size = pointerSize
        
        pointer.position = CGPoint(x: from.x, y: from.y)
        pointer.run(SKAction.move(to: CGPoint(x: to.x, y: to.y),
            duration: TimeInterval(duration)), completion: { completion() } )
        pointer.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { self.movePointer(duration, from: from, to: to, completion: completion) } )
        arrow.run(SKAction.resize(toHeight: 80, duration: TimeInterval(duration)))
        arrow.run(SKAction.resize(toWidth: 60, duration: TimeInterval(duration)))
        playerIcon.run(SKAction.resize(toHeight: 60, duration: TimeInterval(duration)))
    }
    
    func PlayerJumpWithPointer(_ duration : CGFloat) {
        pointer.run(SKAction.resize(toWidth: pointer.size.width + 20, height: pointer.size.height + 20,
            duration: TimeInterval(duration)))
        pointer.run(SKAction.fadeOut(withDuration: TimeInterval(duration)))
        arrow.run(SKAction.fadeOut(withDuration: TimeInterval(0)))
        
        PlayerJump(40, playerHeight: 100)
    }
    
    func PlayerJump(_ height : CGFloat, playerHeight: CGFloat) {
        playerIcon.run(SKAction.resize(toHeight: playerHeight, duration: TimeInterval(0)))
        playerIcon.run(SKAction.move(to: CGPoint(x: playerIcon.frame.midX,
            y: (tutView.frame.midY + tutView.frame.midY)/2 + playerIcon.frame.height), duration: TimeInterval(0.3)))
    }
    
    func PlayerRotate(_ duration : CGFloat) {
        playerIcon.run(SKAction.rotate(toAngle: 0, duration: TimeInterval(duration)))
    }
}
