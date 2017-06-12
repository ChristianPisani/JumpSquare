//
//  SkinEditorViewController.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 06.06.2017.
//  Copyright © 2017 Christian Thorvik. All rights reserved.
//

import UIKit
import SpriteKit

class SkinEditorViewController: UIViewController {
    
    
    var scene = SkinEditorScene(size: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        scene = SkinEditorScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.backgroundColor = view.backgroundColor!
        

        
        
        
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.scene.removeAllActions()
        self.scene.removeFromParent()
        self.scene.removeAllChildren()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
