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
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYNegative))
    }
    
    func testCheckmate() throws {
        sut = try .board(from: checkMateSetup)
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(try sut.isCheckmate(for: .faceYNegative))
        var calcOne = try CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(try calcOne.canEscapeCheck())
        XCTAssertFalse(try calcOne.canNeutralizeAttackers())
        XCTAssertFalse(try calcOne.teamCanBlock())
        
        sut = try .board(from: checkMateSetupTwo)
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(try sut.isCheckmate(for: .faceYNegative))
        var calcTwo = try CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(try calcTwo.canEscapeCheck())
        XCTAssertFalse(try calcTwo.canNeutralizeAttackers())
        XCTAssertFalse(try calcTwo.teamCanBlock())
        
        sut = try .board(from: checkMateSetupThree)
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(try sut.isCheckmate(for: .faceYNegative))
        var calcThree = try CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(try calcThree.canEscapeCheck())
        XCTAssertFalse(try calcThree.canNeutralizeAttackers())
        XCTAssertFalse(try calcThree.teamCanBlock())
    }
    
    func testCheckmateMoveOutOfWay() throws {
        sut = try .board(from: checkMateSetupFour)
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertTrue(try sut.isCheckmate(for: .faceYNegative))
    }
    
    func testCheckmateTeammateBlocks() throws {
        sut = try .board(from: checkMateSetupFive)
        XCTAssertTrue(try sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(try sut.isCheck(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYPositive))
        XCTAssertFalse(try sut.isCheckmate(for: .faceYNegative))
        var calc = try CheckmateCalculator(team: .faceYNegative, board: sut)
        XCTAssertFalse(try calc.canEscapeCheck())
        XCTAssertFalse(try calc.canNeutralizeAttackers())
        XCTAssertTrue(try calc.teamCanBlock())
    }
}
