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
            return String(evalExpression())
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
    
    private func evalExpression() -> Int {
        let left = evalTerm()
        
        if let token = nextTokenAndMove() {
            if let nextToken = nextToken() {
                switch nextToken {
                case .addition:
                    break
                case .multiplication:
                    break
                case .number(_):
                    break
                case .rp:
                    return left
                default:
                    return left
                }
            }
            switch token {
            case .addition:
                return left + evalExpression()
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            return left
        }
    }
    
    private func evalTerm() -> Int {
        let left = evalPrimary()
        
        if let token = nextTokenAndMove() {
            if let nextToken = nextToken() {
                switch nextToken {
                case .multiplication:
                    break
                case .number(_):
                    break
                case .lp:
                    break
                default:
                    return left
                }
            } else {
                if expetionToken(token: tokens[tokenIndex], expected: .rp) {
                    return left
                }
            }
            switch token {
            case .multiplication:
                return left * evalTerm()
                
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            return left
        }
    }
    
    private func evalExpressionInParentheses() -> Int {
        tokenIndex += 1
        let left = evalExpression()
        tokenIndex += 1
        return left
    }
    
    private func evalPrimary() -> Int {
        if let token = nextToken() {
            switch token {
            case .lp:
                let expression = evalExpressionInParentheses()
                // TODO: assert that it's .rp
                // let _ = nextTokenAndMove()
                return expression
                
            case .number(let number):
                return number
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            switch tokens[tokenIndex] {
            case .number(let number):
                return number
                
            default:
                preconditionFailure("Unexpected token: \(tokens[tokenIndex])")
            }        }
    }
    
    private func nextTokenAndMove() -> Token? {
        if tokenIndex + 1 < tokens.count {
            let token: Token
            if expetionToken(token: tokens[tokenIndex + 1], expected: .multiplication) {
                tokenIndex += 1
                token = tokens[tokenIndex]
                tokenIndex += 1
            } else {
                token = tokens[tokenIndex]
                tokenIndex += 1
            }
            return token
        }
        return .none
    }
    
    private func nextToken() -> Token? {
        if tokenIndex + 1 < tokens.count {
            let token = tokens[tokenIndex]
            return token
        }
        return .none
    }
    
    private func expetionToken(token: Token, expected: Token) -> Bool {
        switch expected {
        case .rp:
            switch token {
            case .rp:
                return true
            default:
                return false
            }
        case .addition:
            switch token {
            case .addition:
                return true
            default:
                return false
            }
        case .multiplication:
            switch token {
            case .multiplication:
                return true
            default:
                return false
            }
        case .number(_):
            switch token {
            case .number(_):
                return true
            default:
                return false
            }
        case .lp:
            switch token {
            case .lp:
                return true
            default:
                return false
            }
        }
    }
    
    
    
}
