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
        
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        if trimmedValue.isEmpty {
            return ""
        }
        
        if let valueAsInt = Int(trimmedValue) {
            return String(valueAsInt)
        }
        
        if value.first == "=" {
            return evaluate(formula: Array(value))
        }
        
        return value
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
    
    // MARK: -
    
    private func evaluate(formula:[Character]) -> Value {
        let value: Value
        var beforOperator = ""
        var afterOperator = ""
        
        var lastOperator = ""
        
        for index in 0 ..< formula.count {
            
            let symbol = Value(formula[index])
            
            if index != formula.count - 1  {
                
                if let symbolInInt = Int(symbol)  {
                    
                    beforOperator = addToString(symbolInInt: symbolInInt, befor: beforOperator)
                    
                } else {
                    let triger = symbol
                    
                    switch triger {
                    case "*":
                        if lastOperator.isEmpty {
                            if afterOperator.isEmpty {
                                afterOperator = beforOperator
                                beforOperator = ""
                            } else {
                                guard let beforTriger = Int(afterOperator), let afterTriger = Int(beforOperator) else {
                                    assertionFailure()
                                    return ""
                                }
                                
                                afterOperator = Value(beforTriger * afterTriger)
                                beforOperator = ""
                            }
                            lastOperator = "*"
                        } else {
                            guard let beforTriger = Int(afterOperator), let afterTriger = Int(beforOperator) else {
                                assertionFailure()
                                return ""
                            }
                            
                            afterOperator = Value(beforTriger * afterTriger)
                            beforOperator = ""
                        }
                    case "+":
                        return ""
                    default:
                        continue
                    }
                }
            } else {
                
                guard let symbolInInt = Int(symbol) else {
                    
                    if beforOperator.isEmpty {
                        return afterOperator
                    } else {
                        if lastOperator.isEmpty {
                            return beforOperator
                        } else {
                            guard let beforValueAsInt = Int(beforOperator), let afterValueAsInt = Int(afterOperator) else {
                                return ""
                            }
                            switch lastOperator {
                            case "*":
                                return String(beforValueAsInt * afterValueAsInt)
                            default:
                                assertionFailure()
                            }
                            
                        }
                    }
                    return ""
                }
                
             beforOperator = addToString(symbolInInt: symbolInInt, befor: beforOperator)
                
                if afterOperator.isEmpty {
                    return beforOperator
                } else {
                    guard let beforValueAsInt = Int(beforOperator), let afterValueAsInt = Int(afterOperator) else {
                        assertionFailure()
                        return ""
                    }
                    switch lastOperator {
                    case "*":
                        return String(beforValueAsInt * afterValueAsInt)
                    default:
                        assertionFailure()
                    }
                }
                
            }
        }
        
        assertionFailure()
        return ""
    }
    
    private func addToString(symbolInInt:Int, befor:String) -> String {
        var beforOperator = befor
        if befor.isEmpty {
             beforOperator = "\(symbolInInt)"
            return beforOperator
        } else {
            beforOperator += "\(symbolInInt)"
            return beforOperator
        }
    }
    
}
