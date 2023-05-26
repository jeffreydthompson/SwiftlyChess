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
        var moved = try sut.moveRandom()
        XCTAssertTrue(moved)
        let afterMoveOne = sut.board.toString()
        print(initialSetup)
        print("~~~~~~~~")
        print(afterMoveOne)
        XCTAssertNotEqual(initialSetup, afterMoveOne)
        sut.switchTurn()
        moved = try sut.moveRandom()
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
        var steps = 0
        while try sut.moveRandom() {
            var nowSetup = sut.board.toString()
            XCTAssertNotEqual(previousSetup, nowSetup)
            sut.switchTurn()
            previousSetup = nowSetup
            print(previousSetup)
            print("~~~~~~~~")
            steps += 1
            if steps > 2000 { break }
        }
        let finalSetup = sut.board.toString()
        print(finalSetup)
    }
    
    func testHighScoreAttack() throws {
        sut.board = try .board(from: attackSetup)
        
        guard let positions = sut.findHighestValueAttack(for: .faceYNegative) else {
            
            XCTFail("No positions found")
            return
        }
        
        XCTAssertEqual(positions.from, Position(x: 3, y: 5))
        XCTAssertEqual(positions.to, Position(x: 3, y: 2))
    
    }
    
    func testHighScoreAttackTwo() throws {
        sut.board = try .board(from: attackSetup)
        
        guard let positions = sut.findHighestValueAttack(for: .faceYPositive) else {
            
            XCTFail("No positions found")
            return
        }
        
        XCTAssertEqual(positions.to, Position(x: 3, y: 5))
        XCTAssertEqual(positions.from, Position(x: 3, y: 2))
    }
    
    func testShallowAttackCalc() throws {
        sut.board = try .board(from: attackSetup)
        
        guard let positions = sut.shallowSearchBestAttack(for: .faceYNegative) else {
            
            XCTFail("No positions found")
            return
        }
        
        XCTAssertEqual(positions.from, Position(x: 3, y: 5))
        XCTAssertEqual(positions.to, Position(x: 3, y: 2))
    }
    
    func testShallowAttackCalcTwo() throws {
        sut.board = try .board(from: attackSetup)
        
        let positions = sut.shallowSearchBestAttack(for: .faceYPositive)
        XCTAssertNil(positions)
        
    }
    
    func testPawnAttack() throws {
        sut.board = try .board(from: pawnAttackTest)
        
        guard let positions = sut.findHighestValueAttack(for: .faceYNegative),
              let score = positions.score
        else {
            XCTFail("should be positions")
            return
        }
        
        XCTAssertEqual(score, 9)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
