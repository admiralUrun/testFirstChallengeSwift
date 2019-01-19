//
//  Iterator.swift
//  testFirstChallenge
//
//  Created by Andrew Yakovenko on 1/17/19.
//  Copyright © 2019 Andrew Yakovenko. All rights reserved.
//

import Foundation


class Step {
    init(put getCount:Int) {
        count = getCount
    }
    
    private var count = 0
    
    public var index = 0
    
    public func hasNext() -> Bool {
        return index < count
    }
    
    public func advance()  {
        index += 1
    }
}






