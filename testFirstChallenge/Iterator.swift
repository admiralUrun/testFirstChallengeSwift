//
//  Iterator.swift
//  testFirstChallenge
//
//  Created by Andrew Yakovenko on 1/17/19.
//  Copyright © 2019 Andrew Yakovenko. All rights reserved.
//

import Foundation


class Iterator {
    private var count = 0
    
    public var index = 0
    
    public func next() -> Bool {
        return index < count
    }
    
    public func putCount(put arrayCount:Int) {
        count = arrayCount
    }
    
    public func getAdvance()  {
        index += 1
    }
}






