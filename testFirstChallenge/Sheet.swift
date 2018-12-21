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
    
private var cells:[Key : Value] = [:]
    
    func get(_ key: Key) -> Value {
        guard let value = cells[key] else {
            return ""
        }
        
        if value.isEmpty {
            return ""
        }
        
        if value.first == "=" {
            return returnValue(formul: value)
        }
        
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        if trimmedValue.isEmpty {
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
    
    // private
    
    private func returnValue(formul:Value) -> Value {
        let value: Value
        var insedeValue = ""
        
        for character in formul {
            
            if let vauleInInt = Int(String(character))  {
                if insedeValue.isEmpty {
                    insedeValue = "\(vauleInInt)"
                } else {
                    insedeValue += "\(vauleInInt)"
                }
            } else {
                continue
            }
        }
    
        value = insedeValue
        return value
    }
    
    
    
    
    
}












