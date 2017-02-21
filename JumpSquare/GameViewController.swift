//
//  GameViewController.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 31.01.2016.
//  Copyright (c) 2016 Christian Thorvik. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var GoogleAdBannerView: GADBannerView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    
    var scene = StartGameScene(size: CGSize.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GoogleAdBannerView.delegate = self
        GoogleAdBannerView.adUnitID = "ca-app-pub-1460994528133368/6355604738"
        GoogleAdBannerView.rootViewController = self
        GoogleAdBannerView.loadRequest(request)
        
        
        
        
        self.navigationController?.navigationBarHidden = true
        
        scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.gameViewController = self
        skView.presentScene(scene)
        //skView.showsFPS = true
    }
    
    
    @IBAction func pauseBtnClicked(sender: AnyObject) {
        scene.gamePaused = true
        scene.pauseBtnClicked = true
        resumeButton.hidden = false
        quitButton.hidden = false
    }
    
    
    @IBAction func resumeBtnClicked(sender: AnyObject) {
        scene.gamePaused = false
        scene.resumeBtnClicked = true
        resumeButton.hidden = true
        quitButton.hidden = true
    }
    
    @IBAction func quitBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = false
        self.scene.removeAllActions()
        self.scene.removeFromParent()
        self.scene.removeAllChildren()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
