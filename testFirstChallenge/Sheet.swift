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
            tokens = tokenize(formula: Array(value))
            let getIteator = Step(put: tokens.count)
            if let number = evalExpression(iterator: getIteator) {
                if getIteator.index <= tokens.count {
                    return String(number)
                } else {
                    return "#Error"
                }
                
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
    
    private func tokenize(formula: [Character]) -> [Token] {
        let tokenizeIterator = Step(put: formula.count)
        
        var tokens = [Token]()
        var numberBufer = ""
        while tokenizeIterator.hasNext() {
            let symbol = String(formula[tokenizeIterator.index])
            if let _ = Number(symbol) {
                numberBufer += symbol
                tokenizeIterator.advance()
            } else {
                if !numberBufer.isEmpty {
                    tokens.append(.number(Number(numberBufer)!))
                    numberBufer = ""
                }
                
                switch symbol {
                case"(":
                    tokens.append(.lp)
                    tokenizeIterator.advance()
                case")":
                    tokens.append(.rp)
                    tokenizeIterator.advance()
                case"*":
                    tokens.append(.multiplication)
                    tokenizeIterator.advance()
                case"+":
                    tokens.append(.addition)
                    tokenizeIterator.advance()
                case "=":
                    tokenizeIterator.advance()
                case "-":
                    tokens.append(.subtraction)
                    tokenizeIterator.advance()
                case "/":
                    tokens.append(.division)
                    tokenizeIterator.advance()
                case " ":
                    tokenizeIterator.advance()
                default:
                    tokens.append(.cell(cellInToken(formula: formula, cellTokenIterator: tokenizeIterator)))
                }
            }
        }
        
        if !numberBufer.isEmpty {
            tokens.append(.number(Number(numberBufer)!))
        }
        return tokens
    }
    
    private func cellInToken(formula: [Character], cellTokenIterator:Step) -> Address {
        var addresBuffer = ""
        while ("A"..."Z").contains(formula[cellTokenIterator.index]) {
            addresBuffer += String(formula[cellTokenIterator.index])
            cellTokenIterator.advance()
        }
        
        if addresBuffer.isEmpty {
            return "#Error"
        } else {
            while checkConvertInInt(formula: formula, to: cellTokenIterator.index) {
                addresBuffer += String(formula[cellTokenIterator.index])
                cellTokenIterator.advance()
            }
            return addresBuffer
        }
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
    
    private func evalExpression(iterator expressionStep:Step) -> Number? {
        if  let left = evalTerm(iterator: expressionStep) {
            if let token = getToken(iterator: expressionStep) {
                switch token {
                case .addition:
                    expressionStep.advance()
                    if let right = evalExpression(iterator: expressionStep) {
                        return left + right
                    }
                case .subtraction:
                    expressionStep.advance()
                    if let right = evalExpression(iterator: expressionStep) {
                        return left - right
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
    
    private func evalTerm(iterator termStep: Step) -> Number? {
        if let left = evalPrimary(iterator: termStep) {
            if let token = getToken(iterator: termStep) {
                switch token {
                case .multiplication:
                    termStep.advance()
                    if let right = evalTerm(iterator: termStep) {
                        return left * right
                    } else {
                        return nil
                    }
                case .division:
                    termStep.advance()
                    if let right = evalTerm(iterator: termStep) {
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
    
    private func evalPrimary(iterator primaryStep: Step) -> Number? {
        if let token = getToken(iterator: primaryStep) {
            switch token {
            case .lp:
                primaryStep.advance()
                let expression = evalExpression(iterator: primaryStep)
                primaryStep.advance()
                return expression
                
            case .number(let number):
                primaryStep.advance()
                return number
                
            case .cell(let adress):
                if let number = Number(get(adress)) {
                    primaryStep.advance()
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
    
    private func getToken(iterator:Step) -> Token? {
        if iterator.hasNext() {
            let token = tokens[iterator.index]
            return token
        }
        return .none
    }
}
