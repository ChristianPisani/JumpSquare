//
//  HighScore.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 03.02.2016.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import UIKit

class HighScore: NSObject, NSCoding {
    // MARK : Property
    var highScore : Int
    
    // MARK : Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("highscore")
    
    init?(highScore: Int) {
        self.highScore = highScore
        
        super.init()
    }
    
    // MARK : Types
    struct PropertyKey {
        static let highScoreKey = "highScore"
    }
    
    // MARK : NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(highScore, forKey: PropertyKey.highScoreKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let highScore = aDecoder.decodeObjectForKey(PropertyKey.highScoreKey) as! Int
        
        self.init(highScore: highScore)
    }
}