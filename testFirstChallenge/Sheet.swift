//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation

class Sheet  {
    
    typealias Address = String
    typealias Value = String
    
    private var cells:[Address : String] = [:]
    
    func get(_ key: Address) -> String {
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
            return evaluate(formula: tokenezer(formula: Array(value)))
        }
        
        return value
    }
    
    func put (_ key: Address, _ value: String) {
        cells[key] = value
    }
    
    func getLiteral(_ key: Address) -> String {
        guard let value = cells[key] else {
            return ""
        }
        return value
    }
    
    // MARK: - Token
    
    enum token {
        case multiplication
        case addition
        case number(Int)
        case lp
        case rp
        
    }
    
    func tokenezer(formula:[Character]) -> [token] {
        var formulaInToken = [token]()
        
        for index in 0 ..< formula.count {
            let symbol = String(formula[index])
            
            if let symbolToInt = Int(symbol) {
                formulaInToken.append(.number(symbolToInt))
            } else {
                switch symbol {
                case"(":
                    formulaInToken.append(.lp)
                case")":
                    formulaInToken.append(.rp)
                case"*":
                    formulaInToken.append(.multiplication)
                case"+":
                    formulaInToken.append(.addition)
                default:
                    continue
                }
            }
        }
        return formulaInToken
    }
    
    private func addtokenInString(symbolInInt:Int, befor:String) -> Value {
        var beforOperator = befor
        if befor.isEmpty {
            beforOperator = "\(symbolInInt)"
            return beforOperator
        } else {
            beforOperator += "\(symbolInInt)"
            return beforOperator
        }
    }
    
    // MARK: - Evaluate
    
    private func evaluate(formula:[token]) -> Value {
        var beforOperator = ""
        var afterOperator = ""
        
        var lastOperator : token?
        
        for index in 0 ..< formula.count {
            let symbol = formula[index]
            
            if index != formula.count - 1 {
                switch symbol {
                case .multiplication:
                    if lastOperator != nil  {
                        afterOperator = operation(lastOperator: lastOperator!, beforOperator: beforOperator, afterOperator: afterOperator)
                    } else {
                        afterOperator = afterOperatorMultiplication(afterOperator: afterOperator, beforOperator: beforOperator)
                    }
                    beforOperator = ""
                    lastOperator = .multiplication
                case .addition:
                    if lastOperator != nil  {
                       afterOperator = operation(lastOperator: lastOperator!, beforOperator: beforOperator, afterOperator: afterOperator)
                    } else {
                        afterOperator = afterOperatorAddition(afterOperator: afterOperator, beforOperator: beforOperator)
                    }
                    beforOperator = ""
                    lastOperator = .addition
                case .number(let number):
                    beforOperator = addtokenInString(symbolInInt: number, befor: beforOperator)
                case .lp:
                    continue
                case .rp:
                    continue
                }
            } else {
                switch symbol {
                case .number(let number):
                    beforOperator = addtokenInString(symbolInInt: number, befor: beforOperator)
                    
                    if afterOperator.isEmpty {
                        return beforOperator
                    } else {
                        return operation(lastOperator: lastOperator!, beforOperator: beforOperator, afterOperator: afterOperator)
                    }
                default:
                    if beforOperator.isEmpty {
                        return afterOperator
                    } else {
                        if lastOperator != nil {
                            return operation(lastOperator: lastOperator!, beforOperator: beforOperator, afterOperator: afterOperator)
                            
                        } else {
                            return beforOperator
                        }
                    }
                }
            }
            
        }
        return ""
    }
    
    // MARK: - evaluateLogic
    
    private func afterOperatorMultiplication(afterOperator:Value, beforOperator:Value) -> Value {
        if afterOperator.isEmpty {
            return beforOperator
        } else {
            return operatorMultiplication(first: beforOperator, second: afterOperator)
        }
    }
    
    private func afterOperatorAddition(afterOperator:Value, beforOperator:Value) -> Value {
        if afterOperator.isEmpty {
            return beforOperator
        } else {
            return operatorAddition(first: beforOperator, second: afterOperator)
        }
    }
    
    private func operatorAddition(first:Value, second:Value) -> Value {
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
    
    
    
    private func operation(lastOperator:token, beforOperator:Value, afterOperator:Value) -> Value {
        switch lastOperator {
        case .multiplication:
            return operatorMultiplication(first: beforOperator, second: afterOperator)
        case .addition:
            return operatorAddition(first: beforOperator, second: afterOperator)
        default:
            assertionFailure()
        }
        return ""
    }
    
    
    
}
