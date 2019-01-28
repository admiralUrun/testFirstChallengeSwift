//
//  TokensIterator.swift
//  testFirstChallenge
//
//  Created by Andrew Yakovenko on 1/27/19.
//  Copyright © 2019 Andrew Yakovenko. All rights reserved.
//

import Foundation

class TokenIterator: IteratorProtocol {
    typealias Element = Token
    
    private let tokens: Array<Token>
    private var index = 0
    
    init(_ tokens: Array<Token>) {
        self.tokens = tokens
    }
    
    func lookupNext() -> Element? {
        if index < tokens.count {
            return tokens[index]
        } else {
            return .none
        }
    }
    
     func next() -> Element? {
        if index < tokens.count {
            let token = tokens[index]
            index += 1
            return token
        } else {
            return .none
        }
    }
    
}
