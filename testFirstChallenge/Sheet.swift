//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation



class Sheet  {
    
    
    var dict:[String : String] = [:]
    
    
    func get(_ key:String) -> String {

        guard dict[key] != nil else {
            return ""
        }
        return dict[key]!
    }
    
    func put (_ key:String, _ value:String) {
        dict[key] = value
    }
}












