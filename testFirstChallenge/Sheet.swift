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
    
    var tokens = [Token]()
    var tokenIndex = 0
    
    private var cells:[Address : Value] = [:]
    
    public func get(_ key: Address) -> String {
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
            let getIteator = Iterator()
            tokens = tokenize(formula: Array(value))
            getIteator.putCount(put: tokens.count)
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
        case multiplication
        case addition
        case number(Int)
        case lp
        case rp
        case cell(Address)
    }
    
    private func tokenize(formula: [Character]) -> [Token] {
        let tokenizeIterator = Iterator()
        tokenizeIterator.putCount(put: formula.count)
        
        var tokens = [Token]()
        var numberBufer = ""
        while tokenizeIterator.next() {
            let symbol = String(formula[tokenizeIterator.index])
            if let _ = Number(symbol) {
                numberBufer += symbol
                tokenizeIterator.getAdvance()
            } else {
                if !numberBufer.isEmpty {
                    tokens.append(.number(Number(numberBufer)!))
                    numberBufer = ""
                }
                
                switch symbol {
                case"(":
                    tokens.append(.lp)
                    tokenizeIterator.getAdvance()
                case")":
                    tokens.append(.rp)
                    tokenizeIterator.getAdvance()
                case"*":
                    tokens.append(.multiplication)
                    tokenizeIterator.getAdvance()
                case"+":
                    tokens.append(.addition)
                    tokenizeIterator.getAdvance()
                case "=":
                    tokenizeIterator.getAdvance()
                    continue
                case " ":
                    tokenizeIterator.getAdvance()
                    continue
                default:
                    tokens.append(.cell(cellToken(formula: formula, cellTokenIterator: tokenizeIterator)))
                }
            }
        }
        
        if !numberBufer.isEmpty {
            tokens.append(.number(Number(numberBufer)!))
        }
        return tokens
    }
    
    private func cellToken(formula: [Character], cellTokenIterator:Iterator) -> Address {
        var addresBufer = ""
        while ("A"..."Z").contains(formula[cellTokenIterator.index]) {
            addresBufer += String(formula[cellTokenIterator.index])
            cellTokenIterator.getAdvance()
        }
        
        if addresBufer.isEmpty {
            return "#Error"
        } else {
            while checkConvertInInt(formula: formula, to: cellTokenIterator.index) {
                addresBufer += String(formula[cellTokenIterator.index])
                cellTokenIterator.getAdvance()
            }
            return addresBufer
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
    
    private func evalExpression(iterator expressionIterator:Iterator) -> Number? {
        if  let left = evalTerm(iterator: expressionIterator) {
            if let token = getToken(iterator: expressionIterator) {
                switch token {
                case .addition:
                  expressionIterator.getAdvance()
                    if let right = evalExpression(iterator: expressionIterator) {
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
    
    private func evalTerm(iterator termIterator: Iterator) -> Number? {
        if let left = evalPrimary(iterator: termIterator) {
            if let token = getToken(iterator: termIterator) {
                switch token {
                case .multiplication:
                    termIterator.getAdvance()
                   // getAdvance()
                    if let right = evalTerm(iterator: termIterator) {
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
    
    private func evalPrimary(iterator primaryIterator: Iterator) -> Number? {
        if let token = getToken(iterator: primaryIterator) {
            switch token {
            case .lp:
                primaryIterator.getAdvance()
                let expression = evalExpression(iterator: primaryIterator)
                primaryIterator.getAdvance()
                return expression
                
            case .number(let number):
                primaryIterator.getAdvance()
                return number
                
            default:
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            return nil
        }
    }
    
    private func getToken(iterator:Iterator) -> Token? {
        if iterator.next() {
            let token = tokens[iterator.index]
            return token
        }
        return .none
    }
}
