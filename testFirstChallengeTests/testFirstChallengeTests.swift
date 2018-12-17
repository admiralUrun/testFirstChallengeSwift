//
//  testFirstChallengeTests.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/17/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import XCTest
@testable import testFirstChallenge

class testFirstChallengeTests: XCTestCase {

    override func setUp() {
    
    }

    func testThatCellsAreEmptyByDefault() {
        let testSheet = Sheet()
        
        XCTAssertEqual("", testSheet.get("A1"))
        XCTAssertEqual("", testSheet.get("ZX347"))
    }
    
    func testThatTextCellsAreStored() {
        var testSheet = Sheet()
        let theCell = "A21"
        
        testSheet.put(theCell, "A string")
        XCTAssertEqual("A string", testSheet.get(theCell))
  
        testSheet.put(theCell, "A different string")
        XCTAssertEqual("A different string", testSheet.get(theCell))
        
        testSheet.put(theCell, "")
        XCTAssertEqual("", testSheet.get(theCell))
    }
    
    func testThatManyCellsExist() {
        var testSheet = Sheet()
        
        testSheet.put("A1", "First")
        testSheet.put("X27", "Second")
        testSheet.put("ZX901", "Third")
        
        
        XCTAssertEqual("First", testSheet.get("A1"), "A1")
        XCTAssertEqual("Second", testSheet.get("X27"), "X27")
        XCTAssertEqual("Third", testSheet.get("ZX901"), "ZX901")
        
    }
    
    
}
