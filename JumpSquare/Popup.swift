//
//  Popup.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 11.07.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit

class Popup: SKSpriteNode {
    
    func Pop(distance : CGFloat, duration : CGFloat) {
        self.runAction(SKAction.moveBy(CGVector(dx: 0, dy: distance), duration: NSTimeInterval(duration)),
                       completion: { self.Bounce() } )
    }
    
    func Pop(distance : CGFloat, duration : CGFloat, text : String) {
        let label = SKLabelNode(text: text)
        label.fontColor = UIColor.blackColor()
        self.addChild(label)
        
        self.runAction(SKAction.moveBy(CGVector(dx: 0, dy: distance), duration: NSTimeInterval(duration)),
                       completion: { self.Bounce() } )
        
    }
    
    private func Bounce() {
        self.runAction(SKAction.moveBy(CGVector(dx: 0, dy: -6), duration: NSTimeInterval(0.1)),
                       completion: { self.Fade() } )
    }
    
    private func Fade() {
        self.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(1)))
        self.runAction(SKAction.moveBy(CGVector(dx: 0, dy: 30), duration: NSTimeInterval(0.8)),
                       completion: { self.removeFromParent() } )
    }
}