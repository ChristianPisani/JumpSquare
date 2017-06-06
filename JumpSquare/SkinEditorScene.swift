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

    var hat : SKSpriteNode = SKSpriteNode()
    
    var arrow_hat_right = SKSpriteNode()
    var arrow_hat_left = SKSpriteNode()
    var player = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        let playerWidth = view.bounds.width/4
        player = SKSpriteNode(color: .red, size: CGSize(width: playerWidth, height: playerWidth*1.5))
        player.position.x = frame.midX
        player.position.y = frame.midY
        addChild(player);
        
        hat = SKSpriteNode(imageNamed: "Arrow_shaft")
        hat.size = CGSize(width: playerWidth + 4, height: 25)
        hat.position = CGPoint(x: 0, y: 45)
        player.addChild(hat)
        
        var dst : CGFloat = 20 //Distance from player
        arrow_hat_right = SKSpriteNode(imageNamed: "Arrow_head")
        arrow_hat_right.position = CGPoint(x: player.frame.width/2 + dst, y: 0)
        arrow_hat_right.size = CGSize(width: 20, height: 20)
        arrow_hat_right.zRotation = -(.pi / 2)
        arrow_hat_left = SKSpriteNode(imageNamed: "Arrow_head")
        arrow_hat_left.position = CGPoint(x: -player.frame.width/2 - dst, y: 0)
        arrow_hat_left.size = CGSize(width: 20, height: 20)
        arrow_hat_left.zRotation = .pi / 2
        player.addChild(arrow_hat_right)
        player.addChild(arrow_hat_left)
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
            
            if(arrow_hat_left.frame.contains(location)) {
                arrow_hat_left_clicked()
            }
            
            if(arrow_hat_right.frame.contains(location)) {
                arrow_hat_right_clicked()
            }
        }
    }
    
    func arrow_hat_right_clicked() {
        hat.run(SKAction.move(by: CGVector(dx: 50, dy: 0), duration: TimeInterval(1)))
    }
    
    func arrow_hat_left_clicked() {
        hat.run(SKAction.move(by: CGVector(dx: -50, dy: 0), duration: TimeInterval(1)))
    }
}
