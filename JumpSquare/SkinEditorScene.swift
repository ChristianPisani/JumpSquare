//
//  SkinEditorScene.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 06.06.2017.
//  Copyright © 2017 Christian Thorvik. All rights reserved.
//

import UIKit
import SpriteKit

class SkinEditorScene: SKScene {

    var hats = [SKSpriteNode]()
    
    var arrow_hat_right = SKSpriteNode()
    var arrow_hat_left = SKSpriteNode()
    var player = SKSpriteNode()
    
    var animating = false
    
    var colors : [UIColor] = [.red, .blue, .purple, .black, .white]
    var hatIndex = 0
    
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    
    lazy var hatSelector : RollingSelector = {
        let height = self.player.frame.height*0.15
        let width = self.player.frame.width+4
        return RollingSelector(player: self.player, view: self.view!, name: "hat",
                               offsetY: (self.player.frame.height/2) - height,
                               size: CGSize(width: width, height: width))
    }()
    
    lazy var coatSelector : RollingSelector = {
        return RollingSelector(player: self.player, view: self.view!, name: "coat",
                               offsetY: -(self.player.frame.height/2),
                               size: CGSize(width: self.player.frame.width, height: self.player.frame.height * 0.55))
    }()
    
    override func didMove(to view: SKView) {
        let playerWidth = view.bounds.width/2
        player = SKSpriteNode(color: .red, size: CGSize(width: playerWidth, height: playerWidth*1.5))
        player.position.x = frame.midX
        player.position.y = frame.midY
        addChild(player);
        
        let face = SKSpriteNode(imageNamed: "Smile")
        let smilesize = playerWidth*0.8
        face.size = CGSize(width: smilesize, height: smilesize)
        face.position = CGPoint(x: 10, y: player.frame.height/6)
        player.addChild(face)
        
        //setUpHats()
        let h = hatSelector
        //let c = coatSelector
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: player)
            
            let touchBegan = SKSpriteNode()
            touchBegan.name = "touchBegan"
            touchBegan.position = location
            touchBegan.color = UIColor(red: 255, green: 0, blue: 0, alpha: 0)
            touchBegan.size = CGSize(width: 20, height: 20)
            self.addChild(touchBegan)
            
            if(hatSelector.arrow_left.frame.contains(location)) {
                hatSelector.arrow_left_clicked()
            }
            
            if(hatSelector.arrow_right.frame.contains(location)) {
                hatSelector.arrow_right_clicked()
            }
            
            if(coatSelector.arrow_left.frame.contains(location)) {
                coatSelector.arrow_left_clicked()
            }
            
            if(coatSelector.arrow_right.frame.contains(location)) {
                coatSelector.arrow_right_clicked()
            }
        }
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        if(hatSelector.containsPoint(point: swipeRight.location(in: view))) {
            hatSelector.arrow_right_clicked()
        }
        
        if(coatSelector.containsPoint(point: swipeRight.location(in: view))) {
            coatSelector.arrow_right_clicked()
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        if(hatSelector.containsPoint(point: swipeLeft.location(in: view))) {
            hatSelector.arrow_left_clicked()
        }
        
        if(coatSelector.containsPoint(point: swipeLeft.location(in: view))) {
            coatSelector.arrow_left_clicked()
        }
    }
}
