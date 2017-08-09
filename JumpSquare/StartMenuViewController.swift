//
//  StartMenuViewController.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 12.07.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import SpriteKit
import GoogleMobileAds
import AVFoundation


class StartMenuViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var animationSKView: SKView!
    @IBOutlet weak var obs1pos: UIImageView!
    @IBOutlet weak var obs2pos: UIImageView!
    @IBOutlet weak var playerPos: UIImageView!
    @IBOutlet weak var GoogleAdBannerView: GADBannerView!
    
    var scene = SKScene(size: CGSize.zero)
    var player = AVAudioPlayer()
    let audioPath = Bundle.main.path(forResource: "beep", ofType: "aif")


    
    var playerIcon = SKSpriteNode()
    var obs1 = SKSpriteNode()
    var obs2 = SKSpriteNode()
    
    let spaceBetweenObstacles : CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GoogleAdBannerView.delegate = self
        GoogleAdBannerView.adUnitID = "ca-app-pub-1460994528133368/6355604738"
        GoogleAdBannerView.rootViewController = self
        GoogleAdBannerView.load(request)
        
        scene = SKScene(size: animationSKView.frame.size)
        animationSKView.showsFPS = false
        animationSKView.showsNodeCount = false
        animationSKView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        animationSKView.presentScene(scene)
        animationSKView.scene!.backgroundColor = animationSKView.backgroundColor!
        
        obs1.size = CGSize(width: obs1pos.frame.width, height: animationSKView.frame.height/2 - spaceBetweenObstacles/2)
        obs2.size = CGSize(width: obs2pos.frame.width, height: animationSKView.frame.height/2 - spaceBetweenObstacles/2)
        
        playerPos.isHidden = true;
        playerIcon = SKSpriteNode(color: playerPos.backgroundColor!, size: playerPos.bounds.size)
        playerIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
        playerIcon.run(SKAction.move(to: CGPoint(x: self.view.frame.midX, y: playerPos.bounds.minY),
            duration: TimeInterval(0)))
        
        obs1.run(SKAction.move(to: CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY), duration: TimeInterval(0)))
        obs1.run(SKAction.move(to: CGPoint(x: animationSKView.frame.minX - 100, y: obs1pos.frame.midY), duration: TimeInterval(1)),
                       completion: { self.AnimatePlayer() })
        obs2.run(SKAction.move(to: CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY), duration: TimeInterval(0)))
        obs2.run(SKAction.move(to: CGPoint(x: animationSKView.frame.minX - 100, y: obs2pos.frame.midY), duration: TimeInterval(1)))
        
        animationSKView.scene?.addChild(obs1)
        animationSKView.scene?.addChild(obs2)
        animationSKView.scene?.addChild(playerIcon)
        
        //AnimatePlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func AwardPoint() {
        let popup = Popup()
        popup.position = CGPoint(x: 0, y: (obs2.frame.height/2) + (obs1.frame.minY - obs2.frame.maxY)/2 - 10)
        popup.size = CGSize(width: 20, height: 20)
        popup.Pop(20, duration: 0.3, text: "+1")
        obs2.addChild(popup)
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath : audioPath!))
       //     player.play()
        }catch{
            
        }
    }
    
    func AnimatePlayer() {
        obs1.run(SKAction.wait(forDuration: TimeInterval(1.3)), completion: { self.AwardPoint() })
        
        obs1.run(SKAction.move(to: CGPoint(x: animationSKView.frame.maxX, y: obs1pos.frame.midY + spaceBetweenObstacles/4), duration: TimeInterval(0)))
        obs2.run(SKAction.move(to: CGPoint(x: animationSKView.frame.maxX, y: obs2pos.frame.midY - spaceBetweenObstacles/4), duration: TimeInterval(0)))
        
        obs1.color = UIColor.black
        obs2.color = UIColor.black
        
        obs1.run(SKAction.move(to: CGPoint(x: animationSKView.frame.minX - 10, y: obs1pos.frame.midY + spaceBetweenObstacles/4), duration: TimeInterval(3)))
        obs2.run(SKAction.move(to: CGPoint(x: animationSKView.frame.minX - 10, y: obs2pos.frame.midY - spaceBetweenObstacles/4), duration: TimeInterval(3)))
        
        obs1.run(SKAction.wait(forDuration: TimeInterval(4)), completion: { self.AnimatePlayer() })
        
        let duration = 0.8
        playerIcon.run(SKAction.resize(toHeight: playerIcon.frame.height - 20, duration: duration))
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration)), completion: { self.JumpPlayer() })
        playerIcon.run(SKAction.wait(forDuration: TimeInterval(duration + 1)),
                             completion: { self.playerIcon.run(SKAction.move(to: CGPoint(x: self.view.frame.midX, y: self.playerPos.bounds.minY),
            duration: TimeInterval(0.3))) })
    }
    
    func JumpPlayer() {
        playerIcon.run(SKAction.resize(toHeight: playerPos.bounds.height, duration: TimeInterval(0)))
        playerIcon.run(SKAction.move(to: CGPoint(x: self.view.frame.midX,
            y: (obs2.frame.midY + obs1.frame.midY)/2 - (playerIcon.frame.height/2)), duration: TimeInterval(0.3)))
    }
}
