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
        GoogleAdBannerView.load(request)
        
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.gameViewController = self
        skView.presentScene(scene)
        //skView.showsFPS = true
    }
    
    
    @IBAction func pauseBtnClicked(_ sender: AnyObject) {
        scene.gamePaused = true
        scene.pauseBtnClicked = true
        resumeButton.isHidden = false
        quitButton.isHidden = false
    }
    
    
    @IBAction func resumeBtnClicked(_ sender: AnyObject) {
        scene.gamePaused = false
        scene.resumeBtnClicked = true
        resumeButton.isHidden = true
        quitButton.isHidden = true
    }
    
    @IBAction func quitBtnClicked(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.scene.removeAllActions()
        self.scene.removeFromParent()
        self.scene.removeAllChildren()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
