//
//  GameTests.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import XCTest
@testable import SwiftlyChess

final class GameTests: XCTestCase {

    var sut = ChessGame(playerTeam: .faceYPositive)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRandomMove() throws {
        let initialSetup = sut.board.toString()
        var moved = sut.moveRandom()
        XCTAssertTrue(moved)
        let afterMoveOne = sut.board.toString()
        print(initialSetup)
        print("~~~~~~~~")
        print(afterMoveOne)
        XCTAssertNotEqual(initialSetup, afterMoveOne)
        sut.switchTurn()
        moved = sut.moveRandom()
        XCTAssertTrue(moved)
        let afterMoveTwo = sut.board.toString()
        XCTAssertNotEqual(afterMoveTwo, afterMoveOne)
        print("~~~~~~~~")
        print(afterMoveTwo)
    }
    
    func testRandomMoves() throws {
        var previousSetup = sut.board.toString()
        print(previousSetup)
        print("~~~~~~~~")
        while sut.moveRandom() {
            var nowSetup = sut.board.toString()
            XCTAssertNotEqual(previousSetup, nowSetup)
            sut.switchTurn()
            previousSetup = nowSetup
            print(previousSetup) 
            print("~~~~~~~~")
        }
        let finalSetup = sut.board.toString()
        print(finalSetup)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
