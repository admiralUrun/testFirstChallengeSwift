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
            return evaluate(formula: tokenize(formula: Array(value)))
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
    
    enum Token {
        case multiplication
        case addition
        case number(Int)
        case lp
        case rp
        case empty
    }
    
    func tokenize(formula: [Character]) -> [Token] {
        var tokens = [Token]()
        var numberBufer = ""
        for index in 0 ..< formula.count {
            let symbol = String(formula[index])
            if let _ = Int(symbol) {
                numberBufer += symbol
            } else {
                if !numberBufer.isEmpty {
                    tokens.append(.number(Int(numberBufer)!))
                    numberBufer = ""
                }
                
                switch symbol {
                case"(":
                        tokens.append(.lp)
                case")":
                        tokens.append(.rp)
                case"*":
                    tokens.append(.multiplication)
                case"+":
                    tokens.append(.addition)
                case"=":
                    continue
                case" ":
                    continue
                default:
                    continue
                }
            }
        }
        
        if !numberBufer.isEmpty {
            tokens.append(.number(Int(numberBufer)!))
        }
        
        return tokens
    }
    
    // MARK: - Evaluate
    private func evaluate(formula:[Token]) -> Value {
        var beforOperator: Token = .empty
        var afterOperator: Token = .empty
        
        var lastOperator: Token = .empty
        
        for index in 0 ..< formula.count {
            let token = formula[index]
            
            if index != formula.count - 1 {
                switch token {
                case .multiplication:
                   afterOperator = whatTokenReturn(tokens: (beforOperator,afterOperator), lastOperation: lastOperator)
                    beforOperator = .empty
                    lastOperator = .multiplication
                case .addition:
                    afterOperator = whatTokenReturn(tokens: (beforOperator,afterOperator), lastOperation: lastOperator)
                    beforOperator = .empty
                    lastOperator = .addition
                case .number(_):
                    beforOperator = token
                case .lp:
                    continue
                case .rp:
                    continue
                case .empty:
                    continue
                }
            } else {
                switch token {
                case .number(_):
                    beforOperator = token
                    return convertTokenToValue(token: whatTokenReturn(tokens: (beforOperator,afterOperator), lastOperation: lastOperator))
                default:
                    
                    return convertTokenToValue(token: whatTokenReturn(tokens: (beforOperator,afterOperator), lastOperation: lastOperator))
                }
            }
        }
        return ""
    }
    // MARK: -  evaluet logic
    private func operation(tokens:(Token,Token), tokenOperator: Token) -> Token {
        
        if case let .number(first) = tokens.0, case let .number(second) = tokens.1 {
            
            switch tokenOperator {
            case .multiplication:
                return .number(first * second)
            case .addition:
                return .number(first + second)
            default:
                assertionFailure("TokenOperator return wrong token !")
            }
        } else {
            assertionFailure("Tokens return NOT .number !")
        }
        assertionFailure("Tokens return NOT .number !")
        return .empty
    }
    
    private func convertTokenToValue(token: Token) -> Value {
        if case let .number(numberToReturn) = token {
            switch token {
            case .number(numberToReturn):
                return Value (numberToReturn)
            case .empty:
                return ""
            default:
                assertionFailure("Wrong Token")
            }
        }
        return ""
    }
    
    private func isItEmpty(token: Token) -> Bool {
        switch token {
        case .empty:
            return true
        default:
            return false
        }
    }

    private func whatTokenReturn(tokens inBufer:(Token,Token), lastOperation operatorToUse:Token) -> Token {
        if isItEmpty(token: inBufer.1)  {
            return  inBufer.0
        } else {
            if isItEmpty(token: operatorToUse)  {
                assertionFailure("Operator can't be .empty if afterOperator isn't!")
                return .empty
            } else {
                return  operation(tokens: (inBufer.0,inBufer.1), tokenOperator: operatorToUse)
            }
        }
    }
    
    
    //
}
