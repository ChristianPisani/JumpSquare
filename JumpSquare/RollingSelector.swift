//
//  RollingSelector.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 09.06.2017.
//  Copyright © 2017 Christian Thorvik. All rights reserved.
//

import Foundation
import SpriteKit

class RollingSelector {
    var items = [SKSpriteNode]()
    //var colors : [UIColor] = [.red, .blue, .purple, .black, .white]
    var textures = [SKSpriteNode]()
    var size : CGSize
    var itemIndex : Int
    
    var animating = false
    
    let player : SKSpriteNode
    let view : SKView
    
    var arrow_right = SKSpriteNode()
    var arrow_left = SKSpriteNode()
    
    var offsetY : CGFloat = 0
    
    init(player: SKSpriteNode, view : SKView, name : String, offsetY : CGFloat, size : CGSize, index: Int = 0) {
        self.player = player
        self.view = view
        self.offsetY = offsetY
        self.size = size
        self.itemIndex = index
        
        let d = SKSpriteNode()
        d.texture?.filteringMode = .nearest
        d.texture = nil
        textures.append(d)
        
        for i in 1...3 {
            let t : SKSpriteNode = SKSpriteNode(imageNamed: name + "_" + String(describing: i))
            //if(t != nil) {
            t.texture?.filteringMode = .nearest
                textures.append(t)
            //}
        }
        
        let item = SKSpriteNode()
        item.size = size
        item.anchorPoint = CGPoint(x: 0.5, y: 0)
        items.append(item)
        player.addChild(items[0])
        
        let leftitem = SKSpriteNode()
        leftitem.size = item.size
        leftitem.anchorPoint = item.anchorPoint
        items.append(leftitem)
        player.addChild(items[1])
        
        let rightitem = SKSpriteNode()
        rightitem.size = CGSize(width: item.size.width, height: item.size.height + 15)
        rightitem.anchorPoint = item.anchorPoint
        items.append(rightitem)
        player.addChild(items[2])
        resetItems()
        
        let dst : CGFloat = 30
        arrow_right = SKSpriteNode(imageNamed: "Arrow_head")
        arrow_right.name = name + "_arrow_right"
        arrow_right.position = CGPoint(x: player.frame.width/2 + dst, y: item.frame.midY)
        arrow_right.size = CGSize(width: 20, height: 20)
        arrow_right.zRotation = -(.pi / 2)
        arrow_left = SKSpriteNode(imageNamed: "Arrow_head")
        arrow_left.name = name + "_arrow_left"
        arrow_left.position = CGPoint(x: -player.frame.width/2 - dst, y: item.frame.midY)
        arrow_left.size = CGSize(width: 20, height: 20)
        arrow_left.zRotation = .pi / 2
        player.addChild(arrow_right)
        player.addChild(arrow_left)
    }
    

    
    func resetItems() {
        animating = false
        
        items[0].position = mPos()
        items[1].position = lPos()
        items[2].position = rPos()
        
        items[0].size = CGSize(width: size.width, height: size.height)
        items[1].size = CGSize(width: size.width, height: size.height)
        items[2].size = CGSize(width: size.width, height: size.height)
        
        //items[0].color = colors[getIndex(index: itemIndex, size: colors.count)]
        //items[1].color = colors[getIndex(index: itemIndex-1, size: colors.count)]
        //items[2].color = colors[getIndex(index: itemIndex+1, size: colors.count)]
        items[0].texture = textures[getIndex(index: itemIndex, size: textures.count)].texture
        items[1].texture = textures[getIndex(index: itemIndex-1, size: textures.count)].texture
        items[2].texture = textures[getIndex(index: itemIndex+1, size: textures.count)].texture
    }
    
    func arrow_right_clicked() {
        if(animating) { return }
        
        animating = true
        
        let duration = 0.5
        items[0].run(SKAction.move(to: rPos(), duration: TimeInterval(duration)))
        items[1].run(SKAction.move(to: mPos(), duration: TimeInterval(duration)),
                    completion: {self.resetItems()})
        
        itemIndex = getIndex(index: itemIndex - 1, size: textures.count)
    }
    
    func arrow_left_clicked() {
        if(animating) { return }
        
        animating = true
        
        let duration = 0.5
        items[0].run(SKAction.move(to: lPos(), duration: TimeInterval(duration)))
        items[2].run(SKAction.move(to: mPos(), duration: TimeInterval(duration)),
                    completion: {self.resetItems()})
        
        itemIndex = getIndex(index: itemIndex + 1, size: textures.count)
    }
    
    public func containsPoint(point : CGPoint) -> Bool {
        let checkPoint = CGPoint(x: player.frame.midX - point.x, y: player.frame.midY - point.y)
        print("Checking point: " + String(describing: checkPoint) + ":" + String(describing: items[0].frame))
        
        return items[0].frame.contains(checkPoint)
    }
    
    func getIndex(index: Int, size: Int) -> Int {
        if(index < 0) {
            return size - 1
        }
        
        if(index >= size) {
            return 0
        }
        
        return index
    }
    
    func mPos() -> CGPoint {
        return CGPoint(x: 0, y: offsetY)
    }
    
    func rPos() -> CGPoint {
        return CGPoint(x: ((view.frame.width/2)+(items[0].frame.width/2)), y: items[0].position.y)
    }
    
    func lPos() -> CGPoint {
        return CGPoint(x: -((view.frame.width/2)+(items[0].frame.width/2)), y: items[0].position.y)
    }
}

