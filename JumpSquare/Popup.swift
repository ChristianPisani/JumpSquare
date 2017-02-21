//
//  Popup.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 11.07.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit

class Popup: SKSpriteNode {
    
    func Pop(_ distance : CGFloat, duration : CGFloat) {
        self.run(SKAction.move(by: CGVector(dx: 0, dy: distance), duration: TimeInterval(duration)),
                       completion: { self.Bounce() } )
    }
    
    func Pop(_ distance : CGFloat, duration : CGFloat, text : String) {
        let label = SKLabelNode(text: text)
        label.fontColor = UIColor.black
        self.addChild(label)
        
        self.run(SKAction.move(by: CGVector(dx: 0, dy: distance), duration: TimeInterval(duration)),
                       completion: { self.Bounce() } )
        
    }
    
    fileprivate func Bounce() {
        self.run(SKAction.move(by: CGVector(dx: 0, dy: -6), duration: TimeInterval(0.1)),
                       completion: { self.Fade() } )
    }
    
    fileprivate func Fade() {
        self.run(SKAction.fadeOut(withDuration: TimeInterval(1)))
        self.run(SKAction.move(by: CGVector(dx: 0, dy: 30), duration: TimeInterval(0.8)),
                       completion: { self.removeFromParent() } )
    }
}
