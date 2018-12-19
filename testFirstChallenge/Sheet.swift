//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation


class Sheet  {
    
    var cells:[String : String] = [:]
    
    func get(_ key: String) -> String {
        guard let value = cells[key] else {
            return ""
        }
        
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        if (trimmedValue.isEmpty) {
            return ""
        }
        
        guard let valueToInt = Int(trimmedValue) else {
            return value
        }
        
        return "\(valueToInt)"
    }
    
    func put (_ key: String, _ value: String) {
        cells[key] = value
    }
    
    func getLiteral(_ key: String) -> String {
        guard let value = cells[key] else {
            return ""
        }
        return value
    }
}












