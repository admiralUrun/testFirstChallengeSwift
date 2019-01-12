//
//  SheetTests.swift
//  testFirstChallengeTests
//
//  Created by Andrew Yakovenko on 12/19/18.
//  Copyright © 2018 Andrew Yakovenko. All rights reserved.
//

import XCTest
@testable import testFirstChallenge

class SheetTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    func testThatCellsAreEmptyByDefault() {
        let testSheet = Sheet()
        
        XCTAssertEqual("", testSheet.get("A1"))
        XCTAssertEqual("", testSheet.get("ZX347"))
    }
    
    func testThatTextCellsAreStored() {
        let testSheet = Sheet()
        let theCell = "A21"
        
        testSheet.put(theCell, "A string")
        XCTAssertEqual("A string", testSheet.get(theCell))
        
        testSheet.put(theCell, "A different string")
        XCTAssertEqual("A different string", testSheet.get(theCell))
        
        testSheet.put(theCell, "")
        XCTAssertEqual("", testSheet.get(theCell))
    }
    
    func testThatManyCellsExist() {
        let testSheet = Sheet()
        
        testSheet.put("A1", "First")
        testSheet.put("X27", "Second")
        testSheet.put("ZX901", "Third")
        
        XCTAssertEqual("First", testSheet.get("A1"), "A1")
        XCTAssertEqual("Second", testSheet.get("X27"), "X27")
        XCTAssertEqual("Third", testSheet.get("ZX901"), "ZX901")
        
        testSheet.put("A1", "Fourth")
        
        XCTAssertEqual("Fourth", testSheet.get("A1"), "A1 after")
        XCTAssertEqual("Second", testSheet.get("X27"), "same")
        XCTAssertEqual("Third", testSheet.get("ZX901"), "same")
    }
    
    func testThatNumericCellsAreIdentifiedAndStored() {
        let testSheet = Sheet()
        let theCell = "A21"
        
        testSheet.put(theCell, "X99")
        XCTAssertEqual("X99", testSheet.get(theCell))
        
        testSheet.put(theCell, "14")
        XCTAssertEqual("14", testSheet.get(theCell))
        
        testSheet.put(theCell, " 99 X")
        XCTAssertEqual(" 99 X", testSheet.get(theCell))
        
        testSheet.put(theCell, " 1234 ")
        XCTAssertEqual("1234", testSheet.get(theCell))
        
        testSheet.put(theCell, " ")
        XCTAssertEqual("", testSheet.get(theCell))
    }
    
    func testThatWeHaveAccessToCellLiteralValuesForEditing() {
        let testSheet = Sheet()
        let theCell = "A21"
        
        testSheet.put(theCell, "Some string")
        XCTAssertEqual("Some string", testSheet.getLiteral(theCell))
        
        testSheet.put(theCell, " 1234 ")
        XCTAssertEqual(" 1234 ", testSheet.getLiteral(theCell))
        
        testSheet.put(theCell, "=7")
        XCTAssertEqual("=7", testSheet.getLiteral(theCell))
    }
    
    func testFormulaSpec() {
        let testSheet = Sheet()
        
        testSheet.put("B1", " =7")
        XCTAssertEqual(" =7", testSheet.get("B1"))
        XCTAssertEqual(" =7", testSheet.getLiteral("B1"))
    }
    
    func testConstantFormula()  {
        let testSheet = Sheet()
        testSheet.put("A1", "=7")
        XCTAssertEqual("=7", testSheet.getLiteral("A1"))
        XCTAssertEqual("7", testSheet.get("A1"))
        
    }
    
    func testParentheses() {
        let testSheet = Sheet()
        testSheet.put("A1", "=(7) ")
        XCTAssertEqual("7", testSheet.get("A1"))
    }
    
    func testDeepParentheses() {
        let testSheet = Sheet()
        testSheet.put("A1", "=((((10))))")
        XCTAssertEqual("10", testSheet.get("A1"))
    }
    
    func testMultiply() {
        let testSheep = Sheet()
        testSheep.put("A1", "=2*3*4")
        XCTAssertEqual("24", testSheep.get("A1"))
    }
    
    func testAdd() {
        let testSheep = Sheet()
        testSheep.put("A1", "=71+2+3")
        XCTAssertEqual("76", testSheep.get("A1"))
    }
    
    func testOperationPrecedence() {
        let testSheep = Sheet()
        testSheep.put("A1", "=7+2*3")
        XCTAssertEqual("13", testSheep.get("A1"))
    }
    
//    func testFullExpression() {
//        let testSheep = Sheet()
//        testSheep.put("A1", "=7*(2+3)*((((2+1))))")
//        XCTAssertEqual("105", testSheep.get("A1"))
//    }

}
