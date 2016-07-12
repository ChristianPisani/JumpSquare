//
//  Button.swift
//  ButtonTest
//
//  Created by Christian Thorvik on 21.06.2016.
//  Copyright © 2016 Devfish. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    var pressed = false
    var clicked = false
    
    var touchBegan = CGPoint()
    var touchEnded = CGPoint()
    var touchHasEnded = false
    
    var baseColor = UIColor()
    var pressedColor : UIColor?
    var clickedColor : UIColor?
    
    //remember to call this in viewdidload
    func loaded() {
        baseColor = self.color
    }
    
    //remember to call this in touchesbegan
    func touchesBegan(touches: Set<UITouch>, view: SKNode) {
        if(hidden) {
            return
        }
        
        for touch in touches {
            touchBegan = touch.locationInNode(view)
        }
    }
    
    //remember to call this in touchesended
    func touchesEnded(touches: Set<UITouch>, view: SKNode) {
        if(hidden) {
            return
        }
        
        for touch in touches {
            touchEnded = touch.locationInNode(view)
            touchHasEnded = true
        }
    }
    
    //remember to call this in update
    func update() {
        if(hidden) {
            return
        }
        
        if(self.frame.contains(touchBegan)) {
            self.pressed = true
        } else {
            self.pressed = false
        }
        
        if(pressed && self.frame.contains(touchEnded)) {
            self.clicked = true
        } else {
            self.clicked = false
        }
        
        if(touchHasEnded) {
            touchHasEnded = false
            touchBegan = CGPoint()
            touchEnded = CGPoint()
        }
        
        if(pressedColor != nil && pressed) {
            color = pressedColor!
        }
        
        if(clickedColor != nil && clicked) {
            color = clickedColor!
        }
        
        if(!pressed && !clicked) {
            color = baseColor
        }
    }
}
