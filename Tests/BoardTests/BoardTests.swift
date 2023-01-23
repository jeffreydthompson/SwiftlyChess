//
//  BoardTests.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import XCTest
@testable import SwiftlyChess

final class BoardTests: XCTestCase {

    var sut = Board()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheck() throws {
        sut = try .board(from: checkSetup)
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYNegative))
    }
    
    func testCheckmate() throws {
        sut = try .board(from: checkMateSetup)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(sut.isCheckmate(for: .faceYNegative))
        var calcOne = CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(calcOne.canEscapeCheck())
        XCTAssertFalse(calcOne.canNeutralizeAttackers())
        XCTAssertFalse(calcOne.teamCanBlock())
        
        sut = try .board(from: checkMateSetupTwo)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(sut.isCheckmate(for: .faceYNegative))
        var calcTwo = CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(calcTwo.canEscapeCheck())
        XCTAssertFalse(calcTwo.canNeutralizeAttackers())
        XCTAssertFalse(calcTwo.teamCanBlock())
        
        sut = try .board(from: checkMateSetupThree)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(sut.isCheckmate(for: .faceYNegative))
        var calcThree = CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(calcThree.canEscapeCheck())
        XCTAssertFalse(calcThree.canNeutralizeAttackers())
        XCTAssertFalse(calcThree.teamCanBlock())
    }
    
    func testCheckmateMoveOutOfWay() throws {
        sut = try .board(from: checkMateSetupFour)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(sut.isCheckmate(for: .faceYNegative))
    }
    
    func testCheckmateTeammateBlocks() throws {
        sut = try .board(from: checkMateSetupFive)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
        XCTAssertFalse(sut.isCheckmate(for: .faceYNegative))
        var calc = CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(calc.canEscapeCheck())
        XCTAssertFalse(calc.canNeutralizeAttackers())
        XCTAssertTrue(calc.teamCanBlock())
    }
}
