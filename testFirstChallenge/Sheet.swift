//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation

class Sheet  {
    
    typealias Key = String
    typealias Value = String
    
    var cells:[Key : Value] = [:]
    
    func get(_ key: Key) -> Value {
        guard let value = cells[key] else {
            return ""
        }
        
        if isItEmpty(value: value) {
            return ""
        }
        
        if value[value.startIndex] == "=" {
            var trimmedFormul = Array(value)
            
            trimmedFormul.remove(at: 0)
            return Value(trimmedFormul)
        }
        
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        if isItEmpty(value: trimmedValue) {
            return ""
        }
        
        guard let valueToInt = Int(trimmedValue) else {
            return value
        }
        
        return "\(valueToInt)"
    }
    
    
    func put (_ key: Key, _ value: Value) {
        cells[key] = value
    }
    
    
    func getLiteral(_ key: Key) -> Value {
        guard let value = cells[key] else {
            return ""
        }
        return value
    }
    
    // privat funcS
    
    private func isItEmpty(value string: Value) -> Bool {
        if string.isEmpty {
            return true
        }
        return false
    }
    
    
}












