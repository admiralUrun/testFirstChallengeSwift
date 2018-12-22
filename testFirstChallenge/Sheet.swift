//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation

class Sheet  {
    
    typealias Adress = String
    typealias Value = String
    
    private var cells:[Adress : String] = [:]
    
    func get(_ key: Adress) -> String {
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
    
    func put (_ key: Adress, _ value: String) {
        cells[key] = value
    }
    
    
    func getLiteral(_ key: Adress) -> String {
        guard let value = cells[key] else {
            return ""
        }
        return value
    }
    
    // MARK: -
    
    private func evaluate(formula:[Character]) -> Value {
        var beforOperator = ""
        var afterOperator = ""
        
        var lastOperator = ""
        
        for index in 0 ..< formula.count {
            
            let symbol = Value(formula[index])
            
            if index != formula.count - 1  {
                
                if let symbolInInt = Int(symbol)  {
                    beforOperator = addToString(symbolInInt: symbolInInt, befor: beforOperator)
                } else {
                    switch symbol {
                    case "*":
                        if lastOperator.isEmpty {
                            if afterOperator.isEmpty {
                                afterOperator = beforOperator
                                beforOperator = ""
                            } else {
                                afterOperator = operatorMultiplication(first: beforOperator, second: afterOperator)
                                beforOperator = ""
                            }
                            lastOperator = "*"
                        } else {
                            
                            afterOperator = operatorMultiplication(first: beforOperator, second: afterOperator)
                            beforOperator = ""
                        }
                    case "+":
                        if lastOperator.isEmpty {
                            if afterOperator.isEmpty {
                                afterOperator = beforOperator
                                beforOperator = ""
                            } else {
                                afterOperator = operatorContinuation(first: beforOperator, second: afterOperator)
                                beforOperator = ""
                            }
                            lastOperator = "+"
                        } else {
                            afterOperator = operatorContinuation(first: beforOperator, second: afterOperator)
                            beforOperator = ""
                        }
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
                            return lastOperation(lastOperator: lastOperator, beforOperator: beforOperator, afterOperator: afterOperator)
                        }
                    }
                }
                
                beforOperator = addToString(symbolInInt: symbolInInt, befor: beforOperator)
                
                if afterOperator.isEmpty {
                    return beforOperator
                } else {
                    return lastOperation(lastOperator: lastOperator, beforOperator: beforOperator, afterOperator: afterOperator)
                }
            }
        }
        assertionFailure()
        return ""
    }
    
    private func addToString(symbolInInt:Int, befor:String) -> Value {
        var beforOperator = befor
        if befor.isEmpty {
            beforOperator = "\(symbolInInt)"
            return beforOperator
        } else {
            beforOperator += "\(symbolInInt)"
            return beforOperator
        }
    }
    private func lastOperation(lastOperator:String, beforOperator:Value, afterOperator:Value) -> Value {
        switch lastOperator {
        case "*":
            return operatorMultiplication(first: beforOperator, second: afterOperator)
        case "+":
            return operatorContinuation(first: beforOperator, second: afterOperator)
        default:
            assertionFailure()
        }
        return ""
    }
    
    private func operatorContinuation(first:Value, second:Value) -> Value {
        guard let beforTriger = Int(first), let afterTriger = Int(second) else {
            return ""
        }
        return Value(beforTriger + afterTriger)
    }
    
    private func operatorMultiplication(first:Value, second:Value) -> Value {
        guard let beforTriger = Int(first), let afterTriger = Int(second) else {
            return ""
        }
        return Value(beforTriger * afterTriger)
    }
    
}
