//
//  SkinSave.swift
//  JumpSquare
//
//  Created by Christian Thorvik on 11.06.2017.
//  Copyright © 2016 Christian Thorvik. All rights reserved.
//

import UIKit

class SkinSave: NSObject, NSCoding {
    // MARK : Property
    var coat = ""
    var hat = ""
    
    // MARK : Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("skinsave")
    
    init?(hat: String, coat: String) {
        self.coat = coat
        self.hat = hat
        
        super.init()
    }
    
    // MARK : Types
    struct PropertyKey {
        static let hatKey = "hat"
        static let coatKey = "coat"
    }
    
    // MARK : NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coat, forKey: PropertyKey.hatKey)
        aCoder.encode(coat, forKey: PropertyKey.coatKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        do {
            if let loadCoat = aDecoder.decodeObject(forKey: PropertyKey.coatKey) as? String {
                
                if let loadHat = aDecoder.decodeObject(forKey: PropertyKey.hatKey) as? String {
                    self.init(hat: loadHat, coat: loadCoat)
                    return
                }
            }
        }
        self.init(hat: "", coat: "")
    }
}
