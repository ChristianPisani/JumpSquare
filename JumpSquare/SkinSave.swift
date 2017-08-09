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
    var coat : Int = 0
    var hat : Int = 0
    
    // MARK : Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("skinsave")
    
    init?(hat: Int, coat: Int) {
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
        print("saving: " + String(describing: hat) + " : " + String(describing: coat))
        print(SkinSave.ArchiveURL.path)
        aCoder.encode(hat, forKey: PropertyKey.hatKey)
        aCoder.encode(coat, forKey: PropertyKey.coatKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let loadHat : Int? = aDecoder.decodeInteger(forKey: PropertyKey.hatKey)
        let loadCoat : Int? = aDecoder.decodeInteger(forKey: PropertyKey.coatKey)
        
        if(loadHat != nil && loadCoat != nil) {
            self.init(hat: loadHat!, coat: loadCoat!)
        } else {
            self.init(hat: 0, coat: 0)
        }
        return
    }
}
