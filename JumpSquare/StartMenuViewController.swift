//
//  StartMenuViewController.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 12.07.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class StartMenuViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var animationSKView: SKView!
    @IBOutlet weak var obs1pos: UIImageView!
    @IBOutlet weak var obs2pos: UIImageView!
    @IBOutlet weak var playerPos: UIImageView!
    @IBOutlet weak var GoogleAdBannerView: GADBannerView!
    
    var scene = SKScene(size: CGSize.zero)
    
    var playerIcon = SKSpriteNode()
    var obs1 = SKSpriteNode()
    var obs2 = SKSpriteNode()
    
    let spaceBetweenObstacles : CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = SKScene(size: animationSKView.frame.size)
        animationSKView.showsFPS = false
        animationSKView.showsNodeCount = false
        animationSKView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        animationSKView.presentScene(scene)
        animationSKView.scene!.backgroundColor = animationSKView.backgroundColor!
        
        obs1.size = CGSize(width: obs1pos.frame.width, height: animationSKView.frame.height/2 - spaceBetweenObstacles/2)
        obs2.size = CGSize(width: obs2pos.frame.width, height: animationSKView.frame.height/2 - spaceBetweenObstacles/2)
        
        playerIcon = SKSpriteNode(color: UIColor.redColor(), size: playerPos.bounds.size)
        playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
        playerIcon.runAction(SKAction.moveTo(CGPoint(x: self.view.frame.midX, y: playerPos.bounds.minY),
            duration: NSTimeInterval(0)))
        
        obs1.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY), duration: NSTimeInterval(0)))
        obs1.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.minX - 100, y: obs1pos.frame.midY), duration: NSTimeInterval(1)),
                       completion: { self.AnimatePlayer() })
        obs2.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY), duration: NSTimeInterval(0)))
        obs2.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.minX - 100, y: obs2pos.frame.midY), duration: NSTimeInterval(1)))
        
        animationSKView.scene?.addChild(obs1)
        animationSKView.scene?.addChild(obs2)
        animationSKView.scene?.addChild(playerIcon)
        
        //AnimatePlayer()
    }
    
    func AwardPoint() {
        let popup = Popup()
        popup.position = CGPoint(x: 0, y: (obs2.frame.height/2) + (obs1.frame.minY - obs2.frame.maxY)/2 - 10)
        popup.size = CGSize(width: 20, height: 20)
        popup.Pop(20, duration: 0.3, text: "+1")
        obs2.addChild(popup)
    }
    
    func AnimatePlayer() {
        obs1.runAction(SKAction.waitForDuration(NSTimeInterval(1.3)), completion: { self.AwardPoint() })
        
        obs1.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY + spaceBetweenObstacles/4), duration: NSTimeInterval(0)))
        obs2.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.maxX, y: obs2pos.frame.midY - spaceBetweenObstacles/4), duration: NSTimeInterval(0)))
        
        obs1.color = UIColor.blackColor()
        obs2.color = UIColor.blackColor()
        
        obs1.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.minX - 10, y: obs1pos.frame.midY + spaceBetweenObstacles/4), duration: NSTimeInterval(3)))
        obs2.runAction(SKAction.moveTo(CGPoint(x: animationSKView.frame.minX - 10, y: obs2pos.frame.midY - spaceBetweenObstacles/4), duration: NSTimeInterval(3)))
        
        obs1.runAction(SKAction.waitForDuration(NSTimeInterval(4)), completion: { self.AnimatePlayer() })
        
        let duration = 0.8
        playerIcon.runAction(SKAction.resizeToHeight(playerIcon.frame.height - 20, duration: duration))
        playerIcon.runAction(SKAction.waitForDuration(NSTimeInterval(duration)), completion: { self.JumpPlayer() })
        playerIcon.runAction(SKAction.waitForDuration(NSTimeInterval(duration + 1)),
                             completion: { self.playerIcon.runAction(SKAction.moveTo(CGPoint(x: self.view.frame.midX, y: self.playerPos.bounds.minY),
            duration: NSTimeInterval(0.3))) })
    }
    
    func JumpPlayer() {
        playerIcon.runAction(SKAction.resizeToHeight(playerPos.bounds.height, duration: NSTimeInterval(0)))
        playerIcon.runAction(SKAction.moveTo(CGPoint(x: self.view.frame.midX,
            y: (obs2.frame.midY + obs1.frame.midY)/2 - (playerIcon.frame.height/2)), duration: NSTimeInterval(0.3)))
    }
}
