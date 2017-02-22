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
    var highScore : Int = 0
    
    // MARK : Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("highscore")
    
    init?(highScore: Int) {
        self.highScore = highScore
        
        super.init()
    }
    
    // MARK : Types
    struct PropertyKey {
        static let highScoreKey = "highScore"
    }
    
    // MARK : NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(highScore, forKey: PropertyKey.highScoreKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        do {
            if let highScore = aDecoder.decodeObject(forKey: PropertyKey.highScoreKey) as? Int {
                self.init(highScore: highScore)
                return
            }
        }
        self.init(highScore: 0)
    }
}
