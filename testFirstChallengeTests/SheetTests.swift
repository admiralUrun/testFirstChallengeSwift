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
    
    var sheet: Sheet!
    
    override func setUp() {
        sheet = Sheet()
    }
    
    // MARK: - Part 1
    
    func testThatCellsAreEmptyByDefault() {
        XCTAssertEqual("", sheet.get("A1"))
        XCTAssertEqual("", sheet.get("ZX347"))
    }
    
    func testThatTextCellsAreStored() {
        let theCell = "A21"
        
        sheet.put(theCell, "A string")
        XCTAssertEqual("A string", sheet.get(theCell))
        
        sheet.put(theCell, "A different string")
        XCTAssertEqual("A different string", sheet.get(theCell))
        
        sheet.put(theCell, "")
        XCTAssertEqual("", sheet.get(theCell))
    }
    
    func testThatManyCellsExist() {
        sheet.put("A1", "First")
        sheet.put("X27", "Second")
        sheet.put("ZX901", "Third")
        
        XCTAssertEqual("First", sheet.get("A1"), "A1")
        XCTAssertEqual("Second", sheet.get("X27"), "X27")
        XCTAssertEqual("Third", sheet.get("ZX901"), "ZX901")
        
        sheet.put("A1", "Fourth")
        
        XCTAssertEqual("Fourth", sheet.get("A1"), "A1 after")
        XCTAssertEqual("Second", sheet.get("X27"), "same")
        XCTAssertEqual("Third", sheet.get("ZX901"), "same")
    }
    
    func testThatNumericCellsAreIdentifiedAndStored() {
        let theCell = "A21"
        
        sheet.put(theCell, "X99")
        XCTAssertEqual("X99", sheet.get(theCell))
        
        sheet.put(theCell, "14")
        XCTAssertEqual("14", sheet.get(theCell))
        
        sheet.put(theCell, " 99 X")
        XCTAssertEqual(" 99 X", sheet.get(theCell))
        
        sheet.put(theCell, " 1234 ")
        XCTAssertEqual("1234", sheet.get(theCell))
        
        sheet.put(theCell, " ")
        XCTAssertEqual("", sheet.get(theCell))
    }
    
    func testThatWeHaveAccessToCellLiteralValuesForEditing() {
        let theCell = "A21"
        
        sheet.put(theCell, "Some string")
        XCTAssertEqual("Some string", sheet.getLiteral(theCell))
        
        sheet.put(theCell, " 1234 ")
        XCTAssertEqual(" 1234 ", sheet.getLiteral(theCell))
        
        sheet.put(theCell, "=7")
        XCTAssertEqual("=7", sheet.getLiteral(theCell))
    }
    // MARK: - Part 2
    
    func testFormulaSpec() {
        sheet.put("B1", " =7")
        XCTAssertEqual(" =7", sheet.get("B1"))
        XCTAssertEqual(" =7", sheet.getLiteral("B1"))
    }
    
    func testConstantFormula()  {
        sheet.put("A1", "=7")
        XCTAssertEqual("=7", sheet.getLiteral("A1"))
        XCTAssertEqual("7", sheet.get("A1"))
        
    }
    
    func testParentheses() {
        sheet.put("A1", "=(7) ")
        XCTAssertEqual("7", sheet.get("A1"))
    }
    
    func testDeepParentheses() {
        sheet.put("A1", "=((((10))))")
        XCTAssertEqual("10", sheet.get("A1"))
    }
    
    func testMultiply() {
        sheet.put("A1", "=2*3*4")
        XCTAssertEqual("24", sheet.get("A1"))
    }
    
    func testAdd() {
        sheet.put("A1", "=71+2+3")
        XCTAssertEqual("76", sheet.get("A1"))
    }
    
    func testOperationPrecedence() {
        sheet.put("A1", "=7+2*3")
        XCTAssertEqual("13", sheet.get("A1"))
    }
    
    func testFullExpression() {
        sheet.put("A1", "=7*(2+3)*((((2+1))))")
        XCTAssertEqual("105", sheet.get("A1"))
    }

    func testSimpleFormulaError() {
        sheet.put("A1", "=7*")
        XCTAssertEqual("#Error", sheet.get("A1"))
    }
    
    func testParenthesisError() {
        sheet.put("A1", "=(((((7))")
        XCTAssertEqual("#Error", sheet.get("A1"))
    }
    
    // MARK: - Part 3
    
    func testThatCellReferenceWorks() {
        sheet.put("A1", "8")
        sheet.put("A2", "=A1")
        XCTAssertEqual("8", sheet.get("A2"))
    }
    
    func testThatCellChangesPropagate() {
        sheet.put("A1", "8")
        sheet.put("A2", "=A1")
        XCTAssertEqual("8", sheet.get("A2"))
        
        sheet.put("A1", "9")
        XCTAssertEqual("9", sheet.get("A2"))
    }
    
    func testsubtraction() {
        sheet.put("B1", "5")
        sheet.put("A1", "=(B1-B1)")
        XCTAssertEqual("0", sheet.get("A1"))
    }
    
    func testThatFormulasKnowCellsAndRecalculate() {
        sheet.put("A1", "8")
        sheet.put("A2", "3")
        sheet.put("B1", "=A1*(A1-A2)+A2/3")
        XCTAssertEqual("41", sheet.get("B1"))

        sheet.put("A2", "6")
        XCTAssertEqual("18", sheet.get("B1"))
    }
    
    
    func testThatDeepPropagationWorks()  {
        sheet.put("A1", "8")
        sheet.put("A2", "=A1")
        sheet.put("A3", "=A2")
        sheet.put("A4", "=A3")
        XCTAssertEqual("8", sheet.get("A4"))
        
        sheet.put("A2", "6")
        XCTAssertEqual("6", sheet.get("A4"))
    }
    
    func testThatFormulaWorksWithManyCells()  {
        sheet.put("A1", "10")
        sheet.put("A2", "=A1+B1")
        sheet.put("A3", "=A1+B2")
        sheet.put("A4", "=A3")
        sheet.put("B1", "7")
        sheet.put("B2", "=A2")
        sheet.put("B3", "=A3-A2")
        sheet.put("B4", "=A4+B3")
        
        XCTAssertEqual("34", sheet.get("A4"))
        XCTAssertEqual("51", sheet.get("B4"))

    }
    

}
