//
//  MovementTests.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import XCTest
@testable import SwiftlyChess

final class MovementTests: XCTestCase {

    var sut = Board()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetup() throws {
        sut = Board.standardSetup()
        XCTAssertEqual(sut.pieces.count, 32)
    }
    
    func testPieceStringLookup() throws {
        let pawnString = "♟"
        let pawn = Board.piece(from: pawnString, position: Position(x: 0, y: 0))
        XCTAssertNotNil(pawn)
        
        let charAry = standardSetup.multiLineCharArray
        
        for yPos in (0..<8) {
            for xPos in (0..<8) {
                let str = charAry[7-yPos][xPos]
                let position = Position(x: xPos, y: yPos)
                if let piece = Board.piece(from: str, position: position) {
                    try sut.insert(piece: piece)
                }
            }
        }
        
        XCTAssertEqual(sut, Board.standardSetup())
        try sut.delete(at: Position(x: 0, y: 0))
        XCTAssertNotEqual(sut, Board.standardSetup())
    }
    
    func testPawnMovement() throws {
        sut = Board.standardSetup()
        let pawn = sut.piece(at: Position(x: 1, y: 1))!
        var pPositions = sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 2)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 2)
        }))
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 3)
        }))
        
        sut = try Board.board(from: testPawnOne)
        pPositions = sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 2)
        }))
        
        sut = try Board.board(from: testPawnTwo)
        pPositions = sut.permittedPositions(for: pawn)
        
        XCTAssertEqual(pPositions.count, 0)
        
        sut = try Board.board(from: testPawnThree)
        pPositions = sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 2, y: 2)
        }))
        
        let randoPawn = sut.piece(at: Position(x: 4, y: 3))!
        pPositions = sut.permittedPositions(for: randoPawn)
        
        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 4, y: 4)
        }))
        
        let randoPawnTwo = sut.piece(at: Position(x: 6, y: 5))!
        
        pPositions = sut.permittedPositions(for: randoPawnTwo)
        
        XCTAssertEqual(pPositions.count, 2)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 6, y: 4)
        }))
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 7, y: 4)
        }))
    }

    func testKnightMovement() throws {
        sut = try Board.board(from: testKnightOne)

        let bKnightL = sut.piece(at: Position(x: 1, y: 7))!
        let bKnightR = sut.piece(at: Position(x: 6, y: 7))!
        let wKnightL = sut.piece(at: Position(x: 1, y: 0))!
        let wKnightR = sut.piece(at: Position(x: 6, y: 0))!
        let randoKnight = sut.piece(at: Position(x: 3, y: 3))!
        
        var positions = sut.permittedPositions(for: bKnightL)
        XCTAssertEqual(positions.count, 1)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 5)
        }))
        
        positions = sut.permittedPositions(for: bKnightR)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 5)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 7, y: 5)
        }))
        
        positions = sut.permittedPositions(for: wKnightL)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 2)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 2, y: 2)
        }))
        
        positions = sut.permittedPositions(for: wKnightR)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 2)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 7, y: 2)
        }))
        
        positions = sut.permittedPositions(for: randoKnight)
        XCTAssertEqual(positions.count, 5)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 2, y: 5)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 1, y: 4)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 1, y: 2)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 2)
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 4)
        }))
    }
    
    func testRookMovement() throws {
        sut = try Board.board(from: testRook)
        let bRookL = sut.piece(at: Position(x: 0, y: 7))!
        let bRookR = sut.piece(at: Position(x: 7, y: 7))!
        let wRookL = sut.piece(at: Position(x: 0, y: 0))!
        let wRookR = sut.piece(at: Position(x: 0, y: 7))!
        
        var positions = sut.permittedPositions(for: bRookL)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: bRookR)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: wRookL)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: wRookR)
        XCTAssertEqual(positions.count, 0)
        
        let bRook = sut.piece(at: Position(x: 0, y: 5))!
        let wRook = sut.piece(at: Position(x: 4, y: 4))!
        
        positions = sut.permittedPositions(for: bRook)
        XCTAssertEqual(positions.count, 9)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 1)
        }))
        positions = sut.permittedPositions(for: wRook)
        XCTAssertEqual(positions.count, 11)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 4, y: 6)
        }))
    }
    
    func testBishopMovement() throws {
        sut = try Board.board(from: testBishop)
        let bBishopL = sut.piece(at: Position(x: 2, y: 7))!
        let bBishopR = sut.piece(at: Position(x: 5, y: 7))!
        let wBishopL = sut.piece(at: Position(x: 2, y: 0))!
        let wBishopR = sut.piece(at: Position(x: 5, y: 0))!
        
        var positions = sut.permittedPositions(for: bBishopL)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: bBishopR)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: wBishopL)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: wBishopR)
        XCTAssertEqual(positions.count, 0)
        
        let bBishop = sut.piece(at: Position(x: 5, y: 4))!
        positions = sut.permittedPositions(for: bBishop)
        XCTAssertEqual(positions.count, 6)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 6, y: 3)
        }))
        
        let wBishop = sut.piece(at: Position(x: 2, y: 3))!
        positions = sut.permittedPositions(for: wBishop)
        XCTAssertEqual(positions.count, 4)
    }
    
    func testQueenMovement() throws {
        sut = try Board.board(from: testQueen)
        let wQueenStuck = sut.piece(at: Position(x: 3, y: 0))!
        let bQueenStuck = sut.piece(at: Position(x: 3, y: 7))!

        var positions = sut.permittedPositions(for: wQueenStuck)
        XCTAssertEqual(positions.count, 0)
        positions = sut.permittedPositions(for: bQueenStuck)
        XCTAssertEqual(positions.count, 0)
        
        let wQueen = sut.piece(at: Position(x: 3, y: 3))!
        let bQueen = sut.piece(at: Position(x: 5, y: 5))!
        
        positions = sut.permittedPositions(for: wQueen)
        print(positions)
        XCTAssertEqual(positions.count, 13)
        positions = sut.permittedPositions(for: bQueen)
        XCTAssertEqual(positions.count, 9)
        
    }
    
    func testKingMovement() throws {
        sut = try Board.board(from: testKing)
        var sutKing = sut.piece(at: Position(x: 4, y: 0))!
        var positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 0)
        
        sutKing = sut.piece(at: Position(x: 4, y: 7))!
        positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 0)
        
        // white top left corner
        sutKing = sut.piece(at: Position(x: 0, y: 7))!
        positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 3)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 6)
        }))
        
        // black center upper
        sutKing = sut.piece(at: Position(x: 2, y: 5))!
        positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 5)
        
        // black in front of white pawns
        sutKing = sut.piece(at: Position(x: 5, y: 2))!
        positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 7)
        
        // black lower right corner
        sutKing = sut.piece(at: Position(x: 6, y: 0))!
        positions = sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 5)
    }



}
