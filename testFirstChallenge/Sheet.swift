//
//  Sheet.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import Foundation

typealias Address = String
typealias Number = Int

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

//enum ValueOrError {
//    case value(Number)
//    case syntaxError
//    case circularError
//}

class Sheet  {
    
    private typealias Value = String
    
    private var circular = false
    
    private var cells:[Address : Value] = [:]
    
    enum FormulaError : Error {
        case circularReference(String)
        case syntaxError(String)
    }
    
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
            do {
                let tokens = try tokenize(vaule: value)
                let iterator = TokenIterator(tokens)
                return String(try eval(expression: iterator))
            } catch FormulaError.syntaxError(_) {
                return "#Error"
            } catch FormulaError.circularReference(_) {
                return "#Circular"
            } catch {
                preconditionFailure("Unknown Error")
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
    
    // TODO: make it accept String as formula
    private func tokenize(vaule: String) throws -> [Token] {
        var tokens = [Token]()
        var addresBuffer = ""
        var numberBuffer = ""
        let formula = Array(vaule)
        
        for character in formula {
            let symbol = String(character)
            
            if !addresBuffer.isEmpty {
                if let _ = Number(symbol) {
                    addresBuffer += symbol
                }
                tokens.append(.cell(addresBuffer))
                addresBuffer = ""
                
                continue
            }
            
            if let _ = Number(symbol) {
                numberBuffer += symbol
                continue
            }
            
            if !numberBuffer.isEmpty {
                tokens.append(.number(Number(numberBuffer)!))
                numberBuffer = ""
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
            case "-":
                tokens.append(.subtraction)
            case "/":
                tokens.append(.division)
                
            case "A"..."Z":
                addresBuffer += String(symbol)
                
            case "=", " ":
                break
                
            default:
                throw FormulaError.syntaxError("Unexpected symbol - \(symbol)")
            }
        }
        
        if !numberBuffer.isEmpty {
            tokens.append(.number(Number(numberBuffer)!))
        }
        return tokens
    }
    
    // MARK: - Evaluate
    
    private func eval(expression: TokenIterator) throws -> Number {
        let left = try eval(term:expression)
        
        if let token = expression.lookupNext() {
            switch token {
            case .addition:
                let _ = expression.next()
                let right = try eval(expression: expression)
                return left + right
                
            case .subtraction:
                let _ = expression.next()
                let right = try eval(expression: expression)
                return left - right
                
            default:
                return left
            }
        } else {
            return left
        }
    }
    
    private func eval(term: TokenIterator) throws -> Number {
        let left = try eval(primary: term)
        if let token = term.lookupNext() {
            switch token {
            case .multiplication:
                let _ = term.next()
                let right = try eval(term: term)
                return left * right
                
            case .division:
                let _ = term.next()
                let right =  try eval(term: term)
                return left / right
                
            default:
                return left
            }
            
        } else {
            return left
        }
    }
    
    private func eval(primary: TokenIterator) throws -> Number {
        if let token = primary.next() {
            switch token {
            case .lp:
                let expression = try eval(expression: primary)
                
                switch primary.next() {
                case .some(.rp):
                    return expression
                default:
                    throw FormulaError.syntaxError("Expected )")
                }
                
            case .number(let number):
                return number
                
            case .cell(let address):
                if let number = Number(get(address)) {
                    return number
                } else {
                    throw FormulaError.syntaxError("")
                }
                
            default:
                // TODO: really?
                preconditionFailure("Unexpected token: \(token)")
            }
        } else {
            throw FormulaError.syntaxError("Expected primary")
        }
    }
}
