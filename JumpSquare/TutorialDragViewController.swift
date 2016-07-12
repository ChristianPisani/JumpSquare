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
    let playerIcon = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 60, height: 100))
    
    var playerPos = CGPoint.zero
    var pointerSize = CGSize.zero
    
    
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerPos = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 140)
        pointerSize = CGSize(width: 50, height: 50)
        
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
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
                skView.scene!.backgroundColor = self.view.backgroundColor!
     
        scene.addChild(arrow)
        scene.addChild(pointer)
        scene.addChild(playerIcon)
        
        movePointer(1, from: CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 80),
                    to: CGPoint(x: self.view.frame.midX - 40, y: self.view.frame.midY + 40), completion:  { return } )
    }
    
    @IBAction func onStepperChanged(sender: AnyObject) {
        pageLabel.text = "Page " + String(Int(stepper.value))
        arrow.removeAllActions()
        playerIcon.removeAllActions()
        pointer.removeAllActions()
        scene.removeAllChildren()
        
        switch Int(stepper.value) {
        case 1:
            textView.text = "Drag to change the direction and strength of your jump"
            
            pointer.size = CGSize(width: 50, height: 50)
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
            
            pointer.size = CGSize(width: 50, height: 50)
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
        default:
            return
        }
    }
    
    
    func movePointer(duration : CGFloat, from : CGPoint, to : CGPoint, completion: () -> Void) {
        arrow.size.height = 0
        arrow.size.width = 0
        playerIcon.size.height = 100
        playerIcon.position = playerPos
        pointer.alpha = 1
        arrow.alpha = 1
        pointer.size = pointerSize
        
        pointer.position = CGPoint(x: from.x, y: from.y)
        pointer.runAction(SKAction.moveTo(CGPoint(x: to.x, y: to.y),
            duration: NSTimeInterval(duration)), completion: { completion() } )
        pointer.runAction(SKAction.waitForDuration(NSTimeInterval(2)), completion: { self.movePointer(duration, from: from, to: to, completion: completion) } )
        arrow.runAction(SKAction.resizeToHeight(80, duration: NSTimeInterval(duration)))
        arrow.runAction(SKAction.resizeToWidth(60, duration: NSTimeInterval(duration)))
        playerIcon.runAction(SKAction.resizeToHeight(60, duration: NSTimeInterval(duration)))
    }
    
    func PlayerJumpWithPointer(duration : CGFloat) {
        pointer.runAction(SKAction.resizeToWidth(pointer.size.width + 20, height: pointer.size.height + 20,
            duration: NSTimeInterval(duration)))
        pointer.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(duration)))
        arrow.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(0)))
        
        PlayerJump()
    }
    
    func PlayerJump() {
        playerIcon.runAction(SKAction.resizeToHeight(100, duration: NSTimeInterval(0)))
        playerIcon.runAction(SKAction.moveBy(CGVector(dx: 0, dy: 40), duration: NSTimeInterval(0.3)))
    }
}
