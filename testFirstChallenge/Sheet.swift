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
    
    var tokens = [Token]()
    var tokenIndex = 0
    
    private var cells:[Address : Value] = [:]
    
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
            tokens = tokenize(formula: Array(value))
            
            if let number = evalExpression() {
                if tokenIndex <= tokens.count {
                    return String(number)
                } else {
                    return "#Error"
                }
//             return String(number)
            } else {
                return "#Error"
            }
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
    
    private func evalExpression() -> Int? {
        if  let left = evalTerm() {
            if let token = getToken() {
                switch token {
                case .addition:
                    getAdvance()
                    if let right = evalExpression() {
                     return left + right
                    }
                default:
                    return left
                }
            } else {
                return left
            }
        } else {
            return nil
        } 
       preconditionFailure("Unexpected token")
    }
    
    private func evalTerm() -> Int? {
        if let left = evalPrimary() {
            if let token = getToken() {
                switch token {
                case .multiplication:
                    getAdvance()
                    if let right = evalTerm() {
                     return left * right
                    } else {
                        return nil
                    }
                default:
                    return left
                }
            } else {
                return left
            }
        } else {
            return nil
        }
    }
    
    private func evalPrimary() -> Int? {
        if let token = getToken() {
            switch token {
            case .lp:
                 getAdvance()
                let expression = evalExpression()
                 getAdvance()
                return expression
                
            case .number(let number):
                 getAdvance()
                return number
                
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            return nil
        }
    }
    
    private func getAdvance()  {
            tokenIndex += 1
    }
    
    private func getToken() -> Token? {
        if tokenIndex < tokens.count {
            let token = tokens[tokenIndex]
            return token
        }
        return .none
    }
}
