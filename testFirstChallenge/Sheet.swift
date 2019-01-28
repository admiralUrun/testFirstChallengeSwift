//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation

typealias Address = String

enum Token {
    case addition
    case subtraction
    case multiplication
    case division
    case number(Int)
    case lp
    case rp
    case cell(Address)
}

class Sheet  {
    
    private typealias Value = String
    private typealias Number = Int
    
    private var tokens = [Token]()
    
    private var cells:[Address : Value] = [:]
    
    public func get(_ key: Address) -> String {
        guard let value = cells[key] else {
            return ""
        }
        
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        
        if trimmedValue.isEmpty {
            return ""
        }
        
        if let _ = Int(trimmedValue) {
            return trimmedValue
        }
        
        if value.first == "=" {
            tokens = [Token]()
            tokens = tokenize(formula: Array(value))
            let getIteator = TokenIterator(tokens)
            if let number = evalExpression(expression: getIteator) {
                return String(number)
                
            } else {
                return "#Error"
            }
        }
        return value
    }
    
    public func put (_ key: Address, _ value: String) {
        cells[key] = value
    }
    
    public func getLiteral(_ key: Address) -> String {
        guard let value = cells[key] else {
            return ""
        }
        return value
    }
    
    // MARK: - Token
    
    private func tokenize(formula: [Character]) -> [Token] {
        var index = 0
        var addresBuffer = ""
        var numberBuffer = ""
        while index < formula.count {
            let symbol = String(formula[index])
            
            if !addresBuffer.isEmpty {
                while checkConvertInInt(formula: formula, to: index) {
                    addresBuffer += String(formula[index])
                    index += 1
                }
                tokens.append(.cell(addresBuffer))
                addresBuffer = ""
                
            } else {
                
                if let _ = Number(symbol) {
                    numberBuffer += symbol
                    index += 1
                    
                } else {
                    if !numberBuffer.isEmpty {
                        tokens.append(.number(Number(numberBuffer)!))
                        numberBuffer = ""
                    }
                    
                    switch symbol {
                    case"(":
                        tokens.append(.lp)
                        index += 1
                    case")":
                        tokens.append(.rp)
                        index += 1
                    case"*":
                        tokens.append(.multiplication)
                        index += 1
                    case"+":
                        tokens.append(.addition)
                        index += 1
                    case "=":
                        index += 1
                    case "-":
                        tokens.append(.subtraction)
                        index += 1
                    case "/":
                        tokens.append(.division)
                        index += 1
                    case " ":
                        index += 1
                    default:
                        while ("A"..."Z").contains(formula[index]) {
                            addresBuffer += String(formula[index])
                            index += 1
                        }
                    }
                }
            }
        }
        
        if !numberBuffer.isEmpty {
            tokens.append(.number(Number(numberBuffer)!))
        }
        return tokens
    }
    
    
    private func checkConvertInInt(formula: [Character], to index:Int) -> Bool {
        if index >= formula.count {
            return false
            
        } else {
            if let _ = Number(String(formula[index])) {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: - Evaluate
    
    private func evalExpression(expression: TokenIterator) -> Number? {
        
        if  let left = evalTerm(iterator:expression ) {
            if let token = expression.lookupNext() {
                switch token {
                    
                case .addition:
                    let _ = expression.next()
                    if let right = evalExpression(expression: expression) {
                        return left + right
                        
                    } else {
                        return nil
                    }
                    
                case .subtraction:
                    let _ = expression.next()
                    if let right = evalExpression(expression: expression) {
                        return left - right
                        
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
    
    private func evalTerm(iterator: TokenIterator) -> Number? {
        if let left = evalPrimary(iterator: iterator) {
            if let token = iterator.lookupNext() {
                switch token {
                case .multiplication:
                    let _ = iterator.next()
                    if let right = evalTerm(iterator: iterator) {
                        return left * right
                        
                    } else {
                        return nil
                    }
                    
                case .division:
                    let _ = iterator.next()
                    if let right =  evalTerm(iterator: iterator) {
                        return left / right
                        
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
    
    private func evalPrimary(iterator: TokenIterator) -> Number? {
        if let token = iterator.lookupNext() {
            switch token {
            case .lp:
                let _ = iterator.next()
                let expression = evalExpression(expression: iterator)
                if let rp = iterator.next() {
                    switch rp {
                    case .rp:
                        return expression
                    default:
                        return nil
                    }
                    
                } else {
                    return nil
                }
                
            case .number(let number):
                let _ = iterator.next()
                return number
                
            case .cell(let adress):
                if let number = Number(get(adress)) {
                    let _ = iterator.next()
                    return number
                } else {
                    return nil
                }
                
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
            
        } else {
            return nil
        }
    }
}
